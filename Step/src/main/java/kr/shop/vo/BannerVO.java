package kr.shop.vo;

public class BannerVO {
	private int banner_num;        // 배너 번호
    private String banner_title;   // 배너 제목(명칭)
    private String banner_img;     // 배너 이미지 파일명
    private int prod_num;          // 연결할 상품 번호
    private int banner_order;      // 노출 순서
    private String banner_status;  // 노출 상태 (Y/N)
    
    // 조인용 (화면에 상품명 뿌려주기 위함)
    private String prod_name;

	public int getBanner_num() {
		return banner_num;
	}

	public void setBanner_num(int banner_num) {
		this.banner_num = banner_num;
	}

	public String getBanner_title() {
		return banner_title;
	}

	public void setBanner_title(String banner_title) {
		this.banner_title = banner_title;
	}

	public String getBanner_img() {
		return banner_img;
	}

	public void setBanner_img(String banner_img) {
		this.banner_img = banner_img;
	}

	public int getProd_num() {
		return prod_num;
	}

	public void setProd_num(int prod_num) {
		this.prod_num = prod_num;
	}

	public int getBanner_order() {
		return banner_order;
	}

	public void setBanner_order(int banner_order) {
		this.banner_order = banner_order;
	}

	public String getBanner_status() {
		return banner_status;
	}

	public void setBanner_status(String banner_status) {
		this.banner_status = banner_status;
	}

	public String getProd_name() {
		return prod_name;
	}

	public void setProd_name(String prod_name) {
		this.prod_name = prod_name;
	}
    
}
