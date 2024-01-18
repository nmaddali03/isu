package com.example.app02;

import android.content.Intent;
import android.content.res.ColorStateList;
import android.media.MediaPlayer;
import android.os.Bundle;


import androidx.appcompat.app.AppCompatActivity;

import android.view.Display;
import android.view.Gravity;
import android.view.KeyEvent;
import android.view.View;
import android.view.WindowManager;
import android.widget.EditText;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;

public class messageConnect extends AppCompatActivity {
    private ImageView foreground;
    private MediaPlayer menuMusic;
    private Intent intentItems;
    private String setBG;
    private ImageView gradientBG;
    private LinearLayout sun;
    private Intent intent;
    private String user;
    private String friend;

    private ChatMessages newChat;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.message_connect);
        intentItems = new Intent(this, MainMenu.class);

        //get previous intent
        intent = getIntent();
        setBG = intent.getStringExtra("setBG");

        //get user from previous intent
        user = CurrentUser.getUserName();

        //get time when music in last intent ended
        int [] timeStamp = intent.getIntArrayExtra("timeStamp");

        //start music
        menuMusic = MediaPlayer.create(messageConnect.this, R.raw.menutheme);
        menuMusic.setLooping(true);
        menuMusic.seekTo(timeStamp[0]);
        menuMusic.start();

        sun = findViewById(R.id.sun);

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
        //check for certain key being pressed
        newMessage.setOnKeyListener(new View.OnKeyListener() {
            @Override
            public boolean onKey(View textView, int actionId, KeyEvent keyEvent) {
                //if Enter key is pressed, connect to chat
                if ((keyEvent.getAction() == KeyEvent.ACTION_DOWN)&&(actionId == KeyEvent.KEYCODE_ENTER)) {
                    friend = newMessage.getText().toString();
                    openChat(friend);
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
    public void openChat(String friend){
        int[] timeStamp = new int[1];
        timeStamp[0] = menuMusic.getCurrentPosition();
        menuMusic.stop();
        Intent intentChat = new Intent(this, Chat.class);
        timeStamp[0] = menuMusic.getCurrentPosition();
        intentChat.putExtra("timeStamp", timeStamp);
        intentChat.putExtra("username", user);
        intentChat.putExtra("friend", friend);
        menuMusic.stop();
        startActivity(intentChat);
        overridePendingTransition(android.R.anim.fade_in, android.R.anim.fade_out);
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
}