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
    private LocalDateTime email_verified_at;
    private String reset_password_token;
    private LocalDateTime reset_password_expires;
}
