package com.example.app02;

import static android.content.ContentValues.TAG;

import androidx.appcompat.app.AppCompatActivity;

import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.Toast;

import com.android.volley.Request;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.JsonObjectRequest;
import com.example.net_utils.NetworkCalls;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.HashMap;
import java.util.Map;

public class GroupLeaderDecision extends AppCompatActivity {

    private Button btnMain;
    private Button btnYes;
    private Button btnNo;
    private boolean yesClicked = false;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_group_leader_decision);

        btnMain = findViewById(R.id.exitButton);
        btnYes = findViewById(R.id.yesBtn);
        btnNo = findViewById(R.id.noBtn);

        btnMain.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                openMainMenu();
            }
        });

        btnYes.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                becomeGroupLeader();
            }
        });

        btnNo.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                notGroupLeader();
            }
        });

    }

    public void becomeGroupLeader(){
        yesClicked = true;
        String testName = "testTeam";
        try{
            NetworkCalls.updateLeader(yesClicked);
        } catch (JSONException e) {
            e.printStackTrace();
        }

        JsonObjectRequest jsonObjReq = new JsonObjectRequest(Request.Method.POST,
                NetworkCalls.createTeam(testName, MainMenu.currUser.getId()), null,
                new Response.Listener<JSONObject>() {
                    @Override
                    public void onResponse(JSONObject response) {
                        Log.d(TAG, response.toString());
                        //pDialog.hide();
                        openLeaderSettings();
                    }
                }, new Response.ErrorListener() {
            @Override
            public void onErrorResponse(VolleyError error) {
                //VolleyLog.d(TAG, "Error: " + error.getMessage());
                //pDialog.hide();
                Log.d("Server Response ", error.toString());
                Toast.makeText(getApplicationContext(), error.toString(), Toast.LENGTH_SHORT).show();
            }
        }) {
            @Override
            protected Map<String, String> getParams() {
                Map<String, String> params = new HashMap<String, String>();
                            /*
                            params.put("username", regUsername);
                            params.put("email", regEmail);
                            params.put("password", regPassword);
                            params.put("name", regName);
                             */
                return params;
            }
        };

        AppController.getInstance().addToRequestQueue(jsonObjReq);

    }

    public void openLeaderSettings(){
        Intent intent = new Intent(this, LeaderSettings.class);
        startActivity(intent);
        overridePendingTransition(android.R.anim.fade_in, android.R.anim.fade_out);
    }

    public void notGroupLeader(){
        yesClicked = false;
        try{
            NetworkCalls.updateLeader(yesClicked);
        } catch (JSONException e) {
            e.printStackTrace();
        }

        Intent intent = new Intent(this, Team.class);
        startActivity(intent);
        overridePendingTransition(android.R.anim.fade_in, android.R.anim.fade_out);

    }

    public void openMainMenu() {
        Intent intent = new Intent(this, MainMenu.class);
        startActivity(intent);
        overridePendingTransition(android.R.anim.fade_in, android.R.anim.fade_out);
    }
}