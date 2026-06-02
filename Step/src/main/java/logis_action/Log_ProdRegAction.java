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

public class Log_ProdRegAction implements Action {

    @Override
    public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
        request.setCharacterEncoding("UTF-8");

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
            savedFileNames.add(savedName);

            if (savedFileNames.size() >= 5) break;
        }

        Log_ProdVO vo = new Log_ProdVO();
        vo.setCatNum(parseParam(request.getParameter("catNum"), 0));
        vo.setBrandNum(parseParam(request.getParameter("brandNum"), 0));
        vo.setSku(request.getParameter("sku"));
        vo.setProdName(request.getParameter("prodName"));
        vo.setGender(parseParam(request.getParameter("gender"), 0));
        vo.setProdPrice(parseParam(request.getParameter("prodPrice"), 0));
        vo.setSaleRate(parseParam(request.getParameter("saleRate"), 0));
        vo.setProdText(request.getParameter("prodText"));
        vo.setProdStatus(parseParam(request.getParameter("prodStatus"), 1));
        vo.setColors(request.getParameter("colors"));
        vo.setSizes(request.getParameter("sizes"));

        vo.setProdImgUrls(savedFileNames);
        if (!savedFileNames.isEmpty()) {
            vo.setProdImgUrl(savedFileNames.get(0));
        }

        Log_ProdDAO dao = new Log_ProdDAO();
        dao.insertProd(vo);

        return "redirect:/logistics/log_prod/log_prodForm.do";
    }

    private String getFileName(Part part) {
        String contentDisp = part.getHeader("content-disposition");
        if (contentDisp == null) return null;
        for (String token : contentDisp.split(";")) {
            token = token.trim();
            if (token.startsWith("filename")) {
                String name = token.substring(token.indexOf("=") + 1).trim().replace("\"", ""); 
                if (name.contains("\\")) name = name.substring(name.lastIndexOf("\\") + 1);
                if (name.contains("/"))  name = name.substring(name.lastIndexOf("/") + 1);
                return name.trim();
            }
        }
        return null;
    }

    private int parseParam(String param, int defaultVal) {
        try { return (param != null && !param.isEmpty()) ? Integer.parseInt(param.trim()) : defaultVal; }
        catch (Exception e) { return defaultVal; }
    }
}