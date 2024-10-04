<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>사이드바 컴포넌트 - 아코디언</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link
            href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@100..900&display=swap"
            rel="stylesheet"
    />
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,400..900;1,400..900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.css" />
    <link rel='stylesheet' href='https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css' integrity='sha512-iecdLmaskl7CVkqkXNQ/ZH/XLlvWZOJyj7Yy7tcenmpD1ypASozpmT/E0iPtmFIB46ZmdtAc9eNBvH0H/ZpiBw==' crossorigin='anonymous'/>

    <link rel="stylesheet" href="/resources/css/store_list/store_list.css">
    <script src='https://cdnjs.cloudflare.com/ajax/libs/gsap/3.11.5/gsap.min.js'></script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body>

<jsp:include page="sidebar/sidebar.jsp" />

<div class="page-wrapper2">
    <main class="page-content">
        <div class="content">
            <!-- 가맹점 관리 top 영역시작 -->
            <div
                    class="top-box d-flex justify-content-center align-items-center py-4"
            >
                <div class="top-box-content">
                    <!-- row 안에 col로 그리드를 할경우 자동 양쪽마진 15px가 붙음으로 -->
                    <!-- g-0을 해줘야 마진이 추가로 붙질않음 -->
                    <!-- https://getbootstrap.kr/docs/5.3/layout/gutters/#%EA%B1%B0%ED%84%B0-%EC%A0%9C%EA%B1%B0 -->
                    <!-- 검색 .g-0 -->
                    <div class="d-flex justify-content-between align-items-center">
                        <div class="">
                            <b id="가맹점">가맹점 관리</b>
                        </div>
                        <div class="d-flex justify-content-between">
                            <div class="top-button-wrapper px-2">
                                <div class="top-button top-lookup">조회</div>
                            </div>
                            <div class="">
                                <div class="top-button-wrapper px-2">
                                    <div class="top-button top-reset">초기화</div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div
                            class="row g-0 align-items-center pt-4 ms-3 text-lg-center top-search-box"
                    >
                        <div class="col-lg-1 col-12">
                            <label for="storeSearch" class="form-label">가맹점</label>
                        </div>
                        <div class="col-lg-4 col-12 mb-3 mb-md-0">
                            <input
                                    type="text"
                                    class="form-control top-search"
                                    id="storeSearch"
                                    placeholder="가맹점 검색"
                            />
                        </div>
                        <div class="col-lg-1 col-12">
                            <label for="inspector" class="form-label">점검자</label>
                        </div>
                        <div class="col-lg-3 col-12 mb-3 mb-md-0">
                            <input
                                    type="text"
                                    class="form-control top-search"
                                    id="inspector"
                                    placeholder="점검자 선택"
                            />
                        </div>
                        <div class="col-lg-1 col-12">
                            <label for="svSearch" class="form-label">SV</label>
                        </div>
                        <div class="col-lg-2 col-12">
                            <input
                                    type="text"
                                    class="form-control top-search"
                                    id="svSearch"
                                    placeholder="SV 검색"
                            />
                        </div>
                    </div>
                </div>
            </div>
            <!-- 가맹점 관리 top 영역끝 -->

            <!-- 중간 게시판 목록 시작 -->
            <div class="middle-box">
                <div class="middle-content">
                    <div class="d-flex justify-content-end py-4">
                        <div class="top-button-wrapper px-2">
                            <div class="top-button middle-register">추가</div>
                        </div>
                        <div class="">
                            <div class="top-button-wrapper px-2">
                                <div class="top-button middle-delete">삭제</div>
                            </div>
                        </div>
                    </div>
                    <div class="table-responsive">
                        <table class="table">
                            <thead>
                            <tr>
                                <th><input type="checkbox" id="checkAll" /></th>
                                <th>No</th>
                                <th>매장명</th>
                                <th>브랜드</th>
                                <th>사용자 등록번호</th>
                                <th>예약시간</th>
                                <th>수정</th>
                            </tr>
                            </thead>
                            <tbody>
                            <tr>
                                <td><input type="checkbox" class="checkItem" /></td>
                                <td>1</td>
                                <td>혜화점</td>
                                <td>KCC 크라상</td>
                                <td>111-11-1234</td>
                                <td>10:30</td>
                                <td><button class="btn btn-primary">수정</button></td>
                            </tr>
                            <tr>
                                <td><input type="checkbox" class="checkItem" /></td>
                                <td>2</td>
                                <td>동대문점</td>
                                <td>KCC 크라상</td>
                                <td>111-11-1234</td>
                                <td>9:30</td>
                                <td><button class="btn btn-primary">수정</button></td>
                            </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
            <!-- 중간 게시판 목록 시작 -->
        </div>
    </main>
</div>
</body>
</html>
