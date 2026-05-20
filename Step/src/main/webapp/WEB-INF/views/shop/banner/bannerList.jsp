<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>ShoeMall - 배너 관리</title>
<link href="https://fonts.googleapis.com/css2?family=Pretendard:wght@300;400;500;600;700&family=Space+Grotesk:wght@600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
<style>
/* --- 🚨 핵심 디테일 수정: 모든 요소의 테두리/여백을 너비에 포함 --- */
*, *::before, *::after {
    box-sizing: border-box;
}

/* --- 기본 레이아웃 --- */
body {
    background-color: #f8f9fa; 
    margin: 0;
    font-family: 'Pretendard', sans-serif;
    color: #333;
    overflow-y: scroll; /* 🚨 핵심 디테일: 페이지 전환 시 스크롤바 밀림 방지 */
}

/* 👇 사이드바 너비만큼 본문을 완벽히 밀어줍니다 */
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
    max-width: none;
    margin: 0 auto;
}

/* PAGE HEADER */
.page-hdr { display: flex; align-items: center; justify-content: space-between; margin-bottom: 24px; }
.page-hdr-title { font-size: 24px; font-weight: bold; margin-bottom: 5px; color: #111827; }
.page-hdr-sub { font-size: 14px; color: #666; }

/* BUTTONS */
.btn {
    height: 40px; 
    padding: 0 18px;
    border: none;
    border-radius: 6px;
    cursor: pointer;
    font-size: 13.5px;
    font-weight: 600;
    font-family: inherit;
    transition: all .2s;
    display: inline-flex;
    align-items: center;
    justify-content: center;
    gap: 6px;
    white-space: nowrap;
}
.btn-black { background: #111827; color: #fff; }
.btn-black:hover { background: #374151; box-shadow: 0 2px 4px rgba(17,24,39,0.1); }
.btn-outline { background: #fff; color: #475569; border: 1px solid #e2e8f0; }
.btn-outline:hover { border-color: #111827; color: #111827; }

.btn-xs { height: 30px; padding: 0 12px; font-size: 11.5px; }

/* TABLE LIST */
.tbl-wrap { background: #fff; border: 1px solid #e2e8f0; border-radius: 12px; overflow: hidden; box-shadow: 0 2px 6px rgba(0,0,0,0.02); }
table { width: 100%; border-collapse: collapse; }
th { padding: 14px 16px; font-size: 13px; font-weight: 600; color: #475569; border-bottom: 1px solid #e2e8f0; background: #f8fafc; text-align: center; }
td { padding: 14px 16px; border-bottom: 1px solid #f1f5f9; font-size: 14px; color: #334155; vertical-align: middle; text-align: center; }
tr:last-child td { border-bottom: none; }
tr:hover td { background: #f8fafc; }

/* 🌟 PAGINATION (새로 추가된 스타일) 🌟 */
.pagination-wrap {display:flex;align-items:center;justify-content:space-between;padding:16px 20px;border-top:1px solid #e2e8f0;background:#fff;}
.page-info {font-size:13px;color:#64748b;}
.page-info strong {color:#0f172a;}
.page-btns {display:flex;gap:4px;}
.pg-btn {width:32px;height:32px;border:1px solid #e2e8f0;border-radius:6px;display:flex;align-items:center;justify-content:center;cursor:pointer;font-size:13px;font-weight:600;color:#64748b;background:#fff;transition:all .2s;}
.pg-btn:hover {border-color:#3b82f6;color:#3b82f6;}
.pg-btn.on {background:#3b82f6;color:#fff;border-color:#3b82f6;}
.pg-btn.disabled {opacity:0.4;cursor:not-allowed;pointer-events:none;}

/* 배너 미리보기 - 리스트형 와이드 비율 */
.banner-preview-wrap { 
    width: 240px; 
    height: 80px; 
    overflow: hidden; 
    border: 1px solid #e2e8f0; 
    border-radius: 8px; 
    background: #f1f5f9; 
    display: flex; 
    align-items: center; 
    justify-content: center; 
    margin: 0 auto;
}
.banner-preview { width: 100%; height: 100%; object-fit: cover; display: block; }

/* STATE BADGES */
.badge { display: inline-flex; align-items: center; padding: 4px 10px; border-radius: 12px; font-size: 11.5px; font-weight: 600; }
.b-normal { background: #dcfce7; color: #059669; }   /* 노출중 */
.b-silver { background: #f1f5f9; color: #64748b; }   /* 숨김 */

/* ── MODAL OVERLAY & BOX (통일감 구현) ── */
.modal-overlay { display: none; position: fixed; inset: 0; background: rgba(0,0,0,.5); z-index: 3000; align-items: center; justify-content: center; }
.modal-overlay.open { display: flex; }
.modal-box { background: #fff; width: 560px; border-radius: 12px; max-height: 90vh; display: flex; flex-direction: column; box-shadow: 0 10px 25px rgba(0,0,0,0.2); overflow: hidden; }
.modal-hdr { display: flex; align-items: center; justify-content: space-between; padding: 20px 24px; border-bottom: 1px solid #e2e8f0; background: #f8fafc; }
.modal-title { font-size: 18px; font-weight: 700; color: #0f172a; }
.modal-close { background: none; border: none; color: #94a3b8; cursor: pointer; font-size: 22px; padding: 0; transition: color 0.2s; }
.modal-close:hover { color: #ef4444; }

/* FORM & DETAILED BOX */
.modal-body { padding: 24px; overflow-y: auto; flex: 1; }
.form-group { display: flex; flex-direction: column; gap: 8px; margin-bottom: 20px; }
.f-label { font-size: 13px; font-weight: 600; color: #334155; }
.f-input { 
    height: 42px; 
    padding: 0 14px; 
    border: 1px solid #e2e8f0; 
    border-radius: 6px; 
    background: #fff; 
    font-size: 14px; 
    outline: none; 
    color: #0f172a; 
    width: 100%; 
    transition: border 0.2s; 
    font-family: 'Pretendard', sans-serif;
}
.f-input:focus { border-color: #3b82f6; box-shadow: 0 0 0 3px rgba(59,130,246,0.1); }
.f-row { display: grid; grid-template-columns: 1fr 1fr; gap: 16px; }

/* 🚨 이미지 파일 업로드 디자인 */
.f-file {
    padding: 8px 10px;
    border: 1px dashed #cbd5e1;
    border-radius: 6px;
    background: #f8fafc;
    cursor: pointer;
    font-size: 13px;
    color: #475569;
}
.f-file:hover { border-color: #3b82f6; background: #eff6ff; }

/* 모달 내 이미지 썸네일 미리보기 */
.img-preview-wrap { 
    width: 100%; 
    height: 140px; 
    border: 2px dashed #cbd5e1; 
    border-radius: 8px; 
    margin-bottom: 24px; 
    overflow: hidden; 
    background: #f8fafc; 
    display: flex; 
    align-items: center; 
    justify-content: center; 
    color: #94a3b8; 
    font-size: 13.5px;
    font-weight: 500;
    transition: all 0.2s;
}
.img-preview-wrap img { width: 100%; height: 100%; object-fit: cover; display: none; }
.img-preview-wrap:hover { border-color: #94a3b8; }

.modal-footer { padding: 16px 24px; border-top: 1px solid #e2e8f0; display: flex; gap: 8px; justify-content: flex-end; background: #f8fafc; }
</style>
</head>
<body>

<%@ include file="../../common/shopAdminHeader.jsp"%>

<div class="main">
  <c:set var="pageTitle" value="UI / 배너 관리" scope="request" />
  <jsp:include page="/WEB-INF/views/common/sub_title.jsp" />

  <div class="content">

    <div class="page-hdr">
      <div>
        <div class="page-hdr-title">메인 배너 관리</div>
        <div class="page-hdr-sub">쇼핑몰 메인 페이지 최상단 슬라이드 배너 이미지와 연결 상품을 관리합니다.</div>
      </div>
      <button type="button" class="btn btn-black" onclick="openRegModal()">
        <i class="fa-solid fa-plus"></i> 배너 등록
      </button>
    </div>

    <div class="tbl-wrap">
      <table>
        <thead>
          <tr>
            <th style="width:80px;">노출 순서</th>
            <th style="width:280px;">배너 이미지</th>
            <th style="text-align:left; padding-left:20px;">배너 제목</th>
            <th style="width:240px; text-align:left;">연결 상품 번호</th>
            <th style="width:120px;">상태</th>
            <th style="width:160px;">관리</th>
          </tr>
        </thead>
        <%-- 🌟 id="bannerTbody" 추가 🌟 --%>
        <tbody id="bannerTbody">
          <c:forEach var="b" items="${bannerList}">
            <%-- 🌟 class="banner-row" 추가 🌟 --%>
            <tr class="banner-row">
              <td style="font-weight:700; color:#94a3b8; font-family:'Space Grotesk'; font-size: 16px;">${b.banner_sort_no}</td>
              <td>
                <div class="banner-preview-wrap">
                  <img src="${pageContext.request.contextPath}/upload/${b.banner_img_url}"
                       class="banner-preview"
                       onerror="this.parentNode.innerHTML='<span style=\'color:#cbd5e1;font-size:13px;font-weight:500;\'>이미지 없음</span>'">
                </div>
              </td>
              <td style="font-weight:600; text-align:left; padding-left:20px; color:#0f172a; font-size:15px;">${b.banner_title}</td>
              <td style="font-size:13px; color:#475569; text-align:left;">
                <span style="display:inline-block; background:#f1f5f9; padding:2px 6px; border-radius:4px; margin-bottom:4px; font-family:'Space Grotesk'; font-weight:600;">No.${b.prod_num}</span><br>
                ${b.prod_name}
              </td>
              <td>
                <c:choose>
                  <c:when test="${b.banner_use_yn == 'Y'}"><span class="badge b-normal">● 노출중</span></c:when>
                  <c:otherwise><span class="badge b-silver">● 숨김</span></c:otherwise>
                </c:choose>
              </td>
              <td>
                <div style="display:flex; gap:6px; justify-content:center;">
                  <button type="button" class="btn btn-outline btn-xs"
                    onclick="openModModal(${b.banner_num},'${b.banner_title}',${b.prod_num},${b.banner_sort_no},'${b.banner_use_yn}','${b.banner_img_url}')">
                    ✏️ 수정
                  </button>
                  <button type="button" class="btn btn-outline btn-xs" style="color:#ef4444; border-color:#fecaca;"
                    onclick="if(confirm('정말 삭제하시겠습니까?')) location.href='${pageContext.request.contextPath}/shop/banner/bannerDelete.do?banner_num=${b.banner_num}'">
                    🗑️ 삭제
                  </button>
                </div>
              </td>
            </tr>
          </c:forEach>
          <c:if test="${empty bannerList}">
            <tr>
                <td colspan="6" style="padding:80px 0; color:#94a3b8; text-align:center;">
                    <i class="fa-regular fa-images" style="font-size:36px; display:block; margin-bottom:12px; color:#e2e8f0;"></i>
                    등록된 메인 배너가 없습니다.
                </td>
            </tr>
          </c:if>
        </tbody>
      </table>

      <%-- 🌟 PAGINATION HTML (새로 추가됨) 🌟 --%>
      <div class="pagination-wrap" id="bannerPagination" style="display:none;">
        <div class="page-info" id="bannerPageInfo">총 <strong>0</strong>건</div>
        <div class="page-btns" id="bannerPageBtns"></div>
      </div>

    </div>

  </div>
</div>

<div class="modal-overlay" id="modal-reg">
  <div class="modal-box">
    <div class="modal-hdr">
      <span class="modal-title">배너 등록</span>
      <button type="button" class="modal-close" onclick="document.getElementById('modal-reg').classList.remove('open')">
          <i class="fa-solid fa-xmark"></i>
      </button>
    </div>
    <form action="${pageContext.request.contextPath}/shop/banner/bannerInsert.do"
          method="post" enctype="multipart/form-data" style="display:flex; flex-direction:column; height:100%;">

      <div class="modal-body">
          <div class="img-preview-wrap" id="imgPreviewWrap">
            <img id="imgPreview" src="" alt="">
            <span id="imgPreviewText"><i class="fa-regular fa-image" style="margin-right:6px;"></i> 이미지를 선택하면 미리보기가 표시됩니다</span>
          </div>
    
          <div class="form-group">
              <label class="f-label">배너 제목 <span style="color:#ef4444">*</span></label>
              <input type="text" name="banner_title" class="f-input" placeholder="예) 26SS 뉴발란스 런닝화 신상 기획전" required>
          </div>
    
          <div class="form-group">
              <label class="f-label">연결 상품 번호 (PROD_NUM) <span style="color:#ef4444">*</span></label>
              <input type="number" name="prod_num" class="f-input" placeholder="연결될 상품의 고유 번호를 입력하세요" required>
          </div>
    
          <div class="f-row">
            <div class="form-group">
              <label class="f-label">노출 순서</label>
              <input type="number" name="banner_sort_no" class="f-input" value="1" min="1">
            </div>
            <div class="form-group">
              <label class="f-label">노출 여부</label>
              <select name="banner_use_yn" class="f-input" style="cursor:pointer; padding:0 12px;">
                <option value="Y">Y (노출)</option>
                <option value="N">N (숨김)</option>
              </select>
            </div>
          </div>
    
          <div class="form-group" style="margin-bottom: 0;">
              <label class="f-label">배너 이미지 파일</label>
              <input type="file" name="uploadFile" class="f-input f-file" accept="image/*" onchange="previewImg(this)" required>
          </div>
      </div>
      
      <div class="modal-footer">
          <button type="button" class="btn btn-outline" onclick="document.getElementById('modal-reg').classList.remove('open')">취소</button>
          <button type="submit" class="btn btn-black"><i class="fa-solid fa-check" style="margin-right:4px;"></i> 저장하기</button>
      </div>
      
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

// 🌟 PAGINATION JAVASCRIPT LOGIC (새로 추가됨) 🌟
let currentBannerPage = 1;
const bannerItemsPerPage = 10; // 한 페이지에 보여줄 개수
let allBannerRows = [];

window.addEventListener('load', function() {
    const tbody = document.getElementById('bannerTbody');
    if (tbody) {
        allBannerRows = Array.from(tbody.querySelectorAll('tr.banner-row'));
        if (allBannerRows.length > 0) {
            renderBannerTable();
        } else {
            document.getElementById('bannerPagination').style.display = 'none';
        }
    }
});

function renderBannerTable() {
    allBannerRows.forEach(r => r.style.display = 'none');
    const start = (currentBannerPage - 1) * bannerItemsPerPage;
    const end = start + bannerItemsPerPage;
    
    for (let i = start; i < end && i < allBannerRows.length; i++) {
        allBannerRows[i].style.display = '';
    }
    renderBannerPagination();
}

function renderBannerPagination() {
    const totalPages = Math.ceil(allBannerRows.length / bannerItemsPerPage);
    const pw = document.getElementById('bannerPagination');
    const pi = document.getElementById('bannerPageInfo');
    const pb = document.getElementById('bannerPageBtns');

    if (!pw || !pb) return;

    if (allBannerRows.length === 0) {
        pw.style.display = 'none';
        return;
    }

    pw.style.display = 'flex';
    const sn = (currentBannerPage - 1) * bannerItemsPerPage + 1;
    const en = Math.min(currentBannerPage * bannerItemsPerPage, allBannerRows.length);
    
    // JSP 처리 방지를 위해 \${} 이스케이프 사용
    pi.innerHTML = `총 <strong style="color:#0f172a">\${allBannerRows.length}</strong>건 · \${sn}-\${en}`;

    let h = `<div class="pg-btn \${currentBannerPage === 1 ? 'disabled' : ''}" onclick="changeBannerPage(\${currentBannerPage - 1})">‹</div>`;

    // 최대 9개의 버튼만 보여지도록 제한
    let maxVisible = 9;
    let startPage = Math.max(1, currentBannerPage - Math.floor(maxVisible / 2));
    let endPage = Math.min(totalPages, startPage + maxVisible - 1);

    if (endPage - startPage + 1 < maxVisible) {
        startPage = Math.max(1, endPage - maxVisible + 1);
    }

    for (let i = startPage; i <= endPage; i++) {
        h += `<div class="pg-btn \${i === currentBannerPage ? 'on' : ''}" onclick="changeBannerPage(\${i})">\${i}</div>`;
    }

    h += `<div class="pg-btn \${currentBannerPage === totalPages ? 'disabled' : ''}" onclick="changeBannerPage(\${currentBannerPage + 1})">›</div>`;
    pb.innerHTML = h;
}

function changeBannerPage(p) {
    const totalPages = Math.ceil(allBannerRows.length / bannerItemsPerPage);
    if (p < 1 || p > totalPages) return;
    currentBannerPage = p;
    renderBannerTable();
}
</script>
</body>
</html>