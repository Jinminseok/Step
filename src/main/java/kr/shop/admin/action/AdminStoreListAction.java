package kr.shop.admin.action;

import java.util.List;
import java.util.Map;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.controller.Action;
import kr.shop.dao.AdminStoreDAO; // 🌟 관리자 매장 DAO 추가!
import kr.shop.dao.BrandDAO;
import kr.shop.vo.UserStoreVO;   // 🌟 매장 데이터 담는 VO 추가!

public class AdminStoreListAction implements Action {

    @Override
    public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
        
        //모달창 콤보박스용: 사용 중(Y)인 브랜드 목록 가져오기
        BrandDAO brandDao = BrandDAO.getInstance();
        List<Map<String, Object>> brandList = brandDao.getBrandList(null, "Y");
        request.setAttribute("brandList", brandList);
        
        //테이블 목록용: 관리자용 매장 전체 리스트 가져오기 
        AdminStoreDAO adminStoreDao = AdminStoreDAO.getInstance();
        List<UserStoreVO> adminStoreList = adminStoreDao.getAdminStoreList(); 
        request.setAttribute("adminStoreList", adminStoreList); 
        
        // 3. JSP 페이지로 포워딩
        return "/shop/admin/adminStoreList.jsp";
    }

}