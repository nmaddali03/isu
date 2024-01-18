package com.example.app02;

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

import android.content.res.ColorStateList;
import android.widget.LinearLayout;

import androidx.arch.core.executor.testing.InstantTaskExecutorRule;

@RunWith(MockitoJUnitRunner.class)
public class chatTest {
    private static final String TEST_USERNAME = "maisyTest2";
    private static final String TEST_FRIEND = "maisyTest";

    @Mock
    ChatMessages mock;

    @Mock
    Chat mock2;

    @Before
    public void init() {
        mock2 = new Chat();
        MockitoAnnotations.initMocks(this);

    }
    @After
    public void breakdown() {
        mock = null;
    }

    @Rule
    public TestRule rule = new InstantTaskExecutorRule();

    @Test
    public void validFriend() {
        // Valid login
        when(mock2.validFriend(TEST_FRIEND, TEST_USERNAME)).thenReturn(true);
        assertTrue(mock2.validFriend(TEST_FRIEND, TEST_USERNAME));
    }

    @Test
    public void invalidFriend() {
        // inValid friend
        when(mock2.validFriend(TEST_USERNAME, TEST_USERNAME)).thenReturn(false);
        assertFalse(mock2.validFriend(TEST_USERNAME, TEST_USERNAME));
    }

}
