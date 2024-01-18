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

import com.example.net_utils.NetworkCalls;

import org.json.JSONException;

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
        int[] scoreArr = intent.getIntArrayExtra("score");

        String user = intent.getStringExtra("username");
        int score = scoreArr[0];

        //update recent score and if recent score is a high score, high score is updated
        try {
            NetworkCalls.sendScore(score);
        } catch (JSONException e) {
            e.printStackTrace();
        }

        //update currency
        try {
            NetworkCalls.updateCurrency(score);
        } catch (JSONException e) {
            e.printStackTrace();
        }

        //set BG to night
        night = findViewById(R.id.night);
        night.setImageResource(R.drawable.nightmt);
        if(setBG != null) {
            if (setBG.equals("halloween")) {
                night.setImageResource(R.drawable.halloweennight);
            }
            else if (setBG.equals("forest")) {
                night.setImageResource(R.drawable.forestnight);
            }
        }

        //play again button
        playAgain = findViewById(R.id.playAgain);

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