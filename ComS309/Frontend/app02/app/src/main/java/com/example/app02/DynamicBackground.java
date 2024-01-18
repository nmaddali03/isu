package com.example.app02;

import android.content.res.ColorStateList;
import android.graphics.Point;
import android.view.Display;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;

import java.text.SimpleDateFormat;
import java.util.Calendar;

public class DynamicBackground {
    private ImageView gradientBG;
    private ImageView foreground;
    private ImageView gameTitle;
    private ImageView fastCloud;
    private ImageView mediumCloud;
    private ImageView slowCloud;
    private LinearLayout sun;
    private RelativeLayout title;
    private RelativeLayout bgLayout;
    private Display display;
    private String setBG;
    private ColorStateList white;
    private int hour;

    /**
     * Sets up the dynamic background for any page other than game
     * @param gradientBG
     * @param foreground
     * @param gameTitle
     * @param fastCloud
     * @param mediumCloud
     * @param slowCloud
     * @param sun
     * @param title
     * @param bgLayout
     * @param display
     * @param setBG
     * @param white
     */
    public DynamicBackground(ImageView gradientBG, ImageView foreground, ImageView gameTitle,
                             ImageView fastCloud, ImageView mediumCloud, ImageView slowCloud,
                             LinearLayout sun, RelativeLayout title, RelativeLayout bgLayout,
                             Display display, String setBG, ColorStateList white ){
        this.gradientBG = gradientBG;
        this.foreground = foreground;
        this.gameTitle = gameTitle;
        this.fastCloud = fastCloud;
        this.mediumCloud = mediumCloud;
        this.slowCloud = slowCloud;
        this.sun = sun;
        this.title = title;
        this.bgLayout = bgLayout;
        this.display = display;
        this.setBG = setBG;
        this.white = white;
        setHour();
    }

    /**
     * Sets time for background to know if it should be night, day, etc.
     */
    public void setHour(){
        Calendar calender = Calendar.getInstance();
        SimpleDateFormat format = new SimpleDateFormat("HH");
        String time = format.format(calender.getTime());
        hour = Integer.parseInt(time);
    }

