<%@ page contentType="text/html; charset=UTF-8" session="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="contextPath" value="${pageContext.request.contextPath}"/>


<!-- ex. 2025-05-28 -->
<fmt:formatDate value="<%= new java.util.Date() %>" pattern="yyyy-MM-dd" var="today"/>

<!DOCTYPE html>
<html>
<head>
  <title>예약 관련 선택</title>
  <!-- Flatpickr 관련 -->
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
  <script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
  <script src="https://cdn.jsdelivr.net/npm/flatpickr/dist/l10n/ko.js"></script>
  <style>
    * { margin: 0; padding: 0; box-sizing: border-box; font-family: Arial; }
    body {height: 100vh; }
  
    .container { width: 60%; margin: 0 auto; padding-top: 10px; display: flex; }
    
    /* 왼쪽 사이드바  */
    .step-menu {
      background-color: #e60113; color: white;
      flex: 1; display: flex; flex-direction: column;
    }
    .step-menu div {
    display: flex; flex-direction: column;
      padding: 20px; cursor: pointer;
      border-bottom: 1px solid rgba(255,255,255,0.2);
    }
    .step-menu div.active { background-color: #a00010; }
	form {flex: 10;}
	/* 메인화면 */
    .main-container {
      display: flex; flex-direction: column; background-color: #f9f9f9;
    }
    .top-row {display: flex; justify-content: space-between;}
	.area-select {display: flex; gap: 20px;}
    .area-select, .headCount-select {
      background: white; border-right: 1px solid #ccc;
      flex: 6; padding: 10px;
    }
    .floor, .location {flex:1; }
    
    .schedule-block {
      flex: 8; padding: 20px;
    }

    .floor-option, .location-option, .headCount-option, .calendar-day, .time-slot {
      padding: 8px; margin: 5px 0; cursor: pointer;
      border-radius: 5px;
    }
    .floor-option:hover, .location-option:hover, .headCount-option:hover,
    .calendar-day:hover, .time-slot:hover {
      background-color: #eee;
    }
    .selected { background-color: black; color: white !important; }

    .calendar { display: flex; justify-content: space-between; align-items: center; }
    .calendar-days { display: flex; gap: 10px; margin: 10px 0; }
    .time-list { margin-top: 20px; }
    .time-slot {
      display: inline-block; padding: 10px; margin-right: 10px;
      border: 1px solid #ccc; background-color: white;
    }

    .next-btn {
      margin-top: 30px; padding: 12px 20px; font-size: 16px;
      background-color: #e60113; color: white; border: none; border-radius: 5px;
      cursor: not-allowed; opacity: 0.6;
    }
    .next-btn.enabled {
      cursor: pointer; opacity: 1;
    }
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
      <!-- 블록 2 -->
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

      <!-- 블록 3 인원수 -->
      <div class="headCount-select">
        <h4>인원수</h4>
        <div class="firstfloor-headCount-select" style="display:none">
	        <div class="headCount-option" onclick="selectItem(this, 'headCount')">2명</div>
	        <div class="headCount-option" onclick="selectItem(this, 'headCount')">4명</div>
	        <div class="headCount-option" onclick="selectItem(this, 'headCount')">6명</div>
        </div>
        <div class="secondfloor-headCount-select" style="display:none">
	        <div class="headCount-option" onclick="selectItem(this, 'headCount')">2명</div>
	        <div class="headCount-option" onclick="selectItem(this, 'headCount')">4명</div>
	        <div class="headCount-option" onclick="selectItem(this, 'headCount')">6명</div>
	        <div class="headCount-option" onclick="selectItem(this, 'headCount')">8명</div>
        </div>
      </div>
      </div>

      <!-- 블록 4 -->
      <div class="schedule-block">
        <!-- 달력 표시용 input -->
		<label>날짜 선택:
		  <input type="text" id="datePicker" value="${today}" required>
		</label>
		
		<!-- 선택된 날짜를 form에 전달할 hidden input -->
		
		<!-- 시간대 출력 -->
		<div class="time-list" id="timeList"></div>

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
    let selected = { floor: null, location:null, headCount: null, date: null, time: null };
	
    // 해당 항목을 선택된 상태로 표시하고, selected 객체에 저장, input(hidden)에 반영하여
    function selectItem(element, type) {
      document.querySelectorAll("." + type + "-option, ." + type + "-slot")
      .forEach(el => {
        if (el.classList) el.classList.remove("selected");
      });
      element.classList.add("selected");
      
      // 선택한 값 저장
      selected[type] = element.innerText;
      // hidden 태그에 저장
      document.getElementById("input-" + type).value = selected[type];
      
      const form = document.getElementById("reserveForm");
      // 층수 클릭시 위치와 인원수 옵션 보여주는 기능
      if (type === "floor") {
    	  if (element.innerText === "1층") {
    	    showSubArea("firstfloor");
    	    showHeadCountByFloor("firstfloor");
    	    form.action = "${contextPath}/admin/customerReserveFirstFloor.do";
    	  } else if (element.innerText === "2층") {
    	    showSubArea("secondfloor");
    	    showHeadCountByFloor("secondfloor");
    	    form.action = "${contextPath}/admin/customerReserveSecondFloor.do";
    	  }
    	}
      	validateForm();
    }
    
    function showSubArea(areaId) {
    	  document.querySelectorAll(".sub-area-select").forEach(el => {
    	    el.style.display = "none";
    	  });

    	  document.getElementById("sub-" + areaId).style.display = "block";
    }
    function showHeadCountByFloor(floorId) {
    	  document.querySelectorAll(".firstfloor-headCount-select, .secondfloor-headCount-select").forEach(el => {
    	    el.style.display = "none";
    	  });

    	  document.querySelector("." + floorId + "-headCount-select").style.display = "block";
    }
    function validateForm() {
      console.log(selected.floor);
      console.log(selected.location);
      console.log(selected.headCount);
      console.log(selected.date);
      console.log(selected.time);
      const btn = document.getElementById("nextBtn");
      if (selected.floor && selected.location && selected.headCount && selected.date && selected.time) {
        btn.classList.add("enabled");
        btn.disabled = false;
      }
    }
  </script>
  
<!-- 숨겨진 div에 전체 예약 정보 JSON 형태로 embed -->
<script>
	const reserveList = [
		<c:forEach var="vo" items="${reserveList}" varStatus="status">
			{
				reserveId: '${vo.reserve_Id}',
				date: '<fmt:formatDate value="${vo.reserve_Date}" pattern="yyyy-MM-dd"/>',
		   		time: '${vo.time_Slot}'
		 	}
			<c:if test="${!status.last}">,</c:if>
		</c:forEach>
	];
</script>

<script>
  function updateTimeSlots(selectedDate) {
    const timeListDiv = document.getElementById("timeList");
    timeListDiv.innerHTML = ""; // 기존 시간 제거

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
      }
      timeListDiv.appendChild(div);
    });
  }

  // 페이지 최초 로드시 현재 날짜 시간대 출력
  window.onload = function () {
    updateTimeSlots(document.getElementById("input-date").value);
  }
</script>
  
<script>
  flatpickr("#datePicker", {
	    dateFormat: "Y-m-d",
	    locale: "ko",
	    minDate: "today",
	    maxDate: new Date().fp_incr(7),
	    onChange: function(selectedDates, dateStr) {
	      document.getElementById("input-date").value = dateStr;
	      selected.date = dateStr;
	      updateTimeSlots(dateStr);
	    }
	  });
</script>
</body>
</html>
