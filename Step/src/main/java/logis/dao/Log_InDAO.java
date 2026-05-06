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
    public void insertInbound(int optNum, int prodNum, int inQty, int userNum, String inMemo, String inDate) throws Exception {
        Connection conn = null;
        PreparedStatement pstmt = null;
        // IN_DATE와 IN_CREATED_AT은 SYSDATE로 현재 시간 자동 입력
        String sql = "INSERT INTO INBOUND (IN_NUM, OPT_NUM, PROD_NUM, IN_QTY, ADMIN_NUM, IN_MEMO, IN_DATE, IN_CREATED_AT) "
                   + "VALUES (INBOUND_SEQ.NEXTVAL, ?, ?, ?, ?, ?, TO_DATE(?, 'YYYY-MM-DD'), SYSDATE)";
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, optNum);
            pstmt.setInt(2, prodNum);
            pstmt.setInt(3, inQty);
            pstmt.setInt(4, userNum);
            pstmt.setString(5, inMemo);
            pstmt.setString(6, inDate);
            
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
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        int optNum = 0;
        
        String sqlInsert = "INSERT INTO PROD_OPTIONS (OPT_NUM, PROD_NUM, SIZE_VAL, COLOR, ADD_PRICE, PROD_USE_YN) "
                         + "VALUES (PROD_OPTIONS_SEQ.NEXTVAL, ?, ?, ?, 0, '1')";
        String sqlSelect = "SELECT PROD_OPTIONS_SEQ.CURRVAL FROM DUAL";
        
        try {
            conn = DBUtil.getConnection();
            // 1. 먼저 옵션을 생성
            pstmt = conn.prepareStatement(sqlInsert);
            pstmt.setInt(1, prodNum);
            pstmt.setInt(2, sizeVal);
            pstmt.setString(3, color);
            pstmt.executeUpdate();
            pstmt.close();
            
            // 2. 방금 만들어진 시퀀스 번호(CURRVAL) 가져오기
            pstmt = conn.prepareStatement(sqlSelect);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                optNum = rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
            throw new Exception("옵션 생성 중 오류 발생", e);
        } finally {
            DBUtil.executeClose(rs, pstmt, conn);
        }
        return optNum;
    }
    
    public List<Log_InVO> getInboundList() throws Exception {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<Log_InVO> list = new ArrayList<>();
        
        // 💡 5개의 테이블을 조인해서 화면에 필요한 모든 데이터를 한 방에 가져옵니다!
        String sql = "SELECT I.IN_NUM, I.IN_DATE, I.IN_QTY, I.IN_MEMO, "
                + "       P.SKU, P.PROD_NAME, "
                + "       B.BRAND_NAME, "
                + "       O.SIZE_VAL, O.COLOR, "
                + "       U.USER_NAME "
                + "FROM INBOUND I "
                + "JOIN PRODUCTS P ON I.PROD_NUM = P.PROD_NUM "
                + "JOIN BRANDS B ON P.BRAND_NUM = B.BRAND_NUM "
                + "JOIN PROD_OPTIONS O ON I.OPT_NUM = O.OPT_NUM "
                + "JOIN USERS_DETAIL U ON I.ADMIN_NUM = U.USER_NUM " 
                + "ORDER BY I.IN_NUM DESC";
                   
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Log_InVO vo = new Log_InVO();
                vo.setInNum(rs.getInt("IN_NUM"));
                // 날짜 포맷은 JSP에서 해주거나 문자열로 변환해도 되지만, 일단 Date 타입으로 담습니다.
                vo.setInDate(rs.getDate("IN_DATE")); 
                vo.setInQty(rs.getInt("IN_QTY"));
                vo.setSku(rs.getString("SKU"));
                vo.setProdName(rs.getString("PROD_NAME"));
                vo.setBrandName(rs.getString("BRAND_NAME"));
                vo.setSizeVal(rs.getInt("SIZE_VAL"));
                vo.setColor(rs.getString("COLOR"));
                vo.setUserName(rs.getString("USER_NAME"));
                
                // 💡 핵심 디테일: "[공급업체] 메모내용" 형태로 저장된 IN_MEMO를 쪼개서 담아주기
                String rawMemo = rs.getString("IN_MEMO");
                if (rawMemo != null && rawMemo.startsWith("[")) {
                    int endIdx = rawMemo.indexOf("]");
                    if (endIdx > 0) {
                        vo.setSupplier(rawMemo.substring(1, endIdx)); // 괄호 안의 글자 (공급업체)
                        vo.setInMemo(rawMemo.substring(endIdx + 1).trim()); // 괄호 뒤의 글자 (순수 메모)
                    } else {
                        vo.setSupplier("-");
                        vo.setInMemo(rawMemo);
                    }
                } else {
                    vo.setSupplier("-");
                    vo.setInMemo(rawMemo);
                }
                
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
	
}
