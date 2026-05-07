package kr.shop.vo;

public class AdminBaseVO {
	// 페이징 처리
	private int start_row;
	private int end_row;

	// 검색 조건
	private String search_type;
	private String keyword;

	public int getStart_row() {
		return start_row;
	}

	public void setStart_row(int start_row) {
		this.start_row = start_row;
	}

	public int getEnd_row() {
		return end_row;
	}

	public void setEnd_row(int end_row) {
		this.end_row = end_row;
	}

	public String getSearch_type() {
		return search_type;
	}

	public void setSearch_type(String search_type) {
		this.search_type = search_type;
	}

	public String getKeyword() {
		return keyword;
	}

	public void setKeyword(String keyword) {
		this.keyword = keyword;
	}

}