package com.myspring.restaurant.dao;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.myspring.restaurant.vo.AdminReserveAddVO;
import com.myspring.restaurant.vo.CustomerReserveFirstVO;
import com.myspring.restaurant.vo.RestaurantSeatVO;

@Repository
public class AdminReserveDAOImpl implements AdminReserveDAO {
    @Autowired
    private SqlSession sqlSession;
	
	// 관리자 예약 등록하기
	@Override
	public void adminReserveAddDb(AdminReserveAddVO reserve) {
		sqlSession.insert("mappers.adminReserve.insertReserve", reserve);
	}


	
	
	// ------------------------------------------------------------------------------------------------
	
	// 고객 예약 첫번째 화면 요청
	@Override
	public List<CustomerReserveFirstVO> customerReserveFirst() {
		return sqlSession.selectList("mappers.customerReserve.selectAllReservations");
	}

	// 좌석 테이블 모두 조회
	@Override
	public List<RestaurantSeatVO> getAllSeats() {
		return sqlSession.selectList("mappers.customerReserve.selectAllSeats");
	}
	
}