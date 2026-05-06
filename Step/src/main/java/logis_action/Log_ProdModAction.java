package logis_action;

import java.io.File;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import kr.controller.Action;
import logis.dao.Log_ProdDAO;
import logis_vo.Log_ProdVO;

public class Log_ProdModAction implements Action {

    @Override
    public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
        request.setCharacterEncoding("UTF-8");

        // 1. 파일 저장 경로
        String savePath = request.getServletContext().getRealPath("/upload");
        File uploadDir = new File(savePath);
        if (!uploadDir.exists()) uploadDir.mkdirs();

        // 2. 새로운 파일이 업로드 되었는지 확인 및 저장
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
                fileName = System.currentTimeMillis() + "_" + originName;
                part.write(savePath + File.separator + fileName);
            }
        }

        // 3. 텍스트 데이터 받기
        int prodNum   = parseParam(request.getParameter("prodNum"), 0);
        int catNum    = parseParam(request.getParameter("catNum"), 0);
        int brandNum  = parseParam(request.getParameter("brandNum"), 0);
        int gender    = parseParam(request.getParameter("gender"), 0);
        int prodPrice = parseParam(request.getParameter("prodPrice"), 0);
        int saleRate  = parseParam(request.getParameter("saleRate"), 0);
        int prodStatus= parseParam(request.getParameter("prodStatus"), 1);

        // 4. VO 세팅
        Log_ProdVO vo = new Log_ProdVO();
        vo.setProdNum(prodNum);
        vo.setCatNum(catNum);
        vo.setBrandNum(brandNum);
        vo.setSku(request.getParameter("sku"));
        vo.setProdName(request.getParameter("prodName"));
        vo.setGender(gender);
        vo.setProdPrice(prodPrice);
        vo.setSaleRate(saleRate);
        vo.setProdText(request.getParameter("prodText"));
        vo.setProdStatus(prodStatus);
        
        // 🚨 새 파일이 올라왔을 때만 파일명 세팅 (안 올렸으면 null 유지 -> 기존 사진 유지됨)
        if (!fileName.isEmpty()) {
            vo.setProdImgUrl(fileName);
        }

        // 5. DAO 실행
        Log_ProdDAO dao = new Log_ProdDAO();
        dao.updateProd(vo);

        return "redirect:/logistics/log_prod/log_prodForm.do";
    }

    private int parseParam(String param, int defaultVal) {
        if (param != null && !param.trim().isEmpty()) {
            return Integer.parseInt(param);
        }
        return defaultVal;
    }
}