package logis.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import kr.util.DBUtil;
import logis_vo.Log_InVO;

public class Log_InDAO {

    private static Log_InDAO instance = new Log_InDAO();
    public static Log_InDAO getInstance() { return instance; }
    private Log_InDAO() {}

    //입고 내역 저장 (INBOUND INSERT → 트리거가 STOCK 자동 증가)
    public void insertInbound(int optNum, int prodNum, int inQty, int adminNum,
                              String inMemo, String inDate, String supplier) throws Exception {
        Connection conn = null; PreparedStatement pstmt = null;
        String sql = "INSERT INTO INBOUND (IN_NUM, OPT_NUM, PROD_NUM, IN_QTY, ADMIN_NUM, IN_MEMO, IN_DATE, IN_CREATED_AT, SUPPLIER) "
                   + "VALUES (INBOUND_SEQ.NEXTVAL, ?, ?, ?, ?, ?, TO_DATE(?, 'YYYY-MM-DD'), SYSDATE, ?)";
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, optNum);
            pstmt.setInt(2, prodNum);
            pstmt.setInt(3, inQty);
            pstmt.setInt(4, adminNum);
            pstmt.setString(5, inMemo);
            pstmt.setString(6, inDate);
            pstmt.setString(7, supplier);
            pstmt.executeUpdate();
            //STOCK 처리 불필요: TRG_INBOUND_INSERT 트리거가 자동 처리
        } catch (Exception e) {
            e.printStackTrace();
            throw new Exception("입고 내역 저장 중 오류 발생", e);
        } finally {
            DBUtil.executeClose(null, pstmt, conn);
        }
    }

    //재고 수량 업데이트 - 트리거 적용 후 호출 불필요 (하위 호환성 유지용)
    public void updateStock(int optNum, int prodNum, int inQty) throws Exception {
        
    }

    //상품번호 + 사이즈 + 컬러로 기존 옵션번호(OPT_NUM) 찾기
    public int getOptNum(int prodNum, int sizeVal, String color) throws Exception {
        Connection conn = null; PreparedStatement pstmt = null; ResultSet rs = null;
        int optNum = 0;
        String sql = "SELECT OPT_NUM FROM PROD_OPTIONS WHERE PROD_NUM=? AND SIZE_VAL=? AND COLOR=?";
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, prodNum);
            pstmt.setInt(2, sizeVal);
            pstmt.setString(3, color);
            rs = pstmt.executeQuery();
            if (rs.next()) optNum = rs.getInt("OPT_NUM");
        } catch (Exception e) {
            e.printStackTrace();
            throw new Exception("옵션 번호 조회 중 오류 발생", e);
        } finally {
            DBUtil.executeClose(rs, pstmt, conn);
        }
        return optNum;
    }

    //새로운 옵션 생성 후 옵션번호(OPT_NUM) 반환
    public int insertOptionAndGetNum(int prodNum, int sizeVal, String color) throws Exception {
        int optNum = 0;
        Connection conn = null; PreparedStatement pstmt = null; ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();

            String maxSql = "SELECT NVL(MAX(OPT_NUM), 0) FROM PROD_OPTIONS";
            pstmt = conn.prepareStatement(maxSql);
            rs = pstmt.executeQuery();
            int maxNum = 0;
            if (rs.next()) maxNum = rs.getInt(1);
            DBUtil.executeClose(rs, pstmt, null);

            int safeSeq = 0;
            String seqSql = "SELECT PROD_OPTIONS_SEQ.NEXTVAL FROM DUAL";
            pstmt = conn.prepareStatement(seqSql);
            while (true) {
                rs = pstmt.executeQuery();
                if (rs.next()) safeSeq = rs.getInt(1);
                rs.close();
                if (safeSeq > maxNum) break;
            }
            DBUtil.executeClose(null, pstmt, null);

            String sql = "INSERT INTO PROD_OPTIONS (OPT_NUM, PROD_NUM, SIZE_VAL, COLOR, ADD_PRICE, PROD_USE_YN) "
                       + "VALUES (?, ?, ?, ?, 0, 'Y')";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, safeSeq);
            pstmt.setInt(2, prodNum);
            pstmt.setInt(3, sizeVal);
            pstmt.setString(4, color);
            int count = pstmt.executeUpdate();
            if (count > 0) optNum = safeSeq;
        } catch (Exception e) {
            e.printStackTrace();
            throw new Exception("옵션 생성 중 오류 발생 : " + e.getMessage());
        } finally {
            DBUtil.executeClose(rs, pstmt, conn);
        }
        return optNum;
    }

    //입고 목록 조회
    public List<Log_InVO> getInboundList() throws Exception {
        Connection conn = null; PreparedStatement pstmt = null; ResultSet rs = null;
        List<Log_InVO> list = new ArrayList<>();
        String sql = "SELECT I.IN_NUM, "
                + "TO_CHAR(I.IN_DATE, 'YYYY-MM-DD') || ' ' || TO_CHAR(I.IN_CREATED_AT, 'HH24:MI:SS') AS IN_DATE, "
                + "I.IN_QTY, I.IN_MEMO, I.SUPPLIER, I.IN_STATUS, "
                + "P.SKU, P.PROD_NAME, B.BRAND_NAME, O.SIZE_VAL, O.COLOR, "
                + "NVL(U.USER_NAME, '관리자') AS ADMIN_NAME "
                + "FROM INBOUND I "
                + "JOIN PRODUCTS P ON I.PROD_NUM = P.PROD_NUM "
                + "JOIN BRANDS B ON P.BRAND_NUM = B.BRAND_NUM "
                + "JOIN PROD_OPTIONS O ON I.OPT_NUM = O.OPT_NUM "
                + "LEFT JOIN USERS_DETAIL U ON I.ADMIN_NUM = U.USER_NUM "
                + "ORDER BY I.IN_NUM DESC";
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                Log_InVO vo = new Log_InVO();
                vo.setInNum(rs.getInt("IN_NUM"));
                vo.setInDate(rs.getString("IN_DATE"));
                vo.setInQty(rs.getInt("IN_QTY"));
                vo.setInStatus(rs.getInt("IN_STATUS"));
                vo.setSku(rs.getString("SKU"));
                vo.setProdName(rs.getString("PROD_NAME"));
                vo.setBrandName(rs.getString("BRAND_NAME"));
                vo.setSizeVal(rs.getInt("SIZE_VAL"));
                vo.setColor(rs.getString("COLOR"));
                vo.setUserName(rs.getString("ADMIN_NAME"));
                vo.setSupplier(rs.getString("SUPPLIER"));
                vo.setInMemo(rs.getString("IN_MEMO"));
                list.add(vo);
            }
        } catch (Exception e) {
            e.printStackTrace();
            throw new Exception("입고 목록 조회 중 오류 발생", e);
        } finally {
            DBUtil.executeClose(rs, pstmt, conn);
        }
        return list;
    }

    //상품 검색 목록
    public List<Log_InVO> getProductListForSearch() throws Exception {
        Connection conn = null; PreparedStatement pstmt = null; ResultSet rs = null;
        List<Log_InVO> list = new ArrayList<>();
        String sql = "SELECT P.PROD_NUM, P.SKU, P.PROD_NAME, B.BRAND_NAME "
                   + "FROM PRODUCTS P JOIN BRANDS B ON P.BRAND_NUM = B.BRAND_NUM";
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                Log_InVO vo = new Log_InVO();
                vo.setProdNum(rs.getInt("PROD_NUM"));
                vo.setSku(rs.getString("SKU"));
                vo.setProdName(rs.getString("PROD_NAME"));
                vo.setBrandName(rs.getString("BRAND_NAME"));
                list.add(vo);
            }
        } finally {
            DBUtil.executeClose(rs, pstmt, conn);
        }
        return list;
    }

    //입고 수정 (INBOUND UPDATE → 트리거가 STOCK 자동 보정)
    public void updateInbound(Log_InVO vo) throws Exception {
        Connection conn = null; PreparedStatement pstmt = null;
        try {
            conn = DBUtil.getConnection();

            // 새 옵션번호 조회
            String optSql = "SELECT OPT_NUM FROM PROD_OPTIONS "
                          + "WHERE PROD_NUM = (SELECT PROD_NUM FROM INBOUND WHERE IN_NUM = ?) "
                          + "  AND SIZE_VAL = ? AND COLOR = ?";
            PreparedStatement optStmt = conn.prepareStatement(optSql);
            optStmt.setInt(1, vo.getInNum());
            optStmt.setInt(2, vo.getSizeVal());
            optStmt.setString(3, vo.getColor());
            ResultSet optRs = optStmt.executeQuery();

            // 기존 OPT_NUM 조회 (옵션 못 찾으면 기존 유지)
            String oldOptSql = "SELECT OPT_NUM FROM INBOUND WHERE IN_NUM = ?";
            PreparedStatement oldOptStmt = conn.prepareStatement(oldOptSql);
            oldOptStmt.setInt(1, vo.getInNum());
            ResultSet oldOptRs = oldOptStmt.executeQuery();
            int oldOptNum = 0;
            if (oldOptRs.next()) oldOptNum = oldOptRs.getInt("OPT_NUM");
            oldOptRs.close(); oldOptStmt.close();

            int newOptNum = oldOptNum;
            if (optRs.next()) newOptNum = optRs.getInt("OPT_NUM");
            optRs.close(); optStmt.close();

            // INBOUND UPDATE (트리거 TRG_INBOUND_UPDATE가 STOCK 자동 보정)
            String sql = "UPDATE INBOUND SET "
                       + "  IN_DATE   = TO_DATE(?, 'YYYY-MM-DD'), "
                       + "  IN_QTY    = ?, "
                       + "  IN_STATUS = ?, "
                       + "  SUPPLIER  = ?, "
                       + "  IN_MEMO   = ?, "
                       + "  OPT_NUM   = ? "
                       + "WHERE IN_NUM = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, vo.getInDate());
            pstmt.setInt   (2, vo.getInQty());
            pstmt.setInt   (3, vo.getInStatus());
            pstmt.setString(4, vo.getSupplier());
            pstmt.setString(5, vo.getInMemo());
            pstmt.setInt   (6, newOptNum);
            pstmt.setInt   (7, vo.getInNum());
            pstmt.executeUpdate();
            //STOCK 처리 불필요: TRG_INBOUND_UPDATE 트리거가 자동 처리

        } catch (Exception e) {
            e.printStackTrace();
            throw new Exception("입고 내역 수정 중 오류 발생", e);
        } finally {
            DBUtil.executeClose(null, pstmt, conn);
        }
    }

    //입고 삭제 (INBOUND DELETE → 트리거가 STOCK 자동 차감)
    public void deleteInbound(int inNum) throws Exception {
        Connection conn = null; PreparedStatement pstmt = null;
        try {
            conn = DBUtil.getConnection();
            String sql = "DELETE FROM INBOUND WHERE IN_NUM = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, inNum);
            pstmt.executeUpdate();
            // ← STOCK 처리 불필요: TRG_INBOUND_DELETE 트리거가 자동 처리
        } catch (Exception e) {
            e.printStackTrace();
            throw new Exception("입고 내역 삭제 중 오류 발생", e);
        } finally {
            DBUtil.executeClose(null, pstmt, conn);
        }
    }

    //입고 대기 상품 목록
    public List<Log_InVO> getPendingMasterList() throws Exception {
        Connection conn = null; PreparedStatement pstmt = null; ResultSet rs = null;
        List<Log_InVO> list = new ArrayList<>();
        String sql = "SELECT P.SKU, P.PROD_NAME, B.BRAND_NAME, O.COLOR, O.SIZE_VAL "
                   + "FROM PROD_OPTIONS O "
                   + "JOIN PRODUCTS P ON O.PROD_NUM = P.PROD_NUM "
                   + "JOIN BRANDS B ON P.BRAND_NUM = B.BRAND_NUM "
                   + "WHERE O.OPT_NUM NOT IN (SELECT OPT_NUM FROM INBOUND) "
                   + "ORDER BY P.PROD_NUM DESC";
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                Log_InVO vo = new Log_InVO();
                vo.setSku(rs.getString("SKU"));
                vo.setProdName(rs.getString("PROD_NAME"));
                vo.setBrandName(rs.getString("BRAND_NAME"));
                vo.setColor(rs.getString("COLOR"));
                vo.setSizeVal(rs.getInt("SIZE_VAL"));
                list.add(vo);
            }
        } finally {
            DBUtil.executeClose(rs, pstmt, conn);
        }
        return list;
    }
  //입고번호로 prodNum 조회 (재입고 알림 발송용)
    public int getProdNumByInNum(int inNum) throws Exception {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        int prodNum = 0;
        try {
            conn = DBUtil.getConnection();
            String sql = "SELECT PROD_NUM FROM INBOUND WHERE IN_NUM = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, inNum);
            rs = pstmt.executeQuery();
            if (rs.next()) prodNum = rs.getInt("PROD_NUM");
        } finally {
            DBUtil.executeClose(rs, pstmt, conn);
        }
        return prodNum;
    }

}