/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.quiz.su25.entity;

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
public class Quizzes {
    private Integer id;
    private String name;
    private Integer lesson_id;
    private String level;
    private Integer number_of_questions_target;
    private Integer duration_minutes;
    private Double pass_rate;
    private String quiz_type;
    private String status;
    private Date created_at;
    private Date updated_at;
    private Integer created_by;
}
