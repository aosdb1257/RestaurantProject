package com.myspring.restaurant.service;

import java.util.List;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.myspring.restaurant.dao.AdminReserveDAO;
import com.myspring.restaurant.vo.AdminReservationVO;
import com.myspring.restaurant.vo.AdminReserveAddVO;
import com.myspring.restaurant.vo.CustomerReserveFirstVO;
import com.myspring.restaurant.vo.RestaurantSeatVO;
import com.myspring.restaurant.vo.SeatVO;

@Service
public class AdminReserveServiceImpl implements AdminReserveService {
	@Autowired
	private AdminReserveDAO adminReserveDAO;
	
	private static final Logger logger = Logger.getLogger(AdminReserveServiceImpl.class);
	
	// 관리자 예약 등록하기
	@Override
	public void adminReserveAddDb(AdminReserveAddVO reserve) {
		adminReserveDAO.adminReserveAddDb(reserve);
	}



	
	// -------------------------------------------------------------------------------------------------------------------------
	
	// 고객 첫번째 예약 화면 요청
	@Override
	public List<CustomerReserveFirstVO> customerReserveFirst() {
		return adminReserveDAO.customerReserveFirst();
	}

	// 좌석 테이블 모두 조회
	@Override
	public List<RestaurantSeatVO> getAllSeats() {
		
		return adminReserveDAO.getAllSeats();
	}
	
	// 모든 예약한 테이블 조회
	@Override
	public List<Integer> getReservedSeats(int reserveId) {
		return adminReserveDAO.getReservedSeats(reserveId);
	}

	// 결제하고 결제정보 저장
	@Override
	@Transactional
	public void reserveAndPay(int seatId, int reserveId, int totalPrice) {
		int accountId = 1;
		
	    // 중복 결제 방지
	    int existing = adminReserveDAO.countReservation(reserveId, seatId);
	    if (existing > 0) {
	        throw new IllegalStateException("이미 결제된 예약입니다.");
	    }
		
		// 1. 예약 정보 저장
		adminReserveDAO.insertCustomerReservation(reserveId, seatId);
		
		// 2. 잔액 확인 및 추가
		Integer currentBalance = adminReserveDAO.getBalance(accountId);
		logger.info("현재 잔액: " + currentBalance + ", 결제 금액: " + totalPrice);
		
		/*
		 * 환불 기능 추가시
		 * if (currentBalance < totalPrice) { throw new
		 * IllegalArgumentException("잔액 부족"); }
		 */
		adminReserveDAO.updateBalance(accountId, totalPrice);
		
		// 3. 거래 내역 저장
		adminReserveDAO.insertTransaction(accountId, "DEPOSIT", totalPrice);
	
	}

	// 아이디로 좌석 조회
	@Override
	public SeatVO getSeatById(int seatId) {
		return adminReserveDAO.getSeatById(seatId);
	}

	// 아이디로 해당 예약 조회
	@Override
	public AdminReservationVO getAdminReservationById(int reserveId) {
		return adminReserveDAO.getAdminReservationById(reserveId);
	}
	
}
