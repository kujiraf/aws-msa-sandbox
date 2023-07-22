package com.example.backend.app.model;

import lombok.Getter;
import lombok.Setter;

import java.io.Serial;
import java.io.Serializable;

@Getter
@Setter
public class User implements Serializable {

    @Serial
    private static final long serialVersionUID = 1L;

    private int userId;
    private String userName;

    private User(Builder builder){
        this.setUserId(builder.userId);
        this.setUserName(builder.userName);
    }

    public static class Builder{
        private int userId;
        private String userName;

        public Builder userId(int userId){
            this.userId = userId;
            return this;
        }
        public Builder userName(String userName){
            this.userName = userName;
            return this;
        }
        public User build(){
            return new User(this);
        }
    }

}
