package com.example.app02;

import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.Toast;

import androidx.appcompat.app.AppCompatActivity;

import com.android.volley.Request;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.JsonArrayRequest;
import com.example.net_utils.NetworkCalls;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

public class Friends extends AppCompatActivity {

    private EditText searchFriendsText;
    private TextView printFriends;
    private Button searchButton;
    private Button btnMain;
    private Context mContext;
    private Button btnRequest;
    private TextView printFriendRequest;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_friends);

        searchFriendsText = findViewById(R.id.editSearchFriends);
        searchButton = findViewById(R.id.searchButton);
        printFriends = findViewById(R.id.printFriend);
        btnMain = findViewById(R.id.exitButton);
        btnRequest = findViewById(R.id.btnRequest);
        printFriendRequest = findViewById(R.id.printFriendRequest);

        btnMain.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                openMainMenu();
            }
        });

        mContext = getApplicationContext();

        searchButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (searchFriendsText.getText().length() > 0) {
                    String username = searchFriendsText.getText().toString();

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
                                                //printFriends.setText(response.toString());
                                                printFriends.setText(dbUsername);
                                                btnRequest.setVisibility(View.VISIBLE);
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

        btnRequest.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                printFriendRequest.setText(printFriends.getText().toString());
                btnRequest.setVisibility(View.INVISIBLE);
                printFriends.setVisibility(View.INVISIBLE);

            }

        });
    }


    public void openMainMenu() {
        Intent intent = new Intent(this, MainMenu.class);
        startActivity(intent);
        overridePendingTransition(android.R.anim.fade_in, android.R.anim.fade_out);
    }
}