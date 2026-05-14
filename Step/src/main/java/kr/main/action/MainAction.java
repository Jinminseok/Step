package kr.main.action;

import java.util.List;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import kr.controller.Action;
import kr.shop.dao.UserProductDAO;
import kr.shop.vo.AdminProductVO;

public class MainAction implements Action {

	@Override
	public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

		UserProductDAO dao = UserProductDAO.getInstance();

		// 사용자가 누른 페이지 번호 받기
		String pageNumStr = request.getParameter("pageNum");
		int pageNum = 1;
		if (pageNumStr != null && !pageNumStr.equals("")) {
			pageNum = Integer.parseInt(pageNumStr);
		}

		AdminProductVO filter = new AdminProductVO();
		filter.setGender(-1);
		
		// 헤더의 카테고리 번호 받기
		String cat_num_param = request.getParameter("cat_num");
		if (cat_num_param != null && !cat_num_param.isEmpty()) {
			filter.setCat_num(Integer.parseInt(cat_num_param));
		}
		
		// 카테고리의 탭 활성화
		request.setAttribute("cat_num", filter.getCat_num());

		// 전체 상품 개수를
		int count = dao.getMainProductCount(filter); 

		// 페이징 계산을 위한 변수 세팅
		int pageSize = 10;
		int pageBlock = 5;

		// 시작 번호와 끝 번호 계산
		int startRow = (pageNum - 1) * pageSize + 1;
		int endRow = pageNum * pageSize;

		filter.setStart_row(startRow);
		filter.setEnd_row(endRow);

		// 계산된 번호로 상품 목록 받아오기
		List<AdminProductVO> productList = null;
		if (count > 0) {
			productList = dao.getMainProductList(filter);
		}

		// 하단 버튼 생성을 위한 페이지 연산
		int totalPage = (int) Math.ceil((double) count / pageSize);
		int startPage = ((pageNum - 1) / pageBlock) * pageBlock + 1;
		int endPage = startPage + pageBlock - 1;
		if (endPage > totalPage) endPage = totalPage;

		request.setAttribute("productList", productList);
		request.setAttribute("count", count);             // 총 상품 수
		request.setAttribute("currentPage", pageNum);     // 현재 페이지
		request.setAttribute("totalPage", totalPage);     // 전체 페이지
		request.setAttribute("startPage", startPage);     // 시작 페이지 번호
		request.setAttribute("endPage", endPage);         // 끝 페이지 번호

		return "shop/user/main.jsp";
	}
}