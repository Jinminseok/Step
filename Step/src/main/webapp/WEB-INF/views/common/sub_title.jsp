<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<style>
/* --- 실무형 모던 탑바(Header) 스타일 --- */
.top-header {
    background-color: #ffffff; /* 깔끔한 화이트 배경 */
    height: 64px;
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 0 30px;
    border-bottom: 1px solid #e2e8f0; /* 은은한 구분선 */
    /* main의 패딩을 무시하고 양옆으로 꽉 차게 만듭니다 */
    margin: -30px -30px 30px -30px; 
    position: sticky;
    top: 0;
    z-index: 99; /* 본문 스크롤 시 위로 지나가게 설정 */
}

/* 왼쪽: 타이틀 및 경로(Breadcrumb) */
.th-left {
    display: flex;
    align-items: center;
    gap: 16px;
}
.th-title {
    font-size: 18px;
    font-weight: 700;
    color: #111827;
    margin: 0;
    letter-spacing: -0.5px;
}
.th-breadcrumb {
    display: flex;
    align-items: center;
    gap: 8px;
    font-size: 13px;
    color: #6b7280;
    font-weight: 500;
    margin-top: 2px;
}
.th-breadcrumb i {
    font-size: 10px;
    color: #cbd5e1; /* 꺾쇠 아이콘 색상 */
}

/* 오른쪽: 검색창 및 알림 */
.th-right {
    display: flex;
    align-items: center;
    gap: 20px;
}
.th-search {
    position: relative;
    display: flex;
    align-items: center;
}
.th-search i {
    position: absolute;
    left: 14px;
    color: #9ca3af;
    font-size: 14px;
}
.th-search input {
    padding: 9px 16px 9px 38px;
    border: 1px solid #e5e7eb;
    border-radius: 30px; /* 둥근 검색창 */
    font-size: 13px;
    background-color: #f8fafc;
    outline: none;
    width: 220px;
    transition: all 0.2s ease;
    font-family: 'Pretendard', sans-serif;
}
.th-search input:focus {
    background-color: #ffffff;
    border-color: #3b82f6; /* 포커스 시 파란색 테두리 */
    box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
    width: 260px; /* 클릭 시 살짝 길어지는 애니메이션 */
}

/* 알림 아이콘 버튼 */
.th-noti-btn {
    position: relative;
    background: none;
    border: none;
    font-size: 20px;
    color: #475569;
    cursor: pointer;
    width: 40px;
    height: 40px;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    transition: background 0.2s;
}
.th-noti-btn:hover {
    background-color: #f1f5f9;
    color: #0f172a;
}
.noti-dot {
    position: absolute;
    top: 8px;
    right: 10px;
    width: 8px;
    height: 8px;
    background-color: #ef4444; /* 빨간색 알림 점 */
    border-radius: 50%;
    border: 2px solid #ffffff;
}
</style>

<header class="top-header">
    <div class="th-left">
        <h2 class="th-title">
            <c:choose>
                <c:when test="${not empty pageTitle}">${pageTitle}</c:when>
                <c:otherwise>관리자 대시보드</c:otherwise>
            </c:choose>
        </h2>
        
        <div class="th-breadcrumb">
            <span>Admin Panel</span>
            <i class="fa-solid fa-chevron-right"></i>
            <span style="color: #3b82f6;">
                <c:choose>
                    <c:when test="${not empty pageTitle}">${pageTitle}</c:when>
                    <c:otherwise>대시보드</c:otherwise>
                </c:choose>
            </span>
        </div>
    </div>

    <div class="th-right">
        
        
      
    </div>
</header>