package kr.shop.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import kr.shop.vo.UserReturnVO;
import kr.util.DBUtil;

public class UserReturnDAO {
    // 싱글톤 패턴
    private static UserReturnDAO instance = new UserReturnDAO();
    public static UserReturnDAO getInstance() { return instance; }
    private UserReturnDAO() {}

    //반품/교환 신청 처리
    public void insertReturnRequest(int orderNum, int userNum, int tp, String reason, String retNote) throws Exception {
        Connection conn = null;
        PreparedStatement pstmt1 = null;
        PreparedStatement pstmt2 = null;

        try {
            conn = DBUtil.getConnection();
            // 트랜잭션 시작 (둘 다 성공해야 커밋)
            conn.setAutoCommit(false);

                    
            String sql1 = "INSERT INTO RETURNS (RET_NUM, ORDER_NUM, USER_NUM, TP, REASON, PROD_NUM, OPT_NUM, RET_NOTE, RET_STATUS, RET_CREATED_AT) "
                       + "SELECT RETURNS_SEQ.NEXTVAL, oi.ORDER_NUM, ?, ?, ?, oi.PROD_NUM, oi.OPT_NUM, ?, 1, SYSDATE "
                       + "FROM ORDER_ITEMS oi "
                       + "WHERE oi.ORDER_NUM = ?";

            pstmt1 = conn.prepareStatement(sql1);
            pstmt1.setInt(1, userNum);
            pstmt1.setInt(2, tp);       
            pstmt1.setString(3, reason);
            pstmt1.setString(4, retNote);
            pstmt1.setInt(5, orderNum);
            pstmt1.executeUpdate();
            
          
            String sql2 = "UPDATE ORDERS SET ORDER_STATUS = 6 WHERE ORDER_NUM = ?";
            pstmt2 = conn.prepareStatement(sql2);
            pstmt2.setInt(1, orderNum);
            pstmt2.executeUpdate();

            
            conn.commit();
        } catch (Exception e) {            
            if (conn != null) conn.rollback();
            throw e;
        } finally {
            // 자원 해제 (연 순서의 역순으로)
            DBUtil.executeClose(null, pstmt2, null);
            DBUtil.executeClose(null, pstmt1, conn);
        }
    }
    
 //유저별 반품/교환 신청 내역 조회
    public List<UserReturnVO> getReturnListByUserNum(int userNum) throws Exception {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<UserReturnVO> list = null;
        
        String sql = "SELECT r.RET_NUM, r.ORDER_NUM, r.TP, r.REASON, r.RET_NOTE, r.RET_STATUS, r.OPT_NUM, "
                + "p.PROD_NAME, i.PROD_IMG_URL, "
                + "(SELECT SIZE_VAL || ' / ' || COLOR FROM PROD_OPTIONS WHERE OPT_NUM = r.OPT_NUM) AS OPT_INFO "
                + "FROM RETURNS r "
                + "LEFT OUTER JOIN PRODUCTS p ON r.PROD_NUM = p.PROD_NUM "
                + "LEFT OUTER JOIN PROD_IMGS i ON p.PROD_NUM = i.PROD_NUM AND i.IS_MAIN = 'Y' " 
                + "WHERE r.USER_NUM = ? "
                + "ORDER BY r.RET_NUM DESC";
                   
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, userNum);
            rs = pstmt.executeQuery();
            
            list = new ArrayList<UserReturnVO>();
            while (rs.next()) {
                UserReturnVO vo = new UserReturnVO();
                vo.setRet_num(rs.getInt("RET_NUM"));
                vo.setOrder_num(rs.getInt("ORDER_NUM"));
                vo.setTp(rs.getInt("TP"));
                vo.setReason(rs.getString("REASON"));
                vo.setRet_note(rs.getString("RET_NOTE"));
                vo.setRet_status(rs.getInt("RET_STATUS"));
                vo.setProd_name(rs.getString("PROD_NAME"));
                vo.setProd_img_url(rs.getString("PROD_IMG_URL"));
                vo.setOpt_info(rs.getString("OPT_INFO")); 
                
                list.add(vo);
            }
        } catch (Exception e) {
            throw e;
        } finally {
            DBUtil.executeClose(rs, pstmt, conn);
        }
        return list;
    }

    //반품/교환 신청 내용 수정 ──
    public void updateReturnRequest(UserReturnVO vo) throws Exception {
        Connection conn = null;
        PreparedStatement pstmt = null;
        
     
        String sql = "UPDATE RETURNS SET TP = ?, REASON = ?, RET_NOTE = ? "
                   + "WHERE RET_NUM = ? AND USER_NUM = ?";
                   
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, vo.getTp());
            pstmt.setString(2, vo.getReason());
            pstmt.setString(3, vo.getRet_note());
            pstmt.setInt(4, vo.getRet_num());
            pstmt.setInt(5, vo.getUser_num()); 
            pstmt.executeUpdate();
        } catch (Exception e) {
            throw e;
        } finally {
            DBUtil.executeClose(null, pstmt, conn);
        }
    }

    // 반품/교환 신청 취소 (삭제 및 주문상태 롤백)
    public void deleteReturnRequest(int retNum, int userNum) throws Exception {
        Connection conn = null;
        PreparedStatement pstmt1 = null;
        PreparedStatement pstmt2 = null;
        PreparedStatement pstmt3 = null;
        ResultSet rs = null;
        
        try {
            conn = DBUtil.getConnection();
            // 트랜잭션 시작 (조회 -> 삭제 -> 롤백)
            conn.setAutoCommit(false);
            
            //삭제할 반품 테이블에서 원주문 번호(ORDER_NUM) 먼저 알아내기
            int orderNum = 0;
            String sql1 = "SELECT ORDER_NUM FROM RETURNS WHERE RET_NUM = ? AND USER_NUM = ?";
            pstmt1 = conn.prepareStatement(sql1);
            pstmt1.setInt(1, retNum);
            pstmt1.setInt(2, userNum);
            rs = pstmt1.executeQuery();
            if (rs.next()) {
                orderNum = rs.getInt("ORDER_NUM");
            } else {
                throw new Exception("해당 반품/교환 내역을 찾을 수 없거나 권한이 없습니다.");
            }
            
            //반품/교환 신청 내역(RETURNS) 삭제
            String sql2 = "DELETE FROM RETURNS WHERE RET_NUM = ?";
            pstmt2 = conn.prepareStatement(sql2);
            pstmt2.setInt(1, retNum);
            pstmt2.executeUpdate();
            
            //ORDERS 테이블의 주문 상태를 6(처리중) -> 4(배송완료)로 복구
            String sql3 = "UPDATE ORDERS SET ORDER_STATUS = 4 WHERE ORDER_NUM = ?";
            pstmt3 = conn.prepareStatement(sql3);
            pstmt3.setInt(1, orderNum);
            pstmt3.executeUpdate();
            
            // 모든 작업 완료 시 커밋
            conn.commit();
        } catch (Exception e) {
            if (conn != null) conn.rollback();
            throw e;
        } finally {
            // 자원 해제
            DBUtil.executeClose(null, pstmt3, null);
            DBUtil.executeClose(null, pstmt2, null);
            DBUtil.executeClose(rs, pstmt1, conn);
        }
    }
    
}