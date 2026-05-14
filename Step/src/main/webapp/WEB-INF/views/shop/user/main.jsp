<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>ShoeMall</title>
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700;900&family=Space+Grotesk:wght@600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/KR_style.css">
<style>
    /* 슬라이드 애니메이션 및 구조를 위한 필드 추가 */
    .slider-wrap { overflow: hidden; position: relative; width: 100%; height: 420px; background: #f4f4f4; }
    .slides { display: flex; transition: transform 0.6s cubic-bezier(0.4, 0, 0.2, 1); height: 100%; }
    .slide { 
        flex: 0 0 100%; 
        min-width: 100%; 
        height: 100%; 
        background-size: cover; 
        background-position: center; 
        cursor: pointer; 
        position: relative;
    }
    /* 배너 내 텍스트가 잘 보이도록 하는 스타일 */
    .slide-content { position: absolute; left: 10%; top: 50%; transform: translateY(-50%); color: #fff; text-shadow: 0 2px 10px rgba(0,0,0,0.3); }
</style>
</head>
<body>
    <%-- 공통 헤더 --%>
    <jsp:include page="/WEB-INF/views/common/header.jsp"/>

    <div class="wrap">
        <%-- 비로그인 시 안내 배너 --%>
        <c:if test="${empty sessionScope.user_num}">
            <div style="background:#fff3e0;border-bottom:1px solid #ffe0b2;padding:10px 20px;text-align:center;font-size:13px;color:#e65100;margin-bottom:20px;">
              🔔 로그인하시면 장바구니, 즐겨찾기, 주문 내역 등 다양한 서비스를 이용하실 수 있습니다. &nbsp;
              <a href="${pageContext.request.contextPath}/shop/user/loginForm.do" style="font-weight:700;text-decoration:underline;color:inherit;">지금 로그인하기 →</a>
            </div>
        </c:if>

        <%-- 메인 광고 배너 (DB 연동 및 자동 슬라이드) --%>
        <div class="slider-wrap">
            <div class="slides" id="mainSlider">
                <c:choose>
                    <c:when test="${not empty mainBannerList}">
                        <c:forEach var="bn" items="${mainBannerList}">
                            <div class="slide" onclick="location.href='${pageContext.request.contextPath}/shop/product/productdetail.do?prod_num=${bn.prod_num}'" 
                                 style="background-image: linear-gradient(rgba(0,0,0,0.1), rgba(0,0,0,0.1)), url('${pageContext.request.contextPath}/upload/${bn.banner_img_url}'); cursor:pointer; background-size: cover; background-position: center; flex: 0 0 100%;">
                                <div class="slide-content">
                                    <div class="slide-tag" style="background:#000; color:#fff; display:inline-block; padding:4px 12px; font-size:12px; font-weight:700; margin-bottom:15px;">EVENT</div>
                                    <div class="slide-title" style="font-size:42px; font-weight:900; line-height:1.2;">
                                        ${bn.banner_title}
                                    </div>
                                    <button class="slide-cta" style="margin-top:25px; padding:12px 24px; background:#fff; color:#000; border:none; font-weight:700; cursor:pointer;">지금 보러가기 →</button>
                                </div>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div class="slide" style="background:#222; display:flex; align-items:center; justify-content:center;">
                            <div class="slide-content" style="text-align:center; left:50%; transform:translate(-50%, -50%);">
                                <div class="slide-title">새로운 스타일을 만나보세요</div>
                            </div>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <%-- 왼쪽 사이드바, 오른쪽 상품 그리드 분할 레이아웃 --%>
        <div class="home-layout">
            
            <%-- 좌측 필터 사이드바 --%>
            <div class="filter-side">
                <form id="filterForm" action="${pageContext.request.contextPath}/shop/user/main.do" method="get">
                	<%-- 헤더 탭 기억하기 --%>
                    <input type="hidden" name="cat_num" value="${empty cat_num ? '0' : cat_num}">
                    
                    <%-- 1. 카테고리 필터--%>
                    <div class="filter-box">
                        <div class="filter-title">카테고리 ▾</div>
                        <div class="filter-opts">
                            <label class="filter-opt">
                                <input type="radio" name="cat_num" value="0" ${selected_cat == 0 ? 'checked' : ''} onchange="document.getElementById('filterForm').submit();">
                                전체보기
                            </label>
                            <c:forEach var="cat" items="${categoryList}">
                                <label class="filter-opt">
                                    <input type="radio" name="cat_num" value="${cat.cat_num}" ${selected_cat == cat.cat_num ? 'checked' : ''} onchange="document.getElementById('filterForm').submit();">
                                    ${cat.cat_name}
                                </label>
                            </c:forEach>
                        </div>
                    </div>

                    <%-- 2. 브랜드 필터 --%>
                    <div class="filter-box">
                        <div class="filter-title">브랜드 ▾</div>
                        <div class="filter-opts">
                            <label class="filter-opt">
                                <input type="radio" name="brand_num" value="0" ${selected_brand == 0 ? 'checked' : ''} onchange="document.getElementById('filterForm').submit();">
                                전체 브랜드
                            </label>
                            <c:forEach var="brand" items="${brandList}">
                                <label class="filter-opt">
                                    <input type="radio" name="brand_num" value="${brand.brand_num}" ${selected_brand == brand.brand_num ? 'checked' : ''} onchange="document.getElementById('filterForm').submit();">
                                    ${brand.brand_name}
                                </label>
                            </c:forEach>
                        </div>
                    </div>
                </form>
            </div>

            <%-- 우측 상품 리스트 영역 --%>
            <div class="prod-wrap" id="prod-list-area" style="flex:1; margin:0; padding:0; max-width: none;">
                <div class="sort-header">
                    <div class="sort-tabs">
                        <a href="#" data-sort="recommend" class="sort-tab ${param.sort == 'recommend' || empty param.sort ? 'active' : ''}">추천순</a>
                        <a href="#" data-sort="popular" class="sort-tab ${param.sort == 'popular' ? 'active' : ''}">인기순</a>
                        <a href="#" data-sort="new" class="sort-tab ${param.sort == 'new' ? 'active' : ''}">최신순</a>
                    </div>
                </div>
                
                <div class="prod-grid">
                    <c:forEach var="product" items="${productList}">
                        <div class="prod-item" onclick="location.href='${pageContext.request.contextPath}/shop/product/productdetail.do?prod_num=${product.prod_num}'">
                            <div class="prod-img">
                                <img src="${pageContext.request.contextPath}/upload/${product.prod_img_url}" alt="${product.prod_name}">
                            </div>
                            <div class="prod-info">
                                <div class="prod-brand">${product.brand_name}</div>
                                <div class="prod-name">${product.prod_name}</div>
                                <div class="prod-price">
                                    <fmt:formatNumber value="${product.prod_price}" pattern="#,###"/>원
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                    
                    <c:if test="${empty productList}">
                        <div style="grid-column: 1 / -1; text-align: center; padding: 100px 0; color: #999; background: var(--gray7); border: 1px solid var(--border);">
                            선택하신 조건에 맞는 상품이 없습니다. 🥲
                        </div>
                    </c:if>
                </div>

                <%-- 하단 페이징 영역 --%>
                <div class="pagination">
                    <c:if test="${count > 0}">
                        <c:if test="${startPage > 1}">
                            <a href="#" data-page="${startPage - 1}" class="page-btn">◀</a>
                        </c:if>
                        <c:forEach var="i" begin="${startPage}" end="${endPage}">
                            <a href="#" data-page="${i}" class="page-btn ${currentPage == i ? 'active' : ''}">${i}</a>
                        </c:forEach>
                        <c:if test="${endPage < totalPage}">
                            <a href="#" data-page="${endPage + 1}" class="page-btn">▶</a>
                        </c:if>
                    </c:if>
                </div>
            </div>
        </div>
    </div>
    
<script>
$(document).ready(function() {
    // [추가] 배너 자동 슬라이드 로직
    let currentSlide = 0;
    const slideCount = $('.slide').length;
    
    if(slideCount > 1) {
        setInterval(function() {
            currentSlide = (currentSlide + 1) % slideCount;
            $('#mainSlider').css('transform', 'translateX(-' + (currentSlide * 100) + '%)');
        }, 4500); // 4.5초마다 전환
    }

    // [기존 유지] 정렬 탭 클릭
    $('.sort-tab').click(function(e) {
        e.preventDefault();
        $('.sort-tab').removeClass('active');
        $(this).addClass('active');

        let sortType = $(this).data('sort');
        let formData = $('#filterForm').serialize();
        let targetUrl = '${pageContext.request.contextPath}/shop/user/main.do?' + formData + '&sort=' + sortType;

        $('.prod-grid').css('opacity', '0.4');
        $('.prod-grid').load(targetUrl + ' .prod-grid > *', function() {
            $('.prod-grid').css('opacity', '1');
        });
    });
    
    // [기존 유지] 페이징 클릭
    $(document).on('click', '.page-btn', function(e) {
        e.preventDefault();
        let pageNum = $(this).data('page');
        let sortType = $('.sort-tab.active').data('sort') || 'recommend';
        
        let formData = $('#filterForm').serialize();
        let targetUrl = '${pageContext.request.contextPath}/shop/user/main.do?' + formData + '&sort=' + sortType + '&pageNum=' + pageNum;

        $('#prod-list-area').css('opacity', '0.4');
        $('#prod-list-area').load(targetUrl + ' #prod-list-area > *', function() {
            $('#prod-list-area').css('opacity', '1');
        });
    });
});
</script>
</body>
</html>