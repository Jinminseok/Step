package kr.shop.vo;

import java.io.Serializable;
import java.sql.Timestamp;
import java.util.List; // 다중 처리를 위해 추가

/**
 * 관리자 상품 관리 통합 VO 목록 조회 및 '다중 옵션/이미지 등록' 기능을 모두 지원하도록 개선
 */
public class AdminVO implements Serializable {
	private static final long serialVersionUID = 1L;

	// --- PRODUCTS 테이블 필드 (상품 기본 정보) ---
	private int prod_num;
	private int cat_num;
	private int brand_num;
	private String sku;
	private String prod_name;
	private int gender; // 0:공용, 1:남, 2:여
	private int prod_price;
	private int sale_rate;
	private String prod_text;
	private int prod_status; // 1:판매중, 2:숨김, 3:품절
	private Timestamp prod_created_at;
	private Timestamp prod_updated_at;

	// --- [개선] 다중 데이터 등록을 위한 리스트 필드 ---
	// 상품 등록 시 JSP에서 여러 개의 옵션과 이미지를 한 번에 넘겨받을 때 사용함
	private List<AdminVO> optionList; // 사이즈, 색상, 추가금액, 재고 수량 묶음
	private List<String> imageList; // 추가 이미지 경로들

	// --- PROD_IMGS 테이블 필드 (대표 이미지 정보)[cite: 2] ---
	private String prod_img_url;
	private String is_main; // Y:대표, N:일반

	// --- PROD_OPTIONS & STOCK 테이블 필드 (단일 조회 및 등록용)[cite: 2] ---
	private int opt_num;
	private int size_val;
	private String color;
	private int add_price;
	private int stock_qty; // 현재 가용 재고[cite: 2]
	private int stock_min_qty; // 재고 부족 알림 기준

	// --- JOIN 부가 정보 필드 ---
	private String cat_name;
	private String brand_name;

	public AdminVO() {
	}

	// --- Getter & Setter ---
	public int getProd_num() {
		return prod_num;
	}

	public void setProd_num(int prod_num) {
		this.prod_num = prod_num;
	}

	public int getCat_num() {
		return cat_num;
	}

	public void setCat_num(int cat_num) {
		this.cat_num = cat_num;
	}

	public int getBrand_num() {
		return brand_num;
	}

	public void setBrand_num(int brand_num) {
		this.brand_num = brand_num;
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

	public Timestamp getProd_created_at() {
		return prod_created_at;
	}

	public void setProd_created_at(Timestamp prod_created_at) {
		this.prod_created_at = prod_created_at;
	}

	public List<AdminVO> getOptionList() {
		return optionList;
	}

	public void setOptionList(List<AdminVO> optionList) {
		this.optionList = optionList;
	}

	public List<String> getImageList() {
		return imageList;
	}

	public void setImageList(List<String> imageList) {
		this.imageList = imageList;
	}

	public String getProd_img_url() {
		return prod_img_url;
	}

	public void setProd_img_url(String prod_img_url) {
		this.prod_img_url = prod_img_url;
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

	public String getCat_name() {
		return cat_name;
	}

	public void setCat_name(String cat_name) {
		this.cat_name = cat_name;
	}

	public String getBrand_name() {
		return brand_name;
	}

	public void setBrand_name(String brand_name) {
		this.brand_name = brand_name;
	}
}