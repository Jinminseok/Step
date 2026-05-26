<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>ShoeMall - 찜한 상품</title>
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700;900&family=Space+Grotesk:wght@600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/KR_style.css">
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<style>
body { background: #f2f3f5; }

.wish-page {
    max-width: 1380px;
    margin: 0 auto;
    padding: 36px 32px 80px;
}

/* ── 페이지 헤더 ── */
.wish-page-hdr {
    display: flex;
    align-items: baseline;
    gap: 10px;
    margin-bottom: 28px;
    padding-bottom: 20px;
    border-bottom: 1px solid #e8e8e8;
}
.wish-page-title {
    font-size: 22px;
    font-weight: 900;
    letter-spacing: -0.5px;
    color: #0d0d0d;
}

/* ── 빈 상태 ── */
.wish-empty {
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    padding: 100px 0;
    gap: 16px;
    background: #fff;
    border-radius: 14px;
    border: 1px solid #e8e8e8;
}
.wish-empty-icon { font-size: 52px; }
.wish-empty-txt {
    font-size: 15px;
    color: #bbb;
    font-weight: 500;
}
.wish-empty-sub {
    font-size: 13px;
    color: #ccc;
}
.wish-empty-btn {
    margin-top: 8px;
    padding: 12px 28px;
    background: #0d0d0d;
    color: #fff;
    border: none;
    border-radius: 6px;
    font-size: 13px;
    font-weight: 700;
    cursor: pointer;
    font-family: inherit;
    transition: background .15s;
}
.wish-empty-btn:hover { background: #333; }

/* ── 상품 그리드 ── */
.wish-grid {
    display: grid;
    grid-template-columns: repeat(5, 1fr);
    gap: 20px;
}

/* ── 상품 카드 ── */
.wish-card {
    background: #fff;
    border: 1px solid #e8e8e8;
    border-radius: 12px;
    overflow: hidden;
    cursor: pointer;
    transition: transform .22s, box-shadow .22s;
    position: relative;
}
.wish-card:hover {
    transform: translateY(-4px);
    box-shadow: 0 8px 28px rgba(0,0,0,.1);
    border-color: #d0d0d0;
}

/* 이미지 */
.wish-card-img {
    position: relative;
    aspect-ratio: 1/1;
    background: #f8f8f8;
    overflow: hidden;
}
.wish-card-img img {
    width: 100%; height: 100%;
    object-fit: cover; display: block;
    transition: transform .45s ease;
}
.wish-card:hover .wish-card-img img { transform: scale(1.07); }

/* 찜 해제 버튼 */
.wish-remove-btn {
    position: absolute;
    top: 10px; right: 10px;
    width: 34px; height: 34px;
    border-radius: 50%;
    background: rgba(255,255,255,.92);
    border: none; cursor: pointer;
    display: flex; align-items: center; justify-content: center;
    font-size: 16px;
    box-shadow: 0 2px 8px rgba(0,0,0,.12);
    transition: transform .15s, background .15s;
    z-index: 2;
}
.wish-remove-btn:hover {
    transform: scale(1.15);
    background: #fff0f0;
}

/* 상품 정보 */
.wish-card-info { padding: 14px 14px 16px; }
.wish-card-brand {
    font-size: 11px; font-weight: 700;
    color: #aaa; text-transform: uppercase;
    letter-spacing: .06em; margin-bottom: 4px;
}
.wish-card-name {
    font-size: 13px; font-weight: 500;
    color: #0d0d0d; margin-bottom: 8px;
    line-height: 1.4;
    overflow: hidden; text-overflow: ellipsis; white-space: nowrap;
}
.wish-card-price {
    font-size: 15px; font-weight: 900;
    color: #0d0d0d; letter-spacing: -0.3px;
}

/* 반응형 */
@media(max-width:1200px){ .wish-grid{ grid-template-columns:repeat(4,1fr); } }
@media(max-width:900px) { .wish-grid{ grid-template-columns:repeat(3,1fr); } }
@media(max-width:600px) { .wish-grid{ grid-template-columns:repeat(2,1fr); } }
</style>
</head>
<body>
    <jsp:include page="/WEB-INF/views/common/header.jsp"/>

    <div class="wish-page">

        <%-- ── 페이지 헤더 ── --%>
        <div class="wish-page-hdr">
            <div class="wish-page-title">찜한 상품</div>
        </div>

        <%-- ── 빈 상태 ── --%>
        <c:if test="${empty wishList}">
            <div class="wish-empty">
                <div class="wish-empty-icon">🤍</div>
                <div class="wish-empty-txt">아직 찜한 상품이 없습니다</div>
                <div class="wish-empty-sub">마음에 드는 상품에 하트를 눌러보세요!</div>
                <button class="wish-empty-btn"
                        onclick="location.href='${pageContext.request.contextPath}/shop/user/main.do'">
                    쇼핑 계속하기 →
                </button>
            </div>
        </c:if>

        <%-- ── 상품 그리드 ── --%>
        <c:if test="${not empty wishList}">
            <div class="wish-grid">
                <c:forEach var="wish" items="${wishList}">
                    <div class="wish-card"
                         onclick="location.href='${pageContext.request.contextPath}/shop/product/productdetail.do?prod_num=${wish.prod_num}'">

                        <div class="wish-card-img">
                            <img src="${pageContext.request.contextPath}/upload/${wish.prod_img_url}"
                                 alt="${wish.prod_name}">
                            <button class="wish-remove-btn"
                                    onclick="event.stopPropagation(); removeWish(${wish.prod_num});"
                                    title="찜 해제">❤️</button>
                        </div>

                        <div class="wish-card-info">
                            <div class="wish-card-brand">${wish.brand_name}</div>
                            <div class="wish-card-name">${wish.prod_name}</div>
                            <div class="wish-card-price">
                                <fmt:formatNumber value="${wish.prod_price}" pattern="#,###"/>원
                            </div>
                        </div>

                    </div>
                </c:forEach>
            </div>
        </c:if>

    </div>

<script>
function removeWish(prod_num) {
    if (!confirm("이 상품을 찜 목록에서 삭제하시겠습니까?")) return;
    $.ajax({
        url: '${pageContext.request.contextPath}/shop/wish/deleteWish.do',
        type: 'post',
        data: { prod_num: prod_num },
        dataType: 'json',
        success: function(param) {
            if (param.result === 'logout') {
                alert("로그인이 필요합니다.");
            } else if (param.result === 'success') {
                alert("찜 목록에서 삭제되었습니다.");
                location.reload();
            }
        },
        error: function() { alert("통신 오류가 발생했습니다."); }
    });
}
</script>
</body>
</html>
