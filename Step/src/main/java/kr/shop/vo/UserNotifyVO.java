package kr.shop.vo;

import java.sql.Date;

public class UserNotifyVO {

    private int    notify_num;
    private int    user_num;
    private int    notify_type;
    private String notify_title;
    private String notify_content;
    private int    ref_id;
    private String read_yn;
    private Date   notify_created_at;
    private String formatted_date;

    // 관리자 목록에서 JOIN해서 쓰는 필드
    private String user_id;
    private String user_name;

    // 검색·페이징용
    private String keyword;
    private int    start_row;
    private int    end_row;

    public int getNotify_num() { return notify_num; }
    public void setNotify_num(int notify_num) { this.notify_num = notify_num; }

    public int getUser_num() { return user_num; }
    public void setUser_num(int user_num) { this.user_num = user_num; }

    public int getNotify_type() { return notify_type; }
    public void setNotify_type(int notify_type) { this.notify_type = notify_type; }

    public String getNotify_title() { return notify_title; }
    public void setNotify_title(String notify_title) { this.notify_title = notify_title; }

    public String getNotify_content() { return notify_content; }
    public void setNotify_content(String notify_content) { this.notify_content = notify_content; }

    public int getRef_id() { return ref_id; }
    public void setRef_id(int ref_id) { this.ref_id = ref_id; }

    public String getRead_yn() { return read_yn; }
    public void setRead_yn(String read_yn) { this.read_yn = read_yn; }

    public Date getNotify_created_at() { return notify_created_at; }
    public void setNotify_created_at(Date notify_created_at) { this.notify_created_at = notify_created_at; }

    public String getFormatted_date() { return formatted_date; }
    public void setFormatted_date(String formatted_date) { this.formatted_date = formatted_date; }

    public String getUser_id() { return user_id; }
    public void setUser_id(String user_id) { this.user_id = user_id; }

    public String getUser_name() { return user_name; }
    public void setUser_name(String user_name) { this.user_name = user_name; }

    public String getKeyword() { return keyword; }
    public void setKeyword(String keyword) { this.keyword = keyword; }

    public int getStart_row() { return start_row; }
    public void setStart_row(int start_row) { this.start_row = start_row; }

    public int getEnd_row() { return end_row; }
    public void setEnd_row(int end_row) { this.end_row = end_row; }
}