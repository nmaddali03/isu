package com.example.app02;

import org.json.JSONException;
import org.json.JSONObject;
import org.junit.Assert;
import org.junit.Before;
import org.junit.Rule;
import org.junit.Test;
import org.mockito.junit.MockitoJUnit;
import org.mockito.junit.MockitoRule;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;

public class GETResponseTest {

    @Rule public MockitoRule mockitoRule = MockitoJUnit.rule();


    @Test
    public void getResponseTest_returnsTrue() throws JSONException {
        //This creates a Mock Object of the class that we have not fully implemented
        LoginHandler test = mock(LoginHandler.class);
        LoginHome testLogInSuccess = new LoginHome();

        //These are the parameters to the function that we have not yet implemented in the class LoginHandler
        String usernameCorrect = "maisyTest";
        String passwordCorrect = "maisy";

        //We are expecting a JSONObject response from the server that represents whether or not the username matches the password
        JSONObject response = new JSONObject();

    /*In this simulated instance, the response from the server is a JSONObject "loginSuccess",
    with a boolean value "true" because the login was a success
     */
        response.put("loginSuccess",new Boolean (true));

    /*This line specifies the behavior of the getResponse method from LoginHandler that currently returns null
        You can think of it as overriding the behavior of the function and forcing it to return a specific value
        In the following line, we are forcing this unimplemented method to return our predefined variable "response"
     */
        when(test.getResponse(usernameCorrect,passwordCorrect)).thenReturn(response);

        Assert.assertEquals(testLogInSuccess.tryLogin(usernameCorrect,passwordCorrect,test),response.getBoolean("loginSuccess"));
    }
    @Test
    public void getResponseTest_returnsFalse() throws JSONException {
        //This creates a Mock Object of the class that we have not fully implemented
        LoginHandler test = mock(LoginHandler.class);
        LoginHome testLogin = new LoginHome();

        //These are the parameters to the function that we have not yet implemented in the class LoginHandler
        String usernameFail = "root";
        String passwordFail = "notsecure";

        //We are expecting a JSONObject response from the server that represents whether or not the username matches the password
        JSONObject response = new JSONObject();

        /*In this simulated instance, the response from the server is a JSONObject "loginSuccess",
        with a boolean value "false" because the login failed
         */
        response.put("loginSuccess",new Boolean (false));

        /*This line specifies the behavior of the getResponse method from LoginHandler that currently returns null
            You can think of it as overriding the behavior of the function and forcing it to return a specific value
            In the following line, we are forcing this unimplemented method to return our predefined variable "response"
         */
        when(test.getResponse(usernameFail,passwordFail)).thenReturn(response);

        Assert.assertEquals(testLogin.tryLogin(usernameFail,passwordFail,test),response.getBoolean("loginSuccess"));

    }


}

