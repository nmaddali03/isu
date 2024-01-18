package com.example.hello_android;

import android.content.Intent;
import android.graphics.Color;
import android.media.MediaPlayer;
import android.os.Bundle;
import android.view.View;
import android.webkit.WebView;
import android.widget.Button;
import android.widget.VideoView;

import androidx.appcompat.app.AppCompatActivity;
import androidx.constraintlayout.widget.ConstraintLayout;

import java.util.Random;
import java.util.Timer;
import java.util.TimerTask;

public class Rave extends AppCompatActivity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.rave);

        MediaPlayer music = MediaPlayer.create(Rave.this, R.raw.song);
        music.setLooping(true);
        music.setVolume(100,100);
        music.start();

        Button backButton = findViewById(R.id.rave_back_button);

        backButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                music.stop();
                startActivity(new Intent(view.getContext(), MainActivity.class));
            }
        });

        Timer timer = new Timer("Timer",true);
        long delay = 200L;
        timer.schedule(new TimerTask() {public void run(){colorChanger();}},0, delay);
    }

    public void colorChanger() {
        ConstraintLayout layout = (ConstraintLayout) findViewById(R.id.rave_layout);
        Random rand = new Random();
        int a,r,g,b;
        a=rand.nextInt(255);
        r=rand.nextInt(255);
        g=rand.nextInt(255);
        b=rand.nextInt(255);
        layout.setBackgroundColor(Color.argb(a, r, g, b));
    }
}