package com.example.app02;

import android.content.res.ColorStateList;
import android.view.Gravity;
import android.view.View;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.TextView;

public class ChatMessages {
    private String user;
    private ColorStateList white;
    private Chat context;

    /**
     * Constructor for Chat Messages
     * @param context
     * @param user
     * @param white
     */
    public ChatMessages(Chat context, String user, ColorStateList white){
        this.context = context;
        this.user = user;
        this.white = white;
    }

    /**
     * Sets up existing chat messages
     * @param messages
     */
    public void setChat(LinearLayout messages){
        // get array from database
        //JsonObjectRequest request = new JsonObjectRequest(Request.Method.GET, url, null, new Response.Listener<JSONObject>();
        //find number of messages

        String [][] testMessages = new String[6][2];
        testMessages[0][0] = "recipient";
        testMessages[0][1] = "Hello World!";
        testMessages[1][0] = user;
        testMessages[1][1] = "How are you?";
        testMessages[2][0] = user;
        testMessages[2][1] = "Are you good?";
        testMessages[3][0] = "recipient";
        testMessages[3][1] = "I am doing well, thx!";
        testMessages[4][0] = "recipient";
        testMessages[4][1] = "How bout u?";
        testMessages[5][0] = user;
        testMessages[5][1] = "I'm good! :)";

        //array with last 100 messages
        //String [][] messagesArr = new String[99][1];

        //get user (sender) from database
        //String user = null;

        //go through array and add messages to page
        for(int messageNum = 0; messageNum < testMessages.length; messageNum++){
            int userInArray = 0;
            int messageInArray = 1;

            //get user from messages Array
            String username = testMessages[messageNum][userInArray];
            String message = testMessages[messageNum][messageInArray];

            // if the text is from the current user, create corresponding sent chat bubble
            if(username.equals(user)){
                createSenderMessage(message, messages);
            }

            // if the text is not from the current user, create corresponding received chat bubble
            else{
                createReceivedMessage(message, messages);
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

        //send message to server

        //add message onto page
        createSenderMessage(message, messages);

        //remove top message
        removeTopMessage();
    }

    /**
     * Receives a message
     * @param t
     * @param messages
     */
    public void receiveMessage(boolean t, LinearLayout messages){
        //check for new message on database
        if(t){
            String message = "Hello";
            //add message onto page
            createReceivedMessage(message, messages);
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
        messages.setHorizontalGravity(Gravity.LEFT);
        chatBubble.setLayoutParams(bubble);

        //set text parameters for received chat bubble
        text.setTextAlignment(View.TEXT_ALIGNMENT_VIEW_END);

        //put message into bubble
        chatBubble.addView(text);

        //put bubble into messages linear layout (inside scroll)
        messages.addView(chatBubble);
    }

    /**
     * Removes old messages
     */
    public void removeTopMessage(){

    }
}
