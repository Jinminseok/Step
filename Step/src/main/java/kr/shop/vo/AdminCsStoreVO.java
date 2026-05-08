package kr.shop.vo;

public class AdminCsStoreVO extends AdminBaseVO {
	// 6. 리뷰 (REVIEWS)
	private int rating; // RATING
	private String review_content; // REVIEW_CONTENT

	// 6. 채팅 (CHAT_ROOMS, CHAT_MSGS)
	private int room_status; // ROOM_STATUS
	private String msg_content; // MSG_CONTENT
	private int is_read; // IS_READ

	// 6. 매장 (STORES)
	private int store_num; // STORE_NUM
	private String store_name; // STORE_NAME
	private String store_addred; // STORE_ADDR (오타일 수 있으니 DB 확인 필요)
	private String open_time; // OPEN_TIME

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

	public int getRoom_status() {
		return room_status;
	}

	public void setRoom_status(int room_status) {
		this.room_status = room_status;
	}

	public String getMsg_content() {
		return msg_content;
	}

	public void setMsg_content(String msg_content) {
		this.msg_content = msg_content;
	}

	public int getIs_read() {
		return is_read;
	}

	public void setIs_read(int is_read) {
		this.is_read = is_read;
	}

	public int getStore_num() {
		return store_num;
	}

	public void setStore_num(int store_num) {
		this.store_num = store_num;
	}

	public String getStore_name() {
		return store_name;
	}

	public void setStore_name(String store_name) {
		this.store_name = store_name;
	}

	public String getStore_addred() {
		return store_addred;
	}

	public void setStore_addred(String store_addred) {
		this.store_addred = store_addred;
	}

	public String getOpen_time() {
		return open_time;
	}

	public void setOpen_time(String open_time) {
		this.open_time = open_time;
	}

}