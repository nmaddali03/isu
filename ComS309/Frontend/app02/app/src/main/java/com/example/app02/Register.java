
package com.example.app02;

import static android.content.ContentValues.TAG;
import static com.example.net_utils.NetworkCalls.URL_JSON_USERS;
import static com.example.net_utils.NetworkCalls.URL_JSON_CREATE_USER;
import static com.example.net_utils.NetworkCalls.URL_POSTMAN_TEST;
import static com.example.net_utils.NetworkCalls.*;

import androidx.appcompat.app.AppCompatActivity;

import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Toast;

import com.android.volley.Network;
import com.android.volley.Request;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.VolleyLog;
import com.android.volley.toolbox.JsonObjectRequest;
import com.example.net_utils.NetworkCalls;

import org.json.JSONObject;

import java.util.HashMap;
import java.util.Map;

public class Register extends AppCompatActivity {

    private Button bRegister;
    private EditText nameEditText;
    private EditText emailEditText;
    private EditText usernameEditText;
    private EditText passwordEditText;
    private boolean isValidLogin = false;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_register);

        bRegister=findViewById(R.id.bRegister);
        nameEditText = findViewById(R.id.etName);
        emailEditText = findViewById(R.id.etEmail);
        usernameEditText = findViewById(R.id.etUsername);
        passwordEditText = findViewById(R.id.etPassword);

        bRegister.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v){
                if(usernameEditText.getText().length()>0&&passwordEditText.getText().length()>0&&nameEditText.getText().length()>0&&emailEditText.getText().length()>0){
                    String regUsername = usernameEditText.getText().toString();
                    String regPassword = passwordEditText.getText().toString();
                    String regName = nameEditText.getText().toString();
                    String regEmail = emailEditText.getText().toString();

                    String tag_json_obj = "json_obj_req";
                    //ProgressDialog pDialog = new ProgressDialog(this);
                    //pDialog.setMessage("Loading...");
                    //pDialog.show();



                    JsonObjectRequest jsonObjReq = new JsonObjectRequest(Request.Method.POST,
                            NetworkCalls.createUser(regName, regEmail, regUsername, regPassword), null,
                            new Response.Listener<JSONObject>() {
                                @Override
                                public void onResponse(JSONObject response) {
                                    Log.d(TAG, response.toString());
                                    //pDialog.hide();

                                    isValidLogin = checkCredentials(regEmail, regPassword);

                                    if(isValidLogin){
                                        openRegisterSuccessful();
                                    }


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

                    //openRegisterSuccessful();
                }else{
                    String toastMessage="One or more fields not populated.";
                    Toast.makeText(getApplicationContext(),toastMessage,Toast.LENGTH_SHORT).show();
                }
            }
        });

    }
    public void openRegisterSuccessful(){
        Intent intent = new Intent(this, RegisterSuccessful.class);
        startActivity(intent);
        overridePendingTransition(android.R.anim.fade_in, android.R.anim.fade_out);
    }

    public boolean checkCredentials(String email, String password) {
        // Declare variables
        boolean isValidEmail, isValidPassword;

        // Check for valid email
        isValidEmail = email.length() >= 8 && email.contains("@") && email.contains(".") && (email.indexOf("@") < email.indexOf('.'));
        // Check for valid password
        isValidPassword = password.length() >= 8;

        // Display invalid input messages
        if (!isValidEmail && isValidPassword)
        {
            // Invalid email
            Toast.makeText(getApplicationContext(), "Invalid email. Try again", Toast.LENGTH_LONG).show();
            return false;
        }
        else if (isValidEmail && !isValidPassword)
        {
            // Invalid password
            Toast.makeText(getApplicationContext(), "Invalid password. Try again", Toast.LENGTH_LONG).show();
            return false;
        }
        else if (!isValidEmail) // only have to check if email validity because of else ifs
        {
            // Invalid email and password
            Toast.makeText(getApplicationContext(), "Invalid email and password. Try again", Toast.LENGTH_LONG).show();
            return false;
        }
        else
        {
            // All valid credentials
            return true;
        }

    }
}