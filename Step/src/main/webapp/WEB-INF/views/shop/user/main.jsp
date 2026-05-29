<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<title>ShoeMall</title>
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700;900&family=Space+Grotesk:wght@600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/KR_style.css">

<style>
/* ===== 배너 슬라이더 ===== */
.slider-wrap {
    overflow: hidden;
    position: relative;
    width: 100%;
    height: 360px;
    background: #111;
    border-radius: 8px;
    margin-bottom: 32px;
    user-select: none;
}

.slides {
    display: flex;
    height: 100%;
    transition: transform 0.6s cubic-bezier(0.4, 0, 0.2, 1);
    will-change: transform;
}

.slide {
    flex: 0 0 100%;
    min-width: 100%;
    height: 100%;
    position: relative;
    cursor: pointer;
    overflow: hidden;
}

/* 배너 이미지 - 슬라이드 꽉 채우기 핵심 */
.slide-bg {
    position: absolute;
    inset: 0;
    width: 100%;
    height: 100%;
    object-fit: contain;      
    object-position: center; /* 중앙 기준 */
    display: block;
    background:#111;
    transition: transform 0.4s ease;
}
.slide:hover .slide-bg { transform: scale(1.02); }

/* 배너 텍스트 오버레이 */
.slide-overlay {
    position: absolute;
    inset: 0;
    background: linear-gradient(to right, rgba(0,0,0,0.55) 0%, rgba(0,0,0,0.1) 60%, transparent 100%);
    pointer-events: none;
}
.slide-content {
    position: absolute;
    left: 10%;
    top: 50%;
    transform: translateY(-50%);
    color: #fff;
    z-index: 2;
}
.slide-tag {
    background: #fff;
    color: #000;
    display: inline-block;
    padding: 4px 14px;
    font-size: 11px;
    font-weight: 900;
    margin-bottom: 14px;
    letter-spacing: .1em;
    text-transform: uppercase;
}
.slide-title {
    font-size: 38px;
    font-weight: 900;
    line-height: 1.2;
    text-shadow: 0 2px 12px rgba(0,0,0,0.3);
    margin-bottom: 20px;
    max-width: 480px;
}
.slide-cta {
    padding: 12px 28px;
    background: #fff;
    color: #000;
    border: none;
    font-weight: 700;
    cursor: pointer;
    font-size: 14px;
    font-family: 'Noto Sans KR', sans-serif;
    transition: background .2s, color .2s;
}
.slide-cta:hover { background: #111; color: #fff; }

/* 좌우 화살표 버튼 */
.slider-btn {
    position: absolute;
    top: 50%;
    transform: translateY(-50%);
    z-index: 10;
    width: 44px;
    height: 44px;
    border-radius: 50%;
    background: rgba(255,255,255,0.85);
    border: none;
    cursor: pointer;
    font-size: 18px;
    display: flex;
    align-items: center;
    justify-content: center;
    transition: background .2s, opacity .2s;
    opacity: 0;
    box-shadow: 0 2px 12px rgba(0,0,0,0.15);
}
.slider-wrap:hover .slider-btn { opacity: 1; }
.slider-btn:hover { background: #fff; }
.slider-btn.prev { left: 16px; }
.slider-btn.next { right: 16px; }

/* 하단 인디케이터 */
.slider-dots {
    position: absolute;
    bottom: 16px;
    left: 50%;
    transform: translateX(-50%);
    display: flex;
    gap: 7px;
    z-index: 10;
}
.slider-dot {
    width: 8px;
    height: 8px;
    border-radius: 50%;
    background: rgba(255,255,255,0.5);
    cursor: pointer;
    transition: background .25s, transform .25s;
    border: none;
    padding: 0;
}
.slider-dot.active {
    background: #fff;
    transform: scale(1.3);
}

/* 배너 수 표시 */
.slider-counter {
    position: absolute;
    top: 14px;
    right: 16px;
    background: rgba(0,0,0,0.4);
    color: #fff;
    font-size: 11px;
    font-weight: 700;
    padding: 3px 10px;
    border-radius: 20px;
    z-index: 10;
    letter-spacing: .05em;
}

/* 배너 없을 때 */
.slide-empty {
    width: 100%;
    height: 100%;
    display: flex;
    align-items: center;
    justify-content: center;
    background: #222;
    color: rgba(255,255,255,0.4);
    font-size: 18px;
    font-weight: 700;
}
</style>
</head>
<body>
    <jsp:include page="/WEB-INF/views/common/header.jsp"/>

    <div class="wrap">

        <%-- 비로그인 안내 배너 --%>
        <c:if test="${empty sessionScope.user_num}">
            <div style="background:#fff3e0;border-bottom:1px solid #ffe0b2;padding:10px 20px;text-align:center;font-size:13px;color:#e65100;margin-bottom:20px;">
              🔔 로그인하시면 장바구니, 즐겨찾기, 주문 내역 등 다양한 서비스를 이용하실 수 있습니다. &nbsp;
              <a href="${pageContext.request.contextPath}/shop/user/loginForm.do"
                 style="font-weight:700;text-decoration:underline;color:inherit;">지금 로그인하기</a>
            </div>
        </c:if>

        <%-- 메인 배너 슬라이더 --%>
        <div class="slider-wrap" id="sliderWrap">

            <c:choose>
                <c:when test="${not empty mainBannerList}">

                    <%-- 슬라이드 목록 --%>
                    <div class="slides" id="mainSlider">
                        <c:forEach var="bn" items="${mainBannerList}">
                            <div class="slide"
                                 onclick="location.href='${pageContext.request.contextPath}/shop/product/productdetail.do?prod_num=${bn.prod_num}'">
                                <img class="slide-bg"
                                     src="${pageContext.request.contextPath}/upload/${bn.banner_img_url}"
                                     alt="${bn.banner_title}"
                                     onerror="this.style.background='#333';this.src=''">
                                <div class="slide-overlay"></div>
                                <div class="slide-content">
                                    <div class="slide-tag">EVENT</div>
                                    <div class="slide-title">${bn.banner_title}</div>
                                    <button class="slide-cta" onclick="event.stopPropagation();location.href='${pageContext.request.contextPath}/shop/product/productdetail.do?prod_num=${bn.prod_num}'">
                                        지금 보러가기 →
                                    </button>
                                </div>
                            </div>
                        </c:forEach>
                    </div>

                    <%-- 좌우 화살표 (배너 2개 이상일 때만 의미 있음) --%>
                    <button class="slider-btn prev" id="slidePrev">&#8592;</button>
                    <button class="slider-btn next" id="slideNext">&#8594;</button>

                    <%-- 인디케이터 dots --%>
                    <div class="slider-dots" id="sliderDots"></div>

	                    <%-- 슬라이드 카운터 --%>
	                   <div class="slider-counter" id="sliderCounter"></div>
                </c:when>
                <c:otherwise>
                    <div class="slide-empty">등록된 배너가 없습니다</div>
                </c:otherwise>
            </c:choose>

        </div>

        <%-- 좌측 필터 + 우측 상품 --%>
        <div class="home-layout">

            <%-- 좌측 필터 사이드바 (기존 form 제거 및 onclick 방식 적용) --%>
			<div class="filter-side">
			    <form id="filterForm" action="${pageContext.request.contextPath}/shop/user/main.do" method="get">
			    <input type="hidden" name="keyword" value="${param.keyword}">
			    <input type="hidden" name="sort" id="sortInput" value="${empty param.sort ? 'recommend' : param.sort}">
			        
			        <div class="filter-box">
			            <div class="filter-title">카테고리 ▾</div>
			            <div class="filter-opts">
			                <label class="filter-opt"><input type="radio" name="cat_num" value="0" ${selected_cat == 0 ? 'checked' : ''}> 전체보기</label>
			                <c:forEach var="cat" items="${categoryList}">
			                    <label class="filter-opt">
			                        <input type="radio" name="cat_num" value="${cat.catNum}" ${selected_cat == cat.catNum ? 'checked' : ''}>
			                        ${cat.catName}
			                    </label>
			                </c:forEach>
			            </div>
			        </div>
			
			        <div class="filter-box">
			            <div class="filter-title">브랜드 ▾</div>
			            <div class="filter-opts">
			                <label class="filter-opt"><input type="radio" name="brand_num" value="0" ${selected_brand == 0 ? 'checked' : ''}> 전체 브랜드</label>
			                <c:forEach var="brand" items="${brandList}">
			                    <label class="filter-opt">
			                        <input type="radio" name="brand_num" value="${brand.brandNum}" ${selected_brand == brand.brandNum ? 'checked' : ''}>
			                        ${brand.brandName}
			                    </label>
			                </c:forEach>
			            </div>
			        </div>
			
			        <div class="filter-box">
			            <div class="filter-title">성별 ▾</div>
			            <div class="filter-opts">
			                <label class="filter-opt"><input type="radio" name="gender" value="-1" ${selected_gender == -1 ? 'checked' : ''}> 전체</label>
			                <label class="filter-opt"><input type="radio" name="gender" value="1" ${selected_gender == 1 ? 'checked' : ''}> 남성</label>
			                <label class="filter-opt"><input type="radio" name="gender" value="2" ${selected_gender == 2 ? 'checked' : ''}> 여성</label>
			            </div>
			        </div>
			
			        <button type="submit" class="btn btn-black" style="width:100%; margin-top:20px; padding:12px;">검색하기</button>
			    </form>
			</div>

            <%-- 우측 상품 리스트 --%>
            <div class="prod-wrap" id="prod-list-area" style="flex:1;margin:0;padding:0;max-width:none;">
            	<!-- 검색창 -->
            	<c:if test="${not empty param.keyword}">
                    <div style="font-size: 18px; font-weight: 700; margin-bottom: 20px; color: var(--black);">
                        '<span style="color: var(--blue);">${param.keyword}</span>' 검색 결과 (총 ${count}건)
                    </div>
                </c:if>
                <div class="sort-header">
                    <div class="sort-tabs">
                        <a href="#" data-sort="recommend" class="sort-tab ${param.sort == 'recommend' || empty param.sort ? 'active' : ''}">추천순</a>
                        <a href="#" data-sort="popular"   class="sort-tab ${param.sort == 'popular'   ? 'active' : ''}">인기순</a>
                        <a href="#" data-sort="new"       class="sort-tab ${param.sort == 'new'       ? 'active' : ''}">최신순</a>
                    </div>
                </div>

                <div class="prod-grid">
                    <c:forEach var="product" items="${productList}">
                        <div class="prod-item"
                             onclick="location.href='${pageContext.request.contextPath}/shop/product/productdetail.do?prod_num=${product.prod_num}'">
                            <div class="prod-img">
                                <img src="${pageContext.request.contextPath}/upload/${product.prod_img_url}"
                                     alt="${product.prod_name}">
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
                        <div style="grid-column:1/-1;text-align:center;padding:100px 0;color:#999;background:var(--gray7);border:1px solid var(--border);">
                            선택하신 조건에 맞는 상품이 없습니다. 🥲
                        </div>
                    </c:if>
                </div>

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
$(document).ready(function () {

    /* ===== 배너 슬라이더 ===== */
    var slides     = $('.slide');
    var slideCount = slides.length;
    var current    = 0;
    var autoTimer  = null;
    var AUTO_MS    = 4500; // 자동 전환 간격 (ms)

    if (slideCount > 0) {

        // 인디케이터 dots 생성
        var dotsWrap = $('#sliderDots');
        for (var i = 0; i < slideCount; i++) {
            dotsWrap.append('<button class="slider-dot' + (i === 0 ? ' active' : '') + '" data-idx="' + i + '"></button>');
        }

        // 카운터 초기화
        $('#sliderCounter').text('1 / ' + slideCount);

        // 슬라이드 이동
        function goTo(idx) {
            if (idx < 0) idx = slideCount - 1;
            if (idx >= slideCount) idx = 0;
            current = idx;
            $('#mainSlider').css('transform', 'translateX(-' + (current * 100) + '%)');
            $('.slider-dot').removeClass('active').eq(current).addClass('active');
            $('#sliderCounter').text((current + 1) + ' / ' + slideCount);
        }

        // 자동 슬라이드
        function startAuto() {
            stopAuto();
            if (slideCount > 1) {
                autoTimer = setInterval(function () { goTo(current + 1); }, AUTO_MS);
            }
        }
        function stopAuto() {
            if (autoTimer) { clearInterval(autoTimer); autoTimer = null; }
        }

        // 버튼 클릭
        $('#slideNext').click(function () { goTo(current + 1); startAuto(); });
        $('#slidePrev').click(function () { goTo(current - 1); startAuto(); });

        // 인디케이터 클릭
        $(document).on('click', '.slider-dot', function () {
            goTo(parseInt($(this).data('idx')));
            startAuto();
        });

        // 마우스 올리면 일시정지
        $('#sliderWrap').on('mouseenter', stopAuto).on('mouseleave', startAuto);

        // 배너 1개면 화살표/dots 숨김
        if (slideCount === 1) {
            $('#slidePrev, #slideNext, #sliderDots, #sliderCounter').hide();
        }

        startAuto();
    }

    /* ===== 정렬 탭 ===== */
    $('.sort-tab').click(function (e) {
        e.preventDefault();
        $('.sort-tab').removeClass('active');
        $(this).addClass('active');
        var sortType  = $(this).data('sort');
        
        $('#sortInput').val(sortType);
        
        var targetUrl = '${pageContext.request.contextPath}/shop/user/main.do?' + $('#filterForm').serialize();
        
        $('.prod-grid').css('opacity', '0.4');
        $('.prod-grid').load(targetUrl + ' .prod-grid > *', function () { $('.prod-grid').css('opacity', '1'); });
    });

    /* ===== 페이징 ===== */
    $(document).on('click', '.page-btn', function (e) {
        e.preventDefault();
        var pageNum   = $(this).data('page');
        var sortType  = $('.sort-tab.active').data('sort') || 'recommend';
        var targetUrl = '${pageContext.request.contextPath}/shop/user/main.do?' + $('#filterForm').serialize() + '&sort=' + sortType + '&pageNum=' + pageNum;
        $('#prod-list-area').css('opacity', '0.4');
        $('#prod-list-area').load(targetUrl + ' #prod-list-area > *', function () { $('#prod-list-area').css('opacity', '1'); });
    });
    
	/* ===== 스크롤 위치 유지 ===== */
    let savedScrollY = sessionStorage.getItem("mainScrollY");
    if (savedScrollY) {
        window.scrollTo(0, parseInt(savedScrollY));
        sessionStorage.removeItem("mainScrollY");
    }

    $('#filterForm, .hdr-search').on('submit', function() {
        sessionStorage.setItem("mainScrollY", window.scrollY);
    });

    $('.cat-item').on('click', function() {
        sessionStorage.setItem("mainScrollY", window.scrollY);
    });

});
</script>
</body>
</html>
