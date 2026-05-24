package kr.shop.user.action;

import java.util.ArrayList;          
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import kr.controller.Action;
import kr.shop.dao.RestockAlertDAO;
import kr.shop.dao.UserDAO;
import kr.shop.dao.UserReturnDAO;
import kr.shop.vo.AdminOrderVO;
import kr.shop.vo.UserReturnVO;
import kr.shop.vo.UserVO;

public class MyPageAction implements Action {

    @Override
    public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

        HttpSession session = request.getSession();
        String user_id = (String) session.getAttribute("user_id");

        if (user_id == null) {
            return "redirect:/shop/user/loginForm.do";
        }

        Long user_num = (Long) session.getAttribute("user_num");
        int  userNum  = ((Number) user_num).intValue();
        UserDAO dao = UserDAO.getInstance();

        dao.updateUserGrade(user_num);

        UserVO user = dao.getUserDetail(user_num);
        request.setAttribute("user", user);

        // ✅ orderList 한 번만 선언
        List<AdminOrderVO> orderList = dao.getMyOrderList(user_num);
        request.setAttribute("orderList", orderList);

        // ✅ 주문번호별 그룹핑
        LinkedHashMap<Integer, List<AdminOrderVO>> groupedOrders = new LinkedHashMap<>();
        for (AdminOrderVO item : orderList) {
            groupedOrders
                .computeIfAbsent(item.getOrder_num(), k -> new ArrayList<>())
                .add(item);
        }
        request.setAttribute("groupedOrders", groupedOrders);

        // 최근 주문 현황 1건만 빼서 담기
        List<AdminOrderVO> recentOrderList = new ArrayList<>();
        if (!groupedOrders.isEmpty()) {
            // 그룹핑된 주문 중 가장 첫 번째(최신) 주문 뭉치를 꺼냄
            Map.Entry<Integer, List<AdminOrderVO>> firstOrderEntry = groupedOrders.entrySet().iterator().next();
            List<AdminOrderVO> firstOrderItems = firstOrderEntry.getValue();
            
            // 그 주문의 대표 상품(첫 번째 상품) 정보 추출
            AdminOrderVO recentOrder = firstOrderItems.get(0);
            
            // 한 주문에 상품을 2개 이상 샀다면 "상품명 외 N건"으로 이름 깔끔하게 변경
            if (firstOrderItems.size() > 1) {
                recentOrder.setProd_name(recentOrder.getProd_name() + " 외 " + (firstOrderItems.size() - 1) + "건");
            }
            
            recentOrderList.add(recentOrder);
        }
        request.setAttribute("recentOrderList", recentOrderList);

        // 배송완료 상품 목록
        List<AdminOrderVO> deliveredItemList = dao.getDeliveredItemList(userNum);
        request.setAttribute("deliveredItemList", deliveredItemList);

        // 재입고 알림
        List<Map<String, Object>> restockList = RestockAlertDAO.getInstance().getAlertListByUser(userNum);
        request.setAttribute("restockList", restockList);

        // 반품/교환 내역
        try {
            List<UserReturnVO> returnList = UserReturnDAO.getInstance().getReturnListByUserNum(userNum);
            request.setAttribute("returnList", returnList);
        } catch (Exception e) {
            System.out.println("🚨 [마이페이지 반품내역 조회 에러 발생] 🚨");
            e.printStackTrace();
            request.setAttribute("returnList", null);
        }

        return "shop/user/myPageForm.jsp";
    }
}