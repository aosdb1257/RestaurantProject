package com.myspring.restaurant.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.myspring.restaurant.vo.AdminCheckSeatVO;
import com.myspring.restaurant.vo.AdminReservationVO;
import com.myspring.restaurant.vo.AdminReserveAddVO;
import com.myspring.restaurant.vo.CustomerGetReserveInfoVO;
import com.myspring.restaurant.vo.CustomerReserveFirstVO;
import com.myspring.restaurant.vo.RestaurantSeatVO;
import com.myspring.restaurant.vo.SeatVO;

@Repository
public class AdminReserveDAOImpl implements AdminReserveDAO {
    @Autowired
    private SqlSession sqlSession;
    
	// 관리자 예약 등록하기
	@Override
	public void adminReserveAddDb(AdminReserveAddVO reserve) {
		sqlSession.insert("mappers.adminReserve.insertReserve", reserve);
	}
	
	@Override
	public List<AdminCheckSeatVO> getReservedIdByDate(String date, String time) {
	    Map<String, Object> paramMap = new HashMap<String, Object>();
	    paramMap.put("date", date);
	    paramMap.put("time", time);
	    
		return sqlSession.selectList("mappers.adminReserve.getReservedIdByDate", paramMap);
	}
	
	@Override
	public void adminAddDeleteMessage(int customerId, String content) {
	    Map<String, Object> params = new HashMap<String, Object>();
	    params.put("customerId", customerId);
	    params.put("content", content);

	    sqlSession.insert("mappers.notification.adminAddDeleteMessage", params);
	}

	@Override
	public void adminReserveDelete(int customerId) {
		sqlSession.delete("mappers.adminReserve.adminReserveDelete", customerId);
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
	
	// 예약한 좌석 테이블 번호 조회
	@Override
	public List<Integer> getReservedSeats(int reserveId) {
		return sqlSession.selectList("mappers.customerReserve.selectAllReservedSeats", reserveId);
	}

	// 잔액 확인
	@Override
	public int getBalance(int accountId) {
		//return sqlSession.selectOne("mappers.customerReserve.getBalance", accountId);
	    Integer balance = sqlSession.selectOne("mappers.customerReserve.getBalance", accountId);
	    if (balance == null) {
	        throw new IllegalArgumentException("해당 계좌의 잔액 정보를 찾을 수 없습니다. (accountId: " + accountId + ")");
	    }
	    return balance;
	}
	// 잔액 추가
	@Override
	public void updateBalance(int accountId, int amount) {
	    Map<String, Object> paramMap = new HashMap<String, Object>();
	    paramMap.put("accountId", accountId);
	    paramMap.put("amount", amount);
	    
		sqlSession.update("mappers.customerReserve.updateBalance", paramMap);
	}
	// 거래 내역 저장
	@Override
	public void insertTransaction(int accountId, String type, int totalPrice, Integer memberId) {
	    Map<String, Object> paramMap = new HashMap<String, Object>();
	    paramMap.put("accountId", accountId);
	    paramMap.put("type", type);
	    paramMap.put("totalPrice", totalPrice);
	    paramMap.put("memberId", memberId);
	    
		sqlSession.insert("mappers.customerReserve.insertTransaction", paramMap);
	}
	// 예약 정보 저장
	@Override
	public void insertCustomerReservation(int reserveId, int seatId, Integer memberId) {
	    Map<String, Object> paramMap = new HashMap<String, Object>();
	    paramMap.put("reserveId", reserveId);
	    paramMap.put("seatId", seatId);
	    paramMap.put("memberId", memberId);
		
		sqlSession.insert("mappers.customerReserve.insertCustomerReservation", paramMap);
	}
	// 아이디로 해당 좌석 조회
	@Override
	public SeatVO getSeatById(int seatId) {
		return sqlSession.selectOne("mappers.customerReserve.selectSeatById", seatId);
	}

	// 아이디로 해당 예약 조회
	@Override
	public AdminReservationVO getAdminReservationById(int reserveId) {
		return sqlSession.selectOne("mappers.customerReserve.selectAdminReservationById", reserveId);
	}
	// 중복 결제 방지
	@Override
	public int countReservation(int reserveId, int seatId) {
		Map<String, Integer> paramMap = new HashMap<String, Integer>();
		paramMap.put("reserveId", reserveId);
		paramMap.put("seatId", seatId);
		return sqlSession.selectOne("mappers.customerReserve.countReservation", paramMap);
	}
	
	// 결제 정보 조회
	@Override
	public CustomerGetReserveInfoVO selectPayInfo(Integer memberId, Integer reserveId, Integer seatId) {
		Map<String, Integer> paramMap = new HashMap<String, Integer>();
		paramMap.put("memberId", memberId);
		paramMap.put("reserveId", reserveId);
		paramMap.put("seatId", seatId);
		
		return sqlSession.selectOne("mappers.customerReserve.selectPayInfo", paramMap);
	}
	
	
	
}