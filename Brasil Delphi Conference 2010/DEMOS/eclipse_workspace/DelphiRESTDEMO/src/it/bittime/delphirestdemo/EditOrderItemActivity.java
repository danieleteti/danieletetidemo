package it.bittime.delphirestdemo;

import java.util.ArrayList;
import java.util.List;

import org.json.JSONException;

import it.bittime.delphirestdemo.bo.OrderItem;
import it.bittime.delphirestdemo.bo.Product;
import android.app.Activity;
import android.content.Intent;
import android.database.DataSetObserver;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.view.ViewGroup;
import android.view.View.OnClickListener;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Spinner;
import android.widget.SpinnerAdapter;
import android.widget.Toast;


public class EditOrderItemActivity extends Activity implements OnClickListener{
	public final static int ORDER_ITEM_REQUEST_CODE = 100; 
	private OrderItem order_item;
	private Spinner spn_product;
	private EditText txt_quantity;
	private Button btn_save;
	private List<Product> products;
	private List<String> products_string;
	
	@Override
	public void onCreate(Bundle bundle) {
		super.onCreate(bundle);
		setContentView(R.layout.edit_order_item);
		products = (new RESTProxy(this)).getProducts();
		products_string = new ArrayList<String>();
		
		for (Product product: products)
			products_string.add(String.format("(%d) %s", product.getId(), product.getDescription()));
		
		spn_product = (Spinner)findViewById(R.id.spn_product);
		txt_quantity = (EditText)findViewById(R.id.txt_quantity);
		btn_save = (Button)findViewById(R.id.btn_save_order_item);
		btn_save.setOnClickListener(this);
	}
	
	@Override
	public void onResume() {
		super.onResume();
		Intent intent = getIntent();
		order_item = new OrderItem();
		String s = intent.getStringExtra("order_item");
		if (s!=null)
			try {
				order_item.loadFromJSONString(s);
			} catch (JSONException e) {
				e.printStackTrace();
				Toast.makeText(this, "Cannot load Order Item: " + e.getMessage(), Toast.LENGTH_LONG).show();
			}
		refresh_data();
	}

	private void refresh_data() {
    ArrayAdapter<String> adapter = new ArrayAdapter<String>(this, 
  			android.R.layout.simple_spinner_item, products_string);   
    adapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
    spn_product.setAdapter(adapter);						
		spn_product.setSelection(getPosition(order_item.getId_product()));
		txt_quantity.setText(String.valueOf(order_item.getQuantity()));
	}
	
	private int getPosition(int id)
	{
		int i = 0;
		Boolean found = false;
		for (Product p: products)
		{			
			if (p.getId() == id)
			{
				found = true;
  		  break;
			}
			i++; 
		}
		if (found)			
			return i;
		else
			return 0;
	}

	@Override
	public void onClick(View arg0) {		
		try {
			//Log.d("DEMO", spn_product.getSelectedItem().getClass().getName());
			String s = spn_product.getSelectedItem().toString();
			int i = Integer.parseInt(s.substring(1, s.indexOf(")")));
			order_item.setId_product(i);
			order_item.setQuantity(Integer.parseInt(txt_quantity.getText().toString()));
			Intent intent = new Intent();			
			intent.putExtra("order_item", order_item.toJSONString());
	    setResult(RESULT_OK, intent);			
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			setResult(RESULT_CANCELED);
		}    
    finish();		
	}
}
