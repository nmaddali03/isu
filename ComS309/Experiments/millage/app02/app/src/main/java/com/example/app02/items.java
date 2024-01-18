package com.example.app02;

import androidx.appcompat.app.AppCompatActivity;

import android.content.Intent;
import android.content.res.ColorStateList;
import android.graphics.Point;
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

import java.text.SimpleDateFormat;
import java.util.Calendar;

public class items extends AppCompatActivity {
    private ImageView foreground;
    private ImageButton exitBtn;
    private ImageButton mountainsThumbnail;
    private ImageButton halloweenThumbnail;
    private MediaPlayer menuMusic;
    private Intent intentItems;
    private String setBG;
    private ImageView gradientBG;
    private LinearLayout sun;
    private int hour;
    private ColorStateList clicked;
    private boolean mountainsClicked;
    private boolean halloweenClicked;
    private boolean ended;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.items);

        ended = false;
        halloweenClicked = false;
        mountainsClicked = false;

        intentItems = new Intent(this, MainMenu.class);

        Intent intent = getIntent();

        int [] timeStamp = intent.getIntArrayExtra("timeStamp");

        menuMusic = MediaPlayer.create(items.this, R.raw.menutheme);
        menuMusic.setLooping(true);
        menuMusic.seekTo(timeStamp[0]);
        menuMusic.start();

        clicked = ColorStateList.valueOf(this.getResources().getColor(R.color.white));

        exitBtn = findViewById(R.id.exit);
        mountainsThumbnail = findViewById(R.id.mountainsThumbnail);
        halloweenThumbnail = findViewById(R.id.halloweenThumbnail);

        sun = findViewById(R.id.sun);

        ImageView fastCloud = findViewById(R.id.fastCloud);
        ImageView mediumCloud = findViewById(R.id.mediumCloud);
        ImageView slowCloud = findViewById(R.id.slowCloud);

        RelativeLayout bgLayout = findViewById(R.id.bgLayout);

        gradientBG = new ImageView(this);

        WindowManager windowManager = getWindowManager();
        Display display = windowManager.getDefaultDisplay();

        Point size = new Point();
        display.getSize(size);

        float screenWidth = size.x;
        float screenHeight = size.y;

        Calendar calender = Calendar.getInstance();
        SimpleDateFormat format = new SimpleDateFormat("HH");
        String time = format.format(calender.getTime());
        hour = Integer.parseInt(time);

        RelativeLayout.LayoutParams params2 = new RelativeLayout.LayoutParams((int)screenWidth, (int)screenHeight);
        params2.addRule(0);
        params2.addRule(RelativeLayout.CENTER_IN_PARENT );
        bgLayout.setLayoutParams(params2);

        foreground = findViewById(R.id.foreground);
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
        setBGTheme(1);

        gradientBG.setLayoutParams(params2);
        bgLayout.addView(gradientBG);
        bgLayout.setY(-(screenHeight / 9));

        Clouds clouds = new Clouds(sun.getX(), sun.getY(),
                fastCloud, mediumCloud, slowCloud, display);

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
                else if(mountainsClicked && halloweenClicked){
                    mountainsClicked = false;
                    v.getBackground().setColorFilter(0x00000000, PorterDuff.Mode.SRC_ATOP);
                }
                else {
                    mountainsClicked = true;
                    setBG = "mountains";
                    intentItems.putExtra("setBG", setBG);
                    setBGTheme(-1);
                    v.getBackground().setColorFilter(0x77000000, PorterDuff.Mode.SRC_ATOP);
                    if (halloweenClicked) {
                        halloweenThumbnail.callOnClick();
                    }
                }
                            //mountainsThumbnail.setColorFilter(0x77000000,PorterDuff.Mode.SRC_ATOP);
            }
        });
        halloweenThumbnail.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                //v1.invalidate();
                if(ended){
                    v.getBackground().setColorFilter(0x00000000, PorterDuff.Mode.SRC_ATOP);
                }
                else if(mountainsClicked && halloweenClicked){
                    halloweenClicked = false;
                    v.getBackground().setColorFilter(0x00000000, PorterDuff.Mode.SRC_ATOP);
                }
                else {
                    halloweenClicked = true;
                    setBG = "halloween";
                    intentItems.putExtra("setBG", setBG);
                    setBGTheme(-1);
                    v.getBackground().setColorFilter(0x77000000, PorterDuff.Mode.SRC_ATOP);
                    if(mountainsClicked) {
                        mountainsThumbnail.callOnClick();
                    }
                }
                //halloweenThumbnail.setColorFilter(0x00000000,PorterDuff.Mode.SRC_ATOP);
            }
        });
    }

    public void setBGTheme(int check){
        if(hour >= 21 || hour < 5){
            sun.setAlpha(0);
            gradientBG.setImageResource(R.drawable.nightgradient);
            foreground.setImageResource(R.drawable.nightmt);
            if(setBG != null) {
                if (setBG.equals("halloween")) {
                    foreground.setImageResource(R.drawable.halloweennight);
                }
            }
        }
        else if(hour >= 5 && hour < 9){
            gradientBG.setImageResource(R.drawable.sunrisegradient);
            foreground.setImageResource(R.drawable.sunrisemt);
            if(setBG != null) {
                if(setBG.equals("halloween")){
                    foreground.setImageResource(R.drawable.halloweensunrise);
                }
            }
        }
        else if(hour >= 9 && hour < 12){
            float x = sun.getX();
            float y = sun.getY();
            if(check == 1) {
                sun.setX(x + 80);
                sun.setY(y - 240);
            }
            gradientBG.setImageResource(R.drawable.dawngradient);
            foreground.setImageResource(R.drawable.dawnmt);
            if(setBG != null) {
                if(setBG.equals("halloween")){
                    foreground.setImageResource(R.drawable.halloweendawn);
                }
            }
        }
        else if(hour >= 12 && hour < 17){
            float x = sun.getX();
            float y = sun.getY();
            if(check == 1) {
                sun.setX(x + 200);
                sun.setY(y - 650);
            }
            gradientBG.setImageResource(R.drawable.daygradient);
            foreground.setImageResource(R.drawable.daytimemt);
            if(setBG != null) {
                if(setBG.equals("halloween")){
                    foreground.setImageResource(R.drawable.halloweenday);
                }
            }
        }
        else if(hour >= 17 && hour < 19){
            float x = sun.getX();
            float y = sun.getY();
            if(check == 1) {
                sun.setX(x + 320);
                sun.setY(y - 240);
            }
            gradientBG.setImageResource(R.drawable.dawngradient);
            foreground.setImageResource(R.drawable.dawnmt);
            if(setBG != null) {
                if (setBG.equals("halloween")) {
                    foreground.setImageResource(R.drawable.halloweendawn);
                }
            }
        }
        else if(hour >= 19 && hour < 21){
            float x = sun.getX();
            if(check == 1) {
                sun.setX(x + 440);
            }
            gradientBG.setImageResource(R.drawable.sunrisegradient);
            foreground.setImageResource(R.drawable.sunrisemt);
            if(setBG != null) {
                if(setBG.equals("halloween")){
                    foreground.setImageResource(R.drawable.halloweensunrise);
                }
            }
        }
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
        menuMusic.stop();
        startActivity(intentItems);
        overridePendingTransition(android.R.anim.fade_in, android.R.anim.fade_out);
    }
}