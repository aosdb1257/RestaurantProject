package com.myspring.restaurant.controller;

import java.io.PrintWriter;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import com.myspring.restaurant.BaseController;
import com.myspring.restaurant.service.AdminReserveService;
import com.myspring.restaurant.service.AdminReserveServiceImpl;
import com.myspring.restaurant.vo.AdminReserveAddVO;
import com.myspring.restaurant.vo.CustomerReserveFirstVO;

@Controller
@RequestMapping("admin")
public class AdminReserveControllerImpl extends BaseController implements AdminReserveController {
	
	@Autowired
	private AdminReserveService adminReserveService;

	@Override
	protected ModelAndView viewForm(HttpServletRequest request, HttpServletResponse response) throws Exception {
		return super.viewForm(request, response);
	}

	// 관리자 예약 등록 화면 요청 
	// localhost:8090/restaurant/admin/adminReserveAdd
	@Override
	@RequestMapping(value="/adminReserveAddMain.do" , method=RequestMethod.GET)
	public ModelAndView adminReserveAddMain(HttpServletRequest request, HttpServletResponse response) throws Exception {
		HttpSession session = request.getSession();  
		session.setAttribute("adminId", 15);
		
	    return viewForm(request, response); // WEB-INF/views/admin/adminReserveAdd.jsp
	}
	
	// 관리자 예약 등록 처리
	@Override
	@RequestMapping(value="/addReserve.do", method=RequestMethod.POST)
	public ModelAndView adminReserveAdd(@ModelAttribute("reserve") AdminReserveAddVO reserve, 
			HttpServletRequest request,
			HttpServletResponse response) throws Exception {
	    response.setContentType("text/html; charset=UTF-8");
	    response.setCharacterEncoding("UTF-8");
	    
		String contextPath = request.getContextPath();
		
	    try {
	        adminReserveService.adminReserveAddDb(reserve);
	        PrintWriter out = response.getWriter();
	        return new ModelAndView("redirect:/admin/adminReserveAddMain.do");
	    } catch (Exception e) {
	        e.printStackTrace(); 
	        PrintWriter out = response.getWriter();
	        out.println("<script>alert('예약 등록 중 오류가 발생했습니다.'); history.back();</script>");
	        out.flush();
	        return null;
	    } 
	}

	
	
	//----------------------------------------------------------------------------------------------------------------------------------

	@Override
	@RequestMapping(value="/customerReserveFirst.do", method=RequestMethod.GET)
	public ModelAndView customerReserveFirst(HttpServletRequest request, HttpServletResponse response) throws Exception {
		HttpSession session = request.getSession();  
		session.setAttribute("customerId", 16);
		
		List<CustomerReserveFirstVO> customerReserveFirstVOs = adminReserveService.customerReserveFirst();
		
		for (CustomerReserveFirstVO vo : customerReserveFirstVOs) {
		    System.out.println("예약번호: " + vo.getReserve_Id());
		    System.out.println("식사시간: " + vo.getMeal_Time());
		    System.out.println("예약날짜: " + vo.getReserve_Date());
		    System.out.println("시간대: " + vo.getTime_Slot());
		    System.out.println("층: " + vo.getFloor());
		    System.out.println("생성일: " + vo.getCreated_At());
		    System.out.println("----------------------------");
		}
		
		ModelAndView mav = new ModelAndView("/customer/customerReserveFirst"); // JSP 경로
		mav.addObject("reserveList", customerReserveFirstVOs);
		return mav;
	}
}
