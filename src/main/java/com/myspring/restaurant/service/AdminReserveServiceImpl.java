package com.myspring.restaurant.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.myspring.restaurant.dao.AdminReserveDAO;
import com.myspring.restaurant.vo.AdminReserveAddVO;
import com.myspring.restaurant.vo.CustomerReserveFirstVO;
import com.myspring.restaurant.vo.RestaurantSeatVO;

@Service
public class AdminReserveServiceImpl implements AdminReserveService {
	@Autowired
	private AdminReserveDAO adminReserveDAO;
	
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

	
}
