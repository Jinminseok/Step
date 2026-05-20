<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>ShoeMall Admin - 공지 알림 작성</title>
<link
	href="https://fonts.googleapis.com/css2?family=Pretendard:wght@300;400;500;600;700&display=swap"
	rel="stylesheet">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
<style type="text/css">
*, *::before, *::after {
	box-sizing: border-box;
}

body {
	background-color: #f8f9fa;
	margin: 0;
	font-family: 'Pretendard', sans-serif;
	color: #333;
}

.main {
	margin-left: 260px;
	padding: 30px;
	box-sizing: border-box;
	min-height: 100vh;
	display: flex;
	flex-direction: column;
}

.content {
	flex: 1;
	width: 100%;
	max-width: 800px;
	margin: 0 auto;
}

.page-hdr {
	margin-bottom: 24px;
}

.page-hdr-title {
	font-size: 24px;
	font-weight: bold;
	margin-bottom: 5px;
	color: #111827;
}

.page-hdr-sub {
	font-size: 14px;
	color: #666;
}

.form-card {
	background: #fff;
	border: 1px solid #e2e8f0;
	border-radius: 12px;
	padding: 30px;
	box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
}

.form-group {
	display: flex;
	flex-direction: column;
	gap: 8px;
	margin-bottom: 20px;
}

.form-label {
	font-size: 14px;
	font-weight: 600;
	color: #334155;
}

.form-control {
	width: 100%;
	padding: 12px 14px;
	font-size: 14px;
	font-family: 'Pretendard', sans-serif;
	border: 1px solid #cbd5e1;
	border-radius: 6px;
	outline: none;
	transition: border 0.2s;
}

.form-control:focus {
	border-color: #3b82f6;
	box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
}

textarea.form-control {
	resize: vertical;
	min-height: 160px;
}

.form-footer {
	display: flex;
	justify-content: flex-end;
	gap: 12px;
	border-top: 1px solid #e2e8f0;
	padding-top: 20px;
	margin-top: 10px;
}

.btn {
	padding: 10px 20px;
	font-size: 14px;
	font-weight: 600;
	border-radius: 6px;
	cursor: pointer;
	display: inline-flex;
	align-items: center;
	gap: 8px;
	border: none;
}

.btn-submit {
	color: #fff;
	background-color: #3b82f6;
}

.btn-submit:hover {
	background-color: #2563eb;
}

.btn-cancel {
	color: #475569;
	background-color: #f1f5f9;
	text-decoration: none;
}

.btn-cancel:hover {
	background-color: #e2e8f0;
}
</style>
<script type="text/javascript">
	function toggleTarget() {
		const type = document.getElementById('target_type').value;
		document.getElementById('grade_div').style.display = (type === 'GRADE') ? 'flex'
				: 'none';
		document.getElementById('user_div').style.display = (type === 'USER') ? 'flex'
				: 'none';
	}

	function validateForm(form) {
		const type = form.target_type.value;
		if (type === 'USER' && !form.target_user_id.value.trim()) {
			alert('발송할 회원의 ID를 입력하셈.');
			form.target_user_id.focus();
			return false;
		}
		if (!form.notify_title.value.trim()) {
			alert('알림 제목을 입력하셈.');
			form.notify_title.focus();
			return false;
		}
		if (!form.notify_content.value.trim()) {
			alert('알림 내용을 입력하셈.');
			form.notify_content.focus();
			return false;
		}
		return confirm('해당 조건으로 공지 알림을 발송하겠음?');
	}
</script>
</head>
<body>

	<%@ include file="../../common/shopAdminHeader.jsp"%>

	<div class="main">
		<div class="content">
			<div class="page-hdr">
				<div class="page-hdr-title">공지 알림 작성</div>
				<div class="page-hdr-sub">전체 회원, 특정 등급, 또는 개별 회원을 타겟팅하여 알림을
					발송합니다.</div>
			</div>

			<div class="form-card">
				<form action="sendNotice.do" method="post"
					onsubmit="return validateForm(this)">

					<div class="form-group">
						<label class="form-label">발송 대상 선택</label> <select
							name="target_type" id="target_type" class="form-control"
							onchange="toggleTarget()">
							<option value="ALL">전체 정상 회원 (일괄 발송)</option>
							<option value="GRADE">특정 등급 회원</option>
							<option value="USER">특정 회원 (ID 지정)</option>
						</select>
					</div>

					<div class="form-group" id="grade_div" style="display: none;">
						<label class="form-label">등급 지정</label> <select
							name="target_grade" class="form-control">
							<option value="1">일반 회원</option>
							<option value="2">실버 회원</option>
							<option value="3">골드 회원</option>
							<option value="4">VIP 회원</option>
						</select>
					</div>

					<div class="form-group" id="user_div" style="display: none;">
						<label class="form-label">대상 회원 ID</label> <input type="text"
							name="target_user_id" class="form-control"
							placeholder="정확한 회원 ID를 입력하셈">
					</div>

					<div class="form-group">
						<label class="form-label">알림 제목</label> <input type="text"
							name="notify_title" class="form-control"
							placeholder="예: [안내] VIP 등급 혜택 개편 안내">
					</div>

					<div class="form-group">
						<label class="form-label">알림 내용</label>
						<textarea name="notify_content" class="form-control"
							placeholder="상세 알림 내용을 입력하셈. (최대 500자)"></textarea>
					</div>

					<div class="form-footer">
						<a href="notifyList.do" class="btn btn-cancel">취소</a>
						<button type="submit" class="btn btn-submit">
							<i class="fa-solid fa-paper-plane"></i> 발송하기
						</button>
					</div>
				</form>
			</div>
		</div>
	</div>
</body>
</html>