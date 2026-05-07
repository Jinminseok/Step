package kr.shop.vo;

import java.util.Date;

public class AdminStockInOutVO extends AdminBaseVO {
	private int ioNum; // inNum 또는 outNum
	private int optNum;
	private int adminNum;
	private int ioQty;
	private String ioStatus; // 입고상태 또는 출고상태
	private String memo;
	private String supplier; // 입고처 (입고시 사용)
	private Date ioDate;
	private String type; // IN / OUT 구분 필드 (실무 확장용)

	// 조인용
	private String prodName;
	private String sku;

	public int getIoNum() {
		return ioNum;
	}

	public void setIoNum(int ioNum) {
		this.ioNum = ioNum;
	}

	public int getOptNum() {
		return optNum;
	}

	public void setOptNum(int optNum) {
		this.optNum = optNum;
	}

	public int getAdminNum() {
		return adminNum;
	}

	public void setAdminNum(int adminNum) {
		this.adminNum = adminNum;
	}

	public int getIoQty() {
		return ioQty;
	}

	public void setIoQty(int ioQty) {
		this.ioQty = ioQty;
	}

	public String getIoStatus() {
		return ioStatus;
	}

	public void setIoStatus(String ioStatus) {
		this.ioStatus = ioStatus;
	}

	public String getMemo() {
		return memo;
	}

	public void setMemo(String memo) {
		this.memo = memo;
	}

	public String getSupplier() {
		return supplier;
	}

	public void setSupplier(String supplier) {
		this.supplier = supplier;
	}

	public Date getIoDate() {
		return ioDate;
	}

	public void setIoDate(Date ioDate) {
		this.ioDate = ioDate;
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public String getProdName() {
		return prodName;
	}

	public void setProdName(String prodName) {
		this.prodName = prodName;
	}

	public String getSku() {
		return sku;
	}

	public void setSku(String sku) {
		this.sku = sku;
	}

}