    /**
     * Sets background theme, ie. Halloween, forest, mountains, etc.
     */
    public void setBackground(){
        Point size = new Point();
        display.getSize(size);

        float screenWidth = size.x;
        float screenHeight = size.y;

        int newHeight = (int) (screenHeight / 4.2);
        int orgWidth = gameTitle.getDrawable().getIntrinsicWidth();
        int orgHeight = gameTitle.getDrawable().getIntrinsicHeight();

        int newWidth = (int) Math.floor((orgWidth * newHeight) / orgHeight);

//Use RelativeLayout.LayoutParams if your parent is a RelativeLayout
        RelativeLayout.LayoutParams params = new RelativeLayout.LayoutParams(newWidth, newHeight);
        params.addRule(0);

        params.addRule(RelativeLayout.CENTER_IN_PARENT );
        title.setLayoutParams(params);
        title.setY((float) (screenHeight*.15));
        gameTitle.setLayoutParams(params);
        gameTitle.setScaleType(ImageView.ScaleType.CENTER_CROP);
        gameTitle.setImageTintList(white);
        gameTitle.setAlpha((float) 0.4);
        float temp2 = (screenWidth/2) - (newWidth/2);
        gameTitle.setX(temp2);

        RelativeLayout.LayoutParams params2 = new RelativeLayout.LayoutParams((int)screenWidth, (int)screenHeight);
        params2.addRule(0);
        params2.addRule(RelativeLayout.CENTER_IN_PARENT );
        bgLayout.setLayoutParams(params2);


        if(setBG == null){
            setBG = "mountains";
        }
        if(hour >= 21 || hour < 5){
            sun.setAlpha(0);
            gradientBG.setImageResource(R.drawable.nightgradient);
            foreground.setImageResource(R.drawable.nightmt);
            if(setBG != null) {
                if (setBG.equals("halloween")) {
                    foreground.setImageResource(R.drawable.halloweennight);
                }
                else if (setBG.equals("forest")) {
                    foreground.setImageResource(R.drawable.forestnight);
                }
            }
            if(gameTitle!=null) {
                gameTitle.setImageTintList(white);
                gameTitle.setAlpha((float) 0.4);
            }
        }
        else if(hour >= 5 && hour < 9){
            gradientBG.setImageResource(R.drawable.sunrisegradient);
            foreground.setImageResource(R.drawable.sunrisemt);
            if(setBG != null) {
                if(setBG.equals("halloween")){
                    foreground.setImageResource(R.drawable.halloweensunrise);
                }
                else if (setBG.equals("forest")) {
                    foreground.setImageResource(R.drawable.forestsunrise);
                }
            }
            if(gameTitle!=null) {
                gameTitle.setImageTintList(white);
                gameTitle.setAlpha((float) 0.5);
            }
        }
        else if(hour >= 9 && hour < 12){
            float x = sun.getX();
            float y = sun.getY();
            sun.setX(x+80);
            sun.setY(y-240);
            gradientBG.setImageResource(R.drawable.dawngradient);
            foreground.setImageResource(R.drawable.dawnmt);
            if(setBG != null) {
                if(setBG.equals("halloween")){
                    foreground.setImageResource(R.drawable.halloweendawn);
                }
                else if (setBG.equals("forest")) {
                    foreground.setImageResource(R.drawable.forestdawn);
                }
            }
            if(gameTitle!=null) {
                gameTitle.setImageTintList(white);
                gameTitle.setAlpha((float) 0.6);
            }
        }
        else if(hour >= 12 && hour < 17){
            float x = sun.getX();
            float y = sun.getY();
            sun.setX(x+200);
            sun.setY(y-650);
            gradientBG.setImageResource(R.drawable.daygradient);
            foreground.setImageResource(R.drawable.daytimemt);
            if(setBG != null) {
                if(setBG.equals("halloween")){
                    foreground.setImageResource(R.drawable.halloweenday);
                }
                else if (setBG.equals("forest")) {
                    foreground.setImageResource(R.drawable.forestday);
                }
            }
            if(gameTitle!=null) {
                gameTitle.setImageTintList(white);
                gameTitle.setAlpha((float) 0.6);
            }
        }
        else if(hour >= 17 && hour < 19){
            float x = sun.getX();
            float y = sun.getY();
            sun.setX(x+320);
            sun.setY(y-240);
            gradientBG.setImageResource(R.drawable.dawngradient);
            foreground.setImageResource(R.drawable.dawnmt);
            if(setBG != null) {
                if (setBG.equals("halloween")) {
                    foreground.setImageResource(R.drawable.halloweendawn);
                }
                else if (setBG.equals("forest")) {
                    foreground.setImageResource(R.drawable.forestdawn);
                }
            }
            if(gameTitle!=null) {
                gameTitle.setImageTintList(white);
                gameTitle.setAlpha((float) 0.6);
            }
        }
        else if(hour >= 19 && hour < 21){
            float x = sun.getX();
            sun.setX(x+440);
            gradientBG.setImageResource(R.drawable.sunrisegradient);
            foreground.setImageResource(R.drawable.sunrisemt);
            if(setBG != null) {
                if(setBG.equals("halloween")){
                    foreground.setImageResource(R.drawable.halloweensunrise);
                }
                else if (setBG.equals("forest")) {
                    foreground.setImageResource(R.drawable.forestsunrise);
                }
            }
            if(gameTitle!=null) {
                gameTitle.setImageTintList(white);
                gameTitle.setAlpha((float) 0.5);
            }
        }

        gradientBG.setLayoutParams(params2);
        bgLayout.addView(gradientBG);
        if(gameTitle!=null) {
            title.addView(gameTitle);
        }
        bgLayout.setY(-(screenHeight / 9));

        Clouds clouds = new Clouds(sun.getX(), sun.getY(),
                fastCloud, mediumCloud, slowCloud, display);
    }

