package kr.shop.vo;

import java.sql.Date;

public class AdminOrderVO extends AdminBaseVO {
	// 주문 (ORDERS)
	private int order_num; // ORDER_NUM
	private int total_price; // TOTAL_PRICE
	private int disc_price; // DISC_PRICE
	private int pay_price; // PAY_PRICE
	private int order_status; // ORDER_STATUS
	private String prod_name;
	private String prod_img_url;



	// 배송 (DELIVERY)
	private String courier; // COURIER
	private String invoice_no; // INVOICE_NO
	private int dlv_status; // DLV_STATUS

	// ── [3] 반품/교환 관련 (RETURNS) ──
		private int ret_num;         // RET_NUM
		private int user_num;        // USER_NUM 🌟 (추가: 신청한 회원 번호)
		private int tp;              // TP (1:반품, 2:교환)
		private String reason;       // REASON
		private int prod_num;        // PROD_NUM 🌟 (추가: 신청된 상품 번호)
		private int opt_num;         // OPT_NUM 🌟 (추가: 옵션 번호)
		private int ret_status;      // RET_STATUS (1:신청대기, 2:수거진행, 3:처리완료, 4:신청반려)
		private int admin_num;       // ADMIN_NUM 🌟 (추가: 승인/반려 처리한 관리자 번호)
		private String ret_note;     // RET_NOTE (고객 추가 비고)
		private int is_good;         // IS_GOOD (제품 상태 검수 결과 - 0:대기, 1:정상, 2:파손)
		private Date ret_created_at; // RET_CREATED_AT 🌟 (추가: 클레임 신청일자)
		private Date ret_updated_at; // RET_UPDATED_AT 🌟 (추가: 최종 심사일자)

		
	
	
	public int getUser_num() {
			return user_num;
		}

		public void setUser_num(int user_num) {
			this.user_num = user_num;
		}

		public int getProd_num() {
			return prod_num;
		}

		public void setProd_num(int prod_num) {
			this.prod_num = prod_num;
		}

		public int getOpt_num() {
			return opt_num;
		}

		public void setOpt_num(int opt_num) {
			this.opt_num = opt_num;
		}

		public int getAdmin_num() {
			return admin_num;
		}

		public void setAdmin_num(int admin_num) {
			this.admin_num = admin_num;
		}

		public Date getRet_created_at() {
			return ret_created_at;
		}

		public void setRet_created_at(Date ret_created_at) {
			this.ret_created_at = ret_created_at;
		}

		public Date getRet_updated_at() {
			return ret_updated_at;
		}

		public void setRet_updated_at(Date ret_updated_at) {
			this.ret_updated_at = ret_updated_at;
		}

	public String getProd_img_url() {
		return prod_img_url;
	}

	public void setProd_img_url(String prod_img_url) {
		this.prod_img_url = prod_img_url;
	}
	
	public String getProd_name() {
		return prod_name;
	}

	public void setProd_name(String prod_name) {
		this.prod_name = prod_name;
	}
	
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
