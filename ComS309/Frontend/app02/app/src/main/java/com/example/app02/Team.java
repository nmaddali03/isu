package com.example.app02;

import androidx.appcompat.app.AppCompatActivity;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;

public class Team extends AppCompatActivity {

    private Button mainMenu;
    private Button chatbtn;
    private Button leaderSettingsbtn;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_team);

        mainMenu = findViewById(R.id.exitButton);
        chatbtn = findViewById(R.id.chatButton);
        leaderSettingsbtn = findViewById(R.id.leaderSettingsBtn);

        mainMenu.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                openMainMenu();
            }
        });

        chatbtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                openChat();
            }
        });

        leaderSettingsbtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                openLeaderSettings();
            }
        });

    }

    public void openMainMenu(){
        Intent intentMenu = new Intent(this, MainMenu.class);
        startActivity(intentMenu);
        overridePendingTransition(android.R.anim.fade_in, android.R.anim.fade_out);
    }

    public void openChat(){
        Intent intentMenu = new Intent(this, Chat.class);
        startActivity(intentMenu);
        overridePendingTransition(android.R.anim.fade_in, android.R.anim.fade_out);
    }

    public void openLeaderSettings(){
        Intent intentMenu = new Intent(this, LeaderSettings.class);
        startActivity(intentMenu);
        overridePendingTransition(android.R.anim.fade_in, android.R.anim.fade_out);
    }
}