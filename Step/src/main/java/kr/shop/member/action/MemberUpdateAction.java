package kr.shop.member.action;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.controller.Action;
import kr.shop.dao.MemberDAO;

public class MemberUpdateAction implements Action {

    @Override
    public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
        int userNum = Integer.parseInt(request.getParameter("userNum"));
        int grade   = Integer.parseInt(request.getParameter("grade"));

        MemberDAO.getInstance().updateGrade(userNum, grade);

        return "redirect:/shop/member/memberForm.do?msg=grade_ok";
    }
}