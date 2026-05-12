<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> <%-- 가격 콤마(,) 표시를 위해 추가 --%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>ShoeMall - 찜한 상품</title>
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700;900&family=Space+Grotesk:wght@600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/KR_style.css">
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
</head>
<body>
    <jsp:include page="/WEB-INF/views/common/header.jsp"/>

    <div class="wrap">
        <div class="page-title">찜한 상품 🤍</div>
        
        <%-- 메인 화면과 동일하게 --%>
        <div class="prod-grid">
            
            <%-- 찜한 상품이 없을 경우 --%>
            <c:if test="${empty wishList}">
                <div style="grid-column: 1 / -1; padding: 120px 0; text-align: center; color: var(--gray4); font-size: 15px;">
                    아직 찜한 상품이 없습니다. 마음에 드는 상품에 하트를 눌러보세요!
                </div>
            </c:if>

            <%-- Action에서 넘겨준 wishList 데이터를 하나씩 꺼내서 카드 만들기 --%>
            <c:forEach var="wish" items="${wishList}">
                
                <%-- 상품 카드를 누르면 상세 페이지로 이동 --%>
                <div class="prod-item" onclick="location.href='${pageContext.request.contextPath}/shop/product/productdetail.do?prod_num=${wish.prod_num}'">
                    
                    <%-- 1. 상품 이미지 영역 --%>
                    <div class="prod-img">
                        <img src="${pageContext.request.contextPath}/upload/${wish.prod_img_url}" alt="${wish.prod_name}">
                        
                        <%-- 사진 우측 하단에 배치된 하트 아이콘 --%>
                        <div class="prod-wish on" style="position:absolute; bottom:12px; right:12px; font-size:22px; cursor:pointer; text-shadow: 0 2px 4px rgba(0,0,0,0.1);" 
                             onclick="event.stopPropagation(); removeWish(${wish.prod_num});">❤️</div>
                    </div>
                    
                    <%-- 2. 상품 정보 영역 --%>
                    <div class="prod-info">
                        <div class="prod-brand">${wish.brand_name}</div>
                        <div class="prod-name">${wish.prod_name}</div>
                        <div class="prod-price"><fmt:formatNumber value="${wish.prod_price}" pattern="#,###"/>원</div>
                        
                    </div>
                    
                </div>
            </c:forEach>

        </div>
    </div>
    
<script>
// 찜 해제(삭제)
function removeWish(prod_num) {
    if(!confirm("이 상품을 찜 목록에서 삭제하시겠습니까?")) return;

    $.ajax({
        url: '${pageContext.request.contextPath}/shop/wish/deleteWish.do',
        type: 'post',
        data: { prod_num: prod_num },
        dataType: 'json',
        success: function(param) {
            if(param.result === 'logout') {
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