package com.example.net_utils;

import android.util.Log;
import android.widget.Toast;

import com.android.volley.AuthFailureError;
import com.android.volley.Request;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.VolleyLog;
import com.android.volley.toolbox.JsonArrayRequest;
import com.android.volley.toolbox.JsonObjectRequest;
import com.example.app02.AppController;
import com.example.app02.CurrentUser;
import com.example.app02.MainMenu;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.UnsupportedEncodingException;
import java.util.HashMap;
import java.util.Map;

// Todo: AppController (RequestQueue) makes asynchronous calls.. this is why total is behaving weird (only sometimes updates). Way to make synchronous with RequestFuture

/**
 * Contains abstracted methods which help front-end to back-end (and vice-versa) communication.
 */
public class NetworkCalls {

    public static final String URL_JSON_USERS = "http://coms-309-037.cs.iastate.edu:8080/users";
    public static final String URL_JSON_CREATE_TEAM = "http://coms-309-037.cs.iastate.edu:8080/team";
    public static final String URL_JSON_CREATE_USER = "http://coms-309-037.cs.iastate.edu:8080/createUser";
    public static final String URL_JSON_SCORE = "http://coms-309-037.cs.iastate.edu:8080/score";
    public static final String URL_POSTMAN_TEST = "https://8dc2542d-3327-44bc-be29-a795f5888a6a.mock.pstmn.io";

    // Defunct Methods
    /*
    public static String updateScore(int userID, int updatedScore) {
        return URL_JSON_SCORE + "/" + userID + "/new/" + updatedScore;
    }
     */

    /*
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
     */


