package com.bacooo.generic_modul.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class HealthController {

    @GetMapping(value = "/", produces = "text/plain")
    public String healthCheck() {
        return "Uygulama ayakta";
    }
}