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
public class ItemTest {
    private static final String BG = "forest";
    private static final String FORESTCLICKED = "true";

    private static final String BG_FALSE = "mountains";
    private static final String FOREST_NOT_CLICKED = "false";

    @Mock
    items mock;

    @Before
    public void init() {
        mock = new items();
        MockitoAnnotations.initMocks(this);
        mock.forestClicked = true;

    }
    @After
    public void breakdown() {
        mock = null;
    }

    @Rule
    public TestRule rule = new InstantTaskExecutorRule();

    @Test
    public void validItem() {
        // Valid login
        when(mock.checkItems(BG)).thenReturn(true);
        assertTrue(mock.checkItems(BG));
    }

    @Test
    public void invalidItem() {
        // inValid item
        when(mock.checkItems(BG_FALSE)).thenReturn(false);
        assertFalse(mock.checkItems(BG_FALSE));
    }
}
