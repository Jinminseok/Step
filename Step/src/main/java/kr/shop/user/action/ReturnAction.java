package kr.shop.user.action;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import kr.controller.Action;
import kr.shop.dao.UserReturnDAO;

public class ReturnAction implements Action {

    @Override
    public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
        
        // 1. 인코딩 및 세션 체크 (로그인 유저 식별)
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        
        // 세션에 저장된 user_num 가져오기 
        Integer userNum = (Integer) session.getAttribute("user_num"); 

        if (userNum == null) {
            // 로그인이 안 되어있으면 로그인 창으로 튕겨냅니다.
            return "redirect:/shop/user/loginForm.do"; 
        }

        // 2. 폼에서 넘어온 파라미터 싹 다 받기
        String orderNumStr = request.getParameter("order_num");
        String tpStr = request.getParameter("tp");
        String reason = request.getParameter("reason");
        String retNote = request.getParameter("ret_note");

        // 🚨 방어 코드: 주문을 아예 선택하지 않고 신청 버튼을 누른 경우
        if (orderNumStr == null || orderNumStr.trim().isEmpty()) {
            request.setAttribute("notice_msg", "반품/교환할 주문을 선택해주세요.");
            request.setAttribute("notice_url", request.getContextPath() + "/shop/mypage/myPage.do");
            return "/WEB-INF/views/common/alert_view.jsp"; 
        }

        try {
            int orderNum = Integer.parseInt(orderNumStr);
            int tp = Integer.parseInt(tpStr);

            // 3. DAO 호출해서 DB에 확실하게 박아넣기
            UserReturnDAO dao = UserReturnDAO.getInstance();
            dao.insertReturnRequest(orderNum, userNum, tp, reason, retNote);            
            
        } catch (Exception e) {            
            e.printStackTrace();
            throw e;
        }

        // 4. 신청이 깔끔하게 끝나면 다시 마이페이지 메인으로 새로고침!
        return "redirect:/shop/mypage/myPage.do"; 
    }
}