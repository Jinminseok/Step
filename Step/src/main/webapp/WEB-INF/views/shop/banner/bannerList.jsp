<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>ShoeMall - 배너 관리</title>
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700;900&family=Space+Grotesk:wght@600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/KM_style.css">
<style>
.main{margin-left:220px;flex:1;display:flex;flex-direction:column;min-height:100vh}
.topbar{height:54px;border-bottom:1px solid #1a1a1a;display:flex;align-items:center;padding:0 24px;background:var(--black);position:sticky;top:0;z-index:50}
.topbar-title{font-family:'Space Grotesk',sans-serif;font-size:14px;font-weight:700;color:#fff;}
.content{padding:24px;flex:1}

/* 배너 미리보기 - 고정 비율로 넘침 없이 */
.banner-preview-wrap{width:200px;height:90px;overflow:hidden;border:1px solid var(--border);border-radius:6px;background:#f5f5f5;display:flex;align-items:center;justify-content:center;}
.banner-preview{width:100%;height:100%;object-fit:cover;display:block;}

.badge{display:inline-flex;align-items:center;padding:3px 9px;font-size:11px;font-weight:700;border-radius:20px}
.b-normal{background:#e8f5e8;color:var(--green)}
.b-silver{background:#f0f0f0;color:#555}
.modal-overlay{display:none;position:fixed;inset:0;background:rgba(0,0,0,.6);z-index:300;align-items:center;justify-content:center}
.modal-overlay.open{display:flex}
.modal-box{background:var(--white);width:500px;border:1px solid var(--border);border-radius:4px;overflow:hidden}
.modal-hdr{padding:18px 22px;background:var(--black);color:#fff;display:flex;justify-content:space-between;align-items:center;}
.f-label{font-size:11px;font-weight:700;color:#555;display:block;margin-bottom:5px;}
.f-input{padding:10px;border:1px solid var(--border);width:100%;margin-bottom:14px;outline:none;font-family:'Noto Sans KR',sans-serif;font-size:13px;box-sizing:border-box;}
.f-input:focus{border-color:#111}

/* 이미지 미리보기 영역 (모달 내부) */
.img-preview-wrap{width:100%;height:120px;border:1px dashed var(--border);border-radius:4px;margin-bottom:14px;overflow:hidden;background:#f9f9f9;display:flex;align-items:center;justify-content:center;color:#999;font-size:13px;}
.img-preview-wrap img{width:100%;height:100%;object-fit:cover;display:none;}

.btn-blue{background:#e8f0ff;color:var(--blue);border:1px solid #c0d0ff;padding:5px 12px;font-size:11px;cursor:pointer;font-weight:700;border-radius:3px;}
.btn-danger{background:#fff0f0;color:var(--red);border:1px solid #ffd0d0;padding:5px 12px;font-size:11px;cursor:pointer;font-weight:700;border-radius:3px;}
.btn-blue:hover{background:var(--blue);color:#fff;}
.btn-danger:hover{background:var(--red);color:#fff;}
</style>
</head>
<body>
<%@ include file="../../common/shopAdminHeader.jsp"%>
<div class="main">
  <div class="topbar"><div class="topbar-title">UI / 배너 관리</div></div>
  <div class="content">

    <div class="page-hdr" style="display:flex;justify-content:space-between;margin-bottom:20px;">
      <div>
        <h2 style="font-size:24px;font-weight:900;">메인 배너 관리</h2>
        <p style="color:var(--gray4);font-size:13px;">메인 슬라이드 배너의 이미지와 연결 상품을 관리합니다.</p>
      </div>
      <button class="btn btn-black" onclick="openRegModal()"
        style="padding:10px 20px;cursor:pointer;background:var(--black);color:#fff;border:none;font-weight:700;">
        ＋ 배너 등록
      </button>
    </div>

    <div class="tbl-wrap">
      <table style="width:100%;border-collapse:collapse;background:#fff;border:1px solid var(--border);">
        <thead style="background:#f9f9f9;">
          <tr>
            <th style="padding:12px;border-bottom:1px solid var(--border);width:60px;">순서</th>
            <th style="padding:12px;border-bottom:1px solid var(--border);width:220px;">이미지</th>
            <th style="padding:12px;border-bottom:1px solid var(--border);">배너 제목</th>
            <th style="padding:12px;border-bottom:1px solid var(--border);">연결 상품</th>
            <th style="padding:12px;border-bottom:1px solid var(--border);width:90px;">상태</th>
            <th style="padding:12px;border-bottom:1px solid var(--border);width:130px;">관리</th>
          </tr>
        </thead>
        <tbody>
          <c:forEach var="b" items="${bannerList}">
            <tr style="text-align:center;border-bottom:1px solid var(--border);">
              <td style="font-weight:700;color:#555">${b.banner_sort_no}</td>
              <td style="padding:10px;">
                <div class="banner-preview-wrap" style="margin:0 auto;">
                  <img src="${pageContext.request.contextPath}/upload/${b.banner_img_url}"
                       class="banner-preview"
                       onerror="this.parentNode.innerHTML='<span style=color:#ccc;font-size:12px>이미지 없음</span>'">
                </div>
              </td>
              <td style="font-weight:700;text-align:left;padding-left:16px;">${b.banner_title}</td>
              <td style="font-size:12px;color:#666;">[No.${b.prod_num}] ${b.prod_name}</td>
              <td>
                <c:choose>
                  <c:when test="${b.banner_use_yn == 'Y'}"><span class="badge b-normal">● 노출중</span></c:when>
                  <c:otherwise><span class="badge b-silver">● 숨김</span></c:otherwise>
                </c:choose>
              </td>
              <td>
                <div style="display:flex;gap:6px;justify-content:center;">
                  <button type="button" class="btn-blue"
                    onclick="openModModal(${b.banner_num},'${b.banner_title}',${b.prod_num},${b.banner_sort_no},'${b.banner_use_yn}','${b.banner_img_url}')">
                    ✏️ 수정
                  </button>
                  <button type="button" class="btn-danger"
                    onclick="if(confirm('정말 삭제하시겠습니까?')) location.href='${pageContext.request.contextPath}/shop/banner/bannerDelete.do?banner_num=${b.banner_num}'">
                    🗑️ 삭제
                  </button>
                </div>
              </td>
            </tr>
          </c:forEach>
          <c:if test="${empty bannerList}">
            <tr><td colspan="6" style="padding:40px;color:#999;text-align:center;">📭 등록된 배너가 없습니다.</td></tr>
          </c:if>
        </tbody>
      </table>
    </div>

  </div>
</div>

<!-- 배너 등록/수정 모달 -->
<div class="modal-overlay" id="modal-reg">
  <div class="modal-box">
    <div class="modal-hdr">
      <span class="modal-title" style="font-weight:700;font-size:15px;">배너 등록</span>
      <button onclick="document.getElementById('modal-reg').classList.remove('open')"
        style="background:none;border:none;color:#888;cursor:pointer;font-size:20px;">✕</button>
    </div>
    <form action="${pageContext.request.contextPath}/shop/banner/bannerInsert.do"
          method="post" enctype="multipart/form-data" style="padding:22px;">

      <!-- 이미지 미리보기 -->
      <div class="img-preview-wrap" id="imgPreviewWrap">
        <img id="imgPreview" src="" alt="">
        <span id="imgPreviewText">이미지를 선택하면 미리보기가 표시됩니다</span>
      </div>

      <label class="f-label">배너 제목 *</label>
      <input type="text" name="banner_title" class="f-input" placeholder="예) 뉴발란스 슬리퍼 신상 출시" required>

      <label class="f-label">연결 상품 번호 (PROD_NUM) *</label>
      <input type="number" name="prod_num" class="f-input" placeholder="상품 번호 입력" required>

      <div style="display:grid;grid-template-columns:1fr 1fr;gap:12px;">
        <div>
          <label class="f-label">노출 순서</label>
          <input type="number" name="banner_sort_no" class="f-input" value="1" min="1">
        </div>
        <div>
          <label class="f-label">노출 여부</label>
          <select name="banner_use_yn" class="f-input">
            <option value="Y">Y (노출)</option>
            <option value="N">N (숨김)</option>
          </select>
        </div>
      </div>

      <label class="f-label">이미지 파일</label>
      <input type="file" name="uploadFile" class="f-input" accept="image/*"
             onchange="previewImg(this)" required>

      <button type="submit"
        style="width:100%;padding:13px;margin-top:6px;cursor:pointer;background:var(--black);color:#fff;border:none;font-weight:700;font-size:14px;font-family:'Noto Sans KR',sans-serif;">
        💾 저장하기
      </button>
    </form>
  </div>
</div>

<script>
function previewImg(input) {
    var preview = document.getElementById('imgPreview');
    var text    = document.getElementById('imgPreviewText');
    if (input.files && input.files[0]) {
        var reader = new FileReader();
        reader.onload = function(e) {
            preview.src = e.target.result;
            preview.style.display = 'block';
            text.style.display = 'none';
        };
        reader.readAsDataURL(input.files[0]);
    }
}

function openModModal(num, title, prodNum, sortNo, useYn, imgUrl) {
    var form = document.querySelector('#modal-reg form');
    form.action = '${pageContext.request.contextPath}/shop/banner/bannerUpdate.do';

    var numInput = form.querySelector('input[name="banner_num"]');
    if (!numInput) {
        numInput = document.createElement('input');
        numInput.type = 'hidden';
        numInput.name = 'banner_num';
        form.appendChild(numInput);
    }
    numInput.value = num;

    form.querySelector('input[name="banner_title"]').value   = title;
    form.querySelector('input[name="prod_num"]').value       = prodNum;
    form.querySelector('input[name="banner_sort_no"]').value = sortNo;
    form.querySelector('select[name="banner_use_yn"]').value = useYn;
    form.querySelector('input[type="file"]').required = false;

    // 기존 이미지 미리보기
    var preview = document.getElementById('imgPreview');
    var text    = document.getElementById('imgPreviewText');
    if (imgUrl) {
        preview.src = '${pageContext.request.contextPath}/upload/' + imgUrl;
        preview.style.display = 'block';
        text.style.display = 'none';
    } else {
        preview.style.display = 'none';
        text.style.display = 'block';
    }

    document.querySelector('.modal-title').innerText = '배너 수정';
    document.getElementById('modal-reg').classList.add('open');
}

function openRegModal() {
    var form = document.querySelector('#modal-reg form');
    form.reset();
    form.action = '${pageContext.request.contextPath}/shop/banner/bannerInsert.do';
    form.querySelector('input[type="file"]').required = true;

    var numInput = form.querySelector('input[name="banner_num"]');
    if (numInput) numInput.remove();

    document.getElementById('imgPreview').style.display = 'none';
    document.getElementById('imgPreviewText').style.display = 'block';
    document.querySelector('.modal-title').innerText = '신규 배너 등록';
    document.getElementById('modal-reg').classList.add('open');
}

// 모달 바깥 클릭 시 닫기
document.getElementById('modal-reg').addEventListener('click', function(e) {
    if (e.target === this) this.classList.remove('open');
});
</script>
</body>
</html>
