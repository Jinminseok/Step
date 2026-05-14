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

        request.setCharacterEncoding("UTF-8");

        // 검색 파라미터 받기
        String keyword   = request.getParameter("keyword");
        String brandName = request.getParameter("brand");
        String status    = request.getParameter("status");

        Log_ProdDAO dao = new Log_ProdDAO();

        // 검색 조건 포함해서 조회
        List<Log_ProdVO> list = dao.getProdList(keyword, brandName, status);
        request.setAttribute("list",    list);
        request.setAttribute("count",   list.size());

        // 검색값 유지 (화면에 다시 표시용)
        request.setAttribute("keyword",   keyword   != null ? keyword   : "");
        request.setAttribute("brandSel",  brandName != null ? brandName : "");
        request.setAttribute("statusSel", status    != null ? status    : "");

        // 브랜드·카테고리 목록
        request.setAttribute("brandList", dao.getBrandList());
        request.setAttribute("catList",   dao.getCatList());

        return "logistics/log_prod/log_prodForm.jsp";
    }
}