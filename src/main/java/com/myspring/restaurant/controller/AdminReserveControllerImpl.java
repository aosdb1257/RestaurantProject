package com.myspring.restaurant.controller;

import java.io.PrintWriter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.myspring.restaurant.BaseController;
import com.myspring.restaurant.service.AdminReserveService;
import com.myspring.restaurant.service.AdminReserveServiceImpl;
import com.myspring.restaurant.vo.AdminCheckSeatVO;
import com.myspring.restaurant.vo.AdminReservationVO;
import com.myspring.restaurant.vo.AdminReserveAddVO;
import com.myspring.restaurant.vo.CustomerGetReserveInfoVO;
import com.myspring.restaurant.vo.CustomerReserveFirstVO;
import com.myspring.restaurant.vo.RestaurantSeatVO;
import com.myspring.restaurant.vo.SeatVO;

@Controller
@RequestMapping("admin")
public class AdminReserveControllerImpl extends BaseController {
	static Logger logger = Logger.getLogger(AdminReserveControllerImpl.class);
	
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
		
	    return viewForm(request, response); // WEB-INF/views/admin/adminReserveAddMain.jsp
	}
	
	// 관리자 예약 등록 처리
	@RequestMapping(value="/addReserve.do", method=RequestMethod.POST)
	public ModelAndView adminReserveAdd(@ModelAttribute("reserve") AdminReserveAddVO reserve, 
			HttpServletRequest request,
			HttpServletResponse response) throws Exception {
	    response.setContentType("text/html; charset=UTF-8");
	    response.setCharacterEncoding("UTF-8");
	    
	    try {
	        adminReserveService.adminReserveAddDb(reserve);
	        return new ModelAndView("redirect:/admin/adminReserveAddMain.do");
	    } catch (Exception e) {
	        e.printStackTrace(); 
	        PrintWriter out = response.getWriter();
	        
	        // 중복 예약 예외일 경우
	        if (e instanceof org.springframework.dao.DuplicateKeyException) {
	            out.println("<script>alert('⚠ 이미 예약된 날짜/시간/층입니다.'); history.back();</script>");
	            return null;
	        } 
	        
	        out.println("<script>alert('예약 등록 중 오류가 발생했습니다.'); history.back();</script>");
	        out.flush();
	        return null;
	    } 
	}

	// 관리자 예약 확인 화면 요청
	@RequestMapping(value="/adminReserveCheckMain.do", method = RequestMethod.GET)
	public ModelAndView adminReserveCheckMain(HttpServletRequest request, HttpServletResponse response) throws Exception {
		return viewForm(request, response); // WEB-INF/views/admin/adminReserveCheckMain.jsp
	}
	
	// 날짜와 시간에 해당하는 예약 조회
	@RequestMapping(value="/adminReserveCheck.do", method = RequestMethod.GET)
	@ResponseBody
	public List<AdminCheckSeatVO> checkReserve (
	        @RequestParam("date") String date,
	        @RequestParam("time") String time) {
		
		logger.info("date : " + date);
		logger.info("time : " + time);
		
	    // 1. 예약한 고객예약 아이디와 좌석번호 조회
		List<AdminCheckSeatVO> reservedId = adminReserveService.getReservedIdByDate(date, time);
	    logger.info("관리자 예약된 좌석 확인용 reservedId : " + reservedId);

	    return reservedId;  
	}
	
	@RequestMapping(value="/adminReserveDelete.do", method= RequestMethod.POST)
	public String adminReserveDelete(
			@RequestParam("seatId") int seatId,
            @RequestParam("customerId") int customerId,
            @RequestParam("memberId") int memberId,
            @RequestParam("content") String content) {
		
		logger.info("예약삭제 customerId : " + customerId);
		logger.info("예약삭제 seatId : " + seatId);
		logger.info("예약삭제 memberId : " + memberId);
		logger.info("예약삭제 content : " + content);
		
		try {
			adminReserveService.adminReserveDelete(seatId, customerId, memberId, content);
		} catch (Exception e) {
			logger.error("예약 삭제 중 오류 발생", e);
			return "errorPage";
		}
		
		return null;
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
        // 전체 좌석 목록
        mav.addObject("seatList", restaurantSeatVOs);
        
        //
        List<Integer> reservedSeatsId = adminReserveService.getReservedSeats(reserveId); 
        mav.addObject("reservedSeatsId", reservedSeatsId);
        
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

		ModelAndView mav = new ModelAndView("/customer/customerReserveSecondFloor"); // JSP: /WEB-INF/views/customer/customerReserveSecond.jsp

		List<RestaurantSeatVO> restaurantSeatVOs = adminReserveService.getAllSeats();
        for (RestaurantSeatVO seat : restaurantSeatVOs) {
            System.out.println("좌석 ID: " + seat.getSeat_Id());
            System.out.println("위치: " + seat.getLocation());
            System.out.println("인원수: " + seat.getHead_Count());
            System.out.println("층수: " + seat.getFloor());
            System.out.println("-------------------------");
            
        }
        mav.addObject("seatList", restaurantSeatVOs);

        List<Integer> reservedSeatsId = adminReserveService.getReservedSeats(reserveId); 
        mav.addObject("reservedSeatsId", reservedSeatsId);
        
        mav.addObject("floor", floor);
        mav.addObject("location", location);
        mav.addObject("headCount", headCount);
        mav.addObject("date", date);
        mav.addObject("time", time);
        mav.addObject("reserveId", reserveId);

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
		    @RequestParam("time") String time,
			@RequestParam("reserveId") int reserveId) {
	    
		ModelAndView mav = new ModelAndView("/customer/customerReserveThird"); // JSP: /WEB-INF/views/customer/customerReserveThird.jsp
		mav.addObject("seatId", seatId);
		mav.addObject("floor", floor);
		mav.addObject("location", location);
		mav.addObject("headCount", headCount);
		mav.addObject("date", date);
		mav.addObject("time", time);
		mav.addObject("reserveId", reserveId);
		return mav;
	}
	// 결제하기(성공시 결제정보 화면)
	@RequestMapping(value = "customerReservePay.do", method = RequestMethod.POST)
	public String customerReserveFour(
			@RequestParam("seatId") int seatId,
			@RequestParam("reserveId") int reserveId,
			@RequestParam("totalPrice") int totalPrice,
			HttpServletRequest request) {
		
		try {
			HttpSession session = request.getSession();
			session.setAttribute("reserveId", reserveId);
			session.setAttribute("seatId", seatId);
			//Integer memberId = (Integer) session.getAttribute("memberId");
			Integer memberId = Integer.parseInt("15");
			// 트랜잭션
			adminReserveService.reserveAndPay(seatId, reserveId, totalPrice, memberId);
	        
	        return "redirect:/admin/customerReserveFour.do";
			
		} catch (IllegalStateException  e) {
	        // 중복 결제 등 사용자 실수에 의한 예외
	        request.setAttribute("message", e.getMessage());
	        request.setAttribute("redirectUrl", request.getContextPath() + "/admin/customerReserveFirst.do");
	        return "common/alert";
		} catch (Exception e) {
	        e.printStackTrace();
	        return "redirect:/errorPage.jsp";
		}
	}
	// adminReserveService.getSeatById(seatId)
	// adminReserveService.getAdminReservationById(reserveId)
	@RequestMapping("customerReserveFour.do")
	public ModelAndView customerReserveFour(HttpServletRequest request) {
		
		
		HttpSession session = request.getSession();
	    // 고객 아이디 꺼내오기
	    //Integer memberId = (Integer) session.getAttribute("memberId");
	    Integer memberId = Integer.parseInt("15");
	    Integer reserveId = (Integer) session.getAttribute("reserveId");
	    Integer seatId = (Integer) session.getAttribute("seatId");
	    logger.info("memberId : " + memberId);
	    logger.info("reserveId : " + reserveId);
	    logger.info("seatId : " + seatId);
	    
	    CustomerGetReserveInfoVO infoVo = adminReserveService.selectPayInfo(memberId, reserveId, seatId);
	    
	    ModelAndView mav = new ModelAndView("/customer/customerReserveFour");
	    System.out.println("infovo : " + infoVo);
	    
	    mav.addObject("info", infoVo);
	    
	    return mav;
	}
}
