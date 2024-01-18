package com.example.helloworld;

import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@Component
public class IPAddressDisplay implements HandlerInterceptor {

    public boolean preHandle(HttpServletRequest req, HttpServletResponse resp, Object handler) throws Exception{

        String IP = req.getHeader("X-Forward-For");

        if (IP == null) {
            IP = req.getRemoteAddr();
        }

        System.out.println(IP);
        return false;
    }
}
