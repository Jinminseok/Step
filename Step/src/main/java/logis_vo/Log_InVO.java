package logis_vo;

import java.sql.Date;

public class Log_InVO {
	private int inNum;          // 입고번호 (IN_NUM)
    private int optNum;         // 옵션번호 (OPT_NUM)
    private int prodNum;        // 상품번호 (PROD_NUM)
    private int inQty;          // 입고수량 (IN_QTY)
    private int userNum;        // 담당자번호 (USER_NUM)
    private String inMemo;      // 입고메모 (IN_MEMO) - 공급업체 정보 포함
    private Date inDate;        // 입고일 (IN_DATE)
    private Date inCreatedAt;   // 등록일시 (IN_CREATED_AT)

    // 2. 조인(JOIN)해서 가져올 추가 정보들 (화면에 보여줄 데이터)
    private String sku;         // 품번 (PRODUCTS 테이블)
    private String prodName;    // 상품명 (PRODUCTS 테이블)
    private String brandName;   // 브랜드명 (BRANDS 테이블)
    private int sizeVal;        // 사이즈 (PROD_OPTIONS 테이블)
    private String color;       // 컬러 (PROD_OPTIONS 테이블)
    private String userName;    // 담당자명 (USERS_DETAIL 테이블)
    
    // 화면 편의용 추가 변수
    private String supplier;    // 메모에서 분리해 낼 공급업체 이름

	public int getInNum() {
		return inNum;
	}

	public void setInNum(int inNum) {
		this.inNum = inNum;
	}

	public int getOptNum() {
		return optNum;
	}

	public void setOptNum(int optNum) {
		this.optNum = optNum;
	}

	public int getProdNum() {
		return prodNum;
	}

	public void setProdNum(int prodNum) {
		this.prodNum = prodNum;
	}

	public int getInQty() {
		return inQty;
	}

	public void setInQty(int inQty) {
		this.inQty = inQty;
	}

	public int getUserNum() {
		return userNum;
	}

	public void setUserNum(int userNum) {
		this.userNum = userNum;
	}

	public String getInMemo() {
		return inMemo;
	}

	public void setInMemo(String inMemo) {
		this.inMemo = inMemo;
	}

	public Date getInDate() {
		return inDate;
	}

	public void setInDate(Date inDate) {
		this.inDate = inDate;
	}

	public Date getInCreatedAt() {
		return inCreatedAt;
	}

	public void setInCreatedAt(Date inCreatedAt) {
		this.inCreatedAt = inCreatedAt;
	}

	public String getSku() {
		return sku;
	}

	public void setSku(String sku) {
		this.sku = sku;
	}

	public String getProdName() {
		return prodName;
	}

	public void setProdName(String prodName) {
		this.prodName = prodName;
	}

	public String getBrandName() {
		return brandName;
	}

	public void setBrandName(String brandName) {
		this.brandName = brandName;
	}

	public int getSizeVal() {
		return sizeVal;
	}

	public void setSizeVal(int sizeVal) {
		this.sizeVal = sizeVal;
	}

	public String getColor() {
		return color;
	}

	public void setColor(String color) {
		this.color = color;
	}

	public String getUserName() {
		return userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}

	public String getSupplier() {
		return supplier;
	}

	public void setSupplier(String supplier) {
		this.supplier = supplier;
	}
    
    
}
