package it.bittime.delphirestdemo;
import it.bittime.delphirestdemo.bo.*;

import java.util.*;


import android.app.Application;
import android.content.SharedPreferences;
import android.preference.PreferenceManager;


public class DelphiRESTDEMOApplication extends Application { 
  public List<Product> products = null;
  public Map<Integer, Product> map_products = new HashMap<Integer, Product>();   
  public List<Customer> customers = null;  
	public String getDataSnapURL()
	{
		SharedPreferences prefs = PreferenceManager.getDefaultSharedPreferences(this);
		return prefs.getString("dsurl", "192.168.16.40:8080");				
	}  
}
