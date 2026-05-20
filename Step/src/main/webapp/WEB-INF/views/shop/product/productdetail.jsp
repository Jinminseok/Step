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
<style>
    .sticky-tabs { display: flex; position: sticky; top: 56px; background: #fff; z-index: 100; border-bottom: 2px solid var(--black); margin-bottom: 40px; }
    .sticky-tab { flex: 1; text-align: center; padding: 18px 0; font-size: 16px; font-weight: 700; cursor: pointer; background: #fff; color: var(--gray3); border: 1px solid var(--border); border-bottom: none; transition: background-color 0.2s, color 0.2s; }
    .sticky-tab.active { background: var(--black); color: #fff; border-color: var(--black); }
    .scroll-section { scroll-margin-top: 170px; }
</style>
</head>
<body>
    <jsp:include page="/WEB-INF/views/common/header.jsp"/>

    <div class="wrap">
        <div class="back-btn" onclick="history.back()" style="margin-bottom: 10px; cursor: pointer;">← 목록으로</div>
        
        <div class="detail-layout">
        
        	<%-- 왼쪽: 다중 이미지 영역 --%>
            <div class="detail-imgs-wrap">
                <div class="thumb-list">
                    <c:forEach var="img" items="${imgList}" varStatus="status">
                        <img src="${pageContext.request.contextPath}/upload/${img}" class="thumb-img ${status.first ? 'active' : ''}" onclick="changeMainImg(this)">
                    </c:forEach>
                </div>
                <div class="main-img-box">
                    <img id="mainImage" src="${pageContext.request.contextPath}/upload/${imgList[0]}" alt="${product.prod_name}">
                </div>
            </div>
            
            <%-- 오른쪽: 상품 정보 및 옵션 --%>
            <div class="detail-info-wrap">
                <div class="detail-brand">${product.brand_name}</div>
                <div class="detail-name">${product.prod_name}</div>
                <div class="detail-eng" style="margin-bottom: 16px;">SKU: ${product.sku}</div>
                
                <div style="font-size:13px; color:var(--gray3); margin-bottom: 20px;">
                    <span style="color:#fbc02d; font-size:15px;">★★★★☆</span> 4.5 (리뷰 0개)
                </div>
                
                <%-- 가격 영역 --%>
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
                    <div style="background:#e8f5e9; padding:12px 16px; border-radius:4px; margin-bottom:24px; font-size:13px; display:flex; align-items:center; gap:8px;">
                        <span>👑</span>
                        <span><strong>${grade}등급</strong> 회원 추가 혜택가:</span>
                        <strong style="color:#2e7d32; font-size:16px;"><fmt:formatNumber value="${salePrice - 5000}" pattern="#,###"/>원</strong>
                    </div>
                </c:if>
                
                <%-- 색상 선택 --%>
                <div class="color-label"><div>색상 선택 <span id="selectedColorText" style="color:var(--blue); font-weight:500; margin-left:4px;"></span></div></div>
                <div class="color-grid">
                    <c:forEach var="color" items="${colorList}">
                        <c:set var="bgColor" value="#ccc" />
                        <c:if test="${color == '블랙' or color == 'Black'}"><c:set var="bgColor" value="#000000" /></c:if>
                        <c:if test="${color == '화이트' or color == 'White'}"><c:set var="bgColor" value="#ffffff" /></c:if>
                        <c:if test="${color == '그레이' or color == 'Gray'}"><c:set var="bgColor" value="#8C8C8C" /></c:if>
                        <c:if test="${color == '베이지' or color == 'Beige'}"><c:set var="bgColor" value="#D4B886" /></c:if>
                        <c:if test="${color == '네이비' or color == 'Navy'}"><c:set var="bgColor" value="#13264E" /></c:if>
                        <c:if test="${color == '레드' or color == 'Red'}"><c:set var="bgColor" value="#FF0000" /></c:if>
                        <c:if test="${color == '그린' or color == 'Green'}"><c:set var="bgColor" value="#6BEC62" /></c:if>
                        <div class="color-btn" style="background-color:${bgColor};" onclick="selectColor(this, '${color}')" title="${color}"></div>
                    </c:forEach>
                </div>
                
                <%-- 사이즈 선택 --%>
                <div class="size-label"><div>사이즈 선택 <span id="selectedSizeText" style="color:var(--blue); font-weight:500; margin-left:4px;"></span></div></div>
                <div class="size-grid">
                    <c:forEach var="size" items="${sizeList}">
                        <button class="size-btn" onclick="selectSize(this, ${size})">${size}</button>
                    </c:forEach>
                </div>
                
                <%-- 자바스크립트에서 재고를 갱신 --%>
                <div id="dynamicStockDisplay" style="font-size:12px; color:var(--gray4); margin-bottom:24px;">옵션을 선택하시면 재고가 표시됩니다. (총 재고: ${totalStock}개)</div>
                
                <%-- 장바구니/바로구매 --%>
                <form id="orderPageForm" action="${pageContext.request.contextPath}/shop/order/orderPageForm.do" method="post">
                    <input type="hidden" name="prod_num" value="${product.prod_num}">
                    <input type="hidden" name="color" id="input_color" value="">
                    <input type="hidden" name="size" id="input_size" value="">
                </form>
                
                <%-- ✅ 재입고 신청 전용 form (script 밖에 위치) --%>
                <form id="restockForm" action="${pageContext.request.contextPath}/shop/restock/restockAlert.do" method="post">
                    <input type="hidden" name="prod_num" value="${product.prod_num}">
                    <input type="hidden" name="opt_num" id="restock_opt_num" value="">
                </form>
                
                <%-- 버튼 영역 --%>
                <div class="detail-btns">
                    <%-- 찜 상태에 따라 빨간 하트 유지 --%>
                    <button class="btn-wish-lg ${isWished ? 'on' : ''}" onclick="handleWish()">🤍</button>
                    <button id="cartBtn" class="btn btn-gray" disabled style="cursor:not-allowed; opacity:0.6; font-size:14px; padding:14px;">옵션을 선택해 주세요</button>
                    <button id="buyBtn" class="btn btn-black" disabled style="cursor:not-allowed; opacity:0.6; font-size:14px; padding:14px;">옵션을 선택해 주세요</button>
                </div>
            </div>
        </div>
        
        <%-- 하단 탭 영역 --%>
        <div class="detail-bottom-area" style="position: relative; margin-top: 80px;">
        	<%-- 탭 메뉴 바 --%>
            <div class="sticky-tabs">
                <div class="sticky-tab active" id="tab-btn-info" onclick="scrollToSection('info')">정보</div>
                <div class="sticky-tab" id="tab-btn-size" onclick="scrollToSection('size')">사이즈</div>
                <div class="sticky-tab" id="tab-btn-recommend" onclick="scrollToSection('recommend')">추천 상품</div>
                <div class="sticky-tab" id="tab-btn-review" onclick="scrollToSection('review')">리뷰 (0)</div>
            </div>
            
            <%-- 1. 정보 --%>
            <div id="content-info" class="scroll-section" style="padding-top: 20px; padding-bottom: 40px; border-bottom: 1px solid var(--border);">
                <div style="max-width: 800px; margin: 0 auto;">
                    <h3 style="font-size: 18px; font-weight: 700; margin-bottom: 16px;">상품 기본 정보</h3>
                    <table class="info-table" style="margin-bottom: 60px;">
                        <tbody>
                            <tr><th>품번</th><td>${product.sku}</td><th>브랜드</th><td>${product.brand_name}</td></tr>
                            <tr>
                                <th>성별</th>
                                <td>
                                    <c:choose>
                                        <c:when test="${product.gender == 1}">남성 (Men)</c:when>
                                        <c:when test="${product.gender == 2}">여성 (Women)</c:when>
                                        <c:otherwise>남녀공용</c:otherwise>
                                    </c:choose>
                                </td>
                                <th>제조사</th><td>${product.brand_name} 협력업체</td>
                            </tr>
                        </tbody>
                    </table>
                    <c:if test="${empty product.prod_text}"><div style="padding: 40px 0; color: var(--gray4); text-align: center;">등록된 상세 설명이 없습니다.</div></c:if>
                    <c:if test="${!empty product.prod_text}"><div style="text-align: center;">${product.prod_text}</div></c:if>
                </div>
            </div>

            <%-- 2. 사이즈 --%>
            <div id="content-size" class="scroll-section" style="padding-top: 30px; padding-bottom: 40px; border-bottom: 1px solid var(--border);">
                <div style="max-width: 800px; margin: 0 auto;">
                    <h3 style="font-size: 18px; font-weight: 700; margin-bottom: 12px;">Size Guide</h3>
                    <p style="font-size: 13px; color: var(--gray3); margin-bottom: 24px;">본 사이즈 표는 표준 규격을 기준으로 제작되었습니다. 브랜드 디자인에 따라 약간의 오차가 있을 수 있습니다.</p>
                    <table class="info-table">
                        <thead><tr><th>KR (mm)</th><th style="text-align: center;">US (Men)</th><th style="text-align: center;">UK</th><th style="text-align: center;">EU</th></tr></thead>
                        <tbody style="text-align: center;">
                            <tr><td style="font-weight:700;">230</td><td>5</td><td>4</td><td>37.5</td></tr>
                            <tr><td style="font-weight:700;">240</td><td>6</td><td>5</td><td>38.5</td></tr>
                            <tr><td style="font-weight:700;">250</td><td>7</td><td>6</td><td>40</td></tr>
                            <tr><td style="font-weight:700;">260</td><td>8</td><td>7</td><td>41</td></tr>
                            <tr><td style="font-weight:700;">270</td><td>9</td><td>8</td><td>42.5</td></tr>
                            <tr><td style="font-weight:700;">280</td><td>10</td><td>9</td><td>44</td></tr>
                        </tbody>
                    </table>
                </div>
            </div>

            <%-- 3. 추천 상품 --%>
            <div id="content-recommend" class="scroll-section" style="padding-top: 30px; padding-bottom: 40px; border-bottom: 1px solid var(--border);">
                <div style="max-width: 900px; margin: 0 auto;">
                    <h3 style="font-size: 18px; font-weight: 700; margin-bottom: 30px; text-align: center;">이런 상품은 어떠세요?</h3>
                    
                    <c:if test="${empty recommendList}">
                        <div style="text-align:center; color:var(--gray4); padding: 40px 0;">추천할 관련 상품이 없습니다.</div>
                    </c:if>
                    
                    <%-- 추천 상품 데이터 --%>
                    <div style="display: grid; grid-template-columns: repeat(4, 1fr); gap: 20px;">
                        <c:forEach var="rec" items="${recommendList}">
                            <div style="cursor: pointer; text-align: center;" onclick="location.href='${pageContext.request.contextPath}/shop/product/productDetail.do?prod_num=${rec.prod_num}'">
                                <div style="width: 100%; aspect-ratio: 1; border: 1px solid var(--border); border-radius: 4px; margin-bottom: 10px; overflow: hidden; background: #fff;">
                                    <img src="${pageContext.request.contextPath}/upload/${rec.prod_img_url}" style="width: 100%; height: 100%; object-fit: cover;">
                                </div>
                                <div style="font-size: 13px; font-weight: 700; margin-bottom: 4px; color: var(--black); white-space: nowrap; overflow: hidden; text-overflow: ellipsis;">${rec.prod_name}</div>
                                <div style="font-size: 13px; color: var(--blue); font-weight: 700;"><fmt:formatNumber value="${rec.prod_price}" pattern="#,###"/>원</div>
                            </div>
                        </c:forEach>
                    </div>
                </div>
            </div>

            <%-- 4. 리뷰 --%>
            <div id="content-review" class="scroll-section" style="min-height: 500px; padding-top: 30px;">
                <div style="max-width: 900px; margin: 0 auto;">
                    <div style="border-bottom: 1px solid var(--black); padding-bottom: 14px; margin-bottom: 20px; display: flex; justify-content: space-between; align-items: flex-end;">
                        <h3 style="font-size: 18px; font-weight: 700;">상품 리뷰</h3>
                        <%-- 구매 이력이 있는 회원에게만 리뷰 작성 버튼 노출 --%>
                        <c:if test="${hasPurchased}">
                            <button class="btn btn-black btn-sm" onclick="location.href='#'">리뷰 작성하기</button>
                        </c:if>
                    </div>
                    <div style="text-align: center; color: var(--gray4); padding: 80px 0; background: var(--gray7); border-radius: 4px; font-size: 14px;">
                        <div style="font-size: 28px; margin-bottom: 8px;">📝</div>
                        아직 등록된 상품 리뷰가 없습니다.
                    </div>
                </div>
            </div>
        </div>
    </div>

<script>
const isLogin = ${isLogin};
const stockData = ${empty optionJson ? '[]' : optionJson};

let selectedColor = "";
let selectedSize = "";

// 스크롤 스파이
function scrollToSection(tabName) {
    const target = document.getElementById('content-' + tabName);
    if(target) {
        const targetY = target.getBoundingClientRect().top + window.pageYOffset - 114;
        window.scrollTo({ top: targetY, behavior: 'smooth' });
    }
}

window.addEventListener('scroll', function() {
    let current = 'info'; 
    const sections = ['info', 'size', 'recommend', 'review'];
    const triggerLine = 130; 

    sections.forEach(sec => {
        const section = document.getElementById('content-' + sec);
        if (section) {
            const rect = section.getBoundingClientRect();
            if (rect.top <= triggerLine) {
                current = sec;
            }
        }
    });

    // 선택된 탭 활성화
    if (current) {
        document.querySelectorAll('.sticky-tab').forEach(tab => { tab.classList.remove('active'); });
        const activeBtn = document.getElementById('tab-btn-' + current);
        if(activeBtn) { activeBtn.classList.add('active'); }
    }
});

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
    checkOptionStock();
}

function selectSize(element, size) {
    document.querySelectorAll('.size-btn').forEach(btn => btn.classList.remove('on'));
    element.classList.add('on');
    selectedSize = size;
    document.getElementById('selectedSizeText').innerText = "(" + size + ")";
    document.getElementById('input_size').value = size;
    checkOptionStock();
}

function checkOptionStock() {
    if(selectedColor === "" || selectedSize === "") return;

    let matchedOption = stockData.find(opt => opt.color === selectedColor && opt.size === selectedSize);
    let currentStock = matchedOption ? matchedOption.stock : 0;

    // 옵션을 누를 때마다 동적 재고 텍스트 갱신
    document.getElementById('dynamicStockDisplay').innerText = "현재 선택 가능한 재고 : " + currentStock + "개";

    // ✅ restock form의 hidden input에 opt_num 세팅
    document.getElementById('restock_opt_num').value = matchedOption ? matchedOption.opt_num : 0;

    let $cartBtn = $('#cartBtn');
    let $buyBtn  = $('#buyBtn');

    if (currentStock > 0) {
        $cartBtn.text('장바구니').prop('disabled', false).css({'cursor':'pointer', 'opacity':'1'}).attr('onclick', "handleAction('cart')");
        $buyBtn.text('바로 구매').prop('disabled', false).css({'cursor':'pointer', 'opacity':'1', 'background-color':'var(--black)'}).attr('onclick', "handleAction('buy')");
    } else {
        $cartBtn.text('품절').prop('disabled', true).css({'cursor':'not-allowed', 'opacity':'0.6'}).removeAttr('onclick');
        $buyBtn.text('재입고 알림 신청').prop('disabled', false).css({'cursor':'pointer', 'opacity':'1', 'background-color':'#d32f2f'}).attr('onclick', "handleAction('restock')");
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

// 찜 버튼 클릭 시 추가, 삭제
function handleWish() {
    if(!requireLogin()) return;
    let prod_num = $('input[name="prod_num"]').first().val();
    
    $.ajax({
        url: '${pageContext.request.contextPath}/shop/wish/writeWish.do',
        type: 'post',
        data: { prod_num: prod_num },
        dataType: 'json',
        success: function(param) {
            if(param.result === 'logout') {
                alert("로그인 후 이용 가능합니다.");
                location.href = '${pageContext.request.contextPath}/shop/user/loginForm.do';
            } else if(param.result === 'added') {
                alert("관심 상품(찜)에 추가되었습니다!");
                $('.btn-wish-lg').addClass('on');
            } else if(param.result === 'deleted') {
                alert("관심 상품(찜)에서 해제되었습니다.");
                $('.btn-wish-lg').removeClass('on');
            }
        },
        error: function(xhr, status, error) {
            alert("통신 중 오류가 발생했습니다.");
        }
    });
}

function handleAction(type) {
    if(!requireLogin()) return;
    
    // ✅ 재입고 알림 신청 - form submit으로 처리
    if(type === 'restock') {
        document.getElementById('restockForm').submit();
        return;
    }

    if(selectedColor === "") { alert("상품의 색상을 선택해 주세요."); return; }
    if(selectedSize === "")  { alert("상품의 사이즈를 선택해 주세요."); return; }

	// 장바구니
    if(type === 'cart') {
        let prod_num = $('input[name="prod_num"]').first().val();
        let color = $('#input_color').val();
        let size  = $('#input_size').val();
        $.ajax({
            url: '${pageContext.request.contextPath}/shop/cart/writeCart.do',
            type: 'post',
            data: { prod_num: prod_num, color: color, size: size, cart_qty: 1 },
            dataType: 'json',
            success: function(param) {
                if(param.result === 'logout') {
                    alert("로그인 후 이용 가능합니다.");
                    location.href = '${pageContext.request.contextPath}/shop/user/loginForm.do';
                } else if(param.result === 'success') {
                    if(confirm(selectedColor + " 색상, " + selectedSize + " 사이즈가 장바구니에 담겼습니다!\n장바구니로 이동하시겠습니까?")) {
                        location.href = '${pageContext.request.contextPath}/shop/cart/cartList.do';
                    }
                }
            },
            error: function() { alert("통신 중 오류가 발생했습니다."); }
        });
    }
	
	// 바로구매
    else if(type === 'buy') {
        let form = document.getElementById('orderPageForm');
        form.action = '${pageContext.request.contextPath}/shop/order/directBuy.do';
        form.submit();
    }
}
</script>
</body>
</html>