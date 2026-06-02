package kr.shop.user.action;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import kr.controller.Action;
import kr.shop.dao.UserDAO;

public class ReturnRequestAction implements Action {

    @Override
    public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
        //한글 인코딩 세팅
        request.setCharacterEncoding("UTF-8");
        
        //로그인 및 세션 검증
        HttpSession session = request.getSession();
        String user_id = (String) session.getAttribute("user_id");
        
        if (user_id == null) {
            // 로그인 안 되어 있으면 로그인 폼으로 안전하게 리다이렉트
            return "redirect:/shop/user/loginForm.do";
        }
        
        // 프로젝트의 세션 구조대로 user_num 추출 및 캐스팅
        int userNum = ((Number) session.getAttribute("user_num")).intValue();
        
        // 3. 마이페이지 반품/교환 폼 데이터 수집
        String itemInfo = request.getParameter("item_info"); // "주문번호_상품번호_옵션번호" 구조
        String tpStr = request.getParameter("tp");           // 1:반품, 2:교환
        String reason = request.getParameter("reason");       // 사유 종류
        String retNote = request.getParameter("ret_note");     // 상세 기입 내용
        
        // 4. 비정상적인 접근 방어 코드
        if (itemInfo == null || itemInfo.trim().isEmpty() || tpStr == null) {
            return "redirect:/shop/user/myPageForm.do"; 
        }
        
        int tp = Integer.parseInt(tpStr);
        
        // 5. 언더바(_) 기준 문자열 토큰 파싱 처리
        String[] tokens = itemInfo.split("_");
        int orderNum = Integer.parseInt(tokens[0]); // ORD_NUM
        int prodNum  = Integer.parseInt(tokens[1]); // PROD_NUM
        int optNum   = Integer.parseInt(tokens[2]);  // OPT_NUM
        
        // 6. DB 비즈니스 로직 가동 (오라클 RETURNS 테이블 데이터 삽입)
        UserDAO dao = UserDAO.getInstance();
        dao.insertReturnRequest(userNum, orderNum, prodNum, optNum, tp, reason, retNote);
        
        return "redirect:/shop/user/myPageForm.do";
    }
}