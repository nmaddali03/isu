package com.example.app02;

import androidx.appcompat.app.AppCompatActivity;

import android.content.Intent;
import android.graphics.Point;
import android.media.MediaPlayer;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.view.Display;
import android.view.View;
import android.view.WindowManager;
import android.widget.Button;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ProgressBar;
import android.widget.TextView;

import java.util.Timer;
import java.util.TimerTask;

public class Game extends AppCompatActivity{

    private LinearLayout sun;
    private ImageView night;
    private ImageView sunrise;
    private ImageView dawn;
    private ImageView day;
    private ImageView nightSky;
    private ImageView sunriseSky;
    private ImageView dawnSky;
    private ImageView fastCloud;
    private ImageView mediumCloud;
    private ImageView slowCloud;

    private ProgressBar progress;

    private float analogClockX;
    private float analogClockY;

    private TextView instructions;
    private TextView counterText;
    private TextView livesText;
    private TextView location;

    private int counter = 0;
    private Button btnClick;

    private int numLives;

    private int goal = 40;

    private GameBackground bg;

    private MovingObjects analogObj;
    private MovingObjects hourglassObj;

    private ImageButton analogClock;
    private ImageView brokenAnalogClock;

    private ImageButton hourglass;
    private ImageView brokenHourglass;

    private Button startGame;

    private int score;

    private Timer timer = new Timer();
    private Handler handler = new Handler();

    private MediaPlayer gameMusic;
    private MediaPlayer breakSFX;

    private Intent winIntent;
    private Intent loseIntent;

