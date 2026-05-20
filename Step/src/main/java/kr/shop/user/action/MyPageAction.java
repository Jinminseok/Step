package kr.shop.user.action;

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
		
		// 로그인 정보 가져오기
		HttpSession session = request.getSession();
		String user_id = (String) session.getAttribute("user_id");
		
		// 로그인 확인
		if (user_id == null) {
			return "redirect:/shop/user/loginForm.do";
		}
				
		// DAO를 통해서 내 아이디로 전체 회원 정보 가져오기
		Long user_num = (Long) session.getAttribute("user_num");
		UserDAO dao = UserDAO.getInstance();
		
		// 내 정보의 등급부터 불러오기(업데이트)
		dao.updateUserGrade(user_num);
		
		// 등급 갱신 후 나머지 정보와 같이 가져오기
		UserVO user = dao.getUserDetail(user_num);
		
		// 주문 내역 가져오기
		List<AdminOrderVO> orderList = dao.getMyOrderList(user_num);
		
		// JSP에서 쓸 수 있게 데이터 담기
		request.setAttribute("user", user);
		request.setAttribute("orderList", orderList);
		
		// 세션에서 user_num 가져온 직후
		int userNum = ((Number) session.getAttribute("user_num")).intValue();
		
		// 배송완료(상태 4)된 개별 상품 목록 조회 후 JSP로 전달
		List<AdminOrderVO> deliveredItemList = dao.getDeliveredItemList(userNum);
		request.setAttribute("deliveredItemList", deliveredItemList);		

		// 재입고 알림 목록 조회 추가
		List<Map<String, Object>> restockList = RestockAlertDAO.getInstance().getAlertListByUser(userNum);
		request.setAttribute("restockList", restockList);
		
		
		// 반품/교환 신청 내역 가져오기
		try {			
			List<UserReturnVO> returnList = UserReturnDAO.getInstance().getReturnListByUserNum(userNum);
			request.setAttribute("returnList", returnList);
		} catch (Exception e) {
			// 화면은 뻗지 않게 막아두고, 이클립스 콘솔창에 진짜 에러 원인만 빨간 글씨로 뱉어냅니다.
			System.out.println("🚨 [마이페이지 반품내역 조회 에러 발생] 🚨");
			e.printStackTrace(); 
			request.setAttribute("returnList", null); // 에러 나면 그냥 빈 목록으로 화면 띄움
		}
		
		// 마이페이지 화면으로 이동
		return "shop/user/myPageForm.jsp";
	}
}