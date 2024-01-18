package com.example.app02;

import androidx.appcompat.app.AppCompatActivity;

import android.content.Intent;
import android.graphics.PorterDuff;
import android.media.MediaPlayer;
import android.os.Bundle;
import android.view.Display;
import android.view.View;
import android.view.WindowManager;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;

public class items extends AppCompatActivity {
    private ImageButton mountainsThumbnail;
    private ImageButton halloweenThumbnail;
    private ImageButton forestThumbnail;

    private MediaPlayer menuMusic;
    private Intent intentItems;
    private String setBG;

    private boolean mountainsClicked;
    private boolean halloweenClicked;
    private boolean forestClicked;

    private boolean ended;

    private String user;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.items);

        ended = false;
        halloweenClicked = false;
        mountainsClicked = false;

        intentItems = new Intent(this, MainMenu.class);

        Intent intent = getIntent();

        user = intent.getStringExtra("username");
        int [] timeStamp = intent.getIntArrayExtra("timeStamp");

        menuMusic = MediaPlayer.create(items.this, R.raw.menutheme);
        menuMusic.setLooping(true);
        menuMusic.seekTo(timeStamp[0]);
        menuMusic.start();

        ImageButton exitBtn = findViewById(R.id.exit);
        mountainsThumbnail = findViewById(R.id.mountainsThumbnail);
        halloweenThumbnail = findViewById(R.id.halloweenThumbnail);
        forestThumbnail = findViewById(R.id.forestThumbnail);

        LinearLayout sun = findViewById(R.id.sun);

        ImageView fastCloud = findViewById(R.id.fastCloud);
        ImageView mediumCloud = findViewById(R.id.mediumCloud);
        ImageView slowCloud = findViewById(R.id.slowCloud);

        RelativeLayout bgLayout = findViewById(R.id.bgLayout);

        ImageView gradientBG = new ImageView(this);

        WindowManager windowManager = getWindowManager();
        Display display = windowManager.getDefaultDisplay();

        ImageView foreground = findViewById(R.id.foreground);
        setBG = intent.getStringExtra("setBG");

        if(setBG == null){
            setBG = "mountains";
            mountainsThumbnail.callOnClick();
        }
        else if(setBG.equals("mountains")){
            mountainsThumbnail.callOnClick();
        }
        else if(setBG.equals("halloween")){
            halloweenThumbnail.callOnClick();
        }
        else if(setBG.equals("forest")){
            forestThumbnail.callOnClick();
        }

        DynamicBackground bg = new DynamicBackground(gradientBG, foreground, null, fastCloud, mediumCloud, slowCloud,
                sun, null, bgLayout, display, setBG, null);

        bg.setUpdatingBG();
        bg.updateBG(1, setBG);

        exitBtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                openMainMenu();
            }
        });
        mountainsThumbnail.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if(ended){
                    v.getBackground().setColorFilter(0x00000000, PorterDuff.Mode.SRC_ATOP);
                }
                else if((mountainsClicked && halloweenClicked) || (forestClicked && mountainsClicked)){
                    mountainsClicked = false;
                    v.getBackground().setColorFilter(0x00000000, PorterDuff.Mode.SRC_ATOP);
                }
                else {
                    mountainsClicked = true;
                    setBG = "mountains";
                    intentItems.putExtra("setBG", setBG);
                    bg.updateBG(-1, setBG);
                    v.getBackground().setColorFilter(0x77000000, PorterDuff.Mode.SRC_ATOP);
                    if (halloweenClicked) {
                        halloweenThumbnail.callOnClick();
                    }
                }
            }
        });
        halloweenThumbnail.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                //v1.invalidate();
                if(ended){
                    v.getBackground().setColorFilter(0x00000000, PorterDuff.Mode.SRC_ATOP);
                }
                else if((mountainsClicked && halloweenClicked) || (forestClicked&& halloweenClicked)){
                    halloweenClicked = false;
                    v.getBackground().setColorFilter(0x00000000, PorterDuff.Mode.SRC_ATOP);
                }
                else {
                    halloweenClicked = true;
                    setBG = "halloween";
                    intentItems.putExtra("setBG", setBG);
                    bg.updateBG(-1, setBG);
                    v.getBackground().setColorFilter(0x77000000, PorterDuff.Mode.SRC_ATOP);
                    if(mountainsClicked) {
                        mountainsThumbnail.callOnClick();
                    }
                    else if(mountainsClicked) {
                        forestThumbnail.callOnClick();
                    }
                }
            }
        });
        forestThumbnail.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                //v1.invalidate();
                if(ended){
                    v.getBackground().setColorFilter(0x00000000, PorterDuff.Mode.SRC_ATOP);
                }
                else if((forestClicked && mountainsClicked)  || (forestClicked && halloweenClicked)){
                    forestClicked = false;
                    v.getBackground().setColorFilter(0x00000000, PorterDuff.Mode.SRC_ATOP);
                }
                else {
                    forestClicked = true;
                    setBG = "forest";
                    intentItems.putExtra("setBG", setBG);
                    bg.updateBG(-1, setBG);
                    v.getBackground().setColorFilter(0x77000000, PorterDuff.Mode.SRC_ATOP);
                    if(mountainsClicked) {
                        mountainsThumbnail.callOnClick();
                    }
                    else if(halloweenClicked) {
                        halloweenThumbnail.callOnClick();
                    }
                }
            }
        });
    }



    public void openMainMenu(){
        ended = true;
        mountainsThumbnail.callOnClick();
        halloweenThumbnail.callOnClick();
        halloweenClicked = false;
        mountainsClicked = false;
        int[] timeStamp = new int[1];
        timeStamp[0] = menuMusic.getCurrentPosition();
        intentItems.putExtra("timeStamp", timeStamp);
        intentItems.putExtra("username", user);
        menuMusic.stop();
        startActivity(intentItems);
        overridePendingTransition(android.R.anim.fade_in, android.R.anim.fade_out);
    }
}