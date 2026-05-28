package kr.shop.review;

import java.io.File;
import java.util.UUID;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import kr.controller.Action;
import kr.shop.dao.ReviewDAO;

public class UpdateReviewAction implements Action{

	@Override
	public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

		request.setCharacterEncoding("UTF-8");
		HttpSession session = request.getSession();

		String user_id = (String) session.getAttribute("user_id");
		if (user_id == null) return "redirect:/shop/user/loginForm.do";

		try {
			int    reviewNum = Integer.parseInt(request.getParameter("reviewNum"));
			int    rating    = Integer.parseInt(request.getParameter("rating"));
			String content   = request.getParameter("reviewContent").trim();

			if (rating < 1 || rating > 5 || content.length() < 10) {
				session.setAttribute("reviewMsg", "입력값을 다시 확인해주세요.");
				return "redirect:/shop/user/myPageForm.do";
			}

			// 파일 업로드 처리
			String savePath = request.getServletContext().getRealPath("/upload");
			File uploadDir = new File(savePath);
			if (!uploadDir.exists()) uploadDir.mkdirs();

			String filename = null;
			Part filePart = request.getPart("uploadFile"); 
            
			// 사용자가 수정 폼에서 새로운 사진을 등록한 경우에만 파일 저장
			if (filePart != null && filePart.getSize() > 0) {
				String originalFileName = filePart.getSubmittedFileName();
				filename = UUID.randomUUID().toString() + "_" + originalFileName;
				filePart.write(savePath + File.separator + filename);
			}

			// DAO 호출 시 filename 전달 (새 사진이 없으면 null 전달)
			ReviewDAO.getInstance().updateReview(reviewNum, rating, content, filename);
			session.setAttribute("reviewMsg", "리뷰가 성공적으로 수정되었습니다.");

		} catch (Exception e) {
			e.printStackTrace();
			session.setAttribute("reviewMsg", "리뷰 수정 중 오류가 발생했습니다.");
		}

		return "redirect:/shop/user/myPageForm.do";
	}
}