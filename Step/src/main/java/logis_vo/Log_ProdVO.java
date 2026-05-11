package logis_vo;

import java.sql.Date;

public class Log_ProdVO {

    // ── DB INSERT 용 ──────────────────────────────
    private int    prodNum;
    private int    catNum;       // 카테고리 번호 (FK)
    private int    brandNum;     // 브랜드 번호 (FK)
    private String sku;
    private String prodName;
    private int    gender;       // 0:공용, 1:남, 2:여
    private int    prodPrice;
    private int    saleRate;     // 할인율
    private String prodText;     // 상품 설명
    private int    prodStatus;   // 1:판매중, 2:숨김, 3:품절
    private Date   prodCreatedAt;	//상품 등록일
    private Date   prodUpdatedAt;	//상품 수정일
    

    // ── 화면 표시용 (JOIN) ────────────────────────
    private String brandName;
    private String catName;
    private int    stockQty;
    private int    maxStock;

   
	private int colorCnt;
    private String sizeRange;
    
    private String colors;
    private String sizes;
    
    private String colorList;
    private String sizeList;
    
    private String prodImgUrl;
    
    // ── getter / setter ───────────────────────────
    
    public int getColorCnt() {
		return colorCnt;
	}

	public Date getProdCreatedAt() {
		return prodCreatedAt;
	}

	public void setProdCreatedAt(Date prodCreatedAt) {
		this.prodCreatedAt = prodCreatedAt;
	}

	public Date getProdUpdatedAt() {
		return prodUpdatedAt;
	}

	public void setProdUpdatedAt(Date prodUpdatedAt) {
		this.prodUpdatedAt = prodUpdatedAt;
	}

	public String getProdImgUrl() {
		return prodImgUrl;
	}
	public void setProdImgUrl(String prodImgUrl) {
		this.prodImgUrl = prodImgUrl;
	}
	public String getColorList() {
		return colorList;
	}
	public void setColorList(String colorList) {
		this.colorList = colorList;
	}
	public String getSizeList() {
		return sizeList;
	}
	public void setSizeList(String sizeList) {
		this.sizeList = sizeList;
	}
	public String getColors() {
		return colors;
	}
	public void setColors(String colors) {
		this.colors = colors;
	}
	public String getSizes() {
		return sizes;
	}
	public void setSizes(String sizes) {
		this.sizes = sizes;
	}
	public void setColorCnt(int colorCnt) {
		this.colorCnt = colorCnt;
	}
	public String getSizeRange() {
		return sizeRange;
	}
	public void setSizeRange(String sizeRange) {
		this.sizeRange = sizeRange;
	}
    public int getProdNum()              { return prodNum; }
    public void setProdNum(int prodNum)  { this.prodNum = prodNum; }

    public int getCatNum()               { return catNum; }
    public void setCatNum(int catNum)    { this.catNum = catNum; }

    public int getBrandNum()             { return brandNum; }
    public void setBrandNum(int brandNum){ this.brandNum = brandNum; }

    public String getSku()               { return sku; }
    public void setSku(String sku)       { this.sku = sku; }

    public String getProdName()                  { return prodName; }
    public void setProdName(String prodName)     { this.prodName = prodName; }

    public int getGender()               { return gender; }
    public void setGender(int gender)    { this.gender = gender; }

    public int getProdPrice()                    { return prodPrice; }
    public void setProdPrice(int prodPrice)      { this.prodPrice = prodPrice; }

    public int getSaleRate()                     { return saleRate; }
    public void setSaleRate(int saleRate)        { this.saleRate = saleRate; }

    public String getProdText()                  { return prodText; }
    public void setProdText(String prodText)     { this.prodText = prodText; }

    public int getProdStatus()                   { return prodStatus; }
    public void setProdStatus(int prodStatus)    { this.prodStatus = prodStatus; }

    public String getBrandName()                 { return brandName; }
    public void setBrandName(String brandName)   { this.brandName = brandName; }

    public String getCatName()                   { return catName; }
    public void setCatName(String catName)       { this.catName = catName; }

    public int getStockQty()                     { return stockQty; }
    public void setStockQty(int stockQty)        { this.stockQty = stockQty; }

    public int getMaxStock()                     { return maxStock; }
    public void setMaxStock(int maxStock)        { this.maxStock = maxStock; }
}