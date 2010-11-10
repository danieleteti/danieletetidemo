package it.bittime.delphirestdemo;

import it.bittime.delphirestdemo.bo.*;
import it.bittime.delphirestdemo.*;
import java.io.*;
import java.net.URI;
import java.net.URLEncoder;
import java.util.*;
import org.apache.http.*;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.*;
import org.apache.http.client.utils.URLEncodedUtils;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.DefaultHttpClient;
import org.json.*;

import android.content.Context;
import android.util.Log;
import android.widget.Toast;

public class RESTProxy {
	private String BASE_URL = "";
	private String BASE_URL_FORMAT = "http://%s/datasnap/rest/TService/";
	private String datasnapurl;
	private Context context;

	public RESTProxy(Context context) {
		super();
		this.context = context;
		this.BASE_URL = String.format(BASE_URL_FORMAT,					
					((DelphiRESTDEMOApplication)context.getApplicationContext()).getDataSnapURL()
				);
	}

	
	/// #3
	public void createCustomer(Customer customer) throws Exception {
		org.json.JSONObject j = new org.json.JSONObject();
		j.put("DESCRIPTION", customer.getDescription())
		 .put("ADDRESS", customer.getAddress())
		 .put("LATITUDE", customer.getLat())
		 .put("LONGITUDE", customer.getLon());

		try {
			HttpClient client = new DefaultHttpClient();
			HttpPut method = new HttpPut(BASE_URL + "customers");
			method.setEntity(new StringEntity(j.toString(), "utf-8"));
			client.execute(method);
		} catch (Exception e) {
			e.printStackTrace();
			throw e;
		}
	}

	public void createOrder(Order order) throws Exception {
		String s = order.toJSONString();
		try {
			HttpClient client = new DefaultHttpClient();
			HttpPut method = new HttpPut(BASE_URL + "orders");
			method.setEntity(new StringEntity(s, "utf-8"));
			client.execute(method);
		} catch (Exception e) {
			e.printStackTrace();
			throw e;
		}
	}

	public void updateCustomer(Customer customer) throws Exception {
		org.json.JSONObject j = new org.json.JSONObject();
		j.put("ID", customer.getId()).put("DESCRIPTION", customer.getDescription()).put("ADDRESS", customer.getAddress())
				.put("LATITUDE", customer.getLat()).put("LONGITUDE", customer.getLon());

		try {
			HttpClient client = new DefaultHttpClient();
			HttpPost method = new HttpPost(BASE_URL + "customers/" + String.valueOf(customer.getId()));
			method.setEntity(new StringEntity(j.toString(), "utf-8"));
			client.execute(method);
		} catch (Exception e) {
			e.printStackTrace();
			throw e;
		}
	}

