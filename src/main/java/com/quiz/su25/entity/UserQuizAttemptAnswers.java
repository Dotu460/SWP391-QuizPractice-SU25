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

public class UserQuizAttemptAnswers {
   private Integer id;
   private Integer attempt_id;
   private Integer quiz_question_id;
   private Integer selected_option_id;
   private Boolean correct;  //1 - correct 0 - incorrect
   private Timestamp answer_at;
   private String essay_answer;
   private Double essay_score;
   private String essay_feedback;
}
