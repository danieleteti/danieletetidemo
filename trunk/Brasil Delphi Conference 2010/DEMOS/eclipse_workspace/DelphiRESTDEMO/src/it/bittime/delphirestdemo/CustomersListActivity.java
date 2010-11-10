package it.bittime.delphirestdemo;

import java.util.ArrayList;
import java.util.List;

import it.bittime.delphirestdemo.bo.Customer;
import android.app.*;
import android.content.Intent;
import android.os.Bundle;
import android.speech.RecognizerIntent;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.*;
import android.widget.AdapterView.OnItemClickListener;

public class CustomersListActivity extends Activity implements OnClickListener {
	public static final int VOICE_RECOGNITION_REQUEST_CODE = 10;	
	private ListView lv = null;

	private Button btn = null;

	private EditText txt;
	private Button btn_voice;

	/** Called when the activity is first created. */
	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.customer_list);
		lv = (ListView) findViewById(R.id.lv_customers);
		btn = (Button) findViewById(R.id.btn_customer_search);
		btn.setOnClickListener(this);
		btn_voice = (Button) findViewById(R.id.btn_voice_recognition);
		btn_voice.setOnClickListener(this);
		txt = (EditText) findViewById(R.id.txt_customer_search);
		bind_list(new ArrayList<String>());
	}

	private void bind_list(List<String> list) {
		if (list == null) {
			list = new ArrayList<String>();
			Toast.makeText(this, "No customers found", Toast.LENGTH_SHORT);
		}
		lv.setAdapter(new ArrayAdapter<String>(this, R.layout.customer_list_item, list));
		lv.setTextFilterEnabled(true);
		lv.setOnItemClickListener(new OnItemClickListener() {
			@Override
			public void onItemClick(AdapterView<?> arg0, View view, int arg2, long arg3) {
				// Toast.makeText(getApplicationContext(), ((TextView) view).getText(),
				// Toast.LENGTH_SHORT).show();
				Intent intent = new Intent(CustomersListActivity.this, EditCustomerActivity.class);
				String s = ((TextView) view).getText().toString();
				int i = Integer.parseInt(s.substring(1, s.indexOf(")")));
				intent.putExtra("id_customer", i);
				startActivity(intent);
			}
		});
	}

	@Override
	public void onClick(View arg0) {
		switch (arg0.getId()) {
		case R.id.btn_customer_search: {
			RESTProxy p = new RESTProxy(this);
			List<String> customers = p.customersSearchAsStrings(txt.getText().toString());
			bind_list(customers);
			break;
		}
		
		case R.id.btn_voice_recognition: {
			startVoiceRecognitionActivity();
			break;
		}
		}
	}
  
  /**
   * Fire an intent to start the speech recognition activity.
   */
  private void startVoiceRecognitionActivity() {
      Intent intent = new Intent(RecognizerIntent.ACTION_RECOGNIZE_SPEECH);
      intent.putExtra(RecognizerIntent.EXTRA_LANGUAGE_MODEL,
              RecognizerIntent.LANGUAGE_MODEL_FREE_FORM);
      intent.putExtra(RecognizerIntent.EXTRA_PROMPT, "Speech recognition demo");
      startActivityForResult(intent, VOICE_RECOGNITION_REQUEST_CODE);
  }
	
	
  /**
   * Handle the results from the recognition activity.
   */
  @Override
  protected void onActivityResult(int requestCode, int resultCode, Intent data) {
      if (requestCode == VOICE_RECOGNITION_REQUEST_CODE && resultCode == RESULT_OK) {
          // Fill the list view with the strings the recognizer thought it could have heard
          ArrayList<String> matches = data.getStringArrayListExtra(
                  RecognizerIntent.EXTRA_RESULTS);
          if (matches.size() > 0)
          	txt.setText(matches.get(0));
      }

      super.onActivityResult(requestCode, resultCode, data);
  }

}
