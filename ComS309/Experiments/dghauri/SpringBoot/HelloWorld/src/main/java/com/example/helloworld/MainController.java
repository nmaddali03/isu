package com.example.helloworld;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RestController;



@RestController
public class MainController {


    @GetMapping("/")
    public String welcome() {
        return "Hello World! Willkommen auf dem CS309 Klasse!";
    }

    @GetMapping("/{name}")
    public String welcome(@PathVariable String name) {
        return "Hello World! Willkommen auf dem CS309 Klasse: " + name;
    }

}
