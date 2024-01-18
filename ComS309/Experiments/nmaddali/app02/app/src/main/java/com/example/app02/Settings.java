package com.example.app02;

import androidx.annotation.RequiresApi;
import androidx.appcompat.app.AppCompatActivity;

import android.app.Activity;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.preference.PreferenceManager;
import android.util.Log;
import android.view.View;
//import android.widget.DatePicker;
import android.widget.EditText;
import android.widget.Toast;
import java.util.Calendar;

import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.media.AudioManager;
import android.os.Build;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.SeekBar;
import android.widget.Toast;

import com.android.volley.Request;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.JsonArrayRequest;
import com.example.net_utils.NetworkCalls;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

public class Settings extends AppCompatActivity {

    private static final String TAG = "Settings";
    private SharedPreferencesHelper mSharedPreferencesHelper;
    private EmailValidator mEmailValidator;

    private SeekBar adjustVolBar;
    private AudioManager audioManager;
    private Button btnUp;
    private Button btnDown;
    private Button btnMain;
    private Button btnAdminSettings;
    private Button logout;
    private Button btnUpdateEmail;
    private EditText editEmail;
    private Button btnUpdateUsername;
    private EditText editUsername;
    private Button btnUpdatePassword;
    private EditText editPassword;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_settings);

        adjustVolBar = findViewById(R.id.adjustVolBar);
        btnUp = findViewById(R.id.volUpButton);
        btnDown = findViewById(R.id.volDownButton);
        btnMain = findViewById(R.id.exitButton);
        btnAdminSettings = findViewById(R.id.adminSettingsButton);
        audioManager = (AudioManager) getApplicationContext().getSystemService(Context.AUDIO_SERVICE);
        adjustVolBar.setMax(audioManager.getStreamMaxVolume(AudioManager.STREAM_MUSIC));
        adjustVolBar.setProgress(audioManager.getStreamVolume(AudioManager.STREAM_MUSIC));
        logout = findViewById(R.id.logoutButton);
        btnUpdateEmail = findViewById(R.id.changeEmailButton);
        editEmail = findViewById(R.id.editEmail);

        mEmailValidator = new EmailValidator();
        editEmail.addTextChangedListener(mEmailValidator);
        SharedPreferences sharedPreferences = PreferenceManager.getDefaultSharedPreferences(this);
        mSharedPreferencesHelper = new SharedPreferencesHelper(sharedPreferences);
        // Fill input fields from data retrieved from the SharedPreferences.
        populateUi();

        btnUpdateUsername = findViewById(R.id.changeUsernameButton);
        editUsername = findViewById(R.id.editUsername);
        btnUpdatePassword = findViewById(R.id.changePasswordButton);
        editPassword = findViewById(R.id.editPassword);

        btnUp.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                UpButton();
            }
        });

        btnDown.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                DownButton();
            }
        });

        btnMain.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                openMainMenu();
            }
        });

        btnAdminSettings.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (MainMenu.currUser.isAdmin()) {
                    openAdminSettings();
                } else {
                    Toast.makeText(getApplicationContext(), "You are not an admin.", Toast.LENGTH_SHORT).show();
                }
            }
        });

        logout.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                logoutAndOpenLogin();
            }
        });

        btnUpdateEmail.setOnClickListener(new View.OnClickListener(){
            @Override
            public void onClick(View view) {
                if(editEmail.getText().length()>0) {
                    String newEmail = editEmail.getText().toString();
                    try {
                        NetworkCalls.updateUserEmail(newEmail);
                    } catch (JSONException e) {
                        e.printStackTrace();
                    }
                }
            }
        });

        btnUpdateUsername.setOnClickListener(new View.OnClickListener(){
            @Override
            public void onClick(View view) {
                if(editUsername.getText().length()>0) {
                    String newUsername = editUsername.getText().toString();
                    try {
                        NetworkCalls.updateUserName(newUsername);
                    } catch (JSONException e) {
                        e.printStackTrace();
                    }
                }
            }
        });

        btnUpdatePassword.setOnClickListener(new View.OnClickListener(){
            @Override
            public void onClick(View view) {
                if(editPassword.getText().length()>0) {
                    String newPassword = editPassword.getText().toString();
                    try {
                        NetworkCalls.updatePassword(newPassword);
                    } catch (JSONException e) {
                        e.printStackTrace();
                    }
                }
            }
        });
    }

    private void logoutAndOpenLogin() {
        SharedPreferences pref = getSharedPreferences("checkbox", MODE_PRIVATE);
        SharedPreferences.Editor editor = pref.edit();
        editor.putString("remember", "false");
        editor.apply();
        openLogin();
    }

    private void UpButton() {
        audioManager.adjustVolume(AudioManager.ADJUST_RAISE, AudioManager.FLAG_PLAY_SOUND);
        adjustVolBar.setProgress(audioManager.getStreamVolume(AudioManager.STREAM_MUSIC));
        Toast.makeText(this, "Volume Up", Toast.LENGTH_SHORT).show();

    }

    private void DownButton() {
        audioManager.adjustVolume(AudioManager.ADJUST_LOWER, AudioManager.FLAG_PLAY_SOUND);
        adjustVolBar.setProgress(audioManager.getStreamVolume(AudioManager.STREAM_MUSIC));
        Toast.makeText(this, "Volume Down", Toast.LENGTH_SHORT).show();
    }

    public void openMainMenu() {
        Intent intent = new Intent(this, MainMenu.class);
        startActivity(intent);
        overridePendingTransition(android.R.anim.fade_in, android.R.anim.fade_out);
    }

    public void openAdminSettings() {
        Intent intent = new Intent(this, AdminSettings.class);
        startActivity(intent);
        overridePendingTransition(android.R.anim.fade_in, android.R.anim.fade_out);
    }

    public void openLogin() {
        Intent intent = new Intent(this, LoginHome.class);
        startActivity(intent);
        overridePendingTransition(android.R.anim.fade_in, android.R.anim.fade_out);
    }

    private void populateUi() {
        SharedPreferenceEntry sharedPreferenceEntry;
        sharedPreferenceEntry = mSharedPreferencesHelper.getPersonalInfo();
        //Calendar dateOfBirth = sharedPreferenceEntry.getDateOfBirth();
        //mDobPicker.init(dateOfBirth.get(Calendar.YEAR), dateOfBirth.get(Calendar.MONTH),
        //dateOfBirth.get(Calendar.DAY_OF_MONTH), null);
        editEmail.setText(sharedPreferenceEntry.getEmail());
    }

    public void onSaveClick(View view) {
        // Don't save if the fields do not validate.
        if (!mEmailValidator.isValid()) {
            editEmail.setError("Invalid email");
            Log.w(TAG, "Not saving personal information: Invalid email");
            return;
        }
        // Get the text from the input fields.
        //String name = mNameText.getText().toString();
        //Calendar dateOfBirth = Calendar.getInstance();
        //dateOfBirth.set(mDobPicker.getYear(), mDobPicker.getMonth(), mDobPicker.getDayOfMonth());
        String email = editEmail.getText().toString();
        // Create a Setting model class to persist.
        SharedPreferenceEntry sharedPreferenceEntry =
                new SharedPreferenceEntry(email);
        // Persist the personal information.
        boolean isSuccess = mSharedPreferencesHelper.savePersonalInfo(sharedPreferenceEntry);
        if (isSuccess) {
            Toast.makeText(this, "Personal information saved", Toast.LENGTH_LONG).show();
            Log.i(TAG, "Personal information saved");
        } else {
            Log.e(TAG, "Failed to write personal information to SharedPreferences");
        }
    }
}