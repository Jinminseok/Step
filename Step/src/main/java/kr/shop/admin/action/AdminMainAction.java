package kr.shop.admin.action;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.controller.Action;
import kr.shop.dao.AdminDAO;

public class AdminMainAction implements Action {
    @Override
    public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
        // [Source 2] 관리자 메인에 필요한 데이터 로드 (나중에 구현하더라도 일단 틀은 필요함)
        // AdminDAO dao = AdminDAO.getInstance();
        // request.setAttribute("memberCount", dao.getMemberCount());
        
        // JSP 경로 리턴
        return "shop/admin/main.jsp";
    }
}