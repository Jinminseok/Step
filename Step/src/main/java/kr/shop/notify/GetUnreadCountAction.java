package kr.shop.notify;

import java.util.HashMap;
import java.util.Map;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import kr.controller.Action;
import kr.shop.dao.UserNotifyDAO;
import kr.util.StringUtil;

public class GetUnreadCountAction implements Action {

    @Override
    public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

        Map<String, String> mapAjax = new HashMap<String, String>();

        HttpSession session = request.getSession();
        Long user_num = (Long) session.getAttribute("user_num");

        if (user_num == null) {
            mapAjax.put("count", "0");
        } else {
            int count = UserNotifyDAO.getInstance().getUnreadCount(user_num.intValue());
            mapAjax.put("count", String.valueOf(count));
        }

        return StringUtil.parseJSON(request, mapAjax);
    }
}