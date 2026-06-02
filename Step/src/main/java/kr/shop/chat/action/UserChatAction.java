package kr.shop.chat.action;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import kr.controller.Action;
import kr.shop.dao.ChatDAO;

public class UserChatAction implements Action {
    @Override
    public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
        HttpSession session = request.getSession();
        Number userNum = (Number) session.getAttribute("user_num");
        if (userNum == null) return "redirect:/shop/user/loginForm.do";

        ChatDAO dao = ChatDAO.getInstance();

        // 방 조회만 (없으면 -1, 메시지 보낼 때 생성)
        int roomNum = dao.getRoomByUser(userNum.intValue());

        List<Map<String, Object>> msgList = new ArrayList<>();
        if (roomNum > 0) {
            msgList = dao.getMsgList(roomNum);
            dao.markRead(roomNum, 2); // 관리자 메시지 읽음 처리
        }

        request.setAttribute("roomNum", roomNum); 
        request.setAttribute("msgList", msgList);
        request.setAttribute("userNum", userNum.intValue());
        return "shop/chat/userChat.jsp";
    }
}