package kr.shop.chat.action;

import java.util.List;
import java.util.Map;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import kr.controller.Action;
import kr.shop.dao.ChatDAO;

public class AdminChatViewAction implements Action {
    @Override
    public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
        HttpSession session = request.getSession();

        // roomNum 방어 코드
        String roomNumStr = request.getParameter("roomNum");
        if (roomNumStr == null || roomNumStr.trim().isEmpty()) {
            return "redirect:/shop/chat/adminChatList.do";
        }
        int roomNum = Integer.parseInt(roomNumStr);

        // adminNum null 방어 코드
        Number adminNum = (Number) session.getAttribute("user_num");
        int adminNumInt = (adminNum != null) ? adminNum.intValue() : 0;

        ChatDAO dao = ChatDAO.getInstance();
        List<Map<String, Object>> msgList = dao.getMsgList(roomNum);
        dao.markRead(roomNum, 1);

        request.setAttribute("roomNum",  roomNum);
        request.setAttribute("msgList",  msgList);
        request.setAttribute("adminNum", adminNumInt);

        if (adminNum == null) {
            return "redirect:/shop/user/loginForm.do";
        }
        
        return "shop/chat/adminChatView.jsp";
        
        
    }
}