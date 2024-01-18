package com.example.app02;

import static android.content.ContentValues.TAG;

import androidx.appcompat.app.AppCompatActivity;

import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.Display;
import android.view.View;
import android.view.WindowManager;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.Toast;

import com.android.volley.Request;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.JsonArrayRequest;
import com.android.volley.toolbox.JsonObjectRequest;
import com.example.net_utils.NetworkCalls;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.HashMap;
import java.util.Map;

public class EndPage extends AppCompatActivity {
    private Button btnReturn;
    private int goal = 40;
    private int score;
    private ImageView day;

    private TextView scoreText;
    private TextView highScoreText;

    private String setBG;
    private Intent endPage;

    private String user;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.end_page);

        scoreText = findViewById(R.id.score);
        highScoreText = findViewById(R.id.highScore);

        endPage = new Intent(this, MainMenu.class);

        Intent intent = getIntent();

        int[] score = intent.getIntArrayExtra("score");
        user = intent.getStringExtra("username");
        scoreText.setText("Score: " + score[0]);
        int highScore = CurrentUser.getHigh();
        if(highScore<score[0]){
            highScore = score[0];
        }
        highScoreText.setText("High Score: " + highScore);

        setBG = intent.getStringExtra("setBG");
        day = findViewById(R.id.day);
        day.setImageResource(R.drawable.daytimemt);
        if (setBG != null) {
            if (setBG.equals("halloween")) {
                day.setImageResource(R.drawable.halloweenday);
            }
            else if (setBG.equals("forest")) {
                day.setImageResource(R.drawable.forestday);
            }
        }

        LinearLayout sun = findViewById(R.id.sun);

        ImageView fastCloud = findViewById(R.id.fastCloud);
        ImageView mediumCloud = findViewById(R.id.mediumCloud);
        ImageView slowCloud = findViewById(R.id.slowCloud);

        WindowManager windowManager = getWindowManager();
        Display display = windowManager.getDefaultDisplay();

        Clouds clouds = new Clouds(sun.getX(), sun.getY(),
                fastCloud, mediumCloud, slowCloud, display);

        btnReturn = (Button) findViewById(R.id.btnReturn);
        btnReturn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                openActivityMain();
            }
        });
        try {
            NetworkCalls.sendScore(score[0]);
        } catch (JSONException e) {
            e.printStackTrace();
        }
        try {
            NetworkCalls.updateCurrency(score[0]);
        } catch (JSONException e) {
            e.printStackTrace();
        }
    }

    public void openActivityMain() {
        endPage.putExtra("setBG", setBG);
        endPage.putExtra("user", user);
        startActivity(endPage);
    }



}