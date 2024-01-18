package com.example.net_utils;

import android.util.Log;

import com.android.volley.AuthFailureError;
import com.android.volley.Request;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.VolleyLog;
import com.android.volley.toolbox.JsonObjectRequest;
import com.example.app02.AppController;
import com.example.app02.CurrentUser;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.UnsupportedEncodingException;
import java.util.HashMap;
import java.util.Map;

public class NetworkCalls {
    public static final String URL_JSON_USERS = "http://coms-309-037.cs.iastate.edu:8080/users";
    public static final String URL_JSON_CREATE_USER = "http://coms-309-037.cs.iastate.edu:8080/createUser";
    public static final String URL_JSON_SCORE = "http://coms-309-037.cs.iastate.edu:8080/score";
    public static final String URL_POSTMAN_TEST = "https://8dc2542d-3327-44bc-be29-a795f5888a6a.mock.pstmn.io";

    public static String updateScore(int userID, int updatedScore) {
        return URL_JSON_SCORE + "/" + userID + "/new/" + updatedScore;
    }
    
    public static void updateScore(int id, int low, int high, int recent) throws JSONException {
        String updatedURL = URL_JSON_SCORE + "/" + id;

        JSONObject dataToBeSent = new JSONObject();
        dataToBeSent.put("id", id);
        dataToBeSent.put("low", low);
        dataToBeSent.put("high", high);
        dataToBeSent.put("recent", recent);
        final String requestBody = dataToBeSent.toString();

        JsonObjectRequest jsonObjReq = new JsonObjectRequest(Request.Method.PUT,
                updatedURL, dataToBeSent,
                new Response.Listener<JSONObject>() {

                    @Override
                    public void onResponse(JSONObject response) {
                        Log.d("SR (Resp. Success): ", response.toString());
                    }
                }, new Response.ErrorListener() {

            @Override
            public void onErrorResponse(VolleyError error) {
                Log.d("SR (Resp. Error): ", error.getMessage());

            }
        }) {

            @Override
            public String getBodyContentType() {
                return "application/json";
            }

            @Override
            public byte[] getBody() {
                try {
                    return requestBody == null ? null : requestBody.getBytes("utf-8");
                } catch (UnsupportedEncodingException e) {
                    VolleyLog.wtf("Unsupported Encoding (utf-8): %s", requestBody);
                    return null;
                }
            }

            // Request Headers
            @Override
            public Map<String, String> getHeaders() throws AuthFailureError {
                HashMap<String, String> headers = new HashMap<String, String>();
                headers.put("Content-Type", "application/json");
                return headers;
            }
        };

        AppController.getInstance().addToRequestQueue(jsonObjReq);
    }

    public static void sendScore(int score) throws JSONException {
        CurrentUser.setRecent(score);
        int highScore = CurrentUser.getHigh();
        if (highScore < score){
            highScore = score;
            CurrentUser.setHigh(highScore);
        }
        int userID = CurrentUser.getId();;
        NetworkCalls.updateScore(userID, 0, highScore, score);
    }

