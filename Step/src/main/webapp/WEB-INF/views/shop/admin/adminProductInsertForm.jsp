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

					<div style="display: flex; gap: 20px;">
						<div class="form-group" style="flex: 1;">
							<label>성별</label> <select name="gender">
								<option value="0">공용</option>
								<option value="1">남성</option>
								<option value="2">여성</option>
							</select>
						</div>
						<div class="form-group" style="flex: 1;">
							<label for="brand_num">브랜드</label> <input type="number"
								name="brand_num" placeholder="브랜드 번호" required>
						</div>
						<div class="form-group" style="flex: 1;">
							<label for="cat_num">카테고리</label> <input type="number"
								name="cat_num" placeholder="카테고리 번호" required>
						</div>
					</div>

					<div style="display: flex; gap: 20px;">
						<div class="form-group" style="flex: 1;">
							<label for="prod_price">판매가 (원)</label> <input type="number"
								id="prod_price" name="prod_price" placeholder="판매 가격 입력"
								required>
						</div>
						<div class="form-group" style="flex: 1;">
							<label for="sale_rate">할인율 (%)</label> <input type="number"
								id="sale_rate" name="sale_rate" value="0">
						</div>
						<div class="form-group" style="flex: 1;">
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

					<div style="display: flex; gap: 20px;">
						<div class="form-group" style="flex: 1;">
							<label for="size_val">사이즈</label> <input type="number"
								name="size_val" placeholder="예: 260" required>
						</div>
						<div class="form-group" style="flex: 1;">
							<label for="color">컬러</label> <input type="text" name="color"
								placeholder="예: Black" required>
						</div>
						<div class="form-group" style="flex: 1;">
							<label for="add_price">추가 금액</label> <input type="number"
								name="add_price" value="0">
						</div>
					</div>

					<div class="btn-area">
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