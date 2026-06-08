package kr.shop.notify;

import java.util.HashMap;
import java.util.Map;
import java.util.List;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import kr.controller.Action;
import kr.shop.dao.UserNotifyDAO;
import kr.shop.vo.UserNotifyVO;
import kr.util.StringUtil;

public class GetNotiListAction implements Action {

    @Override
    public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

        Map<String, String> mapAjax = new HashMap<String, String>();

        HttpSession session = request.getSession();
        Long user_num = (Long) session.getAttribute("user_num");

        if (user_num == null) {
            mapAjax.put("list", "[]");
        } else {
            List<UserNotifyVO> list = UserNotifyDAO.getInstance().getNotifyList(user_num.intValue());

            StringBuilder sb = new StringBuilder();
            sb.append("[");
            for (int i = 0; i < list.size(); i++) {
                UserNotifyVO vo = list.get(i);
                sb.append("{");
                sb.append("\"notify_num\":").append(vo.getNotify_num()).append(",");
                sb.append("\"notify_type\":").append(vo.getNotify_type()).append(",");
                sb.append("\"notify_title\":\"").append(escapeJson(vo.getNotify_title())).append("\",");
                sb.append("\"notify_content\":\"").append(escapeJson(vo.getNotify_content())).append("\",");
                sb.append("\"read_yn\":\"").append(vo.getRead_yn()).append("\",");
                sb.append("\"formatted_date\":\"").append(vo.getFormatted_date()).append("\"");
                sb.append("}");
                if (i < list.size() - 1) sb.append(",");
            }
            sb.append("]");
            mapAjax.put("list", sb.toString());
        }

        return StringUtil.parseJSON(request, mapAjax);
    }

    private String escapeJson(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r");
    }
}