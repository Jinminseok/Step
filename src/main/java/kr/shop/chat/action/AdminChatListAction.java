package kr.shop.chat.action;

import java.util.List;
import java.util.Map;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.controller.Action;
import kr.shop.dao.ChatDAO;

public class AdminChatListAction implements Action {
    @Override
    public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
        List<Map<String, Object>> roomList = ChatDAO.getInstance().getRoomList();
        request.setAttribute("roomList", roomList);
        
        return "shop/chat/adminChatList.jsp";
    }
}