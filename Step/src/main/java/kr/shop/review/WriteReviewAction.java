package kr.shop.review;

import java.io.File;
import java.util.UUID;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
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
            // 🌟 폼 데이터 받기 (enctype="multipart/form-data"여도 getParameter 사용 가능)
            long   orderNum = Long.parseLong(request.getParameter("orderNum"));
            int    prodNum  = Integer.parseInt(request.getParameter("prodNum"));
            int    rating   = Integer.parseInt(request.getParameter("rating"));
            String content  = request.getParameter("reviewContent").trim();

            // 🌟 파일 업로드 처리 (라이브러리 없이 내장 기능 사용)
            String savePath = request.getServletContext().getRealPath("/upload");
            File uploadDir = new File(savePath);
            if (!uploadDir.exists()) uploadDir.mkdirs();

            String filename = null;
            Part filePart = request.getPart("uploadFile");
            
            // 파일이 정상적으로 첨부되었다면
            if (filePart != null && filePart.getSize() > 0) {
                // 원본 파일명 가져오기
                String originalFileName = filePart.getSubmittedFileName();
                // 파일명 중복 방지를 위해 UUID(랜덤문자열)를 붙임
                filename = UUID.randomUUID().toString() + "_" + originalFileName;
                // 실제 지정된 경로에 파일 저장
                filePart.write(savePath + File.separator + filename);
            }

            ReviewDAO reviewDAO = ReviewDAO.getInstance();

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

            // 3. 리뷰 및 파일명 DB 저장 (DAO 파라미터에 filename 추가 필요)
            reviewDAO.insertReview(user_num, orderNum, prodNum, rating, content, filename);
            session.setAttribute("reviewMsg", "리뷰가 등록되었습니다. 감사합니다! 😊");

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("reviewMsg", "리뷰 등록 중 오류가 발생했습니다.");
        }

        return "redirect:/shop/user/myPageForm.do";
    }
}