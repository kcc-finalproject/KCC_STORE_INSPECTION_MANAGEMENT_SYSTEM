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
    <link rel="stylesheet" href="/resources/css/qsc/inspection_schedule/schedule_list.css">


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



                <%--  하단 점검 시작  --%>


                <div class="bottom-box-content my-4">
                    <!-- 헤더 섹션 -->
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <b>가맹점 점검 계획 등록</b>
                        </div>
                        <div class="d-flex">
                            <div class="px-2">
                                <div class="top-button middle-register">추가</div>
                            </div>
                            <div class="px-2">
                                <div class="top-button top-reset" id="reset-selection-bottom">초기화</div>
                            </div>
                        </div>
                    </div>

                    <!-- 검색 필드 섹션 -->
                    <div class="container-fluid">
                        <div class="row g-3 align-items-center pt-4">

                            <!-- 점검유형 -->
                            <div class="col-lg-3 col-md-6 col-12">
                                <label for="inspectionType" class="form-label">점검 유형</label>
                                <div class="wrapper" data-autocomplete="INSP">
                                    <div class="search-btn top-search form-control d-flex align-items-center justify-content-between">
                                        <span>정기 점검 검색</span>
                                        <i class="uil uil-angle-down"></i>
                                    </div>
                                    <div class="hide-list">
                                        <div class="search">
                                            <input
                                                    type="text"
                                                    class="form-control top-search"
                                                    id="inspectionType"
                                                    placeholder="점검유형을 입력해주세요"
                                            />
                                            <ul class="options"></ul>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- 체크리스트명 -->
                            <div class="col-lg-3 col-md-6 col-12">
                                <label for="checklistName" class="form-label">체크리스트</label>
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
                                                    id="checklistName"
                                                    placeholder="체크리스트를 입력해주세요"
                                            />
                                            <ul class="options"></ul>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- 가맹점 -->
                            <div class="col-lg-3 col-md-6 col-12">
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

                            <!-- 브랜드 -->
                            <div class="col-lg-3 col-md-6 col-12">
                                <label for="brandSearch" class="form-label">브랜드</label>
                                <div class="wrapper" data-autocomplete="BRAND">
                                    <div class="search-btn top-search form-control d-flex align-items-center justify-content-between">
                                        <span>브랜드 검색</span>
                                        <i class="uil uil-angle-down"></i>
                                    </div>
                                    <div class="hide-list">
                                        <div class="search">
                                            <input
                                                    type="text"
                                                    class="form-control top-search"
                                                    id="brandSearch"
                                                    placeholder="브랜드명을 입력해주세요"
                                            />
                                            <ul class="options"></ul>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- 점검자 -->
                            <div class="col-lg-3 col-md-6 col-12">
                                <label for="inspectorSearch" class="form-label">점검자</label>
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
                                                    id="inspectorSearch"
                                                    placeholder="점검자명을 입력해주세요"
                                            />
                                            <ul class="options"></ul>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- 빈도 -->
                            <div class="col-lg-3 col-md-6 col-12">
                                <label for="frequency" class="form-label">빈도</label>
                                <select id="frequency" name="frequency" class="form-select">
                                    <option value="none" selected>빈도없음</option>
                                    <option value="daily">일별</option>
                                    <option value="weekly">주별</option>
                                    <option value="monthly">월별</option>
                                </select>
                            </div>

                            <!-- 횟수 -->
                            <div class="col-lg-3 col-md-6 col-12">
                                <label for="count" class="form-label">횟수</label>
                                <select id="count" name="count" class="form-select">
                                    <option value="none" selected>없음</option>
                                    <!-- 빈도에 따라 동적으로 옵션이 추가될 예정 -->
                                </select>

                            </div>

                            <!-- 점검 예정일 -->
                            <div class="col-lg-3 col-md-6 col-12" id="input-schedule">
                                <label for="bottomScheduleDate" class="form-label">점검 예정일</label>
                                <input
                                        type="date"
                                        class="form-control"
                                        id="bottomScheduleDate"
                                />
                            </div>
                            <!-- 커스텀 달력 -->
                            <div class="col-12" id="custom-calendar-container" style="display: none;">
                                <label class="form-label">점검 날짜 선택</label>
                                <div class="card">
                                    <div class="card-body">
                                        <div class="row mb-3">
                                            <div class="col-md-6 col-sm-12 mb-2">
                                                <label for="year-select-calendar" class="form-label">연도 선택</label>
                                                <select id="year-select-calendar" class="form-select">
                                                    <!-- 연도 선택 옵션은 JS에서 동적으로 생성됩니다 -->
                                                </select>
                                            </div>
                                            <div class="col-md-6 col-sm-12 mb-2">
                                                <label for="month-select-calendar" class="form-label">월 선택</label>
                                                <select id="month-select-calendar" class="form-select">
                                                    <option value="0">1월</option>
                                                    <option value="1">2월</option>
                                                    <option value="2">3월</option>
                                                    <option value="3">4월</option>
                                                    <option value="4">5월</option>
                                                    <option value="5">6월</option>
                                                    <option value="6">7월</option>
                                                    <option value="7">8월</option>
                                                    <option value="8">9월</option>
                                                    <option value="9">10월</option>
                                                    <option value="10">11월</option>
                                                    <option value="11">12월</option>
                                                </select>
                                            </div>
                                        </div>

                                        <div class="table-responsive">
                                            <table class="table table-bordered">
                                                <thead class="table-light">
                                                <tr>
                                                    <th>월</th>
                                                    <th>화</th>
                                                    <th>수</th>
                                                    <th>목</th>
                                                    <th>금</th>
                                                    <th>토</th>
                                                    <th>일</th>
                                                </tr>
                                                </thead>
                                                <tbody class="calendar-body">
                                                <!-- 달력 날짜가 여기에 생성됩니다 -->
                                                </tbody>
                                            </table>
                                        </div>
                                        <!-- 선택된 날짜 카드 컨테이너 -->
                                        <div id="selected-dates-container"></div>
                                    </div>
                                </div>
                            </div>

                            <!-- 빈도별 동적 버튼 영역 (weekly, monthly) -->
                            <div id="dynamic-buttons" class="mt-3"></div>
                        </div>
                    </div>
                </div>

            </div>
            <%--  하단 점검 끝  --%>
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
                <div class="input-group mb-3 modal-search-box" style="    padding: .5rem 1rem;">
                    <input type="text" class="form-control me-2" placeholder="체크리스트 검색" aria-label="Recipient's username" aria-describedby="button-addon2">
                    <button class="btn btn-outline-secondary" type="button" id="button-addon2">검색</button>
                </div>
                <ol class="list-group  scrollable-list ">
                    <li class="list-group-item d-flex justify-content-between align-items-center mb-1">
                        <div class="item-info d-flex align-items-center">
                            <span class="me-3">01</span>
                            <p class="mb-0">KCC 카페 제품 점검 체크리스트</p>
                        </div>
                        <button class="btn btn-primary btn-sm" type="button" data-bs-target="#exampleModalToggle2" data-bs-toggle="modal">
                            미리보기
                            <i class="fa-regular fa-eye"></i>
                        </button>
                    </li>
                    <li class="list-group-item d-flex justify-content-between align-items-center mb-1">
                        <div class="item-info d-flex align-items-center">
                            <span class="me-3">01</span>
                            <p class="mb-0">KCC 카페 제품 점검 체크리스트</p>
                        </div>
                        <button class="btn btn-primary btn-sm" type="button" data-bs-target="#exampleModalToggle2" data-bs-toggle="modal">
                            미리보기
                            <i class="fa-regular fa-eye"></i>
                        </button>
                    </li>
                    <li class="list-group-item d-flex justify-content-between align-items-center mb-1">
                        <div class="item-info d-flex align-items-center">
                            <span class="me-3">01</span>
                            <p class="mb-0">KCC 카페 제품 점검 체크리스트</p>
                        </div>
                        <button class="btn btn-primary btn-sm" type="button" data-bs-target="#exampleModalToggle2" data-bs-toggle="modal">
                            미리보기
                            <i class="fa-regular fa-eye"></i>
                        </button>
                    </li>
                    <li class="list-group-item d-flex justify-content-between align-items-center mb-1">
                        <div class="item-info d-flex align-items-center">
                            <span class="me-3">01</span>
                            <p class="mb-0">KCC 카페 제품 점검 체크리스트</p>
                        </div>
                        <button class="btn btn-primary btn-sm" type="button" data-bs-target="#exampleModalToggle2" data-bs-toggle="modal">
                            미리보기
                            <i class="fa-regular fa-eye"></i>
                        </button>
                    </li>
                    <li class="list-group-item d-flex justify-content-between align-items-center mb-1">
                        <div class="item-info d-flex align-items-center">
                            <span class="me-3">01</span>
                            <p class="mb-0">KCC 카페 제품 점검 체크리스트</p>
                        </div>
                        <button class="btn btn-primary btn-sm" type="button" data-bs-target="#exampleModalToggle2" data-bs-toggle="modal">
                            미리보기
                            <i class="fa-regular fa-eye"></i>
                        </button>
                    </li>
                    <li class="list-group-item d-flex justify-content-between align-items-center mb-1">
                        <div class="item-info d-flex align-items-center">
                            <span class="me-3">01</span>
                            <p class="mb-0">KCC 카페 제품 점검 체크리스트</p>
                        </div>
                        <button class="btn btn-primary btn-sm" type="button" data-bs-target="#exampleModalToggle2" data-bs-toggle="modal">
                            미리보기
                            <i class="fa-regular fa-eye"></i>
                        </button>
                    </li>
                    <li class="list-group-item d-flex justify-content-between align-items-center mb-1">
                        <div class="item-info d-flex align-items-center">
                            <span class="me-3">01</span>
                            <p class="mb-0">KCC 카페 제품 점검 체크리스트</p>
                        </div>
                        <button class="btn btn-primary btn-sm" type="button" data-bs-target="#exampleModalToggle2" data-bs-toggle="modal" style="border-radius: 8px;">
                            미리보기
                            <i class="fa-regular fa-eye"></i>
                        </button>
                    </li>



                </ol>
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


