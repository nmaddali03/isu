package com.example.app02;

import androidx.appcompat.app.AppCompatActivity;

import android.content.Intent;
import android.os.Bundle;
import android.view.Display;
import android.view.View;
import android.view.WindowManager;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.LinearLayout;

public class EndPageLose extends AppCompatActivity {
    private ImageView night;
    private Button playAgain;
    private String setBG;
    private Intent endPageLose;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.end_page_lose);

        endPageLose = new Intent(this, Game.class);

        Intent intent = getIntent();
        setBG = intent.getStringExtra("setBG");

        night = findViewById(R.id.night);

        night.setImageResource(R.drawable.nightmt);
        if(setBG != null) {
            if (setBG.equals("halloween")) {
                night.setImageResource(R.drawable.halloweennight);
            }
        }

        playAgain = (Button) findViewById(R.id.playAgain);

        LinearLayout sun = findViewById(R.id.sun);

        ImageView fastCloud = findViewById(R.id.fastCloud);
        ImageView mediumCloud = findViewById(R.id.mediumCloud);
        ImageView slowCloud = findViewById(R.id.slowCloud);

        WindowManager windowManager = getWindowManager();
        Display display = windowManager.getDefaultDisplay();

        Clouds clouds = new Clouds(sun.getX(), sun.getY(),
                fastCloud, mediumCloud, slowCloud, display);


        playAgain.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                openActivityMain();
            }
        });
    }

    public void openActivityMain() {
        endPageLose.putExtra("setBG", setBG);
        startActivity(endPageLose);
    }
}