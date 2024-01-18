package com.example.app02;

import androidx.appcompat.app.AppCompatActivity;

import android.content.res.ColorStateList;
import android.graphics.Point;
import android.media.MediaPlayer;
import android.os.Bundle;
import android.content.Intent;
import android.view.Display;
import android.view.View;
import android.view.WindowManager;
import android.widget.Button;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;

import java.text.SimpleDateFormat;
import java.util.Calendar;

public class MainMenu extends AppCompatActivity {
    private Button btnWake;
    private Button btnSetAlarm;
    private Button btnTeam;
    private ImageButton btnFriends;
    private ImageButton btnChat;
    private ImageButton btnItems;
    private ImageButton btnLeaderboard;
    private ImageButton btnSettings;

    private MediaPlayer menuMusic;

    private ImageView foreground;

    private String setBG;


    @Override
    protected void onCreate(Bundle savedInstanceState) {

        super.onCreate(savedInstanceState);
        setContentView(R.layout.main_menu);

        Intent intent = getIntent();
        int [] timeStamp = intent.getIntArrayExtra("timeStamp");

        menuMusic = MediaPlayer.create(MainMenu.this, R.raw.menutheme);
        menuMusic.setLooping(true);
        if(timeStamp != null){
            menuMusic.seekTo(timeStamp[0]);
        }
        menuMusic.start();

        LinearLayout sun = findViewById(R.id.sun);

        ImageView fastCloud = findViewById(R.id.fastCloud);
        ImageView mediumCloud = findViewById(R.id.mediumCloud);
        ImageView slowCloud = findViewById(R.id.slowCloud);

        RelativeLayout title = findViewById(R.id.title);
        RelativeLayout bgLayout = findViewById(R.id.bgLayout);

        ImageView gameTitle = new ImageView(this);
        gameTitle.setImageResource(R.drawable.gametitle);

        ImageView gradientBG = new ImageView(this);

        WindowManager windowManager = getWindowManager();
        Display display = windowManager.getDefaultDisplay();

        Point size = new Point();
        display.getSize(size);

        float screenWidth = size.x;
        float screenHeight = size.y;

        int newHeight = (int) (screenHeight / 4.2);
        int orgWidth = gameTitle.getDrawable().getIntrinsicWidth();
        int orgHeight = gameTitle.getDrawable().getIntrinsicHeight();

        int newWidth = (int) Math.floor((orgWidth * newHeight) / orgHeight);

//Use RelativeLayout.LayoutParams if your parent is a RelativeLayout
        RelativeLayout.LayoutParams params = new RelativeLayout.LayoutParams(newWidth, newHeight);
        params.addRule(0);

        params.addRule(RelativeLayout.CENTER_IN_PARENT );
        title.setLayoutParams(params);
        title.setY((float) (screenHeight*.15));
        gameTitle.setLayoutParams(params);
        gameTitle.setScaleType(ImageView.ScaleType.CENTER_CROP);
        gameTitle.setImageTintList(ColorStateList.valueOf(this.getResources().getColor(R.color.lavender)));
        float temp2 = (screenWidth/2) - (newWidth/2);
        gameTitle.setX(temp2);

        Calendar calender = Calendar.getInstance();
        SimpleDateFormat format = new SimpleDateFormat("HH");
        String time = format.format(calender.getTime());
        int hour = Integer.parseInt(time);

        RelativeLayout.LayoutParams params2 = new RelativeLayout.LayoutParams((int)screenWidth, (int)screenHeight);
        params2.addRule(0);
        params2.addRule(RelativeLayout.CENTER_IN_PARENT );
        bgLayout.setLayoutParams(params2);

        foreground = findViewById(R.id.foreground);
        setBG = intent.getStringExtra("setBG");
        if(setBG == null){
            setBG = "mountains";
        }

        if(hour >= 21 || hour < 5){
            sun.setAlpha(0);
            gradientBG.setImageResource(R.drawable.nightgradient);
            foreground.setImageResource(R.drawable.nightmt);
            if(setBG != null) {
                if (setBG.equals("halloween")) {
                    foreground.setImageResource(R.drawable.halloweennight);
                }
            }
            gameTitle.setImageTintList(ColorStateList.valueOf(this.getResources().getColor(R.color.white)));
            gameTitle.setAlpha((float) 0.4);
        }
        else if(hour >= 5 && hour < 9){
            gradientBG.setImageResource(R.drawable.sunrisegradient);
            foreground.setImageResource(R.drawable.sunrisemt);
            if(setBG != null) {
                if(setBG.equals("halloween")){
                    foreground.setImageResource(R.drawable.halloweensunrise);
                }
            }
            gameTitle.setImageTintList(ColorStateList.valueOf(this.getResources().getColor(R.color.white)));
            gameTitle.setAlpha((float) 0.5);
        }
        else if(hour >= 9 && hour < 12){
            float x = sun.getX();
            float y = sun.getY();
            sun.setX(x+80);
            sun.setY(y-240);
            gradientBG.setImageResource(R.drawable.dawngradient);
            foreground.setImageResource(R.drawable.dawnmt);
            if(setBG != null) {
                if(setBG.equals("halloween")){
                    foreground.setImageResource(R.drawable.halloweendawn);
                }
            }
            gameTitle.setImageTintList(ColorStateList.valueOf(this.getResources().getColor(R.color.white)));
            gameTitle.setAlpha((float) 0.6);
        }
        else if(hour >= 12 && hour < 17){
            float x = sun.getX();
            float y = sun.getY();
            sun.setX(x+200);
            sun.setY(y-650);
            gradientBG.setImageResource(R.drawable.daygradient);
            foreground.setImageResource(R.drawable.daytimemt);
            if(setBG != null) {
                if(setBG.equals("halloween")){
                    foreground.setImageResource(R.drawable.halloweenday);
                }
            }
            gameTitle.setImageTintList(ColorStateList.valueOf(this.getResources().getColor(R.color.white)));
            gameTitle.setAlpha((float) 0.6);
        }
        else if(hour >= 17 && hour < 19){
            float x = sun.getX();
            float y = sun.getY();
            sun.setX(x+320);
            sun.setY(y-240);
            gradientBG.setImageResource(R.drawable.dawngradient);
            foreground.setImageResource(R.drawable.dawnmt);
            if(setBG != null) {
                if (setBG.equals("halloween")) {
                    foreground.setImageResource(R.drawable.halloweendawn);
                }
            }
            gameTitle.setImageTintList(ColorStateList.valueOf(this.getResources().getColor(R.color.white)));
            gameTitle.setAlpha((float) 0.6);
        }
        else if(hour >= 19 && hour < 21){
            float x = sun.getX();
            sun.setX(x+440);
            gradientBG.setImageResource(R.drawable.sunrisegradient);
            foreground.setImageResource(R.drawable.sunrisemt);
            if(setBG != null) {
                if(setBG.equals("halloween")){
                    foreground.setImageResource(R.drawable.halloweensunrise);
                }
            }
            gameTitle.setImageTintList(ColorStateList.valueOf(this.getResources().getColor(R.color.white)));
            gameTitle.setAlpha((float) 0.5);
        }

        gradientBG.setLayoutParams(params2);
        bgLayout.addView(gradientBG);
        title.addView(gameTitle);
        bgLayout.setY(-(screenHeight / 9));

        Clouds clouds = new Clouds(sun.getX(), sun.getY(),
                fastCloud, mediumCloud, slowCloud, display);

        btnWake = findViewById(R.id.btnWake);
        btnSetAlarm = findViewById(R.id.btnSetAlarm);
        btnTeam = findViewById(R.id.btnTeam);
        btnFriends = findViewById(R.id.friends);
        btnChat =  findViewById(R.id.chat);
        btnItems = findViewById(R.id.items);
        btnLeaderboard = findViewById(R.id.leaderboard);
        btnSettings = findViewById(R.id.settings);

        btnWake.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                openGame();
            }
        });

        btnSetAlarm.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                openSetAlarm();
            }
        });

        btnTeam.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                openTeamPage();
            }
        });

        btnFriends.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                openFriendsPage();
            }
        });

        btnChat.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                openChat();
            }
        });

        btnItems.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                openItemsPage();
            }
        });

        btnLeaderboard.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                openLeaderboard();
            }
        });

        btnSettings.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                openSettings();
            }
        });
    }
    public void openGame(){
        menuMusic.stop();
        Intent intentMenu = new Intent(this, Game.class);
        intentMenu.putExtra("setBG", setBG);
        startActivity(intentMenu);
        overridePendingTransition(android.R.anim.fade_in, android.R.anim.fade_out);
    }
    public void openSetAlarm(){
        menuMusic.stop();
        Intent intent = new Intent(this, Activity2.class);
        startActivity(intent);
        overridePendingTransition(android.R.anim.fade_in, android.R.anim.fade_out);
    }
    public void openTeamPage(){
        menuMusic.stop();
        Intent intent = new Intent(this, Activity2.class);
        startActivity(intent);
        overridePendingTransition(android.R.anim.fade_in, android.R.anim.fade_out);
    }
    public void openFriendsPage(){
        menuMusic.stop();
        Intent intent = new Intent(this, Activity2.class);
        startActivity(intent);
        overridePendingTransition(android.R.anim.fade_in, android.R.anim.fade_out);
    }
    public void openChat(){
        menuMusic.stop();
        Intent intent = new Intent(this, Activity2.class);
        startActivity(intent);
        overridePendingTransition(android.R.anim.fade_in, android.R.anim.fade_out);
    }
    public void openItemsPage(){
        int[] timeStamp = new int[1];
        timeStamp[0] = menuMusic.getCurrentPosition();
        menuMusic.stop();
        Intent intentMenu = new Intent(this, items.class);
        intentMenu.putExtra("timeStamp", timeStamp);
        intentMenu.putExtra("setBG", setBG);
        startActivity(intentMenu);
        overridePendingTransition(android.R.anim.fade_in, android.R.anim.fade_out);
    }
    public void openLeaderboard(){
        menuMusic.stop();
        Intent intent = new Intent(this, Leaderboard.class);
        startActivity(intent);
        overridePendingTransition(android.R.anim.fade_in, android.R.anim.fade_out);
    }
    public void openSettings(){
        int[] timeStamp = new int[1];
        timeStamp[0] = menuMusic.getCurrentPosition();
        menuMusic.stop();
        Intent intentMenu = new Intent(this, Activity2.class);
        intentMenu.putExtra("timeStamp", timeStamp);
        startActivity(intentMenu);
        overridePendingTransition(android.R.anim.fade_in, android.R.anim.fade_out);
    }
}