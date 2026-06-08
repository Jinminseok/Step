package kr.shop.chat.action;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import kr.controller.Action;
import kr.shop.dao.ChatDAO;

public class ChatSendAction implements Action {
    @Override
    public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json; charset=UTF-8");

        HttpSession session = request.getSession();
        Number userNum = (Number) session.getAttribute("user_num");

        if (userNum == null) {
            response.getWriter().write("{\"result\":\"fail\",\"msg\":\"로그인 필요\"}");
            return "none";
        }

        try {
            String roomNumStr    = request.getParameter("roomNum");
            String content       = request.getParameter("content");
            String senderTypeStr = request.getParameter("senderType");

            if (content == null || content.trim().isEmpty()) {
                response.getWriter().write("{\"result\":\"fail\",\"msg\":\"내용 없음\"}");
                return "none";
            }

            int roomNum    = (roomNumStr == null || roomNumStr.equals("-1")) ? -1 : Integer.parseInt(roomNumStr);
            int senderType = Integer.parseInt(senderTypeStr);

            // 방 없으면 자동 생성 후 메시지 전송, 생성된 roomNum 반환
            int newRoomNum = ChatDAO.getInstance().sendMsg(
                userNum.intValue(), senderType, content.trim(), roomNum);

            response.getWriter().write("{\"result\":\"ok\",\"roomNum\":" + newRoomNum + "}");

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("{\"result\":\"fail\",\"msg\":\"서버 오류\"}");
        }

        return "none";
    }
}