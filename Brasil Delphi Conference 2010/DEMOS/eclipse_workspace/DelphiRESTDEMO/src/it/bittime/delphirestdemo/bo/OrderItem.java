package it.bittime.delphirestdemo.bo;

import java.io.Serializable;

import org.json.JSONException;
import org.json.JSONObject;

public class OrderItem implements JSONSerializable, Serializable {
	private int id_order = -1;
  private int id_product = -1;
  private int quantity = 1;
	public void setId_order(int id_order) {
		this.id_order = id_order;
	}
	public int getId_order() {
		return id_order;
	}
	public void setId_product(int id_product) {
		this.id_product = id_product;
	}
	public int getId_product() {
		return id_product;
	}
	public void setQuantity(int quantity) {
		this.quantity = quantity;
	}
	public int getQuantity() {
		return quantity;
	}
	@Override
	public void loadFromJSONString(String json) throws JSONException {
		JSONObject j = new JSONObject(json);
		setId_order(j.getInt("ID_ORDER"));
		setId_product(j.getInt("ID_PRODUCT"));
		setQuantity(j.getInt("QUANTITY"));		
	}
	@Override
	public String toJSONString() throws JSONException {
		JSONObject j = new JSONObject();
		j.put("ID_ORDER", getId_order());
		j.put("ID_PRODUCT", getId_product());
		j.put("QUANTITY", getQuantity());
		return j.toString();
	}
}
