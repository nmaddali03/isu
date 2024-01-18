package com.example.app02;

import android.content.Intent;
import android.media.Ringtone;
import android.media.RingtoneManager;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.TextClock;
import android.widget.TimePicker;

//import android.support.v7.app.AppCompactActivity

import androidx.appcompat.app.AppCompatActivity;

import java.util.Timer;
import java.util.TimerTask;

//import android.support.v7.app.AppCompactActivity


public class SetAlarm extends AppCompatActivity {

    TimePicker alarmTime;
    TextClock currentTime;
    Button btnMain;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_set_alarm);

        alarmTime = findViewById(R.id.timePicker);
        currentTime = findViewById(R.id.textClock);
        final Ringtone r = RingtoneManager.getRingtone(getApplicationContext(), RingtoneManager.getDefaultUri(RingtoneManager.TYPE_RINGTONE));

        btnMain = findViewById(R.id.btnExit);

        btnMain.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                openMain();
            }
        });

        Timer t = new Timer();

        t.scheduleAtFixedRate(new TimerTask(){
            @Override
            public void run(){
                if(currentTime.getText().toString().equals(AlarmTime())){
                    r.play();
                    openGame();
                }
                else{
                    r.stop();
                }
            }
        }, 0, 1000);
    }

    private String AlarmTime() {
        Integer alarmHours = alarmTime.getCurrentHour();
        Integer alarmMinutes = alarmTime.getCurrentMinute();
        String stringAlarmMinutes;

        if(alarmMinutes < 10){
            stringAlarmMinutes = "0";
            stringAlarmMinutes = stringAlarmMinutes.concat(alarmMinutes.toString());
        }
        else{
            stringAlarmMinutes = alarmMinutes.toString();
        }

        String stringAlarmTime;

        if(alarmHours>12){
            alarmHours = alarmHours - 12;
            stringAlarmTime = alarmHours.toString().concat(":").concat(stringAlarmMinutes).concat(" PM");
        }
        else{
            stringAlarmTime = alarmHours.toString().concat(":").concat(stringAlarmMinutes).concat(" AM");
        }
        return stringAlarmTime;
    }

    public void openMain(){
        Intent intent = new Intent(this, MainMenu.class);
        startActivity(intent);
        overridePendingTransition(android.R.anim.fade_in, android.R.anim.fade_out);
    }

    public void openGame(){
        Intent intent = new Intent(this, Game.class);
        startActivity(intent);
        overridePendingTransition(android.R.anim.fade_in, android.R.anim.fade_out);
    }
}