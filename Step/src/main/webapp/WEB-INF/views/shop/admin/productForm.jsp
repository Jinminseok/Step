<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>신규 상품 등록 - ShoeMall Admin</title>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/KM_style.css">
<link
	href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;700;900&display=swap"
	rel="stylesheet">
<style>
/* 기존 스타일 그대로 유지 */
.write-container {
	background: #fff;
	border: 1px solid var(--border);
	padding: 30px;
	max-width: 800px;
	margin: 0 auto;
	border-radius: 8px;
}

.form-group {
	margin-bottom: 20px;
}

.form-group label {
	display: block;
	font-weight: 700;
	margin-bottom: 8px;
	font-size: 14px;
	color: #333;
}

.form-control {
	width: 100%;
	padding: 12px;
	border: 1px solid var(--border);
	font-size: 13px;
	box-sizing: border-box;
	border-radius: 4px;
}

.form-control:focus {
	border-color: #000;
	outline: none;
}

.form-row {
	display: flex;
	gap: 20px;
}

.form-row .form-group {
	flex: 1;
}

.radio-group {
	display: flex;
	gap: 15px;
	align-items: center;
	height: 42px;
}

.radio-group label {
	display: inline;
	font-weight: 400;
	margin: 0 0 0 5px;
	cursor: pointer;
}

.btn-area {
	text-align: center;
	margin-top: 30px;
	padding-top: 20px;
	border-top: 1px solid var(--border);
}

.required {
	color: #e74c3c;
	margin-left: 3px;
}

textarea.form-control {
	height: 120px;
	resize: none;
	line-height: 1.5;
}
</style>
</head>
<body>

	<aside class="sidebar">
		<div class="sb-logo">
			<div class="sb-logo-mark">A</div>
			<div>
				<div class="sb-logo-txt">
					Shoe<span>Mall</span>
				</div>
				<div class="sb-logo-badge">Admin Panel</div>
			</div>
		</div>
		<nav class="nav">
			<div class="nav-section">대시보드</div>
			<div class="nav-item"
				onclick="location.href='${pageContext.request.contextPath}/shop/admin/main.do'">
				<span class="nav-icon">📊</span>통계 / 대시보드
			</div>
			<div class="nav-section">상품</div>
			<div class="nav-item active"
				onclick="location.href='${pageContext.request.contextPath}/shop/admin/productList.do'">
				<span class="nav-icon">👟</span>상품 관리
			</div>
			<div class="nav-item" onclick="location.href='#'">
				<span class="nav-icon">🏷️</span>카테고리 관리
			</div>
		</nav>
	</aside>

	<main class="main">
		<div class="topbar">
			<div style="font-weight: 700; letter-spacing: 1px;">PRODUCT
				REGISTRATION</div>
			<div class="admin-profile">관리자 님 👋</div>
		</div>

		<div class="content">
			<div class="page-hdr">
				<h1 class="page-hdr-title">✨ 신규 상품 등록</h1>
				<p style="color: #666; font-size: 13px; margin-top: 5px;">판매할
					새로운 상품 정보를 정확하게 입력해주세요.</p>
			</div>

			<div class="write-container">
				<form
					action="${pageContext.request.contextPath}/shop/admin/adminProductWrite.do"
					method="post" enctype="multipart/form-data">

					<!-- 상품명 -->
					<div class="form-group">
						<label>상품명<span class="required">*</span></label> <input
							type="text" name="prod_name" class="form-control"
							placeholder="상품명을 입력하세요 (예: 에어 포스 1)" required>
					</div>

					<!-- 카테고리(선택) & 브랜드(직접입력 수정됨) -->
					<div class="form-row">
						<div class="form-group">
							<label>카테고리<span class="required">*</span></label> <select
								name="cat_num" class="form-control" required>
								<option value="">선택하세요</option>
								<option value="1">운동화</option>
								<option value="2">샌들/슬리퍼</option>
								<option value="3">구두/로퍼</option>
								<option value="4">부츠</option>
							</select>
						</div>
						<div class="form-group">
							<label>브랜드명<span class="required">*</span></label>
							<!-- 브랜드를 직접 입력받도록 수정 -->
							<input type="text" name="brand_name" class="form-control"
								placeholder="브랜드명을 입력하세요 (예: Nike)" required>
						</div>
					</div>

					<!-- 가격 & 할인율 -->
					<div class="form-row">
						<div class="form-group">
							<label>판매 가격 (₩)<span class="required">*</span></label> <input
								type="number" name="prod_price" class="form-control" min="0"
								step="100" placeholder="숫자만 입력" required>
						</div>
						<div class="form-group">
							<label>할인율 (%)</label> <input type="number" name="sale_rate"
								class="form-control" min="0" max="100" value="0">
						</div>
					</div>

					<!-- 성별 & 상태 -->
					<div class="form-row">
						<div class="form-group">
							<label>성별</label>
							<div class="radio-group">
								<span><input type="radio" name="gender" value="0"
									id="g_all" checked><label for="g_all">공용</label></span> <span><input
									type="radio" name="gender" value="1" id="g_man"><label
									for="g_man">남성</label></span> <span><input type="radio"
									name="gender" value="2" id="g_woman"><label
									for="g_woman">여성</label></span>
							</div>
						</div>
						<div class="form-group">
							<label>판매 상태</label> <select name="prod_status"
								class="form-control">
								<option value="1">판매중</option>
								<option value="2">전시안함(숨김)</option>
								<option value="3">일시품절</option>
							</select>
						</div>
					</div>

					<!-- 모델번호(SKU) -->
					<div class="form-group">
						<label>SKU (모델번호)<span class="required">*</span></label> <input
							type="text" name="sku" class="form-control"
							placeholder="예: CW2288-111" required>
					</div>

					<!-- 상품 상세 설명 -->
					<div class="form-group">
						<label>상품 상세 설명</label>
						<textarea name="prod_text" class="form-control"
							placeholder="소재, 특징 등 상세 정보를 입력하세요."></textarea>
					</div>

					<!-- 대표 이미지 업로드 -->
					<div class="form-group">
						<label>대표 이미지 (Thumbnail)</label> <input type="file"
							name="upload_img" class="form-control" accept="image/*">
						<p style="font-size: 11px; color: #999; margin-top: 5px;">* 권장
							사이즈: 800x800px / jpg, png 파일</p>
					</div>

					<div class="btn-area">
						<button type="button" class="btn btn-outline"
							onclick="history.back()"
							style="width: 140px; margin-right: 12px;">취소 및 돌아가기</button>
						<button type="submit" class="btn btn-black" style="width: 140px;">상품
							등록 완료</button>
					</div>
				</form>
			</div>
		</div>
	</main>
</body>
</html>