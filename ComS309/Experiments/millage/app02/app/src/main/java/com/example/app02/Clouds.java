package com.example.app02;

import android.graphics.Point;
import android.os.Handler;
import android.view.Display;
import android.view.WindowManager;
import android.widget.ImageView;

import androidx.appcompat.app.AppCompatActivity;

import java.util.Timer;
import java.util.TimerTask;

public class Clouds extends AppCompatActivity {

    private ImageView fastCloud;
    private ImageView mediumCloud;
    private ImageView slowCloud;

    private int frameHeight;
    private int screenWidth;
    private int screenHeight;

    private Timer timer = new Timer();
    private Handler handler = new Handler();


    public Clouds(float originalPosX, float originalPosY,
                  ImageView fastCloud, ImageView mediumCloud, ImageView slowCloud,
                  Display display){

        this.fastCloud = fastCloud;
        this.mediumCloud = mediumCloud;
        this.slowCloud = slowCloud;


        Point size = new Point();
        display.getSize(size);

        screenWidth = size.x;
        screenHeight = size.y;

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

}
