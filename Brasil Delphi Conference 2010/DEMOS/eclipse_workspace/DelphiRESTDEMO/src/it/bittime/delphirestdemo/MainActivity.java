package it.bittime.delphirestdemo;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;

public class MainActivity extends Activity implements OnClickListener {
	private Button btn_new_customer = null;
	private Button btn_new_order = null;
	private Button btn_search_customer = null;
	private Button btn_settings = null;

	/** Called when the activity is first created. */
	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.main);
		btn_new_customer = (Button) findViewById(R.id.btn_new_customer);
		btn_new_order = (Button) findViewById(R.id.btn_new_order);
		btn_search_customer = (Button) findViewById(R.id.btn_search_customer);
		btn_settings = (Button) findViewById(R.id.btn_settings);
		
		btn_new_customer.setOnClickListener(this);
		btn_new_order.setOnClickListener(this);
		btn_search_customer.setOnClickListener(this);
		btn_settings.setOnClickListener(this);
	}

	@Override
	public void onClick(View view) {
		switch (view.getId()) {
		case R.id.btn_new_customer: {
			Intent intent = new Intent(this, EditCustomerActivity.class);
			startActivity(intent);
			break;
		}
		case R.id.btn_new_order: {
			Intent intent = new Intent(this, EditOrderActivity.class);
			startActivity(intent);			
			break;
		}
		case R.id.btn_search_customer: {
			Intent intent = new Intent(this, CustomersListActivity.class);
			startActivity(intent);			
			break;
		}
		case R.id.btn_settings: {
			Intent intent = new Intent(this, SettingsActivity.class);
			startActivity(intent);			
			break;
		}
		}
	}
}