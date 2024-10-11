<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>가맹점 점검 계획 관리</title>
  <!-- Bootstrap CSS -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <!-- Font Awesome -->
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
  <link rel="preconnect" href="https://fonts.googleapis.com"/>
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin/>
  <link
          href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@100..900&display=swap"
          rel="stylesheet"
  />
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,400..900;1,400..900&display=swap"
        rel="stylesheet">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.css"/>
  <link rel='stylesheet' href='https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css'
        integrity='sha512-iecdLmaskl7CVkqkXNQ/ZH/XLlvWZOJyj7Yy7tcenmpD1ypASozpmT/E0iPtmFIB46ZmdtAc9eNBvH0H/ZpiBw=='
        crossorigin='anonymous'/>

  <link rel="stylesheet" href="/resources/css/qsc/store_inspection/popup_inspection.css">
  <link rel="stylesheet" href="/resources/css/qsc/inspection_result/result_list.css">


  <!-- Iconscout Link For Icons -->
  <link
          rel="stylesheet"
          href="https://unicons.iconscout.com/release/v4.0.0/css/line.css"
  />
  <!-- AG Grid CSS -->
  <link rel="stylesheet" href="https://unpkg.com/ag-grid-community/styles/ag-grid.css">
  <link rel="stylesheet" href="https://unpkg.com/ag-grid-community/styles/ag-theme-alpine.css">

  <style>
    /*.page-wrapper2 {*/
    /*    display: flex;*/
    /*    flex-direction: column;*/
    /*    min-height: 100vh;*/
    /*    background-color: #f0f2f5; !* 큰 영역의 배경색 *!*/
    /*}*/

    /*.page-content {*/
    /*    overflow-x: hidden;*/
    /*    flex: 1;*/
    /*    position: relative;*/
    /*}*/

  </style>

  <script src='https://cdnjs.cloudflare.com/ajax/libs/gsap/3.11.5/gsap.min.js'></script>
  <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
  <script src="https://cdn.jsdelivr.net/npm/ag-grid-community/dist/ag-grid-community.min.js"></script>

</head>
<body>
<%--<div class="top-bar">--%>
<%--    <span id="breadcrumb"><span class="parent-menu">체크리스트 관리</span></span>--%>
<%--</div>--%>

<jsp:include page="../../sidebar/sidebar.jsp"/>

