package kr.shop.vo;

public class AdminBrandVO {
	public class BrandVO {
	    
	    private int brandNum;       // BRAND_NUM (NUMBER) - 브랜드 번호 (PK)
	    private String brandName;   // BRAND_NAME (VARCHAR2) - 브랜드 이름
	    private String brandUseYn;  // BRAND_USE_YN (CHAR) - 사용 여부 (Y/N)

	    // ── Getters and Setters ──
	    
	    public int getBrandNum() {
	        return brandNum;
	    }
	    
	    public void setBrandNum(int brandNum) {
	        this.brandNum = brandNum;
	    }
	    
	    public String getBrandName() {
	        return brandName;
	    }
	    
	    public void setBrandName(String brandName) {
	        this.brandName = brandName;
	    }
	    
	    public String getBrandUseYn() {
	        return brandUseYn;
	    }
	    
	    public void setBrandUseYn(String brandUseYn) {
	        this.brandUseYn = brandUseYn;
	    }
	}
}
