package kr.shop.review;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import kr.controller.Action;
import kr.shop.dao.ReviewDAO;

public class DeleteReviewAction implements Action{

	@Override
	public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();

        String user_id  = (String) session.getAttribute("user_id");
        Long   user_num = (Long)   session.getAttribute("user_num");
        if (user_id == null) return "redirect:/shop/user/loginForm.do";

        try {
            int reviewNum = Integer.parseInt(request.getParameter("reviewNum"));
            ReviewDAO.getInstance().deleteReview(reviewNum, user_num);
            session.setAttribute("reviewMsg", "리뷰가 삭제되었습니다.");

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("reviewMsg", "리뷰 삭제 중 오류가 발생했습니다.");
        }

        return "redirect:/shop/user/myPageForm.do";
    }
}
