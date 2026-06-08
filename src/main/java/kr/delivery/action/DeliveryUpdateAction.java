package kr.delivery.action;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.controller.Action;
import kr.shop.dao.DeliveryDAO;
import kr.shop.dao.UserNotifyDAO;
import kr.shop.vo.UserNotifyVO;

public class DeliveryUpdateAction implements Action {

    @Override
    public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

        int    dlvNum    = Integer.parseInt(request.getParameter("dlvNum"));
        int    dlvStatus = Integer.parseInt(request.getParameter("dlvStatus"));
        String courier   = request.getParameter("courier");
        String invoiceNo = request.getParameter("invoiceNo");

        DeliveryDAO dao = DeliveryDAO.getInstance();

        //배송 상태 업데이트
        dao.updateDelivery(dlvNum, dlvStatus, courier, invoiceNo);

        // 2. 배송 시작(3) 또는 배송 완료(4)일 때 알림 발송
        if (dlvStatus == 3 || dlvStatus == 4) {
            int userNum = dao.getUserNumByDlvNum(dlvNum);

            if (userNum > 0) {
                UserNotifyVO noti = new UserNotifyVO();
                noti.setUser_num(userNum);
                noti.setNotify_type(1); 

                if (dlvStatus == 3) {
                    noti.setNotify_title("📦 배송이 출발했습니다!");
                    noti.setNotify_content("주문하신 상품이 배송 중입니다. 곧 도착할 예정이니 조금만 기다려 주세요!");
                } else { 
                    noti.setNotify_title("✅ 배송이 완료되었습니다!");
                    noti.setNotify_content("상품이 도착했습니다. 상품은 마음에 드셨나요? 구매 후기를 남겨주시면 포인트를 드려요!");
                }

                UserNotifyDAO.getInstance().insertNotify(noti);
            }
        }

        return "redirect:/shop/delivery/deliveryForm.do?msg=update_ok";
    }
}