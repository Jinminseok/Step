package kr.shop.user.action;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import kr.controller.Action;
import kr.shop.dao.DeliveryDAO;
import kr.shop.vo.UserVO;

public class OrderCancelAction implements Action {

    @Override
    public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

        HttpSession session = request.getSession();
        UserVO user = (UserVO) session.getAttribute("loginUser");

        // 로그인 체크
        if (user == null) {
            return "redirect:/shop/user/loginForm.do";
        }

        int orderNum = Integer.parseInt(request.getParameter("orderNum"));
        int userNum  = (int) user.getUser_num();

        DeliveryDAO deliveryDAO = DeliveryDAO.getInstance();

        // orderNum으로 dlvNum 조회
        int dlvNum = deliveryDAO.getDlvNumByOrderNum(orderNum);

        if (dlvNum == 0) {
            return "redirect:/shop/user/myPage.do?msg=cancel_fail";
        }

        // 취소 처리 (재고복구 + 알림 포함)
        deliveryDAO.cancelOrder(dlvNum, orderNum, userNum);

        return "redirect:/shop/user/myPage.do?msg=cancel_ok";
    }
}