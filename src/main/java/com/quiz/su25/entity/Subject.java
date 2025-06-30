package com.quiz.su25.entity;
import java.util.Date;
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

public class Subject {
    private Integer id;
    private String title;
    private String thumbnail_url;
    private String video_url;
    private String tag_line;
    private String brief_info;
    private String description;
    private Boolean featured_flag;
    private Integer category_id;
    private String status;
    private Integer owner_id;
    private Date created_at;
    private Date updated_at;
    private Integer created_by;
    private Integer updated_by;
}
