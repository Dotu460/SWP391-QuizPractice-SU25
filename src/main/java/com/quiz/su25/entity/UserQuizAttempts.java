/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.quiz.su25.entity;
/**
 *
 * @author quangmingdoc
 */

import java.sql.Timestamp;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@ToString
@Builder
@Data
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter

public class UserQuizAttempts {
    private Integer id;
    private Integer user_id;
    private Integer quiz_id;
    private Timestamp start_time;
    private Timestamp end_time;
    private Double score;
    private Boolean passed;   //1 - passed n 0 - not passed
    private String status;    //in_progress - completed
    private Timestamp created_at;  
    private Timestamp update_at;
    
}
