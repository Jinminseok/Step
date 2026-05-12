package kr.shop.store.action;

import java.util.List;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.controller.Action;
import kr.shop.dao.UserStoreDAO;
import kr.shop.vo.UserStoreVO;

public class StoreListAction implements Action{

	@Override
	public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
	
	        
	        // 1. DAO를 불러서 DB에 있는 매장 리스트를 싹 다 가져옵니다.
	        UserStoreDAO dao = UserStoreDAO.getInstance();
	        List<UserStoreVO> storeList = dao.getStoreList();
	        
//			브랜드 DAO 완성 시 추가. (메서드 이름 등 확인하고 추가 해야 함.)	        
//	        BrandDAO brandDao = BrandDAO.getInstance();
//	        List<BrandVO> brandList = brandDao.getBrandList(); 
//	        request.setAttribute("brandList", brandList);
	        
	        // 🚨 2. 제일 중요한 부분! JSP에서 쓸 수 있도록 request에 담아줍니다.
	        // JSP 파일의 <c:forEach items="${storeList}"> 부분과 이름이 똑같아야 합니다!
	        request.setAttribute("storeList", storeList);
	        
	        // 3. 매장 찾기 JSP 페이지로 포워딩
	        return "/shop/store/storeList.jsp"; 
	    
	}

}
