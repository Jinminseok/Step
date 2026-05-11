package kr.shop.vo;

import java.sql.Date;

public class UserCartVO {
	// 장바구니 테이블 
	private long cart_num;
	private long user_num;
	private long opt_num;
	private int cart_qty;
	private Date cart_created_at;
	
	// 상품 테이블 (출력)
	private int prod_num;			// 상품 번호
	private String prod_name;		// 상품명
	private int prod_price;			// 상품 가격
	private String prod_img_url;	// 대표 이미지
	private String brand_name;		// 브랜드명
	private String color;			// 선택한 색상
	private int size_val;			// 선택한 사이즈
	
	
	public long getCart_num() {
		return cart_num;
	}
	public void setCart_num(long cart_num) {
		this.cart_num = cart_num;
	}
	public long getUser_num() {
		return user_num;
	}
	public void setUser_num(long user_num) {
		this.user_num = user_num;
	}
	public long getOpt_num() {
		return opt_num;
	}
	public void setOpt_num(long opt_num) {
		this.opt_num = opt_num;
	}
	public int getCart_qty() {
		return cart_qty;
	}
	public void setCart_qty(int cart_qty) {
		this.cart_qty = cart_qty;
	}
	public Date getCart_created_at() {
		return cart_created_at;
	}
	public void setCart_created_at(Date cart_created_at) {
		this.cart_created_at = cart_created_at;
	}
	public int getProd_num() {
		return prod_num;
	}
	public void setProd_num(int prod_num) {
		this.prod_num = prod_num;
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
	public String getProd_img_url() {
		return prod_img_url;
	}
	public void setProd_img_url(String prod_img_url) {
		this.prod_img_url = prod_img_url;
	}
	public String getBrand_name() {
		return brand_name;
	}
	public void setBrand_name(String brand_name) {
		this.brand_name = brand_name;
	}
	public String getColor() {
		return color;
	}
	public void setColor(String color) {
		this.color = color;
	}
	public int getSize_val() {
		return size_val;
	}
	public void setSize_val(int size_val) {
		this.size_val = size_val;
	}
}
