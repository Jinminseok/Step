package kr.shop.order.action;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import kr.controller.Action;
import kr.shop.dao.OrderCancelDAO;
import kr.util.DBUtil;

public class OrderCancelAction implements Action {

	@Override
	public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

		request.setCharacterEncoding("UTF-8");
		HttpSession session = request.getSession();

		String user_id  = (String) session.getAttribute("user_id");
		Long   user_num = (Long)   session.getAttribute("user_num");

		if (user_id == null || user_num == null) {
			return "redirect:/shop/user/loginForm.do";
		}

		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		try {
			long orderNum = Long.parseLong(request.getParameter("orderNum"));

			// DB에서 해당 주문의 결제 정보 가져오기
			String payMethod = "";
			String tid = "";
			int cancelAmount = 0;

			conn = DBUtil.getConnection();
			String sql = "SELECT method, tid, amount FROM payments WHERE order_num = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setLong(1, orderNum);
			rs = pstmt.executeQuery();

			if (rs.next()) {
				payMethod = rs.getString("method");
				tid = rs.getString("tid");
				cancelAmount = rs.getInt("amount");
			}
			
			// 다음 DB 작업을 위해 먼저 자원 반납
			DBUtil.executeClose(rs, pstmt, conn);
			conn = null;

			// 카카오페이 결제인 경우 환불 API 호출
			if ("카카오페이".equals(payMethod) && tid != null && !tid.isEmpty()) {
				
				URL url = new URL("https://open-api.kakaopay.com/online/v1/payment/cancel");
				HttpURLConnection httpConn = (HttpURLConnection) url.openConnection();
				
				// 시크릿 키 및 헤더 셋팅
				httpConn.setRequestMethod("POST");
				httpConn.setRequestProperty("Authorization", "SECRET_KEY DEV3B7BAEEAC1BA84DAA6215DAF85C205B97F13D"); 
				httpConn.setRequestProperty("Content-Type", "application/json");
				httpConn.setDoOutput(true);
				
				// 취소 요청 JSON 바디 셋팅 (tid와 취소 금액 필수)
				String jsonBody = "{"
						+ "\"cid\":\"TC0ONETIME\"," 
						+ "\"tid\":\"" + tid + "\"," 
						+ "\"cancel_amount\":" + cancelAmount + ","
						+ "\"cancel_tax_free_amount\":0"
						+ "}";
				
				OutputStream os = httpConn.getOutputStream();
				os.write(jsonBody.getBytes("utf-8"));
				os.flush();
				os.close();
				
				int resultCode = httpConn.getResponseCode();
				if(resultCode == 200) {
					// 취소 성공
					System.out.println("카카오페이 환불 승인 완료 (주문번호: " + orderNum + ")");
				} else {
					// 환불 실패 시
					BufferedReader br = new BufferedReader(new InputStreamReader(httpConn.getErrorStream(), "utf-8"));
					StringBuilder resBuilder = new StringBuilder();
					String line;
					while((line = br.readLine()) != null) resBuilder.append(line);
					br.close();
					
					System.out.println("카카오페이 환불 에러: " + resBuilder.toString());
					
					session.setAttribute("cancelMsg", "카카오페이 환불 처리에 실패했습니다. 고객센터에 문의해주세요.");
					return "redirect:/shop/user/myPageForm.do";
				}
			}

			// 카카오페이 환불이 성공했거나 일반 결제(무통장/카드)일 경우 기존 DB 취소 로직 실행
			OrderCancelDAO.getInstance().cancelOrder(orderNum, user_num);
			session.setAttribute("cancelMsg", "주문이 정상적으로 취소(환불) 되었습니다.");

		} catch (Exception e) {
			e.printStackTrace();
			session.setAttribute("cancelMsg", "주문 취소 중 오류가 발생했습니다.");
		} finally {
			// 혹시 모를 커넥션 누수 방지
			if (conn != null) DBUtil.executeClose(rs, pstmt, conn);
		}

		return "redirect:/shop/user/myPageForm.do";
	}
}