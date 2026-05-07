package kr.shop.vo;

import java.util.Date;
import java.util.List;

public class AdminOrderVO extends AdminBaseVO {
	// 주문(ORDERS)
	private int orderNum;
	private long userNum;
	private int totalPrice;
	private int discPrice;
	private int payPrice;
	private String recvName;
	private String recvPhone;
	private String recvZip;
	private String recvAddr1;
	private String recvAddr2;
	private int orderStatus;
	private Date orderCreatedAt;

	// 결제/배송 확장 필드
	private String payMethod;
	private int payStatus;
	private String courier;
	private String invoiceNo;
	private int dlvStatus;

	// 조인용 확장 필드
	private String userId;
	private String userName;
	private List<AdminOrderItemVO> items; // 주문 상세 상품 리스트

	public int getOrderNum() {
		return orderNum;
	}

	public void setOrderNum(int orderNum) {
		this.orderNum = orderNum;
	}

	public long getUserNum() {
		return userNum;
	}

	public void setUserNum(long userNum) {
		this.userNum = userNum;
	}

	public int getTotalPrice() {
		return totalPrice;
	}

	public void setTotalPrice(int totalPrice) {
		this.totalPrice = totalPrice;
	}

	public int getDiscPrice() {
		return discPrice;
	}

	public void setDiscPrice(int discPrice) {
		this.discPrice = discPrice;
	}

	public int getPayPrice() {
		return payPrice;
	}

	public void setPayPrice(int payPrice) {
		this.payPrice = payPrice;
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

	public String getRecvZip() {
		return recvZip;
	}

	public void setRecvZip(String recvZip) {
		this.recvZip = recvZip;
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

	public Date getOrderCreatedAt() {
		return orderCreatedAt;
	}

	public void setOrderCreatedAt(Date orderCreatedAt) {
		this.orderCreatedAt = orderCreatedAt;
	}

	public String getPayMethod() {
		return payMethod;
	}

	public void setPayMethod(String payMethod) {
		this.payMethod = payMethod;
	}

	public int getPayStatus() {
		return payStatus;
	}

	public void setPayStatus(int payStatus) {
		this.payStatus = payStatus;
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

	public int getDlvStatus() {
		return dlvStatus;
	}

	public void setDlvStatus(int dlvStatus) {
		this.dlvStatus = dlvStatus;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String getUserName() {
		return userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}

	public List<AdminOrderItemVO> getItems() {
		return items;
	}

	public void setItems(List<AdminOrderItemVO> items) {
		this.items = items;
	}

}