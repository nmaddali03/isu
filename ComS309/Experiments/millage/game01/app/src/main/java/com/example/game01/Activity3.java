package com.example.game01;

import android.content.Intent;
import android.graphics.Point;
import android.os.Bundle;
import android.os.Handler;
import android.view.Display;
import android.view.View;
import android.view.WindowManager;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import androidx.appcompat.app.AppCompatActivity;

import java.util.Timer;
import java.util.TimerTask;

public class Activity3 extends AppCompatActivity {

    private TextView counterText;
    private int counter = 0;
    private Button btnClick;
    private ImageView nightMt;
    private ImageView sunriseMt;
    private ImageView dawnMt;
    private ImageView daytimeMt;

    private ImageView nightSky;
    private ImageView sunriseSky;
    private ImageView dawnSky;

    private ImageView fastCloud;
    private ImageView mediumCloud;
    private ImageView slowCloud;

    private int frameHeight;
    private int screenWidth;
    private int screenHeight;

    private LinearLayout sun;
    private Timer timer = new Timer();
    private Handler handler = new Handler();

    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_3);
        counterText = findViewById(R.id.counterText);
        btnClick = findViewById(R.id.btnClick);
        nightMt = findViewById(R.id.nightMt);
        sunriseMt = findViewById(R.id.sunriseMt);
        dawnMt = findViewById(R.id.dawnMt);
        daytimeMt = findViewById(R.id.daytimeMt);
        nightSky = findViewById(R.id.nightGradient);
        sunriseSky = findViewById(R.id.sunriseGradient);
        dawnSky = findViewById(R.id.dawnGradient);

        fastCloud = findViewById(R.id.fastCloud);
        mediumCloud = findViewById(R.id.mediumCloud);
        slowCloud = findViewById(R.id.slowCloud);

        sun = findViewById(R.id.sun);
        sun.setX(-200);
        sun.setY(650);

        WindowManager windowManager = getWindowManager();
        Display display = windowManager.getDefaultDisplay();
        Point size = new Point();
        display.getSize(size);
        screenWidth = size.x;
        screenHeight = size.y;

        wakeBtn();
    }

    public void wakeBtn() {
        moveClouds();
        btnClick.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
            if (counter < 40){
                    counter++;
                    if(counter > 6) {
                        moveSun();
                    }
                    counterText.setText(counter + "");
                    if(counter <= 10) {
                        changeOpacity(nightMt, sunriseMt, nightSky);
                    }
                    else if(counter <= 20) {
                        changeOpacity(sunriseMt, dawnMt, sunriseSky);
                    }
                    else if(counter <= 30) {
                        changeOpacity(dawnMt, daytimeMt, dawnSky);
                    }
                }
                if(counter == 40){
                    doneCounting();
                }
            }
        });
    }
    private float originalPosX(){
        return sun.getX();
    }
    private float originalPosY(){
        return sun.getY();
    }
    private void updatePositionSun(float originalX, float originalY){
        float sunX = sun.getX() + 1;
        float sunY = sun.getY() - 3;
        float test = originalX+10;
        if(test > sunX) {
            sun.setX(sunX);
            sun.setY(sunY);
        }
    }
    private void updatePosition(){
        float fastCloudX = fastCloud.getX() - 1;
        float fastCloudY = fastCloud.getY();
        float mediumCloudX = mediumCloud.getX() - 2;
        float mediumCloudY = mediumCloud.getY();
        float slowCloudX = slowCloud.getX() + 4;
        float slowCloudY = slowCloud.getY();
        if(fastCloudX < -350){
            fastCloudX = screenWidth + 20;
            fastCloudY = (float) Math.floor(Math.random()*(screenHeight - 0));
        }
        if(mediumCloudX < -450){
            mediumCloudX = screenWidth + 20;
            mediumCloudY = (float) Math.floor(Math.random()*(screenHeight - 0));
        }
        if(slowCloudX >  screenWidth + 300){
            slowCloudX = -900;
            slowCloudY = (float) Math.floor(Math.random()*(screenHeight - 0));
        }
        fastCloud.setX(fastCloudX);
        fastCloud.setY(fastCloudY);
        mediumCloud.setX(mediumCloudX);
        mediumCloud.setY(mediumCloudY);
        slowCloud.setX(slowCloudX);
        slowCloud.setY(slowCloudY);
    }
    private void moveSun(){
        float x = originalPosX();
        float y = originalPosY();
        timer.schedule(new TimerTask(){
            @Override
            public void run() {
                handler.post(new Runnable() {
                    @Override
                    public void run() {
                        updatePositionSun(x, y);
                    }
                });
            }
        }, 0, 20);
    }

    private void moveClouds(){
        float x = originalPosX();
        float y = originalPosY();
        timer.schedule(new TimerTask(){
            @Override
            public void run() {
                handler.post(new Runnable() {
                    @Override
                    public void run() {
                        updatePosition();
                    }
                });
            }
        }, 0, 20);
    }

    /* changeOpacity: lowers image opacity every time the button is clicked */
    private void changeOpacity(ImageView mt1, ImageView mt2, ImageView sky){
        float opacity1 = mt1.getAlpha();
        opacity1 = (float) (opacity1 - .1);
        mt1.setAlpha(opacity1);
        mt2.setAlpha(1.0F);
        float opacity3 = sky.getAlpha();
        opacity3 = (float) (opacity3 - .1);
        sky.setAlpha(opacity3);
    }

    /* doneCounting: when counter is done counting up to 40, a new activity page is opened */
    private void doneCounting(){
        try {
            Thread.sleep(50);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        startActivity(new Intent(this, Activity4.class));
        overridePendingTransition(android.R.anim.fade_in, android.R.anim.fade_out);
    }
}