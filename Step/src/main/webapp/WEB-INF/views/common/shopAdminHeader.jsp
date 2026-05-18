<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<style>
/* --- 모던 관리자 사이드바 스타일 --- */
:root {
    --sb-bg: #111827;           
    --sb-text: #9CA3AF;         
    --sb-text-hover: #F9FAFB;   
    --sb-active-bg: #1F2937;    
    --sb-border: #374151;       
    --sb-accent: #3B82F6;       
    --sb-logo-grad: linear-gradient(135deg, #EF4444, #DC2626); 
}

.sidebar {
    /* 👇 여기가 핵심! 화면 왼쪽에 딱 고정시킵니다. */
    position: fixed;
    top: 0;
    left: 0;
    bottom: 0;
    width: 260px;
    height: 100vh;
    background-color: var(--sb-bg);
    color: var(--sb-text);
    display: flex;
    flex-direction: column;
    font-family: 'Pretendard', sans-serif;
    box-shadow: 4px 0 20px rgba(0, 0, 0, 0.15); 
    z-index: 1000; /* 항상 최상단 유지 */
}

/* 로고 영역 */
.sb-logo {
    padding: 24px 20px;
    display: flex;
    align-items: center;
    gap: 14px;
    border-bottom: 1px solid var(--sb-border);
}
.sb-logo-mark {
    width: 38px;
    height: 38px;
    background: var(--sb-logo-grad);
    color: #fff;
    border-radius: 10px;
    display: flex;
    align-items: center;
    justify-content: center;
    font-weight: 800;
    font-size: 20px;
    box-shadow: 0 4px 10px rgba(239, 68, 68, 0.3);
}
.sb-logo-txt {
    font-size: 19px;
    font-weight: 800;
    color: #fff;
    letter-spacing: -0.5px;
}
.sb-logo-txt span {
    font-weight: 300;
    color: var(--sb-text);
}
.sb-logo-badge {
    font-size: 10px;
    color: #6B7280;
    text-transform: uppercase;
    letter-spacing: 1.5px;
    margin-top: 3px;
}

/* 네비게이션 영역 */
.nav {
    flex: 1;
    overflow-y: auto;
    padding: 24px 12px;
}
.nav::-webkit-scrollbar { width: 5px; }
.nav::-webkit-scrollbar-thumb { background: var(--sb-border); border-radius: 5px; }

.nav-section {
    font-size: 11px;
    font-weight: 600;
    color: #6B7280;
    text-transform: uppercase;
    letter-spacing: 1.2px;
    margin: 24px 0 8px 12px;
}
.nav-section:first-child { margin-top: 0; }

.nav-item {
    display: flex;
    align-items: center;
    padding: 11px 14px;
    margin-bottom: 4px;
    border-radius: 8px;
    color: var(--sb-text);
    text-decoration: none;
    font-size: 14px;
    font-weight: 500;
    transition: all 0.2s ease;
}
.nav-item .nav-icon {
    margin-right: 14px;
    font-size: 16px;
    opacity: 0.7;
    transition: transform 0.2s ease, opacity 0.2s;
}

.nav-item:hover {
    background-color: rgba(255, 255, 255, 0.04);
    color: var(--sb-text-hover);
}
.nav-item:hover .nav-icon {
    transform: scale(1.15); 
    opacity: 1;
}

.nav-item.active {
    background-color: var(--sb-active-bg);
    color: #fff;
    font-weight: 600;
    position: relative;
}
.nav-item.active .nav-icon { opacity: 1; }
.nav-item.active::before {
    content: '';
    position: absolute;
    left: -12px;
    top: 50%;
    transform: translateY(-50%);
    height: 50%;
    width: 4px;
    background-color: var(--sb-accent);
    border-radius: 0 4px 4px 0;
}

/* 하단 유저 프로필 영역 */
.sb-footer {
    padding: 18px 20px;
    border-top: 1px solid var(--sb-border);
    background-color: rgba(0, 0, 0, 0.15);
}
.admin-row {
    display: flex;
    align-items: center;
    gap: 12px;
}
.admin-av {
    width: 36px;
    height: 36px;
    background-color: var(--sb-accent);
    color: #fff;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 13px;
    font-weight: 700;
}
.admin-name { font-size: 13.5px; font-weight: 600; color: #fff; }
.admin-role { font-size: 11px; color: var(--sb-text); margin-top: 2px; }

.logout-btn {
    margin-left: auto;
    padding: 6px 12px;
    background-color: rgba(255, 255, 255, 0.05);
    color: var(--sb-text);
    text-decoration: none;
    font-size: 11.5px;
    font-weight: 500;
    border-radius: 6px;
    transition: all 0.2s ease;
}
.logout-btn:hover {
    background-color: #EF4444; 
    color: #fff;
}
</style>

<aside class="sidebar">
	<div class="sb-logo">
		<div class="sb-logo-mark">A</div>
		<div>
			<div class="sb-logo-txt">Shoe<span>Mall</span></div>
			<div class="sb-logo-badge">Admin Panel</div>
		</div>
	</div>
	<nav class="nav">
		<div class="nav-section">대시보드</div>
		<a href="${pageContext.request.contextPath}/shop/admin/main.do"
			class="nav-item ${fn:contains(pageContext.request.servletPath, 'adminMain') ? 'active' : ''}">
			<span class="nav-icon">📊</span>통계 / 대시보드
		</a>

		<div class="nav-section">상품</div>
		<a href="${pageContext.request.contextPath}/shop/admin/productList.do"
			class="nav-item ${fn:contains(pageContext.request.servletPath, 'Product') ? 'active' : ''}">
			<span class="nav-icon">👟</span>상품 관리
		</a> 
		<a href="${pageContext.request.contextPath}/shop/category/categoryForm.do"
			class="nav-item ${fn:contains(pageContext.request.servletPath, 'category') ? 'active' : ''}">
			<span class="nav-icon">📁</span>카테고리 관리
		</a> 
		<a href="${pageContext.request.contextPath}/shop/brand/brandForm.do"
			class="nav-item ${fn:contains(pageContext.request.servletPath, 'brand') ? 'active' : ''}">
			<span class="nav-icon">🏷️</span>브랜드 관리
		</a>

		<div class="nav-section">재고 / 물류</div>
		<a href="${pageContext.request.contextPath}/shop/stock/stockList.do"
			class="nav-item ${fn:contains(pageContext.request.servletPath, 'stock') ? 'active' : ''}">
			<span class="nav-icon">📦</span>재고 현황 조회
		</a> 
		<a href="${pageContext.request.contextPath}/shop/admin_order/adminorderForm.do"
			class="nav-item ${fn:contains(pageContext.request.servletPath, 'order') ? 'active' : ''}">
			<span class="nav-icon">🧾</span>주문 관리
		</a> 
		<a href="${pageContext.request.contextPath}/shop/delivery/deliveryForm.do"
			class="nav-item ${fn:contains(pageContext.request.servletPath, 'delivery') ? 'active' : ''}">
			<span class="nav-icon">🚚</span>배송 관리
		</a> 
		<a href="${pageContext.request.contextPath}/shop/return/returnForm.do"
			class="nav-item ${fn:contains(pageContext.request.servletPath, 'return') ? 'active' : ''}">
			<span class="nav-icon">↩️</span>반품/교환 관리
		</a>

		<div class="nav-section">고객</div>
		<a href="${pageContext.request.contextPath}/shop/member/memberForm.do"
			class="nav-item ${fn:contains(pageContext.request.servletPath, 'member') ? 'active' : ''}">
			<span class="nav-icon">👤</span>회원 관리
		</a> 
		<a href="${pageContext.request.contextPath}/shop/chat/adminChatList.do"
			class="nav-item ${fn:contains(pageContext.request.servletPath, 'chat') ? 'active' : ''}">
			<span class="nav-icon">💬</span>채팅 문의
		</a>

		<div class="nav-section">운영</div>
		<a href="${pageContext.request.contextPath}/shop/banner/bannerList.do"
			class="nav-item ${fn:contains(pageContext.request.servletPath, 'banner') ? 'active' : ''}">
			<span class="nav-icon">🖼️</span>UI / 배너 관리
		</a> 
		<a href="${pageContext.request.contextPath}/shop/admin/adminStoreList.do"
			class="nav-item ${fn:contains(pageContext.request.servletPath, 'store') ? 'active' : ''}">
			<span class="nav-icon">🗺️</span>매장 정보 관리
		</a> 
		<a href="${pageContext.request.contextPath}/shop/admin/notifyList.do"
			class="nav-item ${fn:contains(pageContext.request.servletPath, 'notify') ? 'active' : ''}">
			<span class="nav-icon">🔔</span>알림 발송 관리
		</a>
	</nav>
	<div class="sb-footer">
		<div class="admin-row">
			<div class="admin-av">관리</div>
			<div>
				<div class="admin-name">asdf</div>
				<div class="admin-role">super admin</div>
			</div>
			<a href="${pageContext.request.contextPath}/shop/admin/logout.do" class="logout-btn">로그아웃</a>
		</div>
	</div>
</aside>