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
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.myspring.restaurant.BaseController;
import com.myspring.restaurant.service.AdminReserveService;
import com.myspring.restaurant.service.AdminReserveServiceImpl;
import com.myspring.restaurant.vo.AdminReserveAddVO;
import com.myspring.restaurant.vo.CustomerReserveFirstVO;
import com.myspring.restaurant.vo.RestaurantSeatVO;

@Controller
@RequestMapping("admin")
public class AdminReserveControllerImpl extends BaseController {
	@Autowired
	private AdminReserveService adminReserveService;

	@Override
	protected ModelAndView viewForm(HttpServletRequest request, HttpServletResponse response) throws Exception {
		return super.viewForm(request, response);
	}

	// 관리자 예약 등록 화면 요청 
	// localhost:8090/restaurant/admin/adminReserveAddMain.do
	@RequestMapping(value="/adminReserveAddMain.do" , method=RequestMethod.GET)
	public ModelAndView adminReserveAddMain(HttpServletRequest request, HttpServletResponse response) throws Exception {
		HttpSession session = request.getSession();  
		session.setAttribute("adminId", 15);
		
	    return viewForm(request, response); // WEB-INF/views/admin/adminReserveAdd.jsp
	}
	
	// 관리자 예약 등록 처리
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
	// 고객 예약 첫번쨰 화면 요청
	@RequestMapping(value="/customerReserveFirst.do", method=RequestMethod.GET)
	public ModelAndView customerReserveFirst(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		// 관리자가 등록한 모든 예약 정보
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
	@RequestMapping("/customerReserveFirstFloor.do")
    public ModelAndView moveToSecondStepFirst(
            @RequestParam("floor") String floor,
            @RequestParam("location") String location,
            @RequestParam("headCount") String headCount,
            @RequestParam("date") String date,
            @RequestParam("time") String time,
            @RequestParam("reserveId") int reserveId) {
		
        ModelAndView mav = new ModelAndView("/customer/customerReserveFirstFloor"); // JSP: /WEB-INF/views/customer/customerReserveFirst.jsp
        
        List<RestaurantSeatVO> restaurantSeatVOs = adminReserveService.getAllSeats();
        for (RestaurantSeatVO seat : restaurantSeatVOs) {
            System.out.println("좌석 ID: " + seat.getSeat_Id());
            System.out.println("위치: " + seat.getLocation());
            System.out.println("인원수: " + seat.getHead_Count());
            System.out.println("층수: " + seat.getFloor());
            System.out.println("-------------------------");
        }
        mav.addObject("seatList", restaurantSeatVOs);
        
        mav.addObject("floor", floor);
        mav.addObject("location", location);
        mav.addObject("headCount", headCount);
        mav.addObject("date", date);
        mav.addObject("time", time);
        mav.addObject("reserveId", reserveId);
        
        return mav;
	}
	@RequestMapping("/customerReserveSecondFloor.do")
    public ModelAndView moveToSecondStepSecond(
            @RequestParam("floor") String floor,
            @RequestParam("location") String location,
            @RequestParam("headCount") String headCount,
            @RequestParam("date") String date,
            @RequestParam("time") String time,
            @RequestParam("reserveId") int reserveId) {

        List<RestaurantSeatVO> restaurantSeatVOs = adminReserveService.getAllSeats();
        for (RestaurantSeatVO seat : restaurantSeatVOs) {
            System.out.println("좌석 ID: " + seat.getSeat_Id());
            System.out.println("위치: " + seat.getLocation());
            System.out.println("인원수: " + seat.getHead_Count());
            System.out.println("층수: " + seat.getFloor());
            System.out.println("-------------------------");
            
        }
        System.out.println("총 좌석 수: " + restaurantSeatVOs.size());
        System.out.println("좌석 데이터가 정상적으로 전달됨: " + restaurantSeatVOs);
        
        ModelAndView mav = new ModelAndView("/customer/customerReserveSecondFloor"); // JSP: /WEB-INF/views/customer/customerReserveSecond.jsp
        mav.addObject("seatList", restaurantSeatVOs);
        
        mav.addObject("floor", floor);
        mav.addObject("location", location);
        mav.addObject("headCount", headCount);
        mav.addObject("date", date);
        mav.addObject("time", time);

        return mav;
	}
	// 세 번째 화면으로(결제화면)
	@RequestMapping("customerReserveThird.do")
	public ModelAndView customerReserveThird(
			@RequestParam("seatId") int seatId,
		    @RequestParam("floor") String floor,
		    @RequestParam("location") String location,
		    @RequestParam("headCount") String headCount,
		    @RequestParam("date") String date,
		    @RequestParam("time") String time) {
	    
		ModelAndView mav = new ModelAndView("/customer/customerReserveThird"); // JSP: /WEB-INF/views/customer/customerReserveThird.jsp
		mav.addObject("seatId", seatId);
		mav.addObject("floor", floor);
		mav.addObject("location", location);
		mav.addObject("headCount", headCount);
		mav.addObject("date", date);
		mav.addObject("time", time);
		return mav;
	}
	
}
