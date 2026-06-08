package kr.shop.admin.action;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.controller.Action;
import kr.shop.dao.AdminStoreDAO;
import kr.shop.vo.UserStoreVO;

public class AdminStoreUpdateAction implements Action {
	@Override
    public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
        request.setCharacterEncoding("utf-8"); // 한글 깨짐 방지
        
        UserStoreVO vo = new UserStoreVO();
        //수정할 때는 반드시 Primary Key(매장 번호)를 받아와야 합니다!
        vo.setStoreNum(Integer.parseInt(request.getParameter("storeNum"))); 
        vo.setBrandNum(Integer.parseInt(request.getParameter("brandNum")));
        vo.setStoreName(request.getParameter("storeName"));
        vo.setStoreAddr(request.getParameter("storeAddr"));
        vo.setStorePhone(request.getParameter("storePhone"));
        vo.setOpenTime(request.getParameter("openTime"));
        vo.setStoreUseYn(request.getParameter("storeUseYn"));
        
        AdminStoreDAO.getInstance().updateStore(vo);
        
        return "redirect:/shop/admin/adminStoreList.do";
    }
}
