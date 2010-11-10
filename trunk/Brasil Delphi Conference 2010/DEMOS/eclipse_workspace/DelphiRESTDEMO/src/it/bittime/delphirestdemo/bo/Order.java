package it.bittime.delphirestdemo.bo;

import java.io.Serializable;
import java.util.*;
import org.json.*;

import android.util.Log;

public class Order implements JSONSerializable, Serializable {
	private int id;
	private int id_customer;
	private String created_at;
	private String ship_before;
		
	public List <OrderItem> Items = new ArrayList<OrderItem>();

	public Order()
	{
		super();
		setId(0);
	}
	
	public Order(int id, int id_customer, String created_at, String ship_before)
	{
		super();
		setId(id);
		setId_customer(id_customer);
		setShip_before(ship_before);
		setCreated_at(created_at);
	}
	
	public void setId_customer(int id_customer) {
		this.id_customer = id_customer;
	}


	public int getId_customer() {
		return id_customer;
	}


	public void setCreated_at(String created_at) {
		this.created_at = created_at;
	}


	public String getCreated_at() {
		return created_at;
	}


	public void setShip_before(String ship_before) {
		this.ship_before = ship_before;
	}


	public String getShip_before() {
		return ship_before;
	}	
	

	public void setId(int id) {
		this.id = id;
	}


	public int getId() {
		return id;
	}		
	
	@Override
	public void loadFromJSONString(String json) {
	}
	@Override
	public String toJSONString() throws JSONException {
		JSONObject j = new JSONObject();
		j.put("ID", getId());
		j.put("ID_CUSTOMER", getId_customer());
		j.put("CREATED_AT", getCreated_at());
		j.put("SHIP_BEFORE", getShip_before());			
		
		JSONArray a = new JSONArray();
		for(OrderItem item: Items)
		{
			a.put(new JSONObject(item.toJSONString()));
		}
		j.put("ROWS", a);
		Log.d("DEMO_JSON", j.toString());
		return j.toString();
	}


}
