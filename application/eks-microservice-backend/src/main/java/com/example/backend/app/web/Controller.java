package com.example.backend.app.web;

import com.example.backend.app.model.User;
import lombok.extern.slf4j.Slf4j;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.ArrayList;
import java.util.List;

@RestController
@RequestMapping("/api/v1")
@Slf4j
public class Controller {

    private static final Logger LOGGER = LoggerFactory.getLogger(Controller.class);

    @GetMapping("/users")
    public List<User> getUser(){
        LOGGER.trace("#getUser is called");
        List<User> users = new ArrayList<>();
        users.add(new User.Builder().userId(1).userName("taro").build());
        users.add(new User.Builder().userId(2).userName("jiro").build());
        return users;
    }
}
