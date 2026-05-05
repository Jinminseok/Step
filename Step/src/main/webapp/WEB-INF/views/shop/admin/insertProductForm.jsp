<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>상품 등록 - 관리자 페이지</title>
<style>
.form-container {
	width: 600px;
	margin: 20px auto;
	padding: 20px;
	border: 1px solid #ccc;
	border-radius: 10px;
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
	padding: 8px;
	box-sizing: border-box;
}

.btn-submit {
	background-color: #28a745;
	color: white;
	padding: 10px 20px;
	border: none;
	cursor: pointer;
	border-radius: 5px;
	width: 100%;
}

.btn-submit:hover {
	background-color: #218838;
}
</style>
<script type="text/javascript">
	window.onload = function() {
		const myForm = document.getElementById('insert_form');

		myForm.onsubmit = function() {
			// 유효성 체크
			const items = document.querySelectorAll('.input-check');
			for (let i = 0; i < items.length; i++) {
				if (items[i].value.trim() == '') {
					const label = items[i].previousElementSibling.innerText;
					alert(label + '을(를) 입력하세요');
					items[i].focus();
					return false;
				}
			}

			// 숫자 필드 체크
			if (isNaN(document.getElementById('prod_price').value)) {
				alert('가격은 숫자만 입력 가능합니다');
				return false;
			}

			// 파일 체크
			const file = document.getElementById('upload_img');
			if (file.value == '') {
				alert('상품 이미지는 필수입니다');
				return false;
			}
		};
	};
</script>
</head>
<body>

	<div class="form-container">
		<h2>상품 등록</h2>
		<!-- enctype="multipart/form-data" 설정으로 파일 업로드 가능하게 처리 -->
		<form action="insertProduct.do" method="post" id="insert_form"
			enctype="multipart/form-data">

			<div class="form-group">
				<label for="prod_name">상품명</label> <input type="text"
					name="prod_name" id="prod_name" class="input-check">
			</div>

			<div class="form-group">
				<label for="cat_num">카테고리</label> <select name="cat_num"
					id="cat_num" class="input-check">
					<option value="">-- 카테고리 선택 --</option>
					<c:forEach var="cat" items="${categoryList}">
						<option value="${cat.cat_num}">${cat.cat_name}</option>
					</c:forEach>
				</select>
			</div>

			<div class="form-group">
				<label for="brand_num">브랜드</label> <select name="brand_num"
					id="brand_num" class="input-check">
					<option value="">-- 브랜드 선택 --</option>
					<c:forEach var="brand" items="${brandList}">
						<option value="${brand.brand_num}">${brand.brand_name}</option>
					</c:forEach>
				</select>
			</div>

			<div class="form-group">
				<label for="sku">SKU (상품코드)</label> <input type="text" name="sku"
					id="sku" class="input-check">
			</div>

			<div class="form-group">
				<label>성별</label> <input type="radio" name="gender" value="1"
					checked> 남성 <input type="radio" name="gender" value="2">
				여성 <input type="radio" name="gender" value="3"> 공용
			</div>

			<div class="form-group">
				<label for="prod_price">상품 가격</label> <input type="number"
					name="prod_price" id="prod_price" class="input-check" min="0">
			</div>

			<div class="form-group">
				<label for="sale_rate">할인율 (%)</label> <input type="number"
					name="sale_rate" id="sale_rate" value="0" min="0" max="100">
			</div>

			<hr>
			<h4>기본 옵션 설정</h4>
			<div class="form-group">
				<label for="size_val">사이즈</label> <input type="number"
					name="size_val" id="size_val" class="input-check"
					placeholder="예: 260">
			</div>

			<div class="form-group">
				<label for="color">색상</label> <input type="text" name="color"
					id="color" class="input-check" placeholder="예: Black">
			</div>

			<div class="form-group">
				<label for="add_price">옵션 추가 금액</label> <input type="number"
					name="add_price" id="add_price" value="0">
			</div>

			<hr>

			<div class="form-group">
				<label for="prod_text">상품 설명</label>
				<textarea name="prod_text" id="prod_text" rows="5"
					class="input-check"></textarea>
			</div>

			<div class="form-group">
				<label for="upload_img">상품 이미지</label>
				<!-- Action 파일의 FileUtil.uploadFile(request, "upload_img")과 이름이 같아야 함 -->
				<input type="file" name="upload_img" id="upload_img"
					accept="image/*">
			</div>

			<button type="submit" class="btn-submit">상품 등록하기</button>
		</form>
	</div>

</body>
</html>