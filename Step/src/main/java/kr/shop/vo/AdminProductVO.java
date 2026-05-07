package kr.shop.vo;

import java.util.Date;
import java.util.List;

public class AdminProductVO extends AdminBaseVO {
	private int prodNum;
	private int catNum;
	private int brandNum;
	private String sku;
	private String prodName;
	private int gender;
	private int prodPrice;
	private double saleRate;
	private String prodText;
	private int prodStatus;
	private Date prodCreatedAt;
	private Date prodUpdatedAt;

	// JOIN 결과물 및 관계 설정 필드
	private String catName;
	private String brandName;
	private String mainImgUrl; // 대표 이미지
	private List<AdminProdOptionVO> options; // 옵션 리스트

	public int getProdNum() {
		return prodNum;
	}

	public void setProdNum(int prodNum) {
		this.prodNum = prodNum;
	}

	public int getCatNum() {
		return catNum;
	}

	public void setCatNum(int catNum) {
		this.catNum = catNum;
	}

	public int getBrandNum() {
		return brandNum;
	}

	public void setBrandNum(int brandNum) {
		this.brandNum = brandNum;
	}

	public String getSku() {
		return sku;
	}

	public void setSku(String sku) {
		this.sku = sku;
	}

	public String getProdName() {
		return prodName;
	}

	public void setProdName(String prodName) {
		this.prodName = prodName;
	}

	public int getGender() {
		return gender;
	}

	public void setGender(int gender) {
		this.gender = gender;
	}

	public int getProdPrice() {
		return prodPrice;
	}

	public void setProdPrice(int prodPrice) {
		this.prodPrice = prodPrice;
	}

	public double getSaleRate() {
		return saleRate;
	}

	public void setSaleRate(double saleRate) {
		this.saleRate = saleRate;
	}

	public String getProdText() {
		return prodText;
	}

	public void setProdText(String prodText) {
		this.prodText = prodText;
	}

	public int getProdStatus() {
		return prodStatus;
	}

	public void setProdStatus(int prodStatus) {
		this.prodStatus = prodStatus;
	}

	public Date getProdCreatedAt() {
		return prodCreatedAt;
	}

	public void setProdCreatedAt(Date prodCreatedAt) {
		this.prodCreatedAt = prodCreatedAt;
	}

	public Date getProdUpdatedAt() {
		return prodUpdatedAt;
	}

	public void setProdUpdatedAt(Date prodUpdatedAt) {
		this.prodUpdatedAt = prodUpdatedAt;
	}

	public String getCatName() {
		return catName;
	}

	public void setCatName(String catName) {
		this.catName = catName;
	}

	public String getBrandName() {
		return brandName;
	}

	public void setBrandName(String brandName) {
		this.brandName = brandName;
	}

	public String getMainImgUrl() {
		return mainImgUrl;
	}

	public void setMainImgUrl(String mainImgUrl) {
		this.mainImgUrl = mainImgUrl;
	}

	public List<AdminProdOptionVO> getOptions() {
		return options;
	}

	public void setOptions(List<AdminProdOptionVO> options) {
		this.options = options;
	}

}