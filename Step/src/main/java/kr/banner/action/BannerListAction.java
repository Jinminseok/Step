package kr.banner.action;

import java.util.List;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.controller.Action;
import kr.shop.dao.BannerDAO;
import kr.shop.vo.BannerVO;

public class BannerListAction implements Action{

	@Override
	public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

		BannerDAO dao = BannerDAO.getInstance();
		List<BannerVO> list = dao.getAdminBannerList();
		
		request.setAttribute("bannerList", list);
		
		return "shop/banner/bannerList.jsp";
	}

}
