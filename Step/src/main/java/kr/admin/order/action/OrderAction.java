package kr.admin.order.action;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.admin.order.dao.AdminOrderDAO;
import kr.controller.Action;
import kr.util.PagingUtil;


public class OrderAction implements Action{

	@Override
	public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		request.setCharacterEncoding("utf-8");
        
        String pageNum = request.getParameter("pageNum");
        if (pageNum == null) pageNum = "1";
        int currentPage = Integer.parseInt(pageNum);
        
        String sDate = request.getParameter("sDate");
        String eDate = request.getParameter("eDate");
        String sStatus = request.getParameter("sStatus");
        String sKeywordType = request.getParameter("sKeywordType");
        String sKeyword = request.getParameter("sKeyword");

        Map<String, Object> map = new HashMap<>();
        map.put("sDate", sDate);
        map.put("eDate", eDate);
        map.put("sStatus", sStatus);
        map.put("sKeywordType", sKeywordType);
        map.put("sKeyword", sKeyword);

        AdminOrderDAO dao = AdminOrderDAO.getInstance();
        int count = dao.getOrderCount(map);

        // 🌟 addKey 조립 (날짜, 상태 등 추가 검색 조건을 URL에 붙이기 위함)
        StringBuilder addKey = new StringBuilder();
        if(sDate != null && !sDate.isEmpty()) addKey.append("&sDate=").append(sDate);
        if(eDate != null && !eDate.isEmpty()) addKey.append("&eDate=").append(eDate);
        if(sStatus != null && !sStatus.equals("ALL")) addKey.append("&sStatus=").append(sStatus);

        // 🌟 PagingUtil 호출! (10개씩 목록, 10개씩 페이지 블록)
        PagingUtil page = new PagingUtil(
                sKeywordType, sKeyword, currentPage, count, 10, 10, "adminorderForm.do", addKey.toString()
        );
        
        // PagingUtil이 계산해준 시작행/끝행 번호를 map에 담기
        map.put("startRow", page.getStartRow());
        map.put("endRow", page.getEndRow());

        List<Map<String, Object>> orderList = null;
        if (count > 0) {
            orderList = dao.getOrderList(map);
        }

        // JSP로 데이터 쏘기
        request.setAttribute("count", count);
        request.setAttribute("orderList", orderList);
        request.setAttribute("page", page.getPage().toString());
		
		return "shop/admin_order/adminorderForm.jsp";
	}
}
