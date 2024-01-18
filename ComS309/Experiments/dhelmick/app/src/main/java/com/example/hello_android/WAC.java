package com.example.hello_android;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.ImageView;

import androidx.appcompat.app.AppCompatActivity;

import java.util.Random;

public class WAC extends AppCompatActivity {

    private ImageView[] imgs;
    private ImageView selected;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.wac);


        Button backButton = findViewById(R.id.wac_back_button);
        ImageView img1 = findViewById(R.id.imageView);
        ImageView img2 = findViewById(R.id.imageView2);
        ImageView img3 = findViewById(R.id.imageView3);
        ImageView img4 = findViewById(R.id.imageView4);
        ImageView img5 = findViewById(R.id.imageView5);
        ImageView img6 = findViewById(R.id.imageView6);
        ImageView img7 = findViewById(R.id.imageView7);
        ImageView img8 = findViewById(R.id.imageView8);
        ImageView img9 = findViewById(R.id.imageView9);

        imgs = new ImageView[]{img1, img2, img3, img4, img5, img6, img7, img8, img9};

        backButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                startActivity(new Intent(view.getContext(), MainActivity.class));
            }
        });
        View.OnClickListener imgClick = new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                selected.setVisibility(View.INVISIBLE);
                selected.setClickable(false);

                wackACy();
            }
        };
        img1.setOnClickListener(imgClick);
        img2.setOnClickListener(imgClick);
        img3.setOnClickListener(imgClick);
        img4.setOnClickListener(imgClick);
        img5.setOnClickListener(imgClick);
        img6.setOnClickListener(imgClick);
        img7.setOnClickListener(imgClick);
        img8.setOnClickListener(imgClick);
        img9.setOnClickListener(imgClick);

        wackACy();
    }

    private void wackACy(){
        Random rand = new Random();
        int i = rand.nextInt(9);

        selected=imgs[i];
        selected.setVisibility(View.VISIBLE);
        selected.setClickable(true);
    }
}