<div class="page-wrapper2">
  <main class="page-content">
    <div class="content">
      <!--  top 영역시작 -->
      <div
              class="top-box py-2"
      >
        <div class="top-box-content my-4">
          <!-- row 안에 col로 그리드를 할경우 자동 양쪽마진 15px가 붙음으로 -->
          <!-- g-0을 해줘야 마진이 추가로 붙질않음 -->
          <!-- https://getbootstrap.kr/docs/5.3/layout/gutters/#%EA%B1%B0%ED%84%B0-%EC%A0%9C%EA%B1%B0 -->
          <!-- 검색 .g-0 -->
          <div class="d-flex justify-content-between align-items-center">
            <div class="">
              <b id="가맹점">가맹점 점검 계획 관리</b>
            </div>
            <div class="d-flex justify-content-between">
              <div class="top-button-wrapper px-2">
                <div class="top-button top-lookup">조회</div>
              </div>
              <div class="">
                <div class="top-button-wrapper px-2">
                  <div class="top-button top-reset" id="reset-selection-top">초기화</div>
                </div>
              </div>
            </div>
          </div>
          <%-- 자동 완성 영역 --%>
          <div class="container-fluid">
            <div class="row g-3 align-items-center pt-4 top-search-box d-flex">
              <!-- 가맹점 라벨과 검색 필드 -->
              <div class="col-lg-2 col-md-4 col-12">
                <label for="storeSearch" class="form-label">가맹점</label>
                <div class="wrapper" data-autocomplete="store">
                  <div class="search-btn top-search form-control d-flex align-items-center justify-content-between">
                    <span>가맹점 검색</span>
                    <i class="uil uil-angle-down"></i>
                  </div>
                  <div class="hide-list">
                    <div class="search">
                      <input
                              type="text"
                              class="form-control top-search"
                              id="storeSearch"
                              placeholder="가맹점명을 입력해주세요"
                      />
                      <ul class="options"></ul>
                    </div>
                  </div>
                </div>
              </div>

              <!-- 브랜드 라벨과 검색 필드 -->
              <div class="col-lg-2 col-md-4 col-12">
                <label for="inspectorSearch" class="form-label">브랜드</label>
                <div class="wrapper" data-autocomplete="inspector">
                  <div class="search-btn top-search form-control d-flex align-items-center justify-content-between">
                    <span>브랜드 검색</span>
                    <i class="uil uil-angle-down"></i>
                  </div>
                  <div class="hide-list">
                    <div class="search">
                      <input
                              type="text"
                              class="form-control top-search"
                              id="inspectorSearch"
                              placeholder="브랜드명을 입력해주세요"
                      />
                      <ul class="options"></ul>
                    </div>
                  </div>
                </div>
              </div>
              <%!
                String getTodayString() {
                  SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd"); // 날짜 형식 지정
                  return sdf.format(new Date()); // 현재 날짜를 위에서 지정한 형식으로 포맷팅
                }
              %>
              <!-- 점검 예정일 라벨과 필드 -->
              <div class="col-lg-2 col-md-4 col-12">
                <label for="topScheduleDate" class="form-label">점검 예정일</label>
                <div class="wrapper" data-autocomplete="sv">
                  <div class="search">
                    <input
                            type="date"
                            class="form-control top-search"
                            id="topScheduleDate"
                            placeholder="예정일을 입력해주세요"
                            min="<%= getTodayString() %>"
                    />
                  </div>
                </div>
              </div>

              <!-- 체크리스트명 라벨과 검색 필드 -->
              <div class="col-lg-3 col-md-6 col-12">
                <label for="svSearchInput" class="form-label">체크리스트</label>
                <div class="wrapper" data-autocomplete="CHKLST">
                  <div class="search-btn top-search form-control d-flex align-items-center justify-content-between">
                    <span>체크리스트 검색</span>
                    <i class="uil uil-angle-down"></i>
                  </div>
                  <div class="hide-list">
                    <div class="search">
                      <input
                              type="text"
                              class="form-control top-search"
                              id="svSearchInput"
                              placeholder="체크리스트를 입력해주세요"
                      />
                      <ul class="options"></ul>
                    </div>
                  </div>
                </div>
              </div>

              <!-- 점검자 라벨과 검색 필드 -->
              <div class="col-lg-3 col-md-4 col-12">
                <label for="inspector" class="form-label">점검자</label>
                <div class="wrapper" data-autocomplete="inspector">
                  <div class="search-btn top-search form-control d-flex align-items-center justify-content-between">
                    <span>점검자 검색</span>
                    <i class="uil uil-angle-down"></i>
                  </div>
                  <div class="hide-list">
                    <div class="search">
                      <input
                              type="text"
                              class="form-control top-search"
                              id="inspector"
                              placeholder="점검자를 입력해주세요"
                      />
                      <ul class="options"></ul>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>


        </div>
        <%--  top 영역끝  --%>


        <div class="middle-box py-2">
          <div class="middle-content ">
            <div class="d-flex justify-content-end mb-3">
              <div class="px-2">
                <div class="top-button top-reset"  id="addRowButton" >추가</div>
              </div>
              <div class="px-2">
                <div class="top-button top-reset"  id="deleteRowButton">삭제</div>
              </div>
            </div>
            <div id="myGrid" class="ag-theme-alpine" style="height: 500px; width: 100%;"></div>
          </div>
        </div>


        <%--                    <!-- 중간 게시판 목록 끝 -->--%>

      </div>

    </div>


  </main>
</div>
<%-------------  modal -------------%>
<div class="modal fade" id="masterChecklistModal" aria-hidden="true" aria-labelledby="masterChecklistList" tabindex="-1" data-bs-backdrop="static" data-bs-keyboard="false">
  <div class="modal-dialog modal-dialog-centered modal-dialog-scrollable">
    <div class="modal-content">

      <%-------------- header --------------%>
      <div class="modal-header">
            <span class="modal-title fs-5" id="masterChecklistList" style="font: 450 16px 'Noto Sans KR'">
              마스터체크리스트 선택
            </span>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <%-------------- header --------------%>

      <%-------------- body --------------%>
      <div class="modal-body">

      </div>
      <%-------------- body --------------%>

      <%-------------- footer --------------%>
      <div class="modal-footer">
        <button class="btn btn-secondary"  data-bs-dismiss="modal" aria-label="Close">취소</button>
        <button class="" data-bs-dismiss="modal">선택</button>
      </div>
      <%-------------- footer --------------%>
    </div>
  </div>
</div>




<script src="/resources/js/qsc/store_inspection/popup_inspection.js"></script>
<script src="/resources/js/qsc/inspection_result/result.js"></script>
<!-- SweetAlert2 JS -->
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
</body>
</html>