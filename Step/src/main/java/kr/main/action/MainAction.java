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

		// 1. 사용자가 누른 페이지 번호 받기 (처음 들어오면 기본값 1)
		String pageNumStr = request.getParameter("pageNum");
		int pageNum = 1;
		if (pageNumStr != null && !pageNumStr.equals("")) {
			pageNum = Integer.parseInt(pageNumStr);
		}

		AdminProductVO filter = new AdminProductVO();
		filter.setGender(-1); // 기본 필터 설정

		// 🌟 [매우 중요] 전체 상품 개수를 알아야 전체 페이지 수를 계산할 수 있습니다!
		// (만약 DAO에 이 메서드가 없다면, SELECT COUNT(*) 로 개수를 구하는 메서드를 만드셔야 합니다!)
		int count = dao.getMainProductCount(filter); 

		// 2. 페이징 계산을 위한 변수 세팅
		int pageSize = 10; // 한 페이지에 보여줄 상품 개수 (그리드 모양에 따라 8, 12개로 하셔도 좋습니다)
		int pageBlock = 5; // 하단에 보여줄 페이지 번호 개수 (1 2 3 4 5)

		// 3. 시작 번호와 끝 번호 계산 (공식입니다!)
		int startRow = (pageNum - 1) * pageSize + 1;
		int endRow = pageNum * pageSize;

		filter.setStart_row(startRow);
		filter.setEnd_row(endRow);

		// 4. 계산된 번호로 상품 목록 받아오기
		List<AdminProductVO> productList = null;
		if (count > 0) {
			productList = dao.getMainProductList(filter);
		}

		// 5. 하단 [1][2][3] 버튼 생성을 위한 페이지 연산
		int totalPage = (int) Math.ceil((double) count / pageSize);
		int startPage = ((pageNum - 1) / pageBlock) * pageBlock + 1;
		int endPage = startPage + pageBlock - 1;
		if (endPage > totalPage) endPage = totalPage; // 끝 페이지 보정

		// 6. JSP에서 쓸 수 있도록 request에 몽땅 담아주기
		request.setAttribute("productList", productList);
		request.setAttribute("count", count);             // 총 상품 수
		request.setAttribute("currentPage", pageNum);     // 현재 페이지
		request.setAttribute("totalPage", totalPage);     // 전체 페이지
		request.setAttribute("startPage", startPage);     // 시작 페이지 번호
		request.setAttribute("endPage", endPage);         // 끝 페이지 번호

		return "shop/user/main.jsp";
	}
}