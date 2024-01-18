package com.example.app02;

import android.content.res.ColorStateList;
import android.util.Log;
import android.view.Gravity;
import android.view.View;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.TextView;

import org.java_websocket.client.WebSocketClient;
import org.java_websocket.drafts.Draft;
import org.java_websocket.drafts.Draft_6455;

import org.java_websocket.handshake.ServerHandshake;

import java.net.URI;
import java.net.URISyntaxException;

public class ChatMessages {
    private String user;
    private ColorStateList white;
    private Chat context;
    private WebSocketClient cc;
    private URI serverURI;
    private String rMessage;
    private static LinearLayout messagesLayout;
    private int i;
    private String friend;
    private String sMessage;
    private LinearLayout chatBubble2;
    private String message1;
    /**
     * Constructor for Chat Messages
     * @param context
     * @param user
     * @param white
     */
    public ChatMessages(Chat context, String user, String friend, ColorStateList white, LinearLayout messages){
        this.context = context;
        this.user = user;
        this.white = white;
        this.friend = friend;
        messagesLayout = messages;
        i = 0;
        try {
            webSocket();
        } catch (URISyntaxException e) {
            e.printStackTrace();
        }
    }

    // get array from database
        //JsonObjectRequest request = new JsonObjectRequest(Request.Method.GET, url, null, new Response.Listener<JSONObject>();
        //find number of messages
    public void setChat(){
        String newline = System.getProperty("line.separator");
        int j = 0;
        int m = 0;
        while(m != rMessage.length()){
            String s = ""+rMessage.charAt(i);
            if(s.contains(newline)) {
                j++;
            }
            m++;
        }
        m = 0;
        int k = 0;

        String s2 = "";
        String [] textMessages = new String[j];
        for(m = 0; m<rMessage.length()-1; m++){
            String s = ""+rMessage.charAt(m);
            if(s.contains(newline)){
                k++;
                s2 = "";
            }
            else{
                s2 += rMessage.charAt(i);
            }
            textMessages[k] = s2;
        }
        //go through array and add messages to page
        for(int messageNum = 0; messageNum < textMessages.length; messageNum++){

            //get user from messages Array
            String username = textMessages[messageNum].substring(0,friend.length());
            int split = friend.length() + CurrentUser.getUserName().length()+1;
            String message = "";
            if(username.equals(friend)){
                int size = textMessages[messageNum].length();
                message = textMessages[messageNum].substring(split-1, size);
            }
            // if the text is from the current user, create corresponding sent chat bubble
            if(username.equals(user)){
                createSenderMessage(message, messagesLayout);
            }

            // if the text is not from the current user, create corresponding received chat bubble
            if(username.equals(friend)){
                createReceivedMessage(message, messagesLayout);
            }
        }
    }

    /**
     * Sends a message
     * @param newMessage
     * @param messages
     */
    public void sendMessage(EditText newMessage, LinearLayout messages){
        //convert message to string
        String message = newMessage.getText().toString();
        String m = "@"+friend+" "+message;
        //send message to server
        try {
            cc.send(message);
        } catch (Exception e) {
            Log.d("ExceptionSendMessage:", e.getMessage().toString());
        }

        //add message onto page
        createSenderMessage(message, messages);

        //remove top message
        removeTopMessage();
    }

    /**
     * Receives a message
     */
    public void receiveMessage(){
        //check for new message on database\
        int split = friend.length() + CurrentUser.getUserName().length() + 9;
        String textMessage = rMessage.substring(0,split);
        if(textMessage.equals("[DM] "+ friend + ": @" + CurrentUser.getUserName() + " ")){
            message1 = rMessage.substring(split, rMessage.length());
            createReceivedMessage(message1, messagesLayout);
        }

        //remove top message from page
    }

