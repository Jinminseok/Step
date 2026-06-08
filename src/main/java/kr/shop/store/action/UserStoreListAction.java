package kr.shop.store.action;

import java.util.List;
import java.util.Map;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.controller.Action;
import kr.shop.dao.BrandDAO;
import kr.shop.dao.UserStoreDAO;
import kr.shop.vo.UserStoreVO;

public class UserStoreListAction implements Action{

	@Override
    public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
    
    
        UserStoreDAO dao = UserStoreDAO.getInstance();
        List<UserStoreVO> storeList = dao.getStoreList();
        
      
        BrandDAO branddao = BrandDAO.getInstance();
      
        List<Map<String, Object>> brandList = branddao.getBrandList(null, "Y");
        
       
        request.setAttribute("storeList", storeList);
        request.setAttribute("brandList", brandList); 
        
       
        return "shop/userstore/userStoreList.jsp"; 
    }

}
