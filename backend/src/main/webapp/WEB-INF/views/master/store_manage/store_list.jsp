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


    <link rel="stylesheet" href="/resources/css/master/store_manage/store_list.css">


    <!-- Iconscout Link For Icons -->
    <link
            rel="stylesheet"
            href="https://unicons.iconscout.com/release/v4.0.0/css/line.css"
    />
    <!-- AG Grid CSS -->
    <link rel="stylesheet" href="https://unpkg.com/ag-grid-community/styles/ag-grid.css">
    <link rel="stylesheet" href="https://unpkg.com/ag-grid-community/styles/ag-theme-alpine.css">

    <style>
        .page-content {
            min-height: 100vh;
        }
    </style>


    <script src='https://cdnjs.cloudflare.com/ajax/libs/gsap/3.11.5/gsap.min.js'></script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/ag-grid-community/dist/ag-grid-community.min.js"></script>
    <script type="text/javascript"
            src="https://openapi.map.naver.com/openapi/v3/maps.js?ncpClientId=${naverClientId}&submodules=panorama,geocoder"
            defer></script>

</head>
<body>
>

<jsp:include page="../../sidebar/sidebar.jsp"/>

<div class="page-wrapper2">
    <main class="page-content">
        <div class="content">
            <!--  top 영역시작 -->
            <div
                    class="top-box py-2"
            >
                <div class="top-box-content my-4">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <b id="가맹점">가맹점 점검 계획 관리</b>
                        </div>
                        <div class="d-flex">
                            <div class="top-button-wrapper px-2">
                                <div class="top-button top-lookup">조회</div>
                            </div>
                            <div class="top-button-wrapper px-2">
                                <div class="top-button top-reset" id="reset-selection-top">초기화</div>
                            </div>
                        </div>
                    </div>
                    <!-- 자동 완성 영역 -->
                    <div class="container-fluid">
                        <div class="row g-3 align-items-center pt-4 top-search-box">
                            <!-- 가맹점 라벨과 검색 필드 -->
                            <div class="col-12 col-md-4">
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
                                                    aria-label="가맹점 검색"
                                            />
                                            <ul class="options"></ul>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- 브랜드 라벨과 검색 필드 -->
                            <div class="col-12 col-md-4">
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
                                                    aria-label="브랜드 검색"
                                            />
                                            <ul class="options"></ul>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- 점검자 라벨과 검색 필드 -->
                            <div class="col-12 col-md-4">
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
                                                    aria-label="점검자 검색"
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

                <%--  중간 게시판 목록 시작 --%>
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


                <%--  <!-- 중간 게시판 목록 끝 -->--%>


            </div>

        </div>


    </main>
