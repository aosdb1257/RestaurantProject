<%@ page contentType="text/html; charset=UTF-8" session="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>


<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>좌석 선택</title>
<style>
  .container {
    width: 887px;
    display: flex;
    flex-direction: column;
    margin: 40px auto 0;
    border: 1px solid black;
  }
  .info-space {
    width: 887px;
    height: 70px;
    background-color: #f4f8fc;
    border: 1px solid #ccc;
    padding: 15px 20px;
    box-sizing: border-box;
    display: flex;
    justify-content: space-between;
    align-items: center;
    font-family: Arial;
    color: #333;
    font-size: 15px;
  }
  .info-box {
    font-weight: bold;
    padding: 10px 15px;
    display: flex;
    flex-direction: column;
    gap: 5px;
  }

  .seat-space {
    position: relative;
    width: 887px;
    height: 552px;
    background-image: url("${pageContext.request.contextPath}/resources/images/floor2.PNG");
    background-size: cover;
    background-repeat: no-repeat;
    border: 1px solid #ccc;
  }

  .seat {
    position: absolute;
    background-color: rgba(0, 128, 0, 0.4);
    cursor: pointer;
    border: 2px solid #fff;
    transition: background-color 0.2s;
    border-radius: 0;
  }

  .seat:hover {
    background-color: rgba(0, 200, 0, 0.8);
  }
  
  .next-btn {
  position: absolute;
  bottom: 10px;
  right: 10px;
  padding: 10px 20px;
  background-color: #00509e;
  color: white;
  border: none;
  border-radius: 5px;
  cursor: pointer;
}
</style>
</head>
<body>
<div>
<div class="container">
    <!-- 정보 출력 영역 -->
    <div style="width: 827px; padding: 30px; font-size: 30px; 
     color: #1a4f7a; text-align: left;
    border-bottom: 2px solid #3180c3;">
  		예약하기
	</div>
	<div class="info-space">
	  <div class="info-box">층 : ${floor}</div>
	  <div class="info-box">위치 : ${location}</div>
	  <div class="info-box">인원수 : ${headCount}</div>
	  <div class="info-box">날짜 : ${date}</div>
	  <div class="info-box">시간 : ${time}</div>
	</div>

  <div class="seat-space">
    <!-- 왼쪽 위 -->
    <div class="seat" data-seat-id="9" style="top: 48px; left: 95px; width: 40px; height: 68px;" onclick="selectSeat(9)"></div>
    
    <!-- 왼쪽 가운데 -->
    <div class="seat" data-seat-id="10" style="top: 205px; left: 109px; width: 77px; height: 93px;" onclick="selectSeat(10)"></div>

    <!-- 왼쪽 아래 -->
    <div class="seat" data-seat-id="11" style="top: 392px; left: 125px; width: 105px; height: 60px;" onclick="selectSeat(11)"></div>

    <!-- 2열 맨위 -->
    <div class="seat" data-seat-id="12" style="top: 155px; left: 270px; width: 92px; height: 139px;" onclick="selectSeat(12)"></div>
    
    <!-- 2열 맨아래 -->
    <div class="seat" data-seat-id="13" style="top: 417px; left: 338px; width: 72px; height: 99px;" onclick="selectSeat(13)"></div>
    
    <!-- 3열 맨위 -->
    <div class="seat" data-seat-id="14" style="top: 170px; left: 480px; width: 120px; height: 60px;" onclick="selectSeat(14)"></div>
    
    <!-- 3열 맨아래 -->
    <div class="seat" data-seat-id="15" style="top: 328px; left: 496px; width: 75px; height: 88px;" onclick="selectSeat(15)"></div>
    
    <!-- 오른쪽 위 -->
    <div class="seat" data-seat-id="16" style="top: 90px; left: 683px; width: 92px; height: 55px;" onclick="selectSeat(16)"></div>

    <!-- 오른쪽 중앙 -->
    <div class="seat" data-seat-id="17" style="top: 266px; left: 703px; width: 62px; height: 96px;" onclick="selectSeat(17)"></div>
	
  </div>
</div>

<script>
  const seatList = [
    <c:forEach var="seat" items="${seatList}" varStatus="status">
      {
        seatId: ${seat.seat_Id},
        location: '${seat.location}',
        headCount: ${seat.head_Count},
        floor: ${seat.floor}
      }
      <c:if test='${!status.last}'>,</c:if>
    </c:forEach>
  ];
</script>

<script>
  // 좌석 div에 좌석 정보 추가 (tooltip or 내부 텍스트 등)
  window.onload = function () {

    seatList.forEach(seat => {
      const seatDiv = document.querySelector(`.seat[data-seat-id='${seat.seatId}']`);
      if (seatDiv) {
        seatDiv.title = `${seat.location} (${seat.head_Count}명)`;
      }
    });
  }

  function selectSeat(seatId) {
	  console.log("선택된 좌석 ID:", seatId);
	  const selectedSeat = seatList.find(seat => Number(seat.seatId) === Number(seatId));
	  if (selectedSeat) {
	    alert("선택된 좌석 정보\n" +
	      "ID: " + selectedSeat.seatId + "\n" +
	      "위치: " + selectedSeat.location + "\n" +
	      "인원수: " + selectedSeat.headCount + "\n" +
	      "층수: " + selectedSeat.floor
	    );
	  } else {
	    alert("좌석 정보를 찾을 수 없습니다.");
	  }
	}
</script>

</body>
</html>
