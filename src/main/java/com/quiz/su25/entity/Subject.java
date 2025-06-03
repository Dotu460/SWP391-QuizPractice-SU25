
package com.quiz.su25.entity;
import java.time.LocalDateTime;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;


@Entity
@ToString
@Builder
@Data
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
//public class Subject {
//    private Integer id;
//    private String title;
//    private String thumbnail_url;
//    private String brief_info;
//    private String description;
//    private Integer subjectcategories_id;
//    private String status;
//}

public class Subject {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Integer id;

    private String title;

    @Column(name = "thumbnail_url")
    private String thumbnailUrl;

    @Column(name = "tag_line")
    private String tagLine;

    @Column(name = "brief_info", columnDefinition = "TEXT")
    private String briefInfo;

    @Column(columnDefinition = "TEXT")
    private String description;

    @Column(name = "category_id")
    private Integer categoryId;

//    @ManyToOne
//    @JoinColumn(name = "owner_id", referencedColumnName = "id")
//    private User owner;
    @Column(name = "owner_id")
    private Integer ownerId;

    private String status;

    @Column(name = "featured_flag")
    private Boolean featuredFlag;

    @Column(name = "created_at")
    private LocalDateTime createdAt;

    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

//    @ManyToOne
//    @JoinColumn(name = "created_by", referencedColumnName = "id")
//    private User createdBy;
//
//    @ManyToOne
//    @JoinColumn(name = "updated_by", referencedColumnName = "id")
//    private User updatedBy;

    @Column(name = "created_by")
    private Integer createdById;

    @Column(name = "updated_by")
    private Integer updatedById;
}
