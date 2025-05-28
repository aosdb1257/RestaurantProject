package com.myspring.restaurant.dao;

import java.util.List;

import com.myspring.restaurant.vo.AdminReserveAddVO;
import com.myspring.restaurant.vo.CustomerReserveFirstVO;

public interface AdminReserveDAO {
	// 관리자 예약 등록하기
	void adminReserveAddDb(AdminReserveAddVO reserve);

	// ------------------------------------------------------------------------------
	// 고객 예약 첫번째 화면
	List<CustomerReserveFirstVO> customerReserveFirst();

}
