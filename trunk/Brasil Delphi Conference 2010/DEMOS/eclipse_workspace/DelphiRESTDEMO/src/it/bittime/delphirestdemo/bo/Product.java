package it.bittime.delphirestdemo.bo;

import org.json.JSONException;
import org.json.JSONObject;

public class Product implements JSONSerializable {
	private int id;
	private String description;	
	
	public Product(int id, String description)
	{
		super();
		setId(id);
		setDescription(description);
	}
	
	public void setId(int id) {
		this.id = id;
	}

	public int getId() {
		return id;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public String getDescription() {
		return description;
	}

	@Override
	public void loadFromJSONString(String json) throws JSONException {
		JSONObject j = new JSONObject(json);
		setId(j.getInt("ID"));
		setDescription(j.getString("DESCRIPTION"));
	}

	@Override
	public String toJSONString() throws JSONException {
		JSONObject j = new JSONObject();
		j.put("ID", getId()).put("DESCRIPTION", getDescription());
		return j.toString();
	}

}
