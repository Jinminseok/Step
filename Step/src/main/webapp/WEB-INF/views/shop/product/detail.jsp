<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>ShoeMall - 상품 상세</title>
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700;900&family=Space+Grotesk:wght@600;700&display=swap" rel="stylesheet">
<!-- 외부 CSS 파일 하나만 깔끔하게 불러옵니다 -->
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/KR_style.css">
</head>
<body>
    <jsp:include page="/WEB-INF/views/common/header.jsp"/>

    <div class="wrap">
        <div class="back-btn" onclick="history.back()" style="margin-bottom: 10px;">← 목록으로</div>
        
        <div class="detail-layout">
            
            <%-- 1. 왼쪽: 다중 이미지 영역 --%>
            <div class="detail-imgs-wrap">
                <div class="thumb-list">
                    <img src="${pageContext.request.contextPath}/images/shoe_sample1.jpg" class="thumb-img active" onclick="changeMainImg(this)">
                    <img src="${pageContext.request.contextPath}/images/shoe_sample2.jpg" class="thumb-img" onclick="changeMainImg(this)">
                    <img src="${pageContext.request.contextPath}/images/shoe_sample3.jpg" class="thumb-img" onclick="changeMainImg(this)">
                </div>
                <div class="main-img-box">
                    <img id="mainImage" src="${pageContext.request.contextPath}/images/shoe_sample1.jpg" alt="메인 상품 이미지">
                </div>
            </div>

            <%-- 2. 오른쪽: 상품 정보 및 옵션 영역 --%>
            <div class="detail-info-wrap">
                <div class="detail-brand">NIKE / 운동화</div>
                <div class="detail-name">에어맥스 270 블랙 2024</div>
                <div class="detail-eng">Nike Air Max 270 Black 2024</div>
                
                <div style="font-size:13px; color:var(--gray3); margin-bottom: 20px;">
                    <span style="color:#fbc02d; font-size:15px;">★★★★☆</span> 4.5 (리뷰 124개)
                </div>

                <div class="detail-price-row">
                    <span class="detail-discount">15%</span>
                    <span class="detail-price">189,000원</span>
                    <span class="detail-origin">222,000원</span>
                </div>
                
                <c:if test="${isLogin}">
                    <div style="background:#e8f5e9; padding:12px 16px; border-radius:4px; margin-bottom:24px; font-size:13px; display: flex; align-items: center; gap: 8px;">
                        <span>👑</span>
                        <span><strong>
                            <c:choose>
                                <c:when test="${grade == 1}">BRONZE</c:when>
                                <c:when test="${grade == 2}">SILVER</c:when>
                                <c:when test="${grade == 3}">GOLD</c:when>
                                <c:when test="${grade == 4}">VIP</c:when>
                                <c:otherwise>일반</c:otherwise>
                            </c:choose>
                        </strong> 회원님을 위한 추가 혜택가:</span>
                        <strong style="color:#2e7d32; font-size:16px;">180,000원</strong>
                    </div>
                </c:if>

                <div class="color-label">
                    <div>색상 선택 <span id="selectedColorText" style="color:var(--blue); font-weight:500; margin-left:4px;"></span></div>
                </div>
                <div class="color-grid">
                    <div class="color-btn" style="background-color: #000;" onclick="selectColor(this, '블랙')"></div>
                    <div class="color-btn" style="background-color: #fff;" onclick="selectColor(this, '화이트')"></div>
                    <div class="color-btn" style="background-color: #808080;" onclick="selectColor(this, '그레이')"></div>
                </div>

                <div class="size-label">
                    <div>사이즈 선택 <span id="selectedSizeText" style="color:var(--blue); font-weight:500; margin-left:4px;"></span></div>
                    <span style="font-weight:400; color:var(--blue); cursor:pointer;">사이즈 가이드</span>
                </div>
                <div class="size-grid">
                    <button class="size-btn" onclick="selectSize(this, 230)">230</button>
                    <button class="size-btn" onclick="selectSize(this, 240)">240</button>
                    <button class="size-btn" onclick="selectSize(this, 250)">250</button>
                    <button class="size-btn" onclick="selectSize(this, 260)">260</button>
                    <button class="size-btn sold" onclick="alert('품절된 사이즈입니다.')">270 (품절)</button>
                </div>
                
                <c:set var="stock" value="48" />
                <div style="font-size:12px; color:var(--gray4); margin-bottom: 24px;">재고 : ${stock}개</div>

                <form id="orderForm" action="${pageContext.request.contextPath}/shop/cart/add.do" method="post">
                    <input type="hidden" name="prod_num" value="${prod_num}">
                    <input type="hidden" name="color" id="input_color" value="">
                    <input type="hidden" name="size" id="input_size" value="">
                </form>

                <div class="detail-btns">
                    <button class="btn-wish-lg" onclick="handleWish()">🤍</button>
                    
                    <c:choose>
                        <c:when test="${stock > 0}">
                            <button class="btn btn-gray" onclick="handleAction('cart')" style="font-size: 14px; padding: 14px; border-radius: 4px;">장바구니 담기</button>
                            <button class="btn btn-black" onclick="handleAction('buy')" style="font-size: 14px; padding: 14px; border-radius: 4px;">바로 구매하기</button>
                        </c:when>
                        <c:otherwise>
                            <button class="btn btn-gray" disabled style="cursor:not-allowed; opacity:0.6; font-size: 14px; padding: 14px; border-radius: 4px;">장바구니 (불가)</button>
                            <button class="btn btn-black" onclick="handleAction('restock')" style="font-size: 14px; padding: 14px; border-radius: 4px;">재입고 알림 신청</button>
                        </c:otherwise>
                    </c:choose>
                </div>
                <div style="font-size:12px; color:var(--gray4); margin-top:14px; text-align:center;">💳 카카오페이 간편결제 가능</div>
            </div>
        </div>

        <%-- 3. 하단 탭 영역 --%>
        <div class="bottom-tabs">
            <div class="bt-tab on" onclick="changeTab(this, 'tab-info')">상품 정보</div>
            <div class="bt-tab" onclick="changeTab(this, 'tab-review')">별점 및 리뷰 (124)</div>
            <div class="bt-tab" onclick="changeTab(this, 'tab-recom')">추천 상품</div>
        </div>

        <div id="tab-info" class="bt-content on">
            <h3 style="font-size:18px; margin-bottom:20px;">필수 표기정보</h3>
            <table class="info-table">
                <tr><th>상품번호</th><td>13292394432</td></tr>
                <tr><th>제조사</th><td>(주)NIKE</td></tr>
                <tr><th>브랜드</th><td>NIKE</td></tr>
                <tr><th>모델명</th><td>AM270-BLK</td></tr>
                <tr><th>제조일자</th><td>2024.03.01</td></tr>
            </table>
        </div>

        <div id="tab-review" class="bt-content">
            <div style="color:var(--gray4); padding: 60px; text-align: center; border: 1px solid var(--border); background: var(--gray7); border-radius: 8px;">
                등록된 리뷰 목록이 여기에 표시됩니다.
            </div>
        </div>

        <div id="tab-recom" class="bt-content">
            <div style="color:var(--gray4); padding: 60px; text-align: center; border: 1px solid var(--border); background: var(--gray7); border-radius: 8px;">
                비슷한 스타일의 추천 신발 목록이 표시됩니다.
            </div>
        </div>

    </div>