    public static void updateCurrency(int update) throws JSONException {
        String updatedUser = URL_JSON_USERS + "/" + CurrentUser.getId();
         int currency = update + CurrentUser.getCurrency();
         CurrentUser.setCurrency(currency);
        JSONObject score = new JSONObject();
        score.put("id", CurrentUser.getId());
        score.put("low", CurrentUser.getLow());
        score.put("high", CurrentUser.getHigh());
        score.put("total", CurrentUser.getTotal());
        score.put("recent", CurrentUser.getRecent());

        JSONObject dataToBeSent = new JSONObject();

        dataToBeSent.put("id", CurrentUser.getId());
        dataToBeSent.put("name", CurrentUser.getName());
        dataToBeSent.put("userName", CurrentUser.getUserName());
        dataToBeSent.put("email", CurrentUser.getEmail());
        dataToBeSent.put("password", CurrentUser.getPassword());
        dataToBeSent.put("admin", CurrentUser.isAdmin());
        dataToBeSent.put("currency", currency);
        dataToBeSent.put("score", score);

        final String requestBody = dataToBeSent.toString();

        JsonObjectRequest jsonObjReq = new JsonObjectRequest(Request.Method.PUT,
                updatedUser, dataToBeSent,
                new Response.Listener<JSONObject>() {

                    @Override
                    public void onResponse(JSONObject response) {
                        Log.d("SR (Resp. Success): ", response.toString());
                    }
                }, new Response.ErrorListener() {

            @Override
            public void onErrorResponse(VolleyError error) {
                Log.d("SR (Resp. Error): ", error.getMessage());

            }
        }) {

            @Override
            public String getBodyContentType() {
                return "application/json";
            }

            @Override
            public byte[] getBody() {
                try {
                    return requestBody == null ? null : requestBody.getBytes("utf-8");
                } catch (UnsupportedEncodingException e) {
                    VolleyLog.wtf("Unsupported Encoding (utf-8): %s", requestBody);
                    return null;
                }
            }

            // Request Headers
            @Override
            public Map<String, String> getHeaders() throws AuthFailureError {
                HashMap<String, String> headers = new HashMap<String, String>();
                headers.put("Content-Type", "application/json");
                return headers;
            }
        };
        AppController.getInstance().addToRequestQueue(jsonObjReq);
    }

    public static String createUser(String name, String email, String username, String password) {
        return URL_JSON_CREATE_USER + "?name=" + name + "&email=" + email + "&username=" + username + "&password=" + password;
    }

    public static void updateUserEmail(String email) throws JSONException {
        String updatedUser = URL_JSON_USERS + "/" + CurrentUser.getId();
        CurrentUser.setEmail(email);

        JSONObject score = new JSONObject();
        score.put("id", CurrentUser.getId());
        score.put("low", CurrentUser.getLow());
        score.put("high", CurrentUser.getHigh());
        score.put("total", CurrentUser.getTotal());
        score.put("recent", CurrentUser.getRecent());

        JSONObject dataToBeSent = new JSONObject();

        dataToBeSent.put("id", CurrentUser.getId());
        dataToBeSent.put("name", CurrentUser.getName());
        dataToBeSent.put("userName", CurrentUser.getUserName());
        dataToBeSent.put("email", email);
        dataToBeSent.put("password", CurrentUser.getPassword());
        dataToBeSent.put("admin", CurrentUser.isAdmin());
        dataToBeSent.put("currency", CurrentUser.getCurrency());
        dataToBeSent.put("score", score);

        final String requestBody = dataToBeSent.toString();

        JsonObjectRequest jsonObjReq = new JsonObjectRequest(Request.Method.PUT,
                updatedUser, dataToBeSent,
                new Response.Listener<JSONObject>() {

                    @Override
                    public void onResponse(JSONObject response) {
                        Log.d("SR (Resp. Success): ", response.toString());
                    }
                }, new Response.ErrorListener() {

            @Override
            public void onErrorResponse(VolleyError error) {
                Log.d("SR (Resp. Error): ", error.getMessage());

            }
        }) {

            @Override
            public String getBodyContentType() {
                return "application/json";
            }

            @Override
            public byte[] getBody() {
                try {
                    return requestBody == null ? null : requestBody.getBytes("utf-8");
                } catch (UnsupportedEncodingException e) {
                    VolleyLog.wtf("Unsupported Encoding (utf-8): %s", requestBody);
                    return null;
                }
            }

            // Request Headers
            @Override
            public Map<String, String> getHeaders() throws AuthFailureError {
                HashMap<String, String> headers = new HashMap<String, String>();
                headers.put("Content-Type", "application/json");
                return headers;
            }
        };

        AppController.getInstance().addToRequestQueue(jsonObjReq);
    }

