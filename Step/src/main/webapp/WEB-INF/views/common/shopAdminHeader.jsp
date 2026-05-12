<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<aside class="sidebar">
	<div class="sb-logo">
		<div class="sb-logo-mark">A</div>
		<div>
			<div class="sb-logo-txt">
				Shoe<span>Mall</span>
			</div>
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
		</a> <a
			href="${pageContext.request.contextPath}/shop/category/categoryForm.do"
			class="nav-item ${fn:contains(pageContext.request.servletPath, 'category') ? 'active' : ''}">
			<span class="nav-icon">🏷️</span>카테고리 관리
		</a> <a href="${pageContext.request.contextPath}/shop/brand/brandForm.do"
			class="nav-item ${fn:contains(pageContext.request.servletPath, 'brand') ? 'active' : ''}">
			<span class="nav-icon">🏷️</span>브랜드 관리
		</a>

		<div class="nav-section">재고 / 물류</div>
		<a href="${pageContext.request.contextPath}/shop/admin/stockList.do"
			class="nav-item ${fn:contains(pageContext.request.servletPath, 'stock') ? 'active' : ''}">
			<span class="nav-icon">📦</span>재고 관리<span class="nav-badge">2</span>
		</a> <a href="${pageContext.request.contextPath}/shop/admin/orderList.do"
			class="nav-item ${fn:contains(pageContext.request.servletPath, 'order') ? 'active' : ''}">
			<span class="nav-icon">🧾</span>주문 관리
		</a> <a
			href="${pageContext.request.contextPath}/shop/admin/deliveryList.do"
			class="nav-item ${fn:contains(pageContext.request.servletPath, 'delivery') ? 'active' : ''}">
			<span class="nav-icon">🚚</span>배송 관리
		</a> <a href="${pageContext.request.contextPath}/shop/admin/returnList.do"
			class="nav-item ${fn:contains(pageContext.request.servletPath, 'return') ? 'active' : ''}">
			<span class="nav-icon">↩️</span>반품/교환 관리
		</a>

		<div class="nav-section">고객</div>
		<a href="${pageContext.request.contextPath}/shop/admin/memberList.do"
			class="nav-item ${fn:contains(pageContext.request.servletPath, 'member') ? 'active' : ''}">
			<span class="nav-icon">👤</span>회원 관리
		</a> <a href="${pageContext.request.contextPath}/shop/admin/couponList.do"
			class="nav-item ${fn:contains(pageContext.request.servletPath, 'coupon') ? 'active' : ''}">
		
			<span class="nav-icon">💬</span>채팅 문의<span class="nav-badge">3</span>
		</a>

		<div class="nav-section">운영</div>
		<a href="${pageContext.request.contextPath}/shop/admin/bannerList.do"
			class="nav-item ${fn:contains(pageContext.request.servletPath, 'banner') ? 'active' : ''}">
			<span class="nav-icon">🖼️</span>UI / 배너 관리
		</a> <a href="${pageContext.request.contextPath}/shop/admin/adminStoreList.do"
			class="nav-item ${fn:contains(pageContext.request.servletPath, 'store') ? 'active' : ''}">
			<span class="nav-icon">🗺️</span>매장 정보 관리
		</a> <a href="${pageContext.request.contextPath}/shop/admin/notifyList.do"
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
			<a href="${pageContext.request.contextPath}/shop/admin/logout.do"
				class="logout-btn">로그아웃</a>
		</div>
	</div>
</aside>