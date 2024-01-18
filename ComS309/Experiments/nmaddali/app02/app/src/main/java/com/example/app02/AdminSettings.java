package com.example.app02;

import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Toast;

import androidx.appcompat.app.AppCompatActivity;

import com.android.volley.Request;
import com.android.volley.RequestQueue;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.StringRequest;
import com.android.volley.toolbox.Volley;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.HashMap;
import java.util.Map;

public class AdminSettings extends AppCompatActivity {

    private Button btnMain;
    private Button btnSuspendUser;
    private Button btnBanUser;
    private Context mContext;
    private EditText editSuspendUser;
    private EditText editBanUser;



    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_admin_settings);

        btnMain = findViewById(R.id.exitButton);
        btnSuspendUser = findViewById(R.id.btnSuspendUser);
        btnBanUser = findViewById(R.id.btnBanUser);
        editSuspendUser = findViewById(R.id.editSuspendUser);
        editBanUser = findViewById(R.id.editBanUser);

        btnMain.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                openMainMenu();
            }
        });

        mContext = getApplicationContext();

        btnSuspendUser.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                // validating if the text field is empty or not.
                if (editSuspendUser.getText().toString().isEmpty()) {
                    Toast.makeText(AdminSettings.this, "Please enter a username to suspend", Toast.LENGTH_SHORT).show();
                    return;
                }
                // calling a method to post the data and passing our name and job.
                postDataUsingVolley(editSuspendUser.getText().toString());
            }
        });

        btnBanUser.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                // validating if the text field is empty or not.
                if (editBanUser.getText().toString().isEmpty()) {
                    Toast.makeText(AdminSettings.this, "Please enter a username to ban", Toast.LENGTH_SHORT).show();
                    return;
                }
                // calling a method to post the data and passing our name and job.
                postDataUsingVolley2(editBanUser.getText().toString());
            }
        });
    }

    private void postDataUsingVolley(String name){
        // url to post our data
        String url = "http://coms-309-037.cs.iastate.edu:8080/users";

        // creating a new variable for our request queue
        RequestQueue queue = Volley.newRequestQueue(AdminSettings.this);

        // on below line we are calling a string
        // request method to post the data to our API
        // in this we are calling a post method.
        StringRequest request = new StringRequest(Request.Method.POST, url, new com.android.volley.Response.Listener<String>() {
            @Override
            public void onResponse(String response) {
                // inside on response method we are
                // hiding our progress bar
                // and setting data to edit text as empty
                editSuspendUser.setText("");

                // on below line we are displaying a success toast message.
                Toast.makeText(AdminSettings.this, "Data added to API", Toast.LENGTH_SHORT).show();
                try {
                    // on below line we are passing our response
                    // to json object to extract data from it.
                    JSONObject respObj = new JSONObject(response);


                    // below are the strings which we
                    // extract from our json object.
                    String name = respObj.getString("userName");

                    // on below line we are setting this string s to our text view.
                } catch (JSONException e) {
                    e.printStackTrace();
                }
            }
        }, new com.android.volley.Response.ErrorListener() {
            @Override
            public void onErrorResponse(VolleyError error) {
                // method to handle errors.
                Toast.makeText(AdminSettings.this, "Fail to get response = " + error, Toast.LENGTH_SHORT).show();
            }
        }) {
            @Override
            protected Map<String, String> getParams() {
                // below line we are creating a map for
                // storing our values in key and value pair.
                Map<String, String> params = new HashMap<String, String>();

                // on below line we are passing our key
                // and value pair to our parameters.
                params.put("suspend", "TRUE");

                // at last we are
                // returning our params.
                return params;
            }
        };
        // below line is to make
        // a json object request.
        queue.add(request);
    }

    private void postDataUsingVolley2(String name){
        // url to post our data
        String url = "http://coms-309-037.cs.iastate.edu:8080/users";

        // creating a new variable for our request queue
        RequestQueue queue = Volley.newRequestQueue(AdminSettings.this);

        // on below line we are calling a string
        // request method to post the data to our API
        // in this we are calling a post method.
        StringRequest request = new StringRequest(Request.Method.POST, url, new com.android.volley.Response.Listener<String>() {
            @Override
            public void onResponse(String response) {
                // inside on response method we are
                // hiding our progress bar
                // and setting data to edit text as empty
                editSuspendUser.setText("");

                // on below line we are displaying a success toast message.
                Toast.makeText(AdminSettings.this, "Data added to API", Toast.LENGTH_SHORT).show();
                try {
                    // on below line we are passing our response
                    // to json object to extract data from it.
                    JSONObject respObj = new JSONObject(response);


                    // below are the strings which we
                    // extract from our json object.
                    String name = respObj.getString("userName");

                    // on below line we are setting this string s to our text view.
                } catch (JSONException e) {
                    e.printStackTrace();
                }
            }
        }, new com.android.volley.Response.ErrorListener() {
            @Override
            public void onErrorResponse(VolleyError error) {
                // method to handle errors.
                Toast.makeText(AdminSettings.this, "Fail to get response = " + error, Toast.LENGTH_SHORT).show();
            }
        }) {
            @Override
            protected Map<String, String> getParams() {
                // below line we are creating a map for
                // storing our values in key and value pair.
                Map<String, String> params = new HashMap<String, String>();

                // on below line we are passing our key
                // and value pair to our parameters.
                params.put("ban", "TRUE");

                // at last we are
                // returning our params.
                return params;
            }
        };
        // below line is to make
        // a json object request.
        queue.add(request);
    }


    public void openMainMenu(){
        Intent intent = new Intent(this, MainMenu.class);
        startActivity(intent);
        overridePendingTransition(android.R.anim.fade_in, android.R.anim.fade_out);
    }
}