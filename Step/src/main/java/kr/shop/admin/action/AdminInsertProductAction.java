package kr.shop.admin.action;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import kr.controller.Action;
import kr.shop.dao.AdminDAO;
import kr.shop.vo.AdminVO;
import kr.util.FileUtil;

public class AdminInsertProductAction implements Action {

	@Override
	public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		HttpSession session = request.getSession();
		Integer user_auth = (Integer) session.getAttribute("user_auth");

		// 관리자 권한 확인
		if (user_auth == null || user_auth != 9) {
			return "common/accessDenied.jsp";
		}

		request.setCharacterEncoding("utf-8");

		// 1. 파일 업로드 실행 (webapp/upload 경로에 저장됨)
		String filename = FileUtil.uploadFile(request, "upload_img");

		// 2. AdminVO 세팅
		AdminVO vo = new AdminVO();

		// (1) 상품 기본 정보
		vo.setProd_name(request.getParameter("prod_name"));
		vo.setCat_num(Integer.parseInt(request.getParameter("cat_num")));
		vo.setBrand_num(Integer.parseInt(request.getParameter("brand_num")));
		vo.setSku(request.getParameter("sku"));
		vo.setGender(Integer.parseInt(request.getParameter("gender")));
		vo.setProd_price(Integer.parseInt(request.getParameter("prod_price")));
		vo.setSale_rate(Integer.parseInt(request.getParameter("sale_rate")));
		vo.setProd_text(request.getParameter("prod_text"));

		// (2) 상품 옵션 정보
		vo.setSize_val(Integer.parseInt(request.getParameter("size_val")));
		vo.setColor(request.getParameter("color"));
		vo.setAdd_price(Integer.parseInt(request.getParameter("add_price")));

		// (3) 이미지 파일명 세팅
		if (filename != null && !filename.isEmpty()) {
			vo.setProd_img_url(filename);
		}

		// 3. 싱글톤 인스턴스를 사용하여 DB 저장 실행
		// AdminDAO dao = new AdminDAO(); 대신 아래 방식을 사용함
		AdminDAO dao = AdminDAO.getInstance();
		boolean isSuccess = dao.insertProduct(vo);

		if (isSuccess) {
			// 등록 성공 시 목록으로 리다이렉트
			return "redirect:/shop/admin/productList.do";
		} else {
			// DB 저장 실패 시 업로드된 실제 파일 삭제
			if (filename != null) {
				FileUtil.removeFile(request, filename);
			}
			return "common/accessDeenied.jsp";
		}
	}
}