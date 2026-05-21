package kr.shop.review;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import kr.controller.Action;
import kr.shop.dao.ReviewDAO;

public class WriteReviewAction implements Action {

    @Override
    public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();

        String user_id  = (String) session.getAttribute("user_id");
        Long   user_num = (Long)   session.getAttribute("user_num");

        if (user_id == null || user_num == null) {
            return "redirect:/shop/user/loginForm.do";
        }

        try {
            long   orderNum = Long.parseLong(request.getParameter("orderNum"));
            int    prodNum  = Integer.parseInt(request.getParameter("prodNum"));
            int    rating   = Integer.parseInt(request.getParameter("rating"));
            String content  = request.getParameter("reviewContent").trim();

            ReviewDAO reviewDAO = ReviewDAO.getInstance();

            // ✅ checkUserPurchase 제거 (본인 주문 내역에서만 버튼 노출되므로 불필요)

            // 1. 중복 리뷰 확인
            if (reviewDAO.isDuplicateReview(user_num, orderNum, prodNum)) {
                session.setAttribute("reviewMsg", "이미 리뷰를 작성하신 상품입니다.");
                return "redirect:/shop/user/myPageForm.do";
            }

            // 2. 유효성 검사
            if (rating < 1 || rating > 5 || content.length() < 10) {
                session.setAttribute("reviewMsg", "입력값을 다시 확인해주세요.");
                return "redirect:/shop/user/myPageForm.do";
            }

            // 3. 리뷰 저장
            reviewDAO.insertReview(user_num, orderNum, prodNum, rating, content);
            session.setAttribute("reviewMsg", "리뷰가 등록되었습니다. 감사합니다! 😊");

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("reviewMsg", "리뷰 등록 중 오류가 발생했습니다.");
        }

        return "redirect:/shop/user/myPageForm.do";
    }
}