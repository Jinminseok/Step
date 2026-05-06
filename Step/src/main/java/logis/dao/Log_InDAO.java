package logis.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import kr.util.DBUtil;
import logis_vo.Log_InVO;

public class Log_InDAO {
	//싱글턴 패턴
	private static Log_InDAO instance = new Log_InDAO();
	
	public static Log_InDAO getInstance() {
		return instance;
	}
	private Log_InDAO() {}
	
	
	// 1. 입고 내역 저장 (INBOUND 테이블)
    public void insertInbound(int optNum, int prodNum, int inQty, int adminNum, String inMemo, String inDate, String supplier) throws Exception {
        Connection conn = null;
        PreparedStatement pstmt = null;
        // IN_DATE와 IN_CREATED_AT은 SYSDATE로 현재 시간 자동 입력
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
        } catch (Exception e) {
            e.printStackTrace();
            throw new Exception("입고 내역 저장 중 오류 발생", e);
        } finally {
            DBUtil.executeClose(null, pstmt, conn);
        }
    }

    // 2. 재고 수량 업데이트 (STOCK 테이블)
    public void updateStock(int optNum, int prodNum, int inQty) throws Exception {
        Connection conn = null;
        PreparedStatement pstmt = null;
        // 💡 실무 치트키 MERGE INTO: 해당 옵션 번호가 이미 있으면 수량 증가(UPDATE), 없으면 새로 등록(INSERT)!
        String sql = "MERGE INTO STOCK S "
                   + "USING DUAL ON (S.OPT_NUM = ?) "
                   + "WHEN MATCHED THEN "
                   + "    UPDATE SET S.STOCK_QTY = S.STOCK_QTY + ?, S.STOCK_UPDATED_AT = SYSDATE "
                   + "WHEN NOT MATCHED THEN "
                   + "    INSERT (STOCK_NUM, OPT_NUM, PROD_NUM, STOCK_QTY, STOCK_MIN_QTY, STOCK_UPDATED_AT) "
                   + "    VALUES (STOCK_SEQ.NEXTVAL, ?, ?, ?, 10, SYSDATE)";
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, optNum); // ON 조건 (이 옵션번호가 STOCK 테이블에 있나?)
            pstmt.setInt(2, inQty);  // MATCHED: 있으면 원래 수량에 inQty만큼 더함
            pstmt.setInt(3, optNum); // NOT MATCHED: 없으면 INSERT할 옵션번호
            pstmt.setInt(4, prodNum); // INSERT할 상품번호
            pstmt.setInt(5, inQty);   // INSERT할 초기 수량
            pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
            throw new Exception("재고 업데이트 중 오류 발생", e);
        } finally {
            DBUtil.executeClose(null, pstmt, conn);
        }
    }

    // 3. 상품번호 + 사이즈 + 컬러로 기존 옵션번호(OPT_NUM) 찾기
    public int getOptNum(int prodNum, int sizeVal, String color) throws Exception {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        int optNum = 0;
        String sql = "SELECT OPT_NUM FROM PROD_OPTIONS WHERE PROD_NUM=? AND SIZE_VAL=? AND COLOR=?";
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, prodNum);
            pstmt.setInt(2, sizeVal);
            pstmt.setString(3, color);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                optNum = rs.getInt("OPT_NUM");
            }
        } catch (Exception e) {
            e.printStackTrace();
            throw new Exception("옵션 번호 조회 중 오류 발생", e);
        } finally {
            DBUtil.executeClose(rs, pstmt, conn);
        }
        return optNum; // 만약 못 찾으면 0 반환
    }

    // 4. 새로운 옵션 생성 후 그 생성된 옵션번호(OPT_NUM) 반환하기
    public int insertOptionAndGetNum(int prodNum, int sizeVal, String color) throws Exception {
    	int optNum = 0;
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBUtil.getConnection();
            
            // 🚨 [단계 1] 현재 테이블에 저장된 제일 큰 옵션 번호(MAX) 찾기
            String maxSql = "SELECT NVL(MAX(OPT_NUM), 0) FROM PROD_OPTIONS";
            pstmt = conn.prepareStatement(maxSql);
            rs = pstmt.executeQuery();
            int maxNum = 0;
            if (rs.next()) {
                maxNum = rs.getInt(1);
            }
            DBUtil.executeClose(rs, pstmt, null); // 썼던 그릇(자원) 잠시 반납
            
            // 🚨 [단계 2] 꼬여버린 시퀀스 번호표를 안전한 번호가 나올 때까지 계속 뽑기 (Fast-Forward)
            int safeSeq = 0;
            String seqSql = "SELECT PROD_OPTIONS_SEQ.NEXTVAL FROM DUAL";
            pstmt = conn.prepareStatement(seqSql);
            
            while (true) {
                rs = pstmt.executeQuery();
                if (rs.next()) {
                    safeSeq = rs.getInt(1);
                }
                rs.close(); // 다음 반복을 위해 ResultSet 닫기
                
                // 방금 뽑은 시퀀스 번호가 DB에 있는 최대값보다 크다면? 안전 확보! 탈출!
                if (safeSeq > maxNum) {
                    break; 
                }
            }
            DBUtil.executeClose(null, pstmt, null); // 그릇 다시 반납
            
            // 🚨 [단계 3] 드디어 찾은 '안전한 번호(safeSeq)'를 사용해서 DB에 INSERT!
            String sql = "INSERT INTO PROD_OPTIONS (OPT_NUM, PROD_NUM, SIZE_VAL, COLOR, ADD_PRICE, PROD_USE_YN) "
                       + "VALUES (?, ?, ?, ?, 0, 'Y')";
                       
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, safeSeq); // PROD_OPTIONS_SEQ.NEXTVAL 대신 방금 찾은 번호를 직접 꽂아줌
            pstmt.setInt(2, prodNum);
            pstmt.setInt(3, sizeVal);
            pstmt.setString(4, color);
            
            int count = pstmt.executeUpdate();
            if (count > 0) {
                optNum = safeSeq; // 성공하면 이 번호를 리턴해서 입고(INBOUND) 테이블로 넘겨줍니다!
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            throw new Exception("옵션 생성 중 오류 발생 : " + e.getMessage());
        } finally {
            DBUtil.executeClose(rs, pstmt, conn); // 최종 연결 종료
        }
        return optNum;
    }
    
    public List<Log_InVO> getInboundList() throws Exception {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<Log_InVO> list = new ArrayList<>();
        
        // 💡 5개의 테이블을 조인해서 화면에 필요한 모든 데이터를 한 방에 가져옵니다!
        String sql = "SELECT I.IN_NUM, "
                + "TO_CHAR(I.IN_DATE, 'YYYY-MM-DD') || ' ' || TO_CHAR(I.IN_CREATED_AT, 'HH24:MI:SS') AS IN_DATE, "
                + "I.IN_QTY, I.IN_MEMO, I.SUPPLIER, I.IN_STATUS, "
                + "       P.SKU, P.PROD_NAME, "
                + "       B.BRAND_NAME, "
                + "       O.SIZE_VAL, O.COLOR, "
                + "       NVL(U.USER_NAME, '관리자') AS ADMIN_NAME " 
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
                
                // 🚨 1. 해결 포인트: 오라클이 지어준 별명(ADMIN_NAME)으로 꺼내옵니다!
                // (VO에는 setUserName을 그대로 쓰셔도 무방합니다)
                vo.setUserName(rs.getString("ADMIN_NAME"));
                
                // 🚨 2. 해결 포인트: 테이블이 분리되었으니 쪼갤 필요 없이 바로 꺼내서 담습니다!
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
    
    // 검색 모달창에 띄워줄 상품 정보들만 쓱 가져옵니다.
    public List<Log_InVO> getProductListForSearch() throws Exception {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<Log_InVO> list = new ArrayList<>();
        
        // PRODUCTS와 BRANDS를 조인해서 상품번호, 품번, 상품명, 브랜드명 조회
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
    
    //입고 내역 수정 (UPDATE)
    public void updateInbound(Log_InVO vo) throws Exception {
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        // 🚨 UPDATE 안에 SELECT를 넣어서 오라클이 알아서 새 옵션 번호를 찾아 끼우게 만듭니다!
        String sql = "UPDATE INBOUND "
                   + "SET IN_DATE = TO_DATE(?, 'YYYY-MM-DD'), "
                   + "    IN_QTY = ?, "
                   + "    IN_STATUS = ?, "
                   + "    SUPPLIER = ?, "
                   + "    IN_MEMO = ?, "
                   + "    OPT_NUM = ( "
                   + "        SELECT OPT_NUM FROM PROD_OPTIONS "
                   + "        WHERE PROD_NUM = (SELECT PROD_NUM FROM INBOUND WHERE IN_NUM = ?) "
                   + "          AND SIZE_VAL = ? "
                   + "          AND COLOR = ? "
                   + "    ) "
                   + "WHERE IN_NUM = ?";
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            
            // 1~5번째 물음표: 일반 정보
            pstmt.setString(1, vo.getInDate());
            pstmt.setInt(2, vo.getInQty());
            pstmt.setInt(3, vo.getInStatus());
            pstmt.setString(4, vo.getSupplier());
            pstmt.setString(5, vo.getInMemo());
            
            // 6~8번째 물음표: 서브쿼리(옵션 번호 찾기)에 들어갈 재료들
            pstmt.setInt(6, vo.getInNum());
            pstmt.setInt(7, vo.getSizeVal());  // 🚨 VO에 sizeVal 이 있어야 합니다!
            pstmt.setString(8, vo.getColor()); // 🚨 VO에 color 가 있어야 합니다!
            
            // 9번째 물음표: 어떤 입고 번호를 수정할지
            pstmt.setInt(9, vo.getInNum());
            
            pstmt.executeUpdate();
            
        } catch (Exception e) {
            e.printStackTrace();
            throw new Exception("입고 내역 수정 중 오류 발생", e);
        } finally {
            DBUtil.executeClose(null, pstmt, conn);
        }
    }
    
    // 입고 내역 삭제 (DELETE)
    public void deleteInbound(int inNum) throws Exception {
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        // 아주 깔끔한 한 줄짜리 삭제 쿼리!
        String sql = "DELETE FROM INBOUND WHERE IN_NUM = ?";
        
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, inNum); // JSP에서 가져온 번호를 꽂아줍니다.
            
            pstmt.executeUpdate();
            
        } catch (Exception e) {
            e.printStackTrace();
            throw new Exception("입고 내역 삭제 중 오류 발생", e);
        } finally {
            DBUtil.executeClose(null, pstmt, conn);
        }
    }
	
}
