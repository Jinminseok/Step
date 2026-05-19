package kr.shop.order.action;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import kr.controller.Action;
import kr.shop.dao.UserOrderDAO;

public class KakaoSuccessAction implements Action {

	@Override
	public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		// 결제 승인 도장 꺼내기
		String pg_token = request.getParameter("pg_token");
		
		// 결제 전 세션에 맡겨뒀던 배송지 정보와 tid 꺼내기
		HttpSession session = request.getSession();
		Long user_num = (Long) session.getAttribute("user_num");
		String tid = (String) session.getAttribute("kakao_tid");
		String name = (String) session.getAttribute("order_name");
		String phone = (String) session.getAttribute("order_phone");
		String zipcode = (String) session.getAttribute("order_zipcode");
		String address1 = (String) session.getAttribute("order_address1");
		String address2 = (String) session.getAttribute("order_address2");
		String[] cartNums = (String[]) session.getAttribute("order_cartNums");
		Integer totalPrice = (Integer) session.getAttribute("order_totalPrice");

		// 만약 세션이 날아갔다면 에러 처리
		if(user_num == null || tid == null) {
			request.setAttribute("notice_msg", "결제 정보가 만료되었습니다. 다시 시도해주세요.");
			request.setAttribute("notice_url", request.getContextPath() + "/shop/cart/cartList.do");
			return "common/alert_view.jsp"; 
		}

		// ----------------------------------------------------
		// 카카오페이 최종 결제 승인
		// ----------------------------------------------------
		URL url = new URL("https://open-api.kakaopay.com/online/v1/payment/approve");
		HttpURLConnection conn = (HttpURLConnection) url.openConnection();
		
		// 시크릿키 세팅
		conn.setRequestMethod("POST");
		conn.setRequestProperty("Authorization", "SECRET_KEY DEV3B7BAEEAC1BA84DAA6215DAF85C205B97F13D"); 
		conn.setRequestProperty("Content-Type", "application/json");
		conn.setDoOutput(true);

		// JSON 바디 세팅
		String jsonBody = "{"
				+ "\"cid\":\"TC0ONETIME\"," 
				+ "\"tid\":\"" + tid + "\"," 
				+ "\"partner_order_id\":\"order_1234\"," 
				+ "\"partner_user_id\":\"user_" + user_num + "\","
				+ "\"pg_token\":\"" + pg_token + "\""
				+ "}";

		OutputStream os = conn.getOutputStream();
		os.write(jsonBody.getBytes("utf-8"));
		os.flush();
		os.close();

		int resultCode = conn.getResponseCode();
		if(resultCode == 200) { 
			// DB에 주문 내역을 인서트
			UserOrderDAO orderDao = UserOrderDAO.getInstance();
			orderDao.processOrder(user_num, totalPrice, name, phone, zipcode, address1, address2, cartNums, "카카오페이", tid);

			// DB 저장이 끝났으므로 세션의 임시 데이터 삭제
			session.removeAttribute("kakao_tid");
			session.removeAttribute("order_name");
			session.removeAttribute("order_phone");
			session.removeAttribute("order_zipcode");
			session.removeAttribute("order_address1");
			session.removeAttribute("order_address2");
			session.removeAttribute("order_cartNums");
			session.removeAttribute("order_totalPrice");

			// 고객을 환영해 줄 완료 화면으로 안내합니다.
			request.setAttribute("result_title", "결제 완료");
			request.setAttribute("result_msg", "카카오페이 결제가 성공적으로 완료되었습니다!<br>ShoeMall을 이용해 주셔서 감사합니다.");
			request.setAttribute("result_url", request.getContextPath() + "/shop/user/myPageForm.do");

			return "common/result_view.jsp";
			
		} else {
			// 승인 실패 시
			BufferedReader br = new BufferedReader(new InputStreamReader(conn.getErrorStream(), "utf-8"));
			String line;
			StringBuilder resBuilder = new StringBuilder();
			while((line = br.readLine()) != null) resBuilder.append(line);
			br.close();
			System.out.println("카카오 승인 에러: " + resBuilder.toString());
			
			request.setAttribute("notice_msg", "결제 승인 중 오류가 발생했습니다.");
			request.setAttribute("notice_url", request.getContextPath() + "/shop/cart/cartList.do");
			return "common/alert_view.jsp"; 
		}
	}
}