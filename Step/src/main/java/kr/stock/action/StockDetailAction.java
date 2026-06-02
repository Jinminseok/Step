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
        
        //상품 번호 파라미터 받기
        int prodNum = Integer.parseInt(request.getParameter("prodNum"));
        
        //DAO 호출해서 옵션별 재고 리스트(List) 가져오기
        Log_StkDAO dao = Log_StkDAO.getInstance();
        List<Map<String, Object>> list = dao.getProductOptionStock(prodNum);
        
        Map<String, Object> map = new HashMap<>();
        map.put("list", list);
        
        return StringUtil.parseJSON(request, map);
    }
}
