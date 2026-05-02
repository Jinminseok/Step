<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
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
.write-container {
	background: #fff;
	border: 1px solid var(--border);
	padding: 30px;
	max-width: 800px;
	margin: 0 auto;
}

.form-group {
	margin-bottom: 20px;
}

.form-group label {
	display: block;
	font-weight: 700;
	margin-bottom: 8px;
	font-size: 14px;
}

.form-control {
	width: 100%;
	padding: 10px;
	border: 1px solid var(--border);
	font-size: 13px;
	box-sizing: border-box;
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
	height: 38px;
}

.radio-group label {
	display: inline;
	font-weight: 400;
	margin-bottom: 0;
	margin-left: 5px;
}

.btn-area {
	text-align: center;
	margin-top: 30px;
	padding-top: 20px;
	border-top: 1px solid var(--border);
}
</style>
</head>
<body>

	<!-- SIDEBAR (대시보드와 동일하게 유지) -->
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
			<div class="nav-item">
				<span class="nav-icon">🏷️</span>카테고리 관리
			</div>

			<div class="nav-section">재고 / 물류</div>
			<div class="nav-item">
				<span class="nav-icon">📦</span>재고 관리<span class="nav-badge">2</span>
			</div>
			<div class="nav-item">
				<span class="nav-icon">🧾</span>주문 관리
			</div>
			<div class="nav-item">
				<span class="nav-icon">🚚</span>배송 관리
			</div>
			<div class="nav-item">
				<span class="nav-icon">↩️</span>반품/교환 관리
			</div>

			<div class="nav-section">고객</div>
			<div class="nav-item">
				<span class="nav-icon">👤</span>회원 관리
			</div>
			<div class="nav-item">
				<span class="nav-icon">🎫</span>쿠폰 관리
			</div>
			<div class="nav-item">
				<span class="nav-icon">💬</span>채팅 문의<span class="nav-badge">3</span>
			</div>
		</nav>

		<div class="sb-footer">
			<div class="admin-row">
				<div class="admin-av">관</div>
				<div>
					<div class="admin-name">최슈퍼</div>
					<div class="admin-role">super admin</div>
				</div>
			</div>
		</div>
	</aside>

	<main class="main">
		<div class="topbar">
			<div style="font-weight: 700;">PRODUCT REGISTRATION</div>
		</div>

		<div class="content">
			<div class="page-hdr">
				<h1 class="page-hdr-title">✨ 신규 상품 등록</h1>
			</div>

			<div class="write-container">
				<form
					action="${pageContext.request.contextPath}/shop/admin/adminProductWrite.do"
					method="post" enctype="multipart/form-data">
					<div class="form-group">
						<label>상품명</label> <input type="text" name="prod_name"
							class="form-control" placeholder="상품명을 입력하세요" required>
					</div>

					<div class="form-row">
						<div class="form-group">
							<label>카테고리명</label> <input type="text" name="cat_name"
								class="form-control" placeholder="예: 스니커즈" required>
						</div>
						<div class="form-group">
							<label>브랜드명</label> <input type="text" name="brand_name"
								class="form-control" placeholder="예: Nike" required>
						</div>
					</div>

					<div class="form-row">
						<div class="form-group">
							<label>판매 가격 (₩)</label> <input type="number" name="prod_price"
								class="form-control" placeholder="숫자만 입력" required>
						</div>
						<div class="form-group">
							<label>할인율 (%)</label> <input type="number" name="sale_rate"
								class="form-control" value="0">
						</div>
					</div>

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
								<option value="2">품절</option>
								<option value="3">숨김</option>
							</select>
						</div>
					</div>

					<div class="form-group">
						<label>SKU (모델번호)</label> <input type="text" name="sku"
							class="form-control" placeholder="예: NK-AIR-001" required>
					</div>

					<div class="form-group">
						<label>상품 설명</label>
						<textarea name="prod_text" class="form-control"
							style="height: 100px; resize: none;"
							placeholder="상품 상세 설명을 입력하세요"></textarea>
					</div>

					<div class="form-group">
						<label>상품 이미지</label> <input type="file" name="upload_img"
							class="form-control">
					</div>

					<div class="btn-area">
						<button type="button" class="btn btn-outline"
							onclick="history.back()"
							style="width: 120px; margin-right: 10px;">취소</button>
						<button type="submit" class="btn btn-black" style="width: 120px;">상품
							등록</button>
					</div>
				</form>
			</div>
		</div>
	</main>
</body>
</html>