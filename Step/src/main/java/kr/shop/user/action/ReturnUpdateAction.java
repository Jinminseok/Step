package kr.shop.user.action;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import kr.controller.Action;
import kr.shop.dao.UserReturnDAO;

import kr.shop.vo.UserReturnVO;

public class ReturnUpdateAction implements Action {

	@Override
	public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		// 1. 로그인 세션 체크
		HttpSession session = request.getSession();
		Number sessionUserNum = (Number) session.getAttribute("user_num");
		if (sessionUserNum == null) {
		    return "redirect:/shop/user/loginForm.do";
		}
		int user_num = sessionUserNum.intValue();
		
		// 2. 파라미터 인코딩
		request.setCharacterEncoding("utf-8");
		
		// 3. 파라미터 수집
		int ret_num = Integer.parseInt(request.getParameter("ret_num"));
		int tp = Integer.parseInt(request.getParameter("tp"));
		String reason = request.getParameter("reason");
		String ret_note = request.getParameter("ret_note");
		
		// 4. VO에 데이터 세팅
		UserReturnVO returnVO = new UserReturnVO();
		returnVO.setRet_num(ret_num);
		returnVO.setTp(tp);
		returnVO.setReason(reason);
		returnVO.setRet_note(ret_note);		
		returnVO.setUser_num(user_num);
		
		// 5. DAO 호출 (수정 로직)
		UserReturnDAO dao = UserReturnDAO.getInstance();
		
		// 보안 권장: 타인이 수정할 수 없도록 수정 시 user_num도 함께 넘기거나,
		// 업데이트 쿼리 조건(WHERE ret_num=? AND user_num=?)에 포함하는 것이 좋습니다.
		dao.updateReturnRequest(returnVO);
		
		// 6. 처리 완료 후 마이페이지로 리다이렉트
		return "redirect:/shop/user/myPageForm.do";
	}
}