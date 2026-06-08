package kr.shop.order.action;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.List;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import kr.controller.Action;
import kr.shop.dao.UserCartDAO;
import kr.shop.dao.UserDAO;
import kr.shop.dao.UserOrderDAO;
import kr.shop.vo.UserCartVO;
import kr.shop.vo.UserVO;

public class OrderProcessAction implements Action {

	@Override
	public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		// 로그인 확인
		HttpSession session = request.getSession();
		Long user_num = (Long) session.getAttribute("user_num");
		if(user_num == null) return "redirect:/shop/user/loginForm.do";

		request.setCharacterEncoding("utf-8");

		// 주문서 폼에서 넘어온 파라미터 받기
		String[] cartNums = request.getParameterValues("cart_num");
		String name = request.getParameter("name");
		String phone = request.getParameter("phone");
		String zipcode = request.getParameter("zipcode");
		String address1 = request.getParameter("address1");
		String address2 = request.getParameter("address2");
		String payType = request.getParameter("pay_type"); 

		// 결제 수단 번호를 문자로 변환
		String payMethod = "신용카드";
		if("2".equals(payType)) payMethod = "무통장입금";
		else if("3".equals(payType)) payMethod = "카카오페이";

		// DB에서 장바구니 금액을 다시 계산
		UserCartDAO cartDao = UserCartDAO.getInstance();
		List<UserCartVO> orderItemList = cartDao.getOrderCartList(cartNums);
		int totalPrice = 0;
		for(UserCartVO item : orderItemList) {
			totalPrice += (item.getProd_price() * item.getCart_qty());
		}
		
		// 등급별 할인율 및 최종 결제 금액 계산
		UserDAO userDao = UserDAO.getInstance();
		UserVO user = userDao.getUserDetail(user_num);
		int grade = user.getGrade(); 
		
		double discountRate = 0.0;
		if (grade == 2) discountRate = 0.03;
		else if (grade == 3) discountRate = 0.05;
		else if (grade == 4) discountRate = 0.10;
		
		int discountAmount = (int) (totalPrice * discountRate);
		int finalPayPrice = totalPrice - discountAmount; 
		
		// 카카오페이에 보낼 상품명 조합 (예: 에어포스 외 1건)
		String itemName = "ShoeMall 상품";
		if(orderItemList.size() > 0) {
			itemName = orderItemList.get(0).getProd_name();
			if(orderItemList.size() > 1) itemName += " 외 " + (orderItemList.size() - 1) + "건";
		}

		// 결제 수단에 따른 분기 처리
		if (!"3".equals(payType)) {
			UserOrderDAO orderDao = UserOrderDAO.getInstance();
			orderDao.processOrder(user_num, totalPrice, discountAmount, finalPayPrice, name, phone, zipcode, address1, address2, cartNums, payMethod, null);

			request.setAttribute("result_title", "주문 완료");
			request.setAttribute("result_msg", "주문 및 결제가 성공적으로 완료되었습니다.<br>이용해 주셔서 감사합니다.");
			request.setAttribute("result_url", request.getContextPath() + "/shop/user/myPageForm.do");
			return "common/result_view.jsp";
			
		} else {
			// 카카오페이 결제
			URL url = new URL("https://open-api.kakaopay.com/online/v1/payment/ready");
			HttpURLConnection conn = (HttpURLConnection) url.openConnection();
			
			// Secret key(dev) 값
			conn.setRequestMethod("POST");
			conn.setRequestProperty("Authorization", "카카오 API 키"); 
			conn.setRequestProperty("Content-Type", "application/json");
			conn.setDoOutput(true); 
			
			String approval_url = "http://localhost:8080" + request.getContextPath() + "/shop/order/kakaoSuccess.do";
			String cancel_url = "http://localhost:8080" + request.getContextPath() + "/shop/cart/cartList.do"; 
			String fail_url = "http://localhost:8080" + request.getContextPath() + "/shop/cart/cartList.do";   
			
			String jsonBody = "{"
					+ "\"cid\":\"TC0ONETIME\"," 
					+ "\"partner_order_id\":\"order_1234\"," 
					+ "\"partner_user_id\":\"user_" + user_num + "\","
					+ "\"item_name\":\"" + itemName + "\","
					+ "\"quantity\":1,"
					+ "\"total_amount\":" + finalPayPrice + ","
					+ "\"tax_free_amount\":0,"
					+ "\"approval_url\":\"" + approval_url + "\","
					+ "\"cancel_url\":\"" + cancel_url + "\","
					+ "\"fail_url\":\"" + fail_url + "\""
					+ "}";
			
			OutputStream os = conn.getOutputStream();
			os.write(jsonBody.getBytes("utf-8"));
			os.flush();
			os.close();
			
			BufferedReader br;
			int resultCode = conn.getResponseCode();
			if(resultCode == 200) { 
				br = new BufferedReader(new InputStreamReader(conn.getInputStream(), "utf-8"));
			} else { 
				br = new BufferedReader(new InputStreamReader(conn.getErrorStream(), "utf-8"));
			}
			
			String line;
			StringBuilder resBuilder = new StringBuilder();
			while((line = br.readLine()) != null) {
				resBuilder.append(line);
			}
			br.close();
			
			String responseData = resBuilder.toString();
			
			// JSON 추출
			String tid = responseData.split("\"tid\":\"")[1].split("\"")[0];
			String redirectUrl = responseData.split("\"next_redirect_pc_url\":\"")[1].split("\"")[0];
			
			// 카카오페이 성공 후 처리를 위해 세션에 모두 보관
			session.setAttribute("kakao_tid", tid);
			session.setAttribute("order_name", name);
			session.setAttribute("order_phone", phone);
			session.setAttribute("order_zipcode", zipcode);
			session.setAttribute("order_address1", address1);
			session.setAttribute("order_address2", address2);
			session.setAttribute("order_cartNums", cartNums);
			session.setAttribute("order_totalPrice", totalPrice);      // 원가
			session.setAttribute("order_discPrice", discountAmount);   // 할인액
			session.setAttribute("order_payPrice", finalPayPrice);     // 실결제액
			
			// JSON 반환
			request.setAttribute("notice_msg", "카카오페이 결제창으로 이동합니다.");
			request.setAttribute("notice_url", redirectUrl);
			
			return "common/alert_view.jsp";
		}
	}
}
