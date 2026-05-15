package kr.delivery.action;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.controller.Action;
import kr.shop.dao.DeliveryDAO;


public class DeliveryUpdateAction implements Action{

	@Override
	public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		 	int   dlvNum    = Integer.parseInt(request.getParameter("dlvNum"));
	        int    dlvStatus = Integer.parseInt(request.getParameter("dlvStatus"));
	        String courier   = request.getParameter("courier");
	        String invoiceNo = request.getParameter("invoiceNo");

	        if (courier   == null) courier   = "";
	        if (invoiceNo == null) invoiceNo = "";

	        DeliveryDAO.getInstance().updateDelivery(dlvNum, dlvStatus, courier, invoiceNo);

	        return "redirect:/shop/delivery/deliveryForm.do?msg=update_ok";
	    }
	}