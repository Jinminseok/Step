<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<header>
  <div class="hdr-top">
    <div class="logo" onclick="location.href='${pageContext.request.contextPath}/main/main.do'">Shoe<span>Mall</span></div>
    <div class="hdr-search">
      <input type="text" placeholder="브랜드, 상품, 카테고리 검색">
      <button class="hdr-search-btn">🔍</button>
    </div>
    <div class="hdr-actions">
      <c:choose>
        <%-- 1. 로그인 상태일 때 (세션에 user_num이 있을 때) --%>
        <c:when test="${!empty sessionScope.user_num}">
          <button class="hdr-btn" onclick="location.href='${pageContext.request.contextPath}/notice/list.do'">
            <span class="hdr-btn-icon">🔔</span><span class="hdr-btn-label">알림</span>
            <span class="hdr-badge" style="background:var(--blue)">1</span>
          </button>
          <button class="hdr-btn" onclick="location.href='${pageContext.request.contextPath}/cart/list.do'">
            <span class="hdr-btn-icon">🛒</span><span class="hdr-btn-label">장바구니</span>
          </button>
          <button class="hdr-btn" onclick="location.href='${pageContext.request.contextPath}/member/myPage.do'">
            <span class="hdr-btn-icon" style="width:28px;height:28px;background:#ff0000;border-radius:50%;display:flex;align-items:center;justify-content:center;font-size:13px;font-weight:700;color:#fff">김</span>
            <span class="hdr-btn-label" style="color:#fff">마이페이지</span>
          </button>
          <button class="hdr-btn" onclick="location.href='${pageContext.request.contextPath}/member/logout.do'">
            <span class="hdr-btn-label" style="font-size:12px;font-weight:700">로그아웃</span>
          </button>
        </c:when>
        
        <%-- 2. 비로그인 상태일 때 --%>
        <c:otherwise>
          <button class="hdr-btn" onclick="location.href='${pageContext.request.contextPath}/member/loginForm.do'" style="color:#fff;background:rgba(255,255,255,.08);border-radius:3px;padding:6px 14px;">
            <span class="hdr-btn-label" style="font-size:12px;font-weight:700">로그인</span>
          </button>
          <button class="hdr-btn" onclick="location.href='${pageContext.request.contextPath}/member/registerForm.do'" style="color:#000;background:#fff;border-radius:3px;padding:6px 14px;">
            <span class="hdr-btn-label" style="font-size:12px;font-weight:700">회원가입</span>
          </button>
        </c:otherwise>
      </c:choose>
    </div>
  </div>
</header>

<div class="cat-nav">
  <div class="cat-nav-inner">
    <div class="cat-item active" onclick="location.href='${pageContext.request.contextPath}/main/main.do'">전체</div>
    <div class="cat-item">👟 운동화</div>
    <div class="cat-item">👡 샌들</div>
    <div class="cat-item">👞 구두</div>
    <div class="cat-item">🥾 부츠</div>
    <div class="cat-item">🩴 슬리퍼</div>
    <div class="cat-item">🗺️ 매장찾기</div>
  </div>
</div>
