<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%-- 🌟 JSTL 사용을 위한 필수 태그 추가 --%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>ShoeMall - 주문서 작성</title>
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700;900&family=Space+Grotesk:wght@600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/KR_style.css">
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
</head>
<body>
    <jsp:include page="/WEB-INF/views/common/header.jsp"/>
    
    <div class="wrap">
        <div class="page-title">주문서 작성</div>
        <form id="paymentForm" action="${pageContext.request.contextPath}/shop/order/orderProcess.do" method="post" class="cart-layout" style="grid-template-columns: 1fr 450px; gap: 40px;">
        
            <%-- 왼쪽: 주문 정보 --%>
            <div class="order-forms">
            
                <%-- 주문 상품 정보 --%>
                <div class="form-sec" style="max-width:100%; margin-bottom:24px;">
                    <div class="sec-title" style="margin-bottom:20px;">주문 상품 정보</div>
                    
                    <c:forEach var="item" items="${orderItemList}">
                        <div style="display:flex; gap:16px; align-items:center; border-bottom:1px solid var(--border); padding-bottom:16px; margin-bottom:16px;">
                            <img src="${pageContext.request.contextPath}/upload/${item.prod_img_url}" style="width:80px; height:80px; object-fit:cover; border-radius:4px;">
                            <div style="flex:1;">
                                <div style="font-weight:700;">${item.prod_name}</div>
                                <div style="font-size:13px; color:var(--gray4); margin-top:4px;">옵션: ${item.color} / ${item.size_val}</div>
                                <div style="font-size:13px; color:var(--gray4);">수량: ${item.cart_qty}개</div>
                            </div>
                            <div style="font-weight:700; font-size:15px;">
                                <fmt:formatNumber value="${item.prod_price * item.cart_qty}" pattern="#,###"/>원
                            </div>
                            
                            <%-- 결제 시 히든으로 장바구니 번호를 서버로 넘김 --%>
                            <input type="hidden" name="cart_num" value="${item.cart_num}">
                        </div>
                    </c:forEach>
                </div>
            
                <%-- 배송 정보 --%>
                <div class="form-sec" style="max-width:100%; margin-bottom:24px;">
                    <div class="sec-title" style="margin-bottom:20px;">배송 정보</div>
                    
                    <div class="form-group">
                        <label class="form-label">받는 사람</label>
                        <input type="text" class="form-input" name="name" value="${user.user_name}">
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">연락처</label>
                        <input type="text" class="form-input" name="phone" value="${user.phone}">
                    </div>
                    
                    <%-- 주소 --%>
                    <div class="form-group">
                        <label class="form-label">주소</label>
                        <div class="input-with-btn" style="margin-bottom:8px;">
                            <input type="text" class="form-input" name="zipcode" value="${user.zipcode}" readonly placeholder="우편번호">
                            <button type="button" class="btn btn-outline btn-sm">주소 검색</button>
                        </div>
                        <input type="text" class="form-input" name="address1" value="${user.addr1}" style="margin-bottom:8px;" readonly placeholder="기본 주소">
                        <input type="text" class="form-input" name="address2" value="${user.addr2}" placeholder="상세주소를 입력해 주세요">
                    </div>
                </div>
    
                <%-- 결제 수단 --%>
                <div class="form-sec" style="max-width:100%;">
                    <div class="sec-title" style="margin-bottom:20px;">결제 수단</div>
                    <div style="display:grid; grid-template-columns: repeat(3, 1fr); gap:10px;">
                        <button type="button" class="btn btn-outline active" style="font-weight: 700; border-color: var(--black);">신용카드</button>
                        <button type="button" class="btn btn-outline">무통장입금</button>
                        <button type="button" class="btn btn-outline">카카오페이</button>
                    </div>
                    <%-- 결제수단 선택시 히든으로 서버에 넘김 --%>
                    <input type="hidden" name="pay_type" id="pay_type" value="1">
                </div>
            </div>

            <%-- 오른쪽: 주문 요약 및 결제 --%>
            <div class="cart-summary">
                <div class="cart-summary-box">
                    <div class="cs-title">최종 결제 금액</div>
                    
                    <div class="cs-row"><span>총 상품 금액</span> <span><fmt:formatNumber value="${totalProductPrice}" pattern="#,###"/>원</span></div>
                    <div class="cs-row"><span>배송비</span> <span>무료</span></div>
                    <div class="cs-row" style="color:var(--red);"><span>할인 금액</span> <span>-0원</span></div>
                    
                    <div style="border-top: 1px solid var(--border); margin: 20px 0;"></div>
                    
                    <div class="cs-total"><span>최종 결제 금액</span> <span style="color:var(--blue);"><fmt:formatNumber value="${totalProductPrice}" pattern="#,###"/>원</span></div>
                    
                    <button type="submit" class="btn btn-black btn-full" style="margin-top:20px; height:52px; font-size:16px;">결제하기</button>
                </div>
            </div>
            
        </form>
    </div>
</body>
</html>