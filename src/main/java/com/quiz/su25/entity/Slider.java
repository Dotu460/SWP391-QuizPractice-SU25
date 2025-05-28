/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.quiz.su25.entity;

/**
 *
 * @author LENOVO
 */

import java.sql.Date;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class Slider {
    private Integer id;
    private String title;
    private String image_url;
    private String backlink_url;
    private String status;
    private Boolean display_order;
    private String notes;
    private Date created_at;
    private Date update_at;
    private Integer created_by;
}