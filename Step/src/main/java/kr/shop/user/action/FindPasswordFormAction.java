package kr.shop.user.action;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.controller.Action;

public class FindPasswordFormAction implements Action {
    @Override
    public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
        // 비밀번호 찾기 폼 화면으로 이동
        return "shop/user/findPasswordForm.jsp";
    }
}