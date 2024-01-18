package com.example.app02;

import android.content.Intent;
import android.content.res.ColorStateList;
import android.media.MediaPlayer;
import android.os.Bundle;
import android.view.Display;
import android.view.Gravity;
import android.view.KeyEvent;
import android.view.View;
import android.view.WindowManager;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.ScrollView;

import androidx.appcompat.app.AppCompatActivity;

import com.google.android.material.textfield.TextInputLayout;


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

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.chat);

        intentItems = new Intent(this, MainMenu.class);

        //get previous intent
        intent = getIntent();

        //get user from previous intent
        user = intent.getStringExtra("username");

        //get time when music in last intent ended
        int [] timeStamp = intent.getIntArrayExtra("timeStamp");

        //start music
        menuMusic = MediaPlayer.create(Chat.this, R.raw.menutheme);
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
        bg.setBackground();

        LinearLayout messages = findViewById(R.id.messages);

        ColorStateList white = ColorStateList.valueOf(this.getResources().getColor(R.color.white));

        ChatMessages newChat = new ChatMessages(this, user, white);
        newChat.setChat(messages);

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

    }
}