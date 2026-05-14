package kr.banner.action;

import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import kr.shop.dao.BannerDAO;
import kr.shop.vo.BannerVO;
import kr.util.Action;

public class BannerInsertAction implements Action{

	@Override
	public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

		request.setCharacterEncoding("UTF-8");
		String savePath = request.getServletContext().getRealPath("/upload");
        File uploadDir = new File(savePath);
        if (!uploadDir.exists()) uploadDir.mkdirs();

        String bannerImg = "";
        Part part = request.getPart("uploadFile");
        
        if (part != null && part.getSize() > 0) {
            String originName = getFileName(part);
            if (originName != null && !originName.trim().isEmpty()) {
                bannerImg = originName;
                File saveFile = new File(savePath, bannerImg);
                try (InputStream is = part.getInputStream();
                     FileOutputStream fos = new FileOutputStream(saveFile)) {
                    byte[] buffer = new byte[4096];
                    int read;
                    while ((read = is.read(buffer)) != -1) {
                        fos.write(buffer, 0, read);
                    }
                }
            }
        }

        BannerVO vo = new BannerVO();
        vo.setBanner_title(request.getParameter("banner_title"));
        vo.setBanner_img(bannerImg);
        vo.setProd_num(Integer.parseInt(request.getParameter("prod_num")));
        vo.setBanner_order(Integer.parseInt(request.getParameter("banner_order")));
        vo.setBanner_status(request.getParameter("banner_status"));

        BannerDAO.getInstance().insertBanner(vo);

        return "redirect:/shop/admin/bannerList.do";
    }

    private String getFileName(Part part) {
        String contentDisp = part.getHeader("content-disposition");
        for (String token : contentDisp.split(";")) {
            if (token.trim().startsWith("filename")) {
                String name = token.substring(token.indexOf("=") + 1).trim().replace("\"", "");
                if (name.contains("\\")) name = name.substring(name.lastIndexOf("\\") + 1);
                if (name.contains("/")) name = name.substring(name.lastIndexOf("/") + 1);
                return name;
            }
        }
        return null;
    }
}