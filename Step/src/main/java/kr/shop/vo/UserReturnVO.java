package kr.shop.vo;

import java.sql.Date;

public class UserReturnVO {
    private int ret_num;        // 반품/교환 번호 (PK)
    private int order_num;      // 원주문 번호 (FK)
    private int user_num;       // 유저 번호 (FK)
    private int tp;             // 1: 반품, 2: 교환
    private String reason;      // 사유 (단순 변심 등)
    private int prod_num;       // 상품 번호
    private int opt_num;        // 옵션 번호
    private String ret_note;    // 상세 사유
    private int ret_status;     // 상태 (1:대기중, 2:수거중, 3:완료, 4:반려)
    private Date ret_created_at;// 신청일

    // --- DB 테이블엔 없지만 JSP 출력을 위해 조인으로 가져올 확장 필드 ---
    private String prod_name;   // 상품명
    private String prod_img_url;// 상품 메인 이미지 경로

    // Getter & Setter
    public int getRet_num() { return ret_num; }
    public void setRet_num(int ret_num) { this.ret_num = ret_num; }

    public int getOrder_num() { return order_num; }
    public void setOrder_num(int order_num) { this.order_num = order_num; }

    public int getUser_num() { return user_num; }
    public void setUser_num(int user_num) { this.user_num = user_num; }

    public int getTp() { return tp; }
    public void setTp(int tp) { this.tp = tp; }

    public String getReason() { return reason; }
    public void setReason(String reason) { this.reason = reason; }

    public int getProd_num() { return prod_num; }
    public void setProd_num(int prod_num) { this.prod_num = prod_num; }

    public int getOpt_num() { return opt_num; }
    public void setOpt_num(int opt_num) { this.opt_num = opt_num; }

    public String getRet_note() { return ret_note; }
    public void setRet_note(String ret_note) { this.ret_note = ret_note; }

    public int getRet_status() { return ret_status; }
    public void setRet_status(int ret_status) { this.ret_status = ret_status; }

    public Date getRet_created_at() { return ret_created_at; }
    public void setRet_created_at(Date ret_created_at) { this.ret_created_at = ret_created_at; }

    public String getProd_name() { return prod_name; }
    public void setProd_name(String prod_name) { this.prod_name = prod_name; }

    public String getProd_img_url() { return prod_img_url; }
    public void setProd_img_url(String prod_img_url) { this.prod_img_url = prod_img_url; }
}