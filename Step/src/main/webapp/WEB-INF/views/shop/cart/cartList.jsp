<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>ShoeMall - 장바구니</title>
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700;900&family=Space+Grotesk:wght@600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/KR_style.css">
</head>
<body>
    <%-- 공통 헤더 --%>
    <jsp:include page="/WEB-INF/views/common/header.jsp"/>

    <div class="wrap">
        <div class="page-title">장바구니</div>
        
        <div class="cart-layout">
            <%-- 왼쪽: 상품 리스트 --%>
            <div class="cart-list">
                <div style="padding: 10px 0; border-bottom: 2px solid var(--black); display: flex; justify-content: space-between;">
                    <label style="display:flex; align-items:center; gap:8px; font-weight:700;">
                        <input type="checkbox" id="checkAll" checked> 전체 선택
                    </label>
                    <button class="btn-del-selected" style="background:none; border:none; color:var(--gray4); cursor:pointer; font-size:13px;">선택 삭제</button>
                </div>

                <c:if test="${empty cartList}">
                    <div style="padding:100px 0; text-align:center; color:var(--gray4);">장바구니에 담긴 상품이 없습니다.</div>
                </c:if>

                <c:forEach var="cart" items="${cartList}">
                    <div class="cart-item">
                        <div class="cart-check"><input type="checkbox" name="cart_check" checked></div>
                        <div class="cart-thumb"><img src="${pageContext.request.contextPath}/upload/${cart.prod_img_url}" style="width:100%;"></div>
                        <div style="flex:1;">
                            <div class="cart-brand">${cart.brand_name}</div>
                            <div class="cart-name">${cart.prod_name}</div>
                            <div class="cart-opt">옵션: ${cart.color} / ${cart.size_val}</div>
                            <div class="qty-row">
                                <button class="qty-btn">-</button>
                                <div class="qty-num">${cart.cart_qty}</div>
                                <button class="qty-btn">+</button>
                            </div>
                        </div>
                        <div class="cart-price-col">
                            <div class="cart-price"><fmt:formatNumber value="${cart.prod_price * cart.cart_qty}" pattern="#,###"/>원</div>
                            <div class="cart-del">삭제</div>
                        </div>
                    </div>
                </c:forEach>
            </div>

            <%-- 오른쪽: 주문 요약 --%>
            <div class="cart-summary">
                <div class="cart-summary-box">
                    <div class="cs-title">주문 요약</div>
                    <div class="cs-row"><span>총 상품 금액</span> <span>0원</span></div>
                    <div class="cs-row"><span>배송비</span> <span>무료</span></div>
                    <div class="cs-row" style="color:var(--red);"><span>할인 금액</span> <span>-0원</span></div>
                    <div class="cs-total"><span>총 결제 예상 금액</span> <span style="color:var(--blue);">0원</span></div>
                    <button class="btn btn-black btn-full" style="margin-top:20px; height:52px; font-size:15px;" onclick="location.href='${pageContext.request.contextPath}/order/orderForm.do'">구매하기</button>
                    <p class="pay-note">쿠폰 및 적립금은 주문서에서 적용 가능합니다.</p>
                </div>
            </div>
        </div>
    </div>
</body>
</html>