package kr.shop.vo;

import java.util.Date;

public class AdminOperationVO extends AdminBaseVO {
	// 리뷰
	private int reviewNum;
	private int rating;
	private String reviewContent;
	private int reviewStatus;

	// 배너
	private int bannerNum;
	private String bannerTitle;
	private String bannerImgUrl;
	private String bannerUseYn;

	// 매장
	private int storeNum;
	private String storeName;
	private String storeUseYn;

	public int getReviewNum() {
		return reviewNum;
	}

	public void setReviewNum(int reviewNum) {
		this.reviewNum = reviewNum;
	}

	public int getRating() {
		return rating;
	}

	public void setRating(int rating) {
		this.rating = rating;
	}

	public String getReviewContent() {
		return reviewContent;
	}

	public void setReviewContent(String reviewContent) {
		this.reviewContent = reviewContent;
	}

	public int getReviewStatus() {
		return reviewStatus;
	}

	public void setReviewStatus(int reviewStatus) {
		this.reviewStatus = reviewStatus;
	}

	public int getBannerNum() {
		return bannerNum;
	}

	public void setBannerNum(int bannerNum) {
		this.bannerNum = bannerNum;
	}

	public String getBannerTitle() {
		return bannerTitle;
	}

	public void setBannerTitle(String bannerTitle) {
		this.bannerTitle = bannerTitle;
	}

	public String getBannerImgUrl() {
		return bannerImgUrl;
	}

	public void setBannerImgUrl(String bannerImgUrl) {
		this.bannerImgUrl = bannerImgUrl;
	}

	public String getBannerUseYn() {
		return bannerUseYn;
	}

	public void setBannerUseYn(String bannerUseYn) {
		this.bannerUseYn = bannerUseYn;
	}

	public int getStoreNum() {
		return storeNum;
	}

	public void setStoreNum(int storeNum) {
		this.storeNum = storeNum;
	}

	public String getStoreName() {
		return storeName;
	}

	public void setStoreName(String storeName) {
		this.storeName = storeName;
	}

	public String getStoreUseYn() {
		return storeUseYn;
	}

	public void setStoreUseYn(String storeUseYn) {
		this.storeUseYn = storeUseYn;
	}

}