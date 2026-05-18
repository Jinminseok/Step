package kr.adminreturn.action;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.controller.Action;
import kr.shop.dao.AdminReturnDAO;

public class AdminReturnProcessAction implements Action {

    @Override
    public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
        
        // 1. 한글 인코딩 처리
        request.setCharacterEncoding("UTF-8");

        // 2. 폼 데이터 수집
        String retNumStr = request.getParameter("ret_num");
        String retStatusStr = request.getParameter("ret_status");
        String isGoodStr = request.getParameter("is_good");
        String retNoteAdmin = request.getParameter("ret_note_admin"); // 관리자가 작성한 조치 메모

        // 방어 코드
        if (retNumStr == null || retNumStr.trim().isEmpty()) {
            return "redirect:/shop/return/returnForm.do";
        }

        int retNum = Integer.parseInt(retNumStr);
        int retStatus = Integer.parseInt(retStatusStr);
        int isGood = Integer.parseInt(isGoodStr);

        // 3. DAO 호출하여 오라클 데이터베이스 최종 UPDATE 기동!
        AdminReturnDAO dao = AdminReturnDAO.getInstance();
        dao.updateReturnStatus(retNum, retStatus, isGood, retNoteAdmin);

        // 4. 저장이 끝나면 대시보드 메인으로 리다이렉트 처리하여 현황판 갱신
        return "redirect:/shop/return/returnForm.do";
    }
}