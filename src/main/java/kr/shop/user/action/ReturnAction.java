package kr.shop.user.action;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import kr.controller.Action;
import kr.shop.dao.UserReturnDAO;

public class ReturnAction implements Action {

    @Override
    public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
        
        //인코딩 및 세션 체크 (로그인 유저 식별)
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        
        Object sessionUserNum = session.getAttribute("user_num"); 

        if (sessionUserNum == null) {
            // 로그인이 안 되어있으면 로그인 창으로 튕겨냅니다.
            return "redirect:/shop/user/loginForm.do"; 
        }
        int userNum = ((Number) sessionUserNum).intValue();

        // 2. 폼에서 넘어온 파라미터 싹 다 받기
        String orderNumStr = request.getParameter("order_num");
        String tpStr = request.getParameter("tp");
        String reason = request.getParameter("reason");
        String retNote = request.getParameter("ret_note");

        // 방어 코드: 주문을 아예 선택하지 않고 신청 버튼을 누른 경우
        if (orderNumStr == null || orderNumStr.trim().isEmpty()) {
            request.setAttribute("notice_msg", "반품/교환할 주문을 선택해주세요.");
            request.setAttribute("notice_url", request.getContextPath() + "/shop/mypage/myPage.do");
            return "/WEB-INF/views/common/alert_view.jsp"; 
        }

        try {
            int orderNum = Integer.parseInt(orderNumStr);
            int tp = Integer.parseInt(tpStr);

            //DAO 호출해서 DB에 확실하게 박아넣기
            UserReturnDAO dao = UserReturnDAO.getInstance();
            dao.insertReturnRequest(orderNum, userNum, tp, reason, retNote);
            
            // 이클립스 콘솔에서 성공 여부 확인용
            System.out.println("✅ 반품/교환 신청 완료! (주문번호: " + orderNum + ", 유형: " + tp + ")");

        } catch (Exception e) {
            System.out.println("🚨 [ReturnAction 에러 발생]");
            e.printStackTrace();
            throw e;
        }

        //신청이 깔끔하게 끝나면 다시 마이페이지 메인으로 새로고침!
        return "redirect:/shop/user/myPageForm.do"; 
    }
}