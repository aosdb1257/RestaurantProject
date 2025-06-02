package com.myspring.restaurant.service;

import java.util.List;

import com.myspring.restaurant.vo.AdminReserveAddVO;
import com.myspring.restaurant.vo.CustomerReserveFirstVO;
import com.myspring.restaurant.vo.RestaurantSeatVO;

public interface AdminReserveService {
	// 관리자 예약 등록하기
	void adminReserveAddDb(AdminReserveAddVO reserve);

	
	// ---------------------------------------------------------------------------------------------------------------
	
	// 고객 예약 첫번째 화면 요청
	List<CustomerReserveFirstVO> customerReserveFirst();

	// 모든 좌석 테이블 정보 조회
	List<RestaurantSeatVO> getAllSeats();

	// 결제하고 결제정보 저장
	void reserveAndPay(int seatId, int reserveId, int totalPrice);
	
	// 잔액 확인
	

}
