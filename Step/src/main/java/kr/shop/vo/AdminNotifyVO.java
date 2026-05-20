package kr.shop.vo;

import java.sql.Date;

// AdminBaseVO를 상속받아 페이징(start_row, end_row) 및 검색(keyword, search_type 등) 필드를 활용함
public class AdminNotifyVO extends AdminBaseVO {

	private int notify_num;
	private int user_num;
	private int notify_type; // 1: 배송, 2: 재입고, 3: 공지
	private String notify_title;
	private String notify_content;
	private int ref_id;
	private String read_yn;
	private Date notify_created_at;

	// DB엔 없지만 JOIN해서 화면에 뿌려줄 때 필요한 추가 필드
	private String user_id;
	private String user_name;
	private String sku;
	private String prod_name;

	public int getNotify_num() {
		return notify_num;
	}

	public void setNotify_num(int notify_num) {
		this.notify_num = notify_num;
	}

	public int getUser_num() {
		return user_num;
	}

	public void setUser_num(int user_num) {
		this.user_num = user_num;
	}

	public int getNotify_type() {
		return notify_type;
	}

	public void setNotify_type(int notify_type) {
		this.notify_type = notify_type;
	}

	public String getNotify_title() {
		return notify_title;
	}

	public void setNotify_title(String notify_title) {
		this.notify_title = notify_title;
	}

	public String getNotify_content() {
		return notify_content;
	}

	public void setNotify_content(String notify_content) {
		this.notify_content = notify_content;
	}

	public int getRef_id() {
		return ref_id;
	}

	public void setRef_id(int ref_id) {
		this.ref_id = ref_id;
	}

	public String getRead_yn() {
		return read_yn;
	}

	public void setRead_yn(String read_yn) {
		this.read_yn = read_yn;
	}

	public Date getNotify_created_at() {
		return notify_created_at;
	}

	public void setNotify_created_at(Date notify_created_at) {
		this.notify_created_at = notify_created_at;
	}

	public String getUser_id() {
		return user_id;
	}

	public void setUser_id(String user_id) {
		this.user_id = user_id;
	}

	public String getUser_name() {
		return user_name;
	}

	public void setUser_name(String user_name) {
		this.user_name = user_name;
	}

	public String getSku() {
		return sku;
	}

	public void setSku(String sku) {
		this.sku = sku;
	}

	public String getProd_name() {
		return prod_name;
	}

	public void setProd_name(String prod_name) {
		this.prod_name = prod_name;
	}
}