package kr.shop.vo;

public class AdminOrderVO extends AdminBaseVO {
	// 주문 (ORDERS)
	private int order_num; // ORDER_NUM
	private int total_price; // TOTAL_PRICE
	private int disc_price; // DISC_PRICE
	private int pay_price; // PAY_PRICE
	private int order_status; // ORDER_STATUS

	// 배송 (DELIVERY)
	private String courier; // COURIER
	private String invoice_no; // INVOICE_NO
	private int dlv_status; // DLV_STATUS

	// 반품 (RETURNS)
	private int ret_num; // RET_NUM
	private int tp; // TP
	private String reason; // REASON
	private int ret_status; // RET_STATUS
	private int is_good; // IS_GOOD
	private String ret_note; // RET_NOTE

	public int getOrder_num() {
		return order_num;
	}

	public void setOrder_num(int order_num) {
		this.order_num = order_num;
	}

	public int getTotal_price() {
		return total_price;
	}

	public void setTotal_price(int total_price) {
		this.total_price = total_price;
	}

	public int getDisc_price() {
		return disc_price;
	}

	public void setDisc_price(int disc_price) {
		this.disc_price = disc_price;
	}

	public int getPay_price() {
		return pay_price;
	}

	public void setPay_price(int pay_price) {
		this.pay_price = pay_price;
	}

	public int getOrder_status() {
		return order_status;
	}

	public void setOrder_status(int order_status) {
		this.order_status = order_status;
	}

	public String getCourier() {
		return courier;
	}

	public void setCourier(String courier) {
		this.courier = courier;
	}

	public String getInvoice_no() {
		return invoice_no;
	}

	public void setInvoice_no(String invoice_no) {
		this.invoice_no = invoice_no;
	}

	public int getDlv_status() {
		return dlv_status;
	}

	public void setDlv_status(int dlv_status) {
		this.dlv_status = dlv_status;
	}

	public int getRet_num() {
		return ret_num;
	}

	public void setRet_num(int ret_num) {
		this.ret_num = ret_num;
	}

	public int getTp() {
		return tp;
	}

	public void setTp(int tp) {
		this.tp = tp;
	}

	public String getReason() {
		return reason;
	}

	public void setReason(String reason) {
		this.reason = reason;
	}

	public int getRet_status() {
		return ret_status;
	}

	public void setRet_status(int ret_status) {
		this.ret_status = ret_status;
	}

	public int getIs_good() {
		return is_good;
	}

	public void setIs_good(int is_good) {
		this.is_good = is_good;
	}

	public String getRet_note() {
		return ret_note;
	}

	public void setRet_note(String ret_note) {
		this.ret_note = ret_note;
	}

}
