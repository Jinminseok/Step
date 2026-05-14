package logis_action;

import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

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

        // [복구] 수업 때 쓰던 프로젝트 내부 webapp/upload 경로 방식
        String savePath = request.getServletContext().getRealPath("/upload");
        File uploadDir = new File(savePath);
        if (!uploadDir.exists()) uploadDir.mkdirs();

        List<String> savedFileNames = new ArrayList<>();
        Collection<Part> parts = request.getParts();

        for (Part part : parts) {
            if (!"uploadFile".equals(part.getName())) continue;
            if (part.getSize() == 0) continue;

            String originName = getFileName(part);
            if (originName == null || originName.trim().isEmpty()) continue;

            // [수정] 수정 시에도 원본 파일 이름을 그대로 사용 (시간/인덱스 제거)
            String savedName = originName;

            File saveFile = new File(savePath, savedName);
            try (InputStream is = part.getInputStream();
                 FileOutputStream fos = new FileOutputStream(saveFile)) {
                byte[] buffer = new byte[4096];
                int read;
                while ((read = is.read(buffer)) != -1) {
                    fos.write(buffer, 0, read);
                }
            }
            // 리스트에 원본 이름을 담아 DB 업데이트용으로 전달
            savedFileNames.add(savedName);

            // 최대 5장 제한
            if (savedFileNames.size() >= 5) break;
        }

        // --- 파라미터 수집 (기존 기능 100% 유지) ---
        int prodNum   = parseParam(request.getParameter("prodNum"), 0);
        int catNum    = parseParam(request.getParameter("catNum"), 0);
        int brandNum  = parseParam(request.getParameter("brandNum"), 0);
        int gender    = parseParam(request.getParameter("gender"), 0);
        int prodPrice = parseParam(request.getParameter("prodPrice"), 0);
        int saleRate  = parseParam(request.getParameter("saleRate"), 0);
        int prodStatus= parseParam(request.getParameter("prodStatus"), 1);

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
        vo.setColors(request.getParameter("colors"));
        vo.setSizes(request.getParameter("sizes"));
        
        // 새로운 사진이 업로드된 경우에만 이미지 정보 갱신
        if (!savedFileNames.isEmpty()) {
            vo.setProdImgUrls(savedFileNames);           
            vo.setProdImgUrl(savedFileNames.get(0));     
        }

        Log_ProdDAO dao = new Log_ProdDAO();
        dao.updateProd(vo);

        return "redirect:/logistics/log_prod/log_prodForm.do";
    }

    private String getFileName(Part part) {
        String contentDisp = part.getHeader("content-disposition");
        if (contentDisp == null) return null;
        for (String token : contentDisp.split(";")) {
            token = token.trim();
            if (token.startsWith("filename")) {
                String name = token.substring(token.indexOf("=") + 1).trim();
                name = name.replace("\"", ""); 
                if (name.contains("\\")) name = name.substring(name.lastIndexOf("\\") + 1);
                if (name.contains("/"))  name = name.substring(name.lastIndexOf("/") + 1);
                return name.trim();
            }
        }
        return null;
    }

    private int parseParam(String param, int defaultVal) {
        if (param != null && !param.trim().isEmpty()) {
            try {
                return Integer.parseInt(param.trim());
            } catch (Exception e) {
                return defaultVal;
            }
        }
        return defaultVal;
    }
}