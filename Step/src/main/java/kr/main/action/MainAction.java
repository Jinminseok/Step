package kr.main.action;

import java.util.List;
import java.util.Map;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import kr.controller.Action;
import kr.shop.dao.UserProductDAO;
import kr.shop.vo.AdminProductVO;

import kr.shop.dao.BannerDAO;
import kr.shop.dao.BrandDAO;
import kr.shop.dao.CategoryDAO;
import kr.shop.vo.BannerVO;

public class MainAction implements Action {

	@Override
	public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

		UserProductDAO dao = UserProductDAO.getInstance();

		// 메인 화면 슬라이드 배너 가져오기
		BannerDAO bannerDao = BannerDAO.getInstance();
		List<BannerVO> mainBannerList = bannerDao.getMainBanners();
		request.setAttribute("mainBannerList", mainBannerList);

		// 사용자가 누른 페이지 번호 받기
		String pageNumStr = request.getParameter("pageNum");
		int pageNum = 1;
		if (pageNumStr != null && !pageNumStr.equals("")) {
			pageNum = Integer.parseInt(pageNumStr);
		}

		AdminProductVO filter = new AdminProductVO();
		filter.setGender(-1); // 기본값 세팅
		
		// 피라미터 받기
		String cat_num_param = request.getParameter("cat_num");
		if (cat_num_param != null) {
		    filter.setCat_num(Integer.parseInt(cat_num_param));
		}
		
		String brand_num_param = request.getParameter("brand_num");
		if (brand_num_param != null) {
		    filter.setBrand_num(Integer.parseInt(brand_num_param));
		}
		
		String gender_param = request.getParameter("gender");
		if (gender_param != null) {
			filter.setGender(Integer.parseInt(gender_param));
		}
		
		String keyword = request.getParameter("keyword");
		if (keyword != null && !keyword.trim().isEmpty()) {
		    filter.setKeyword(keyword.trim());
		}
		
		String sort = request.getParameter("sort");
		if (sort == null || sort.isEmpty()) {
			sort = "recommend";
		}
		
		// 전체 상품 개수
		int count = dao.getMainProductCount(filter); 

		// 페이징 계산을 위한 변수 세팅
		int pageSize = 12;
		int pageBlock = 5;

		// 시작 번호와 끝 번호 계산
		int startRow = (pageNum - 1) * pageSize + 1;
		int endRow = pageNum * pageSize;

		filter.setStart_row(startRow);
		filter.setEnd_row(endRow);

		// 계산된 번호로 상품 목록 받아오기
		List<AdminProductVO> productList = null;
		if (count > 0) {
			productList = dao.getMainProductList(filter, sort);
		}

		// 하단 버튼 생성을 위한 페이지 연산
		int totalPage = (int) Math.ceil((double) count / pageSize);
		int startPage = ((pageNum - 1) / pageBlock) * pageBlock + 1;
		int endPage = startPage + pageBlock - 1;
		if (endPage > totalPage) endPage = totalPage;
		
		// DB에서 사용 중인 카테고리 목록 가져오기
		CategoryDAO catDao = CategoryDAO.getInstance();
		BrandDAO brandDao = BrandDAO.getInstance();
		
		// 사용 중인 카테고리, 브랜드 가져오기
		List<Map<String, Object>> categoryList = catDao.getCategoryList(null, "Y");
		List<Map<String, Object>> brandList = brandDao.getBrandList(null, "Y");

		// request 속성 세팅
		request.setAttribute("productList", productList);
		request.setAttribute("count", count);
		request.setAttribute("currentPage", pageNum);
		request.setAttribute("totalPage", totalPage);
		request.setAttribute("startPage", startPage);
		request.setAttribute("endPage", endPage);
		request.setAttribute("categoryList", categoryList); 
		request.setAttribute("brandList", brandList);

		// 화면에서 라디오 버튼 체크 유지를 위해 선택된 번호를 넘김
		request.setAttribute("selected_cat", filter.getCat_num());
		request.setAttribute("selected_brand", filter.getBrand_num());
		request.setAttribute("selected_gender", filter.getGender());

		return "shop/user/main.jsp";
	}
}