    public static void updateUserName(String username) throws JSONException {
        String updatedUser = URL_JSON_USERS + "/" + CurrentUser.getId();
        CurrentUser.setUserName(username);

        JSONObject score = new JSONObject();
        score.put("id", CurrentUser.getId());
        score.put("low", CurrentUser.getLow());
        score.put("high", CurrentUser.getHigh());
        score.put("total", CurrentUser.getTotal());
        score.put("recent", CurrentUser.getRecent());

        JSONObject dataToBeSent = new JSONObject();

        dataToBeSent.put("id", CurrentUser.getId());
        dataToBeSent.put("name", CurrentUser.getName());
        dataToBeSent.put("userName", username);
        dataToBeSent.put("email", CurrentUser.getEmail());
        dataToBeSent.put("password", CurrentUser.getPassword());
        dataToBeSent.put("admin", CurrentUser.isAdmin());
        dataToBeSent.put("currency", CurrentUser.getCurrency());
        dataToBeSent.put("score", score);

        final String requestBody = dataToBeSent.toString();

        JsonObjectRequest jsonObjReq = new JsonObjectRequest(Request.Method.PUT,
                updatedUser, dataToBeSent,
                new Response.Listener<JSONObject>() {

                    @Override
                    public void onResponse(JSONObject response) {
                        Log.d("SR (Resp. Success): ", response.toString());
                    }
                }, new Response.ErrorListener() {

            @Override
            public void onErrorResponse(VolleyError error) {
                Log.d("SR (Resp. Error): ", error.getMessage());

            }
        }) {

            @Override
            public String getBodyContentType() {
                return "application/json";
            }

            @Override
            public byte[] getBody() {
                try {
                    return requestBody == null ? null : requestBody.getBytes("utf-8");
                } catch (UnsupportedEncodingException e) {
                    VolleyLog.wtf("Unsupported Encoding (utf-8): %s", requestBody);
                    return null;
                }
            }

            // Request Headers
            @Override
            public Map<String, String> getHeaders() throws AuthFailureError {
                HashMap<String, String> headers = new HashMap<String, String>();
                headers.put("Content-Type", "application/json");
                return headers;
            }
        };

        AppController.getInstance().addToRequestQueue(jsonObjReq);
    }

    public static void updatePassword(String password) throws JSONException {
        String updatedUser = URL_JSON_USERS + "/" + CurrentUser.getId();
        CurrentUser.setPassword(password);

        JSONObject score = new JSONObject();
        score.put("id", CurrentUser.getId());
        score.put("low", CurrentUser.getLow());
        score.put("high", CurrentUser.getHigh());
        score.put("total", CurrentUser.getTotal());
        score.put("recent", CurrentUser.getRecent());

        JSONObject dataToBeSent = new JSONObject();

        dataToBeSent.put("id", CurrentUser.getId());
        dataToBeSent.put("name", CurrentUser.getName());
        dataToBeSent.put("userName", CurrentUser.getUserName());
        dataToBeSent.put("email", CurrentUser.getEmail());
        dataToBeSent.put("password", password);
        dataToBeSent.put("admin", CurrentUser.isAdmin());
        dataToBeSent.put("currency", CurrentUser.getCurrency());
        dataToBeSent.put("score", score);

        final String requestBody = dataToBeSent.toString();

        JsonObjectRequest jsonObjReq = new JsonObjectRequest(Request.Method.PUT,
                updatedUser, dataToBeSent,
                new Response.Listener<JSONObject>() {

                    @Override
                    public void onResponse(JSONObject response) {
                        Log.d("SR (Resp. Success): ", response.toString());
                    }
                }, new Response.ErrorListener() {

            @Override
            public void onErrorResponse(VolleyError error) {
                Log.d("SR (Resp. Error): ", error.getMessage());

            }
        }) {

            @Override
            public String getBodyContentType() {
                return "application/json";
            }

            @Override
            public byte[] getBody() {
                try {
                    return requestBody == null ? null : requestBody.getBytes("utf-8");
                } catch (UnsupportedEncodingException e) {
                    VolleyLog.wtf("Unsupported Encoding (utf-8): %s", requestBody);
                    return null;
                }
            }

            // Request Headers
            @Override
            public Map<String, String> getHeaders() throws AuthFailureError {
                HashMap<String, String> headers = new HashMap<String, String>();
                headers.put("Content-Type", "application/json");
                return headers;
            }
        };

        AppController.getInstance().addToRequestQueue(jsonObjReq);
    }
}


