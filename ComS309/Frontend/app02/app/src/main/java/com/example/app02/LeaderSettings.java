package com.example.app02;

import androidx.appcompat.app.AppCompatActivity;

import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Toast;

import com.android.volley.Request;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.JsonArrayRequest;
import com.example.net_utils.NetworkCalls;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

public class LeaderSettings extends AppCompatActivity {

    private Button btnMain;
    private Button addMemberbtn;
    private EditText searchAdd;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_leader_settings);

        btnMain = findViewById(R.id.exitButton);
        addMemberbtn = findViewById(R.id.addBtn);
        searchAdd = findViewById(R.id.editAdd);


        btnMain.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                openMainMenu();
            }
        });


        addMemberbtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (searchAdd.getText().length() > 0) {
                    String username = searchAdd.getText().toString();

                    String toastMessage = "Username:" + username;
                    //Toast.makeText(getApplicationContext(),toastMessage,Toast.LENGTH_SHORT).show();

                    //RequestQueue reqQueue = Volley.newRequestQueue(mContext);

                    JsonArrayRequest jsonArrReq = new JsonArrayRequest(
                            Request.Method.GET,
                            NetworkCalls.URL_JSON_USERS,
                            null,
                            new Response.Listener<JSONArray>() {
                                @Override
                                public void onResponse(JSONArray response) {
                                    try {
                                        for (int i = 0; i < response.length(); i++) {
                                            JSONObject user = response.getJSONObject(i);

                                            String dbUsername = user.getString("userName");

                                            if (username.equals(dbUsername)) {


                                            } else {

                                            }
                                        }
                                    } catch (JSONException e) {
                                        e.printStackTrace();
                                    }
                                }
                            },
                            new Response.ErrorListener() {
                                @Override
                                public void onErrorResponse(VolleyError error) {
                                    Log.d("Server Response ", error.toString());
                                    Toast.makeText(getApplicationContext(), error.toString(), Toast.LENGTH_SHORT).show();
                                }

                            }
                    );

                    AppController.getInstance().addToRequestQueue(jsonArrReq);
                    //openMainMenu();

                } else {
                    String toastMessage = "Please enter a username to search.";
                    Toast.makeText(getApplicationContext(), toastMessage, Toast.LENGTH_SHORT).show();
                }
            }
        });

    }

    public void openMainMenu() {
        Intent intent = new Intent(this, MainMenu.class);
        startActivity(intent);
        overridePendingTransition(android.R.anim.fade_in, android.R.anim.fade_out);
    }
}