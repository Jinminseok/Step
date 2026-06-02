package kr.shop.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import kr.shop.vo.AdminOrderVO;
import kr.util.DBUtil;

public class AdminReturnDAO {
    // 싱글톤 패턴
    private static AdminReturnDAO instance = new AdminReturnDAO();
    public static AdminReturnDAO getInstance() { return instance; }
    private AdminReturnDAO() {}

    //상단 대시보드용 현황판 카운트 조회 (통계)
    public Map<String, Integer> getReturnCounts() throws Exception {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        Map<String, Integer> counts = new HashMap<>();
        
        // 초기값 세팅 (NPE 방지)
        counts.put("pendingCount", 0);
        counts.put("processingCount", 0);
        counts.put("completedCount", 0);
        counts.put("rejectedCount", 0);
        counts.put("totalCount", 0);

        try {
            conn = DBUtil.getConnection();
            
            String sql = "SELECT "
                       + "  COUNT(CASE WHEN RET_STATUS = 1 THEN 1 END) as pending, "
                       + "  COUNT(CASE WHEN RET_STATUS = 2 THEN 1 END) as processing, "
                       + "  COUNT(CASE WHEN RET_STATUS = 3 THEN 1 END) as completed, "
                       + "  COUNT(CASE WHEN RET_STATUS = 4 THEN 1 END) as rejected, "
                       + "  COUNT(*) as total "
                       + "FROM RETURNS";
            
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                counts.put("pendingCount", rs.getInt("pending"));
                counts.put("processingCount", rs.getInt("processing"));
                counts.put("completedCount", rs.getInt("completed"));
                counts.put("rejectedCount", rs.getInt("rejected"));
                counts.put("totalCount", rs.getInt("total"));
            }
        } catch (Exception e) {
            e.printStackTrace();
            throw new Exception(e);
        } finally {
            DBUtil.executeClose(rs, pstmt, conn);
        }
        return counts;
    }

    //관리자 반품/교환 검색 및 필터링 리스트 조회
    public List<AdminOrderVO> getAdminReturnList(String sTp, String sStatus, String sKeywordType, String sKeyword) throws Exception {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<AdminOrderVO> list = new ArrayList<>();

        try {
            conn = DBUtil.getConnection();
            
            // 기본 동적 쿼리 베이스 작성 (상품명 가져오기 위해 PRODUCTS 조인)
            String sql = "SELECT r.*, p.PROD_NAME "
                       + "FROM RETURNS r "
                       + "JOIN PRODUCTS p ON r.PROD_NUM = p.PROD_NUM "
                       + "WHERE 1=1 ";

            //유형 검색 (1: 반품, 2: 교환)
            if (sTp != null && !sTp.equals("ALL") && !sTp.trim().isEmpty()) {
                sql += " AND r.TP = " + Integer.parseInt(sTp);
            }
            //처리상태 검색 (1: 신청대기, 2: 수거진행, 3: 완료, 4: 반려)
            if (sStatus != null && !sStatus.equals("ALL") && !sStatus.trim().isEmpty()) {
                sql += " AND r.RET_STATUS = " + Integer.parseInt(sStatus);
            }
            //키워드 검색 (주문번호, 회원번호, 클레임 사유)
            if (sKeyword != null && !sKeyword.trim().isEmpty()) {
                if (sKeywordType.equals("orderNum")) {
                    sql += " AND r.ORDER_NUM = ? ";
                } else if (sKeywordType.equals("userNum")) {
                    sql += " AND r.USER_NUM = ? ";
                } else if (sKeywordType.equals("reason")) {
                    sql += " AND r.REASON LIKE ? ";
                }
            }
            
            // 최신 신청일 순 정렬
            sql += " ORDER BY r.RET_NUM DESC";

            pstmt = conn.prepareStatement(sql);
            
            // 동적 쿼리 파라미터 바인딩 (? 매핑 처리)
            if (sKeyword != null && !sKeyword.trim().isEmpty()) {
                if (sKeywordType.equals("orderNum") || sKeywordType.equals("userNum")) {
                    pstmt.setInt(1, Integer.parseInt(sKeyword));
                } else if (sKeywordType.equals("reason")) {
                    pstmt.setString(1, "%" + sKeyword + "%");
                }
            }

            rs = pstmt.executeQuery();
            while (rs.next()) {
                AdminOrderVO item = new AdminOrderVO();
                item.setRet_num(rs.getInt("RET_NUM"));
                item.setOrder_num(rs.getInt("ORDER_NUM"));
                item.setUser_num(rs.getInt("USER_NUM"));
                item.setTp(rs.getInt("TP"));
                item.setReason(rs.getString("REASON"));
                item.setRet_status(rs.getInt("RET_STATUS"));
                item.setIs_good(rs.getInt("IS_GOOD"));
                item.setRet_note(rs.getString("RET_NOTE"));
                item.setProd_name(rs.getString("PROD_NAME"));
                // 날짜 포맷팅을 편하게 하기 위해 컬럼 문자열 바인딩 기법 사용
                item.setRet_created_at(rs.getDate("RET_CREATED_AT"));
                
                list.add(item);
            }
        } catch (Exception e) {
            e.printStackTrace();
            throw new Exception(e);
        } finally {
            DBUtil.executeClose(rs, pstmt, conn);
        }
        return list;
    }

    //모달창 비동기(Fetch) 호출용: 단건 상세조회
    public AdminOrderVO getReturnDetail(int retNum) throws Exception {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        AdminOrderVO item = null;

        try {
            conn = DBUtil.getConnection();
            String sql = "SELECT r.*, p.PROD_NAME "
                       + "FROM RETURNS r "
                       + "JOIN PRODUCTS p ON r.PROD_NUM = p.PROD_NUM "
                       + "WHERE r.RET_NUM = ?";
            
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, retNum);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                item = new AdminOrderVO();
                item.setRet_num(rs.getInt("RET_NUM"));
                item.setOrder_num(rs.getInt("ORDER_NUM"));
                item.setUser_num(rs.getInt("USER_NUM"));
                item.setTp(rs.getInt("TP"));
                item.setReason(rs.getString("REASON"));
                item.setRet_status(rs.getInt("RET_STATUS"));
                item.setIs_good(rs.getInt("IS_GOOD"));
                item.setRet_note(rs.getString("RET_NOTE")); 
                item.setProd_name(rs.getString("PROD_NAME"));
            }
        } catch (Exception e) {
            e.printStackTrace();
            throw new Exception(e);
        } finally {
            DBUtil.executeClose(rs, pstmt, conn);
        }
        return item;
    }

    //관리자 심사 결과 업데이트 처리 (확정 저장) 
    public void updateReturnStatus(int retNum, int retStatus, int isGood, String retNote) throws Exception {
        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = DBUtil.getConnection();
           
            String sql = "UPDATE RETURNS SET "
                       + "  RET_STATUS = ?, "
                       + "  IS_GOOD = ?, "
                       + "  RET_NOTE = ?, "
                       + "  RET_UPDATED_AT = SYSDATE "
                       + "WHERE RET_NUM = ?";
            
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, retStatus);
            pstmt.setInt(2, isGood);
            pstmt.setString(3, retNote);
            pstmt.setInt(4, retNum);
            
            pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
            throw new Exception(e);
        } finally {
            DBUtil.executeClose(null, pstmt, conn);
        }
    }
    
    public List<AdminOrderVO> getAdminReturnList(String sTp, String sStatus, String sKeywordType, String sKeyword, String startDate, String endDate) throws Exception {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<AdminOrderVO> list = new ArrayList<>();

        try {
            conn = DBUtil.getConnection();
            
            String sql = "SELECT r.*, p.PROD_NAME "
                       + "FROM RETURNS r "
                       + "JOIN PRODUCTS p ON r.PROD_NUM = p.PROD_NUM "
                       + "WHERE 1=1 ";

            //유형 검색
            if (sTp != null && !sTp.equals("ALL") && !sTp.trim().isEmpty()) {
                sql += " AND r.TP = " + Integer.parseInt(sTp);
            }
            //처리상태 검색
            if (sStatus != null && !sStatus.equals("ALL") && !sStatus.trim().isEmpty()) {
                sql += " AND r.RET_STATUS = " + Integer.parseInt(sStatus);
            }
            //키워드 검색
            if (sKeyword != null && !sKeyword.trim().isEmpty()) {
                if (sKeywordType.equals("orderNum")) {
                    sql += " AND r.ORDER_NUM = ? ";
                } else if (sKeywordType.equals("userNum")) {
                    sql += " AND r.USER_NUM = ? ";
                } else if (sKeywordType.equals("reason")) {
                    sql += " AND r.REASON LIKE ? ";
                }
            }
          
            if (startDate != null && !startDate.trim().isEmpty()) {
                sql += " AND r.RET_CREATED_AT >= TO_DATE(?, 'YYYY-MM-DD') ";
            }
            if (endDate != null && !endDate.trim().isEmpty()) {
                sql += " AND r.RET_CREATED_AT <= TO_DATE(?, 'YYYY-MM-DD') + 1 ";
            }
            
            sql += " ORDER BY r.RET_NUM DESC";

            pstmt = conn.prepareStatement(sql);
            
            //동적 파라미터 세팅 처리용 인덱스 카운터
            int paramIdx = 1;
            
            if (sKeyword != null && !sKeyword.trim().isEmpty()) {
                if (sKeywordType.equals("orderNum") || sKeywordType.equals("userNum")) {
                    pstmt.setInt(paramIdx++, Integer.parseInt(sKeyword));
                } else if (sKeywordType.equals("reason")) {
                    pstmt.setString(paramIdx++, "%" + sKeyword + "%");
                }
            }
            //날짜 파라미터 동적 바인딩
            if (startDate != null && !startDate.trim().isEmpty()) {
                pstmt.setString(paramIdx++, startDate);
            }
            if (endDate != null && !endDate.trim().isEmpty()) {
                pstmt.setString(paramIdx++, endDate);
            }

            rs = pstmt.executeQuery();
            while (rs.next()) {
                AdminOrderVO item = new AdminOrderVO();
                item.setRet_num(rs.getInt("RET_NUM"));
                item.setOrder_num(rs.getInt("ORDER_NUM"));
                item.setUser_num(rs.getInt("USER_NUM"));
                item.setTp(rs.getInt("TP"));
                item.setReason(rs.getString("REASON"));
                item.setRet_status(rs.getInt("RET_STATUS"));
                item.setIs_good(rs.getInt("IS_GOOD"));
                item.setRet_note(rs.getString("RET_NOTE"));
                item.setProd_name(rs.getString("PROD_NAME"));
                item.setRet_created_at(rs.getDate("RET_CREATED_AT"));
                
                list.add(item);
            }
        } catch (Exception e) {
            e.printStackTrace();
            throw new Exception(e);
        } finally {
            DBUtil.executeClose(rs, pstmt, conn);
        }
        return list;
    }
    
}