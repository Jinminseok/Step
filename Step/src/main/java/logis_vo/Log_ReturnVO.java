package logis_vo;

public class Log_ReturnVO {
    // RETURNS (반품/교환 신청 테이블 기본 컬럼)
    private int ret_num;        // 접수 번호 (PK)
    private int order_num;      // 주문 번호
    private int prod_num;       // 상품 번호
    private int opt_num;        // 옵션 번호
    private int user_num;       // 유저 번호
    private int tp;             // 구분 (1:반품, 2:교환)
    private String reason;      // 신청 사유
    private String ret_note;    // 사용자 신청 메모 및 관리자 검수 메모 (특수문자 수용)
    private int ret_status;     // 상태 (1:접수대기, 2:검수중, 3:양품복구완료, 4:불량폐기완료)
    private String ret_created_at; // 신청 일자

    // 조인 컬럼 (주문자 배송지 정보 및 상품 정보 출력용)
    private String prod_name;   // 상품명
    private String recv_name;   // 수령인(주문자) 이름
    private String recv_phone;  // 수령인 연락처
    private String recv_addr;   // 수령인 반송 주소 (ADDR1 + ADDR2 결합)
    private String invoice_no;  // 교환 처리 시 재출고된 운송장 번호
    
    private String size_val;
    private String color;
    private String is_good_str; // 양품/불량 텍스트 저장용
    
    
	public String getSize_val() {
		return size_val;
	}
	public void setSize_val(String size_val) {
		this.size_val = size_val;
	}
	public String getColor() {
		return color;
	}
	public void setColor(String color) {
		this.color = color;
	}
	public String getIs_good_str() {
		return is_good_str;
	}
	public void setIs_good_str(String is_good_str) {
		this.is_good_str = is_good_str;
	}
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
	public String getRet_note() {
		return ret_note;
	}
	public void setRet_note(String ret_note) {
		this.ret_note = ret_note;
	}
	public int getRet_status() {
		return ret_status;
	}
	public void setRet_status(int ret_status) {
		this.ret_status = ret_status;
	}
	public String getRet_created_at() {
		return ret_created_at;
	}
	public void setRet_created_at(String ret_created_at) {
		this.ret_created_at = ret_created_at;
	}
	public String getProd_name() {
		return prod_name;
	}
	public void setProd_name(String prod_name) {
		this.prod_name = prod_name;
	}
	public String getRecv_name() {
		return recv_name;
	}
	public void setRecv_name(String recv_name) {
		this.recv_name = recv_name;
	}
	public String getRecv_phone() {
		return recv_phone;
	}
	public void setRecv_phone(String recv_phone) {
		this.recv_phone = recv_phone;
	}
	public String getRecv_addr() {
		return recv_addr;
	}
	public void setRecv_addr(String recv_addr) {
		this.recv_addr = recv_addr;
	}
	public String getInvoice_no() {
		return invoice_no;
	}
	public void setInvoice_no(String invoice_no) {
		this.invoice_no = invoice_no;
	}

    
}