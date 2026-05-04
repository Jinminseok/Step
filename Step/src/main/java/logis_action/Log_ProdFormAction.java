package logis_action;

import java.util.List;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.controller.Action;
import logis.dao.Log_ProdDAO;
import logis_vo.Log_ProdVO;

public class Log_ProdFormAction implements Action {

    @Override
    public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

        Log_ProdDAO dao = new Log_ProdDAO();
        List<Log_ProdVO> list = dao.getProdList();
        
        //상품 목록
        request.setAttribute("list",  list);
        request.setAttribute("count", list.size());

        //브랜드 카테고리 목록
        request.setAttribute("brandList", dao.getBrandList());
        request.setAttribute("catList",   dao.getCatList());
        
        return "logistics/log_prod/log_prodForm.jsp";
    }
}