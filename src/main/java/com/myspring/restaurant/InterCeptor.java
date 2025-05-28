package com.myspring.restaurant;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

public class InterCeptor extends HandlerInterceptorAdapter {
	  //컨트롤러 클래스 실행전 요청한 주소에 관하여 뷰주소를 얻어 request메모리에 뷰주소를 저장하는 메소드
	  @Override
	   public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler){
		   try {
			
			   String viewName = getViewName(request);
			   request.setAttribute("viewName", viewName);
		   } catch (Exception e) {
			e.printStackTrace();
		   }
		   return true;
	   }
	  
	   //요청한 전체 주소에서 뷰 전체 주소를 얻기 위한 메소드 
	   // /admin/adminReserveAdd.do => "adminReserveAdd"
	   private String getViewName(HttpServletRequest request) throws Exception {
			String contextPath = request.getContextPath();
			String uri = (String) request.getAttribute("javax.servlet.include.request_uri");
			if (uri == null || uri.trim().equals("")) {
				uri = request.getRequestURI();
			}
			int begin = 0;
			if (!((contextPath == null) || ("".equals(contextPath)))) {
				begin = contextPath.length();
			}
			int end;
			if (uri.indexOf(";") != -1) {
				end = uri.indexOf(";");
			} else if (uri.indexOf("?") != -1) {
				end = uri.indexOf("?");
			} else {
				end = uri.length();
			}
			String fileName = uri.substring(begin, end);
			if (fileName.indexOf(".") != -1) {
				fileName = fileName.substring(0, fileName.lastIndexOf("."));
			}
			if (fileName.lastIndexOf("/") != -1) {
				fileName = fileName.substring(fileName.lastIndexOf("/",1), fileName.length());
			}
			return fileName;
	   }
}
