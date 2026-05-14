<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>상품 등록 | ShoeMall Admin</title>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/KM_style.css">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
<style>
/* 화면 꽉 안 차는 문제 해결을 위한 추가 스타일 */
.main {
	width: 100%;
	min-height: 100vh;
	background-color: #f8f9fa;
	padding-bottom: 50px;
}

.content {
	max-width: 1100px; /* 너무 좁지도 넓지도 않은 적당한 너비 */
	margin: 0 auto; /* 가운데 정렬 */
	width: 95%; /* 모바일/작은 화면 대응 */
	padding: 20px 0;
}

.form-container {
	width: 100%;
	background: #fff;
	padding: 40px;
	border-radius: 12px;
	box-shadow: 0 4px 20px rgba(0, 0, 0, 0.05);
	box-sizing: border-box; /* 패딩이 너비에 포함되게 함 */
}

.form-group input, .form-group select, .form-group textarea {
	width: 100%;
	box-sizing: border-box; /* 인풋창 삐져나감 방지 */
}

.section-title {
	margin-top: 30px;
	padding-bottom: 10px;
	border-bottom: 2px solid #eee;
	margin-bottom: 20px;
}
</style>
</head>
<body>

	<%@ include file="../../common/shopAdminHeader.jsp"%>

	<div class="main">
		<jsp:include page="/WEB-INF/views/common/sub_title.jsp" />

		<div class="content">
			<div class="page-hdr">
				<h1 class="page-hdr-title">👟 상품 신규 등록</h1>
				<button class="btn btn-outline"
					onclick="location.href='productList.do'">목록으로</button>
			</div>

			<div class="form-container">
				<form action="adminProductInsert.do" method="post"
					enctype="multipart/form-data">
					<h3 class="section-title">기본 정보</h3>

					<div class="form-group">
						<label for="sku">품번 (SKU)</label> <input type="text" id="sku"
							name="sku" placeholder="예: NK-AIR-001" required>
					</div>

					<div class="form-group">
						<label for="prod_name">상품명</label> <input type="text"
							id="prod_name" name="prod_name" placeholder="상품명을 입력하세요" required>
					</div>

					<div style="display: flex; gap: 20px; flex-wrap: wrap;">
						<div class="form-group" style="flex: 1; min-width: 200px;">
							<label>성별</label> <select name="gender">
								<option value="0">공용</option>
								<option value="1">남성</option>
								<option value="2">여성</option>
							</select>
						</div>
						<div class="form-group" style="flex: 1; min-width: 200px;">
							<label for="brand_num">브랜드</label> <select name="brand_num"
								required>
								<option value="" disabled selected>브랜드 선택</option>
								<c:forEach var="brand" items="${brandList}">
									<option value="${brand.brand_num}">${brand.brand_name}</option>
								</c:forEach>
							</select>
						</div>
						<div class="form-group" style="flex: 1; min-width: 200px;">
							<label for="cat_num">카테고리</label> <select name="cat_num" required>
								<option value="" disabled selected>카테고리 선택</option>
								<c:forEach var="cat" items="${categoryList}">
									<option value="${cat.cat_num}">${cat.cat_name}</option>
								</c:forEach>
							</select>
						</div>
					</div>

					<div style="display: flex; gap: 20px; flex-wrap: wrap;">
						<div class="form-group" style="flex: 1; min-width: 150px;">
							<label for="prod_price">판매가 (원)</label> <input type="number"
								id="prod_price" name="prod_price" placeholder="판매 가격 입력"
								required>
						</div>
						<div class="form-group" style="flex: 1; min-width: 150px;">
							<label for="sale_rate">할인율 (%)</label> <input type="number"
								id="sale_rate" name="sale_rate" value="0">
						</div>
						<div class="form-group" style="flex: 1; min-width: 150px;">
							<label>상품 상태</label> <select name="prod_status">
								<option value="1">판매중</option>
								<option value="2">품절</option>
								<option value="0">미판매</option>
							</select>
						</div>
					</div>

					<div class="form-group">
						<label for="prod_img_url">대표 이미지 등록</label> <input type="file"
							id="prod_img_url" name="prod_img_url" style="padding: 8px;">
					</div>

					<div class="form-group">
						<label for="prod_text">상품 상세 설명</label>
						<textarea id="prod_text" name="prod_text" rows="8"
							placeholder="상세 설명을 입력해주세요."></textarea>
					</div>

					<h3 class="section-title">📦 초기 재고/옵션 설정</h3>

					<div style="display: flex; gap: 20px; flex-wrap: wrap;">
						<div class="form-group" style="flex: 1; min-width: 150px;">
							<label for="size_val">사이즈</label> <input type="number"
								name="size_val" placeholder="예: 260" required>
						</div>
						<div class="form-group" style="flex: 1; min-width: 150px;">
							<label for="color">컬러</label> <input type="text" name="color"
								placeholder="예: Black" required>
						</div>
						<div class="form-group" style="flex: 1; min-width: 150px;">
							<label for="add_price">추가 금액</label> <input type="number"
								name="add_price" value="0">
						</div>
					</div>

					<div class="btn-area"
						style="margin-top: 40px; display: flex; gap: 10px; justify-content: flex-end;">
						<button type="button" class="btn btn-outline"
							onclick="history.back();">취소</button>
						<button type="submit" class="btn btn-black">상품 등록하기</button>
					</div>
				</form>
			</div>
		</div>
	</div>

</body>
</html>