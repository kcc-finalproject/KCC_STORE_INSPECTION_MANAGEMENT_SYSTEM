$(function () {
  /**
   * Autocomplete 클래스 정의
   */
  class Autocomplete {
    /**
     * 생성자
     * @param {jQuery} $wrapper - 자동완성을 적용할 wrapper 요소
     * @param {Array} dataList - 자동완성에 사용할 데이터 목록
     */
    constructor($wrapper, dataList) {
      this.$wrapper = $wrapper;
      this.$searchBtn = $wrapper.find(".search-btn");
      this.$input = $wrapper.find("input");
      this.$options = $wrapper.find(".options");
      this.dataList = dataList;

      this.init();
    }

    /**
     * 초기화 메서드
     * 이벤트 리스너를 설정하고 초기 리스트를 렌더링
     */
    init() {
      this.renderOptions();
      this.bindEvents();
    }

    /**
     * 옵션 리스트를 렌더링.
     * @param {string} [selectedItem] - 선택된 아이템을 표시
     */
    renderOptions(selectedItem = null) {
      this.$options.empty();
      this.dataList.forEach((item) => {
        const isSelected = item === selectedItem ? "selected" : "";
        const li = `<li onclick="window.updateName(this)" class="${isSelected} autocomplete-item list-group-item list-group-item-action">${item}</li>`;
        this.$options.append(li);
      });
    }

    /**
     * 필터링된 옵션 리스트를 렌더링
     * @param {string} query - 검색어
     */
    filterOptions(query) {
      const filtered = this.dataList.filter((item) =>
        item.toLowerCase().includes(query.toLowerCase()),
      );

      this.$options.empty();
      if (filtered.length > 0) {
        filtered.forEach((item) => {
          const isSelected =
            item === this.$searchBtn.children().first().text()
              ? "selected"
              : "";
          const li = `<li onclick="window.updateName(this)" class="${isSelected} autocomplete-item list-group-item list-group-item-action">${item}</li>`;
          this.$options.append(li);
        });
      } else {
        this.$options.html(
          `<li class="list-group-item">찾으시는 항목이 없습니다.</li>`,
        );
      }
    }

    /**
     * 이벤트 리스너를 바인딩
     */
    bindEvents() {
      // 검색 버튼 클릭 시 옵션 리스트 토글
      this.$searchBtn.on("click", (e) => {
        e.stopPropagation(); // 이벤트 버블링 방지
        $(".wrapper").not(this.$wrapper).removeClass("active"); // 다른 wrapper의 active 클래스 제거
        this.$wrapper.toggleClass("active");
        this.$input.focus();
      });

      // 입력 필드 키업 이벤트 처리
      this.$input.on("keyup", (e) => {
        e.stopPropagation(); // 이벤트 버블링 방지
        const query = this.$input.val();
        if (query) {
          this.filterOptions(query);
        } else {
          this.renderOptions();
        }
      });

      // 외부 클릭 시 옵션 리스트 숨기기
      $(document).on("click", (e) => {
        if (
          !this.$wrapper.is(e.target) &&
          this.$wrapper.has(e.target).length === 0
        ) {
          this.$wrapper.removeClass("active");
        }
      });
    }

    /**
     * 선택된 아이템을 업데이트
     * @param {string} selectedItem - 선택된 아이템 텍스트
     */
    updateSelected(selectedItem) {
      this.$input.val("");
      this.renderOptions(selectedItem);
      this.$wrapper.removeClass("active");
      this.$searchBtn.children().first().text(selectedItem);
    }
  }

  /**
   * 전역 함수로 선택된 아이템을 업데이트
   * @param {HTMLElement} selectedLi - 선택된 li 요소
   */
  window.updateName = function (selectedLi) {
    const selectedText = $(selectedLi).text();
    // 해당 li가 속한 wrapper를 찾습니다.
    const $wrapper = $(selectedLi).closest(".wrapper");
    const instance = $wrapper.data("autocompleteInstance");
    if (instance) {
      instance.updateSelected(selectedText);
    }
  };

  // 각 자동완성 필드에 대한 데이터 목록 정의
  const autocompleteData = {
    store: () =>
      $.ajax({
        url: "/qsc/inspection-schedule/stores",
        method: "GET",
      }).then((data) => {
        // "전체" 옵션 추가
        return ["전체", ...data];
      }),
    inspector: () =>
      $.ajax({
        url: "/qsc/inspection-schedule/inspectors",
        method: "GET",
      }).then((data) => {
        return ["전체", ...data];
      }),
    INSP: () => Promise.resolve(["전체", "정기 점검", "제품 점검"]),
    CHKLST: () =>
      $.ajax({
        url: "/qsc/inspection-schedule/checklists",
        method: "GET",
      }).then((data) => {
        return ["전체", ...data];
      }),
    BRAND: () =>
      $.ajax({
        url: "/qsc/inspection-schedule/brands",
        method: "GET",
      }).then((data) => {
        return ["전체", ...data];
      }),
  };

  // Autocomplete 인스턴스를 초기화할 때 데이터 로드 후 생성
  $(".wrapper").each(function () {
    const $wrapper = $(this);
    const type = $wrapper.data("autocomplete");
    if (type && autocompleteData[type]) {
      // dataList 가져오기 (함수 호출)
      autocompleteData[type]()
        .then((response) => {
          let dataList;
          if (type === "INSP") {
            dataList = response;
          } else {
            // AJAX 응답 구조에 따라 적절히 수정
            // 예를 들어, 응답이 { data: [...] } 형태라면:
            dataList = response.data || response; // 실제 응답 구조에 맞게 수정 필요
          }
          // Autocomplete 인스턴스 생성
          const autocomplete = new Autocomplete($wrapper, dataList);
          $wrapper.data("autocompleteInstance", autocomplete);
        })
        .catch((error) => {
          console.error(
            `Error fetching autocomplete data for type ${type}:`,
            error,
          );
        });
    }
  });

  /**
   * 빈도 관련 데이터 및 함수
   */
  const frequencyOptions = {
    daily: generateOptions("매일마다", 31, "일마다"),
    weekly: generateOptions("매주마다", 5, "주마다"),
    monthly: generateOptions("매달마다", 12, "개월마다"),
    none: ["없음"],
  };

  /**
   * 옵션 생성 함수
   * @param {string} prefix - 빈도별 횟수의 맨처음 들어갈 말 e.g) '일마다', '주마다', '개월마다'
   * @param {number} max - 생성할 조건의 최대 숫자
   * @param {string} suffix - 횟수의 숫자 뒤에 붙을 말들 e.g) 빈도가 월이면 '개월마다'
   * @returns {Array} - 생성된 옵션 배열
   */
  function generateOptions(prefix, max, suffix) {
    const options = [];
    for (let i = 1; i <= max; i++) {
      if (i === 1) {
        options.push(`${prefix}`);
      } else {
        options.push(`${i}${suffix}`);
      }
    }
    return options;
  }

  /**
   * 횟수 옵션을 업데이트하는 함수
   * @param {string} frequency - 선택된 빈도 유형
   */
  function updateCountOptions(frequency) {
    const countSelect = $("#count");
    countSelect.empty(); // 기존 옵션 제거
    $("#bottomScheduleDate").val("none");
    if (frequencyOptions[frequency]) {
      frequencyOptions[frequency].forEach((option) => {
        countSelect.append(`<option value="${option}">${option}</option>`);
      });
    } else {
      countSelect.append(`<option value="없음">없음</option>`);
    }

    // '없음'일 경우 횟수 선택 박스 비활성화
    if (frequency === "none") {
      countSelect.prop("disabled", true);
    } else {
      countSelect.prop("disabled", false);
    }

    // 빈도에 따른 추가적인 UI 생성
    generateFrequencySpecificUI(frequency);
  }

  /**
   * 빈도에 따라 추가적인 UI 요소를 생성하는 함수
   * @param {string} frequency - 선택된 빈도 값입니다.
   */
  function generateFrequencySpecificUI(frequency) {
    // 동적으로 생성될 요소를 넣을 영역의 ID
    const dynamicButtonsContainer = $("#dynamic-buttons");

    // 기존 요소 제거
    dynamicButtonsContainer.empty();

    if (frequency === "monthly") {
      // 매달마다의 추가적인 UI (1~31, 매월 마지막 일)
      const buttonsHTML = `
            <div class="container g-0">
              <div class="row g-2">
                <!-- 버튼들 생성 -->
                ${generateMonthButtons(31)}
                <div class="col-12 mt-2">
                  <button class="btn btn-outline-secondary w-100" type="button" value="32" aria-pressed="false">
                    매월 마지막 일
                  </button>
                </div>
              </div>
            </div>
          `;
      dynamicButtonsContainer.append(buttonsHTML);
    } else if (frequency === "weekly") {
      // 매주마다의 추가적인 UI (요일 버튼들)
      const buttonsHTML = `
            <div class="container g-0">
              <div class="row g-2">
                ${generateWeekdayButtons()}
              </div>
            </div>
          `;
      dynamicButtonsContainer.append(buttonsHTML);
    }
    // 'daily'나 'none'에 대해서는 추가적인 UI를 원하지 않을 경우 생략
  }

  /**
   * 월별 선택 시 버튼들을 생성하는 함수
   * @param {number} count - 생성할 버튼의 개수.
   * @returns {string} - 생성된 버튼 HTML 문자열
   */
  function generateMonthButtons(count) {
    let buttonsHTML = "";
    for (let i = 1; i <= count; i++) {
      if (i <= 31) {
        // 일수에 맞게 버튼 생성
        buttonsHTML += `
              <div class="col-2 col-sm-3 col-md-2 col-lg-1 mb-2">
                <button class="btn btn-outline-primary w-100 d-flex justify-content-center" type="button" value="${i}" aria-pressed="false">
                  ${i}
                </button>
              </div>
            `;
      }
    }

    return buttonsHTML;
  }

  /**
   * 주별 선택 시 요일 버튼들을 생성하는 함수
   * @returns {string} - 생성된 요일 버튼 HTML 문자열
   */
  function generateWeekdayButtons() {
    const weekdays = ["월", "화", "수", "목", "금", "토", "일"];
    let buttonsHTML = "";
    weekdays.forEach((day, index) => {
      buttonsHTML += `
            <div class="col-6 col-sm-4 col-md-3 col-lg-1 mb-2">
              <button class="btn btn-outline-secondary w-100" type="button" value="${index + 1}" aria-pressed="false">
                ${day}
              </button>
            </div>
          `;
    });
    return buttonsHTML;
  }

  // 선택된 날짜를 저장할 배열 (월별)
  let selectedDays = [];

  // 선택된 요일을 저장할 배열 (주별)
  let selectedWeekdays = [];

  // 커스텀 달력 관련 변수
  let selectedCalendarDates = [];

  // 버튼 클릭 시 active 클래스 및 aria-pressed 속성 토글 부트스트랩 색깔 변경
  $(document).on("click", "#dynamic-buttons button", function () {
    // 현재 빈도에 따라 동작
    const frequency = $("#frequency").val();

    if (frequency === "monthly") {
      const day = $(this).val();
      const isPressed = $(this).attr("aria-pressed") === "true";

      if (isPressed) {
        // 이미 선택된 경우 배열에서 제거
        selectedDays = selectedDays.filter(
          (selectedDay) => selectedDay !== day,
        );
      } else {
        // 선택되지 않은 경우 배열에 추가
        selectedDays.push(day);
      }

      // 버튼의 aria-pressed 상태 및 active 클래스 토글
      $(this).attr("aria-pressed", !isPressed);
      $(this).toggleClass("active");
    } else if (frequency === "weekly") {
      // 매주
      const weekday = $(this).val();
      const isPressed = $(this).attr("aria-pressed") === "true";

      if (isPressed) {
        // 이미 선택된 경우 배열에서 제거
        selectedWeekdays = selectedWeekdays.filter(
          (selectedDay) => selectedDay !== weekday,
        );
      } else {
        // 선택되지 않은 경우 배열에 추가
        selectedWeekdays.push(weekday);
      }

      // 버튼의 aria-pressed 상태 및 active 클래스 토글
      $(this).attr("aria-pressed", !isPressed);
      $(this).toggleClass("active");
    }
  });

  /**
   * 달력 함수 정의
   */
  function calender() {
    const $calendarBody = $(".calendar-body"); // 클래스 선택자로 변경
    const $monthSelectCalendar = $("#month-select-calendar");
    const $yearSelectCalendar = $("#year-select-calendar");
    const $customCalendarContainer = $("#custom-calendar-container");
    const $scheduleDateContainer = $("#schedule-date-container");
    const $selectedDatesContainer = $("#selected-dates-container");

    // 오늘 날짜 정보 가져오기
    const today = new Date();
    const todayYear = today.getFullYear();
    const todayMonth = today.getMonth(); // 0-based index
    const todayDate = today.getDate();

    // 현재 연도 설정
    const currentYear = todayYear;

    // 연도 선택 옵션 생성 (현재 연도부터 현재 연도 +5까지)
    const startYear = currentYear;
    const endYear = currentYear + 5;
    for (let year = startYear; year <= endYear; year++) {
      $yearSelectCalendar.append(new Option(year, year));
    }
    $yearSelectCalendar.val(currentYear); // 현재 연도를 기본값으로 설정

    // 월 선택을 현재 월로 설정
    $monthSelectCalendar.val(todayMonth);

    /**
     * 선택된 날짜를 카드로 추가하는 함수
     * @param {string} date - 'YYYY-MM-DD' 형식의 날짜
     */
    function addDateCard(date) {
      // 중복된 날짜는 추가하지 않음
      if (selectedCalendarDates.includes(date)) return;

      // 날짜 추가
      selectedCalendarDates.push(date);

      // 날짜 정렬
      selectedCalendarDates.sort();

      // 기존 카드들을 모두 지움
      $selectedDatesContainer.empty();

      // 정렬된 날짜들로 카드 재생성
      selectedCalendarDates.forEach(function (sortedDate) {
        const cardHTML = `
          <div class="date-card">
            <span>${sortedDate}</span>
            <span class="remove-date">&times;</span>
          </div>
        `;
        $selectedDatesContainer.append(cardHTML);
      });
    }

    /**
     * 날짜 카드를 제거하는 함수
     * @param {string} date - 'YYYY-MM-DD' 형식의 날짜
     */
    function removeDateCard(date) {
      selectedCalendarDates = selectedCalendarDates.filter((d) => d !== date);
      $selectedDatesContainer.find(`.date-card:contains('${date}')`).remove();
    }

    /**
     * 선택된 날짜 카드를 초기화하는 함수
     */
    function resetDateCards() {
      selectedCalendarDates = [];
      $selectedDatesContainer.empty();
      $calendarBody.find("td.selected").removeClass("selected");
    }

    /**
     * 선택된 날짜를 표시하는 카드에 이벤트 리스너 추가
     */
    $selectedDatesContainer.on("click", ".remove-date", function () {
      const dateText = $(this).siblings().first().text();
      removeDateCard(dateText);

      // 달력에서 해당 날짜의 선택 상태 해제
      $calendarBody.find(`td[data-date="${dateText}"]`).removeClass("selected");
    });

    /**
     * 달력 생성 함수
     */
    function generateCalendar(month, year) {
      // 달력 초기화
      $calendarBody.empty();

      // 첫 번째 날과 마지막 날짜 계산
      const firstDay = new Date(year, month, 1).getDay(); // 일요일=0
      const lastDate = new Date(year, month + 1, 0).getDate();

      let day = 1;
      let $row = $("<tr></tr>");

      // 월요일 시작으로 설정 (일요일을 0으로 간주)
      const startDayIndex = firstDay === 0 ? 6 : firstDay - 1;

      // 첫 번째 주의 빈 칸 채우기
      for (let i = 0; i < startDayIndex; i++) {
        $row.append($("<td></td>"));
      }

      // 첫 주 날짜 채우기
      for (let i = startDayIndex; i < 7 && day <= lastDate; i++, day++) {
        const $cell = createCalendarCell(day, month, year);
        $row.append($cell);
      }

      $calendarBody.append($row);

      // 나머지 주 날짜 채우기
      while (day <= lastDate) {
        $row = $("<tr></tr>");
        for (let i = 0; i < 7; i++) {
          if (day <= lastDate) {
            const $cell = createCalendarCell(day, month, year);
            $row.append($cell);
            day++;
          } else {
            // **남은 빈 칸 채우기**
            $row.append($("<td></td>"));
          }
        }
        $calendarBody.append($row);
      }
    }

    // 셀 생성 함수 분리
    function createCalendarCell(day, month, year) {
      const $cell = $("<td></td>").text(day);
      const dateString = `${year}-${String(month + 1).padStart(2, "0")}-${String(day).padStart(2, "0")}`; // 'YYYY-MM-DD' 형식

      // 오늘 날짜인지 확인
      const isToday =
        day === todayDate && month === todayMonth && year === todayYear;

      // 오늘 이전 날짜인지 확인
      if (
        year < todayYear ||
        (year === todayYear && month < todayMonth) ||
        (year === todayYear && month === todayMonth && day < todayDate)
      ) {
        // 오늘 이전 날짜는 비활성화
        $cell.addClass("disabled");
      } else {
        // 선택된 날짜인지 확인
        if (selectedCalendarDates.includes(dateString)) {
          $cell.addClass("selected");
        }

        // 오늘 날짜에 특별한 스타일 적용
        if (isToday) {
          $cell.addClass("today");
        }

        // 클릭 이벤트 추가
        $cell.on("click", function () {
          if ($(this).hasClass("disabled")) return;

          if ($(this).hasClass("selected")) {
            $(this).removeClass("selected");
            removeDateCard(dateString);
          } else {
            $(this).addClass("selected");
            addDateCard(dateString);
          }
        });
      }

      // 데이터 속성 추가
      $cell.attr("data-date", dateString);

      return $cell;
    }

    /**
     * 월 및 연도 선택 시 달력 갱신 및 과거 월 비활성화
     */
    $("#month-select-calendar, #year-select-calendar").on(
      "change",
      function () {
        const selectedMonth = parseInt($("#month-select-calendar").val());
        const selectedYear = parseInt($("#year-select-calendar").val());
        generateCalendar(selectedMonth, selectedYear);
        disablePastMonthsAndYears();
      },
    );

    /**
     * 연도 및 월 선택 시 과거 월 비활성화 함수
     */
    function disablePastMonthsAndYears() {
      const selectedYear = parseInt($("#year-select-calendar").val());

      $("#month-select-calendar option").each(function () {
        const optionMonth = parseInt($(this).val());
        if (selectedYear === todayYear && optionMonth < todayMonth) {
          $(this).attr("disabled", true);
        } else {
          $(this).removeAttr("disabled");
        }
      });

      // 연도 선택 시 현재 연도 이전을 비활성화하려면 아래 주석 해제
      /*
        $("#year-select-calendar option").each(function () {
          const optionYear = parseInt($(this).val());
          if (optionYear < todayYear) {
            $(this).attr("disabled", true);
          } else {
            $(this).removeAttr("disabled");
          }
        });
      */
    }

    // 초기 달력 생성 (현재 월과 연도)
    const currentMonth = todayMonth; // 현재 월
    generateCalendar(currentMonth, currentYear);
    disablePastMonthsAndYears();
  }

  // 달력 함수 호출
  calender();

  // 상단 초기화
  $("#reset-selection-top").on("click", function () {
    // 점검 예정일
    $("#topScheduleDate").val("none");

    // 빈도 회수
    $("#top-frequency").val("all").trigger("change");

    // #top-count의 instance 가져오기
    const countInstance = $("#top-count").data("autocompleteInstance");
    if (countInstance) {
      countInstance.updateSelected("전체");
    } else {
      // instance가 없으면 기본 방법으로 설정
      $("#top-count").val("전체"); // 또는 적절한 기본값
    }

    // 상단 Autocomplete 필드 초기화
    $(".top-box-content .wrapper").each(function () {
      const $wrapper = $(this);
      const instance = $wrapper.data("autocompleteInstance");
      if (instance) {
        instance.updateSelected("전체");
      }
    });

    // 초기 데이터 다시 로드 (필터 없이 전체 데이터 로드)
    loadInitialData();
  });

  // 하단 초기화
  $("#reset-selection-bottom").on("click", function () {
    // 빈도 초기화
    $("#frequency").val("none");
    updateCountOptions("none");
    initializeUI();

    // 점검 예정일
    $("#bottomScheduleDate").val("all");

    // 하단 Autocomplete 필드 초기화
    $(".bottom-box-filter .wrapper").each(function () {
      const $wrapper = $(this);
      const instance = $wrapper.data("autocompleteInstance");
      if (instance) {
        instance.updateSelected("전체");
      }
    });

    // 커스텀 달력 선택 초기화
    resetDateCards();

    // 횟수 초기화
    $("#count").val("없음");
  });

  /**
   * 초기화 시 점검 예정일 및 커스텀 달력 표시 상태 설정
   */
  function initializeUI() {
    const selectedFrequency = $("#frequency").val();
    if (selectedFrequency === "none" || selectedFrequency === "daily") {
      $("#schedule-date-container").hide();
      $("#input-schedule").hide();
      $("#custom-calendar-container").show();
    } else {
      $("#schedule-date-container").show();
      $("#input-schedule").show();
      $("#custom-calendar-container").hide();
    }
  }

  /**
   * 커스텀 달력 선택 초기화 함수
   */
  function resetDateCards() {
    selectedCalendarDates = [];
    $("#selected-dates-container").empty();
    $(".calendar-body td.selected").removeClass("selected");
  }

  /**
   * 페이지 로드 시 초기 UI 설정
   */
  initializeUI();

  /**
   * 빈도 선택 변경 시 UI 업데이트
   */
  $("#frequency").change(function () {
    const selectedFrequency = $(this).val();
    updateCountOptions(selectedFrequency);
    resetDateCards();
    if (selectedFrequency === "none") {
      $("#schedule-date-container").hide();
      $("#input-schedule").hide();
      $("#custom-calendar-container").show();
    } else {
      $("#schedule-date-container").show();
      $("#input-schedule").show();
      $("#custom-calendar-container").hide();
    }
  });

  let topFrequencyOptions = {
    all: ["전체"],
    daily: generateOptions("매일마다", 31, "일마다"),
    weekly: generateOptions("매주마다", 5, "주마다"),
    monthly: generateOptions("매달마다", 12, "개월마다"),
    none: ["없음"],
  };
  $("#top-frequency").change(function () {
    const selectedFrequency = $(this).val();
    const countSelect = $("#top-count");
    countSelect.empty(); // 먼저 select 요소를 비웁니다.
    //countSelect.append('<option value="none">전체</option>');
    if (topFrequencyOptions[selectedFrequency]) {
      topFrequencyOptions[selectedFrequency].forEach((option) => {
        countSelect.append(`<option value="${option}">${option}</option>`); // 옵션 태그를 정확하게 닫습니다.
      });
    }
  });

  // '전체 선택' 체크박스 클릭 시
  $("#checkAll").click(function () {
    // 모든 'checkItem' 체크박스에 대해 체크 상태를 'checkAll'과 동일하게 설정
    $(".checkItem").prop("checked", this.checked);
  });

  // 개별 체크박스가 클릭될 때
  $(".checkItem").click(function () {
    // 'checkItem' 체크박스 중 하나라도 해제되면 'checkAll' 체크박스 해제
    if ($(".checkItem:checked").length === $(".checkItem").length) {
      $("#checkAll").prop("checked", true);
    } else {
      $("#checkAll").prop("checked", false);
    }
  });

  // 모달 영역 시작

  // 모달 내 li 들 이벤트 클릭
  $(document).on("click", ".list-group-item .item-info", function () {
    // 클릭된 요소가 이미 'highlighted' 클래스를 가지고 있는지 확인
    if ($(this).hasClass("highlighted")) {
      // 'highlighted' 클래스가 있다면 제거
      $(this).removeClass("highlighted");
    } else {
      // 'highlighted' 클래스가 없다면,
      // 다른 모든 요소에서 'highlighted' 클래스 제거 후
      $(".item-info").removeClass("highlighted");
      // 현재 클릭된 요소에만 'highlighted' 클래스 추가
      $(this).addClass("highlighted");
    }
  });

  // 모달 영역 끝

  /**
   * 검색 박스 토글 함수 정의
   */
  function toggleSearchBox() {
    const toggleButton = document.querySelector(".top-drop-down button"); // 버튼 선택
    const icon = toggleButton.querySelector("i"); // 아이콘 선택
    const searchSection = document.querySelector(
      ".top-box .bottom-box-content",
    ); // 검색 섹션 선택 --> 해당 부분은 접을 부분(custom)할 것

    // 초기 상태: 검색 섹션 닫힘
    let isOpen = false;

    // 초기 스타일 설정
    searchSection.style.maxHeight = "0";
    searchSection.style.overflow = "hidden"; // 내용 숨김

    // CSS 트랜지션을 추가하여 부드러운 애니메이션 효과
    searchSection.style.transition = "0.3s ease, transform 0.3s ease";

    // 버튼 클릭 이벤트 리스너
    toggleButton.addEventListener("click", () => {
      isOpen = !isOpen; // 상태 토글

      if (isOpen) {
        searchSection.style.maxHeight = `${searchSection.scrollHeight + 5}px`; // 자연스럽게 열기
        icon.style.transform = "rotate(-90deg)"; // 아이콘 180도 회전
      } else {
        searchSection.style.maxHeight = "0"; // 높이를 0으로 줄여서 닫기
        icon.style.transform = "rotate(0deg)"; // 아이콘 원래 상태로

        // 애니메이션이 끝나면 overflow를 hidden으로 설정
        searchSection.addEventListener(
          "transitionend",
          () => {
            if (!isOpen) searchSection.style.overflow = "hidden";
          },
          { once: true }, // 이벤트가 한 번만 실행되도록 설정
        );
      }
    });
  }

  // 함수 호출
  toggleSearchBox();

  /**
   * AG Grid 초기화 및 데이터 로드
   */

  // 초기 rowData를 빈 배열로 설정
  const rowData = [];

  // 통합 설정 객체
  const gridOptions = {
    rowData: rowData, // 초기에는 빈 배열
    columnDefs: [
      {
        headerName: "",
        checkboxSelection: true,
        headerCheckboxSelection: true,
        minWidth: 45,
        width: 70,
        resizable: true,
        cellStyle: { backgroundColor: "#ffffff" },
      },
      { field: "no", headerName: "순서", width: 60, minWidth: 50 },
      { field: "storeNm", headerName: "가맹점", width: 150, minWidth: 50 },
      { field: "brandNm", headerName: "브랜드", width: 150, minWidth: 110 },
      {
        field: "chklstNm",
        headerName: "체크리스트명",
        width: 180,
        minWidth: 110,
      },
      { field: "mbrNm", headerName: "점검자", width: 150, minWidth: 110 },
      {
        field: "inspPlanDt",
        headerName: "점검예정일",
        width: 160,
        minWidth: 110,
      },
      { field: "frqCd", headerName: "빈도", width: 130, minWidth: 70 },
      { field: "cntCd", headerName: "횟수", width: 130, minWidth: 70 },
      {
        headerName: "관리",
        field: "more",
        width: 100,
        minWidth: 53,
        cellRenderer: function (params) {
          // jQuery를 사용하여 컨테이너 div 생성
          const $container = $("<div>", {
            class: "edit-container",
            css: { position: "relative", cursor: "pointer" },
          });
          // console.log(params);
          // SVG 요소 생성
          const $svg = $(`
            <svg xmlns="http://www.w3.org/2000/svg" width="15" height="15" fill="currentColor" class="bi bi-three-dots-vertical" viewBox="0 0 15 15">
              <path d="M9.5 13a1.5 1.5 0 1 1-3 0 1.5 1.5 0 0 1 3 0m0-5a1.5 1.5 0 1 1-3 0 1.5 1.5 0 0 1 3 0m0-5a1.5 1.5 0 1 1-3 0 1.5 1.5 0 0 1 3 0"/>
            </svg>
          `);

          // '자세히보기' 옵션 div 생성
          const $editDiv = $('<div class="edit-options">자세히보기</div>');
          $editDiv.attr("data-store-id", params.data.storeId);

          // SVG 클릭 시 '자세히보기' 옵션 표시
          $svg.on("click", function (e) {
            e.stopPropagation(); // 이벤트 버블링 방지

            // 모든 다른 'edit-options' 숨기기
            $(".edit-options").not($editDiv).removeClass("show");

            // SVG의 위치 계산
            const offset = $svg.offset();
            const svgHeight = $svg.outerHeight();

            // 'edit-options' 위치 설정 (SVG 아래에 표시)
            $editDiv.css({
              top: offset.top + svgHeight + 2, // SVG 바로 아래에 2px 간격
              left: offset.left + $svg.outerWidth() / 2 - 43, // SVG의 중앙에 왼쪽으로 이동
              transform: "translateX(-50%)", // 가로 중앙 정렬
            });

            // 'show' 클래스 토글
            $editDiv.toggleClass("show");
          });

          // '자세히보기' 옵션 클릭 시 모달 열기
          $editDiv.on("click", function (e) {
            e.stopPropagation(); // 이벤트 버블링 방지

            // 'edit-options' 숨기기
            $editDiv.removeClass("show");

            // 클래스가 'row bottom-box mb-3'인 요소로 스크롤 이동
            const targetElement = $(".row.bottom-box.mb-3");

            if (targetElement.length > 0) {
              // 스크롤 이동 (부드럽게)
              targetElement[0].scrollIntoView({
                behavior: "smooth",
                block: "start",
              });

              // 요소에 포커스 설정 (필요한 경우)
              // 포커스를 받기 위해 tabindex="-1" 속성을 추가합니다.
              targetElement.attr("tabindex", "-1").focus();
            } else {
              console.warn("Target element not found.");
            }
          });

          // 컨테이너에 SVG 추가
          $container.append($svg);

          // 'edit-options'를 body에 추가
          $("body").append($editDiv);

          return $container[0]; // DOM 요소 반환
        },
        pinned: "right",
      },
    ],
    autoSizeStrategy: {
      type: "fitGridWidth",
      defaultMinWidth: 10,
    },
    rowHeight: 45,
    rowSelection: "multiple",
    pagination: true,
    paginationAutoPageSize: true,
    rowDragManaged: true,
    rowDragEntireRow: true,
    rowDragMultiRow: true,
    onCellClicked: (params) => {},

    // 드래그 종료 후 seq 업데이트

    // 그리드가 준비되었을 때 이벤트 핸들러 추가
    onGridReady: function (params) {
      // 그리드 API 저장
      gridOptions.api = params.api;
      gridOptions.columnApi = params.columnApi;

      //console.log("Grid API 초기화 완료:", gridOptions.api); // 디버깅용 로그

      // 초기 데이터 로드
      loadInitialData();

      // 체크리스트 개수 업데이트
      //updateChecklistCount();

      // 그리드 모델 업데이트 시 총 개수도 업데이트
      //gridOptions.api.addEventListener("modelUpdated", updateTotalCount);
    },
  };

  $("#masterChecklistModal").on("show.bs.modal", function (e) {
    const storeId = $(this).attr("data-store-id");
    //console.log("모달에 전달된 storeId:", storeId);

    if (storeId) {
      $.ajax({
        url: "/qsc/inspection-schedule/schedule-list/master-chklst/" + storeId,
        method: "GET",
        // GET 요청의 경우, storeId가 URL에 포함되어 있으므로 data 파라미터는 필요 없습니다.
        success: function (response) {
          //console.log("상세 데이터:", response);
          // 모달의 내용 업데이트
          const modalBody = $("#masterChecklistModal .modal-body");

          // 검색 박스 아래의 리스트 그룹을 선택
          const checklistList = modalBody.find(".list-group");
          checklistList.empty(); // 기존 리스트 항목 제거

          if (response && response.length > 0) {
            response.forEach(function (item, index) {
              const listItem = `
                            <li class="list-group-item d-flex justify-content-between align-items-center mb-1">
                                <div class="item-info d-flex align-items-center">
                                    <span class="me-3">${index + 1}</span>
                                    <p class="mb-0">${item.chklstNm}</p>
                                </div>
                                <button class="btn btn-primary btn-sm preview-btn" type="button" data-store-id="${item.storeId}" data-chklst-id="${item.chklstId}">
                                    미리보기
                                    <i class="fa-regular fa-eye"></i>
                                </button>
                            </li>
                        `;
              checklistList.append(listItem);
            });
          } else {
            const noDataItem = `
                        <li class="list-group-item">
                            찾으시는 체크리스트가 없습니다.
                        </li>
                    `;
            checklistList.append(noDataItem);
          }
        },
        error: function (xhr, status, error) {
          console.error("상세 데이터 요청 중 오류 발생:", error);
          Swal.fire({
            title: "오류!",
            text: "상세 데이터를 불러오는 중 오류가 발생했습니다.",
            icon: "error",
            confirmButtonText: "확인",
          });
        },
      });
    } else {
      console.warn("모달에 전달된 storeId가 없습니다.");
    }
  });

  // 문서 전체에 클릭 이벤트 바인딩하여 Popover 숨기기
  $(document).on("click", function () {
    $(".edit-options").removeClass("show");
  });
  // 그리드 컨테이너 선택
  const gridDiv = document.querySelector("#myGrid");

  // AG Grid 초기화 방식: new agGrid.Grid 사용
  new agGrid.Grid(gridDiv, gridOptions);

  /**
   * 체크리스트 개수를 업데이트하는 함수
   */
  function updateChecklistCount() {
    const checklistCount = document.getElementById("checklist_count");
    if (checklistCount && gridOptions.api) {
      // AG Grid API를 사용하여 현재 표시된 row 수 가져오기
      checklistCount.innerText = gridOptions.api.getDisplayedRowCount();
    } else {
      console.warn(
        "checklist_count 요소가 없거나 gridOptions.api가 초기화되지 않았습니다.",
      );
    }
  }

  /**
   * 총 개수 업데이트 함수
   */
  function updateTotalCount() {
    $("#totalCount").text(gridOptions.api.getDisplayedRowCount());
  }

  /**
   * 데이터 로드 함수
   */
  const FRQ_CD_MAP = {
    ED: "일별",
    EW: "주별",
    EM: "월별",
    NF: "빈도없음",
  };

  const FRQ_MAP = {
    ED: "daily",
    EW: "weekly",
    EM: "monthly",
    NF: "none",
  };

  const CNT_CD_MAP = {
    MO: "월",
    TU: "화",
    WE: "수",
    TH: "목",
    FR: "금",
    SA: "토",
    SU: "일",
    LD: "매월말일",
    D1: "매일마다",
    W1: "매주마다",
    M1: "매달마다",
    ...Object.fromEntries(
      Array.from({ length: 4 }, (_, i) => [`W${i + 2}`, `${i + 2}주마다`]),
    ),
    ...Object.fromEntries(
      Array.from({ length: 11 }, (_, i) => [`M${i + 2}`, `${i + 2}개월마다`]),
    ),
    ...Object.fromEntries(
      Array.from({ length: 30 }, (_, i) => [`D${i + 2}`, `${i + 2}일마다`]),
    ),
  };
  function createReverseMap(map) {
    return Object.fromEntries(
      Object.entries(map).map(([key, value]) => [value, key]),
    );
  }

  const FRQ_CD_REVERSE_MAP = createReverseMap(FRQ_MAP);
  const CNT_CD_REVERSE_MAP = createReverseMap(CNT_CD_MAP);

  function loadInitialData(filters = {}) {
    $.ajax({
      url: "/qsc/inspection-schedule/schedule-list/filter", // 필터 엔드포인트 사용
      method: "GET",
      data: filters, // 필터 파라미터 전달
      success: function (response) {
        if (response) {
          console.log("서버 응답 데이터:", response); // 데이터 정상 수신 확인
        }
        // 서버 응답을 grid에 맞게 변환
        const dataArray = Array.isArray(response) ? response : response.data;
        const formattedData = dataArray.map((item, index) => ({
          no: index + 1,
          storeNm: item.storeNm || "",
          brandNm: item.brandNm || "",
          chklstNm: item.chklstNm || "",
          inspPlanDt: item.inspPlanDt || "",
          mbrNm: item.mbrNm || "",
          storeId: item.storeId || "",
          cntCd: CNT_CD_MAP[item.cntCd?.toUpperCase()] || item.cntCd || "",
          frqCd: FRQ_CD_MAP[item.frqCd] || item.frqCd || "",
        }));

        if (gridOptions.api) {
          gridOptions.api.setGridOption("rowData", formattedData);
          updateChecklistCount();
        } else {
          console.error("AG Grid API가 초기화되지 않았습니다.");
        }
      },
      error: function (xhr, status, error) {
        console.error("Error fetching data:", error);
        Swal.fire({
          title: "오류!",
          text: "데이터를 불러오는 중 오류가 발생했습니다.",
          icon: "error",
          confirmButtonText: "확인",
        });
      },
    });
  }

  /**
   * 조회 버튼 클릭 시 필터링된 데이터 로드
   */
  $(".select-btn").on("click", function () {
    //console.log("오긴함"); // 클릭 이벤트 확인

    // 필터링할 파라미터 수집
    let storeNm = $("#storeNm").text().trim() || null;
    let brandNm = $("#brandNm").text().trim() || null;
    let scheduleDate = $("#topScheduleDate").val() || null;
    let chklstNm = $("#chklstNm").text().trim() || null;
    let inspector = $("#inspector").text().trim() || null;
    let frequencyLabel = $("#top-frequency").val() || null;
    let cntLabel = $("#top-count").val() || null;

    // 각 필터의 초기화 텍스트 정의, 검색에 제외하고 싶은 목록 넣음
    const placeholders = {
      storeNm: ["전체", "가맹점 검색", ""],
      brandNm: ["전체", "브랜드 검색", ""],
      chklstNm: ["전체", "체크리스트 검색", ""],
      inspector: ["전체", "점검자 검색", ""],
      frequency: ["전체", "all", ""],
      count: ["전체", "none", "없음", ""],
    };

    //console.log(frequencyLabel);
    // console.log(cntLabel);

    // placeholders에 포함된 값일 경우 null로 설정
    storeNm = placeholders.storeNm.includes(storeNm) ? null : storeNm;
    brandNm = placeholders.brandNm.includes(brandNm) ? null : brandNm;
    chklstNm = placeholders.chklstNm.includes(chklstNm) ? null : chklstNm;
    inspector = placeholders.inspector.includes(inspector) ? null : inspector;
    frequencyLabel = placeholders.frequency.includes(frequencyLabel)
      ? null
      : frequencyLabel;
    cntLabel = placeholders.count.includes(cntLabel) ? null : cntLabel;

    // 레이블을 코드로 변환
    const frequencyCode = frequencyLabel
      ? FRQ_CD_REVERSE_MAP[frequencyLabel] || frequencyLabel
      : null;
    const cntCode = cntLabel ? CNT_CD_REVERSE_MAP[cntLabel] || cntLabel : null;
    // console.log("변환된 fre  " + frequencyCode);
    // console.log("변환된 cntCode  " + cntCode);
    const filters = {};
    scheduleDate =
      scheduleDate != null ? scheduleDate.replaceAll("-", "") : null;
    if (storeNm) filters.storeNm = storeNm;
    if (brandNm) filters.brandNm = brandNm; // 필요 시 brandCode로 변경 가능
    if (scheduleDate) filters.scheduleDate = scheduleDate;
    if (chklstNm) filters.chklstNm = chklstNm;
    if (inspector) filters.inspector = inspector;
    if (frequencyCode) filters.frqCd = frequencyCode;
    if (cntCode) filters.cntCd = cntCode;

    // console.log(filters);
    // AJAX 요청을 통해 필터링된 데이터 로드
    loadInitialData(filters);
  });

  /**
   * 행 추가 함수
   */
  function onAddRow() {
    const newItem = {
      no: gridOptions.api.getDisplayedRowCount() + 1,
      storeNm: "",
      brandNm: "",
      inspPlanDt: "",
      creTm: "",
      mbrNm: "",
    };
    gridOptions.api.applyTransaction({ add: [newItem], addIndex: 0 });
    updateChecklistCount();
  }

  /**
   * 행 삭제 함수
   */
  function onDeleteRow() {
    const selectedRows = gridOptions.api.getSelectedRows();
    if (selectedRows.length > 0) {
      gridOptions.api.applyTransaction({ remove: selectedRows });
      updateChecklistCount();
    } else {
      Swal.fire({
        title: "경고!",
        text: "삭제할 항목을 선택해주세요.",
        icon: "warning",
        confirmButtonText: "확인",
      });
    }
  }

  // 행 추가 및 삭제 버튼 이벤트 바인딩
  $("#addRowButton").on("click", function () {
    onAddRow();
  });

  $("#deleteRowButton").on("click", function () {
    onDeleteRow();
  });
});
