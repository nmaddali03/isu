package com.example.app02;

import android.content.Intent;
import android.os.Handler;
import android.view.View;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.view.Display;

import androidx.appcompat.app.AppCompatActivity;

import java.util.Timer;
import java.util.TimerTask;

public class Background extends AppCompatActivity {
    private ImageView night;
    private ImageView sunrise;
    private ImageView dawn;
    private ImageView daytime;

    private ImageView nightSky;
    private ImageView sunriseSky;
    private ImageView dawnSky;

    private LinearLayout sun;

    private boolean isGoalReached = false;

    private Timer timer = new Timer();
    private Handler handler = new Handler();

    private boolean sunIsUp = false;

    private TextView counterText;
    private int counter = 0;
    private Button btnClick;

    final Clouds clouds;

    public Background(Display display,
                      TextView counterText,
                      LinearLayout sun,
                      ImageView night,
                      ImageView sunrise,
                      ImageView dawn,
                      ImageView day,
                      ImageView nightSky,
                      ImageView sunriseSky,
                      ImageView dawnSky,
                      ImageView fastCloud,
                      ImageView mediumCloud,
                      ImageView slowCloud){

        this.counterText = counterText;
        this.sun = sun;
        this.night = night;
        this.sunrise = sunrise;
        this.dawn = dawn;
        daytime = day;
        this.nightSky = nightSky;
        this.sunriseSky = sunriseSky;
        this.dawnSky = dawnSky;

        clouds = new Clouds(sun.getX(), sun.getY(),
                fastCloud, mediumCloud, slowCloud, display);
    }

    public void setSun(int x, int y, boolean c){
        sun.setX(x);
        sun.setY(y);
        sunIsUp = c;
    }

    public boolean isSunUp(){
        return sunIsUp;
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

    public void moveSun(){
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


    /* changeOpacity: lowers image opacity every time the button is clicked */
    public void changeOpacity(ImageView mt1, ImageView mt2, ImageView sky){
        float opacity1 = mt1.getAlpha();
        opacity1 = (float) (opacity1 - .1);
        mt1.setAlpha(opacity1);
        mt2.setAlpha(1.0F);
        float opacity3 = sky.getAlpha();
        opacity3 = (float) (opacity3 - .1);
        sky.setAlpha(opacity3);
    }

}
