package kr.shop.admin.action;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.controller.Action;
import kr.shop.dao.AdminStoreDAO;
import kr.shop.vo.UserStoreVO;

public class AdminStoreInsertAction implements Action{

	@Override
    public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
        
        //POST 방식으로 넘어올 때 한글 깨짐 방지
        request.setCharacterEncoding("utf-8");
        
        //폼에서 날아온 데이터 파라미터 낚아채기
        int brandNum = Integer.parseInt(request.getParameter("brandNum"));
        String storeName = request.getParameter("storeName");
        String storeAddr = request.getParameter("storeAddr");
        String storePhone = request.getParameter("storePhone");
        String openTime = request.getParameter("openTime");
        String storeUseYn = request.getParameter("storeUseYn");
        
        UserStoreVO vo = new UserStoreVO();
        vo.setBrandNum(brandNum);
        vo.setStoreName(storeName);
        vo.setStoreAddr(storeAddr);
        vo.setStorePhone(storePhone);
        vo.setOpenTime(openTime);
        vo.setStoreUseYn(storeUseYn);
        
        AdminStoreDAO dao = AdminStoreDAO.getInstance();
        dao.insertStore(vo);
        
        
        return "redirect:/shop/admin/adminStoreList.do";
    }


}
