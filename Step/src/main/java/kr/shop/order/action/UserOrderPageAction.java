package kr.shop.order.action;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import kr.controller.Action;
import kr.shop.dao.UserDAO; 
import kr.shop.vo.UserVO;   

public class UserOrderPageAction implements Action {

    @Override
    public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
        
        // 로그인 확인
        HttpSession session = request.getSession();
        Long user_num = (Long) session.getAttribute("user_num");
        if(user_num == null) {
            return "redirect:/shop/user/loginForm.do";
        }
        
        // 장바구니 번호 받기
        String[] cartNums = request.getParameterValues("cart_num");
        if (cartNums == null || cartNums.length == 0) {
            request.setAttribute("notice_msg", "잘못된 접근입니다.");
            request.setAttribute("notice_url", request.getContextPath() + "/shop/cart/cartList.do");
            return "common/alert_view.jsp";
        }

        // 회원의 전체 정보 가져오기
        UserDAO userDao = UserDAO.getInstance();
        UserVO user = userDao.getUserDetail(user_num); 
        request.setAttribute("user", user);
        
        // 선택한 장바구니 상품 목록 가져오기
        kr.shop.dao.UserCartDAO cartDao = kr.shop.dao.UserCartDAO.getInstance();
        java.util.List<kr.shop.vo.UserCartVO> orderItemList = cartDao.getOrderCartList(cartNums);
        
        // 총 상품 금액 계산하기
        int totalProductPrice = 0;
        for(kr.shop.vo.UserCartVO item : orderItemList) {
            totalProductPrice += (item.getProd_price() * item.getCart_qty());
        }
        
        // 등급별 할인율 및 최종 결제 금액 계산 로직
        int grade = user.getGrade(); // 1: BRONZE, 2: SILVER, 3: GOLD, 4: VIP
        double discountRate = 0.0;
        
        if (grade == 2) discountRate = 0.03; // SILVER 3%
        else if (grade == 3) discountRate = 0.05; // GOLD 5%
        else if (grade == 4) discountRate = 0.10; // VIP 10%
        
        // 할인 금액 계산 (소수점 버림 처리)
        int discountAmount = (int) (totalProductPrice * discountRate);
        
        // 최종 결제 금액 계산
        int finalPayPrice = totalProductPrice - discountAmount;
        
        request.setAttribute("orderItemList", orderItemList);
        request.setAttribute("totalProductPrice", totalProductPrice);
        
        request.setAttribute("discountRate", discountRate);
        request.setAttribute("discountAmount", discountAmount);
        request.setAttribute("finalPayPrice", finalPayPrice);

        // 주문서로 이동
        return "shop/order/orderPageForm.jsp";
    }
}