package it.bittime.delphirestdemo;

import it.bittime.delphirestdemo.bo.Customer;
import it.bittime.delphirestdemo.bo.Order;
import it.bittime.delphirestdemo.bo.OrderItem;

import java.util.*;

import org.json.JSONException;

import android.app.*;
import android.app.DatePickerDialog.OnDateSetListener;
import android.content.Intent;
import android.os.*;
import android.util.Log;
import android.view.*;
import android.view.View.OnClickListener;
import android.widget.*;

public class EditOrderActivity extends Activity implements OnClickListener, OnDateSetListener {
	static final int SHIP_BEFORE_DATE_DIALOG_ID = 10;
	static final int ORDER_CREATION_DATE_DIALOG_ID = 20;
	private Order order = null;
	private Button btn_save, btn_cancel = null;
	private Button btn_order_creation_date, btn_ship_before = null;
	private int mYear, mShipBeforeYear;
	private int mMonth, mShipBeforeMonth;
	private int mDay, mShipBeforeDay;
	private int which_date_dialog;
	private Spinner spn_customer_name;
	final private List<String> customers = new ArrayList<String>();
	private Button btn_new_order_item;
	private ListView lv_order_items;
	private List<String> order_items_strings = new ArrayList<String>();
	private ArrayAdapter<String> order_items_adapter;

	@Override
	public void onCreate(Bundle bundle) {
		super.onCreate(bundle);

		setContentView(R.layout.edit_order);
		bind_views();
		bind_events();
		String s;
		// //////////////
		if (bundle != null) {
			order = (Order) bundle.getSerializable("order");
			mYear = bundle.getInt("mYear");
			mMonth = bundle.getInt("mMonth");
			mDay = bundle.getInt("mDay");
			mShipBeforeYear = bundle.getInt("mShipBeforeYear");
			mShipBeforeMonth = bundle.getInt("mShipBeforeMonth");
			mShipBeforeDay = bundle.getInt("mShipBeforeDay");			
			s = "Edit Order";
		} else {
			Intent i = getIntent();
			int id_order = i.getIntExtra("id", -1);
			if (id_order == -1) {
				s = "New Order";
				order = new Order();
				final Calendar c = Calendar.getInstance();
				mYear = c.get(Calendar.YEAR);
				mMonth = c.get(Calendar.MONTH);
				mDay = c.get(Calendar.DAY_OF_MONTH);
				c.add(Calendar.DATE, 1);
				mShipBeforeYear = c.get(Calendar.YEAR);
				mShipBeforeMonth = c.get(Calendar.MONTH);
				mShipBeforeDay = c.get(Calendar.DAY_OF_MONTH);
			} else {
				s = "Edit Order";
				order = load_order_by_id(id_order);
			}
		}
		setTitle(s);
		List<String> c = load_customers();
		customers.clear();
		customers.addAll(c);
		ArrayAdapter<String> adapter = new ArrayAdapter<String>(this, android.R.layout.simple_spinner_item, customers);
		adapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
		spn_customer_name.setAdapter(adapter);
		// spn_customer_name.setSelection(position)
		// if id_Order = -1 then we are going to create a new Order
		refresh_data();
	}

