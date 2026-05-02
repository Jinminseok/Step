package kr.shop.admin.action;

import java.util.List;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import kr.controller.Action;
import kr.shop.dao.AdminDAO;
import kr.shop.vo.AdminVO;

public class AdminProductFormAction implements Action {
	@Override
	public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		// 1. 세션 및 관리자 권한 체크
		HttpSession session = request.getSession();
		Integer user_auth = (Integer) session.getAttribute("user_auth");

		// 관리자 등급(9)이 아니거나 세션이 만료된 경우[cite: 8]
		if (user_auth == null || user_auth != 9) {
			return "common/accessDeenied.jsp";
		}

		// 2. DAO 인스턴스 생성 및 데이터 로드 (C-4 요구사항)
		AdminDAO dao = AdminDAO.getInstance();

		try {
			// 카테고리 및 브랜드 목록 조회[cite: 8]
			List<AdminVO> categoryList = dao.getCategoryList();
			List<AdminVO> brandList = dao.getBrandList();

			// 데이터가 비어있을 경우에 대한 최소한의 방어 기제
			if (categoryList == null || brandList == null) {
				request.setAttribute("notice", "카테고리 또는 브랜드 설정이 필요합니다.");
			}

			// JSP에서 사용할 수 있도록 request에 바인딩
			request.setAttribute("categoryList", categoryList);
			request.setAttribute("brandList", brandList);

		} catch (Exception e) {
			// 데이터 로드 중 오류 발생 시 로깅 및 에러 페이지 처리
			e.printStackTrace();
			return "common/error.jsp";
		}

		// 3. 상품 등록 폼 뷰 경로 반환
		return "shop/admin/productForm.jsp";
	}
}