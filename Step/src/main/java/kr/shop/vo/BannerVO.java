package kr.shop.vo;

public class BannerVO {
	private int banner_num;           // 배너 번호
    private String banner_title;      // 배너 제목
    private String banner_img_url;    // 배너 이미지명
    private String banner_link_url;   // 배너 링크 (안 쓰면 null)
    private int pos;                  // 배너 위치
    private int banner_sort_no;       // 노출 순서
    private String banner_start_day;  // 시작일
    private String banner_end_day;    // 종료일
    private String banner_use_yn;     // 노출 여부 (Y/N)
    private int prod_num;             // 연결 상품 번호
    
    private String prod_name;         // 조인해서 가져올 상품명

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

	public String getBanner_img_url() {
		return banner_img_url;
	}

	public void setBanner_img_url(String banner_img_url) {
		this.banner_img_url = banner_img_url;
	}

	public String getBanner_link_url() {
		return banner_link_url;
	}

	public void setBanner_link_url(String banner_link_url) {
		this.banner_link_url = banner_link_url;
	}

	public int getPos() {
		return pos;
	}

	public void setPos(int pos) {
		this.pos = pos;
	}

	public int getBanner_sort_no() {
		return banner_sort_no;
	}

	public void setBanner_sort_no(int banner_sort_no) {
		this.banner_sort_no = banner_sort_no;
	}

	public String getBanner_start_day() {
		return banner_start_day;
	}

	public void setBanner_start_day(String banner_start_day) {
		this.banner_start_day = banner_start_day;
	}

	public String getBanner_end_day() {
		return banner_end_day;
	}

	public void setBanner_end_day(String banner_end_day) {
		this.banner_end_day = banner_end_day;
	}

	public String getBanner_use_yn() {
		return banner_use_yn;
	}

	public void setBanner_use_yn(String banner_use_yn) {
		this.banner_use_yn = banner_use_yn;
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
    
    
}
