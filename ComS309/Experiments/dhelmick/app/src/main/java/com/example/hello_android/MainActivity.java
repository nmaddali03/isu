package com.example.hello_android;

import androidx.appcompat.app.AppCompatActivity;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;

public class MainActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        Button buttonToCounter = findViewById(R.id.activity_main_buttonToCounter);
        Button buttonToRave = findViewById(R.id.activity_main_buttonToRave);
        Button buttonToWAC = findViewById(R.id.activity_main_buttonToWAC);
        Button helloWorldButton = findViewById(R.id.activity_main_helloWorld);
        TextView titleText = findViewById(R.id.activity_main_text);

        helloWorldButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                titleText.setText("Hello World!");
            }
        });
        buttonToCounter.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                startActivity(new Intent(view.getContext(), Counter.class));
            }
        });
        buttonToRave.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                startActivity(new Intent(view.getContext(), Rave.class));
            }
        });
        buttonToWAC.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                startActivity(new Intent(view.getContext(), WAC.class));
            }
        });
    }
}