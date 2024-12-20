package com.sims.qsc.store_inspection.vo;

import lombok.*;

import java.util.ArrayList;
import java.util.List;

@Getter
@Setter
@Builder
@NoArgsConstructor
@ToString
public class StoreInspectionPopupRequest {
    private Long chklstId;
    private String storeNm;
    private String inspPlanDt;

    private Long inspResultId; // 점검결과 ID
    private Long inspSchdId; // 점검일정 ID
    private String inspComplW; // 점검완료여부
    private Long creMbrId; // 등록자 ID

    private List<CategoryInspection> inspections;

    private String signImgPath; // 서명 이미지 경로
    private String totalReview; // 총평

    private Integer totalScore; // 총점
    private Integer totalPenalty; // 총과태료
    private Integer totalClosureDays; // 총영업정지일수

    @Builder
    public StoreInspectionPopupRequest(Long chklstId, String storeNm, String inspPlanDt, Long inspResultId, Long inspSchdId,  String inspComplW, Long creMbrId, List<CategoryInspection> inspections, String signImgPath, String totalReview, Integer totalScore, Integer totalPenalty, Integer totalClosureDays) {
        this.chklstId = chklstId;
        this.storeNm = storeNm;
        this.inspPlanDt = inspPlanDt;

        this.inspResultId = inspResultId;
        this.inspSchdId = inspSchdId;
        this.inspComplW = inspComplW;
        this.creMbrId = creMbrId;

        this.inspections = inspections != null ? inspections : List.of(); // null 체크 및 기본값 설정

        this.signImgPath = signImgPath;
        this.totalReview = totalReview;

        this.totalScore = totalScore;
        this.totalPenalty = totalPenalty;
        this.totalClosureDays = totalClosureDays;

    }

    @Getter
    @Setter
    @NoArgsConstructor
    @ToString
    public static class CategoryInspection {
        private String categoryName; // 예: '중대법규', '기타법규', '위생관리'
        private List<SubcategoryInspection> subcategories;

        @Builder
        public CategoryInspection(String categoryName, List<SubcategoryInspection> subcategories) {
            this.categoryName = categoryName;
            this.subcategories = subcategories != null ? subcategories : List.of(); // null 체크 및 기본값 설정
        }
    }

    @Getter
    @Setter
    @NoArgsConstructor
    @ToString
    public static class SubcategoryInspection {
        private String subcategoryName; // 예: '영업취소', '영업정지 1개월', 등
//        private List<String> photoPaths; // 사진 경로 목록
        private List<Photo> photos; // 변경된 부분

        // 추가 필드 (예: EVIT_ID, answerContent 등)
        private Long evitId;
        private String answerContent;
        private String pdtNmDtplc;
        private String vltContent;
        private Integer vltCnt;
        private String caupvdCd;
        private String vltCause;
        private String instruction;
        private String vltPlcCd;
        private Long creMbrId; // 추가된 필드
        private Long inspResultId;

        private boolean shouldMergeVLT;
        private boolean shouldMergeAnswImg;

        @Builder
        public SubcategoryInspection(String subcategoryName, List<Photo> photos,
                                     Long evitId, String answerContent, String pdtNmDtplc, String vltContent,
                                     Integer vltCnt, String caupvdCd, String vltCause, String instruction,
                                     String vltPlcCd, Long creMbrId,Long inspResultId) {
            this.subcategoryName = subcategoryName;
//            this.photoPaths = photoPaths != null ? photoPaths : List.of(); // null 체크 및 기본값 설정
            this.photos = photos != null ? photos : new ArrayList<>();
            this.evitId = evitId;
            this.answerContent = answerContent;
            this.pdtNmDtplc = pdtNmDtplc;
            this.vltContent = vltContent;
            this.vltCnt = vltCnt;
            this.caupvdCd = caupvdCd;
            this.vltCause = vltCause;
            this.instruction = instruction;
            this.vltPlcCd = vltPlcCd;
            this.creMbrId = creMbrId;
            this.inspResultId = inspResultId;



        }
    }

    // Photo 클래스 추가
    @Getter
    @Setter
    @NoArgsConstructor
    @ToString
    @Builder
    public static class Photo {
        private Integer seq;
        private String photoPath;

        @Builder
        public Photo(Integer seq, String photoPath) {
            this.seq = seq;
            this.photoPath = photoPath;
        }
    }

}
