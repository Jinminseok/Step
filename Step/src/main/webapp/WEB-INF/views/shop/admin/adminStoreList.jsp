<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>ShoeMall Admin - 매장 관리</title>
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700;900&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/KM_style.css">
<style>
    /* 관리자 페이지 전용 심플 레이아웃 */
    .admin-wrap { max-width: 1200px; margin: 40px auto; padding: 0 20px; font-family: 'Noto Sans KR', sans-serif; }
    .admin-title { font-size: 24px; font-weight: 700; margin-bottom: 20px; padding-bottom: 15px; border-bottom: 2px solid var(--black); }
    
    /* 상단 버튼 영역 */
    .top-action-bar { display: flex; justify-content: flex-end; margin-bottom: 15px; }
    .btn-register { 
        background: var(--black); color: var(--white); padding: 10px 20px; 
        border-radius: 4px; text-decoration: none; font-weight: 500; font-size: 14px; transition: 0.2s;
    }
    .btn-register:hover { background: #333; }

    /* 데이터 테이블 스타일 */
    .admin-table { width: 100%; border-collapse: collapse; text-align: center; border-top: 1px solid var(--black); }
    .admin-table th { background: #f8f9fa; padding: 14px; border-bottom: 1px solid var(--border); font-weight: 700; color: #333; }
    .admin-table td { padding: 14px; border-bottom: 1px solid var(--border); vertical-align: middle; color: #555; }
    .admin-table tbody tr:hover { background: #fdfdfd; }
    
    /* 매장명 링크 */
    .store-link { color: var(--black); font-weight: 700; text-decoration: none; }
    .store-link:hover { color: var(--blue); text-decoration: underline; }

    /* 상태 뱃지 (운영중/미운영) */
    .badge-y { background: #e6f4ea; color: #1e8e3e; padding: 4px 10px; border-radius: 12px; font-size: 12px; font-weight: 700; }
    .badge-n { background: #fce8e6; color: #d93025; padding: 4px 10px; border-radius: 12px; font-size: 12px; font-weight: 700; }

    /* 작은 관리 버튼 */
    .btn-sm { 
        padding: 6px 12px; border: 1px solid var(--border); border-radius: 4px; 
        background: var(--white); cursor: pointer; font-size: 12px; color: #333;
    }
    .btn-sm:hover { background: #f1f1f1; }
</style>
</head>
<body>
    <jsp:include page="/WEB-INF/views/common/shopAdminHeader.jsp"/>

    <div class="admin-wrap">
        <div class="admin-title">🏢 오프라인 매장 관리 (Admin)</div>
        
        <div class="top-action-bar">
            <%-- 매장 등록 폼으로 이동하는 버튼 --%>
            <a href="${pageContext.request.contextPath}/admin/storeWriteForm.do" class="btn-register">＋ 새 매장 등록</a>
        </div>

        <table class="admin-table">
            <colgroup>
                <col style="width: 8%;">
                <col style="width: 12%;">
                <col style="width: 20%;">
                <col style="width: auto;">
                <col style="width: 15%;">
                <col style="width: 10%;">
                <col style="width: 10%;">
            </colgroup>
            <thead>
                <tr>
                    <th>번호</th>
                    <th>브랜드</th>
                    <th>매장명</th>
                    <th>주소</th>
                    <th>전화번호</th>
                    <th>상태</th>
                    <th>관리</th>
                </tr>
            </thead>
            <tbody>
                <%-- 컨트롤러에서 넘어올 관리자용 리스트 변수명: adminStoreList --%>
                <c:forEach var="store" items="${adminStoreList}">
                    <tr>
                        <td>${store.storeNum}</td>
                        <td style="font-weight: 500; color: var(--blue);">${store.brandName}</td>
                        
                        <td style="text-align: left;">
                            <%-- 매장명을 누르면 상세/수정 페이지로 이동하도록 링크 처리 --%>
                            <a href="${pageContext.request.contextPath}/admin/storeDetail.do?storeNum=${store.storeNum}" class="store-link">
                                ${store.storeName}
                            </a>
                        </td>
                        
                        <td style="text-align: left;">${store.storeAddr}</td>
                        <td>${store.storePhone}</td>
                        
                        <td>
                            <%-- Y/N 여부에 따라 뱃지 색상을 다르게 보여줌 --%>
                            <c:choose>
                                <c:when test="${store.storeUseYn == 'Y'}">
                                    <span class="badge-y">운영중</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge-n">미운영</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        
                        <td>
                            <%-- 수정 버튼 --%>
                            <button type="button" class="btn-sm" onclick="location.href='${pageContext.request.contextPath}/admin/storeModifyForm.do?storeNum=${store.storeNum}'">수정</button>
                        </td>
                    </tr>
                </c:forEach>
                
                <%-- 데이터가 하나도 없을 때 보여줄 화면 --%>
                <c:if test="${empty adminStoreList}">
                    <tr>
                        <td colspan="7" style="padding: 60px; color: var(--gray4); font-size: 15px;">등록된 매장 데이터가 없습니다. 상단의 '새 매장 등록' 버튼을 눌러 추가해주세요.</td>
                    </tr>
                </c:if>
            </tbody>
        </table>
    </div>
</body>
</html>