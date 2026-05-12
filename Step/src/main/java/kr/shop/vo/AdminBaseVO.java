package kr.shop.vo;

import java.util.Date;

public class AdminBaseVO {
	// 기타 및 검색
	private String keyword; // KEYWORD (검색어)
	private String search_type; // SEARCH_TYPE (검색 조건)
	private int start_row; // START_ROW (페이징 시작 로우)
	private int end_row; // END_ROW (페이징 끝 로우)

	public String getKeyword() {
		return keyword;
	}

	public void setKeyword(String keyword) {
		this.keyword = keyword;
	}

	public String getSearch_type() {
		return search_type;
	}

	public void setSearch_type(String search_type) {
		this.search_type = search_type;
	}

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

}