	/// #2
	public List<Customer> getCustomers() {
		DelphiRESTDEMOApplication app = (DelphiRESTDEMOApplication) context.getApplicationContext();
		if (app.customers == null) {
			try {
				HttpClient client = new DefaultHttpClient();
				HttpGet method = new HttpGet(BASE_URL + "/customers");
				app.customers = loadCustomersJSON(client.execute(method));
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		return app.customers;
	}

	public List<Product> getProducts() {
		DelphiRESTDEMOApplication app = (DelphiRESTDEMOApplication) context.getApplicationContext();
		if (app.products == null) {
			try {
				HttpClient client = new DefaultHttpClient();
				HttpGet method = new HttpGet(BASE_URL + "products");
				app.products = loadProductsJSON(client.execute(method));
				app.map_products.clear();  //BUILDING PRODUCTS CACHE
				for(Product p: app.products)
					app.map_products.put(p.getId(), p);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		return app.products;
	}

	protected List<Customer> loadCustomersJSON(HttpResponse response) throws IllegalStateException, IOException,
			JSONException {
		BufferedReader br = new BufferedReader(new InputStreamReader(response.getEntity().getContent()));
		String row;
		StringBuilder sb = new StringBuilder();
		while ((row = br.readLine()) != null)
			sb.append(row);
		Log.d("DEMO", "JSON COMPLETO: " + sb.toString());
		org.json.JSONObject o = new org.json.JSONObject(sb.toString());

		JSONArray ids = ((JSONObject) o.getJSONArray("result").get(0)).getJSONArray("ID");
		JSONArray descriptions = ((JSONObject) o.getJSONArray("result").get(0)).getJSONArray("DESCRIPTION");
		JSONArray addresses = ((JSONObject) o.getJSONArray("result").get(0)).getJSONArray("ADDRESS");
		JSONArray lats = ((JSONObject) o.getJSONArray("result").get(0)).getJSONArray("LATITUDE");
		JSONArray lons = ((JSONObject) o.getJSONArray("result").get(0)).getJSONArray("LONGITUDE");

		ArrayList<Customer> arr = new ArrayList<Customer>();

		for (int i = 0; i < ids.length(); i++)
			arr.add(new Customer(ids.getInt(i), descriptions.getString(i), addresses.getString(i), lats.getDouble(i), lons
					.getDouble(i)));

		return arr;
	}

	protected List<Product> loadProductsJSON(HttpResponse response) throws IllegalStateException, IOException,
			JSONException {
		BufferedReader br = new BufferedReader(new InputStreamReader(response.getEntity().getContent()));
		String row;
		StringBuilder sb = new StringBuilder();
		while ((row = br.readLine()) != null)
			sb.append(row);
		Log.d("DEMO", "JSON COMPLETO: " + sb.toString());
		org.json.JSONObject o = new org.json.JSONObject(sb.toString());
		JSONArray ids = ((JSONObject) o.getJSONArray("result").get(0)).getJSONArray("ID");
		JSONArray descriptions = ((JSONObject) o.getJSONArray("result").get(0)).getJSONArray("DESCRIPTION");		
		ArrayList<Product> arr = new ArrayList<Product>();
		for (int i = 0; i < ids.length(); i++)
			arr.add(new Product(ids.getInt(i), descriptions.getString(i)));
		return arr;
	}

	protected List<String> loadCustomersJSONAsStrings(HttpResponse response) throws IllegalStateException, IOException,
			JSONException {
		BufferedReader br = new BufferedReader(new InputStreamReader(response.getEntity().getContent()));
		String row;
		StringBuilder sb = new StringBuilder();
		while ((row = br.readLine()) != null)
			sb.append(row);
		Log.d("DEMO", "JSON COMPLETO: " + sb.toString());
		org.json.JSONObject o = new org.json.JSONObject(sb.toString());
		ArrayList<String> arr = null;
		JSONObject obj = (JSONObject) o.getJSONArray("result").get(0);
		if (obj.has("ID")) {
			JSONArray ids = obj.getJSONArray("ID");
			JSONArray descriptions = obj.getJSONArray("DESCRIPTION");
			/*
			 * JSONArray addresses = obj.getJSONArray("ADDRESS"); JSONArray lats =
			 * obj.getJSONArray("LATITUDE"); JSONArray lons =
			 * obj.getJSONArray("LONGITUDE");
			 */
			arr = new ArrayList<String>();
			for (int i = 0; i < ids.length(); i++)
				arr.add(String.format("(%s) %s", ids.getInt(i), descriptions.getString(i)));
		}
		return arr;
	}

	public List<Customer> customersSearch(String criteria) {
		try {
			HttpClient client = new DefaultHttpClient();
			HttpGet method = new HttpGet(BASE_URL + "searchcustomers/" + criteria);
			return loadCustomersJSON(client.execute(method));
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}

	/// #3
	public List<String> customersSearchAsStrings(String criteria) {
		try {
			HttpClient client = new DefaultHttpClient();
			HttpGet method = new HttpGet(BASE_URL + "searchcustomers/" + URLEncoder.encode(criteria));
			return loadCustomersJSONAsStrings(client.execute(method));
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}

	/// #1
	public Customer getCustomer(String key) {
		try {
			HttpClient client = new DefaultHttpClient();
			HttpGet method = new HttpGet(BASE_URL + "customers/" + key);
			HttpResponse res = client.execute(method);
			if (res.getStatusLine().getStatusCode() == 200) {

				String strjson = getResponseAsString(res);
				JSONObject o = new JSONObject(strjson);

				JSONArray ids = ((JSONObject) o.getJSONArray("result").get(0)).getJSONArray("ID");
				JSONArray descriptions = ((JSONObject) o.getJSONArray("result").get(0)).getJSONArray("DESCRIPTION");
				JSONArray addresses = ((JSONObject) o.getJSONArray("result").get(0)).getJSONArray("ADDRESS");
				JSONArray lats = ((JSONObject) o.getJSONArray("result").get(0)).getJSONArray("LATITUDE");
				JSONArray lons = ((JSONObject) o.getJSONArray("result").get(0)).getJSONArray("LONGITUDE");
				
				Double lat = 0.0;				 
				try { lat =  lats.getDouble(0); }catch (Exception ex) {}
				Double lon = 0.0;				 
				try { lon =  lons.getDouble(0); }catch (Exception ex) {}
				
				
				// return the orders too
				Customer customer = new Customer(ids.getInt(0), descriptions.getString(0), addresses.getString(0), lat, lon);
				return customer;
			} else
				return null;
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}

	public Order getOrder(String key) {
		try {
			HttpClient client = new DefaultHttpClient();
			HttpGet method = new HttpGet(BASE_URL + "orders/" + key);
			HttpResponse res = client.execute(method);
			if (res.getStatusLine().getStatusCode() == 200) {
				JSONObject o = (new JSONObject(getResponseAsString(res))).getJSONArray("result").getJSONObject(0);
				int id = o.getJSONArray("ID").getInt(0);
				int id_customer = o.getJSONArray("ID_CUSTOMER").getInt(0);
				String created_at = o.getJSONArray("CREATED_AT").getString(0);
				String ship_before = o.getJSONArray("SHIP_BEFORE").getString(0);
				return new Order(id, id_customer, created_at, ship_before);
			} else
				return null;
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}

	final protected String getResponseAsString(HttpResponse res) throws IOException {
		BufferedReader x = new BufferedReader(new InputStreamReader(res.getEntity().getContent()));
		StringBuffer sb = new StringBuffer();
		String l;
		while ((l = x.readLine()) != null)
			sb.append(l);
		return sb.toString();
	}
}
