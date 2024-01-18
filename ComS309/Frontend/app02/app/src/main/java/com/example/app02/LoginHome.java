package com.example.app02;

import androidx.appcompat.app.AppCompatActivity;

import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.CompoundButton;
import android.widget.EditText;
import android.widget.Toast;

import com.android.volley.Network;
import com.android.volley.Request;
import com.android.volley.RequestQueue;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.VolleyLog;
import com.android.volley.toolbox.JsonArrayRequest;
import com.android.volley.toolbox.JsonObjectRequest;
import com.android.volley.toolbox.StringRequest;
import com.android.volley.toolbox.Volley;
import com.example.net_utils.NetworkCalls;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

public class LoginHome extends AppCompatActivity {

    private EditText usernameEditText;
    private EditText passwordEditText;
    private Button loginButton;
    private Button registerButton;
    private CheckBox rememberMe;

   // private Context mContext;
    private String user;

    private Integer respID = -1;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_login_home);

        //userusernameandpasswordtext
        usernameEditText = findViewById(R.id.activity_main_usernameEditText);
        passwordEditText = findViewById(R.id.activity_main_passwordEditText);

        //gettheloginbuttonid
        loginButton = findViewById(R.id.activity_main_loginButton);
        registerButton = findViewById(R.id.activity_main_registerButton);

        rememberMe = findViewById(R.id.login_rememberme_checkBox);

        SharedPreferences pref = getSharedPreferences("checkbox", MODE_PRIVATE);
        String checkedBox = pref.getString("remember", "");
        // Todo: make shared preferences store current object values


        if(checkedBox.equals("true")) {
            Toast.makeText(this, "Login remembered. Proceeding to Main Menu.", Toast.LENGTH_SHORT).show();
            openMainMenu();
        } else if (checkedBox.equals("false")) {
            Toast.makeText(this, "Please sign in.", Toast.LENGTH_SHORT).show();
        }

        //checkalltheseconditions
        //afteruserclickslogin,theirinputs,ifpassedbytheconditionswillbeprintedin
        //analertmessageonthebottomofthescreen

        //mContext = getApplicationContext();

        loginButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (usernameEditText.getText().length() > 0 && passwordEditText.getText().length() > 0) {
                    String username = usernameEditText.getText().toString();
                    String password = passwordEditText.getText().toString();
                    user = username;

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
                                                respID = i;
                                                validate(username,password);
                                                openMainMenu();
                                                break;
                                            } 
                                        }

                                        if (respID == -1) {
                                            Toast.makeText(getApplicationContext(), "Incorrect Username or Password.", Toast.LENGTH_SHORT).show();
                                        }

                                        /* Debug */
                                        Log.d("SR (Response Index): ", respID.toString());

                                        if (respID != -1) {
                                            JSONObject user = response.getJSONObject(respID);

                                            Integer currID = user.getInt("id");
                                            String currName = user.getString("name");
                                            String currUserName = user.getString("userName");
                                            String currEmail = user.getString("email");
                                            String currPassword = user.getString("password");
                                            Boolean currAdminFlag = user.getBoolean("admin");
                                            Boolean currSuspendFlag = user.getBoolean("suspend");
                                            Integer currCurrency = user.getInt("currency");
                                            Boolean currLeaderFlag = user.getBoolean("leader");
                                            Integer currHigh = user.getJSONObject("score").getInt("high");
                                            Integer currLow = user.getJSONObject("score").getInt("low");
                                            Integer currRecent = user.getJSONObject("score").getInt("recent");
                                            Integer currTotal = user.getJSONObject("score").getInt("total");

                                            /* Debug */
                                            Log.d("SR (userID): ", currID.toString());
                                            Log.d("SR (currName): ", currName);
                                            Log.d("SR (currUserName): ", currUserName);
                                            Log.d("SR (currEmail): ", currEmail);
                                            Log.d("SR (currPassword): ", currPassword);
                                            Log.d("SR (currAdminFlag): ", currAdminFlag.toString());
                                            Log.d("SR (currSuspendFlag): ", currSuspendFlag.toString());
                                            Log.d("SR (currCurrency): ", currCurrency.toString());
                                            Log.d("SR (currLeaderFlag): ", currLeaderFlag.toString());
                                            Log.d("SR (currHigh): ", currHigh.toString());
                                            Log.d("SR (currLow): ", currLow.toString());
                                            Log.d("SR (currRecent): ", currRecent.toString());
                                            Log.d("SR (currTotal): ", currTotal.toString());

                                            MainMenu.currUser = new CurrentUser(currID, currName,
                                                    currUserName, currEmail, currPassword, currAdminFlag, currSuspendFlag,
                                                    currCurrency, currLeaderFlag, currHigh, currLow, currRecent, currTotal);
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

                } else {
                    String toastMessage = "Username or Password are not populated.";
                    Toast.makeText(getApplicationContext(), toastMessage, Toast.LENGTH_SHORT).show();
                }
            }
        });

        rememberMe.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(CompoundButton compoundButton, boolean b) {

                if(compoundButton.isChecked()) {
                    SharedPreferences pref = getSharedPreferences("checkbox", MODE_PRIVATE);
                    SharedPreferences.Editor editor = pref.edit();
                    editor.putString("remember", "true");
                    editor.apply();
                } else {
                    SharedPreferences pref = getSharedPreferences("checkbox", MODE_PRIVATE);
                    SharedPreferences.Editor editor = pref.edit();
                    editor.putString("remember", "false");
                    editor.apply();
                }
            }
        });

        registerButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                openRegister();
            }
        });

    }

    //public LoginHome(Context context){

    //}

    public String validate(String userName, String password)
    {
        if(userName.equals("user") && password.equals("user"))
            return "Login was successful";
        else
            return "Invalid login!";
    }

    public void openMainMenu() {
        Intent intent = new Intent(this, MainMenu.class);
        intent.putExtra("username", user);
        startActivity(intent);
        overridePendingTransition(android.R.anim.fade_in, android.R.anim.fade_out);
    }

    public void openRegister() {
        Intent intent = new Intent(this, Register.class);
        startActivity(intent);
        overridePendingTransition(android.R.anim.fade_in, android.R.anim.fade_out);
    }
}