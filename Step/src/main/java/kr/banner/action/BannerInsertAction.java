package kr.banner.action;

import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import kr.controller.Action;
import kr.shop.dao.BannerDAO;
import kr.shop.vo.BannerVO;


public class BannerInsertAction implements Action{

	@Override
	public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

		request.setCharacterEncoding("UTF-8");

        String savePath = request.getServletContext().getRealPath("/upload");
        File uploadDir = new File(savePath);
        if (!uploadDir.exists()) uploadDir.mkdirs();

        String bannerImgUrl = "";
        Part part = request.getPart("uploadFile");
        
        if (part != null && part.getSize() > 0) {
            String originName = getFileName(part);
            if (originName != null && !originName.trim().isEmpty()) {
                bannerImgUrl = originName;
                File saveFile = new File(savePath, bannerImgUrl);
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
        vo.setBanner_img_url(bannerImgUrl);
        vo.setProd_num(Integer.parseInt(request.getParameter("prod_num")));
        vo.setBanner_sort_no(Integer.parseInt(request.getParameter("banner_sort_no")));
        vo.setBanner_use_yn(request.getParameter("banner_use_yn"));

        BannerDAO.getInstance().insertBanner(vo);

        return "redirect:/shop/banner/bannerList.do";
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