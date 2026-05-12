package kr.shop.vo;

import java.util.Date;

public class AdminInventoryVO extends AdminBaseVO {
	// 재고 (STOCK)
	private int stock_num; // STOCK_NUM
	private int stock_qty; // STOCK_QTY
	private int stock_min_qty; // STOCK_MIN_QTY
	private Date stock_updated_at; // STOCK_UPDATED_AT

	// 입고 (INBOUND)
	private int in_qty; // IN_QTY
	private String in_memo; // IN_MEMO
	private Date in_date; // IN_DATE
	private long admin_num; // ADMIN_NUM

	// 출고 (OUTBOUND)
	private int out_qty; // OUT_QTY
	private String out_memo; // OUT_MEMO

	public int getStock_num() {
		return stock_num;
	}

	public void setStock_num(int stock_num) {
		this.stock_num = stock_num;
	}

	public int getStock_qty() {
		return stock_qty;
	}

	public void setStock_qty(int stock_qty) {
		this.stock_qty = stock_qty;
	}

	public int getStock_min_qty() {
		return stock_min_qty;
	}

	public void setStock_min_qty(int stock_min_qty) {
		this.stock_min_qty = stock_min_qty;
	}

	public Date getStock_updated_at() {
		return stock_updated_at;
	}

	public void setStock_updated_at(Date stock_updated_at) {
		this.stock_updated_at = stock_updated_at;
	}

	public int getIn_qty() {
		return in_qty;
	}

	public void setIn_qty(int in_qty) {
		this.in_qty = in_qty;
	}

	public String getIn_memo() {
		return in_memo;
	}

	public void setIn_memo(String in_memo) {
		this.in_memo = in_memo;
	}

	public Date getIn_date() {
		return in_date;
	}

	public void setIn_date(Date in_date) {
		this.in_date = in_date;
	}

	public long getAdmin_num() {
		return admin_num;
	}

	public void setAdmin_num(long admin_num) {
		this.admin_num = admin_num;
	}

	public int getOut_qty() {
		return out_qty;
	}

	public void setOut_qty(int out_qty) {
		this.out_qty = out_qty;
	}

	public String getOut_memo() {
		return out_memo;
	}

	public void setOut_memo(String out_memo) {
		this.out_memo = out_memo;
	}

}