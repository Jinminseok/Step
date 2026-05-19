<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
                            
                            <%-- 결제 시 장바구니 번호를 서버로 넘김 --%>
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
                        <button type="button" class="btn btn-outline pay-btn" onclick="selectPayType(this, 1)">신용카드</button>
                        <button type="button" class="btn btn-outline pay-btn" onclick="selectPayType(this, 2)">무통장입금</button>
                        <button type="button" class="btn btn-outline pay-btn" onclick="selectPayType(this, 3)">카카오페이</button>
                    </div>
                    
                    <input type="hidden" name="pay_type" id="pay_type" value="">
                    
                    <div id="pay_notice" style="margin-top:15px; font-size:14px; color:var(--gray3);">
                        결제 수단을 선택해 주세요.
                    </div>
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

<script>
// 결제 수단 클릭 시
function selectPayType(element, type) {
    // 서버로 보낼 hidden input 값
    document.getElementById('pay_type').value = type;
    
    // 버튼 디자인 토글
    $('.pay-btn').removeClass('active').css({'font-weight':'normal', 'border-color':'var(--border)'});
    $(element).addClass('active').css({'font-weight':'700', 'border-color':'var(--black)'});
    
    // 하단 안내 문구 변경
    let notice = document.getElementById('pay_notice');
    if(type === 1) {
        notice.innerHTML = "신용카드 결제창이 열립니다.";
    } else if(type === 2) {
        notice.innerHTML = "입금계좌: 신한은행 110-123-456789 (예금주: ShoeMall)<br>주문 완료 후 입금해 주시기 바랍니다.";
    } else if(type === 3) {
        notice.innerHTML = "<span style='color:#000; font-weight:bold; background:#FEE500; padding:2px 5px;'>카카오페이</span> 빠르고 간편하게 결제하세요!";
    }
}

// 유효성 검사
$('#paymentForm').on('submit', function(event) {
    let payType = $('#pay_type').val();
    
    // 결제 수단이 선택되지 않았으면
    if (payType === "") {
        alert("결제 수단을 선택해주세요.");
        event.preventDefault(); // 데이터가 넘어가는 것을 차단
        return false;
    }
    
});
</script>
</body>
</html>