package com.example.app02;

import androidx.appcompat.app.AppCompatActivity;

import android.content.res.ColorStateList;
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
import android.widget.TextView;

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
    private String user;

    protected static CurrentUser currUser;

    @Override
    protected void onCreate(Bundle savedInstanceState) {

        super.onCreate(savedInstanceState);
        setContentView(R.layout.main_menu);

        Intent intent = getIntent();
        int [] timeStamp = intent.getIntArrayExtra("timeStamp");
        user = intent.getStringExtra("username");
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

        TextView username = findViewById(R.id.username);
        username.setText(user);

        ImageView gradientBG = new ImageView(this);

        foreground = findViewById(R.id.foreground);
        setBG = intent.getStringExtra("setBG");
        if(setBG == null){
            setBG = "mountains";
        }

        WindowManager windowManager = getWindowManager();
        Display display = windowManager.getDefaultDisplay();

        ColorStateList white = ColorStateList.valueOf(this.getResources().getColor(R.color.white));

        DynamicBackground bg = new DynamicBackground(gradientBG, foreground, gameTitle, fastCloud, mediumCloud, slowCloud,
                sun, title, bgLayout, display, setBG, white);
        bg.setBackground();



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

    /**
     * opens game page when button is pressed
     */
    public void openGame(){
        menuMusic.stop();
        Intent intentMenu = new Intent(this, Game.class);
        intentMenu.putExtra("setBG", setBG);
        intentMenu.putExtra("username", user);
        startActivity(intentMenu);
        overridePendingTransition(android.R.anim.fade_in, android.R.anim.fade_out);
    }

    /**
     * opens SetAlarm page
     */
    public void openSetAlarm(){
        menuMusic.stop();
        Intent intent = new Intent(this, SetAlarm.class);
        startActivity(intent);
        overridePendingTransition(android.R.anim.fade_in, android.R.anim.fade_out);
    }

    /**
     * opens team page
     */
    public void openTeamPage(){
        menuMusic.stop();
        Intent intent = new Intent(this, Activity2.class);
        startActivity(intent);
        overridePendingTransition(android.R.anim.fade_in, android.R.anim.fade_out);
    }

    /**
     * opens friend page
     */
    public void openFriendsPage(){
        menuMusic.stop();
        Intent intent = new Intent(this, Friends.class);
        startActivity(intent);
        overridePendingTransition(android.R.anim.fade_in, android.R.anim.fade_out);
    }

    /**
     * opens chat page
     */
    public void openChat(){
        int[] timeStamp = new int[1];
        timeStamp[0] = menuMusic.getCurrentPosition();
        menuMusic.stop();
        Intent intentMenu = new Intent(this, Chat.class);
        intentMenu.putExtra("timeStamp", timeStamp);
        intentMenu.putExtra("username", user);
        intentMenu.putExtra("setBG", setBG);
        startActivity(intentMenu);
        overridePendingTransition(android.R.anim.fade_in, android.R.anim.fade_out);
    }

    /**
     * opens items page
     */
    public void openItemsPage(){
        int[] timeStamp = new int[1];
        timeStamp[0] = menuMusic.getCurrentPosition();
        menuMusic.stop();
        Intent intentMenu = new Intent(this, items.class);
        intentMenu.putExtra("username", user);
        intentMenu.putExtra("timeStamp", timeStamp);
        intentMenu.putExtra("setBG", setBG);
        startActivity(intentMenu);
        overridePendingTransition(android.R.anim.fade_in, android.R.anim.fade_out);
    }

    /**
     * opens leaderboard page
     */
    public void openLeaderboard(){
        menuMusic.stop();
        Intent intent = new Intent(this, Leaderboard.class);
        startActivity(intent);
        overridePendingTransition(android.R.anim.fade_in, android.R.anim.fade_out);
    }

    /**
     * opens settings page
     */
    public void openSettings(){
        int[] timeStamp = new int[1];
        timeStamp[0] = menuMusic.getCurrentPosition();
        menuMusic.stop();
        Intent intentMenu = new Intent(this, Settings.class);
        intentMenu.putExtra("timeStamp", timeStamp);
        intentMenu.putExtra("username", user);
        startActivity(intentMenu);
        overridePendingTransition(android.R.anim.fade_in, android.R.anim.fade_out);
    }

}