<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>ShoeMall - ${product.prod_name}</title>
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700;900&family=Space+Grotesk:wght@600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/KR_style.css">
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
</head>
<body>
    <jsp:include page="/WEB-INF/views/common/header.jsp"/>

    <div class="wrap">
        <div class="back-btn" onclick="history.back()" style="margin-bottom: 10px;">← 목록으로</div>
        
        <div class="detail-layout">
            
            <%-- 1. 왼쪽: 다중 이미지 영역 (DB 연동) --%>
            <div class="detail-imgs-wrap">
                <div class="thumb-list">
                    <%-- DB에 저장된 사진 개수만큼 반복해서 썸네일 생성 --%>
                    <c:forEach var="img" items="${imgList}" varStatus="status">
                        <img src="${pageContext.request.contextPath}/upload/${img}" 
                             class="thumb-img ${status.first ? 'active' : ''}" 
                             onclick="changeMainImg(this)">
                    </c:forEach>
                </div>
                <div class="main-img-box">
                    <%-- 메인 이미지는 리스트의 첫 번째 사진으로 세팅 --%>
                    <img id="mainImage" src="${pageContext.request.contextPath}/upload/${imgList[0]}" alt="${product.prod_name}">
                </div>
            </div>

            <%-- 2. 오른쪽: 상품 정보 및 옵션 영역 (DB 연동) --%>
            <div class="detail-info-wrap">
                <div class="detail-brand">${product.brand_name}</div>
                <div class="detail-name">${product.prod_name}</div>
                <div class="detail-eng" style="margin-bottom: 16px;">SKU: ${product.sku}</div>
                
                <div style="font-size:13px; color:var(--gray3); margin-bottom: 20px;">
                    <span style="color:#fbc02d; font-size:15px;">★★★★☆</span> 4.5 (리뷰 0개)
                </div>

                <%-- 가격 영역 (할인율 적용) --%>
                <div class="detail-price-row">
                    <c:if test="${product.sale_rate > 0}">
                        <span class="detail-discount">${product.sale_rate}%</span>
                    </c:if>
                    <span class="detail-price"><fmt:formatNumber value="${salePrice}" pattern="#,###"/>원</span>
                    <c:if test="${product.sale_rate > 0}">
                        <span class="detail-origin"><fmt:formatNumber value="${product.prod_price}" pattern="#,###"/>원</span>
                    </c:if>
                </div>
                
                <%-- 로그인 혜택 --%>
                <c:if test="${isLogin}">
                    <div style="background:#e8f5e9; padding:12px 16px; border-radius:4px; margin-bottom:24px; font-size:13px; display: flex; align-items: center; gap: 8px;">
                        <span>👑</span>
                        <span><strong>${grade}등급</strong> 회원 추가 혜택가:</span>
                        <strong style="color:#2e7d32; font-size:16px;">
                            <fmt:formatNumber value="${salePrice - 5000}" pattern="#,###"/>원
                        </strong>
                    </div>
                </c:if>

                <%-- ★ 색상 선택 (DB 연동) --%>
                <div class="color-label">
                    <div>색상 선택 <span id="selectedColorText" style="color:var(--blue); font-weight:500; margin-left:4px;"></span></div>
                </div>
                <div class="color-grid">
                    <c:forEach var="color" items="${colorList}">
                        <%-- 색상 이름이 '블랙'이면 검정색, '화이트'면 흰색으로 UI 표현 처리 (임시) --%>
                        <c:set var="bgColor" value="#ccc" />
                        <c:if test="${color == '블랙' or color == 'Black'}"><c:set var="bgColor" value="#000" /></c:if>
                        <c:if test="${color == '화이트' or color == 'White'}"><c:set var="bgColor" value="#fff" /></c:if>
                        
                        <div class="color-btn" style="background-color: ${bgColor};" onclick="selectColor(this, '${color}')" title="${color}"></div>
                    </c:forEach>
                </div>

                <%-- ★ 사이즈 선택 (DB 연동) --%>
                <div class="size-label">
                    <div>사이즈 선택 <span id="selectedSizeText" style="color:var(--blue); font-weight:500; margin-left:4px;"></span></div>
                </div>
                <div class="size-grid">
                    <c:forEach var="size" items="${sizeList}">
                        <button class="size-btn" onclick="selectSize(this, ${size})">${size}</button>
                    </c:forEach>
                </div>
                
                <div style="font-size:12px; color:var(--gray4); margin-bottom: 24px;">현재 선택 가능한 재고 : ${totalStock}개</div>

                <form id="orderForm" action="${pageContext.request.contextPath}/shop/cart/add.do" method="post">
                    <input type="hidden" name="prod_num" value="${product.prod_num}">
                    <input type="hidden" name="color" id="input_color" value="">
                    <input type="hidden" name="size" id="input_size" value="">
                </form>

                <%-- 초기 버튼 상태 (비활성화) --%>
                <div class="detail-btns">
                    <button class="btn-wish-lg" onclick="handleWish()">🤍</button>
                    <button id="cartBtn" class="btn btn-gray" disabled style="cursor:not-allowed; opacity:0.6; font-size: 14px; padding: 14px;">옵션을 선택해 주세요</button>
                    <button id="buyBtn" class="btn btn-black" disabled style="cursor:not-allowed; opacity:0.6; font-size: 14px; padding: 14px;">옵션을 선택해 주세요</button>
                </div>
            </div>
        </div>
	</div>

