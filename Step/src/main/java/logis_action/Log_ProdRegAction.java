package logis_action;

import java.io.File;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import kr.controller.Action;
import logis.dao.Log_ProdDAO;
import logis_vo.Log_ProdVO;

public class Log_ProdRegAction implements Action {

    @Override
    public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
        request.setCharacterEncoding("UTF-8");

        // 1. 파일 저장 경로 (webapp/upload 폴더)
        String savePath = request.getServletContext().getRealPath("/upload");
        File uploadDir = new File(savePath);
        if (!uploadDir.exists()) uploadDir.mkdirs();

        // 2. 파일 업로드 처리
        String fileName = "";
        Part part = request.getPart("uploadFile");
        if (part != null && part.getSize() > 0) {
            String contentDisp = part.getHeader("content-disposition");
            String originName = "";
            for (String cd : contentDisp.split(";")) {
                if (cd.trim().startsWith("filename")) {
                    originName = cd.substring(cd.indexOf("=") + 2, cd.length() - 1);
                    break;
                }
            }
            if (!originName.isEmpty()) {
            	fileName = originName;
                part.write(savePath + File.separator + fileName); // 실제 폴더에 파일 저장
            }
        }

        // 3. 텍스트 데이터 받기 및 변환
        int catNum    = parseParam(request.getParameter("catNum"), 0);
        int brandNum  = parseParam(request.getParameter("brandNum"), 0);
        int gender    = parseParam(request.getParameter("gender"), 0);
        int prodPrice = parseParam(request.getParameter("prodPrice"), 0);
        int saleRate  = parseParam(request.getParameter("saleRate"), 0);
        int prodStatus= parseParam(request.getParameter("prodStatus"), 1);

        // 4. VO 세팅
        Log_ProdVO vo = new Log_ProdVO();
        vo.setCatNum(catNum);
        vo.setBrandNum(brandNum);
        vo.setSku(request.getParameter("sku"));
        vo.setProdName(request.getParameter("prodName"));
        vo.setGender(gender);
        vo.setProdPrice(prodPrice);
        vo.setSaleRate(saleRate);
        vo.setProdText(request.getParameter("prodText"));
        vo.setProdStatus(prodStatus);
        vo.setColors(request.getParameter("colors"));
        vo.setSizes(request.getParameter("sizes"));
        
        // 🚨 DB에 들어갈 파일명 세팅
        vo.setProdImgUrl(fileName);

        // 5. DAO 실행
        Log_ProdDAO dao = new Log_ProdDAO();
        dao.insertProd(vo);

        return "redirect:/logistics/log_prod/log_prodForm.do";
    }

    // 숫자 변환 헬퍼 메서드
    private int parseParam(String param, int defaultVal) {
        if (param != null && !param.trim().isEmpty()) {
            return Integer.parseInt(param);
        }
        return defaultVal;
    }
}