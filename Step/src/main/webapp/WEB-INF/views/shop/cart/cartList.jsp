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
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
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
                    <div class="cart-item" style="position: relative;">
                        
                        <%-- 체크박스에 가격 데이터 넣어두기 --%>
                        <div class="cart-check">
                            <input type="checkbox" name="cart_check" class="cart-checkbox" value="${cart.cart_num}" data-price="${cart.prod_price * cart.cart_qty}" checked>
                        </div>
                        
                        <div class="cart-thumb"><img src="${pageContext.request.contextPath}/upload/${cart.prod_img_url}" style="width:100%;"></div>
                        <div style="flex:1;">
                            <div class="cart-brand">${cart.brand_name}</div>
                            <div class="cart-name">${cart.prod_name}</div>
                            <div class="cart-opt">옵션: ${cart.color} / ${cart.size_val}</div>
                            <div class="qty-row">
                                <button class="qty-btn" onclick="alert('수량 변경 기능은 준비 중입니다!')">-</button>
                                <div class="qty-num">${cart.cart_qty}</div>
                                <button class="qty-btn" onclick="alert('수량 변경 기능은 준비 중입니다!')">+</button>
                            </div>
                        </div>
                        
                        <div class="cart-price-col" style="display: flex; flex-direction: column; justify-content: space-between; align-items: flex-end; align-self: stretch;">
                            
                            <%-- 상단: 가격과 삭제 버튼 --%>
                            <div style="text-align: right;">
                                <div class="cart-price"><fmt:formatNumber value="${cart.prod_price * cart.cart_qty}" pattern="#,###"/>원</div>
                                <div class="cart-del" style="cursor:pointer; display:inline-block; margin-top:4px;" onclick="deleteCartItem(${cart.cart_num})">삭제</div>
                            </div>
                            
                            <%-- 하단: 날짜 --%>
                            <div class="cart-date" style="font-size: 12px; color: var(--gray4); white-space: nowrap; margin-bottom: 4px;">
                                <fmt:formatDate value="${cart.cart_created_at}" pattern="yyyy.MM.dd"/> 담음
                            </div>
                            
                        </div>
                        
                    </div>
                </c:forEach>
            </div>

            <%-- 오른쪽: 주문 요약 --%>
            <div class="cart-summary">
                <div class="cart-summary-box">
                    <div class="cs-title">주문 요약</div>
                    <div class="cs-row"><span>총 상품 금액</span> <span id="totalProductPrice">0원</span></div>
                    <div class="cs-row"><span>배송비</span> <span>무료</span></div>
                    <div class="cs-row" style="color:var(--red);"><span>할인 금액</span> <span>-0원</span></div>
                    <div class="cs-total"><span>총 결제 예상 금액</span> <span style="color:var(--blue);" id="finalTotalPrice">0원</span></div>
                    <button class="btn btn-black btn-full" style="margin-top:20px; height:52px; font-size:15px;" onclick="location.href='${pageContext.request.contextPath}/shop/orderpage/orderForm.do'">구매하기</button>
                    <p class="pay-note">쿠폰 및 적립금은 주문서에서 적용 가능합니다.</p>
                </div>
            </div>
        </div>
    </div>

<script>
// 체크된 상품의 금액을 주문 요약에 반영
function calcTotal() {
    let total = 0;
    $('.cart-checkbox:checked').each(function() {
        total += parseInt($(this).data('price'));
    });

    // 가격에 , 표시
    let formatTotal = total.toLocaleString('ko-KR') + '원';
    
    // 주문 요약 영역에 값 반영
    $('#totalProductPrice').text(formatTotal);
    $('#finalTotalPrice').text(formatTotal);
}

$(document).ready(function() {
    // 페이지가 열리자마자 총 금액 계산
    calcTotal();

    // 전체 선택 체크박스 동작
    $('#checkAll').click(function() {
        $('.cart-checkbox').prop('checked', this.checked);
        calcTotal();
    });

    // 개별 체크박스 동작
    $('.cart-checkbox').click(function() {
        if ($('.cart-checkbox:checked').length == $('.cart-checkbox').length) {
            $('#checkAll').prop('checked', true);
        } else {
            $('#checkAll').prop('checked', false);
        }
        calcTotal(); // 금액 다시 계산
    });
});

// 개별 삭제
function deleteCartItem(cart_num) {
    if(!confirm("이 상품을 장바구니에서 삭제하시겠습니까?")) return;

    $.ajax({
        url: '${pageContext.request.contextPath}/shop/cart/deleteCart.do',
        type: 'post',
        data: { cart_num: cart_num },
        dataType: 'json',
        success: function(param) {
            if(param.result === 'logout') {
                alert("로그인이 필요합니다.");
                location.href = '${pageContext.request.contextPath}/shop/user/loginForm.do';
            } else if(param.result === 'success') {
                alert("삭제되었습니다.");
                location.reload(); // 성공 시 화면 새로고침
            }
        },
        error: function() {
            alert("통신 오류가 발생했습니다.");
        }
    });
}
</script>
</body>
</html>