    /**
     * Updates the remote state on the server for the current user's score.
     * @throws JSONException Thrown to indicate a problem with the JSON API.
     */
    public static void updateCurrentScoreRemoteState() throws JSONException {
        String updatedURL = URL_JSON_SCORE + "/" + MainMenu.currUser.getId() + "/" + MainMenu.currUser.getRecent();

        JSONObject dataToBeSent = new JSONObject();
        dataToBeSent.put("id", MainMenu.currUser.getId());
        dataToBeSent.put("low", MainMenu.currUser.getLow());
        dataToBeSent.put("high", MainMenu.currUser.getHigh());
        dataToBeSent.put("total", MainMenu.currUser.getTotal());
        dataToBeSent.put("recent", MainMenu.currUser.getRecent());
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

    /**
     * Updates remote current user state with what is stored in MainMenu.currUser object.
     * The idea is that front end only needs to make updates to the local state of the current user (that is, MainMenu.currUser),
     * and when they want to set those changes to match the database, they need only call this method.
     * @throws JSONException Thrown to indicate a problem with the JSON API.
     */
    public static void updateCurrentUserRemoteState() throws JSONException {
        String updatedURL = URL_JSON_USERS + "/" + MainMenu.currUser.getId();

        /*
        Note to self: You will need to add each field relevant to user in this as features keep
        being added; otherwise, null values will propagate on database.
         */

        JSONObject score = new JSONObject();
        score.put("id", MainMenu.currUser.getId());
        score.put("low", MainMenu.currUser.getLow());
        score.put("high", MainMenu.currUser.getHigh());
        score.put("total", MainMenu.currUser.getTotal());
        score.put("recent", MainMenu.currUser.getRecent());

        JSONObject dataToBeSent = new JSONObject();
        dataToBeSent.put("id", MainMenu.currUser.getId());
        dataToBeSent.put("name", MainMenu.currUser.getName());
        dataToBeSent.put("userName", MainMenu.currUser.getUserName());
        dataToBeSent.put("email", MainMenu.currUser.getEmail());
        dataToBeSent.put("password", MainMenu.currUser.getPassword());
        dataToBeSent.put("admin", MainMenu.currUser.isAdmin());
        dataToBeSent.put("leader", MainMenu.currUser.isLeader());
        dataToBeSent.put("currency", MainMenu.currUser.getCurrency());
        dataToBeSent.put("score", score);

        final String requestBody = dataToBeSent.toString();

        JsonObjectRequest jsonObjReq = new JsonObjectRequest(Request.Method.PUT,
                updatedURL, dataToBeSent,
                new Response.Listener<JSONObject>() {

                    @Override
                    public void onResponse(JSONObject response) {

                        /*
                        SR stands for Server Response.
                         */
                        Log.d("SR (local->remote): ", response.toString());
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

    /**
     * Updates local current user state with what is stored in the remotely on the database.
     * @throws JSONException Thrown to indicate a problem with the JSON API.
     */
    public static void updateCurrentUserLocalState() throws JSONException {
        String updatedURL = URL_JSON_USERS + "/" + MainMenu.currUser.getId();

        JsonObjectRequest jsonObjReq = new JsonObjectRequest(
                Request.Method.GET,
                updatedURL,
                null,
                new Response.Listener<JSONObject>() {
                    @Override
                    public void onResponse(JSONObject response) {
                        try {

                            Integer currID = response.getInt("id");
                            String currName = response.getString("name");
                            String currUserName = response.getString("userName");
                            String currEmail = response.getString("email");
                            String currPassword = response.getString("password");
                            Boolean currAdminFlag = response.getBoolean("admin");
                            Boolean currLeader = response.getBoolean("leader");
                            Integer currCurrency = response.getInt("currency");
                            Integer currHigh = response.getJSONObject("score").getInt("high");
                            Integer currLow = response.getJSONObject("score").getInt("low");
                            Integer currRecent = response.getJSONObject("score").getInt("recent");
                            Integer currTotal = response.getJSONObject("score").getInt("total");

                            /*
                            SR stands for Server Response.
                             */
                            Log.d("SR (remote->local): ", response.toString());

                            MainMenu.currUser.setId(currID);
                            MainMenu.currUser.setName(currName);
                            MainMenu.currUser.setUserName(currUserName);
                            MainMenu.currUser.setEmail(currEmail);
                            MainMenu.currUser.setPassword(currPassword);
                            MainMenu.currUser.setAdmin(currAdminFlag);
                            MainMenu.currUser.setLeader(currLeader);
                            MainMenu.currUser.setCurrency(currCurrency);
                            MainMenu.currUser.setHigh(currHigh);
                            MainMenu.currUser.setLow(currLow);
                            MainMenu.currUser.setRecent(currRecent);
                            MainMenu.currUser.setTotal(currTotal);

                            /*
                            Print out current user local values. LR stands for Local Response.
                             */
                            Log.d("LR", "Current user has the following values locally.");
                            Log.d("userID: ", MainMenu.currUser.getId().toString());
                            Log.d("currName: ", MainMenu.currUser.getName());
                            Log.d("currUserName: ", MainMenu.currUser.getUserName());
                            Log.d("currEmail: ", MainMenu.currUser.getEmail());
                            Log.d("currPassword: ", MainMenu.currUser.getPassword());
                            Log.d("currAdminFlag: ", MainMenu.currUser.isAdmin().toString());
                            Log.d("currLeader: ", MainMenu.currUser.isLeader().toString());
                            Log.d("currCurrency: ", MainMenu.currUser.getCurrency().toString());
                            Log.d("currHigh: ", MainMenu.currUser.getHigh().toString());
                            Log.d("currLow: ", MainMenu.currUser.getLow().toString());
                            Log.d("currRecent: ", MainMenu.currUser.getRecent().toString());
                            Log.d("currTotal: ", MainMenu.currUser.getTotal().toString());

                        } catch (JSONException e) {
                            e.printStackTrace();
                        }
                    }
                },
                new Response.ErrorListener() {
                    @Override
                    public void onErrorResponse(VolleyError error) {
                        Log.d("Server Response ", error.toString());

                    }
                }
        );

        AppController.getInstance().addToRequestQueue(jsonObjReq);
    }

    /**
     * Sets current state of user's currency. Calls local->remote update.
     * @param update Currency to add.
     * @throws JSONException Thrown to indicate a problem with the JSON API.
     */
    public static void updateCurrency(int update) throws JSONException {
        int currency = update + MainMenu.currUser.getCurrency();
        MainMenu.currUser.setCurrency(currency);
        updateCurrentUserRemoteState();
    }

    /**
     * Sets current state of user's leader status. Calls local->remote update.
     * @param update Leader to update.
     * @throws JSONException Thrown to indicate a problem with the JSON API.
     */
    public static void updateLeader(boolean update) throws JSONException {
        MainMenu.currUser.setLeader(update);
        updateCurrentUserRemoteState();
    }

    public static void updateSuspended(CurrentUser suspendUser, Boolean suspend) {

    }

    /**
     * Sets current state of user's score. Calls local->remote update.
     * Note: High and total scores have logic on backend to update automatically.
     * @param low Low score for the user.
     * @param recent Score from most recently played game.
     * @throws JSONException Thrown to indicate a problem with the JSON API.
     */
    public static void updateScore(int low, int recent) throws JSONException {
        MainMenu.currUser.setLow(low);
        MainMenu.currUser.setRecent(recent);
        updateCurrentScoreRemoteState();

        /*
        This is called because remote has logic to update high and total; therefore,
        remote and local values will differ. So we call for an update to the local state.

        Although network calls are done asynchronously (thanks android) so this does f*** all.
         */
        updateCurrentUserLocalState();
    }

    /**
     * Creates a user in the database.
     * @param name Chosen name by user.
     * @param email Chosen email by user.
     * @param username Chosen username by user.
     * @param password Chosen password by user.
     * @return String which contains properly formatted URL to be called to create a user.
     */
    public static String createUser(String name, String email, String username, String password) {
        return URL_JSON_CREATE_USER + "?name=" + name + "&email=" + email + "&username=" + username + "&password=" + password;
    }

    // Add comments after testing
    public static String createTeam(String name, Integer lid) {
        return URL_JSON_CREATE_TEAM + "/" + name + "/" + lid;
    }

    /**
     * Sets current state of user's email. Calls local->remote update.
     * @param email New email to set.
     * @throws JSONException Thrown to indicate a problem with the JSON API.
     */
    public static void updateUserEmail(String email) throws JSONException {
        MainMenu.currUser.setEmail(email);
        updateCurrentUserRemoteState();
    }

    /**
     * Sets current state of user's username. Calls local->remote update.
     * @param username New username to set.
     * @throws JSONException Thrown to indicate a problem with the JSON API.
     */
    public static void updateUserName(String username) throws JSONException {
        MainMenu.currUser.setUserName(username);
        updateCurrentUserRemoteState();
    }

    /**
     * Sets current state of user's password. Calls local->remote update.
     * @param password New password to set.
     * @throws JSONException Thrown to indicate a problem with the JSON API.
     */
    public static void updatePassword(String password) throws JSONException {
        MainMenu.currUser.setPassword(password);
        updateCurrentUserRemoteState();
    }


}

