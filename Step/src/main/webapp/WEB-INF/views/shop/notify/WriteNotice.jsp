<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>ShoeMall Admin - 공지 알림 작성</title>
<link href="https://fonts.googleapis.com/css2?family=Pretendard:wght@300;400;500;600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
<style>
*, *::before, *::after { box-sizing: border-box; }
body { background:#f8f9fa; margin:0; font-family:'Pretendard',sans-serif; color:#333; }

.main { margin-left:260px; padding:30px; min-height:100vh; display:flex; flex-direction:column; }
.content { flex:1; width:100%; max-width:800px; margin:0 auto; }

.page-hdr { margin-bottom:24px; }
.page-hdr-title { font-size:24px; font-weight:700; margin-bottom:5px; color:#111827; }
.page-hdr-sub { font-size:14px; color:#666; }

.form-card { background:#fff; border:1px solid #e2e8f0; border-radius:12px; padding:30px; box-shadow:0 1px 3px rgba(0,0,0,.05); }

.form-group { display:flex; flex-direction:column; gap:8px; margin-bottom:20px; }
.form-label { font-size:14px; font-weight:600; color:#334155; }
.form-label .required { color:#ef4444; margin-left:3px; }

.form-control { width:100%; padding:12px 14px; font-size:14px; font-family:'Pretendard',sans-serif; border:1px solid #cbd5e1; border-radius:6px; outline:none; transition:border 0.2s; color:#334155; background:#fff; }
.form-control:focus { border-color:#3b82f6; box-shadow:0 0 0 3px rgba(59,130,246,.1); }
textarea.form-control { resize:vertical; min-height:160px; }

/* 대상 선택 카드 */
.target-cards { display:flex; gap:12px; margin-bottom:4px; }
.target-card { flex:1; padding:14px; border:1.5px solid #e2e8f0; border-radius:8px; cursor:pointer; transition:all 0.2s; text-align:center; }
.target-card:hover { border-color:#93c5fd; background:#f0f7ff; }
.target-card.selected { border-color:#3b82f6; background:#eff6ff; }
.target-card .tc-icon { font-size:22px; margin-bottom:6px; }
.target-card .tc-label { font-size:13px; font-weight:600; color:#334155; }
.target-card .tc-desc { font-size:11px; color:#94a3b8; margin-top:2px; }

.form-footer { display:flex; justify-content:flex-end; gap:12px; border-top:1px solid #e2e8f0; padding-top:20px; margin-top:10px; }
.btn { padding:10px 20px; font-size:14px; font-weight:600; border-radius:6px; cursor:pointer; display:inline-flex; align-items:center; gap:8px; border:none; transition:background 0.2s; }
.btn-submit { color:#fff; background:#3b82f6; }
.btn-submit:hover { background:#2563eb; }
.btn-cancel { color:#475569; background:#f1f5f9; text-decoration:none; }
.btn-cancel:hover { background:#e2e8f0; }

/* 미리보기 */
.preview-box { background:#f8fafc; border:1px solid #e2e8f0; border-radius:8px; padding:16px; margin-top:8px; display:none; }
.preview-noti { display:flex; align-items:flex-start; gap:12px; }
.preview-icon { font-size:24px; }
.preview-title { font-size:14px; font-weight:700; color:#0f172a; margin-bottom:4px; }
.preview-content { font-size:13px; color:#64748b; }

/* 글자수 카운터 */
.char-counter { font-size:12px; color:#94a3b8; text-align:right; }
.char-counter.warn { color:#ef4444; }
</style>
</head>
<body>

<%@ include file="../../common/shopAdminHeader.jsp"%>

<div class="main">
  <div class="content">

    <div class="page-hdr">
      <div class="page-hdr-title">공지 알림 작성</div>
      <div class="page-hdr-sub">전체 회원, 특정 등급, 또는 개별 회원을 대상으로 알림을 발송합니다.</div>
    </div>

    <div class="form-card">
      <form action="sendNotice.do" method="post" onsubmit="return validateForm(this)">

        <%-- 발송 대상 선택 (카드형) --%>
        <div class="form-group">
          <label class="form-label">발송 대상 선택 <span class="required">*</span></label>
          <div class="target-cards">
            <div class="target-card selected" onclick="selectTarget('ALL', this)">
              <div class="tc-icon">👥</div>
              <div class="tc-label">전체 회원</div>
              <div class="tc-desc">정상 가입 회원 전체</div>
            </div>
            <div class="target-card" onclick="selectTarget('GRADE', this)">
              <div class="tc-icon">🏅</div>
              <div class="tc-label">등급별 발송</div>
              <div class="tc-desc">특정 등급만 선택</div>
            </div>
            <div class="target-card" onclick="selectTarget('USER', this)">
              <div class="tc-icon">👤</div>
              <div class="tc-label">개별 회원</div>
              <div class="tc-desc">ID 직접 입력</div>
            </div>
          </div>
          <input type="hidden" name="target_type" id="target_type" value="ALL">
        </div>

        <%-- 등급 선택 --%>
        <div class="form-group" id="grade_div" style="display:none;">
          <label class="form-label">등급 지정 <span class="required">*</span></label>
          <select name="target_grade" class="form-control">
            <option value="1">⭐ 일반 회원</option>
            <option value="2">⭐⭐ 실버 회원</option>
            <option value="3">⭐⭐⭐ 골드 회원</option>
            <option value="4">👑 VIP 회원</option>
          </select>
        </div>

        <%-- 특정 회원 ID --%>
        <div class="form-group" id="user_div" style="display:none;">
          <label class="form-label">대상 회원 ID <span class="required">*</span></label>
          <input type="text" name="target_user_id" id="target_user_id"
                 class="form-control" placeholder="정확한 회원 ID를 입력하세요">
        </div>

        <%-- 알림 제목 --%>
        <div class="form-group">
          <label class="form-label">알림 제목 <span class="required">*</span></label>
          <input type="text" name="notify_title" id="notify_title"
                 class="form-control" placeholder="예: [안내] VIP 등급 혜택 개편 안내"
                 maxlength="100" oninput="updatePreview()">
          <div class="char-counter" id="title_counter">0 / 100</div>
        </div>

        <%-- 알림 내용 --%>
        <div class="form-group">
          <label class="form-label">알림 내용 <span class="required">*</span></label>
          <textarea name="notify_content" id="notify_content"
                    class="form-control" placeholder="상세 알림 내용을 입력하세요. (최대 500자)"
                    maxlength="500" oninput="updatePreview()"></textarea>
          <div class="char-counter" id="content_counter">0 / 500</div>
        </div>

        <%-- 미리보기 --%>
        <div class="form-group">
          <label class="form-label">발송 미리보기</label>
          <div class="preview-box" id="previewBox">
            <div class="preview-noti">
              <div class="preview-icon">🎁</div>
              <div>
                <div class="preview-title" id="previewTitle">제목이 여기 표시됩니다</div>
                <div class="preview-content" id="previewContent">내용이 여기 표시됩니다</div>
              </div>
            </div>
          </div>
          <div id="previewEmpty" style="font-size:13px;color:#94a3b8;padding:10px 0;">
            제목과 내용을 입력하면 미리보기가 표시됩니다.
          </div>
        </div>

        <div class="form-footer">
          <a href="notifyList.do" class="btn btn-cancel">
            <i class="fa-solid fa-xmark"></i> 취소
          </a>
          <button type="submit" class="btn btn-submit">
            <i class="fa-solid fa-paper-plane"></i> 발송하기
          </button>
        </div>

      </form>
    </div>

  </div>
</div>

<script>
/* 대상 선택 카드 */
function selectTarget(type, el) {
  document.querySelectorAll('.target-card').forEach(function(c) { c.classList.remove('selected'); });
  el.classList.add('selected');
  document.getElementById('target_type').value = type;
  document.getElementById('grade_div').style.display = (type === 'GRADE') ? 'flex' : 'none';
  document.getElementById('user_div').style.display  = (type === 'USER')  ? 'flex' : 'none';
}

/* 미리보기 업데이트 */
function updatePreview() {
  var title   = document.getElementById('notify_title').value.trim();
  var content = document.getElementById('notify_content').value.trim();

  // 글자수 카운터
  var tLen = document.getElementById('notify_title').value.length;
  var cLen = document.getElementById('notify_content').value.length;
  var tc = document.getElementById('title_counter');
  var cc = document.getElementById('content_counter');
  tc.textContent = tLen + ' / 100';
  cc.textContent = cLen + ' / 500';
  tc.className = 'char-counter' + (tLen > 80 ? ' warn' : '');
  cc.className = 'char-counter' + (cLen > 450 ? ' warn' : '');

  // 미리보기
  if (title || content) {
    document.getElementById('previewBox').style.display   = 'block';
    document.getElementById('previewEmpty').style.display = 'none';
    document.getElementById('previewTitle').textContent   = title   || '(제목 없음)';
    document.getElementById('previewContent').textContent = content || '(내용 없음)';
  } else {
    document.getElementById('previewBox').style.display   = 'none';
    document.getElementById('previewEmpty').style.display = 'block';
  }
}

/* 폼 유효성 검사 */
function validateForm(form) {
  var type = form.target_type.value;
  if (type === 'USER' && !form.target_user_id.value.trim()) {
    alert('발송할 회원의 ID를 입력해주세요.');
    form.target_user_id.focus();
    return false;
  }
  if (!form.notify_title.value.trim()) {
    alert('알림 제목을 입력해주세요.');
    form.notify_title.focus();
    return false;
  }
  if (!form.notify_content.value.trim()) {
    alert('알림 내용을 입력해주세요.');
    form.notify_content.focus();
    return false;
  }
  return confirm('해당 조건으로 공지 알림을 발송하시겠습니까?');
}
</script>
</body>
</html>