    public void setBackground2(){
        Point size = new Point();
        display.getSize(size);

        float screenWidth = size.x;
        float screenHeight = size.y;

        RelativeLayout.LayoutParams params2 = new RelativeLayout.LayoutParams((int)screenWidth, (int)screenHeight);
        params2.addRule(0);
        params2.addRule(RelativeLayout.CENTER_IN_PARENT );
        bgLayout.setLayoutParams(params2);


        if(setBG == null){
            setBG = "mountains";
        }
        if(hour >= 21 || hour < 5){
            sun.setAlpha(0);
            gradientBG.setImageResource(R.drawable.nightgradient);
            foreground.setImageResource(R.drawable.nightmt);
            if(setBG != null) {
                if (setBG.equals("halloween")) {
                    foreground.setImageResource(R.drawable.halloweennight);
                }
                else if (setBG.equals("forest")) {
                    foreground.setImageResource(R.drawable.forestnight);
                }
            }
            if(gameTitle!=null) {
                gameTitle.setImageTintList(white);
                gameTitle.setAlpha((float) 0.4);
            }
        }
        else if(hour >= 5 && hour < 9){
            gradientBG.setImageResource(R.drawable.sunrisegradient);
            foreground.setImageResource(R.drawable.sunrisemt);
            if(setBG != null) {
                if(setBG.equals("halloween")){
                    foreground.setImageResource(R.drawable.halloweensunrise);
                }
                else if (setBG.equals("forest")) {
                    foreground.setImageResource(R.drawable.forestsunrise);
                }
            }
            if(gameTitle!=null) {
                gameTitle.setImageTintList(white);
                gameTitle.setAlpha((float) 0.5);
            }
        }
        else if(hour >= 9 && hour < 12){
            float x = sun.getX();
            float y = sun.getY();
            sun.setX(x+80);
            sun.setY(y-240);
            gradientBG.setImageResource(R.drawable.dawngradient);
            foreground.setImageResource(R.drawable.dawnmt);
            if(setBG != null) {
                if(setBG.equals("halloween")){
                    foreground.setImageResource(R.drawable.halloweendawn);
                }
                else if (setBG.equals("forest")) {
                    foreground.setImageResource(R.drawable.forestdawn);
                }
            }
            if(gameTitle!=null) {
                gameTitle.setImageTintList(white);
                gameTitle.setAlpha((float) 0.6);
            }
        }
        else if(hour >= 12 && hour < 17){
            float x = sun.getX();
            float y = sun.getY();
            sun.setX(x+200);
            sun.setY(y-650);
            gradientBG.setImageResource(R.drawable.daygradient);
            foreground.setImageResource(R.drawable.daytimemt);
            if(setBG != null) {
                if(setBG.equals("halloween")){
                    foreground.setImageResource(R.drawable.halloweenday);
                }
                else if (setBG.equals("forest")) {
                    foreground.setImageResource(R.drawable.forestday);
                }
            }
            if(gameTitle!=null) {
                gameTitle.setImageTintList(white);
                gameTitle.setAlpha((float) 0.6);
            }
        }
        else if(hour >= 17 && hour < 19){
            float x = sun.getX();
            float y = sun.getY();
            sun.setX(x+320);
            sun.setY(y-240);
            gradientBG.setImageResource(R.drawable.dawngradient);
            foreground.setImageResource(R.drawable.dawnmt);
            if(setBG != null) {
                if (setBG.equals("halloween")) {
                    foreground.setImageResource(R.drawable.halloweendawn);
                }
                else if (setBG.equals("forest")) {
                    foreground.setImageResource(R.drawable.forestdawn);
                }
            }
            if(gameTitle!=null) {
                gameTitle.setImageTintList(white);
                gameTitle.setAlpha((float) 0.6);
            }
        }
        else if(hour >= 19 && hour < 21){
            float x = sun.getX();
            sun.setX(x+440);
            gradientBG.setImageResource(R.drawable.sunrisegradient);
            foreground.setImageResource(R.drawable.sunrisemt);
            if(setBG != null) {
                if(setBG.equals("halloween")){
                    foreground.setImageResource(R.drawable.halloweensunrise);
                }
                else if (setBG.equals("forest")) {
                    foreground.setImageResource(R.drawable.forestsunrise);
                }
            }
            if(gameTitle!=null) {
                gameTitle.setImageTintList(white);
                gameTitle.setAlpha((float) 0.5);
            }
        }

        gradientBG.setLayoutParams(params2);
        bgLayout.addView(gradientBG);
        if(gameTitle!=null) {
            title.addView(gameTitle);
        }
        bgLayout.setY(-(screenHeight / 9));

        Clouds clouds = new Clouds(sun.getX(), sun.getY(),
                fastCloud, mediumCloud, slowCloud, display);
    }
    /**
     * Sets up sky and clouds
     */
    public void setUpdatingBG(){
        Point size = new Point();
        display.getSize(size);

        float screenWidth = size.x;
        float screenHeight = size.y;

        RelativeLayout.LayoutParams params2 = new RelativeLayout.LayoutParams((int)screenWidth, (int)screenHeight);
        params2.addRule(0);
        params2.addRule(RelativeLayout.CENTER_IN_PARENT );
        bgLayout.setLayoutParams(params2);
        gradientBG.setLayoutParams(params2);
        bgLayout.addView(gradientBG);
        bgLayout.setY(-(screenHeight / 9));

        Clouds clouds = new Clouds(sun.getX(), sun.getY(),
                fastCloud, mediumCloud, slowCloud, display);

    }

