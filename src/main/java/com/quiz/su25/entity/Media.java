package com.quiz.su25.entity;

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
public class Media {
    private Integer id;
    private Integer subjectId;
    private String link;
    private Integer type; // 0: image, 1: video
    private String notes;
    
    // Convenience methods
    public boolean isImage() {
        return type != null && type == 0;
    }
    
    public boolean isVideo() {
        return type != null && type == 1;
    }
    
    public String getTypeString() {
        if (type == null) return "unknown";
        return type == 0 ? "image" : "video";
    }
}
