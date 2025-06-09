<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>예약 조회</title>
<style>
	.container {
	    width: 1580px;
	    height: 650px;
    	display: flex;
    	margin: 40px auto 0;
    	flex-direction: column;
	}
	
	.result {
		width: 1580px;
		height: 620px;
		display: flex;
    		
	}
	.result-left {
		flex: 1;
	    background-image: url("${pageContext.request.contextPath}/resources/images/floor1.PNG");
    background-size: contain;   /* ✅ 비율 유지하면서 이미지 전체 보이기 */
    background-repeat: no-repeat;
    background-position: center center;  /* ✅ 가운데 정렬 */
	}
	.result-right {
		flex: 1;
	    background-image: url("${pageContext.request.contextPath}/resources/images/floor2.PNG");
    background-size: contain;   /* ✅ 비율 유지하면서 이미지 전체 보이기 */
    background-repeat: no-repeat;
    background-position: center center;  /* ✅ 가운데 정렬 */	
	}
</style>
</head>
<body>
<div class="container">
	<h3>예약 조회</h3>
	<div class="head-container">
		<label>날짜:</label>
		<input type="date" id="reserveDate">
		
		<label>시간:</label>
		<select id="time">
		  <option value="1">1층</option>
		  <option value="12:00 ~ 13:00">12:00 ~ 13:00</option>
		  <option value="13:00 ~ 14:00">13:00 ~ 14:00</option>
		  <option value="14:00 ~ 15:00">14:00 ~ 15:00</option>
		  <option value="14:00 ~ 15:00">14:00 ~ 15:00</option>
		  <option value="14:00 ~ 15:00">15:00 ~ 16:00</option>
		  <option value="14:00 ~ 15:00">16:00 ~ 17:00</option>
		  <option value="14:00 ~ 15:00">17:00 ~ 18:00</option>
		  <option value="14:00 ~ 15:00">18:00 ~ 19:00</option>
		  <option value="14:00 ~ 15:00">19:00 ~ 20:00</option>
		</select>
		
		<button onclick="searchReserve()">조회</button>
	</div>
	<hr>
	
	<div class="result">
		<div class="result-left">
		
		</div>
		<div class="result-right">
		</div>
	</div>
</div>	
<script>
	function searchReserve() {
	    const date = $("#reserveDate").val();
	    const time = $("#time").val();
	
	    if (!date || !time) {
	        alert("날짜와 시간을 선택해주세요.");
	        return;
	    }
	
	    $.ajax({
	        url: "/adminReserveCheck.do",
	        type: "GET",
	        data: { date: date, time: time },
	        success: function(data) {

	        },
	        error: function() {
	            alert("조회 중 오류가 발생했습니다.");
	        }
	    });
	}
</script>	
</body>
</html>