package kr.shop.admin.action;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.controller.Action;
import kr.shop.dao.AdminStoreDAO;

public class AdminStoreDeleteAction implements Action{

	@Override
    public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
        
        // 넘어온 매장 번호(PK)만 쏙 빼서 삭제 쿼리에 던집니다.
        int storeNum = Integer.parseInt(request.getParameter("storeNum"));
        AdminStoreDAO.getInstance().deleteStore(storeNum);
        
        return "redirect:/shop/admin/adminStoreList.do";
    }

}
