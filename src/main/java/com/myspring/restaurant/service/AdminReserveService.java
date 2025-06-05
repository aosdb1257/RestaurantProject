package com.myspring.restaurant.service;

import java.util.List;

import com.myspring.restaurant.vo.AdminReservationVO;
import com.myspring.restaurant.vo.AdminReserveAddVO;
import com.myspring.restaurant.vo.CustomerGetReserveInfoVO;
import com.myspring.restaurant.vo.CustomerReserveFirstVO;
import com.myspring.restaurant.vo.RestaurantSeatVO;
import com.myspring.restaurant.vo.SeatVO;

public interface AdminReserveService {
	// 관리자 예약 등록하기
	void adminReserveAddDb(AdminReserveAddVO reserve);

	
	// ---------------------------------------------------------------------------------------------------------------
	
	// 고객 예약 첫번째 화면 요청
	List<CustomerReserveFirstVO> customerReserveFirst();

	// 모든 좌석 테이블 정보 조회
	List<RestaurantSeatVO> getAllSeats();
	
	// 모든 예약한 테이블 번호 조회
	List<Integer> getReservedSeats(int reserveId);
	
	// 결제하고 결제정보 저장
	void reserveAndPay(int seatId, int reserveId, int totalPrice, Integer memberId);

	// 아이디로 해당 좌석 조회
	SeatVO getSeatById(int seatId);
	
	// 아이디로 해당 예약 조회
	AdminReservationVO getAdminReservationById(int reserveId);

	// 결제 정보 조회
	CustomerGetReserveInfoVO selectPayInfo(Integer memberId, Integer reserveId, Integer seatId);

}
