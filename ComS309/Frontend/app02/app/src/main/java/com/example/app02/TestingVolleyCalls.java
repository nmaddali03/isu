package com.example.app02;

import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.os.PersistableBundle;
import android.view.View;
import android.widget.Button;

import androidx.annotation.Nullable;
import androidx.appcompat.app.AppCompatActivity;

import com.example.net_utils.NetworkCalls;

import org.json.JSONException;

/*
Solely for testing. Will be deleted.
 */
public class TestingVolleyCalls extends AppCompatActivity {

    private Button updateScoreButton;
    private Context mContext;

    @Override
    public void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_testing_volley_calls);

        updateScoreButton = findViewById(R.id.button_update_score);

        updateScoreButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                try {
                    updateScoreTest();
                } catch (JSONException e) {
                    e.printStackTrace();
                }
            }
        });

    }

    public void updateScoreTest() throws JSONException {
        //NetworkCalls.updateScore(1, 0, 5, 10);
    }
}
