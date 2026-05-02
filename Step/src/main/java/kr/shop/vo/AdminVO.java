package kr.shop.vo;

import java.io.Serializable;
import java.sql.Timestamp;

public class AdminVO implements Serializable {

	private int prod_num;
	private int cat_num;
	private int brand_num;
	private String sku;
	private String prod_name; // DAO의 getName() 대신 getProd_name()으로 사용 권장
	private int prod_price;
	private int sale_rate; // DB 컬럼에 맞춰 추가
	private String prod_text;
	private int prod_status;
	private int gender; // int 타입으로 통일 (0:공용, 1:남, 2:여)
	private Timestamp reg_date;

	// 조인 및 이미지 처리를 위한 필드
	private String cat_name;
	private String brand_name;
	private int stock_qty;
	private String main_img_url; // DAO에서 product.getImg_url() 대신 이거 쓰도록 수정 필요

	public AdminVO() {
	}

	// Getter & Setter (이름 주의)
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

	public int getGender() {
		return gender;
	}

	public void setGender(int gender) {
		this.gender = gender;
	}

	public Timestamp getReg_date() {
		return reg_date;
	}

	public void setReg_date(Timestamp reg_date) {
		this.reg_date = reg_date;
	}

	public String getMain_img_url() {
		return main_img_url;
	}

	public void setMain_img_url(String main_img_url) {
		this.main_img_url = main_img_url;
	}

	// ... 나머지 cat_name, brand_name, stock_qty의 Getter/Setter는 기존과 동일
}