package kr.shop.vo;

import java.sql.Date;

public class UserWishListVO {
	// 찜 테이블
	private int wish_num;
	private long user_num;
	private int prod_num;
	private Date wish_created_at;
	
	// 상품 테이블(출력)
	private String prod_name;     // 상품명
	private int prod_price;       // 상품 가격
	private String prod_img_url;  // 대표 이미지
	private String brand_name;    // 브랜드명
	
	
	public int getWish_num() {
		return wish_num;
	}
	public void setWish_num(int wish_num) {
		this.wish_num = wish_num;
	}
	public long getUser_num() {
		return user_num;
	}
	public void setUser_num(long user_num) {
		this.user_num = user_num;
	}
	public int getProd_num() {
		return prod_num;
	}
	public void setProd_num(int prod_num) {
		this.prod_num = prod_num;
	}
	public Date getWish_created_at() {
		return wish_created_at;
	}
	public void setWish_created_at(Date wish_created_at) {
		this.wish_created_at = wish_created_at;
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
}