    private String setBG;
    private String user;


    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.game);

        breakSFX = MediaPlayer.create(Game.this, R.raw.breaksfx);

        //get current BG and music from server

        instructions = findViewById(R.id.instructions);
        counterText = findViewById(R.id.counterText);
        livesText = findViewById(R.id.lives);

        sun = findViewById(R.id.sun);

        night = findViewById(R.id.nightMt);
        sunrise = findViewById(R.id.sunriseMt);
        dawn = findViewById(R.id.dawnMt);
        day = findViewById(R.id.daytimeMt);

        //finding user set BG
        Intent intent = getIntent();
        setBG = intent.getStringExtra("setBG");
        user = intent.getStringExtra("username");
        //Set BG to user preference
        if(setBG.equals("halloween")){
            night.setImageResource(R.drawable.halloweennight);
            sunrise.setImageResource(R.drawable.halloweensunrise);
            dawn.setImageResource(R.drawable.halloweendawn);
            day.setImageResource(R.drawable.halloweenday);
            gameMusic = MediaPlayer.create(Game.this, R.raw.spooky);
        }
        else if(setBG.equals("forest")){
            night.setImageResource(R.drawable.forestnight);
            sunrise.setImageResource(R.drawable.forestsunrise);
            dawn.setImageResource(R.drawable.forestdawn);
            day.setImageResource(R.drawable.forestday);
            gameMusic = MediaPlayer.create(Game.this, R.raw.spooky);
        }
        else{
            night.setImageResource(R.drawable.nightmt);
            sunrise.setImageResource(R.drawable.sunrisemt);
            dawn.setImageResource(R.drawable.dawnmt);
            day.setImageResource(R.drawable.daytimemt);
            gameMusic = MediaPlayer.create(Game.this, R.raw.mountains);
        }

        gameMusic.setLooping(true);
        gameMusic.start();

        winIntent = new Intent(this, EndPage.class);
        loseIntent = new Intent(this, EndPageLose.class);

        nightSky = findViewById(R.id.nightGradient);
        sunriseSky = findViewById(R.id.sunriseGradient);
        dawnSky = findViewById(R.id.dawnGradient);
        fastCloud = findViewById(R.id.fastCloud);
        mediumCloud = findViewById(R.id.mediumCloud);
        slowCloud = findViewById(R.id.slowCloud);

        analogClock = findViewById(R.id.analogClock);
        brokenAnalogClock = findViewById(R.id.brokenAnalogClock);

        hourglass = findViewById(R.id.hourglass);
        brokenHourglass = findViewById(R.id.brokenHourglass);

        hourglass.setAlpha((float)0);
        brokenHourglass.setAlpha((float)0);

        analogClock.setAlpha((float)0);
        brokenAnalogClock.setAlpha((float)0);

        startGame = findViewById(R.id.startGame);

        progress = findViewById(R.id.progressBar);

        WindowManager windowManager = getWindowManager();
        Display display = windowManager.getDefaultDisplay();

        Point size = new Point();
        display.getSize(size);

        float screenWidth = size.x;
        float screenHeight = size.y;

        numLives = 3;

        bg = new GameBackground(display, counterText, sun,
                night, sunrise, dawn, day,
                nightSky, sunriseSky, dawnSky,
                fastCloud, mediumCloud, slowCloud
        );
        btnClick = findViewById(R.id.btnClick);
        bg.setSun(-200, 700, true);

        analogClock.setX(screenWidth+100.0f);
        analogClock.setY((float)Math.floor(Math.random()*(screenHeight-analogClock.getHeight())));

        double speed = 8;
        double tempSpeed = speed + (counter*1.5);
        analogObj = new MovingObjects(sun.getX(), sun.getY(),
                analogClock, brokenAnalogClock, (int)tempSpeed, display, numLives, livesText, false);

        hourglass.setX(screenWidth+100.0f);
        hourglass.setY((float)Math.floor(Math.random()*(screenHeight-analogClock.getHeight())));

        double speed2 = 10;
        double tempSpeed2 = speed2 + (counter*1.5);
        hourglassObj = new MovingObjects(sun.getX(), sun.getY(),
                hourglass, brokenHourglass, (int)tempSpeed2, display, numLives, livesText, false);

        analogClock.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                counterGame(goal, analogClock, analogObj, 1);
                analogObj.breakObj();
            }
        });

        hourglass.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                breakSFX.start();
                counterGame(goal, hourglass, hourglassObj, 2);
                hourglassObj.breakObj();
            }
        });
        startGame.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                startGame.setAlpha((float)0);
                hourglass.setAlpha((float)1);
                analogClock.setAlpha((float)1);
                moveObj(display);
            }
        });
    }

    public void startActivityFromMainThread(){
        Handler handler = new Handler(Looper.getMainLooper());
        handler.post(new Runnable() {
            @Override
            public void run() {
                if (numLives <= 0) {
                    if (counter >= goal) {
                        doneCounting();
                    }
                    else{
                        loseGame();
                    }
                }
            }
        });
    }

    /**
     * moves object that must be destroyed
     * @param display
     */
    public void moveObj(Display display) {
        timer.schedule(new TimerTask(){
            @Override
            public void run() {
                while (numLives > 0) {
                    handler.post(new Runnable() {
                        @Override
                        public void run() {
                            analogObj.updateObjPos(analogClock, analogClock.getX());
                            if (analogObj.lostLife()) {
                                numLives--;
                            }
                            analogObj.setLostLife(false);
                            hourglassObj.updateObjPos(hourglass, hourglass.getX());
                            if (hourglassObj.lostLife()) {
                                numLives--;
                            }
                            hourglassObj.setLostLife(false);
                            updateLivesText();
                        }
                    });
                    try {
                        Thread.sleep(20);

                    } catch (InterruptedException e) {
                        e.printStackTrace();
                    }
                startActivityFromMainThread();
                }
            }
        }, 0, 20);
    }

    /**
     * Counts score and how many objects were broke
     * @param goal
     * @param btnClick
     * @param obj
     * @param value
     */
    public void counterGame(int goal, ImageButton btnClick, MovingObjects obj, int value){
        if(breakSFX.isPlaying()){
            breakSFX.pause();
        }
        breakSFX.seekTo(0);
        breakSFX.start();


        WindowManager windowManager = getWindowManager();
        Display display = windowManager.getDefaultDisplay();

        Point size = new Point();
        display.getSize(size);

        float screenWidth = size.x;
        float temp0 = btnClick.getAlpha();
        if(btnClick.getAlpha() != 1){
            return;
        }
        double speed = screenWidth/135;
        double tempSpeed = speed + (counter/5);
        obj.updateSpeed((int)tempSpeed);
        double tempSpeed2 = speed + (counter/4.8);
        obj.updateSpeed((int)tempSpeed2);

        double goalD = goal;

        if(counter == 5){
            instructions.setAlpha(0F);
        }
        if(counter > goalD/4 && counter < goal) {
            bg.moveSun();
        }
        if(counter >= goalD/1.5) {
            bg.changeOpacity(dawn, day, dawnSky);
        }

        else if(counter >= goalD/2.3) {
            bg.changeOpacity(sunrise, dawn, sunriseSky);
        }
        else if(counter >= goalD/5.8) {
            bg.changeOpacity(night, sunrise, nightSky);
        }
        score += value;
        counter ++;
        counterText.setText("Score: " + score);
        double temp2 = ((counter + 0.0)/(goal + 0.0))* 100;
        progress.setProgress((int)temp2);

        if(obj.isDead()){
            if(counter >= goal)
                doneCounting();
            loseGame();
        }
    }

    /**
     * updates lives in textView
     */
    public void updateLivesText(){
        livesText.setText("lives: " + numLives);
    }

    /**
     * Checks if enough clocks were broken to win the game and sends user to win EndPage
     */
    public void doneCounting(){
        try {
            Thread.sleep(50);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        int temp [] = new int[1];
        temp[0] = score;
        winIntent.putExtra("username", user);
        winIntent.putExtra("score", temp);
        gameMusic.stop();
        winIntent.putExtra("setBG", setBG);
        startActivity(winIntent);
        overridePendingTransition(android.R.anim.fade_in, android.R.anim.fade_out);
    }

    /**
     * If the user didn't break enough clocks to win, they go to loseEndPage
     */
    public void loseGame(){
        try {
            Thread.sleep(50);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        gameMusic.stop();
        int temp [] = new int[1];
        temp[0] = score;
        loseIntent.putExtra("username", user);
        loseIntent.putExtra("score", temp);
        loseIntent.putExtra("setBG", setBG);
        startActivity(loseIntent);
        overridePendingTransition(android.R.anim.fade_in, android.R.anim.fade_out);

    }
}
