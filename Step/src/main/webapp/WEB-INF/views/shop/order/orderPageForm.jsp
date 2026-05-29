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
						    <input type="text" class="form-input" id="zipcode" name="zipcode" value="${user.zipcode}" readonly placeholder="우편번호">
						    <button type="button" class="btn btn-outline btn-sm" onclick="execDaumPostcode()">주소 검색</button>
						</div>
						<input type="text" class="form-input" id="address1" name="address1" value="${user.addr1}" style="margin-bottom:8px;" readonly placeholder="기본 주소">
						<input type="text" class="form-input" id="address2" name="address2" value="${user.addr2}" placeholder="상세주소를 입력해 주세요">
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
                    
                    <%-- 등급별 할인 금액 및 뱃지 --%>
                    <div class="cs-row" style="color:var(--red);">
                        <span style="display:flex; align-items:center; gap:6px;">
                            할인 금액
                            <c:if test="${user.grade >= 2}">
                                <c:choose>
                                    <c:when test="${user.grade == 2}"><span style="background:#e0f2fe;color:#0369a1;font-size:10px;padding:2px 6px;border-radius:4px;font-weight:700;">SILVER 3%</span></c:when>
                                    <c:when test="${user.grade == 3}"><span style="background:#fef08a;color:#b45309;font-size:10px;padding:2px 6px;border-radius:4px;font-weight:700;">GOLD 5%</span></c:when>
                                    <c:when test="${user.grade == 4}"><span style="background:#000;color:#fff;font-size:10px;padding:2px 6px;border-radius:4px;font-weight:700;">VIP 10%</span></c:when>
                                </c:choose>
                            </c:if>
                        </span> 
                        <span>-<fmt:formatNumber value="${discountAmount}" pattern="#,###"/>원</span>
                    </div>
                    
                    <div style="border-top: 1px solid var(--border); margin: 20px 0;"></div>
                    
                    <%-- 최종 결제 금액 --%>
                    <div class="cs-total"><span>최종 결제 금액</span> <span style="color:var(--blue);"><fmt:formatNumber value="${finalPayPrice}" pattern="#,###"/>원</span></div>
                    
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

<!-- 우편번호 처리 시작 -->	
<!-- iOS에서는 position:fixed 버그가 있음, 적용하는 사이트에 맞게 position:absolute 등을 이용하여 top,left값 조정 필요 -->
<div id="layer" style="display:none;position:fixed;overflow:hidden;z-index:1;-webkit-overflow-scrolling:touch;">
<img src="//t1.daumcdn.net/postcode/resource/images/close.png" id="btnCloseLayer" style="cursor:pointer;position:absolute;right:-3px;top:-3px;z-index:1" onclick="closeDaumPostcode()" alt="닫기 버튼">
</div>

<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script>
    // 우편번호 찾기 화면을 넣을 element
    var element_layer = document.getElementById('layer');

    function closeDaumPostcode() {
        // iframe을 넣은 element를 안보이게 한다.
        element_layer.style.display = 'none';
    }

    function execDaumPostcode() {
        new daum.Postcode({
            oncomplete: function(data) {
                // 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.

                // 각 주소의 노출 규칙에 따라 주소를 조합한다.
                // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
                var addr = ''; // 주소 변수
                var extraAddr = ''; // 참고항목 변수

                //사용자가 선택한 주소 타입에 따라 해당 주소 값을 가져온다.
                if (data.userSelectedType === 'R') { // 사용자가 도로명 주소를 선택했을 경우
                    addr = data.roadAddress;
                } else { // 사용자가 지번 주소를 선택했을 경우(J)
                    addr = data.jibunAddress;
                }

                // 사용자가 선택한 주소가 도로명 타입일때 참고항목을 조합한다.
                if(data.userSelectedType === 'R'){
                    // 법정동명이 있을 경우 추가한다. (법정리는 제외)
                    // 법정동의 경우 마지막 문자가 "동/로/가"로 끝난다.
                    if(data.bname !== '' && /[동|로|가]$/g.test(data.bname)){
                        extraAddr += data.bname;
                    }
                    // 건물명이 있고, 공동주택일 경우 추가한다.
                    if(data.buildingName !== '' && data.apartment === 'Y'){
                        extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
                    }
                    // 표시할 참고항목이 있을 경우, 괄호까지 추가한 최종 문자열을 만든다.
                    if(extraAddr !== ''){
                        extraAddr = ' (' + extraAddr + ')';
                    }
                
                } 

                // 우편번호와 주소 정보를 해당 필드에 넣는다.
                document.getElementById('zipcode').value = data.zonecode;
                //(수정) + extraAddr를 추가해서 address1에 참고항목이 보여지도록 수정
                document.getElementById("addr1").value = addr + extraAddr;
                // 커서를 상세주소 필드로 이동한다.
                document.getElementById("addr2").focus();
                
                //주소 안내 메시지 초기화
                document.getElementById('zipcode').dispatchEvent(new Event('input'));
                document.getElementById('addr1').dispatchEvent(new Event('input'));

                // iframe을 넣은 element를 안보이게 한다.
                // (autoClose:false 기능을 이용한다면, 아래 코드를 제거해야 화면에서 사라지지 않는다.)
                element_layer.style.display = 'none';
            },
            width : '100%',
            height : '100%',
            maxSuggestItems : 5
        }).embed(element_layer);

        // iframe을 넣은 element를 보이게 한다.
        element_layer.style.display = 'block';

        // iframe을 넣은 element의 위치를 화면의 가운데로 이동시킨다.
        initLayerPosition();
    }

    // 브라우저의 크기 변경에 따라 레이어를 가운데로 이동시키고자 하실때에는
    // resize이벤트나, orientationchange이벤트를 이용하여 값이 변경될때마다 아래 함수를 실행 시켜 주시거나,
    // 직접 element_layer의 top,left값을 수정해 주시면 됩니다.
    function initLayerPosition(){
        var width = 300; //우편번호서비스가 들어갈 element의 width
        var height = 400; //우편번호서비스가 들어갈 element의 height
        var borderWidth = 5; //샘플에서 사용하는 border의 두께

        // 위에서 선언한 값들을 실제 element에 넣는다.
        element_layer.style.width = width + 'px';
        element_layer.style.height = height + 'px';
        element_layer.style.border = borderWidth + 'px solid';
        // 실행되는 순간의 화면 너비와 높이 값을 가져와서 중앙에 뜰 수 있도록 위치를 계산한다.
        element_layer.style.left = (((window.innerWidth || document.documentElement.clientWidth) - width)/2 - borderWidth) + 'px';
        element_layer.style.top = (((window.innerHeight || document.documentElement.clientHeight) - height)/2 - borderWidth) + 'px';
    }
</script>
<!-- 우편번호 처리 끝 -->	
</body>
</html>