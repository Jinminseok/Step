package kr.stock.action;

import java.io.PrintWriter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.controller.Action;
import kr.util.StringUtil;
import logis.dao.Log_StkDAO;
import oracle.sql.json.OracleJsonArray;

public class StockDetailAction implements Action{

	@Override
    public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
        
        // 1. 상품 번호 파라미터 받기
        int prodNum = Integer.parseInt(request.getParameter("prodNum"));
        
        // 2. DAO 호출해서 옵션별 재고 리스트(List) 가져오기
        Log_StkDAO dao = Log_StkDAO.getInstance();
        List<Map<String, Object>> list = dao.getProductOptionStock(prodNum);
        
        // 3. 🌟 StringUtil.parseJSON이 Map을 요구하므로, Map에 "list"라는 이름으로 담기
        Map<String, Object> map = new HashMap<>();
        map.put("list", list);
        
        // 4. JSON 변환 및 ajax_view.jsp로 포워딩!
        return StringUtil.parseJSON(request, map);
    }
}
