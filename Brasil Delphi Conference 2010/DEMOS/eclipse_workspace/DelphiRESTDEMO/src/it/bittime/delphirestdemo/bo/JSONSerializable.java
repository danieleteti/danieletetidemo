package it.bittime.delphirestdemo.bo;

import org.json.JSONException;

public interface JSONSerializable {
	public String toJSONString() throws JSONException;
	public void loadFromJSONString(String json) throws JSONException;
}
