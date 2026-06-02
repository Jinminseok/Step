<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>반품/교환 관리 (관리자)</title>
<link href="https://fonts.googleapis.com/css2?family=Pretendard:wght@300;400;500;600;700&family=Space+Grotesk:wght@600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
<style>
*, *::before, *::after {
    box-sizing: border-box;
}

/* --- 기본 레이아웃 --- */
body {
    background-color: #f8f9fa; 
    margin: 0;
    font-family: 'Pretendard', sans-serif;
    color: #333;
    overflow-y: scroll;
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
    max-width: none;
    margin: 0 auto;
}

.tbl-wrap { 
    background: #fff; 
    border: 1px solid #e2e8f0; 
    border-radius: 8px; 
    overflow: hidden; 
    box-shadow: 0 1px 2px rgba(0,0,0,0.05); 
    overflow-x: auto; 
}
table { width: 100%; border-collapse: collapse; }
th { 
    padding: 14px 16px; 
    font-size: 13px; 
    font-weight: 600; 
    color: #475569; 
    border-bottom: 1px solid #e2e8f0; 
    background: #f8fafc; 
    text-align: center; 
    white-space: nowrap; 
}
td { 
    padding: 14px 16px; 
    border-bottom: 1px solid #f1f5f9; 
    font-size: 14px; 
    color: #334155; 
    vertical-align: middle; 
    text-align: center; 
    white-space: nowrap; 
}