	private void bind_views() {
		btn_save = (Button) findViewById(R.id.btn_save_order);
		btn_cancel = (Button) findViewById(R.id.btn_cancel);
		btn_new_order_item = (Button) findViewById(R.id.btn_new_order_item);
		btn_order_creation_date = (Button) findViewById(R.id.btn_order_creation_date);
		btn_ship_before = (Button) findViewById(R.id.btn_ship_before);
		lv_order_items = (ListView) findViewById(R.id.lv_order_items);
		order_items_adapter = new ArrayAdapter<String>(this, android.R.layout.simple_list_item_1, order_items_strings);
		lv_order_items.setAdapter(order_items_adapter);
		spn_customer_name = (Spinner) findViewById(R.id.spn_customer_name);
		spn_customer_name.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
			@Override
			public void onItemSelected(AdapterView<?> arg0, View arg1, int arg2, long arg3) {
				Toast.makeText(EditOrderActivity.this, customers.get(arg2), Toast.LENGTH_SHORT).show();
			}

			@Override
			public void onNothingSelected(AdapterView<?> arg0) {
				// do nothing
			}
		});
	}

	private void bind_events() {
		btn_ship_before.setOnClickListener(this);
		btn_order_creation_date.setOnClickListener(this);
		btn_save.setOnClickListener(this);
		btn_cancel.setOnClickListener(this);
		btn_new_order_item.setOnClickListener(this);
	}

	@Override
	public void onClick(View view) {
		switch (view.getId()) {
		case R.id.btn_save_order: {
			RESTProxy p = new RESTProxy(this);
			int cust_position = spn_customer_name.getSelectedItemPosition();
			String s = customers.get(cust_position);
			int i = Integer.parseInt(s.substring(1, s.indexOf(")")));
			order.setId_customer(i);
			order.setCreated_at(btn_order_creation_date.getText().toString());
			order.setShip_before(btn_ship_before.getText().toString());

			try {
				if (order.getId() == 0)
					p.createOrder(order);
				// else
				// p.updateOrder(order);
				Toast.makeText(this, "Order saved", Toast.LENGTH_SHORT).show();
			} catch (Exception e) {
				e.printStackTrace();
				Toast.makeText(this, e.getMessage(), Toast.LENGTH_LONG).show();
			}
			break;
		}
		case R.id.btn_ship_before: {
			showDialog(SHIP_BEFORE_DATE_DIALOG_ID);
			break;
		}
		case R.id.btn_order_creation_date: {
			showDialog(ORDER_CREATION_DATE_DIALOG_ID);
			break;
		}

		case R.id.btn_new_order_item: {
			startActivityForResult(new Intent(this, EditOrderItemActivity.class),
					EditOrderItemActivity.ORDER_ITEM_REQUEST_CODE);
			break;
		}

		case R.id.btn_cancel: {
			finish();
			break;
		}
		}
	}

	@Override
	protected Dialog onCreateDialog(int id) {
		which_date_dialog = id;
		switch (id) {
		case SHIP_BEFORE_DATE_DIALOG_ID: {
			return new DatePickerDialog(this, this, mYear, mMonth, mDay);
		}

		case ORDER_CREATION_DATE_DIALOG_ID: {
			return new DatePickerDialog(this, this, mShipBeforeYear, mShipBeforeMonth, mShipBeforeDay);
		}
		}
		return null;
	}

	private List<String> load_customers() {
		RESTProxy p = new RESTProxy(this);
		return p.customersSearchAsStrings("");
	}

	private Order load_order_by_id(int id) {
		if (id == -1)
			return null;
		RESTProxy p = new RESTProxy(this);
		return p.getOrder(String.valueOf(id));
	}

	private void refresh_data() {
		btn_order_creation_date.setText(order.getCreated_at());
		btn_ship_before.setText(order.getShip_before());
		order_items_strings.clear();
		DelphiRESTDEMOApplication app = ((DelphiRESTDEMOApplication)getApplication());
		for (OrderItem o : order.Items) {
			order_items_strings.add(
						app.map_products.get(o.getId_product()).getDescription() + 
						" (" + 
						String.valueOf(o.getQuantity()) + ")");
		}
		order_items_adapter.notifyDataSetChanged();
		updateDisplay();
	}

	// updates the date in the TextView
	private void updateDisplay() {
		btn_order_creation_date.setText(new StringBuilder()
		// Month is 0 based so add 1
				.append(mDay).append("-").append(mMonth + 1).append("-").append(mYear));
		btn_ship_before.setText(new StringBuilder()
		// Month is 0 based so add 1
				.append(mShipBeforeDay).append("-").append(mShipBeforeMonth + 1).append("-").append(mShipBeforeYear));
	}

	@Override
	public void onDateSet(DatePicker view, int year, int monthOfYear, int dayOfMonth) {
		if (which_date_dialog == ORDER_CREATION_DATE_DIALOG_ID) {
			mYear = year;
			mMonth = monthOfYear;
			mDay = dayOfMonth;
		} else {
			mShipBeforeYear = year;
			mShipBeforeMonth = monthOfYear;
			mShipBeforeDay = dayOfMonth;
		}
		updateDisplay();
	}

	// Listen for results.
	protected void onActivityResult(int requestCode, int resultCode, Intent data) {
		// See which child activity is calling us back.
		switch (requestCode) {
		case EditOrderItemActivity.ORDER_ITEM_REQUEST_CODE:
			if (resultCode == RESULT_CANCELED) {
				Toast.makeText(this, "Errors happend", Toast.LENGTH_LONG).show();
			} else {
				OrderItem i = new OrderItem();
				try {
					i.loadFromJSONString(data.getStringExtra("order_item"));
					i.setId_order(order.getId());
					order.Items.add(i);
				} catch (JSONException e) {
					e.printStackTrace();
				}
				refresh_data();
			}
		default:
			break;
		}
	}

	@Override
	protected void onSaveInstanceState(Bundle outState) {
		super.onSaveInstanceState(outState);
		Log.d("DEMO", "onSaveInstanceState");
		outState.putSerializable("order", order);
		outState.putInt("mYear", mYear);
		outState.putInt("mMonth", mMonth);
		outState.putInt("mDay", mDay);		
		outState.putInt("mShipBeforeYear", mShipBeforeYear);
		outState.putInt("mShipBeforeMonth", mShipBeforeMonth);
		outState.putInt("mShipBeforeDay", mShipBeforeDay);
	}

	@Override
	protected void onPause() {
		super.onPause();
		Log.d("DEMO", "OnPause");
	}

	@Override
	protected void onStop() {
		super.onStop();
		Log.d("DEMO", "OnStop");
	}
}
