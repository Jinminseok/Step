package kr.shop.admin.action;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import kr.controller.Action;
import kr.shop.dao.AdminProductDAO;
import kr.shop.vo.AdminProductVO;

public class AdminProductInsertAction implements Action {

	@Override
	public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

		request.setCharacterEncoding("utf-8");

		// ※ 파일 업로드(이미지)가 추가되면 MultipartRequest(cos.jar 등) 처리로 변경해야 함.
		// 현재는 DAO 쿼리에 맞춰 텍스트 데이터만 받는 구조임.
		AdminProductVO vo = new AdminProductVO();
		vo.setSku(request.getParameter("sku"));
		vo.setProd_name(request.getParameter("prod_name"));
		vo.setGender(Integer.parseInt(request.getParameter("gender")));
		vo.setBrand_num(Integer.parseInt(request.getParameter("brand_num")));
		vo.setCat_num(Integer.parseInt(request.getParameter("cat_num")));
		vo.setProd_price(Integer.parseInt(request.getParameter("prod_price")));

		// sale_rate가 비어있을 경우 예외 처리
		String saleRateStr = request.getParameter("sale_rate");
		vo.setSale_rate((saleRateStr != null && !saleRateStr.isEmpty()) ? Integer.parseInt(saleRateStr) : 0);

		vo.setProd_status(Integer.parseInt(request.getParameter("prod_status")));
		vo.setProd_text(request.getParameter("prod_text"));

		AdminProductDAO dao = AdminProductDAO.getInstance();
		dao.insertProduct(vo);

		// 등록 성공 시 목록으로 리다이렉트 (설정된 매핑 주소 사용)
		return "redirect:/admin/adminProductList.do";
	}
}