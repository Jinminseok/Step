package kr.shop.admin.action;

import java.util.List;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import kr.controller.Action;
import kr.shop.dao.AdminProductDAO;
import kr.shop.vo.AdminProductVO;
import kr.util.PagingUtil;

public class AdminProductListAction implements Action {

	@Override
	public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		HttpSession session = request.getSession();
		Object user_auth_obj = session.getAttribute("user_auth");

		if (user_auth_obj == null || ((Number) user_auth_obj).intValue() != 9) {
			return "redirect:/shop/user/loginForm.do";
		}

		String pageNum = request.getParameter("pageNum");
		if (pageNum == null)
			pageNum = "1";

		String search_status = request.getParameter("search_status");

		// 🚨 카테고리 및 브랜드 파라미터 수집
		String cat_num_param = request.getParameter("cat_num");
		String brand_num_param = request.getParameter("brand_num");

		int cat_num = 0;
		if (cat_num_param != null && !cat_num_param.isEmpty()) {
			cat_num = Integer.parseInt(cat_num_param);
		}

		int brand_num = 0;
		if (brand_num_param != null && !brand_num_param.isEmpty()) {
			brand_num = Integer.parseInt(brand_num_param);
		}

		AdminProductVO vo = new AdminProductVO();
		vo.setSearch_status(search_status);
		vo.setCat_num(cat_num); // 🚨 VO 세팅
		vo.setBrand_num(brand_num); // 🚨 VO 세팅

		AdminProductDAO dao = AdminProductDAO.getInstance();

		// 카운트 및 리스트 호출
		int count = dao.getProductTotalCount(vo);

		// 🚨 페이징 처리 시 카테고리와 브랜드 검색 필터 쿼리 스트링 유지를 위한 누적 작업
		StringBuilder addKey = new StringBuilder();
		if (search_status != null && !search_status.isEmpty()) {
			addKey.append("&search_status=").append(search_status);
		}
		if (cat_num > 0) {
			addKey.append("&cat_num=").append(cat_num);
		}
		if (brand_num > 0) {
			addKey.append("&brand_num=").append(brand_num);
		}

		PagingUtil page = new PagingUtil(null, null, Integer.parseInt(pageNum), count, 10, 10, "productList.do",
				addKey.toString());

		List<AdminProductVO> list = null;
		if (count > 0) {
			vo.setStart_row(page.getStartRow());
			vo.setEnd_row(page.getEndRow());
			list = dao.getProductList(vo);
		}

		// 🚨 필터링 셀렉트 박스 구성을 위한 데이터 로드 후 바인딩
		List<AdminProductVO> categoryList = dao.getCategoryList();
		List<AdminProductVO> brandList = dao.getBrandList();

		request.setAttribute("count", count);
		request.setAttribute("list", list);
		request.setAttribute("page", page.getPage());
		request.setAttribute("app_title", "상품 관리");

		// 🚨 JSP에 필요한 속성 등록
		request.setAttribute("categoryList", categoryList);
		request.setAttribute("brandList", brandList);
		request.setAttribute("cat_num", cat_num);
		request.setAttribute("brand_num", brand_num);

		return "shop/admin/adminProductList.jsp";
	}
}