package logis_action;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.controller.Action;
import logis.dao.Log_ProdDAO;

public class Log_ProdDelAction implements Action {

    @Override
    public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

        request.setCharacterEncoding("UTF-8");

        String prodNumStr = request.getParameter("prodNum");
        int prodNum = (prodNumStr != null && !prodNumStr.isEmpty())
                      ? Integer.parseInt(prodNumStr) : 0;

        if (prodNum > 0) {
            Log_ProdDAO dao = new Log_ProdDAO();
            int result = dao.deleteProd(prodNum);
            
            // 🚨 FK 무결성 제약조건 위배로 삭제 실패 시
            if (result == -1) {
                return "redirect:/logistics/log_prod/log_prodForm.do?result=fk_error";
            }
        }

        // ✅ 정상 삭제 시
        return "redirect:/logistics/log_prod/log_prodForm.do?result=deleted";
    }
}