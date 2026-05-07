package kr.shop.vo;

public class AdminOrderItemVO {
	private int itemNum;
	private int orderNum;
	private int optNum;
	private int orderItemQty;
	private int orderItemPrice;

	// 조인용 (상품명, 옵션정보 등)
	private String prodName;
	private String color;
	private int sizeVal;

	public int getItemNum() {
		return itemNum;
	}

	public void setItemNum(int itemNum) {
		this.itemNum = itemNum;
	}

	public int getOrderNum() {
		return orderNum;
	}

	public void setOrderNum(int orderNum) {
		this.orderNum = orderNum;
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

	public int getOrderItemPrice() {
		return orderItemPrice;
	}

	public void setOrderItemPrice(int orderItemPrice) {
		this.orderItemPrice = orderItemPrice;
	}

	public String getProdName() {
		return prodName;
	}

	public void setProdName(String prodName) {
		this.prodName = prodName;
	}

	public String getColor() {
		return color;
	}

	public void setColor(String color) {
		this.color = color;
	}

	public int getSizeVal() {
		return sizeVal;
	}

	public void setSizeVal(int sizeVal) {
		this.sizeVal = sizeVal;
	}
	
}