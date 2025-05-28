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
public class PricePackage {
    private Integer id;
    private Integer subject_id;
    private String package_name;
    private double list_price;
    private double sale_price;
    private String status;
    private String description;
    private Date created_at;
    private Date updated_at;
            
}