<script>
const isLogin = ${isLogin};
const stockData = ${empty optionJson ? '[]' : optionJson};

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
    
    checkOptionStock(); // 색상을 누를 때마다 검사
}

function selectSize(element, size) {
    document.querySelectorAll('.size-btn').forEach(btn => btn.classList.remove('on'));
    element.classList.add('on');
    selectedSize = size;
    document.getElementById('selectedSizeText').innerText = "(" + size + ")";
    document.getElementById('input_size').value = size;
    
    checkOptionStock(); // 사이즈를 누를 때마다 검사
}

function checkOptionStock() {
    // 1. 색상과 사이즈 둘 다 골랐을 때만 작동
    if(selectedColor === "" || selectedSize === "") return;

    // 2. 재고표에서 지금 고른 조합 찾기
    let matchedOption = stockData.find(opt => opt.color === selectedColor && opt.size === selectedSize);
    
    // 3. 재고량 파악
    let currentStock = matchedOption ? matchedOption.stock : 0;

    let $cartBtn = $('#cartBtn');
    let $buyBtn = $('#buyBtn');

    if (currentStock > 0) {
        // 재고가 있을 때: 장바구니 / 바로구매 활성화
        $cartBtn.text('장바구니').prop('disabled', false).css({'cursor':'pointer', 'opacity':'1'})
                .attr('onclick', "handleAction('cart')");
        $buyBtn.text('바로 구매').prop('disabled', false).css({'cursor':'pointer', 'opacity':'1', 'background-color':'var(--black)'})
               .attr('onclick', "handleAction('buy')");
    } else {
        // 품절일 때: 장바구니 막기 / 재입고 알림 신청 활성화
        $cartBtn.text('품절').prop('disabled', true).css({'cursor':'not-allowed', 'opacity':'0.6'})
                .removeAttr('onclick');
        $buyBtn.text('재입고 알림 신청').prop('disabled', false).css({'cursor':'pointer', 'opacity':'1', 'background-color':'#d32f2f'}) // 빨간 버튼으로 변경!
               .attr('onclick', "handleAction('restock')");
    }
}

function requireLogin() {
    if(!isLogin) {
        alert("로그인 후 이용 가능한 서비스입니다.");
        location.href = "${pageContext.request.contextPath}/shop/user/loginForm.do";
        return false;
    }
    return true;
}

// 찜(즐겨찾기) 기능
function handleWish() {
    if(!requireLogin()) return;

    let prod_num = $('input[name="prod_num"]').val();

    $.ajax({
    	url: '${pageContext.request.contextPath}/shop/wish/writeWish.do',
        type: 'post',
        data: { prod_num: prod_num },
        dataType: 'json',
        success: function(param) {
            if(param.result === 'logout') {
                alert("로그인 후 이용 가능합니다.");
                location.href = '${pageContext.request.contextPath}/shop/user/loginForm.do';
            } else if (param.result === 'success') {
                alert("관심 상품(찜)에 추가되었습니다!");
                $('.btn-wish-lg').addClass('on'); // 버튼에 불 들어오게 처리
            }
        },
        error: function(xhr, status, error) {
            console.log("에러 상태:", xhr.status, xhr.responseText);
            alert("통신 중 오류가 발생했습니다.");
        }
    });
}

// 장바구니, 바로구매
function handleAction(type) {
    if(!requireLogin()) return;
    
    if(type === 'restock') { alert("재입고 알림 신청이 완료되었습니다."); return; }
    if(selectedColor === "") { alert("상품의 색상을 선택해 주세요."); return; }
    if(selectedSize === "") { alert("상품의 사이즈를 선택해 주세요."); return; }
    
    if(type === 'cart') {
        // 유저가 진짜 선택한 정보들 수집
        let prod_num = $('input[name="prod_num"]').val();
        let color = $('#input_color').val();
        let size = $('#input_size').val();
        let cart_qty = 1; // 기본 수량

        $.ajax({
            url: '${pageContext.request.contextPath}/shop/cart/writeCart.do',
            type: 'post',
            data: {
                prod_num: prod_num,
                color: color,
                size: size,
                cart_qty: cart_qty
            },
            dataType: 'json',
            success: function(param) {
                if(param.result === 'logout') {
                    alert("로그인 후 이용 가능합니다.");
                    location.href = '${pageContext.request.contextPath}/shop/user/loginForm.do';
                } else if (param.result === 'success') {
                    if(confirm(selectedColor + " 색상, " + selectedSize + " 사이즈가 장바구니에 담겼습니다!\n장바구니로 이동하시겠습니까?")) {
                        location.href = '${pageContext.request.contextPath}/shop/cart/cartList.do';
                    }
                }
            },
            error: function(xhr, status, error) {
                console.log("에러 상태:", xhr.status, xhr.responseText);
                alert("통신 중 오류가 발생했습니다.");
            }
        });
        
    } else if(type === 'buy') {
        document.getElementById('orderForm').submit();
    }
}
</script>
</body>
</html>