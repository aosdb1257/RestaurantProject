<%@ page contentType="text/html; charset=UTF-8" session="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="contextPath" value="${pageContext.request.contextPath}"/>
<fmt:formatDate value="<%= new java.util.Date() %>" pattern="yyyy-MM-dd" var="today"/>

<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>예약 관련 선택</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
  <script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
  <script src="https://cdn.jsdelivr.net/npm/flatpickr/dist/l10n/ko.js"></script>
  <style>
    * { margin: 0; padding: 0; box-sizing: border-box; font-family: Arial; }
    body { height: 100vh; }
    .container { width: 60%; margin: 0 auto; padding-top: 10px; display: flex; }
    .step-menu { background-color: #e60113; color: white; flex: 1; display: flex; flex-direction: column; }
    .step-menu div { padding: 20px; cursor: pointer; border-bottom: 1px solid rgba(255,255,255,0.2); }
    .step-menu div.active { background-color: #a00010; }
    form { flex: 10; }
    .main-container { display: flex; flex-direction: column; background-color: #f9f9f9; }
    .top-row { display: flex; justify-content: space-between; }
    .area-select { display: flex; gap: 20px; background: white; border-right: 1px solid #ccc; flex: 6; padding: 10px; }
    .floor, .location { flex: 1; }
    .headCount-select { background: white; border-right: 1px solid #ccc; flex: 6; padding: 10px; }
    .schedule-block { flex: 8; padding: 20px; }
    .floor-option, .location-option, .headCount-option, .time-slot {
      padding: 8px; margin: 5px 0; cursor: pointer; border-radius: 5px;
    }
    .floor-option:hover, .location-option:hover, .headCount-option:hover, .time-slot:hover {
      background-color: #eee;
    }
    .selected { background-color: black; color: white !important; }
    .next-btn {
      margin-top: 30px; padding: 12px 20px; font-size: 16px;
      background-color: #e60113; color: white; border: none; border-radius: 5px;
      cursor: not-allowed; opacity: 0.6;
    }
    .next-btn.enabled { cursor: pointer; opacity: 1; }
  </style>
</head>
<body>

<div class="container">
  <div class="step-menu">
    <div class="active">01 상영시간</div>
    <div onclick="alert('이전 단계 완료 후 이동하세요')">02 인원/좌석</div>
    <div onclick="alert('이전 단계 완료 후 이동하세요')">03 결제</div>
    <div onclick="alert('이전 단계 완료 후 이동하세요')">04 결제완료</div>
  </div>

  <form id="reserveForm" method="post" action="">
    <div class="main-container">
      <div class="top-row">
        <!-- 장소 -->
        <div class="area-select">
          <div class="floor">
            <h4>장소</h4>
            <div class="floor-option" onclick="selectItem(this, 'floor')">1층</div>
            <div class="floor-option" onclick="selectItem(this, 'floor')">2층</div>
          </div>
          <div class="location">
            <h4>위치</h4>
            <div class="sub-area-select" id="sub-firstfloor" style="display:none">
              <div class="location-option" onclick="selectItem(this, 'location')">창가자리</div>
              <div class="location-option" onclick="selectItem(this, 'location')">입구근처</div>
              <div class="location-option" onclick="selectItem(this, 'location')">중앙</div>
              <div class="location-option" onclick="selectItem(this, 'location')">구석자리</div>
            </div>
            <div class="sub-area-select" id="sub-secondfloor" style="display:none">
              <div class="location-option" onclick="selectItem(this, 'location')">창가자리</div>
              <div class="location-option" onclick="selectItem(this, 'location')">중앙</div>
              <div class="location-option" onclick="selectItem(this, 'location')">구석자리</div>
            </div>
          </div>
        </div>

        <!-- 인원수 -->
        <div class="headCount-select">
          <h4>인원수</h4>
          <div class="headCount-option" style="display:none" onclick="selectItem(this, 'headCount')">2명</div>
          <div class="headCount-option" style="display:none" onclick="selectItem(this, 'headCount')">4명</div>
          <div class="headCount-option" style="display:none" onclick="selectItem(this, 'headCount')">6명</div>
          <div class="headCount-option" style="display:none" onclick="selectItem(this, 'headCount')">8명</div>
        </div>
      </div>

      <!-- 시간 선택 -->
      <div class="schedule-block">
        <label>날짜 선택:
          <input type="text" id="datePicker" value="${today}" required>
        </label>
        <div class="time-list" id="timeList"></div>

        <!-- Hidden Inputs -->
        <input type="hidden" name="floor" id="input-floor">
        <input type="hidden" name="location" id="input-location">
        <input type="hidden" name="headCount" id="input-headCount">
        <input type="hidden" name="date" id="input-date" value="${today}">
        <input type="hidden" name="time" id="input-time">
        <input type="hidden" name="reserveId" id="input-reserveId">
        <button type="submit" class="next-btn" id="nextBtn" disabled>다음 단계</button>
      </div>
    </div>
  </form>
</div>

<script>
  let selected = { floor: null, location: null, headCount: null, date: null, time: null };

  function selectItem(element, type) {
    document.querySelectorAll("." + type + "-option, ." + type + "-slot").forEach(el => {
      el.classList?.remove("selected");
    });
    element.classList.add("selected");
    selected[type] = element.innerText;
    document.getElementById("input-" + type).value = selected[type];

    const form = document.getElementById("reserveForm");

    if (type === "floor") {
      showSubArea(selected.floor === "1층" ? "firstfloor" : "secondfloor");
      form.action = selected.floor === "1층" ?
        "${contextPath}/admin/customerReserveFirstFloor.do" :
        "${contextPath}/admin/customerReserveSecondFloor.do";
    }

    if (type === "location") {
      const floor = selected.floor;
      const location = element.innerText;

      if (floor === "1층") {
        if (location === "창가자리") showHeadCounts(["4명"]);
        else if (location === "입구근처") showHeadCounts(["6명"]);
        else if (location === "중앙") showHeadCounts(["2명", "4명"]);
        else if (location === "구석자리") showHeadCounts(["2명", "4명"]);
      } else if (floor === "2층") {
        if (location === "창가자리") showHeadCounts(["4명", "6명"]);
        else if (location === "중앙") showHeadCounts(["4명", "8명"]);
        else if (location === "구석자리") showHeadCounts(["2명"]);
      }
    }

    validateForm();
  }

  function showSubArea(areaId) {
    document.querySelectorAll(".sub-area-select").forEach(el => el.style.display = "none");
    document.getElementById("sub-" + areaId).style.display = "block";
  }

  function showHeadCounts(allowedList) {
    document.querySelectorAll(".headCount-option").forEach(el => {
      if (allowedList.includes(el.innerText)) {
        el.style.display = "block";
      } else {
        el.style.display = "none";
        el.classList.remove("selected");
      }
    });
  }

  function validateForm() {
    const btn = document.getElementById("nextBtn");
    btn.classList.toggle("enabled", Object.values(selected).every(v => v));
    btn.disabled = !Object.values(selected).every(v => v);
  }
</script>

<script>
  const reserveList = [
    <c:forEach var="vo" items="${reserveList}" varStatus="status">
      {
        reserveId: '${vo.reserve_Id}',
        date: '<fmt:formatDate value="${vo.reserve_Date}" pattern="yyyy-MM-dd"/>',
        time: '${vo.time_Slot}'
      }<c:if test="${!status.last}">,</c:if>
    </c:forEach>
  ];

  function updateTimeSlots(selectedDate) {
    const timeListDiv = document.getElementById("timeList");
    timeListDiv.innerHTML = "";
    const filtered = reserveList.filter(item => item.date === selectedDate);
    if (filtered.length === 0) {
      timeListDiv.innerHTML = "<div>예약 가능한 시간이 없습니다.</div>";
      return;
    }
    filtered.forEach(item => {
      const div = document.createElement("div");
      div.className = "time-slot";
      div.innerText = item.time;
      div.onclick = () => {
        selectItem(div, 'time');
        document.getElementById("input-reserveId").value = item.reserveId;
      };
      timeListDiv.appendChild(div);
    });
  }

  window.onload = () => updateTimeSlots(document.getElementById("input-date").value);

  flatpickr("#datePicker", {
    dateFormat: "Y-m-d",
    locale: "ko",
    minDate: "today",
    maxDate: new Date().fp_incr(7),
    onChange: (selectedDates, dateStr) => {
      document.getElementById("input-date").value = dateStr;
      selected.date = dateStr;
      updateTimeSlots(dateStr);
    }
  });
</script>

</body>
</html>
