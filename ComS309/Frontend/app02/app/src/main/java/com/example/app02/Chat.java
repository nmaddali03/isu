package com.example.app02;

import android.content.Intent;
import android.content.res.ColorStateList;
import android.media.MediaPlayer;
import android.os.Bundle;
import android.util.Log;
import android.view.Display;
import android.view.Gravity;
import android.view.KeyEvent;
import android.view.View;
import android.view.WindowManager;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.ScrollView;
import android.widget.TextView;

import androidx.appcompat.app.AppCompatActivity;

import com.google.android.material.textfield.TextInputLayout;

import org.java_websocket.WebSocket;
import org.java_websocket.client.WebSocketClient;
import org.java_websocket.drafts.Draft;
import org.java_websocket.handshake.ServerHandshake;

import java.net.URI;
import java.net.URISyntaxException;


public class Chat extends AppCompatActivity {
    private ImageView foreground;
    private MediaPlayer menuMusic;
    private Intent intentItems;
    private String setBG;
    private ImageView gradientBG;
    private LinearLayout sun;
    private Intent intent;
    private String user;
    private ScrollView scroll;
    private boolean keyboardOpen;
    private String friend;
    private TextView friendName;

    private ChatMessages newChat;

    WebSocket ws;
    WebSocketClient cc;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.chat);

        intentItems = new Intent(this, MainMenu.class);

        //get previous intent
        intent = getIntent();
        setBG = intent.getStringExtra("setBG");
        friend = intent.getStringExtra("friend");

        //get user from previous intent
        user = CurrentUser.getUserName();

        //get time when music in last intent ended
        int [] timeStamp = intent.getIntArrayExtra("timeStamp");

        //start music
        menuMusic = MediaPlayer.create(Chat.this, R.raw.menutheme);
        menuMusic.setLooping(true);
        menuMusic.seekTo(timeStamp[0]);
        menuMusic.start();

        sun = findViewById(R.id.sun);

        friendName = findViewById(R.id.friendName);
        friendName.setText(friend);

        ImageView fastCloud = findViewById(R.id.fastCloud);
        ImageView mediumCloud = findViewById(R.id.mediumCloud);
        ImageView slowCloud = findViewById(R.id.slowCloud);

        EditText newMessage = findViewById(R.id.newMessage);

        RelativeLayout bgLayout = findViewById(R.id.bgLayout);

        foreground = findViewById(R.id.foreground);

        LinearLayout writeMessage = findViewById(R.id.writeMessage);
        writeMessage.setGravity(Gravity.BOTTOM);

        gradientBG = new ImageView(this);

        WindowManager windowManager = getWindowManager();
        Display display = windowManager.getDefaultDisplay();

        //set background
        DynamicBackground bg = new DynamicBackground(gradientBG, foreground, null, fastCloud, mediumCloud, slowCloud,
                sun, null, bgLayout, display, setBG, null);
        bg.setBackground2();

        LinearLayout messages = findViewById(R.id.messages);

        ColorStateList white = ColorStateList.valueOf(this.getResources().getColor(R.color.white));
        newChat = new ChatMessages(this, user, friend, white, messages);
        //newChat.setChat();

        TextInputLayout textLayout = findViewById(R.id.textLayout);

        keyboardOpen = false;
        scroll = findViewById(R.id.scroll);
        scroll.smoothScrollTo(0, scroll.getHeight());

        //if textEdit is clicked, scroll down, and move textEdit up
        newMessage.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                scroll.smoothScrollTo(0, scroll.getChildAt(0).getHeight());
                keyboardOpen = true;
                //ToDo
            }
        });

        //check for certain key being pressed
        newMessage.setOnKeyListener(new View.OnKeyListener() {
            @Override
            public boolean onKey(View textView, int actionId, KeyEvent keyEvent) {
                //if any key is pressed, keyboard will open if it isn't
                if(scroll.getScrollY() != scroll.getChildAt(0).getHeight()){
                    scroll.smoothScrollTo(0, scroll.getChildAt(0).getHeight());
                }
                if(!keyboardOpen){
                    keyboardOpen = true;
                    //ToDo
                }
                //if Enter key is pressed, send new message
                if ((keyEvent.getAction() == KeyEvent.ACTION_DOWN)&&(actionId == KeyEvent.KEYCODE_ENTER)) {
                    newChat.sendMessage(newMessage, messages);
                    newMessage.setText("");
                    return true;
                }
                return false;
            }
        });
        ImageButton exitBtn = findViewById(R.id.exit);
        exitBtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                openMainMenu();
            }
        });

    }
    public void openMainMenu() {
        int[] timeStamp = new int[1];
        timeStamp[0] = menuMusic.getCurrentPosition();
        menuMusic.stop();
        Intent intentMenu = new Intent(this, MainMenu.class);
        timeStamp[0] = menuMusic.getCurrentPosition();
        intentMenu.putExtra("timeStamp", timeStamp);
        intentMenu.putExtra("setBG", setBG);
        intentMenu.putExtra("user", user);
        startActivity(intentMenu);
    }

    public boolean validFriend(String friend, String username){
        if(username == friend){
            return false;
        }
        return true;
    }
}