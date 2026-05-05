package kr.shop.vo;

import java.sql.Date;

public class AdminVO {
	// 1. 계정
	private long user_num;
	private String user_id;
	private int auth;
	private String user_name;
	private String pwd;
	private String phone;
	private String email;
	private String zipcode;
	private String addr1;
	private String addr2;
	private int grade;
	private Date user_created_at;
	private Date user_updated_at;
	private Date last_login;

	// 2. 카테고리/브랜드
	private int cat_num;
	private String cat_name;
	private String cat_icon;
	private int cat_sort_no;
	private String cat_use_yn;
	private int brand_num;
	private String brand_name;
	private String brand_use_yn;

	// 3. 상품/옵션
	private int prod_num;
	private String sku;
	private String prod_name;
	private int gender;
	private int prod_price;
	private int sale_rate;
	private String prod_text;
	private int prod_status;
	private Date prod_created_at;
	private Date prod_updated_at;

	private int opt_num;
	private int size_val;
	private String color;
	private int add_price;
	private String prod_use_yn;

	private String prod_img_url; // 이미지 파일명 저장 필드
	private String is_main;
	private int prod_img_sort_no;

	// 4. 재고/물류
	private int stock_num;
	private int stock_qty;
	private int stock_min_qty;
	private Date stock_updated_at;
	private int in_qty;
	private String in_memo;
	private Date in_date;
	private int out_qty;
	private String out_memo;
	private long admin_num;

	// 5. 주문/배송/반품
	private int order_num;
	private int total_price;
	private int disc_price;
	private int pay_price;
	private int order_status;
	private String courier;
	private String invoice_no;
	private int dlv_status;
	private int ret_num;
	private int tp;
	private String reason;
	private int ret_status;
	private int is_good;
	private String ret_note;

	// 6. 기타 및 검색
	private int rating;
	private String review_content;
	private int room_status;
	private String msg_content;
	private int is_read;
	private int store_num;
	private String store_name;
	private String store_addred;
	private String open_time;

	private String keyword;
	private String search_type;
	private int start_row;
	private int end_row;

	public long getUser_num() {
		return user_num;
	}

	public void setUser_num(long user_num) {
		this.user_num = user_num;
	}

	public String getUser_id() {
		return user_id;
	}

	public void setUser_id(String user_id) {
		this.user_id = user_id;
	}

	public int getAuth() {
		return auth;
	}

	public void setAuth(int auth) {
		this.auth = auth;
	}

	public String getUser_name() {
		return user_name;
	}

	public void setUser_name(String user_name) {
		this.user_name = user_name;
	}

	public String getPwd() {
		return pwd;
	}

	public void setPwd(String pwd) {
		this.pwd = pwd;
	}

	public String getPhone() {
		return phone;
	}