/*  PAGINATION  */
.pagination-wrap {display:flex;align-items:center;justify-content:space-between;padding:16px 20px;border-top:1px solid #e2e8f0;background:#fff;}
.page-info {font-size:13px;color:#64748b;}
.page-info strong {color:#0f172a;}
.page-btns {display:flex;gap:4px;}
.pg-btn {width:32px;height:32px;border:1px solid #e2e8f0;border-radius:6px;display:flex;align-items:center;justify-content:center;cursor:pointer;font-size:13px;font-weight:600;color:#64748b;background:#fff;transition:all .2s;}
.pg-btn:hover {border-color:#3b82f6;color:#3b82f6;}
.pg-btn.on {background:#3b82f6;color:#fff;border-color:#3b82f6;}
.pg-btn.disabled {opacity:0.4;cursor:not-allowed;pointer-events:none;}

/* PAGE HEADER */
.page-hdr { display: flex; align-items: center; justify-content: space-between; margin-bottom: 24px; }
.page-hdr-title { font-size: 24px; font-weight: bold; margin-bottom: 5px; color: #111827; }
.page-hdr-sub { font-size: 14px; color: #666; }

/* STATS ROW  */
.stats-row { display: grid; grid-template-columns: repeat(5, 1fr); gap: 20px; margin-bottom: 30px; }
.stat-card { background: #fff; padding: 20px 24px; border: 1px solid #e9ecef; border-radius: 12px; box-shadow: 0 2px 4px rgba(0,0,0,0.02); }
.stat-label { font-size: 12px; font-weight: 600; color: #868e96; margin-bottom: 8px; }
.stat-val { font-family: 'Space Grotesk', sans-serif; font-size: 28px; font-weight: 700; color: #212529; }
.stat-change { font-size: 12px; margin-top: 8px; color: #adb5bd; }

/* ── 툴바 및 필터 검색창 ── */
.toolbar { display: flex; align-items: center; gap: 12px; margin-bottom: 16px; flex-wrap: wrap; }
.search-wrap { position: relative; width: 320px; flex-shrink: 0; }
.search-wrap input {
    width: 100%;
    height: 40px; 
    padding: 0 12px 0 38px;
    border: 1px solid #e2e8f0;
    border-radius: 6px;
    background: #fff;
    font-size: 13px;
    outline: none;
    color: #333;
    transition: all 0.2s ease;
}
.search-wrap input:focus { border-color: #3b82f6; box-shadow: 0 0 0 3px rgba(59,130,246,0.1); }
.search-wrap input::placeholder { color: #9ca3af; }
.search-ico { position: absolute; left: 14px; top: 50%; transform: translateY(-50%); color: #9ca3af; font-size: 14px; }

.sel {
    height: 40px; 
    padding: 0 30px 0 14px;
    border: 1px solid #e2e8f0;
    border-radius: 6px;
    background: #fff;
    font-size: 13px;
    font-family: inherit;
    outline: none;
    color: #475569;
    cursor: pointer;
    flex-shrink: 0;
}

/* BUTTONS */
.btn {
    height: 40px; 
    padding: 0 18px;
    border: none;
    border-radius: 6px;
    cursor: pointer;
    font-size: 13px;
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
.btn-black:hover { background: #374151; }
.btn-outline { background: #fff; color: #475569; border: 1px solid #e2e8f0; }
.btn-outline:hover { border-color: #111827; color: #111827; }
.btn-danger { background: #fef2f2; color: #ef4444; border: 1px solid #fecaca; }
.btn-danger:hover { background: #ef4444; color: #fff; }

.btn-blue { background: #f0f4ff; color: #1a73e8; border: 1px solid #cce0ff; }
.btn-blue:hover { background: #1a73e8; color: #fff; border-color: #1a73e8; }
.btn-xs { height: 28px; padding: 0 10px; font-size: 11px; }

/* STATE BADGES */
.badge { display: inline-flex; align-items: center; padding: 4px 10px; border-radius: 12px; font-size: 11px; font-weight: 600; }
.b-vip { background: #fef3c7; color: #92400e; }      
.b-gold { background: #fff7ed; color: #c2410c; }     
.b-silver { background: #f1f5f9; color: #475569; }   
.b-normal { background: #dcfce7; color: #059669; }   

/* ── MODAL OVERLAY & BOX ── */
.modal-overlay { display: none; position: fixed; inset: 0; background: rgba(0,0,0,.5); z-index: 3000; align-items: center; justify-content: center; }
.modal-overlay.open { display: flex; }
.modal-box { background: #fff; width: 520px; border-radius: 12px; max-height: 90vh; display: flex; flex-direction: column; box-shadow: 0 10px 25px rgba(0,0,0,0.2); overflow: hidden; }
.modal-hdr { display: flex; align-items: center; justify-content: space-between; padding: 20px 24px; border-bottom: 1px solid #e2e8f0; background: #f8fafc; }
.modal-title { font-size: 18px; font-weight: 700; color: #0f172a; }
.modal-close { background: none; border: none; color: #94a3b8; cursor: pointer; font-size: 22px; padding: 0; transition: color 0.2s; }
.modal-close:hover { color: #ef4444; }
.modal-body { padding: 24px; overflow-y: auto; flex: 1; }
.modal-footer { padding: 16px 24px; border-top: 1px solid #e2e8f0; display: flex; gap: 8px; justify-content: flex-end; background: #f8fafc; }

/* FORM & DETAILED BOX */
.form-group { display: flex; flex-direction: column; gap: 8px; margin-bottom: 16px; }
.f-label { font-size: 13px; font-weight: 600; color: #334155; }
.f-input { height: 40px; padding: 0 12px; border: 1px solid #e2e8f0; border-radius: 6px; background: #fff; font-size: 14px; outline: none; color: #0f172a; width: 100%; transition: border 0.2s; }
.f-input:focus { border-color: #3b82f6; }
.f-input[readonly] { background: #f8fafc; color: #64748b; cursor: default; }
.f-row { display: grid; grid-template-columns: 1fr 1fr; gap: 12px; }
.info-section { background: #f8fafc; border: 1px solid #e2e8f0; padding: 16px; margin-bottom: 20px; border-radius: 8px; }
.info-section-title { font-size: 13px; font-weight: 700; color: #0f172a; margin-bottom: 12px; border-bottom: 2px solid #0f172a; padding-bottom: 4px; }

/* TOAST */
.toast { position: fixed; bottom: 30px; left: 50%; transform: translateX(-50%) translateY(20px); background: #111827; color: #fff; padding: 12px 24px; border-radius: 8px; font-size: 14px; font-weight: 500; opacity: 0; transition: all .3s; z-index: 9999; pointer-events: none; box-shadow: 0 4px 12px rgba(0,0,0,0.15); }
.toast.show { opacity: 1; transform: translateX(-50%) translateY(0); }
</style>
</head>
<body>

<%@ include file="../../common/shopAdminHeader.jsp"%>

<div class="main">
  <c:set var="pageTitle" value="반품/교환 관리" scope="request" />
  <jsp:include page="/WEB-INF/views/common/sub_title.jsp" />

  <div class="content">
  <div class="stats-row">
      <div class="stat-card">
        <div class="stat-label">📥 신규 신청 대기</div>
        <div class="stat-val" style="color: #ef4444;" id="stat-pending">${pendingCount != null ? pendingCount : 0}건</div>
        <div class="stat-change">빠른 확인 필요</div>
      </div>
      <div class="stat-card">
        <div class="stat-label">🚚 수거/교환 진행중</div>
        <div class="stat-val" style="color: #3b82f6;">${processingCount != null ? processingCount : 0}건</div>
        <div class="stat-change">택배사 연동 상태</div>
      </div>
      <div class="stat-card">
        <div class="stat-label">✅ 처리 완료</div>
        <div class="stat-val" style="color: #10b981;">${completedCount != null ? completedCount : 0}건</div>
        <div class="stat-change">당월 누적 완료건</div>
      </div>
      <div class="stat-card">
        <div class="stat-label">🚫 신청 반려</div>
        <div class="stat-val" style="color: #64748b;">${rejectedCount != null ? rejectedCount : 0}건</div>
        <div class="stat-change">귀책 사유 미달 등</div>
      </div>
      <div class="stat-card">
        <div class="stat-label">📊 총 신청 건수</div>
        <div class="stat-val">${totalCount != null ? totalCount : 0}건</div>
        <div class="stat-change">전체 이력 누적</div>
      </div>
    </div>

    <form id="searchForm" action="${pageContext.request.contextPath}/shop/return/returnForm.do" method="get" class="toolbar">
      
      <div style="display: inline-flex; align-items: center; gap: 6px; background: #fff; padding: 0 8px; border: 1px solid #e2e8f0; border-radius: 6px; height: 40px;">
        <input type="date" name="startDate" value="${param.startDate}" style="border:none; outline:none; font-size:13px; color:#475569; font-family:inherit;">
        <span style="color: #cbd5e1; font-size:12px;">~</span>
        <input type="date" name="endDate" value="${param.endDate}" style="border:none; outline:none; font-size:13px; color:#475569; font-family:inherit;">
      </div>

      <select class="sel" name="sTp">
        <option value="ALL" ${param.sTp == 'ALL' ? 'selected' : ''}>전체 유형 (반품/교환)</option>
        <option value="1" ${param.sTp == '1' ? 'selected' : ''}>📤 반품 신청</option>
        <option value="2" ${param.sTp == '2' ? 'selected' : ''}>🔄 교환 신청</option>
      </select>

      <select class="sel" name="sStatus">
        <option value="ALL" ${param.sStatus == 'ALL' ? 'selected' : ''}>전체 처리상태</option>
        <option value="1" ${param.sStatus == '1' ? 'selected' : ''}>⏳ 신청대기</option>
        <option value="2" ${param.sStatus == '2' ? 'selected' : ''}>🚚 수거진행</option>
        <option value="3" ${param.sStatus == '3' ? 'selected' : ''}>✅ 처리완료</option>
        <option value="4" ${param.sStatus == '4' ? 'selected' : ''}>🚫 신청반려</option>
      </select>

      <div class="search-wrap">
        <span class="search-ico"><i class="fa fa-search"></i></span>
        <select class="sel" name="sKeywordType" style="position: absolute; left: 1px; top: 1px; height: 38px; border: none; border-right: 1px solid #e2e8f0; border-radius: 5px 0 0 5px; background: #fafafa; padding: 0 20px 0 10px; font-size: 12px;">
          <option value="orderNum" ${param.sKeywordType == 'orderNum' ? 'selected' : ''}>주문번호</option>
          <option value="userNum" ${param.sKeywordType == 'userNum' ? 'selected' : ''}>회원번호</option>
          <option value="reason" ${param.sKeywordType == 'reason' ? 'selected' : ''}>사유검색</option>
        </select>
        <input type="text" name="sKeyword" value="${param.sKeyword}" placeholder="검색어를 입력하세요" style="padding-left: 110px;">
      </div>

      <button type="submit" class="btn btn-black"><i class="fa fa-filter"></i> 조회</button>
      <button type="button" class="btn btn-outline" onclick="location.href='${pageContext.request.contextPath}/shop/return/returnForm.do'"><i class="fa fa-undo"></i> 초기화</button>
    </form>

    <div class="tbl-wrap">
      <table>
        <thead>
          <tr>
            <th style="width: 90px;">신청번호</th>
            <th style="width: 100px;">주문번호</th>
            <th style="width: 90px;">회원번호</th>
            <th style="width: 100px;">신청유형</th>
            <th>신청상품 및 옵션</th>
            <th style="width: 160px;">클레임 사유</th>
            <th style="width: 130px;">신청일시</th>
            <th style="width: 110px;">처리상태</th>
            <th style="width: 90px;">상세관리</th>
          </tr>
        </thead>
        <tbody id="returnTbody">
          <c:if test="${empty returnList}">
            <tr>
              <td colspan="9" style="padding: 60px; color: #94a3b8; font-size: 14px;">
                <i class="fa fa-box-open" style="font-size: 24px; margin-bottom: 10px; display: block; color: #cbd5e1;"></i>
                현재 접수된 반품 또는 교환 신청 내역이 없습니다.
              </td>
            </tr>
          </c:if>
          
          <c:forEach var="item" items="${returnList}">
            <tr class="return-row">
              <td style="font-weight: 600; color: #64748b;">RET-${item.ret_num}</td>
              <td style="font-family: 'Space Grotesk', sans-serif; font-weight: 700; color: #1a73e8;">#${item.order_num}</td>
              <td style="font-size: 13px; color: #64748b;">${item.user_num}</td>
              <td>
                <c:choose>
                  <c:when test="${item.tp == 1}"><span class="badge b-silver" style="color: #ef4444; background: #fef2f2; border: 1px solid #fecaca;">📤 반품</span></c:when>
                  <c:when test="${item.tp == 2}"><span class="badge b-silver" style="color: #3b82f6; background: #eff6ff; border: 1px solid #bfdbfe;">🔄 교환</span></c:when>
                </c:choose>
              </td>
              <td style="text-align: center; font-weight: 500;">
                ${item.prod_name}                
              </td>
              <td style="font-size: 13px; color: #475569; font-weight: 500;">${item.reason}</td>
              <td style="font-size: 12px; color: #64748b;">${item.ret_created_at}</td>
              <td>
                <c:choose>
                  <c:when test="${item.ret_status == 1}">
                    <span class="badge b-vip">⏳ 신청대기</span>
                  </c:when>
                  <c:when test="${item.ret_status == 2}">
                    <span class="badge b-gold">🚚 수거진행</span>
                  </c:when>
                  <c:when test="${item.ret_status == 3 || item.ret_status == 4 || item.ret_status == 5}">
                    <span class="badge b-normal">✅ 처리완료</span>
                  </c:when>
                  <c:when test="${item.ret_status == 6}">
                    <span class="badge b-silver">🚫 신청반려</span>
                  </c:when>
                </c:choose>
              </td>
              <td>
                <button type="button" class="btn btn-outline btn-xs" onclick="openReturnModal('${item.ret_num}')">
                  <i class="fa fa-cog"></i> 처리
                </button>
              </td>
            </tr>
          </c:forEach>
        </tbody>
      </table>

      <%-- PAGINATION HTML --%>
      <div class="pagination-wrap" id="returnPagination" style="display:none;">
        <div class="page-info" id="returnPageInfo">총 <strong>0</strong>건</div>
        <div class="page-btns" id="returnPageBtns"></div>
      </div>

    </div>

  </div>
 </div>
 
 <div class="modal-overlay" id="returnModal">
  <div class="modal-box">
    <div class="modal-hdr">
      <div class="modal-title"><i class="fa fa-clipboard-check"></i> 클레임 상세 심사 (<span id="mdlRetNum" style="color:#1a73e8;"></span>)</div>
      <button class="modal-close" onclick="closeReturnModal()">&times;</button>
    </div>
    
    <form id="returnProcessForm" action="${pageContext.request.contextPath}/shop/return/processReturn.do" method="post" 
          style="display: flex; flex-direction: column; flex: 1; overflow: hidden; margin: 0;">
          
      <input type="hidden" name="ret_num" id="formRetNum">
      <input type="hidden" name="order_num" id="formOrderNum">
      
      <div class="modal-body">
        <div class="info-section">
          <div class="info-section-title">👤 고객 요약 정보</div>
          <div class="f-row">
            <div class="form-group">
              <label class="f-label">주문 번호</label>
              <input type="text" id="mdlOrderNum" class="f-input" readonly>
            </div>
            <div class="form-group">
              <label class="f-label">회원 번호</label>
              <input type="text" id="mdlUserNum" class="f-input" readonly>
            </div>
          </div>
          <div class="form-group">
            <label class="f-label">신청 상품</label>
            <input type="text" id="mdlProdName" class="f-input" readonly>
          </div>
          <div class="form-group" style="margin-bottom:0;">
            <label class="f-label">고객 선택 사유</label>
            <input type="text" id="mdlReason" class="f-input" readonly style="color: #ef4444; font-weight:600;">
          </div>
        </div>

        <div class="form-group">
          <label class="f-label">고객 작성 상세 내용</label>
          <input type="text" id="mdlRetNote" class="f-input" readonly style="height: auto; padding: 10px 12px;">
        </div>

        <hr style="border:0; border-top:1px dashed #e2e8f0; margin: 20px 0;">

        <div class="info-section" style="background: #fdfdfd; border-color: #cbd5e1;">
          <div class="info-section-title" style="color: #1e293b; border-color: #1e293b;">🛠️ 관리자 심사 및 상태 변경</div>
          
          <div class="form-group">
            <label class="f-label" style="color: #1e293b;">1. 처리 상태 선택</label>
            <select class="sel" name="ret_status" id="mdlRetStatus" style="width: 100%;">
              <option value="1">⏳ 신청대기 (접수 후 확인중)</option>
              <option value="2">🚚 수거진행중 (택배사 지시)</option>
              <option value="3">✅ 처리완료 (환불/교환 출고 확정)</option>
              <option value="4">🚫 신청반려 (클레임 거절)</option>
            </select>
          </div>

          <div class="form-group">
            <label class="f-label" style="color: #1e293b;">2. 수거 제품 상태 검수 (IS_GOOD)</label>
            <select class="sel" name="is_good" id="mdlIsGood" style="width: 100%;">
              <option value="0">검수 전 (대기)</option>
              <option value="1">정상 제품 (재고 복원 및 재판매)</option>
              <option value="2">상품 파손/훼손 (폐기 처리)</option>
            </select>
          </div>

          <div class="form-group" style="margin-bottom:0;">
            <label class="f-label" style="color: #1e293b;">3. 관리자 조치 메모 (RET_NOTE 업데이트)</label>
            <input type="text" name="ret_note_admin" id="mdlAdminNote" class="f-input" placeholder="반려 사유 혹은 환불 완료 내역 등을 기입하세요.">
          </div>
        </div>
      </div>

      <div class="modal-footer" style="flex-shrink: 0;">
        <button type="button" class="btn btn-outline" onclick="closeReturnModal()">취소</button>
        <button type="submit" class="btn btn-black" style="background: #10b981; border-color: #10b981;"><i class="fa fa-check"></i> 처리 완료</button>
      </div>
    </form>
  </div>
</div>

<div class="toast" id="toast"></div>

<script>
function showToast(msg) {
    const t = document.getElementById('toast');
    if(!t) return;
    t.textContent = msg;
    t.classList.add('show');
    setTimeout(() => t.classList.remove('show'), 2800);
}

function openReturnModal(retNum) {
    document.getElementById('mdlRetNum').innerText = "RET-" + retNum;
    document.getElementById('formRetNum').value = retNum;
    
    
    fetch('${pageContext.request.contextPath}/shop/admin_return/returnDetail.do?retNum=' + retNum)
        .then(res => res.text()) // 텍스트로 안전하게 받기
        .then(text => {
            
            console.log("▼ 서버가 보낸 원본 데이터 확인용 콘솔입니다 ▼");
            console.log(text);
            
            
            const data = JSON.parse(text);
            
            if(data.result === 'error') {
                showToast("🚨 데이터를 불러오지 못했습니다: " + data.message);
                return;
            }
            
            document.getElementById('formOrderNum').value = data.order_num;
            document.getElementById('mdlOrderNum').value = "#" + data.order_num;
            document.getElementById('mdlUserNum').value = data.user_num;
            document.getElementById('mdlProdName').value = data.prod_name;
            document.getElementById('mdlReason').value = data.reason;
            document.getElementById('mdlRetNote').value = data.ret_note ? data.ret_note : "고객이 작성한 추가 내용이 없습니다.";
            
            // 관리자 설정 상태 세팅
            document.getElementById('mdlRetStatus').value = data.ret_status;
            document.getElementById('mdlIsGood').value = data.is_good ? data.is_good : "0";
            document.getElementById('mdlAdminNote').value = data.ret_note_admin ? data.ret_note_admin : "";
            
            // 모달 열기
            document.getElementById('returnModal').classList.add('open');
        })
        .catch(err => {
            console.error("🚨 진짜 에러 원인 분석:", err);
            showToast("🚨 서버 통신에 실패했습니다.");
        });
}

function closeReturnModal() {
    document.getElementById('returnModal').classList.remove('open');
}

// 모달 바깥쪽 어두운 영역 클릭 시 닫기 기능 추가
window.onclick = function(event) {
    const modal = document.getElementById('returnModal');
    if (event.target === modal) {
        modal.classList.remove('open');
    }
}

let currentReturnPage = 1;
const returnItemsPerPage = 10; // 한 페이지에 보여줄 개수
let allReturnRows = [];

window.addEventListener('load', function() {
    const tbody = document.getElementById('returnTbody');
    if (tbody) {
        allReturnRows = Array.from(tbody.querySelectorAll('tr.return-row'));
        if (allReturnRows.length > 0) {
            renderReturnTable();
        } else {
            document.getElementById('returnPagination').style.display = 'none';
        }
    }
});

function renderReturnTable() {
    allReturnRows.forEach(r => r.style.display = 'none');
    const start = (currentReturnPage - 1) * returnItemsPerPage;
    const end = start + returnItemsPerPage;
    
    for (let i = start; i < end && i < allReturnRows.length; i++) {
        allReturnRows[i].style.display = '';
    }
    renderReturnPagination();
}

function renderReturnPagination() {
    const totalPages = Math.ceil(allReturnRows.length / returnItemsPerPage);
    const pw = document.getElementById('returnPagination');
    const pi = document.getElementById('returnPageInfo');
    const pb = document.getElementById('returnPageBtns');

    if (!pw || !pb) return;

    if (allReturnRows.length === 0) {
        pw.style.display = 'none';
        return;
    }

    pw.style.display = 'flex';
    const sn = (currentReturnPage - 1) * returnItemsPerPage + 1;
    const en = Math.min(currentReturnPage * returnItemsPerPage, allReturnRows.length);
    
    // JSP 처리 방지를 위해 \${} 이스케이프 사용
    pi.innerHTML = `총 <strong style="color:#0f172a">\${allReturnRows.length}</strong>건 · \${sn}-\${en}`;

    let h = `<div class="pg-btn \${currentReturnPage === 1 ? 'disabled' : ''}" onclick="changeReturnPage(\${currentReturnPage - 1})">‹</div>`;

    // 최대 9개의 버튼만 보여지도록 제한
    let maxVisible = 9;
    let startPage = Math.max(1, currentReturnPage - Math.floor(maxVisible / 2));
    let endPage = Math.min(totalPages, startPage + maxVisible - 1);

    if (endPage - startPage + 1 < maxVisible) {
        startPage = Math.max(1, endPage - maxVisible + 1);
    }

    for (let i = startPage; i <= endPage; i++) {
        h += `<div class="pg-btn \${i === currentReturnPage ? 'on' : ''}" onclick="changeReturnPage(\${i})">\${i}</div>`;
    }

    h += `<div class="pg-btn \${currentReturnPage === totalPages ? 'disabled' : ''}" onclick="changeReturnPage(\${currentReturnPage + 1})">›</div>`;
    pb.innerHTML = h;
}

function changeReturnPage(p) {
    const totalPages = Math.ceil(allReturnRows.length / returnItemsPerPage);
    if (p < 1 || p > totalPages) return;
    currentReturnPage = p;
    renderReturnTable();
}
</script>
</body>
</html>