/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.quiz.su25.entity;

/**
 *
 * @author LENOVO
 */
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.sql.Date;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class Post {
    private Integer id;
    private String title;
    private String category;
    private String thumbnail_url;
    private String brief_info;
    private String content;
    private Integer category_id;
    private Integer author_id;
    private Date published_at;
    private Date updated_at;
    private Date created_at;
    private String status;
    private Boolean featured_flag;
    private Integer view_count;
}