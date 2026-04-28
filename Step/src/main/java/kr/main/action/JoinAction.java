package kr.main.action;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.controller.Action;

public class JoinAction implements Action {
    @Override
    public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
        
        // POST 방식일 때 (가입 버튼 눌렀을 때)
        if (request.getMethod().equalsIgnoreCase("POST")) {
            request.setCharacterEncoding("utf-8"); // 한글 깨짐 방지
            
            // 1. 파라미터 꺼내기
            String userEmail = request.getParameter("userEmail");
            String userPw = request.getParameter("userPw");
            // ... 나머지 데이터들
            
            // 2. DAO 객체 생성해서 DB에 저장 (나중에 구현할 부분)
            // MemberDAO dao = MemberDAO.getInstance();
            // dao.insertMember(vo);
            
            // 3. 가입 완료 후 로그인 페이지나 메인으로 이동
            return "redirect:/member/login.do"; 
        }

        // GET 방식일 때 (그냥 가입 페이지 들어왔을 때)
        return "shop/member/KM_join.jsp"; 
    }
}