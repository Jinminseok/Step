package kr.shop.admin.action;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.controller.Action;

public class AdminProductInsertFormAction implements Action {

	@Override
	public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		// (추가 작업) 카테고리/브랜드 목록을 DB에서 불러와 request에 담아주는 로직

		return "/admin/product/adminProductInsert.jsp";
	}
}