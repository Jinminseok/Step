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
<style>
.main-content {
	margin-left: 260px;
	padding: 20px;
}

.form-container {
	background: #fff;
	padding: 30px;
	border-radius: 8px;
	box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
}

.form-group {
	margin-bottom: 15px;
}

.form-group label {
	display: block;
	margin-bottom: 5px;
	font-weight: bold;
}

.form-group input, .form-group select, .form-group textarea {
	width: 100%;
	padding: 10px;
	border: 1px solid #ddd;
	border-radius: 4px;
}

.btn-submit {
	background-color: #333;
	color: #fff;
	padding: 12px 25px;
	border: none;
	border-radius: 4px;
	cursor: pointer;
}

.btn-submit:hover {
	background-color: #555;
}
</style>
</head>
<body>

	<%@ include file="../../common/shopAdminHeader.jsp"%>

	<div class="main-content">
		<div class="form-container">
			<h2>👟 상품 등록 (Admin Panel)</h2>
			<hr>
			<form action="adminProductInsert.do" method="post"
				enctype="multipart/form-data">
				<div class="form-group">
					<label for="sku">품번 (SKU)</label> <input type="text" id="sku"
						name="sku" placeholder="예: NK-AIR-001" required>
				</div>

				<div class="form-group">
					<label for="prod_name">상품명</label> <input type="text"
						id="prod_name" name="prod_name" required>
				</div>

				<div class="form-group">
					<label>성별</label> <select name="gender">
						<option value="0">공용</option>
						<option value="1">남성</option>
						<option value="2">여성</option>
					</select>
				</div>

				<div class="form-group">
					<label for="brand_num">브랜드</label> <input type="number"
						name="brand_num" placeholder="브랜드 번호 입력" required>
				</div>

				<div class="form-group">
					<label for="cat_num">카테고리</label> <input type="number"
						name="cat_num" placeholder="카테고리 번호 입력" required>
				</div>

				<div class="form-group">
					<label for="prod_price">판매가</label> <input type="number"
						id="prod_price" name="prod_price" required>
				</div>

				<div class="form-group">
					<label for="sale_rate">할인율 (%)</label> <input type="number"
						id="sale_rate" name="sale_rate" value="0">
				</div>

				<div class="form-group">
					<label>상품 상태</label> <select name="prod_status">
						<option value="1">판매중</option>
						<option value="2">품절</option>
						<option value="0">미판매</option>
					</select>
				</div>

				<div class="form-group">
					<label for="prod_img_url">대표 이미지</label> <input type="file"
						id="prod_img_url" name="prod_img_url">
				</div>

				<div class="form-group">
					<label for="prod_text">상품 설명</label>
					<textarea id="prod_text" name="prod_text" rows="5"></textarea>
				</div>

				<hr>
				<h3>📦 초기 옵션/재고 설정</h3>
				<div class="form-group">
					<label for="size_val">사이즈</label> <input type="number"
						name="size_val" placeholder="예: 260" required>
				</div>
				<div class="form-group">
					<label for="color">컬리</label> <input type="text" name="color"
						placeholder="예: Black" required>
				</div>
				<div class="form-group">
					<label for="add_price">추가 금액</label> <input type="number"
						name="add_price" value="0">
				</div>

				<div style="text-align: right;">
					<button type="submit" class="btn-submit">상품 등록하기</button>
				</div>
			</form>
		</div>
	</div>

</body>
</html>