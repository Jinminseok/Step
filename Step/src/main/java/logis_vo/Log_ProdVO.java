package logis_vo;

import java.sql.Date;
import java.util.ArrayList;
import java.util.List;

/**
 * [Log_ProdVO]
 * 물류 관리 시스템의 상품 정보를 담는 Value Object입니다.
 * DB의 PRODUCTS, BRANDS, CATEGORIES, PROD_IMGS, PROD_OPTIONS 테이블의 데이터를 통합 관리합니다.
 */
public class Log_ProdVO {

    // --- PRODUCTS 테이블 기본 필드 ---
    private int    prodNum;       // 상품 번호 (PK)
    private int    catNum;        // 카테고리 번호 (FK)
    private int    brandNum;      // 브랜드 번호 (FK)
    private String sku;           // 상품 고유코드 (SKU)
    private String prodName;      // 상품명
    private int    gender;        // 성별 (0:공용, 1:남성, 2:여성)
    private int    prodPrice;     // 정가
    private int    saleRate;      // 할인율
    private String prodText;      // 상품 상세설명
    private int    prodStatus;    // 판매상태 (1:판매중, 2:숨김, 3:품절)
    private Date   prodCreatedAt; // 등록일
    private Date   prodUpdatedAt; // 수정일

    // --- JOIN 및 서브쿼리로 가져오는 확장 필드 ---
    private String brandName;     // 브랜드명
    private String catName;       // 카테고리명
    private int    stockQty;      // 총 재고 수량
    private int    maxStock;      // 최대 재고량 (그래프 계산용, 기본값 100)
    private int    colorCnt;      // 등록된 컬러 수
    private String sizeRange;     // 사이즈 범위 (예: 230~280)
    
    // --- 화면 UI 처리를 위한 콤마(,) 구분 문자열 필드 ---
    private String colors;         // 등록/수정 시 폼에서 넘어오는 컬러들
    private String sizes;          // 등록/수정 시 폼에서 넘어오는 사이즈들
    private String colorList;      // DB에서 LISTAGG로 가져온 컬러 리스트
    private String sizeList;       // DB에서 LISTAGG로 가져온 사이즈 리스트
    private String prodImgListStr; // DB에서 LISTAGG로 가져온 전체 이미지 URL 리스트

    // --- 이미지 처리 관련 필드 ---
    private String       prodImgUrl;                          // 대표 이미지 URL
    private List<String> prodImgUrls = new ArrayList<>();     // 등록/수정 시 사용할 이미지 리스트

    // --- Getter & Setter (형님의 기존 로직 100% 유지) ---

    public String getProdImgListStr() { return prodImgListStr; }
    public void setProdImgListStr(String prodImgListStr) { this.prodImgListStr = prodImgListStr; }

    public String getProdImgUrl() { return prodImgUrl; }
    public void setProdImgUrl(String prodImgUrl) { this.prodImgUrl = prodImgUrl; }

    public List<String> getProdImgUrls() { return prodImgUrls; }
    public void setProdImgUrls(List<String> prodImgUrls) { this.prodImgUrls = prodImgUrls; }

    public int getColorCnt() { return colorCnt; }
    public void setColorCnt(int colorCnt) { this.colorCnt = colorCnt; }

    public Date getProdCreatedAt() { return prodCreatedAt; }
    public void setProdCreatedAt(Date prodCreatedAt) { this.prodCreatedAt = prodCreatedAt; }

    public Date getProdUpdatedAt() { return prodUpdatedAt; }
    public void setProdUpdatedAt(Date prodUpdatedAt) { this.prodUpdatedAt = prodUpdatedAt; }

    public String getColorList() { return colorList; }
    public void setColorList(String colorList) { this.colorList = colorList; }

    public String getSizeList() { return sizeList; }
    public void setSizeList(String sizeList) { this.sizeList = sizeList; }

    public String getColors() { return colors; }
    public void setColors(String colors) { this.colors = colors; }

    public String getSizes() { return sizes; }
    public void setSizes(String sizes) { this.sizes = sizes; }

    public String getSizeRange() { return sizeRange; }
    public void setSizeRange(String sizeRange) { this.sizeRange = sizeRange; }

    public int getProdNum() { return prodNum; }
    public void setProdNum(int prodNum) { this.prodNum = prodNum; }

    public int getCatNum() { return catNum; }
    public void setCatNum(int catNum) { this.catNum = catNum; }

    public int getBrandNum() { return brandNum; }
    public void setBrandNum(int brandNum) { this.brandNum = brandNum; }

    public String getSku() { return sku; }
    public void setSku(String sku) { this.sku = sku; }

    public String getProdName() { return prodName; }
    public void setProdName(String prodName) { this.prodName = prodName; }

    public int getGender() { return gender; }
    public void setGender(int gender) { this.gender = gender; }

    public int getProdPrice() { return prodPrice; }
    public void setProdPrice(int prodPrice) { this.prodPrice = prodPrice; }

    public int getSaleRate() { return saleRate; }
    public void setSaleRate(int saleRate) { this.saleRate = saleRate; }

    public String getProdText() { return prodText; }
    public void setProdText(String prodText) { this.prodText = prodText; }

    public int getProdStatus() { return prodStatus; }
    public void setProdStatus(int prodStatus) { this.prodStatus = prodStatus; }

    public String getBrandName() { return brandName; }
    public void setBrandName(String brandName) { this.brandName = brandName; }

    public String getCatName() { return catName; }
    public void setCatName(String catName) { this.catName = catName; }

    public int getStockQty() { return stockQty; }
    public void setStockQty(int stockQty) { this.stockQty = stockQty; }

    public int getMaxStock() { return maxStock; }
    public void setMaxStock(int maxStock) { this.maxStock = maxStock; }
}