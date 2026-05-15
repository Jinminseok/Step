package kr.admin.order.action;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.admin.order.dao.AdminOrderDAO;
import kr.controller.Action;
import kr.util.StringUtil;

public class OrderDetailAction implements Action{

	@Override
    public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
        // AJAX 응답을 담을 큰 바구니
        Map<String, Object> ajaxMap = new HashMap<>();

        try {
            // 1. 파라미터 안전하게 받기
            String ordNumStr = request.getParameter("ordNum");
            if(ordNumStr == null || ordNumStr.trim().isEmpty()) {
                throw new Exception("주문번호 파라미터(ordNum)가 전달되지 않았습니다.");
            }
            int ordNum = Integer.parseInt(ordNumStr);

            AdminOrderDAO dao = AdminOrderDAO.getInstance();
            
            // 2. 데이터 가져오기
            Map<String, Object> master = dao.getOrderMaster(ordNum);
            List<Map<String, Object>> items = dao.getOrderItems(ordNum);
            
            // 3. 성공 시 데이터 포장
            ajaxMap.put("result", "success");
            ajaxMap.put("master", master);
            ajaxMap.put("items", items);

        } catch (Exception e) {
            e.printStackTrace();            
            ajaxMap.put("result", "error");
            ajaxMap.put("message", e.getMessage());
        }
        
        return StringUtil.parseJSON(request, ajaxMap);
    }
	
}
