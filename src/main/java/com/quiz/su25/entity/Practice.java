package com.quiz.su25.entity;

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
public class Practice {
    private Integer id;
    private Integer user_id;
    private Integer subject_id;
    private Integer number_of_questions;
    private String question_selection_type; // "by_topic", "by_dimension", "random"
    private String selected_topics; // JSON string for topic IDs
    private String selected_dimensions; // JSON string for dimension IDs
    private Timestamp created_at;
    private String status; // "draft", "active", "completed"

} 