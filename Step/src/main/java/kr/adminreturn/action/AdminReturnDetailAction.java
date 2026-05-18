package kr.adminreturn.action;

import java.util.HashMap;
import java.util.Map;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.controller.Action;
import kr.shop.dao.AdminReturnDAO;
import kr.shop.vo.AdminOrderVO;
import kr.util.StringUtil; // 🌟 형님이 만드신 StringUtil 임포트

public class AdminReturnDetailAction implements Action {

    @Override
    public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
        
        String retNumStr = request.getParameter("retNum");        
        Map<String, Object> map = new HashMap<>();
        
        if (retNumStr == null || retNumStr.trim().isEmpty()) {
            map.put("result", "error");
            map.put("message", "신청번호가 누락되었습니다.");
            
            return StringUtil.parseJSON(request, map);
        }

        try {
            int retNum = Integer.parseInt(retNumStr);
            AdminReturnDAO dao = AdminReturnDAO.getInstance();
            AdminOrderVO item = dao.getReturnDetail(retNum);

            if (item == null) {
                map.put("result", "error");
                map.put("message", "해당 데이터를 찾을 수 없습니다.");
            } else {
                map.put("result", "success");
                map.put("order_num", item.getOrder_num());
                map.put("user_num", item.getUser_num());
                map.put("prod_name", item.getProd_name());
                map.put("reason", item.getReason());
                map.put("ret_status", item.getRet_status());
                map.put("is_good", item.getIs_good());                
                map.put("ret_note", item.getRet_note() != null ? item.getRet_note() : "");
                map.put("ret_note_admin", item.getRet_note() != null ? item.getRet_note() : ""); 
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            map.put("result", "error");
            map.put("message", "서버 내부 로직 에러 발생: " + e.getMessage());
        }

        return StringUtil.parseJSON(request, map);
    }
}