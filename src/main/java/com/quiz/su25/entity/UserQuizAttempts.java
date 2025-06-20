/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.quiz.su25.entity;
/**
 *
 * @author quangmingdoc
 */

import java.sql.Date;
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
    private Date start_time;
    private Date end_time;
    private Double score;
    private Boolean passed;   //1 - passed n 0 - not passed
    private String status;    //in_progress - completed
    private Date created_at;  
    private Date update_at;
    
}