</div>
<%-- 모달 시작 --%>
<div class="modal fade" id="DetailStore" aria-hidden="true" aria-labelledby="MoreDetailStore" tabindex="-1"
     data-bs-backdrop="static" data-bs-keyboard="false">
    <div class="modal-dialog modal-dialog-centered modal-dialog-scrollable  modal-lg">
        <div class="modal-content">

            <%-------------- header --------------%>
            <div class="modal-header">
            <span class="modal-title fs-5" id="MoreDetailStore" style="font: 450 16px 'Noto Sans KR'">
              가맹점 상세 보기
            </span>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <%-------------- header --------------%>

            <%-------------- body --------------%>
            <div class="modal-body">
                <form>
                    <div class="container-fluid">
                        <div class="row g-3">

                            <!-- 매장명 -->
                            <div class="col-12 col-lg-6">
                                <label for="storeName" class="form-label">매장명</label>
                                <input type="text" class="form-control" id="storeName" placeholder="매장명 입력">
                            </div>

                            <!-- 사업자등록번호 -->
                            <div class="col-12 col-lg-6">
                                <div class="file_cus">
                                    <label for="brn" class="form-label">사업자등록번호</label>
                                    <label>
                                        <input type="file">
                                        <!-- 파일명과 삭제 버튼을 감싸는 컨테이너 -->
                                        <div class="file_display">
                                            <span class="file_name">파일을 선택해주세요.</span>
                                            <!-- 'X' 버튼 -->
                                            <span class="file_remove" style="display: none;">&times;</span>
                                        </div>
                                        <span class="file_btn">파일선택</span>
                                    </label>
                                </div>
                                <input type="text" class="form-control" id="brn" placeholder="사업자등록번호 입력 (ex: 111-11-1111)">
                            </div>


                            <!-- 브랜드 선택 -->
                            <div class="col-12 col-md-6">
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
                                                    aria-label="브랜드 검색"
                                            />
                                            <ul class="options"></ul>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- 운영시간 선택 -->
                            <div class="col-12 col-md-6">
                                <label for="operationHours" class="form-label">운영시간</label>
                                <input type="time" class="form-control" id="operationHours" placeholder="운영시간 선택">
                            </div>

                            <!-- 가맹점 주소 -->
                            <div class="col-12 col-md-6">
                                <label for="storeAddress" class="form-label">가맹점 주소</label>
                                <div class="input-group">
                                    <input type="text" class="form-control" id="storeAddress" placeholder="가맹점 주소 입력">
                                    <button type="button" class="btn btn-primary" onclick="DaumPostcode()">주소 찾기
                                    </button>
                                </div>
                            </div>

                            <!-- 상세 주소 입력 -->
                            <div class="col-12 col-md-6">
                                <label for="detailedAddress" class="form-label">상세 주소 입력</label>
                                <input type="text" class="form-control" id="detailedAddress" placeholder="상세 주소 입력">
                            </div>

                            <!-- 지도 (웹 화면에서 크기를 키우기 위해 전체 차지) -->
                            <div class="col-12">
                                <div id="map"
                                     style="width: 100%; height: 300px; background-color: #e9ecef; position: relative;overflow: hidden">
                                </div>

                            </div>

                            <!-- 점주명 -->
                            <div class="col-12 col-md-6">
                                <label for="ownerName" class="form-label">점주명</label>
                                <input type="text" class="form-control" id="ownerName" placeholder="점주명 입력">
                            </div>

                            <!-- 점주 휴대폰 번호 -->
                            <div class="col-12 col-md-6">
                                <label for="ownerPhone" class="form-label">점주 휴대폰 번호</label>
                                <input type="text" class="form-control" id="ownerPhone"
                                       placeholder="휴대폰 번호 입력 (ex: 010-1111-1111)">
                            </div>

                            <!-- 점검자 선택 -->
                            <div class="col-12 col-md-6">
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
                                                    aria-label="점검자 검색"
                                            />
                                            <ul class="options"></ul>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- 담당 SV 선택 -->
                            <div class="col-12 col-md-6">
                                <label for="inspector" class="form-label">담당 SV (심사원)</label>
                                <div class="wrapper" data-autocomplete="sv">
                                    <div class="search-btn top-search form-control d-flex align-items-center justify-content-between">
                                        <span>SV 검색</span>
                                        <i class="uil uil-angle-down"></i>
                                    </div>
                                    <div class="hide-list">
                                        <div class="search">
                                            <input
                                                    type="text"
                                                    class="form-control top-search"
                                                    id="inspector"
                                                    placeholder="담당자를 입력해주세요"
                                                    aria-label="담당자 검색"
                                            />
                                            <ul class="options"></ul>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- 운영 상태 -->
                            <div class="col-12">
                                <label class="form-label">운영 상태</label>
                                <div class="form-check form-check-inline">
                                    <input class="form-check-input" type="radio" name="operationStatus" id="operating"
                                           value="operating" checked>
                                    <label class="form-check-label" for="operating">운영중</label>
                                </div>
                                <div class="form-check form-check-inline">
                                    <input class="form-check-input" type="radio" name="operationStatus" id="closed"
                                           value="closed">
                                    <label class="form-check-label" for="closed">폐업</label>
                                </div>
                            </div>

                        </div>
                    </div>
                </form>
            </div>


            <%-------------- body --------------%>

            <%-------------- footer --------------%>
            <div class="modal-footer">
                <button class="btn btn-secondary" data-bs-dismiss="modal" aria-label="Close">취소</button>
                <button class="" data-bs-dismiss="modal">선택</button>
            </div>
            <%-------------- footer --------------%>
        </div>
    </div>
</div>

<script src="/resources/js/master/store_manage/store_list.js"></script>
<script src="/resources/js/master/store_manage/maps.js"></script>
<!-- 주소 검색 다음 -->
<script src="http://dmaps.daum.net/map_js_init/postcode.v2.js"></script>
<!-- SweetAlert2 JS -->
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

<script>


    function DaumPostcode() {
        new daum.Postcode({
            oncomplete: function (data) {
                var fullRoadAddr = data.roadAddress; // 도로명 주소 변수

                // 가맹점 주소 입력 필드에 도로명 주소 값 넣기
                document.getElementById('storeAddress').value = fullRoadAddr;

                console.log("선택한 주소:", fullRoadAddr);

                // 주소를 좌표로 변환하고 지도를 이동
                searchAddressToCoordinate(fullRoadAddr);
            },
        }).open();
    }
</script>

</body>
</html>
