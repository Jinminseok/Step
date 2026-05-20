package logis_vo;

import java.sql.Date; // 오라클 DATE 타입 매핑용

public class Log_ReturnVO {
	// ── [1] RETURNS 테이블 원본 컬럼들 ──
	private int ret_num;         // RET_NUM (PK)
	private int order_num;       // ORDER_NUM
	private int user_num;        // USER_NUM
	private int tp;              // TP (1:반품, 2:교환)
	private String reason;       // REASON
	private int prod_num;        // PROD_NUM
	private int opt_num;         // OPT_NUM
	private int ret_status;      // RET_STATUS (1:대기, 2:수거중, 3:완료, 4:반려)
	private int admin_num;       // ADMIN_NUM
	private String ret_note;     // RET_NOTE
	private int is_good;         // IS_GOOD (1:양품, 0:불량/파손)
	private Date ret_created_at; // RET_CREATED_AT
	private Date ret_updated_at; // RET_UPDATED_AT

	// ── [2] 물류 대시보드 화면 조인(JOIN)용 확장 변수 ──
	private String prod_name;    // PRODUCTS 테이블 조인 결과 (상품명)
	private String opt_info;     // PROD_OPTIONS 테이블 조인 결과 (사이즈 등)
	private int qty;             // ORDER_ITEMS 테이블 조인 결과 (신청 수거 수량)

	
	// ── 💡 Getter / Setter 영역 ──

	public int getRet_num() {
		return ret_num;
	}

	public void setRet_num(int ret_num) {
		this.ret_num = ret_num;
	}

	public int getOrder_num() {
		return order_num;
	}

	public void setOrder_num(int order_num) {
		this.order_num = order_num;
	}

	public int getUser_num() {
		return user_num;
	}

	public void setUser_num(int user_num) {
		this.user_num = user_num;
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

	public int getRet_status() {
		return ret_status;
	}

	public void setRet_status(int ret_status) {
		this.ret_status = ret_status;
	}

	public int getAdmin_num() {
		return admin_num;
	}

	public void setAdmin_num(int admin_num) {
		this.admin_num = admin_num;
	}

	public String getRet_note() {
		return ret_note;
	}

	public void setRet_note(String ret_note) {
		this.ret_note = ret_note;
	}

	public int getIs_good() {
		return is_good;
	}

	public void setIs_good(int is_good) {
		this.is_good = is_good;
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

	public String getProd_name() {
		return prod_name;
	}

	public void setProd_name(String prod_name) {
		this.prod_name = prod_name;
	}

	public String getOpt_info() {
		return opt_info;
	}

	public void setOpt_info(String opt_info) {
		this.opt_info = opt_info;
	}

	public int getQty() {
		return qty;
	}

	public void setQty(int qty) {
		this.qty = qty;
	}
}