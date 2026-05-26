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
<style>
/* ── 장바구니 전용 스타일 ── */
body { background: #f4f5f7; }

.cart-page-wrap {
    max-width: 1200px;
    margin: 0 auto;
    padding: 36px 24px 80px;
}
.cart-page-title {
    font-size: 22px; font-weight: 900;
    letter-spacing: -0.5px;
    margin-bottom: 28px; color: #0d0d0d;
}

/* ── 레이아웃 ── */
.cart-cols {
    display: grid;
    grid-template-columns: 1fr 340px;
    gap: 24px;
    align-items: start;
}

/* ── 왼쪽: 상품 목록 ── */
.cart-card {
    background: #fff;
    border: 1px solid #e8e8e8;
    border-radius: 12px;
    overflow: hidden;
}

/* 상단 전체선택/선택삭제 바 */
.cart-ctrl-bar {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 14px 20px;
    border-bottom: 1px solid #f0f0f0;
    background: #fafafa;
}
.cart-ctrl-bar label {
    display: flex; align-items: center; gap: 8px;
    font-size: 13px; font-weight: 700; color: #0d0d0d;
    cursor: pointer;
}
.cart-ctrl-bar input[type="checkbox"] {
    width: 16px; height: 16px;
    accent-color: #0d0d0d; cursor: pointer;
}
.btn-del-selected {
    background: none; border: none;
    font-size: 12px; color: #999;
    cursor: pointer; padding: 4px 8px;
    border-radius: 4px; transition: color .15s, background .15s;
    font-family: inherit;
}
.btn-del-selected:hover { color: #e52; background: #fff0f0; }

/* 빈 장바구니 */
.cart-empty {
    padding: 80px 0; text-align: center;
    color: #bbb; font-size: 14px;
}
.cart-empty-icon { font-size: 48px; margin-bottom: 16px; }

/* ── 개별 아이템 ── */
.cart-row {
    display: flex; align-items: center;
    gap: 16px; padding: 20px;
    border-bottom: 1px solid #f5f5f5;
    transition: background .12s;
}
.cart-row:last-child { border-bottom: none; }
.cart-row:hover { background: #fafafa; }

.cart-row-check input[type="checkbox"] {
    width: 16px; height: 16px;
    accent-color: #0d0d0d; cursor: pointer;
    flex-shrink: 0;
}

/* 이미지 */
.cart-row-img {
    width: 90px; height: 90px; flex-shrink: 0;
    border-radius: 8px;
    border: 1px solid #eee;
    background: #f8f8f8;
    overflow: hidden;
    cursor: pointer;
}
.cart-row-img img {
    width: 100%; height: 100%; object-fit: cover;
    display: block;
}

/* 텍스트 정보 */
.cart-row-info { flex: 1; min-width: 0; }
.cart-row-brand {
    font-size: 11px; font-weight: 700;
    color: #999; text-transform: uppercase;
    letter-spacing: .06em; margin-bottom: 4px;
}
.cart-row-name {
    font-size: 14px; font-weight: 600; color: #0d0d0d;
    margin-bottom: 6px; line-height: 1.4;
    overflow: hidden; text-overflow: ellipsis; white-space: nowrap;
}
.cart-row-opt {
    font-size: 12px; color: #aaa; margin-bottom: 12px;
}

/* 수량 조절 */
.cart-qty-ctrl {
    display: inline-flex; align-items: center;
    border: 1.5px solid #e0e0e0; border-radius: 6px;
    overflow: hidden;
}
.cart-qty-btn {
    width: 32px; height: 32px;
    background: none; border: none; cursor: pointer;
    font-size: 16px; font-weight: 700; color: #555;
    display: flex; align-items: center; justify-content: center;
    transition: background .12s;
}
.cart-qty-btn:hover { background: #f5f5f5; }
.cart-qty-num {
    width: 36px; height: 32px;
    border-left: 1.5px solid #e0e0e0;
    border-right: 1.5px solid #e0e0e0;
    display: flex; align-items: center; justify-content: center;
    font-size: 13px; font-weight: 700; color: #0d0d0d;
}

/* 가격/삭제 */
.cart-row-price-col {
    display: flex; flex-direction: column;
    align-items: flex-end; gap: 6px;
    flex-shrink: 0; min-width: 100px;
}
.cart-row-price {
    font-size: 16px; font-weight: 900;
    color: #0d0d0d; letter-spacing: -0.5px;
}
.cart-row-del {
    font-size: 12px; color: #bbb;
    cursor: pointer; transition: color .15s;
    padding: 2px 4px;
    border-radius: 3px;
}
.cart-row-del:hover { color: #e52; background: #fff0f0; }
.cart-row-date {
    font-size: 11px; color: #ccc; margin-top: 4px;
}

/* ── 오른쪽: 주문 요약 ── */
.order-summary-card {
    background: #fff;
    border: 1px solid #e8e8e8;
    border-radius: 12px;
    overflow: hidden;
    position: sticky;
    top: 84px;
}
.summary-hdr {
    padding: 18px 20px 14px;
    border-bottom: 1px solid #f0f0f0;
    font-size: 15px; font-weight: 800;
    color: #0d0d0d; letter-spacing: -0.3px;
}
.summary-body { padding: 20px; }
.summary-row {
    display: flex; justify-content: space-between;
    align-items: center;
    font-size: 13px; color: #666;
    padding: 8px 0;
}
.summary-row:first-child { padding-top: 0; }
.summary-row span:last-child { font-weight: 500; color: #0d0d0d; }
.summary-discount span:last-child { color: #e52 !important; font-weight: 600; }
.summary-divider {
    height: 1px; background: #f0f0f0; margin: 12px 0;
}
.summary-total {
    display: flex; justify-content: space-between;
    align-items: baseline;
    padding: 4px 0 0;
}
.summary-total-label {
    font-size: 14px; font-weight: 700; color: #0d0d0d;
}
.summary-total-price {
    font-size: 22px; font-weight: 900;
    color: #1a6ef5; letter-spacing: -0.5px;
}
.summary-free-ship {
    margin-top: 8px; padding: 8px 12px;
    background: #f0f6ff; border-radius: 6px;
    font-size: 12px; color: #1a6ef5; font-weight: 500;
    text-align: center;
}
.btn-buy {
    display: block; width: 100%; margin-top: 16px;
    height: 52px; background: #0d0d0d; color: #fff;
    border: none; border-radius: 8px;
    font-size: 15px; font-weight: 700;
    cursor: pointer; font-family: inherit;
    transition: background .15s;
    letter-spacing: .02em;
}
.btn-buy:hover { background: #333; }
.summary-info {
    margin-top: 14px; font-size: 11px;
    color: #bbb; text-align: center; line-height: 1.7;
}
</style>
</head>
<body>
    <jsp:include page="/WEB-INF/views/common/header.jsp"/>

    <div class="cart-page-wrap">
        <div class="cart-page-title">장바구니</div>

        <div class="cart-cols">

            <%-- ── 왼쪽: 상품 목록 ── --%>
            <div class="cart-card">
                <div class="cart-ctrl-bar">
                    <label>
                        <input type="checkbox" id="checkAll" checked> 전체 선택
                        <span id="checkedCount" style="font-weight:400;color:#999;margin-left:2px"></span>
                    </label>
                    <button class="btn-del-selected">선택 삭제</button>
                </div>

                <c:if test="${empty cartList}">
                    <div class="cart-empty">
                        <div class="cart-empty-icon">🛒</div>
                        장바구니에 담긴 상품이 없습니다.
                    </div>
                </c:if>

                <c:forEach var="cart" items="${cartList}">
                    <div class="cart-row">
                        <div class="cart-row-check">
                            <input type="checkbox" name="cart_check" class="cart-checkbox"
                                   value="${cart.cart_num}"
                                   data-price="${cart.prod_price * cart.cart_qty}" checked>
                        </div>

                        <div class="cart-row-img">
                            <img src="${pageContext.request.contextPath}/upload/${cart.prod_img_url}" alt="${cart.prod_name}">
                        </div>

                        <div class="cart-row-info">
                            <div class="cart-row-brand">${cart.brand_name}</div>
                            <div class="cart-row-name">${cart.prod_name}</div>
                            <div class="cart-row-opt">옵션: ${cart.color} / ${cart.size_val}</div>
                            <div class="cart-qty-ctrl">
                                <button class="cart-qty-btn" onclick="updateQty(${cart.cart_num}, -1, ${cart.prod_price}, this)">−</button>
                                <div class="cart-qty-num">${cart.cart_qty}</div>
                                <button class="cart-qty-btn" onclick="updateQty(${cart.cart_num}, 1, ${cart.prod_price}, this)">+</button>
                            </div>
                        </div>

                        <div class="cart-row-price-col">
                            <div class="cart-row-price"><fmt:formatNumber value="${cart.prod_price * cart.cart_qty}" pattern="#,###"/>원</div>
                            <div class="cart-row-del" onclick="deleteCartItem(${cart.cart_num})">삭제</div>
                            <div class="cart-row-date"><fmt:formatDate value="${cart.cart_created_at}" pattern="yyyy.MM.dd"/> 담음</div>
                        </div>
                    </div>
                </c:forEach>
            </div>

            <%-- ── 오른쪽: 주문 요약 ── --%>
            <div class="order-summary-card">
                <div class="summary-hdr">주문 요약</div>
                <div class="summary-body">
                    <div class="summary-row">
                        <span>총 상품 금액</span>
                        <span id="totalProductPrice">0원</span>
                    </div>
                    <div class="summary-row">
                        <span>배송비</span>
                        <span>무료</span>
                    </div>
                    <div class="summary-row summary-discount">
                        <span>할인 금액</span>
                        <span>-0원</span>
                    </div>
                    <div class="summary-divider"></div>
                    <div class="summary-total">
                        <span class="summary-total-label">총 결제 예상 금액</span>
                        <span class="summary-total-price" id="finalTotalPrice">0원</span>
                    </div>
                    <div class="summary-free-ship">🚚 전 상품 무료배송</div>
                    <button class="btn-buy" onclick="goOrder()">구매하기</button>
                    <div class="summary-info">
                        주문 완료 후 마이페이지에서<br>배송 현황을 확인하실 수 있습니다.
                    </div>
                </div>
            </div>

        </div>
    </div>

<script>
function calcTotal() {
    let total = 0;
    let count = 0;
    $('.cart-checkbox:checked').each(function() {
        total += parseInt($(this).data('price'));
        count++;
    });
    let fmt = total.toLocaleString('ko-KR') + '원';
    $('#totalProductPrice').text(fmt);
    $('#finalTotalPrice').text(fmt);
    $('#checkedCount').text(count > 0 ? '(' + count + '개)' : '');
}

$(document).ready(function() {
    calcTotal();
    $('#checkAll').click(function() {
        $('.cart-checkbox').prop('checked', this.checked);
        calcTotal();
    });
    $('.cart-checkbox').click(function() {
        $('#checkAll').prop('checked', $('.cart-checkbox:checked').length === $('.cart-checkbox').length);
        calcTotal();
    });
});

function deleteCartItem(cart_num) {
    if (!confirm("이 상품을 장바구니에서 삭제하시겠습니까?")) return;
    $.ajax({
        url: '${pageContext.request.contextPath}/shop/cart/deleteCart.do',
        type: 'post', data: { cart_num: cart_num }, dataType: 'json',
        success: function(param) {
            if (param.result === 'logout') {
                alert("로그인이 필요합니다.");
                location.href = '${pageContext.request.contextPath}/shop/user/loginForm.do';
            } else if (param.result === 'success') {
                alert("삭제되었습니다."); location.reload();
            }
        },
        error: function() { alert("통신 오류가 발생했습니다."); }
    });
}

function goOrder() {
    let checkedCarts = $('.cart-checkbox:checked');
    if (checkedCarts.length === 0) { alert("주문할 상품을 선택해 주세요."); return; }
    let form = $('<form></form>');
    form.attr('action', '${pageContext.request.contextPath}/shop/order/orderPageForm.do');
    form.attr('method', 'post');
    checkedCarts.each(function() {
        form.append($('<input/>', {type: 'hidden', name: 'cart_num', value: $(this).val()}));
    });
    form.appendTo('body').submit();
}

function updateQty(cart_num, change, unit_price, btnElem) {
    let qtyElem = $(btnElem).siblings('.cart-qty-num');
    let newQty = parseInt(qtyElem.text()) + change;
    if (newQty < 1) { alert("수량은 최소 1개 이상이어야 합니다."); return; }
    $.ajax({
        url: '${pageContext.request.contextPath}/shop/cart/updateCartQty.do',
        type: 'post', data: { cart_num: cart_num, cart_qty: newQty }, dataType: 'json',
        success: function(param) {
            if (param.result === 'logout') {
                alert("로그인이 필요합니다.");
                location.href = '${pageContext.request.contextPath}/shop/user/loginForm.do';
            } else if (param.result === 'success') {
                qtyElem.text(newQty);
                let newPrice = unit_price * newQty;
                let cartRow = $(btnElem).closest('.cart-row');
                cartRow.find('.cart-row-price').text(newPrice.toLocaleString('ko-KR') + '원');
                cartRow.find('.cart-checkbox').data('price', newPrice);
                calcTotal();
            }
        },
        error: function() { alert("통신 오류가 발생했습니다."); }
    });
}

$('.btn-del-selected').click(function() {
    let checkedCarts = $('.cart-checkbox:checked');
    if (checkedCarts.length === 0) { alert("삭제할 상품을 선택해 주세요."); return; }
    if (!confirm("선택한 상품을 장바구니에서 삭제하시겠습니까?")) return;
    let cartNums = [];
    checkedCarts.each(function() { cartNums.push($(this).val()); });
    $.ajax({
        url: '${pageContext.request.contextPath}/shop/cart/deleteSelectedCart.do',
        type: 'post', data: { 'cart_nums': cartNums }, dataType: 'json', traditional: true,
        success: function(param) {
            if (param.result === 'logout') {
                alert("로그인이 필요합니다.");
                location.href = '${pageContext.request.contextPath}/shop/user/loginForm.do';
            } else if (param.result === 'success') { location.reload(); }
        },
        error: function() { alert("통신 오류가 발생했습니다."); }
    });
});
</script>
</body>
</html>
