package kr.shop.vo;

public class UserStoreVO {
	private int storeNum;          // STORE_NUM
    private String storeName;      // STORE_NAME
    private String storeAddr;      // STORE_ADDR
    private String storePhone;     // STORE_PHONE
    private String openTime;       // OPEN_TIME
    private String storeUseYn;     // STORE_USE_YN (기본값 'Y')
    private int brandNum;
    private String brandName;
    
    
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
	public int getStoreNum() {
		return storeNum;
	}
	public void setStoreNum(int storeNum) {
		this.storeNum = storeNum;
	}
	public String getStoreName() {
		return storeName;
	}
	public void setStoreName(String storeName) {
		this.storeName = storeName;
	}
	public String getStoreAddr() {
		return storeAddr;
	}
	public void setStoreAddr(String storeAddr) {
		this.storeAddr = storeAddr;
	}
	public String getStorePhone() {
		return storePhone;
	}
	public void setStorePhone(String storePhone) {
		this.storePhone = storePhone;
	}
	public String getOpenTime() {
		return openTime;
	}
	public void setOpenTime(String openTime) {
		this.openTime = openTime;
	}
	public String getStoreUseYn() {
		return storeUseYn;
	}
	public void setStoreUseYn(String storeUseYn) {
		this.storeUseYn = storeUseYn;
	}
    
    
}
