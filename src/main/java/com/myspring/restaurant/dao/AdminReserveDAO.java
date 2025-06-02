package com.myspring.restaurant.dao;

import java.util.List;

import com.myspring.restaurant.vo.AdminReserveAddVO;
import com.myspring.restaurant.vo.CustomerReserveFirstVO;
import com.myspring.restaurant.vo.RestaurantSeatVO;

public interface AdminReserveDAO {
	// 관리자 예약 등록하기
	void adminReserveAddDb(AdminReserveAddVO reserve);

	// ------------------------------------------------------------------------------
	// 고객 예약 첫번째 화면
	List<CustomerReserveFirstVO> customerReserveFirst();
	
	// 좌석 테이블 모두 조회
	List<RestaurantSeatVO> getAllSeats();
	
	// 예약 정보 저장
	void insertCustomerReservation(int reserveId, int seatId);
	
	// 잔액 확인
	int getBalance(int accountId);

	// 잔액 차감
	void updateBalance(int accountId, int i);
	
	// 거래 내역 저장
	void insertTransaction(int accountId, String string, int totalPrice);

}
