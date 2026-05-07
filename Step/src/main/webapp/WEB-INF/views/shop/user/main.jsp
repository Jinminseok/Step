<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>ShoeMall</title>
<link
	href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700;900&family=Space+Grotesk:wght@600;700&display=swap"
	rel="stylesheet">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/KR_style.css">
</head>
<body>
	<jsp:include page="/WEB-INF/views/common/header.jsp" />

	<div class="wrap">
		<c:if test="${empty sessionScope.user_num}">
			<div
				style="background: #fff3e0; border-bottom: 1px solid #ffe0b2; padding: 10px 20px; text-align: center; font-size: 13px; color: #e65100; margin-bottom: 20px;">
				🔔 로그인하시면 장바구니, 즐겨찾기, 주문 내역 등 다양한 서비스를 이용하실 수 있습니다. &nbsp; <a
					href="${pageContext.request.contextPath}/shop/user/loginForm.do"
					style="font-weight: 700; text-decoration: underline; color: inherit;">지금
					로그인하기 →</a>
			</div>
		</c:if>

		<div class="prod-wrap">
			<div class="prod-title">✨ NEW ARRIVALS</div>

			<div class="prod-grid">
				<c:forEach var="product" items="${productList}">
					<div class="prod-item"
						onclick="location.href='${pageContext.request.contextPath}/shop/product/userdetail.do?prod_num=${product.prodNum}'">
						<div class="prod-img">
							<%-- product 다음에 오는 변수명이 VO의 이미지 필드명과 일치해야 함 --%>

							<div class="prod-img">
								<%-- VO 필드명인 mainImgUrl을 사용 --%>

								<img
									src="${pageContext.request.contextPath}/upload/${product.mainImgUrl}"
									alt="${product.prodName}">
							</div>
						</div>
						<div class="prod-info">
							<div class="prod-brand">${product.brandName}</div>
							<div class="prod-name">${product.prodName}</div>
							<div class="prod-price">
								<fmt:formatNumber value="${product.prodPrice}" pattern="#,###" />
								원
							</div>
						</div>
					</div>
				</c:forEach>

				<c:if test="${empty productList}">
					<div
						style="grid-column: 1/-1; text-align: center; padding: 50px; color: #999;">
						현재 등록된 상품이 없습니다. 관리자 페이지에서 신발을 등록해 주세요</div>
				</c:if>
			</div>
		</div>
	</div>
</body>
</html>