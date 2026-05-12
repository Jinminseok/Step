package kr.shop.vo;

import java.util.Date;

public class AdminProductVO extends AdminBaseVO {
	// 상품 (PRODUCTS)
	private int prod_num; // PROD_NUM
	private String sku; // SKU
	private String prod_name; // PROD_NAME
	private int gender; // GENDER
	private int prod_price; // PROD_PRICE
	private int sale_rate; // SALE_RATE
	private String prod_text; // PROD_TEXT
	private int prod_status; // PROD_STATUS
	private Date prod_created_at; // PROD_CREATED_AT
	private Date prod_updated_at; // PROD_UPDATED_AT

	// 상품 옵션 (PROD_OPTIONS)
	private int opt_num; // OPT_NUM
	private int size_val; // SIZE_VAL
	private String color; // COLOR
	private int add_price; // ADD_PRICE
	private String prod_use_yn; // PROD_USE_YN

	// 상품 이미지 (PROD_IMGS)
	private String prod_img_url; // PROD_IMG_URL
	private String is_main; // IS_MAIN
	private int prod_img_sort_no; // PROD_IMG_SORT_NO

	// 카테고리 (CATEGORIES)
	private int cat_num; // CAT_NUM
	private String cat_name; // CAT_NAME
	private String cat_icon; // CAT_ICON
	private int cat_sort_no; // CAT_SORT_NO
	private String cat_use_yn; // CAT_USE_YN

	// 브랜드 (BRANDS)
	private int brand_num; // BRAND_NUM
	private String brand_name; // BRAND_NAME
	private String brand_use_yn; // BRAND_USE_YN

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

}
