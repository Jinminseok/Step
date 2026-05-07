package logis_action;

import java.util.ArrayList;
import java.util.List;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import kr.controller.Action;
import logis.dao.Log_OutDAO;
import logis_vo.Log_OutVO;

public class Log_OutProcessAction implements Action{

	@Override
    public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
        
        request.setCharacterEncoding("UTF-8");

        // 1. 단일 출고든 일괄 출고든 무조건 배열로 받습니다 (getParameterValues)
        String[] orderNums = request.getParameterValues("orderNum");
        String[] optNums = request.getParameterValues("optNum");
        String[] qtys = request.getParameterValues("qty");
        String[] couriers = request.getParameterValues("courier");
        String[] invoiceNos = request.getParameterValues("invoiceNo");

        HttpSession session = request.getSession();
        Object sessionUserNum = session.getAttribute("user_num");

        int adminNum = 1; // 세션이 없을 경우를 대비한 기본값
        if (sessionUserNum != null) {            
            adminNum = ((Number) sessionUserNum).intValue();
        }
        
        // 2. 파라미터가 넘어왔다면 리스트로 변환
        if (orderNums != null && orderNums.length > 0) {
            List<Log_OutVO> list = new ArrayList<>();
            
            for (int i = 0; i < orderNums.length; i++) {
                Log_OutVO vo = new Log_OutVO();
                vo.setOrderNum(Integer.parseInt(orderNums[i]));
                vo.setOptNum(Integer.parseInt(optNums[i]));
                vo.setOrderItemQty(Integer.parseInt(qtys[i]));
                vo.setAdminNum(adminNum);
                
                // 택배사와 송장번호는 값이 비어있을 수 있으므로 방어 코드 작성
                vo.setCourier((couriers != null && couriers.length > i && !couriers[i].isEmpty()) ? couriers[i] : null);
                vo.setInvoiceNo((invoiceNos != null && invoiceNos.length > i && !invoiceNos[i].isEmpty()) ? invoiceNos[i] : null);
                vo.setOutMemo("WMS 시스템 출고 처리");
                
                list.add(vo);
            }

            // 3. DAO로 리스트를 통째로 넘겨서 일괄 처리
            Log_OutDAO dao = new Log_OutDAO();
            dao.processBulkOutbound(list);
        }

        return "redirect:/logistics/log_out/log_outForm.do";
    }
    
}