	public void setPhone(String phone) {
		this.phone = phone;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getZipcode() {
		return zipcode;
	}

	public void setZipcode(String zipcode) {
		this.zipcode = zipcode;
	}

	public String getAddr1() {
		return addr1;
	}

	public void setAddr1(String addr1) {
		this.addr1 = addr1;
	}

	public String getAddr2() {
		return addr2;
	}

	public void setAddr2(String addr2) {
		this.addr2 = addr2;
	}

	public int getGrade() {
		return grade;
	}

	public void setGrade(int grade) {
		this.grade = grade;
	}

	public Date getUser_created_at() {
		return user_created_at;
	}

	public void setUser_created_at(Date user_created_at) {
		this.user_created_at = user_created_at;
	}

	public Date getUser_updated_at() {
		return user_updated_at;
	}

	public void setUser_updated_at(Date user_updated_at) {
		this.user_updated_at = user_updated_at;
	}

	public Date getLast_login() {
		return last_login;
	}

	public void setLast_login(Date last_login) {
		this.last_login = last_login;
	}

	public int getCat_num() {
		return cat_num;
	}

	public void setCat_num(int cat_num) {
		this.cat_num = cat_num;
	}

	public String getCat_name() {
		return cat_name;
	}

	public void setCat_name(String cat_name) {
		this.cat_name = cat_name;
	}

	public String getCat_icon() {
		return cat_icon;
	}

	public void setCat_icon(String cat_icon) {
		this.cat_icon = cat_icon;
	}

	public int getCat_sort_no() {
		return cat_sort_no;
	}

	public void setCat_sort_no(int cat_sort_no) {
		this.cat_sort_no = cat_sort_no;
	}

	public String getCat_use_yn() {
		return cat_use_yn;
	}

	public void setCat_use_yn(String cat_use_yn) {
		this.cat_use_yn = cat_use_yn;
	}

	public int getBrand_num() {
		return brand_num;
	}

	public void setBrand_num(int brand_num) {
		this.brand_num = brand_num;
	}

	public String getBrand_name() {
		return brand_name;
	}

	public void setBrand_name(String brand_name) {
		this.brand_name = brand_name;
	}

	public String getBrand_use_yn() {
		return brand_use_yn;
	}

	public void setBrand_use_yn(String brand_use_yn) {
		this.brand_use_yn = brand_use_yn;
	}

	public int getProd_num() {
		return prod_num;
	}

	public void setProd_num(int prod_num) {
		this.prod_num = prod_num;
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

	public int getGender() {
		return gender;
	}

	public void setGender(int gender) {
		this.gender = gender;
	}

	public int getProd_price() {
		return prod_price;
	}

	public void setProd_price(int prod_price) {
		this.prod_price = prod_price;
	}

	public int getSale_rate() {
		return sale_rate;
	}

	public void setSale_rate(int sale_rate) {
		this.sale_rate = sale_rate;
	}

	public String getProd_text() {
		return prod_text;
	}

	public void setProd_text(String prod_text) {
		this.prod_text = prod_text;
	}

	public int getProd_status() {
		return prod_status;
	}

	public void setProd_status(int prod_status) {
		this.prod_status = prod_status;
	}

	public Date getProd_created_at() {
		return prod_created_at;
	}

	public void setProd_created_at(Date prod_created_at) {
		this.prod_created_at = prod_created_at;
	}

	public Date getProd_updated_at() {
		return prod_updated_at;
	}

	public void setProd_updated_at(Date prod_updated_at) {
		this.prod_updated_at = prod_updated_at;
	}

	public int getOpt_num() {
		return opt_num;
	}

	public void setOpt_num(int opt_num) {
		this.opt_num = opt_num;
	}

	public int getSize_val() {
		return size_val;
	}

	public void setSize_val(int size_val) {
		this.size_val = size_val;
	}

	public String getColor() {
		return color;
	}

	public void setColor(String color) {
		this.color = color;
	}

	public int getAdd_price() {
		return add_price;
	}

	public void setAdd_price(int add_price) {
		this.add_price = add_price;
	}

	public String getProd_use_yn() {
		return prod_use_yn;
	}

	public void setProd_use_yn(String prod_use_yn) {
		this.prod_use_yn = prod_use_yn;
	}

	public String getProd_img_url() {
		return prod_img_url;
	}

	public void setProd_img_url(String prod_img_url) {
		this.prod_img_url = prod_img_url;
	}

	public String getIs_main() {
		return is_main;
	}

	public void setIs_main(String is_main) {
		this.is_main = is_main;
	}

	public int getProd_img_sort_no() {
		return prod_img_sort_no;
	}

	public void setProd_img_sort_no(int prod_img_sort_no) {
		this.prod_img_sort_no = prod_img_sort_no;
	}

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

	public long getAdmin_num() {
		return admin_num;
	}

	public void setAdmin_num(long admin_num) {
		this.admin_num = admin_num;
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

	public int getRating() {
		return rating;
	}

	public void setRating(int rating) {
		this.rating = rating;
	}

	public String getReview_content() {
		return review_content;
	}

	public void setReview_content(String review_content) {
		this.review_content = review_content;
	}

	public int getRoom_status() {
		return room_status;
	}

	public void setRoom_status(int room_status) {
		this.room_status = room_status;
	}

	public String getMsg_content() {
		return msg_content;
	}

	public void setMsg_content(String msg_content) {
		this.msg_content = msg_content;
	}

	public int getIs_read() {
		return is_read;
	}

	public void setIs_read(int is_read) {
		this.is_read = is_read;
	}

	public int getStore_num() {
		return store_num;
	}

	public void setStore_num(int store_num) {
		this.store_num = store_num;
	}

	public String getStore_name() {
		return store_name;
	}

	public void setStore_name(String store_name) {
		this.store_name = store_name;
	}

	public String getStore_addred() {
		return store_addred;
	}

	public void setStore_addred(String store_addred) {
		this.store_addred = store_addred;
	}

	public String getOpen_time() {
		return open_time;
	}

	public void setOpen_time(String open_time) {
		this.open_time = open_time;
	}

	public String getKeyword() {
		return keyword;
	}

	public void setKeyword(String keyword) {
		this.keyword = keyword;
	}

	public String getSearch_type() {
		return search_type;
	}

	public void setSearch_type(String search_type) {
		this.search_type = search_type;
	}

	public int getStart_row() {
		return start_row;
	}

	public void setStart_row(int start_row) {
		this.start_row = start_row;
	}

	public int getEnd_row() {
		return end_row;
	}

	public void setEnd_row(int end_row) {
		this.end_row = end_row;
	}

}