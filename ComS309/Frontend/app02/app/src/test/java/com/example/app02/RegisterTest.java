package com.example.app02;

import android.content.Context;

import org.junit.After;
import org.junit.Before;
import org.junit.Rule;
import org.junit.Test;
import org.junit.rules.TestRule;
import org.junit.runner.RunWith;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import org.mockito.junit.MockitoJUnitRunner;

import static org.junit.Assert.*;
import static org.mockito.Mockito.when;

import androidx.arch.core.executor.testing.InstantTaskExecutorRule;

@RunWith(MockitoJUnitRunner.class)
public class RegisterTest {
    private static final String TEST_EMAIL = "test@email.com";
    private static final String FAKE_TEST_EMAIL = "t@e.cm";
    private static final String TEST_PASSWORD = "Test12345";
    private static final String FAKE_TEST_PASSWORD = "Test";

    @Mock
    Register mRegister;

    @Before
    public void init() {
        //RxAndroidPlugins.setInitMainThreadSchedulerHandler(scheduler -> Schedulers.trampoline());

        mRegister = new Register();
        MockitoAnnotations.initMocks(this);

    }

    @After
    public void breakdown() {
        mRegister = null;
    }

    @Rule
    public TestRule rule = new InstantTaskExecutorRule();

    @Test
    public void validEmailAndPassword() {
        // Valid login
        when(mRegister.checkCredentials(TEST_EMAIL, TEST_PASSWORD)).thenReturn(true);
        assertTrue(mRegister.checkCredentials(TEST_EMAIL, TEST_PASSWORD));
    }

    @Test
    public void validPasswordNotEmail() {
        // Invalid login - invalid email
        when(mRegister.checkCredentials(FAKE_TEST_EMAIL, TEST_PASSWORD)).thenReturn(false);
        assertFalse(mRegister.checkCredentials(FAKE_TEST_EMAIL, TEST_PASSWORD));
    }

    @Test
    public void validEmailNotPassword() {
        // Invalid login - invalid password
        when(mRegister.checkCredentials(TEST_EMAIL, FAKE_TEST_PASSWORD)).thenReturn(false);
        assertFalse(mRegister.checkCredentials(TEST_EMAIL, FAKE_TEST_PASSWORD));
    }
}