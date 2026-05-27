package logis_action;

import java.io.PrintWriter;
import java.util.List;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.controller.Action;
import logis.dao.Log_ReturnDAO;
import logis_vo.Log_ReturnVO;

public class Log_GetAvailableOptionsAction implements Action {

    @Override
    public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
        // 1. 보안 및 인코딩, JSON 타입 선언
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json; charset=UTF-8");
        
        String prodNumStr = request.getParameter("prodNum");
        PrintWriter out = response.getWriter();
        
        // 방어막: 파라미터가 비어있거나 null인 경우 예외를 터뜨리지 않고 안전하게 빈 배열 반환
        if(prodNumStr == null || prodNumStr.trim().isEmpty() || "undefined".equals(prodNumStr)) {
            out.print("[]");
            out.flush();
            out.close();
            return null;
        }
        
        try {
            int prodNum = Integer.parseInt(prodNumStr.trim());
            Log_ReturnDAO dao = Log_ReturnDAO.getInstance();
            
            // 2. DB에서 현재 창고 실재고가 1개 이상 살아있는 옵션 풀 긁어오기
            List<Log_ReturnVO> optList = dao.getAvailableOptions(prodNum);
            
            // 3. 라이트한 순정 JSON 문자열 정밀 빌드
            StringBuilder json = new StringBuilder();
            json.append("[");
            if(optList != null) {
                for(int i=0; i<optList.size(); i++) {
                    Log_ReturnVO vo = optList.get(i);
                    json.append("{");
                    json.append("\"color\":\"").append(vo.getColor()).append("\",");
                    json.append("\"size_val\":\"").append(vo.getSize_val()).append("\"");
                    json.append("}");
                    if(i < optList.size() - 1) {
                        json.append(",");
                    }
                }
            }
            json.append("]");
            
            // 4. 프론트엔드로 JSON 쏘고 스트림 소멸
            out.print(json.toString());
            
        } catch(Exception e) {
            // 🚨 자바 콘솔에 에러가 나더라도 브라우저가 완전히 뻗지 않도록 에러 로깅 후 빈 배열 리턴 방어
            e.printStackTrace(); 
            out.print("[]");
        } finally {
            out.flush();
            out.close();
        }
        
        return null; 
    }
}