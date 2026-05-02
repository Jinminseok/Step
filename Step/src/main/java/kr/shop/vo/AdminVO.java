package kr.shop.vo;

import java.sql.Date;
import java.util.List;

public class AdminVO {

	// ==========================================
	// 1. PRODUCTS (상품 기본 정보)
	// ==========================================
	private int prod_num; // 상품 번호 (PK)
	private int cat_num; // 카테고리 번호 (FK)
	private int brand_num; // 브랜드 번호 (FK)
	private String sku; // 품번 (UK)
	private String prod_name; // 상품명
	private int gender; // 성별 (0:공용, 1:남자, 2:여자)
	private int prod_price; // 정가
	private int sale_rate; // 할인율
	private String prod_text; // 상품설명 (CLOB)
	private int prod_status; // 상태 (1:판매중, 2:숨김, 3:품절) - C-4 상품 숨김 처리용
	private Date prod_created_at; // 등록일
	private Date prod_updated_at; // 수정일

	// ==========================================
	// 2. CATEGORIES & BRANDS (카테고리/브랜드 관리)
	// ==========================================
	private String cat_name; // 카테고리명 (운동화, 샌들 등)
	private String cat_icon; // 카테고리 아이콘
	private int cat_sort_no; // 카테고리 정렬순서
	private String cat_use_yn; // 카테고리 사용여부
	private String brand_name; // 브랜드명
	private String brand_use_yn; // 브랜드 사용여부

	// ==========================================
	// 3. PROD_OPTIONS (상품 옵션 - 컬러/사이즈)
	// ==========================================
	private int opt_num; // 옵션 번호 (PK)
	private int size_val; // 사이즈 (230, 240 등)
	private String color; // 색상
	private int add_price; // 추가금액
	private String prod_use_yn; // 옵션 사용여부 (Y/N)

	// ==========================================
	// 4. PROD_IMGS (상품 이미지 관리)[cite: 6]
	// ==========================================
	private int prod_img_num; // 이미지 번호 (PK)
	private String prod_img_url; // 이미지 URL
	private String is_main; // 대표여부 (Y/N)
	private int prod_img_sort_no; // 이미지 정렬 순서

	// ==========================================
	// 5. REVIEWS (리뷰 관리 - C-4 요구사항)[cite: 5, 6]
	// ==========================================
	private int review_num; // 리뷰 번호
	private int user_num; // 작성자 회원 번호
	private int rating; // 별점 (1~5)
	private String review_content; // 리뷰 내용
	private int review_status; // 리뷰 상태 (1:정상, 2:삭제)

	// ==========================================
	// 6. 다중 데이터 처리를 위한 List 컬렉션
	// (하나의 상품에 여러 옵션과 이미지를 묶어서 처리할 때 유용함)
	// ==========================================
	private List<AdminVO> optionList; // 컬러, 사이즈 리스트
	private List<AdminVO> imageList; // 서브 이미지 리스트

	// === 기본 생성자 ===
	public AdminVO() {
	}

	// === Getter / Setter ===
	// (에디터 자동완성(Alt+Shift+S -> Generate Getters and Setters)으로 생성해서 쓰면 됨)

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

	public int getProd_img_num() {
		return prod_img_num;
	}

	public void setProd_img_num(int prod_img_num) {
		this.prod_img_num = prod_img_num;
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

	public int getReview_num() {
		return review_num;
	}

	public void setReview_num(int review_num) {
		this.review_num = review_num;
	}

	public int getUser_num() {
		return user_num;
	}

	public void setUser_num(int user_num) {
		this.user_num = user_num;
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

	public int getReview_status() {
		return review_status;
	}

	public void setReview_status(int review_status) {
		this.review_status = review_status;
	}

	public List<AdminVO> getOptionList() {
		return optionList;
	}

	public void setOptionList(List<AdminVO> optionList) {
		this.optionList = optionList;
	}

	public List<AdminVO> getImageList() {
		return imageList;
	}

	public void setImageList(List<AdminVO> imageList) {
		this.imageList = imageList;
	}
}