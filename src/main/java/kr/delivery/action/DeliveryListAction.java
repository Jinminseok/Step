package kr.delivery.action;

import java.util.List;
import java.util.Map;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.controller.Action;
import kr.shop.dao.DeliveryDAO;

public class DeliveryListAction implements Action {

	@Override
	public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

		String status = request.getParameter("status");
		String keyword = request.getParameter("keyword");
		
		DeliveryDAO dao = DeliveryDAO.getInstance();
		List<Map<String, Object>> deliveryList = dao.getDeliveryList(status, keyword);
		Map<String, Integer> statusCount = dao.getStatusCount();
		
		request.setAttribute("deliveryList" ,deliveryList);
		request.setAttribute("statusCount", statusCount);
		request.setAttribute("statusSel", status);
		request.setAttribute("keyword", keyword);
		
		return "shop/delivery/deliveryForm.jsp";
	}
}
