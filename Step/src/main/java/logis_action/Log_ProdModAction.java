package logis_action;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.controller.Action;
import logis.dao.Log_ProdDAO;
import logis_vo.Log_ProdVO;

public class Log_ProdModAction implements Action {

    @Override
    public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

        request.setCharacterEncoding("UTF-8");

        // 파라미터 꺼내기
        String prodNumStr  = request.getParameter("prodNum");
        String catNumStr   = request.getParameter("catNum");
        String brandNumStr = request.getParameter("brandNum");
        String genderStr   = request.getParameter("gender");
        String priceStr    = request.getParameter("prodPrice");
        String saleStr     = request.getParameter("saleRate");
        String statusStr   = request.getParameter("prodStatus");

        // 빈값 체크 후 변환
        int prodNum   = (prodNumStr  != null && !prodNumStr.isEmpty())  ? Integer.parseInt(prodNumStr)  : 0;
        int catNum    = (catNumStr   != null && !catNumStr.isEmpty())   ? Integer.parseInt(catNumStr)   : 0;
        int brandNum  = (brandNumStr != null && !brandNumStr.isEmpty()) ? Integer.parseInt(brandNumStr) : 0;
        int gender    = (genderStr   != null && !genderStr.isEmpty())   ? Integer.parseInt(genderStr)   : 0;
        int prodPrice = (priceStr    != null && !priceStr.isEmpty())    ? Integer.parseInt(priceStr)    : 0;
        int saleRate  = (saleStr     != null && !saleStr.isEmpty())     ? Integer.parseInt(saleStr)     : 0;
        int prodStatus= (statusStr   != null && !statusStr.isEmpty())   ? Integer.parseInt(statusStr)   : 1;

        Log_ProdVO vo = new Log_ProdVO();
        vo.setProdNum  (prodNum);    // ← 수정 시 필수
        vo.setCatNum   (catNum);
        vo.setBrandNum (brandNum);
        vo.setSku      (request.getParameter("sku"));
        vo.setProdName (request.getParameter("prodName"));
        vo.setGender   (gender);
        vo.setProdPrice(prodPrice);
        vo.setSaleRate (saleRate);
        vo.setProdText (request.getParameter("prodText"));
        vo.setProdStatus(prodStatus);

        Log_ProdDAO dao = new Log_ProdDAO();
        dao.updateProd(vo);

        return "redirect:/logistics/log_prod/log_prodForm.do";
    }
}