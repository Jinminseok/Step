package kr.shop.admin.action;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import kr.controller.Action;
import kr.shop.dao.AdminDAO;
import kr.shop.vo.AdminProductVO;
import kr.util.FileUtil;

public class AdminProductWriteAction implements Action {
	@Override
	public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

		// 1. 관리자 권한 체크
		HttpSession session = request.getSession();
		Object authObj = session.getAttribute("user_auth");
		if (authObj == null || !authObj.toString().equals("9")) {
			return "common/accessDeenied.jsp";
		}

		// 2. GET 방식 처리: 등록 폼으로 이동
		if (request.getMethod().equalsIgnoreCase("GET")) {
			return "shop/admin/productForm.jsp"; 
		}

		// 3. POST 방식 처리: 실제 데이터 저장
		request.setCharacterEncoding("utf-8");

		// 파일 업로드 처리
		String fileName = FileUtil.uploadFile(request, "upload_img");

		// VO 객체 생성 및 데이터 세팅
		AdminProductVO product = new AdminProductVO();

		// [중요] 이름으로 파라미터를 받음 (DB 자동 생성을 위함)
		String catName = request.getParameter("cat_name");
		String brandName = request.getParameter("brand_name");

		// 숫자형 데이터 파싱 및 세팅
		product.setPrice(Integer.parseInt(request.getParameter("prod_price")));
		product.setStatus(Integer.parseInt(request.getParameter("prod_status")));
		product.setGender(Integer.parseInt(request.getParameter("gender")));

		String saleRateParam = request.getParameter("sale_rate");
		product.setSale_rate((saleRateParam != null && !saleRateParam.isEmpty()) ? Integer.parseInt(saleRateParam) : 0);

		// 문자열 데이터 세팅
		product.setSku(request.getParameter("sku"));
		product.setName(request.getParameter("prod_name"));
		product.setProd_text(request.getParameter("prod_text"));

		// 기존 테이블 구조 유지 (IMG_NUM, OPT_NUM 기본값 세팅)
		product.setImg_num(0);
		product.setOpt_num(0);

		// 4. DAO 호출: 상품 정보와 함께 카테고리/브랜드 이름을 보냄
		AdminDAO dao = AdminDAO.getInstance();
		int check = dao.insertProduct(product, catName, brandName);

		// 5. 결과에 따른 페이지 이동
		if (check > 0) {
			return "redirect:/shop/admin/productForm.do";
		} else {
			return "shop/admin/productForm.jsp";
		}
	}
}