package kr.shop.review;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import kr.controller.Action;
import kr.shop.dao.ReviewDAO;

public class WriteReviewDetailAction implements Action {

    @Override
    public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();

        Long user_num = (Long) session.getAttribute("user_num");

        if (user_num == null) {
            return "redirect:/shop/user/loginForm.do";
        }

        try {
            int prodNum = Integer.parseInt(request.getParameter("prodNum"));
            int rating = Integer.parseInt(request.getParameter("rating"));
            String content = request.getParameter("reviewContent").trim();

            ReviewDAO reviewDAO = ReviewDAO.getInstance();
            
            // 구매 내역에서 가장 최근 상품 번호 가져오기
            Long orderNum = reviewDAO.getRecentOrderNum(user_num, prodNum);

            if (orderNum == null) {
                session.setAttribute("reviewMsg", "리뷰를 작성할 수 있는 구매 내역이 없습니다.");
            } else if (reviewDAO.isDuplicateReview(user_num, orderNum, prodNum)) {
                session.setAttribute("reviewMsg", "이미 리뷰를 작성하신 상품입니다.");
            } else if (rating < 1 || rating > 5 || content.length() < 10) {
                session.setAttribute("reviewMsg", "별점과 리뷰 내용을 최소 10자 이상 정확히 입력해주세요.");
            } else {
                // 검증 통과 시 리뷰 저장
                reviewDAO.insertReview(user_num, orderNum, prodNum, rating, content);
                session.setAttribute("reviewMsg", "리뷰가 성공적으로 등록되었습니다! 😊");
            }

            // 처리 완료 후 해당 상품 상세페이지로 이동
            return "redirect:/shop/product/productdetail.do?prod_num=" + prodNum;

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("reviewMsg", "리뷰 등록 중 오류가 발생했습니다.");
            return "redirect:/shop/product/productdetail.do?prod_num=" + request.getParameter("prodNum");
        }
    }
}