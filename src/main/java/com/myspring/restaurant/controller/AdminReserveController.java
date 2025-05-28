package com.myspring.restaurant.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.myspring.restaurant.vo.AdminReserveAddVO;

public interface AdminReserveController {
	// 관리자 예약 등록 화면 요청
	public ModelAndView adminReserveAddMain(HttpServletRequest request, HttpServletResponse response) throws Exception;
	
	// 관리자 예약 등록하기
	public ModelAndView adminReserveAdd(AdminReserveAddVO reserve,
			HttpServletRequest request, HttpServletResponse response) throws Exception;
	
	//--------------------------------------------------------------------------------------------------------------------------
	
	// 회원 예약 화면
	public ModelAndView customerReserveFirst(HttpServletRequest request, HttpServletResponse response) throws Exception;

}
