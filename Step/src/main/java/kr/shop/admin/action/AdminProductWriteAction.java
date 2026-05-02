package kr.shop.admin.action;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import kr.controller.Action;
import kr.shop.dao.AdminDAO;
import kr.shop.vo.AdminVO;
import kr.util.FileUtil;

public class AdminProductWriteAction implements Action {
	@Override
	public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

		// 1. 관리자 권한 체크 (USERS 테이블 AUTH: 9 확인)[cite: 8]
		HttpSession session = request.getSession();
		Integer user_auth = (Integer) session.getAttribute("user_auth");

		if (user_auth == null || user_auth != 9) {
			return "common/accessDenied.jsp";
		}

		// 2. 전송 방식 체크 (POST 방식만 허용)
		if (!request.getMethod().equalsIgnoreCase("POST")) {
			return "redirect:/shop/admin/productForm.do";
		}

		// 3. 데이터 저장 처리
		request.setCharacterEncoding("utf-8");

		// 파일 업로드 처리 (PROD_IMGS 테이블 관련)[cite: 8]
		String fileName = FileUtil.uploadFile(request, "upload_img");

		AdminVO product = new AdminVO();

		try {
			// Foreign Key 및 숫자형 데이터 파싱[cite: 8]
			product.setCat_num(Integer.parseInt(request.getParameter("cat_num")));
			product.setBrand_num(Integer.parseInt(request.getParameter("brand_num")));
			product.setProd_price(Integer.parseInt(request.getParameter("prod_price")));
			product.setProd_status(Integer.parseInt(request.getParameter("prod_status")));
			product.setGender(Integer.parseInt(request.getParameter("gender")));

			String saleRateParam = request.getParameter("sale_rate");
			product.setSale_rate(
					(saleRateParam != null && !saleRateParam.isEmpty()) ? Integer.parseInt(saleRateParam) : 1);

		} catch (NumberFormatException e) {
			// 파싱 에러 발생 시 업로드된 파일 즉시 삭제[cite: 7]
			if (fileName != null)
				FileUtil.removeFile(request, fileName);
			request.setAttribute("error_msg", "입력 형식이 올바르지 않습니다.");
			return "shop/admin/productForm.jsp";
		}

		// 상품 상세 정보 세팅[cite: 8]
		product.setSku(request.getParameter("sku"));
		product.setProd_name(request.getParameter("prod_name"));
		product.setProd_text(request.getParameter("prod_text"));
		product.setProd_img_url(fileName);

		// 4. DAO 호출 (C-4 요구사항: 단일 트랜잭션 실행)[cite: 7]
		AdminDAO dao = AdminDAO.getInstance();
		int check = dao.insertProduct(product);

		// 5. 결과 처리
		if (check > 0) {
			// 성공 시 목록으로 리다이렉트
			return "redirect:/shop/admin/productList.do";
		} else {
			// 실패 시 서버 자원 정리 및 안내
			if (fileName != null)
				FileUtil.removeFile(request, fileName);
			request.setAttribute("error_msg", "상품 등록에 실패했습니다.");
			return "shop/admin/productForm.jsp";
		}
	}
}