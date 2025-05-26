package com.quiz.su25.entity;

import lombok.*;

import java.time.LocalDateTime;

@ToString
@Builder
@Data
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter

public class User {
    private Integer user_id;
    private String full_name;
    private String email;
    private String password_hash;
    private boolean gender;
    private String mobile;
    private String avatar_url;
    private Role role;
    private String status;
}
