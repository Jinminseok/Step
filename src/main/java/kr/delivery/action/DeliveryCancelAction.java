package kr.delivery.action;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.controller.Action;
import kr.shop.dao.DeliveryDAO;

public class DeliveryCancelAction implements Action{

	@Override
	public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
			int dlvNum   = Integer.parseInt(request.getParameter("dlvNum"));
	        int orderNum = Integer.parseInt(request.getParameter("orderNum"));
	        int userNum  = Integer.parseInt(request.getParameter("userNum"));

	        DeliveryDAO.getInstance().cancelOrder(dlvNum, orderNum, userNum);

	        return "redirect:/shop/delivery/deliveryForm.do?msg=cancel_ok";
	    }
	}

