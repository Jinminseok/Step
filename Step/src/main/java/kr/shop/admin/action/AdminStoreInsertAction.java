package kr.shop.admin.action;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.controller.Action;
import kr.shop.dao.AdminStoreDAO;
import kr.shop.vo.UserStoreVO;

public class AdminStoreInsertAction implements Action{

	@Override
    public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
        
        // 🌟 1. POST 방식으로 넘어올 때 한글 깨짐 방지
        request.setCharacterEncoding("utf-8");
        
        // 2. 폼에서 날아온 데이터 파라미터 낚아채기
        // (폼의 input 태그 name 속성과 정확히 일치해야 합니다)
        int brandNum = Integer.parseInt(request.getParameter("brandNum"));
        String storeName = request.getParameter("storeName");
        String storeAddr = request.getParameter("storeAddr");
        String storePhone = request.getParameter("storePhone");
        String openTime = request.getParameter("openTime");
        String storeUseYn = request.getParameter("storeUseYn");
        
        // 3. VO 객체를 만들어서 예쁘게 담아줍니다.
        UserStoreVO vo = new UserStoreVO();
        vo.setBrandNum(brandNum);
        vo.setStoreName(storeName);
        vo.setStoreAddr(storeAddr);
        vo.setStorePhone(storePhone);
        vo.setOpenTime(openTime);
        vo.setStoreUseYn(storeUseYn);
        
        // 4. 관리자용 DAO를 불러서 DB에 INSERT
        AdminStoreDAO dao = AdminStoreDAO.getInstance();
        dao.insertStore(vo);
        
        // 🌟 5. 처리 완료 후 매장 목록 페이지로 강제 이동 (리다이렉트)
        // FrontController(DispatcherServlet) 규칙에 맞게, 목록 Action(.do) 경로로 리다이렉트
        
        return "redirect:/shop/admin/adminStoreList.do";
    }


}
