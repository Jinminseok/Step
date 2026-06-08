package kr.banner.action;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.controller.Action;
import kr.shop.dao.BannerDAO;

public class BannerDeleteAction implements Action{
	@Override
	public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

		int banner_num = Integer.parseInt(request.getParameter("banner_num"));
        
        BannerDAO.getInstance().deleteBanner(banner_num);

        return "redirect:/shop/banner/bannerList.do";
	}
}
