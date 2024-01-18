package com.example.helloworld;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

public class InterceptorRegistry implements WebMvcConfigurer {


    @Autowired
    private IPAddressDisplay obj;

    @Override
    public void addInterceptors(org.springframework.web.servlet.config.annotation.InterceptorRegistry registry) {

        registry.addInterceptor(obj);
    }

}