<script>
const isLogin = ${isLogin}; 
let selectedColor = "";
let selectedSize = "";

function changeMainImg(element) {
    document.querySelectorAll('.thumb-img').forEach(img => img.classList.remove('active'));
    element.classList.add('active');
    document.getElementById('mainImage').src = element.src;
}

function selectColor(element, color) {
    document.querySelectorAll('.color-btn').forEach(btn => btn.classList.remove('on'));
    element.classList.add('on');
    selectedColor = color;
    document.getElementById('selectedColorText').innerText = "(" + color + ")";
    document.getElementById('input_color').value = color;
}

function selectSize(element, size) {
    if(element.classList.contains('sold')) return;
    document.querySelectorAll('.size-btn').forEach(btn => btn.classList.remove('on'));
    element.classList.add('on');
    selectedSize = size;
    document.getElementById('selectedSizeText').innerText = "(" + size + ")";
    document.getElementById('input_size').value = size;
}

function changeTab(element, tabId) {
    document.querySelectorAll('.bt-tab').forEach(t => t.classList.remove('on'));
    element.classList.add('on');
    document.querySelectorAll('.bt-content').forEach(c => c.classList.remove('on'));
    document.getElementById(tabId).classList.add('on');
}

function requireLogin() {
    if(!isLogin) {
        alert("로그인 후 이용 가능한 서비스입니다.");
        location.href = "${pageContext.request.contextPath}/shop/user/loginForm.do";
        return false;
    }
    return true;
}

function handleWish() {
    if(!requireLogin()) return;
    alert("관심 상품(찜)에 추가되었습니다!");
}

function handleAction(type) {
    if(!requireLogin()) return;
    
    if(type === 'restock') {
        alert("재입고 알림 신청이 완료되었습니다.");
        return;
    }
    
    if(selectedColor === "") {
        alert("상품의 색상을 선택해 주세요.");
        return;
    }
    if(selectedSize === "") {
        alert("상품의 사이즈를 선택해 주세요.");
        return;
    }
    
    if(type === 'cart') {
        alert(selectedColor + " 색상, " + selectedSize + " 사이즈가 장바구니에 담겼습니다!");
    } else if(type === 'buy') {
        alert("결제 페이지로 이동합니다.");
    }
}
</script>
</body>
</html>