    /**
     * Updates current background theme
     * @param check
     * @param setBG
     */
    public void updateBG(int check, String setBG){
        this.setBG = setBG;
        if(hour >= 21 || hour < 5){
            sun.setAlpha(0);
            gradientBG.setImageResource(R.drawable.nightgradient);
            foreground.setImageResource(R.drawable.nightmt);
            if(setBG != null) {
                if (setBG.equals("halloween")) {
                    foreground.setImageResource(R.drawable.halloweennight);
                }
                else if (setBG.equals("forest")) {
                    foreground.setImageResource(R.drawable.forestnight);
                }
            }
        }
        else if(hour >= 5 && hour < 9){
            gradientBG.setImageResource(R.drawable.sunrisegradient);
            foreground.setImageResource(R.drawable.sunrisemt);
            if(setBG != null) {
                if(setBG.equals("halloween")){
                    foreground.setImageResource(R.drawable.halloweensunrise);
                }
                else if (setBG.equals("forest")) {
                    foreground.setImageResource(R.drawable.forestsunrise);
                }
            }
        }
        else if(hour >= 9 && hour < 12){
            float x = sun.getX();
            float y = sun.getY();
            if(check == 1) {
                sun.setX(x + 80);
                sun.setY(y - 240);
            }
            gradientBG.setImageResource(R.drawable.dawngradient);
            foreground.setImageResource(R.drawable.dawnmt);
            if(setBG != null) {
                if(setBG.equals("halloween")){
                    foreground.setImageResource(R.drawable.halloweendawn);
                }
                else if (setBG.equals("forest")) {
                    foreground.setImageResource(R.drawable.forestdawn);
                }
            }
        }
        else if(hour >= 12 && hour < 17){
            float x = sun.getX();
            float y = sun.getY();
            if(check == 1) {
                sun.setX(x + 200);
                sun.setY(y - 650);
            }
            gradientBG.setImageResource(R.drawable.daygradient);
            foreground.setImageResource(R.drawable.daytimemt);
            if(setBG != null) {
                if(setBG.equals("halloween")){
                    foreground.setImageResource(R.drawable.halloweenday);
                }
                else if (setBG.equals("forest")) {
                    foreground.setImageResource(R.drawable.forestday);
                }
            }
        }
        else if(hour >= 17 && hour < 19){
            float x = sun.getX();
            float y = sun.getY();
            if(check == 1) {
                sun.setX(x + 320);
                sun.setY(y - 240);
            }
            gradientBG.setImageResource(R.drawable.dawngradient);
            foreground.setImageResource(R.drawable.dawnmt);
            if(setBG != null) {
                if (setBG.equals("halloween")) {
                    foreground.setImageResource(R.drawable.halloweendawn);
                }
                else if (setBG.equals("forest")) {
                    foreground.setImageResource(R.drawable.forestdawn);
                }
            }
        }
        else if(hour >= 19 && hour < 21){
            float x = sun.getX();
            if(check == 1) {
                sun.setX(x + 440);
            }
            gradientBG.setImageResource(R.drawable.sunrisegradient);
            foreground.setImageResource(R.drawable.sunrisemt);
            if(setBG != null) {
                if(setBG.equals("halloween")){
                    foreground.setImageResource(R.drawable.halloweensunrise);
                }
                else if (setBG.equals("forest")) {
                    foreground.setImageResource(R.drawable.forestsunrise);
                }
            }
        }
    }
}
