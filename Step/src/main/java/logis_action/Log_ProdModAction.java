package logis_action;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.controller.Action;

public class Log_ProdModAction implements Action {

    @Override
    public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

        // TODO: 수정 기능 구현 예정
        response.sendRedirect(request.getContextPath()
            + "/logistics/log_prod/log_prodForm.do");
        return null;
    }
}