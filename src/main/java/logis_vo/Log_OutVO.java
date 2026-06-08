package logis_vo;

public class Log_OutVO {
    // 1. 주문 정보 (ORDERS)
    private int orderNum;           // 주문 번호
    private String recvName;        // 수령인 이름
    private String recvPhone;       // 수령인 연락처
    private String recvAddr1;       // 기본 주소
    private String recvAddr2;       // 상세 주소
    private int orderStatus;        // 주문 상태 (1:출고대기, 2:출고완료)
    private String orderCreatedAt;  // 주문일

    // 2. 주문 상세 및 상품 정보 (ORDER_ITEMS, PRODUCTS, PROD_OPTIONS)
    private int itemNum;            // 주문 상세 번호
    private int prodNum;            // 상품 번호
    private int optNum;             // 옵션 번호
    private int orderItemQty;       // 주문(출고) 수량
    private String sku;             // 품번
    private String prodName;        // 상품명
    private int sizeVal;            // 사이즈
    private String color;           // 컬러

    // 3. 출고 이력 정보 (OUTBOUND)
    private int outNum;             // 출고 번호
    private int adminNum;           // 출고 처리한 관리자 번호
    private String outDate;         // 출고일
    private String outMemo;         // 출고 메모

    // 4. 배송 정보 (DELIVERY)
    private String courier;         // 택배사
    private String invoiceNo;       // 운송장 번호
    
    
	public int getOrderNum() {
		return orderNum;
	}
	public void setOrderNum(int orderNum) {
		this.orderNum = orderNum;
	}
	public String getRecvName() {
		return recvName;
	}
	public void setRecvName(String recvName) {
		this.recvName = recvName;
	}
	public String getRecvPhone() {
		return recvPhone;
	}
	public void setRecvPhone(String recvPhone) {
		this.recvPhone = recvPhone;
	}
	public String getRecvAddr1() {
		return recvAddr1;
	}
	public void setRecvAddr1(String recvAddr1) {
		this.recvAddr1 = recvAddr1;
	}
	public String getRecvAddr2() {
		return recvAddr2;
	}
	public void setRecvAddr2(String recvAddr2) {
		this.recvAddr2 = recvAddr2;
	}
	public int getOrderStatus() {
		return orderStatus;
	}
	public void setOrderStatus(int orderStatus) {
		this.orderStatus = orderStatus;
	}
	public String getOrderCreatedAt() {
		return orderCreatedAt;
	}
	public void setOrderCreatedAt(String orderCreatedAt) {
		this.orderCreatedAt = orderCreatedAt;
	}
	public int getItemNum() {
		return itemNum;
	}
	public void setItemNum(int itemNum) {
		this.itemNum = itemNum;
	}
	public int getProdNum() {
		return prodNum;
	}
	public void setProdNum(int prodNum) {
		this.prodNum = prodNum;
	}
	public int getOptNum() {
		return optNum;
	}
	public void setOptNum(int optNum) {
		this.optNum = optNum;
	}
	public int getOrderItemQty() {
		return orderItemQty;
	}
	public void setOrderItemQty(int orderItemQty) {
		this.orderItemQty = orderItemQty;
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
	public int getOutNum() {
		return outNum;
	}
	public void setOutNum(int outNum) {
		this.outNum = outNum;
	}
	public int getAdminNum() {
		return adminNum;
	}
	public void setAdminNum(int adminNum) {
		this.adminNum = adminNum;
	}
	public String getOutDate() {
		return outDate;
	}
	public void setOutDate(String outDate) {
		this.outDate = outDate;
	}
	public String getOutMemo() {
		return outMemo;
	}
	public void setOutMemo(String outMemo) {
		this.outMemo = outMemo;
	}
	public String getCourier() {
		return courier;
	}
	public void setCourier(String courier) {
		this.courier = courier;
	}
	public String getInvoiceNo() {
		return invoiceNo;
	}
	public void setInvoiceNo(String invoiceNo) {
		this.invoiceNo = invoiceNo;
	}

    
}