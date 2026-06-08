package kr.shop.chat.action;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.controller.Action;
import kr.shop.dao.ChatDAO;

public class AdminChatDeleteAction implements Action{

	@Override
	public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String roomNumStr = request.getParameter("roomNum");
        if (roomNumStr != null && !roomNumStr.trim().isEmpty()) {
            ChatDAO.getInstance().deleteRoom(Integer.parseInt(roomNumStr));
        }
        return "redirect:/shop/chat/adminChatList.do?msg=delete_ok";
	}
}
