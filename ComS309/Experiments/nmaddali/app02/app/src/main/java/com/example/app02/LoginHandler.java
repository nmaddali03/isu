package com.example.app02;

/**
import android.content.Intent;
import android.util.Log;
import android.widget.Toast;

import com.android.volley.Request;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.JsonArrayRequest;
import com.example.net_utils.NetworkCalls;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;

public class LoginHandler {

    public LoginHandler()
    {

    }

    mContext = getApplicationContext();

    public JSONObject getResponse(String username, String password) {

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
                                String dbPassword = user.getString("password");

                                if (username.equals(dbUsername) && password.equals(dbPassword)) {
                                    openMainMenu();
                                    break;
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
        return null;
    }

    public void openMainMenu() {
        Intent intent = new Intent(this, MainMenu.class);
        intent.putExtra("username", user);
        startActivity(intent);
        overridePendingTransition(android.R.anim.fade_in, android.R.anim.fade_out);
    }
}**/

