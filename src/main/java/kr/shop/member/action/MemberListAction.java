package kr.shop.member.action;

import java.util.List;
import java.util.Map;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.controller.Action;
import kr.shop.dao.MemberDAO;

public class MemberListAction implements Action {

    @Override
    public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String keyword = request.getParameter("keyword");
        String grade   = request.getParameter("grade");

        MemberDAO dao = MemberDAO.getInstance();
        List<Map<String, Object>> memberList = dao.getMemberList(keyword, grade);

        request.setAttribute("memberList",   memberList);
        request.setAttribute("totalCount",   dao.getTotalCount());
        request.setAttribute("vipCount",     dao.getCountByGrade(4));
        request.setAttribute("goldCount",    dao.getCountByGrade(3));
        request.setAttribute("silverCount",  dao.getCountByGrade(2));
        request.setAttribute("normalCount",  dao.getCountByGrade(1));
        request.setAttribute("keyword",      keyword);
        request.setAttribute("gradeSel",     grade);

        return "shop/member/memberForm.jsp";
    }
}