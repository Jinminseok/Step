package kr.shop.review;

import java.io.File;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import kr.controller.Action;
import kr.shop.dao.ReviewDAO;

public class UpdateReviewDetailAction implements Action{

	@Override
	public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

		request.setCharacterEncoding("UTF-8");
		HttpSession session = request.getSession();
		if (session.getAttribute("user_num") == null) return "redirect:/shop/user/loginForm.do";

		try {
			int reviewNum = Integer.parseInt(request.getParameter("reviewNum"));
			int prodNum = Integer.parseInt(request.getParameter("prodNum"));
			int rating = Integer.parseInt(request.getParameter("rating"));
			String content = request.getParameter("reviewContent").trim();

			if (rating < 1 || rating > 5 || content.length() < 10) {
				session.setAttribute("reviewMsg", "입력값을 다시 확인해주세요.");
				return "redirect:/shop/product/productdetail.do?prod_num=" + prodNum;
			}

			String savePath = request.getServletContext().getRealPath("/upload");
			File uploadDir = new File(savePath);
			if (!uploadDir.exists()) uploadDir.mkdirs();

			List<String> filenames = new ArrayList<>();
			for (Part part : request.getParts()) {
				if ("uploadFiles".equals(part.getName()) && part.getSize() > 0) {
					String originalFileName = part.getSubmittedFileName();
					
					part.write(savePath + File.separator + originalFileName);
					filenames.add(originalFileName);
				}
			}

			ReviewDAO.getInstance().updateReview(reviewNum, rating, content, filenames);
			session.setAttribute("reviewMsg", "리뷰가 성공적으로 수정되었습니다.");
            
			return "redirect:/shop/product/productdetail.do?prod_num=" + prodNum;

		} catch (Exception e) {
			e.printStackTrace();
			session.setAttribute("reviewMsg", "리뷰 수정 중 오류가 발생했습니다.");
            return "redirect:/shop/product/productdetail.do?prod_num=" + request.getParameter("prodNum");
		}
	}
}