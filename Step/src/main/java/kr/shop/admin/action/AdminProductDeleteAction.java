package kr.shop.admin.action;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import kr.controller.Action;
import kr.shop.dao.AdminDAO;

public class AdminProductDeleteAction implements Action {

	@Override
	public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

		// 1. 관리자 권한 체크 (설계서 기준 USERS.AUTH = 9)
		HttpSession session = request.getSession();
		Integer user_auth = (Integer) session.getAttribute("user_auth");

		if (user_auth == null || user_auth != 9) {
			// 관리자가 아닐 경우 접근 제한 페이지로 이동 (파일 구조 참고)
			return "common/accessDeenied.jsp";
		}

		// 2. 삭제할 상품 번호 파라미터 받기 (PRODUCTS.PROD_NUM)[cite: 5]
		int prod_num = Integer.parseInt(request.getParameter("prod_num"));

		// 3. DAO 호출하여 물리적 삭제 수행 (이미지, 옵션 테이블 트랜잭션 처리됨)
		AdminDAO dao = new AdminDAO();
		boolean isSuccess = dao.deleteProductPhysical(prod_num);

		if (isSuccess) {
			// 삭제 성공 시 상품 리스트로 이동 (리다이렉트)
			// 파일 구조상 관리자 리스트 주소는 /admin/productList.do로 가정
			return "redirect:/admin/productList.do";
		} else {
			// 삭제 실패 시 공통 알림 뷰로 이동 (파일 구조의 alert_view.jsp 활용)
			request.setAttribute("notice_msg", "상품 삭제 중 오류가 발생했습니다.");
			request.setAttribute("notice_url", request.getContextPath() + "/admin/productList.do");

			return "common/alert_view.jsp";
		}
	}
}