    /**
     * Creates message bubble for sent message
     * @param message
     * @param messages
     */
    public void createSenderMessage(String message, LinearLayout messages){
        //add message to page
        //create chat bubble
        LinearLayout chatBubble = new LinearLayout(context);

        //set message
        TextView text = new TextView(context);
        text.setText(message);
        //set general/shared design and layout of bubble
        LinearLayout.LayoutParams bubble = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.WRAP_CONTENT, LinearLayout.LayoutParams.WRAP_CONTENT);
        text.setPadding(10,10,10,10);
        text.setTextColor(white);

        // if the text is from the current user, create corresponding sent chat bubble
        bubble.setMargins(300,10,15,10);
        bubble.gravity = Gravity.RIGHT;

        //LinearLayout.LayoutParams bubbleParams = new LinearLayout.LayoutParams(chatBubble.getLayoutParams());
        chatBubble.setBackgroundResource(R.drawable.sent_chat_bubble);
        chatBubble.setHorizontalGravity(Gravity.RIGHT);
        chatBubble.setLayoutParams(bubble);
        text.setTextAlignment(View.TEXT_ALIGNMENT_VIEW_START);

        //put message into bubble
        chatBubble.addView(text);

        //put bubble into messages linear layout (inside scroll)
        messages.addView(chatBubble);


    }

    /**
     * Creates bubble for received message
     * @param message
     * @param messages
     */
    public void createReceivedMessage(String message, LinearLayout messages){
        //add message to page
        //create chat bubble
        LinearLayout chatBubble = new LinearLayout(context);

        //set message
        TextView text = new TextView(context);
        text.setText(message);
        //set general/shared design and layout of bubble
        LinearLayout.LayoutParams bubble = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.WRAP_CONTENT, LinearLayout.LayoutParams.WRAP_CONTENT);
        text.setPadding(10,10,10,10);
        text.setTextColor(white);

        //set bubble shape and parameters for received chat bubble
        bubble.setMargins(15,10,300,10);
        bubble.gravity = Gravity.LEFT;
        chatBubble.setBackgroundResource(R.drawable.received_chat_bubble);
        chatBubble.setHorizontalGravity(Gravity.LEFT);
        //messages.setHorizontalGravity(Gravity.LEFT);
        chatBubble.setLayoutParams(bubble);

        //set text parameters for received chat bubble
        text.setTextAlignment(View.TEXT_ALIGNMENT_VIEW_END);

        //put message into bubble
        chatBubble.addView(text);

        //put bubble into messages linear layout (inside scroll)
        messages.addView(chatBubble);
        chatBubble2 = chatBubble;
    }

    public void addChat(){
        messagesLayout.addView(chatBubble2);
    }
    /**
     * Removes old messages
     */
    public void removeTopMessage(){

    }
    public void webSocket() throws URISyntaxException {
        //   -- WEBSOCKET --   \\

        String w = "ws://coms-309-037.cs.iastate.edu:8080/chat/" + CurrentUser.getUserName();
        try {
            serverURI = new URI(w);
        }
        catch (URISyntaxException e){
            e.printStackTrace();
            return;
        }

        Draft[] drafts = {
                new Draft_6455()
        };


        Log.d("Socket:", "Trying socket");
        cc = new WebSocketClient(new URI(w), (Draft) drafts[0])  {
            @Override
            public void onMessage(String message) {
                Log.d("", "run() returned: " + message);
                rMessage = message;
                //if(i == 0){
                    //i++;
                    //setChat();
               // }
                receiveMessage();
                //t1.setText(s + " Server:" + message);
            }

            @Override
            public void onOpen(ServerHandshake handshake) {
                Log.d("OPEN", "run() returned: " + "is connecting");
            }

            @Override
            public void onClose(int code, String reason, boolean remote) {
                Log.d("CLOSE", "onClose() returned: " + reason);
            }

            @Override
            public void onError(Exception e) {
                Log.d("Exception:", e.toString());
            }
        };
        cc.connect();
    }

    public void correctMessage(String message){

    }
}
