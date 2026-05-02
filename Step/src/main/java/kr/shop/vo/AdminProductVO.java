package kr.shop.vo; // 패키지 경로는 프로젝트에 맞춰 수정

import java.sql.Date;

public class AdminProductVO {
	// --- DB 테이블 필드 (PK, FK 및 기본 정보) ---
	private int prod_num; // 상품 번호 (PK)
	private int cat_num; // 카테고리 번호 (FK)
	private int brand_num; // 브랜드 번호 (FK)
	private int opt_num; // 옵션 번호 (FK)
	private int img_num; // 이미지 번호 (FK)
	private String sku; // 품번
	private String name; // 상품명 (PROD_NAME)
	private int gender; // 성별 (0:공용, 1:남, 2:여)
	private int price; // 가격 (PROD_PRICE)
	private int sale_rate; // 할인율
	private String prod_text; // 상품 설명
	private int status; // 상태 (1:판매중, 2:품절, 3:숨김)
	private Date prod_created_at; // 등록일
	private Date prod_updated_at; // 수정일

	// --- JOIN 또는 목록 출력용 추가 필드 ---
	private String cat_name; // 카테고리 이름 (JOIN 결과 저장용)
	private String brand_name; // 브랜드 이름 (JOIN 결과 저장용)
	private String upload_img; // 이미지 파일명 (실제 출력용)

	// 기본 생성자
	public AdminProductVO() {
	}

	// --- Getter and Setter ---

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

	public int getOpt_num() {
		return opt_num;
	}

	public void setOpt_num(int opt_num) {
		this.opt_num = opt_num;
	}

	public int getImg_num() {
		return img_num;
	}

	public void setImg_num(int img_num) {
		this.img_num = img_num;
	}

	public String getSku() {
		return sku;
	}

	public void setSku(String sku) {
		this.sku = sku;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public int getGender() {
		return gender;
	}

	public void setGender(int gender) {
		this.gender = gender;
	}

	public int getPrice() {
		return price;
	}

	public void setPrice(int price) {
		this.price = price;
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

	public int getStatus() {
		return status;
	}

	public void setStatus(int status) {
		this.status = status;
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

	public String getBrand_name() {
		return brand_name;
	}

	public void setBrand_name(String brand_name) {
		this.brand_name = brand_name;
	}

	public String getUpload_img() {
		return upload_img;
	}

	public void setUpload_img(String upload_img) {
		this.upload_img = upload_img;
	}
}