package kr.shop.member.action;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.controller.Action;
import kr.shop.dao.MemberDAO;

public class MemberDeleteAction implements Action {

    @Override
    public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
        int userNum = Integer.parseInt(request.getParameter("userNum"));

        MemberDAO.getInstance().deleteMember(userNum);

        return "redirect:/shop/member/memberForm.do?msg=delete_ok";
    }
}