<%--    second modal     --%>
<div class="modal fade" id="exampleModalToggle2" aria-hidden="true" aria-labelledby="details" tabindex="-1" data-bs-backdrop="static" data-bs-keyboard="false">
    <div class="modal-dialog modal-dialog-centered modal-dialog-scrollable modal-lg" style="max-width : 1015px!important;">
        <div class="modal-content" style="overflow-y: scroll;">
            <section class="inspection-section">
                <div class="inspection-tabs">
                    <button class="inspection-tab active" data-tab="중대법규">중대법규</button>
                    <button class="inspection-tab" data-tab="기타법규">기타법규</button>
                    <button class="inspection-tab" data-tab="위생관리">위생관리</button>
                    <button class="inspection-tab" data-tab="위생지도상황">위생지도상황</button>
                    <button class="inspection-tab" data-bs-target="#masterChecklistModal" data-bs-toggle="modal" style="background-color: #afa4dd; color: white">뒤로가기</button>
                </div>

                <section class="inspection-list" id="중대법규">
                    <div class="inspection-box">
                        <div class="inspection-header">
                            영업취소
                            <span class="toggle-icon">▼</span>
                        </div>
                        <div class="inspection-content">
                            <div class="inspection-content-detail">
                                <p>1. 소비기한 변조 및 삭제</p>
                                <button class="add-btn">+</button>
                            </div>

                            <%--        ----해당부분은 동적으로 변동이 될부분----        --%>
                            <div class="inspection-content-wrapper">
                                <!-- 사진 업로드 구역 -->
                                <div class="answer-section">
                                    <button class="answer-btn">예</button>
                                    <button class="answer-btn">아니오</button>
                                </div>

                                <div class="photo-section">
                                    <div class="photo-buttons">
                                        <button class="photo-btn camera-btn">
                                            <i class="fa-solid fa-camera"></i>사진촬영
                                        </button>
                                        <button class="photo-btn gallery-btn">
                                            <i class="fa-regular fa-image"></i>갤러리
                                        </button>
                                    </div>
                                    <div class="photo-boxes">
                                        <div class="photo-box">사진 미등록</div>
                                        <div class="photo-box">최대 2개</div>
                                    </div>
                                </div>

                                <!-- 매장 정보 라디오 버튼 리스트 -->
                                <div class="store-info">
                                    <div class="tab-section">
                                        <button class="tab-btn active">위치정보</button>
                                        <button class="tab-btn">상세입력</button>
                                    </div>

                                    <!-- 위치정보 -->
                                    <div class="content location-content">
                                        <div class = "content location-content-list">
                                            <label class="radio-label">
                                                매장
                                                <input type="radio" name="location">
                                            </label>
                                            <label class="radio-label">
                                                카페
                                                <input type="radio" name="location">
                                            </label>
                                            <label class="radio-label">
                                                주방
                                                <input type="radio" name="location">
                                            </label>
                                            <label class="radio-label">
                                                기타
                                                <input type="radio" name="location">
                                            </label>

                                        </div>

                                        <!-- 기타사항 입력 -->
                                        <div class="other-info">
                                            <label>기타사항</label>
                                            <textarea class="etc-input" name="responsibility" placeholder="기타사항을 입력해주세요"></textarea>
                                        </div>
                                    </div>

                                    <!-- 상세입력 정보 (숨김 상태) -->
                                    <div class="content detail-content">
                                        <div class="input-group-cover">
                                            <div class="input-group">
                                                <label>제품명 (또는 상세위치)</label>
                                                <input type="text" class="product-name" placeholder="제품명 입력">
                                            </div>
                                            <div class="input-group">
                                                <label>위반수량</label>
                                                <input type="text" class="violation-quantity" placeholder="위반수량 입력">
                                            </div>
                                        </div>

                                        <div class="input-group">
                                            <label>원인</label>
                                            <textarea class="reason" placeholder="원인을 작성해주세요"></textarea>
                                        </div>
                                        <div class="input-group">
                                            <label>개선조치사항</label>
                                            <textarea class="action" placeholder="개선조치사항을 입력해주세요"></textarea>
                                        </div>
                                        <div class="input-group">
                                            <label>위반사항</label>
                                            <textarea class="violation" placeholder="위반사항을 입력해주세요"></textarea>
                                        </div>
                                        <div class="input-group">
                                            <label>귀책사유</label>
                                            <div class="radio-group">
                                                <label>
                                                    SV <input type="radio" name="responsibility" value="SV">
                                                </label>
                                                <label>
                                                    점주 <input type="radio" name="responsibility" value="Owner">
                                                </label>
                                                <label>
                                                    직원 <input type="radio" name="responsibility" value="Employee">
                                                </label>
                                                <label>
                                                    기타 <input type="radio" name="responsibility" value="Other">
                                                </label>
                                            </div>
                                            <textarea class="caupvd" placeholder="귀책사유를 입력해주세요"></textarea>
                                        </div>
                                    </div>
                                </div>


                            </div>

                            <%--        ----해당부분은 동적으로 변동이 될부분----        --%>
                        </div>
                    </div>

                    <div class="inspection-box">
                        <div class="inspection-header">
                            영업정지 1개월 이상
                            <span class="toggle-icon">▼</span>
                        </div>
                        <div class="inspection-content">
                            <div class="inspection-content-detail">
                                <p>2. 표시사항 전부를 표시하지 않은 식품을 영업에 사용</p>
                                <button class="add-btn">+</button>
                            </div>

                            <%--        ----해당부분은 동적으로 변동이 될부분----        --%>
                            <div class="inspection-content-wrapper">
                                <!-- 사진 업로드 구역 -->
                                <div class="answer-section2">
                                    <label class="radio-label2">
                                        <input type="radio" name="rating" value="매우좋음" checked>
                                        매우좋음
                                    </label>
                                    <label class="radio-label2">
                                        <input type="radio" name="rating" value="좋음">
                                        좋음
                                    </label>
                                    <label class="radio-label2">
                                        <input type="radio" name="rating" value="보통">
                                        보통
                                    </label>
                                    <label class="radio-label2">
                                        <input type="radio" name="rating" value="나쁨">
                                        나쁨
                                    </label>
                                    <label class="radio-label2">
                                        <input type="radio" name="rating" value="매우나쁨">
                                        매우나쁨
                                    </label>
                                </div>


                                <div class="photo-section">
                                    <div class="photo-buttons">
                                        <button class="photo-btn camera-btn">
                                            <i class="fa-solid fa-camera"></i>사진촬영
                                        </button>
                                        <button class="photo-btn gallery-btn">
                                            <i class="fa-regular fa-image"></i>갤러리
                                        </button>
                                    </div>
                                    <div class="photo-boxes">
                                        <div class="photo-box">사진 미등록</div>
                                        <div class="photo-box">최대 2개</div>
                                    </div>
                                </div>

                                <!-- 매장 정보 라디오 버튼 리스트 -->
                                <div class="store-info">
                                    <div class="tab-section">
                                        <button class="tab-btn active">위치정보</button>
                                        <button class="tab-btn">상세입력</button>
                                    </div>

                                    <!-- 위치정보 -->
                                    <div class="content location-content">
                                        <div class = "content location-content-list">
                                            <label class="radio-label">
                                                매장
                                                <input type="radio" name="location">
                                            </label>
                                            <label class="radio-label">
                                                카페
                                                <input type="radio" name="location">
                                            </label>
                                            <label class="radio-label">
                                                주방
                                                <input type="radio" name="location">
                                            </label>
                                            <label class="radio-label">
                                                기타
                                                <input type="radio" name="location">
                                            </label>

                                        </div>

                                        <!-- 기타사항 입력 -->
                                        <div class="other-info">
                                            <label>기타사항</label>
                                            <textarea class="etc-input" placeholder="기타사항을 입력해주세요"></textarea>
                                        </div>
                                    </div>

                                    <!-- 상세입력 정보 (숨김 상태) -->
                                    <div class="content detail-content">
                                        <div class="input-group-cover">
                                            <div class="input-group">
                                                <label>제품명 (또는 상세위치)</label>
                                                <input type="text" class="product-name" placeholder="제품명 입력">
                                            </div>
                                            <div class="input-group">
                                                <label>위반수량</label>
                                                <input type="text" class="violation-quantity" placeholder="위반수량 입력">
                                            </div>
                                        </div>

                                        <div class="input-group">
                                            <label>원인</label>
                                            <textarea class="reason" placeholder="원인을 작성해주세요"></textarea>
                                        </div>
                                        <div class="input-group">
                                            <label>개선조치사항</label>
                                            <textarea class="action" placeholder="개선조치사항을 입력해주세요"></textarea>
                                        </div>
                                        <div class="input-group">
                                            <label>위반사항</label>
                                            <textarea class="violation" placeholder="위반사항을 입력해주세요"></textarea>
                                        </div>
                                        <div class="input-group">
                                            <label>귀책사유</label>
                                            <div class="radio-group">
                                                <label>
                                                    SV <input type="radio" name="responsibility" value="SV">
                                                </label>
                                                <label>
                                                    점주 <input type="radio" name="responsibility" value="Owner">
                                                </label>
                                                <label>
                                                    직원 <input type="radio" name="responsibility" value="Employee">
                                                </label>
                                                <label>
                                                    기타 <input type="radio" name="responsibility" value="Other">
                                                </label>
                                            </div>
                                            <textarea class="caupvd" placeholder="귀책사유를 입력해주세요"></textarea>
                                        </div>
                                    </div>
                                </div>


                            </div>

                            <%--        ----해당부분은 동적으로 변동이 될부분----        --%>

                        </div>
                    </div>

                    <div class="inspection-box">
                        <div class="inspection-header">
                            영업정지 15일 이상
                            <span class="toggle-icon">▼</span>
                        </div>
                        <div class="inspection-content">
                            <div class="inspection-content-detail">
                                <p>3. 소비기한 경과</p>
                                <button class="add-btn">+</button>
                            </div>
                        </div>
                    </div>

                    <div class="inspection-box">
                        <div class="inspection-header">
                            시정 명령
                            <span class="toggle-icon">▼</span>
                        </div>
                        <div class="inspection-content">
                            <div class="inspection-content-detail">
                                <p>4. 영업신고 관련 위반</p>
                                <button class="add-btn">+</button>
                            </div>
                        </div>
                    </div>

                    <div class="inspection-box">
                        <div class="inspection-header">
                            과태료
                            <span class="toggle-icon">▼</span>
                        </div>
                        <div class="inspection-content">
                            <div class="inspection-content-detail">
                                <p>5. 무신고 소분판매</p>
                                <button class="add-btn">+</button>
                            </div>
                            <div class="inspection-content-detail">
                                <p>6. 건강검진 위반</p>
                                <button class="add-btn">+</button>
                            </div>
                        </div>
                    </div>
                </section>

                <section class="inspection-list" id="기타법규">
                    <!-- 기타법규 관련 내용 -->
                    <div class="inspection-box">
                        <div class="inspection-header">기타법규 관련 내용 1</div>
                    </div>
                </section>

                <section class="inspection-list" id="위생관리">
                    <!-- 위생관리 관련 내용 -->
                    <div class="inspection-box">
                        <div class="inspection-header">위생관리 관련 내용 1</div>
                    </div>
                </section>

                <section class="inspection-list" id="위생지도상황">
                    <!-- 위생지도상황 관련 내용 -->
                    <div class="inspection-box">
                        <div class="inspection-header">위생지도상황 관련 내용 1</div>
                    </div>
                </section>


            </section>
            <div class="modal-footer">

            </div>
        </div>
    </div>
</div >


<script src="/resources/js/qsc/store_inspection/popup_inspection.js"></script>
<script src="/resources/js/qsc/inspection_schedule/schedule_list.js"></script>
<!-- SweetAlert2 JS -->
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
</body>
</html>
