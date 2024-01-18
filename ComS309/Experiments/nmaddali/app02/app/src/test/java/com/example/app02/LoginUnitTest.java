package com.example.app02;

import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.core.Is.is;

import android.content.Context;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.Mock;
import org.mockito.junit.MockitoJUnitRunner;

@RunWith(MockitoJUnitRunner.class)
public class LoginUnitTest {

    private static final String FAKE_STRING = "Login was successful";

    @Mock
    Context mMockContext;

    @Test
    public void readStringFromContext_LocalizedString() {

        LoginHome myObjectUnderTest = new LoginHome(mMockContext);

        // ...when the string is returned from the object under test...
        String result = myObjectUnderTest.validate("maisyTest", "test");

        // ...then the result should be the expected one.
        assertThat(result, is(FAKE_STRING));
    }

}