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
import android.widget.TextView;

public class EndPage extends AppCompatActivity {
    private Button btnReturn;
    private int goal = 40;
    private int score;
    private ImageView day;

    private TextView scoreText;

    private String setBG;
    private Intent endPage;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.end_page);

        scoreText = findViewById(R.id.score);

        endPage = new Intent(this, MainMenu.class);

        Intent intent = getIntent();

        int [] score = intent.getIntArrayExtra("score");
        scoreText.setText("Score: "+score[0]);
        setBG = intent.getStringExtra("setBG");

        day = findViewById(R.id.day);
        day.setImageResource(R.drawable.daytimemt);
        if(setBG != null) {
            if(setBG.equals("halloween")){
                day.setImageResource(R.drawable.halloweenday);
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
    }

    public void openActivityMain() {
        endPage.putExtra("setBG", setBG);
        startActivity(endPage);
    }
}