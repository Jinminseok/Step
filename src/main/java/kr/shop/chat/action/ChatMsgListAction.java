package kr.shop.chat.action;

import java.util.List;
import java.util.Map;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.controller.Action;
import kr.shop.dao.ChatDAO;

public class ChatMsgListAction implements Action {
    @Override
    public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
        response.setContentType("application/json; charset=UTF-8");

        String roomNumStr = request.getParameter("roomNum");
        String senderType = request.getParameter("senderType");

        if (roomNumStr == null || roomNumStr.equals("-1")) {
            response.getWriter().write("[]");
            return "none";
        }

        try {
            int roomNum = Integer.parseInt(roomNumStr);
            ChatDAO dao = ChatDAO.getInstance();

            // 읽음 처리 (상대방 메시지)
            if (senderType != null) {
                int st = Integer.parseInt(senderType);
                // 사용자가 읽으면 관리자(2) 메시지를 읽음처리
                // 관리자가 읽으면 사용자(1) 메시지를 읽음처리
                dao.markRead(roomNum, st == 1 ? 2 : 1);
            }

            List<Map<String, Object>> msgList = dao.getMsgList(roomNum);

            StringBuilder json = new StringBuilder("[");
            for (int i = 0; i < msgList.size(); i++) {
                Map<String, Object> m = msgList.get(i);
                if (i > 0) json.append(",");
                json.append("{");
                json.append("\"msgNum\":").append(m.get("msgNum")).append(",");
                json.append("\"msgSender\":").append(m.get("msgSender")).append(",");
                json.append("\"senderName\":\"").append(escapeJson(String.valueOf(m.get("senderName")))).append("\",");
                json.append("\"msgContent\":\"").append(escapeJson(String.valueOf(m.get("msgContent")))).append("\",");
                json.append("\"msgTime\":\"").append(m.get("msgTime")).append("\",");
                json.append("\"isRead\":").append(m.get("isRead"));
                json.append("}");
            }
            json.append("]");

            response.getWriter().write(json.toString());
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("[]");
        }
        return "none";
    }

    private String escapeJson(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r")
                .replace("\t", "\\t");
    }
}