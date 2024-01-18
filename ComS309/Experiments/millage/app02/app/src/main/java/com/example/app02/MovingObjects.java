package com.example.app02;

import static androidx.core.content.ContextCompat.startActivity;

import android.content.Intent;
import android.graphics.Point;
import android.os.Handler;
import android.view.Display;
import android.widget.AnalogClock;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.TextView;

import java.util.Timer;
import java.util.TimerTask;

public class MovingObjects {
    public ImageButton obj;
    private ImageView brokenObj;

    private int frameHeight;

    private float objX;
    private float objY;

    private int screenWidth;
    private int screenHeight;

    private int speed;
    private int numLives;
    private int called;

    private boolean isbroken;
    private boolean isDead;
    private boolean lostLife = false;


    private TextView livesText;

    public MovingObjects(float originalPosX, float originalPosY,
                         ImageButton obj, ImageView brokenObj, int speed,
                         Display display, int numLives, TextView livesText, boolean isBroken){
        this.numLives = numLives;
        this.obj = obj;
        this.brokenObj = brokenObj;
        this.speed = speed;
        this.livesText = livesText;
        this.isbroken = isBroken;

        Point size = new Point();
        display.getSize(size);

        screenWidth = size.x;
        screenHeight = size.y;

        isDead = false;
    }

    public boolean checkBroken(){
        if(brokenObj.getAlpha() == 0)
            return false;
        return true;
    }

    public void updateSpeed(int speed){
        this.speed = speed;
    }

    public int getSpeed(){
       return speed;
    }

    public void fixClock(ImageButton fixed, ImageView broken, int lives){
        lostLife = false;
        numLives = lives;
        fixed.setAlpha(1F);
        broken.setAlpha(0F);
        isbroken = false;
    }


    public int lives(){
        return numLives;
    }

    public void breakObj(){
        obj.setAlpha(0F);
        brokenObj.setAlpha(1F);
        isbroken = true;
    }

    public void updateObjPos(ImageButton obj, float originalX){
        this.obj = obj;
        objX = obj.getX();
        objY = obj.getY();
        float x = obj.getX();

        if(obj.getX() + obj.getWidth() < 0){
            if(!checkBroken() && objX + obj.getWidth() < 0){
                lostLife = true;
                numLives = loseLife(numLives);

            }
            else if(checkBroken() && obj.getX() + obj.getWidth() < 0) {
                fixClock(obj, brokenObj, numLives);
                lostLife = false;
            }
            objX = screenWidth+100.0f;
            objY = (float)Math.floor(Math.random()*(screenHeight-obj.getHeight()));
        }

        objX -= getSpeed();
        obj.setX(objX);
        obj.setY(objY);
        brokenObj.setX(objX);
        brokenObj.setY(objY);
    }

    public boolean lostLife(){
        return lostLife;
    }
    public void setLostLife(boolean lostLife){
        this.lostLife = lostLife;
    }

    public int loseLife(int lives){
        numLives = lives;
        numLives--;
        if(numLives == 0){
            isDead = true;
        }
        return 1;
    }

    public boolean isDead(){
        return isDead;
    }



}