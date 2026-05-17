package kr.delivery.action;

import java.util.List;
import java.util.Map;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.controller.Action;
import kr.shop.dao.DeliveryDAO;

public class DeliveryDetailAction implements Action{

	@Override
	public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		int orderNum = Integer.parseInt(request.getParameter("orderNum"));

        List<Map<String, Object>> orderItems =
            DeliveryDAO.getInstance().getOrderItems(orderNum);

        // JSON으로 응답
        response.setContentType("application/json; charset=UTF-8");

        StringBuilder json = new StringBuilder();
        json.append("[");
        for (int i = 0; i < orderItems.size(); i++) {
            Map<String, Object> item = orderItems.get(i);
            if (i > 0) json.append(",");
            json.append("{");
            json.append("\"prodName\":")  .append(toJson(item.get("prodName")))   .append(",");
            json.append("\"brandName\":") .append(toJson(item.get("brandName")))  .append(",");
            json.append("\"catName\":")   .append(toJson(item.get("catName")))    .append(",");
            json.append("\"sizeVal\":")   .append(item.get("sizeVal"))            .append(",");
            json.append("\"color\":")     .append(toJson(item.get("color")))      .append(",");
            json.append("\"qty\":")       .append(item.get("qty"))                .append(",");
            json.append("\"itemPrice\":") .append(item.get("itemPrice"))          .append(",");
            json.append("\"prodImgUrl\":").append(toJson(item.get("prodImgUrl"))) ;
            json.append("}");
        }
        json.append("]");

        response.getWriter().write(json.toString());
        return null;
    }

    private String toJson(Object val) {
        if (val == null) return "\"\"";
        return "\"" + val.toString()
            .replace("\\", "\\\\")
            .replace("\"", "\\\"") + "\"";
    }
}