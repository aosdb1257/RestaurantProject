package com.myspring.restaurant.dao;

import java.util.List;

import com.myspring.restaurant.vo.AdminReservationVO;
import com.myspring.restaurant.vo.AdminReserveAddVO;
import com.myspring.restaurant.vo.CustomerGetReserveInfoVO;
import com.myspring.restaurant.vo.CustomerReserveFirstVO;
import com.myspring.restaurant.vo.RestaurantSeatVO;
import com.myspring.restaurant.vo.SeatVO;

public interface AdminReserveDAO {
	// 관리자 예약 등록하기
	void adminReserveAddDb(AdminReserveAddVO reserve);

	// ------------------------------------------------------------------------------
	// 고객 예약 첫번째 화면
	List<CustomerReserveFirstVO> customerReserveFirst();
	
	// 좌석 테이블 모두 조회
	List<RestaurantSeatVO> getAllSeats();
	
	// 모든 예약한 테이블 번호 조회
	List<Integer> getReservedSeats(int reserveId);
	
	// 예약 정보 저장
	void insertCustomerReservation(int reserveId, int seatId , Integer memberId);
	
	// 잔액 확인
	int getBalance(int accountId);

	// 잔액 차감
	void updateBalance(int accountId, int i);
	
	// 거래 내역 저장
	void insertTransaction(int accountId, String string, int totalPrice, Integer memberId);
	
	// 아이디로 해당 좌석 조회
	SeatVO getSeatById(int seatId);

	// 아이디로 해당 에약 조회
	AdminReservationVO getAdminReservationById(int reserveId);
	
	// 중복 결제 방지
	int countReservation(int reserveId, int seatId);
	
	// 결제 정보 조회
	CustomerGetReserveInfoVO selectPayInfo(Integer memberId, Integer reserveId, Integer seatId);

	

}
