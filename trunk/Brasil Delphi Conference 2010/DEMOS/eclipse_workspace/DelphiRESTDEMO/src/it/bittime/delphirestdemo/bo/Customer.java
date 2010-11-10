package it.bittime.delphirestdemo.bo;

import org.json.JSONException;
import org.json.JSONObject;

public class Customer implements JSONSerializable{
  private String description;
  private String address;
  private Double lat, lon;
  private int id;
    
  public Customer()
  {
  	super();
  	setId(0);
  }
  
  public Customer(int id, String description, String address, Double lat, Double lon)
  {
  	super();
  	setId(id);
  	setDescription(description);
  	setAddress(address);
  	setLat(lat);
  	setLon(lon);
  }
  
	public void setId(int id) {
		this.id = id;
	}
	public int getId() {
		return id;
	}  
	
	@Override
	public String toString()
	{
		return String.format("(%d) %s %s", id, description, address); //, lat, lon);		
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public String getDescription() {
		return description;
	}

	public void setAddress(String address) {
		this.address = address;
	}

	public String getAddress() {
		return address;
	}

	public void setLat(Double lat) {
		this.lat = lat;
	}

	public Double getLat() {
		return lat;
	}

	public void setLon(Double lon) {
		this.lon = lon;
	}

	public Double getLon() {
		return lon;
	}

	@Override
	public void loadFromJSONString(String json) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public String toJSONString() throws JSONException {
		JSONObject j = new JSONObject();
		if (getId() > 0)
			j.put("ID", getId());
		j.put("DESCRIPTION", getDescription());
		j.put("ADDRESS", getAddress());
		j.put("LATITUDE", getLat());
		j.put("LONGITUDE", getLon());
		return j.toString();
	}
}
