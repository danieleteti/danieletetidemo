package it.bittime.delphirestdemo;

import it.bittime.delphirestdemo.bo.Customer;

import java.io.IOException;
import java.net.URI;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import org.apache.http.client.ClientProtocolException;
import org.json.JSONException;

import android.app.Activity;
import android.content.Intent;
import android.location.*;
import android.net.Uri;
import android.os.*;
import android.util.Log;
import android.view.*;
import android.view.View.OnClickListener;
import android.widget.*;

public class EditCustomerActivity extends Activity implements OnClickListener, LocationListener {

	private Customer customer = null;
	private Button btn_save, btn_cancel, btn_get_gps, btn_show_map = null;
	private EditText txt_customer_name, txt_address = null;
	private TextView lbl_latitude, lbl_longitude = null;

	private LocationManager locationManager; 
	private Location lastLocation;
	private Criteria criteria;
	private String bestProvider;

	@Override
	public void onCreate(Bundle bundle) {
		super.onCreate(bundle);
		setContentView(R.layout.edit_customer);
		bind_views();
		bind_events();
		
		Intent i = getIntent();
		int id_customer = i.getIntExtra("id_customer", -1);
		String s;
		if (id_customer == -1)
		{
			s = "New Customer";
			customer = new Customer();
			setTitle(s);
			refresh_data();							
		}
		else
		{
			s = "Edit Customer";			
			try {
				customer = load_customer_by_id(id_customer);
				setTitle(s);
				refresh_data();				
			} catch (Exception e) {
				e.printStackTrace();				
				Toast.makeText(this, e.getMessage(), Toast.LENGTH_LONG).show();
				finish();
				return;
			}						
		}
		
		//LOCATION SERVICES
		locationManager = (LocationManager) getSystemService(LOCATION_SERVICE);
		Criteria criteria = new Criteria();
		criteria.setCostAllowed(false);
		bestProvider = locationManager.getBestProvider(criteria, true);
		lastLocation = locationManager.getLastKnownLocation(bestProvider);
	}

	private void bind_views() {
		btn_save = (Button) findViewById(R.id.btn_save_customer);
		btn_cancel = (Button) findViewById(R.id.btn_cancel);
		btn_get_gps = (Button) findViewById(R.id.btn_get_gps);
		btn_show_map = (Button) findViewById(R.id.btn_show_map);
		txt_customer_name = (EditText) findViewById(R.id.txt_customer_name);
		txt_address = (EditText) findViewById(R.id.txt_address);
		lbl_latitude = (TextView) findViewById(R.id.txt_latitude);
		lbl_longitude = (TextView) findViewById(R.id.txt_longitude);
	}

	private void bind_events() {
		btn_get_gps.setOnClickListener(this);
		btn_show_map.setOnClickListener(this);
		btn_save.setOnClickListener(this);
		btn_cancel.setOnClickListener(this);
		findViewById(R.id.btn_show_orders).setOnClickListener(this);
		findViewById(R.id.btn_new_order).setOnClickListener(this);
	}

	@Override
	public void onClick(View view) {
		switch (view.getId()) {
		case R.id.btn_get_gps: {
			if (lastLocation != null) {
				customer.setLat(lastLocation.getLatitude());
				customer.setLon(lastLocation.getLongitude());
			}
			// lastLocation = get_position();
			// lbl_latitude.setText(String.valueOf(lastLocation.getLatitude()));
			// lbl_longitude.setText(String.valueOf(lastLocation.getLongitude()));
			break;
		}

		case R.id.btn_show_map: {
			if (lastLocation == null) {
				Toast.makeText(this, "No GPS information has been acquired", Toast.LENGTH_SHORT).show();
				return;
			}
			Intent intent = new Intent(Intent.ACTION_VIEW);
			intent.setData(Uri.parse("geo:" + String.valueOf(lastLocation.getLatitude()) + ","
					+ String.valueOf(lastLocation.getLongitude()) + "?z=23"));
			startActivity(intent);
			break;
		}
		case R.id.btn_save_customer: {
			RESTProxy p = new RESTProxy(this);
			customer.setDescription(txt_customer_name.getText().toString());
			customer.setAddress(txt_address.getText().toString());
			try {
				if (customer.getId() == 0)
					p.createCustomer(customer);
				else
					p.updateCustomer(customer);
				Toast.makeText(this, "Customer saved", Toast.LENGTH_SHORT).show();
				finish();
			} catch (Exception e) {
				e.printStackTrace();
				Toast.makeText(this, e.getMessage(), Toast.LENGTH_LONG).show();
			}
			break;
		}
		case R.id.btn_cancel: {
			finish();
			break;
		}
		default: {
			Toast.makeText(this, "Not Implemented", Toast.LENGTH_SHORT).show();
		}
		}
	}

	private Location get_position() {
		/*
		LocationManager locationManager = (LocationManager) getSystemService(LOCATION_SERVICE);
		Criteria criteria = new Criteria();
		criteria.setCostAllowed(false);
		bestProvider = locationManager.getBestProvider(criteria, true);
		*/
		// Or use LocationManager.GPS_PROVIDER
		try {
			locationManager.requestLocationUpdates(LocationManager.NETWORK_PROVIDER, 20000, 1000, this);
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		Location lastKnownLocation = locationManager.getLastKnownLocation(LocationManager.NETWORK_PROVIDER);
		//Location lastKnownLocation = locationManager.getLastKnownLocation(LocationManager.GPS_PROVIDER);
		return lastKnownLocation;
	}

	private Customer load_customer_by_id(int id) throws Exception {
		if (id == -1)
			throw new Exception("Invalid Customer ID");
		RESTProxy p = new RESTProxy(this);
		return p.getCustomer(String.valueOf(id));
	}

	private void refresh_data() {
		txt_customer_name.setText(customer.getDescription());
		txt_address.setText(customer.getAddress());
	}

	@Override
	public void onLocationChanged(Location location) {
		Log.d("GPS_EVENTS", "onLocationChanged");
		// getSystemService(SERVICE_)
		if (location != null) {
			lastLocation = location;
			//customer.setLat(lastLocation.getLatitude());
			//customer.setLon(lastLocation.getLongitude());
		}
	}

	@Override
	public void onProviderDisabled(String arg0) {
		Log.d("GPS_EVENTS", "onProviderDisabled");
	}

	@Override
	public void onProviderEnabled(String arg0) {
		Log.d("GPS_EVENTS", "onProviderEnabled");
	}

	@Override
	public void onStatusChanged(String arg0, int arg1, Bundle arg2) {
		Log.d("GPS_EVENTS", "onStatusChanged");
	}
	
	
	@Override
	protected void onResume() {
		// TODO Auto-generated method stub
		super.onResume();
		locationManager.requestLocationUpdates(bestProvider, 20000, 10, this);		
	}
	
	/** Stop the updates when Activity is paused */
	@Override
	protected void onPause() {
		super.onPause();
		locationManager.removeUpdates(this);
	}
	
}
