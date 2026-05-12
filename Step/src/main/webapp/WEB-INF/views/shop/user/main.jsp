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

        <%-- 메인 광고 배너(더미 데이터) --%>
        <div class="slider-wrap">
            <div class="slides">
                <div class="slide">
                    <div class="slide-content">
                        <div class="slide-tag">BEST</div>
                        <div class="slide-title">나이키 에어맥스 270<br>신상 컬러 출시</div>
                        <div class="slide-sub">가장 인기있는 에어맥스 라인에 새 색상 추가</div>
                        <button class="slide-cta">지금 보러가기 →</button>
                    </div>
                </div>
            </div>
        </div>

        <%-- 왼쪽 사이드바, 오른쪽 상품 그리드 분할 레이아웃 --%>
        <div class="home-layout">
            
            <%-- 좌측 필터 사이드바 --%>
            <div class="filter-side">
                <form id="filterForm" action="${pageContext.request.contextPath}/shop/user/main.do" method="get">
                    
                    <%-- 1. 카테고리 필터--%>
                    <div class="filter-box">
                        <div class="filter-title">카테고리 ▾</div>
                        <div class="filter-opts">
                            <label class="filter-opt">
                                <input type="radio" name="cat_num" value="0" ${selected_cat == 0 ? 'checked' : ''} onchange="document.getElementById('filterForm').submit();">
                                전체보기
                            </label>
                            <%-- DB 목록 반복 --%>
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
            <%-- 좌측 필터 사이드바 끝 --%>


            <%-- 우측 상품 리스트 영역 --%>
            <div class="prod-wrap" id="prod-list-area" style="flex:1; margin:0; padding:0; max-width: none;">
                <div class="sort-header">
                    <div class="sort-tabs">
                        <a href="#" data-sort="recommend" class="sort-tab ${param.sort == 'recommend' || empty param.sort ? 'active' : ''}">추천순</a>
                        <a href="#" data-sort="popular" class="sort-tab ${param.sort == 'popular' ? 'active' : ''}">인기순</a>
                        <a href="#" data-sort="new" class="sort-tab ${param.sort == 'new' ? 'active' : ''}">최신순</a>
                    </div>
                    <div class="total-count">총 ${productList.size()}개</div>
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
                        <%-- '이전 블록' 화살표 --%>
                        <c:if test="${startPage > 1}">
                            <a href="#" data-page="${startPage - 1}" class="page-btn">◀</a>
                        </c:if>

                        <%-- 번호 찍어주기 --%>
                        <c:forEach var="i" begin="${startPage}" end="${endPage}">
                            <a href="#" data-page="${i}" class="page-btn ${currentPage == i ? 'active' : ''}">${i}</a>
                        </c:forEach>

                        <%-- '다음 블록' 화살표 --%>
                        <c:if test="${endPage < totalPage}">
                            <a href="#" data-page="${endPage + 1}" class="page-btn">▶</a>
                        </c:if>
                    </c:if>
                </div>
            </div>
            <%-- 우측 상품 리스트 영역 끝 --%>
        </div>
    </div>
    
<script>
// 정렬 탭
$(document).ready(function() {
    $('.sort-tab').click(function(e) {
        e.preventDefault();

        // 1. 클릭한 탭으로 까만 밑줄 옮기기
        $('.sort-tab').removeClass('active');
        $(this).addClass('active');

        // 2. 어떤 정렬 방식을 눌렀는지 가져오기 (recommend, popular, new)
        let sortType = $(this).data('sort');

        // 3. 좌측 필터(카테고리, 브랜드) 값을 그대로 가져와서 정렬 조건과 합치기
        let formData = $('#filterForm').serialize();
        let targetUrl = '${pageContext.request.contextPath}/shop/user/main.do?' + formData + '&sort=' + sortType;

        // 4. 로딩 중 시각적 효과
        $('.prod-grid').css('opacity', '0.4');

        // 5. 서버의 메인 화면을 백그라운드로 몰래 호출한 뒤, 
        // 그 중에서 '.prod-grid' 안에 있는 상품 카드들만 호출해여 현재 화면을 교체
        $('.prod-grid').load(targetUrl + ' .prod-grid > *', function() {
            $('.prod-grid').css('opacity', '1');
        });
    });
    
    // 하단 페이징 버튼을 눌렀을 때
    $(document).on('click', '.page-btn', function(e) {
        e.preventDefault();
        let pageNum = $(this).data('page'); // 누른 페이지 번호
        
        let sortType = $('.sort-tab.active').data('sort'); // 현재 눌려있는 탭 기준 기억하기
        if(!sortType) sortType = 'recommend'; // 기본값
        
        let formData = $('#filterForm').serialize();
        let targetUrl = '${pageContext.request.contextPath}/shop/user/main.do?' + formData + '&sort=' + sortType + '&pageNum=' + pageNum;

        $('#prod-list-area').css('opacity', '0.4');
        $('#prod-list-area').load(targetUrl + ' #prod-list-area > *', function() {
            $('#prod-list-area').css('opacity', '1');
            // 스크롤을 살짝 위로 올려주고 싶다면 아래 줄의 주석을 푸세요!
            // window.scrollTo({top: 400, behavior: 'smooth'}); 
        });
    });
});
</script>
</body>
</html>