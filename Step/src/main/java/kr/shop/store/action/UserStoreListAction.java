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
    
        // 1. DAO를 불러서 DB에 있는 매장 리스트를 싹 다 가져옵니다.
        UserStoreDAO dao = UserStoreDAO.getInstance();
        List<UserStoreVO> storeList = dao.getStoreList();
        
        // 2. 브랜드 리스트 가져오기 
        BrandDAO branddao = BrandDAO.getInstance();
        // 검색어(keyword)는 없으니 null, 사용자 화면이므로 사용중인('Y') 브랜드만 가져오게 세팅!
        List<Map<String, Object>> brandList = branddao.getBrandList(null, "Y");
        
        // 🚨 3. JSP에서 쓸 수 있도록 request에 담아줍니다.
        request.setAttribute("storeList", storeList);
        request.setAttribute("brandList", brandList); // 주석 해제 및 담기 완료!
        
        // 4. 매장 찾기 JSP 페이지로 포워딩
        return "shop/userstore/userStoreList.jsp"; 
    }

}
