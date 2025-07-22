/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.quiz.su25.config;

/**
 *
 * @author FPT
 */
public class GlobalConfig {
    
    public static final String SESSION_ACCOUNT = "account";
    
    // Role Constants
    public static final int ROLE_ADMIN = 1;
    public static final int ROLE_STUDENT = 2;
    public static final int ROLE_INSTRUCTOR = 3;
    
    // Quiz Attempt Status Constants
    public static final String QUIZ_ATTEMPT_STATUS_IN_PROGRESS = "in_progress";
    public static final String QUIZ_ATTEMPT_STATUS_COMPLETED = "completed";
    public static final String QUIZ_ATTEMPT_STATUS_ABANDONED = "abandoned";
    public static final String QUIZ_ATTEMPT_STATUS_PARTIALLY_GRADED = "partially_graded";
}
