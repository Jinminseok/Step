package logis_action;

import java.util.ArrayList;
import java.util.List;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import kr.controller.Action;
import logis.dao.Log_OutDAO;
import logis_vo.Log_OutVO;

public class Log_OutProcessAction implements Action {

    @Override
    public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
        
        request.setCharacterEncoding("UTF-8");

        String[] orderNums = request.getParameterValues("orderNum");
        String[] optNums = request.getParameterValues("optNum");
        String[] qtys = request.getParameterValues("qty");
        String[] couriers = request.getParameterValues("courier");
        String[] invoiceNos = request.getParameterValues("invoiceNo");

        HttpSession session = request.getSession();
        Object sessionUserNum = session.getAttribute("user_num");

        int adminNum = 1;
        if (sessionUserNum != null) {            
            adminNum = ((Number) sessionUserNum).intValue();
        }
        
        try {
            if (orderNums != null && orderNums.length > 0) {
                List<Log_OutVO> list = new ArrayList<>();
                
                System.out.println("========== [출고 Action 로그] ==========");
                for (int i = 0; i < orderNums.length; i++) {
                    Log_OutVO vo = new Log_OutVO();
                    vo.setOrderNum(Integer.parseInt(orderNums[i]));
                    vo.setOptNum(Integer.parseInt(optNums[i]));
                    vo.setOrderItemQty(Integer.parseInt(qtys[i]));
                    vo.setAdminNum(adminNum);
                    
                 
                    String courier = (couriers != null && couriers.length > i && couriers[i] != null && !couriers[i].trim().isEmpty()) ? couriers[i].trim() : null;
                    String invoiceNo = (invoiceNos != null && invoiceNos.length > i && invoiceNos[i] != null && !invoiceNos[i].trim().isEmpty()) ? invoiceNos[i].trim() : null;
                    
                    vo.setCourier(courier);
                    vo.setInvoiceNo(invoiceNo);
                    vo.setOutMemo("WMS 시스템 출고 처리");
                    
                    System.out.println("주문번호: " + vo.getOrderNum() + " | 택배사: " + courier + " | 송장번호: " + invoiceNo);
                    list.add(vo);
                }
                System.out.println("========================================");

                Log_OutDAO dao = new Log_OutDAO();
                dao.processBulkOutbound(list);
            }
        } catch (Exception e) {
         
            System.out.println("🚨🚨🚨 [출고 처리 중 에러 발생!] 🚨🚨🚨");
            e.printStackTrace();
            throw e;
        }

        return "redirect:/logistics/log_out/log_outForm.do";
    }
}