package kr.shop.member.action;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import kr.controller.Action;

public class LoginAction implements Action{

	@Override
	public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
        // 1. 폼에서 넘어온 파라미터 받기
        String id = request.getParameter("id");
        String passwd = request.getParameter("passwd");
        
        // 2. DAO를 통해 로그인 체크 및 회원 정보 가져오기 (예시 로직)
        // MemberDAO dao = MemberDAO.getInstance();
        // MemberVO member = dao.checkLogin(id, passwd);
        
        // (로그인 성공했다고 가정)
        // 3. 세션에 회원 정보와 권한(auth) 저장
        HttpSession session = request.getSession();
        session.setAttribute("user_num", 1004); // 예시: 회원번호
        session.setAttribute("user_id", id);
        session.setAttribute("user_auth", 9);   // ★ 중요: DB에서 가져온 회원의 권한 등급
        
        /* * 4. 권한(auth)에 따른 페이지 분기 (Redirect)
         * 일반 회원은 쇼핑몰 메인으로, 관리자(auth==9)는 관리자 메인으로 이동시킵니다.
         */
        int user_auth = (Integer) session.getAttribute("user_auth");
        
        if (user_auth == 9) {
            // 관리자일 경우 -> 관리자 메인 컨트롤러로 리다이렉트
            // (주의: jsp로 바로 가지 않고 무조건 .do 컨트롤러를 거쳐야 합니다)
            return "redirect:/shop/admin/main.do"; 
        } else {
            // 일반 회원일 경우 -> 쇼핑몰 메인 컨트롤러로 리다이렉트
            return "redirect:/main/main.do";
        }
    }
}