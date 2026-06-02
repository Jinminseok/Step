package kr.stock.action;

import java.util.List;
import java.util.Map;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.controller.Action;
import kr.shop.dao.BrandDAO; // 브랜드 콤보박스용 DAO (이전에 쓰시던 거!)
import logis.dao.Log_StkDAO;


public class StockListAction implements Action {

    @Override
    public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
        
        //화면 상단 필터용: 브랜드 목록 가져오기 (매장 관리 때 썼던 거 재활용!)
        BrandDAO brandDao = BrandDAO.getInstance();
        List<Map<String, Object>> brandList = brandDao.getBrandList(null, "Y");
        request.setAttribute("brandList", brandList);
        
        //메인 데이터: 전체 재고 목록 가져오기
        Log_StkDAO stockDao = Log_StkDAO.getInstance();
        List<Map<String, Object>> stockList = stockDao.getStockList(null, null, null);
        request.setAttribute("stockList", stockList);
        
        //방금 만든 JSP 페이지로 포워딩
        return "/shop/stock/stockList.jsp";
    }

}