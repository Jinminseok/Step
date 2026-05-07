package kr.shop.vo;

import java.util.Date;

public class AdminProdOptionVO extends AdminBaseVO {
	private int optNum;
	private int prodNum;
	private int sizeVal;
	private String color;
	private int addPrice;
	private String prodUseYn;

	// 재고 관련 확장 필드
	private int stockQty;
	private int stockMinQty;
	private Date stockUpdatedAt;

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

	public int getAddPrice() {
		return addPrice;
	}

	public void setAddPrice(int addPrice) {
		this.addPrice = addPrice;
	}

	public String getProdUseYn() {
		return prodUseYn;
	}

	public void setProdUseYn(String prodUseYn) {
		this.prodUseYn = prodUseYn;
	}

	public int getStockQty() {
		return stockQty;
	}

	public void setStockQty(int stockQty) {
		this.stockQty = stockQty;
	}

	public int getStockMinQty() {
		return stockMinQty;
	}

	public void setStockMinQty(int stockMinQty) {
		this.stockMinQty = stockMinQty;
	}

	public Date getStockUpdatedAt() {
		return stockUpdatedAt;
	}

	public void setStockUpdatedAt(Date stockUpdatedAt) {
		this.stockUpdatedAt = stockUpdatedAt;
	}

}