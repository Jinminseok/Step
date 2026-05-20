<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>반품/교환 관리</title>
<link rel="stylesheet" href="${pageContext.request.contextPath }/css/YH_style.css" type="text/css">
<link href="https://fonts.googleapis.com/css2?family=Pretendard:wght@300;400;500;600;700&family=DM+Mono:wght@400;500&display=swap" rel="stylesheet">
<style>
/* CONTENT */
.content{flex:1;overflow-y:auto;padding:24px}
.content::-webkit-scrollbar{width:5px}
.content::-webkit-scrollbar-thumb{background:var(--gray5);border-radius:3px}

/* ══ TAB BAR ══ */
.tab-bar{display:flex;gap:0;margin-bottom:18px;border-bottom:2px solid var(--gray6)}
.tab-btn{padding:10px 22px;font-size:12.5px;font-weight:700;color:var(--gray4);cursor:pointer;border-bottom:2px solid transparent;margin-bottom:-2px;transition:all .18s;display:flex;align-items:center;gap:7px}
.tab-btn.on{color:var(--blue);border-bottom-color:var(--blue)}
.tab-btn:hover:not(.on){color:var(--gray2)}
.tab-cnt{color:#fff;font-size:9px;font-weight:700;padding:1px 6px;border-radius:10px}

/* ══ ALERT ══ */
.alert{display:flex;align-items:flex-start;gap:10px;padding:12px 16px;border-radius:8px;font-size:12.5px;line-height:1.6;border:1px solid;margin-bottom:16px}
.alert-amber{background:var(--amber-lt);border-color:#FCD34D;color:#78350F}
.alert-red{background:var(--red-lt);border-color:#FECACA;color:#991B1B}
.alert-green{background:var(--green-lt);border-color:#6EE7B7;color:#065F46}
.alert-blue{background:var(--blue-lt);border-color:#93C5FD;color:#1E3A8A}
.alert-ico{flex-shrink:0;font-size:15px;margin-top:1px}

/* ══ KPI ══ */
.kpi-row{display:grid;grid-template-columns:repeat(4,1fr);gap:12px;margin-bottom:18px}
.kpi{background:var(--white);border:1px solid var(--gray6);border-radius:10px;padding:16px 18px;box-shadow:0 1px 3px rgba(15,32,68,.06);position:relative;overflow:hidden}
.kpi::before{content:'';position:absolute;top:0;left:0;right:0;height:3px}
.kpi.red::before{background:var(--red)}.kpi.amber::before{background:var(--amber)}.kpi.blue::before{background:var(--blue)}.kpi.green::before{background:var(--green)}
.kpi-label{font-size:10px;font-weight:700;color:var(--gray3);text-transform:uppercase;letter-spacing:.07em;margin-bottom:8px}
.kpi-val{font-family:'DM Mono',monospace;font-size:26px;font-weight:700;margin-bottom:4px}
.kpi-val.c-red{color:var(--red)}.kpi-val.c-amber{color:var(--amber)}.kpi-val.c-blue{color:var(--blue)}.kpi-val.c-green{color:var(--green)}
.kpi-sub{font-size:11px;color:var(--gray4)}

/* ══ TOOLBAR ══ */
.toolbar{display:flex;align-items:center;gap:8px;margin-bottom:14px;flex-wrap:wrap}
.search-wrap{position:relative;flex:1;min-width:200px;max-width:280px}
.search-wrap input{width:100%;padding:9px 12px 9px 32px;border:1.5px solid var(--gray5);background:var(--white);border-radius:7px;font-size:12.5px;color:var(--gray1);font-family:'Pretendard',sans-serif;outline:none;transition:all .15s}
.search-wrap input:focus{border-color:var(--blue);box-shadow:0 0 0 3px rgba(29,111,228,.08)}
.search-wrap input::placeholder{color:var(--gray4)}
.search-ico{position:absolute;left:10px;top:50%;transform:translateY(-50%);color:var(--gray4);font-size:13px}
.sel{padding:9px 12px;border:1.5px solid var(--gray5);background:var(--white);font-size:12.5px;font-family:'Pretendard',sans-serif;color:var(--gray2);outline:none;border-radius:7px;cursor:pointer;transition:border .15s}
.sel:focus{border-color:var(--blue)}

/* ══ BUTTONS ══ */
.btn{padding:9px 16px;border:none;border-radius:7px;font-size:12.5px;font-weight:700;cursor:pointer;font-family:'Pretendard',sans-serif;transition:all .15s;display:inline-flex;align-items:center;gap:6px}
.btn-blue{background:var(--blue);color:#fff}.btn-blue:hover{background:var(--navy2)}
.btn-green{background:var(--green);color:#fff}.btn-green:hover{background:#059669}
.btn-red{background:var(--red);color:#fff}.btn-red:hover{background:#DC2626}
.btn-outline{background:var(--white);color:var(--gray2);border:1.5px solid var(--gray5)}.btn-outline:hover{border-color:var(--gray3);color:var(--gray1)}
.btn-ghost{background:transparent;color:var(--gray3);border:1.5px solid var(--gray5)}.btn-ghost:hover{color:var(--gray1);border-color:var(--gray3)}
.btn-amber{background:var(--amber);color:#fff}.btn-amber:hover{background:#D97706}
.btn-sm{padding:7px 13px;font-size:12px}
.btn-xs{padding:4px 10px;font-size:11px}

/* ══ TABLE ══ */
.tbl-card{background:var(--white);border:1px solid var(--gray6);border-radius:10px;overflow:hidden;box-shadow:0 1px 3px rgba(15,32,68,.06)}
.tbl-top{display:flex;align-items:center;justify-content:space-between;padding:12px 16px;border-bottom:1px solid var(--gray6);background:var(--bg2);gap:8px;flex-wrap:wrap}
.tbl-top-info{font-size:12px;color:var(--gray3)}.tbl-top-info strong{color:var(--gray1)}
.tbl-wrap{overflow-x:auto}
table{width:100%;border-collapse:collapse}
thead{position:sticky;top:0;z-index:5}
th{padding:10px 14px;font-size:10px;font-weight:700;color:var(--gray3);text-transform:uppercase;letter-spacing:.08em;background:var(--gray7);border-bottom:1px solid var(--gray6);text-align:left;white-space:nowrap}
td{padding:13px 14px;border-bottom:1px solid var(--gray7);font-size:12.5px;color:var(--gray2);vertical-align:middle}
tr:last-child td{border-bottom:none}
.tbl-row{cursor:pointer;transition:background .12s}
.tbl-row:hover td{background:#F5F8FF}
td:first-child{border-left:3px solid transparent;padding-left:11px}
.tbl-row.selected td{background:var(--blue-lt)}.tbl-row.selected td:first-child{border-left-color:var(--blue)}

/* ══ BADGE ══ */
.bdg{display:inline-flex;align-items:center;padding:3px 9px;border-radius:100px;font-size:10.5px;font-weight:700;white-space:nowrap;gap:4px}
.bdg::before{content:'●';font-size:7px}
.bdg-red{background:var(--red-lt);color:#991B1B}
.bdg-amber{background:var(--amber-lt);color:#92400E}
.bdg-green{background:var(--green-lt);color:#065F46}
.bdg-blue{background:var(--blue-lt);color:var(--blue)}
.bdg-gray{background:var(--gray7);color:var(--gray3)}
.bdg-purple{background:var(--purple-lt);color:var(--purple)}
.bdg-orange{background:var(--orange-lt);color:var(--orange)}
.bdg-teal{background:var(--teal-lt);color:var(--teal)}

/* ══ TYPE CHIP ══ */
.type-chip{display:inline-flex;align-items:center;gap:5px;padding:4px 10px;border-radius:6px;font-size:11px;font-weight:700;white-space:nowrap}
.type-ret{background:var(--red-lt);color:#991B1B;border:1px solid #FECACA}
.type-exc{background:var(--amber-lt);color:#92400E;border:1px solid #FCD34D}

/* ══ STOCK STATUS INDICATOR ══ */
.stock-ind{display:flex;align-items:center;gap:5px;font-size:12px}
.stock-dot{width:8px;height:8px;border-radius:50%;flex-shrink:0}
.s-good{background:var(--green)}.s-bad{background:var(--red)}.s-pend{background:var(--gray4)}

/* ══ PAGINATION ══ */
.pagination-wrap{display:flex;align-items:center;justify-content:space-between;padding:12px 16px;border-top:1px solid var(--gray6)}
.page-info{font-size:12px;color:var(--gray3)}
.page-btns{display:flex;gap:4px}
.pg-btn{width:30px;height:30px;border:1.5px solid var(--gray5);border-radius:6px;display:flex;align-items:center;justify-content:center;cursor:pointer;font-size:12px;font-weight:600;color:var(--gray3);background:var(--white);transition:all .15s}
.pg-btn:hover{border-color:var(--blue);color:var(--blue)}
.pg-btn.on{background:var(--blue);color:#fff;border-color:var(--blue)}

/* ══ INNER TABS (이력 탭 안) ══ */
.inner-tabs{display:flex;gap:0;border-bottom:1.5px solid var(--gray6);margin-bottom:14px}
.inner-tab{padding:8px 18px;font-size:12px;font-weight:700;color:var(--gray4);cursor:pointer;border-bottom:2px solid transparent;margin-bottom:-1px;transition:all .15s;display:flex;align-items:center;gap:6px}
.inner-tab.on{color:var(--blue);border-bottom-color:var(--blue)}
.inner-tab:hover:not(.on){color:var(--gray2)}
.inner-cnt{font-size:9px;font-weight:700;padding:1px 5px;border-radius:10px;color:#fff}

/* ══ FILTER BAR ══ */
.filter-bar{display:flex;align-items:center;gap:8px;padding:12px 16px;background:var(--white);border:1px solid var(--gray6);border-radius:10px;margin-bottom:14px;flex-wrap:wrap;box-shadow:0 1px 3px rgba(15,32,68,.05)}
.f-label{font-size:11px;font-weight:700;color:var(--gray3);white-space:nowrap;text-transform:uppercase;letter-spacing:.05em}
.date-in{padding:7px 10px;border:1.5px solid var(--gray5);border-radius:6px;font-size:12px;font-family:'Pretendard',sans-serif;color:var(--gray2);outline:none;transition:border .15s}
.date-in:focus{border-color:var(--blue)}

/* ══ MODAL ══ */
.modal-bg{display:none;position:fixed;inset:0;background:rgba(15,32,68,.48);z-index:300;align-items:center;justify-content:center}
.modal-bg.open{display:flex}
.modal{background:var(--white);width:560px;max-height:90vh;border-radius:12px;overflow:hidden;display:flex;flex-direction:column;box-shadow:0 20px 60px rgba(15,32,68,.25)}
.modal-hdr{padding:18px 22px;border-bottom:1px solid var(--gray6);display:flex;align-items:center;justify-content:space-between;background:var(--navy)}
.modal-title{font-size:14px;font-weight:700;color:#fff;display:flex;align-items:center;gap:8px}
.modal-x{background:none;border:none;color:rgba(255,255,255,.5);font-size:18px;cursor:pointer;line-height:1;padding:0;transition:color .15s}
.modal-x:hover{color:#fff}
.modal-body{padding:22px;overflow-y:auto;flex:1}
.modal-foot{padding:14px 22px;border-top:1px solid var(--gray6);display:flex;gap:8px;justify-content:flex-end;background:var(--bg2)}

/* DETAIL ROWS */
.dr{display:flex;padding:10px 0;border-bottom:1px solid var(--gray7)}
.dr:last-child{border-bottom:none}
.dk{font-size:11px;font-weight:700;color:var(--gray3);text-transform:uppercase;letter-spacing:.06em;width:110px;flex-shrink:0;padding-top:1px}
.dv{font-size:13px;color:var(--gray1);flex:1}

/* SECTION TITLE */
.sec-ttl{font-size:10px;font-weight:700;color:var(--gray3);text-transform:uppercase;letter-spacing:.1em;margin-bottom:10px;padding-bottom:8px;border-bottom:1px solid var(--gray7);display:flex;align-items:center;gap:6px}
.sec-ttl::before{content:'';width:3px;height:12px;background:var(--blue);border-radius:2px;display:inline-block}

/* INSPECTION CARD */
.inspect-card{border:1.5px solid var(--gray5);border-radius:8px;overflow:hidden;margin-bottom:14px}
.inspect-hdr{padding:10px 14px;background:var(--gray7);font-size:11px;font-weight:700;color:var(--gray3);text-transform:uppercase;letter-spacing:.07em}
.inspect-body{padding:14px}

/* ACTION CONFIRM BOX */
.action-box{border-radius:8px;padding:14px 16px;margin-top:12px;border:1.5px solid}
.action-box-good{background:var(--green-lt);border-color:#6EE7B7}
.action-box-bad{background:var(--red-lt);border-color:#FECACA}
.action-box-title{font-size:12px;font-weight:700;margin-bottom:4px}
.action-box-desc{font-size:11.5px;color:var(--gray3);line-height:1.6}

/* TOAST */
.toast{position:fixed;bottom:28px;left:50%;transform:translateX(-50%) translateY(20px);background:var(--gray1);color:#fff;padding:11px 22px;border-radius:8px;font-size:13px;font-weight:500;opacity:0;transition:all .3s;z-index:999;pointer-events:none;display:flex;align-items:center;gap:8px}
.toast.show{opacity:1;transform:translateX(-50%) translateY(0)}

/* SUMMARY PILLS */
.pills{display:flex;gap:8px;margin-bottom:14px;flex-wrap:wrap}
.pill{display:flex;align-items:center;gap:6px;padding:7px 14px;border-radius:8px;border:1px solid;font-size:12px;font-weight:600}
.pill-num{font-family:'DM Mono',monospace;font-size:16px;font-weight:700}
</style>
</head>
<body>
	<jsp:include page="/WEB-INF/views/common/log_header.jsp"/>
<main class="main">
  <div class="topbar">
    <div class="breadcrumb">
      <span class="breadcrumb-root">Step WMS</span>
      <span class="breadcrumb-sep">›</span>
      <span class="breadcrumb-cur">반품 / 교환 관리</span>
    </div>
  </div>

  <div class="content">
    <div class="tab-bar">
      <div class="tab-btn on" id="tab-claim-btn" onclick="switchTab('claim')">
        🔄 접수된 클레임 처리 <span class="tab-cnt" id="claimWaitCnt">${claimList.size()}</span>
      </div>
      <div class="tab-btn" id="tab-hist-btn" onclick="switchTab('hist')">
        📋 클레임 처리 이력 조회 <span class="tab-cnt tab-cnt-gray">${historyList.size()}</span>
      </div>
    </div>

    <div id="sec-claim">
      <div class="tbl-card">
        <div class="tbl-top">
          <div class="tbl-top-info">처리 대기 목록 (총 <strong>${claimList.size()}</strong>건)</div>
        </div>
        <div class="tbl-wrap">
          <table>
            <thead>
              <tr>
                <th>접수번호</th>
                <th>주문번호</th>
                <th>구분</th>
                <th>상품명</th>
                <th>신청 사유</th>
                <th>상태</th>
                <th>처리하기</th>
              </tr>
            </thead>
            <tbody>
              <c:forEach var="c" items="${claimList}">
				  <tr>
				    <td>${c.ret_num}</td>
				    <td>#${c.order_num}</td>
				    <td>
				      <c:choose>
				        <c:when test="${c.tp == 1}"><span class="bdg bdg-red">반품</span></c:when>
				        <c:otherwise><span class="bdg bdg-blue">교환</span></c:otherwise>
				      </c:choose>
				    </td>
				    <td style="text-align:left; font-weight:600;">${c.prod_name}</td>
				    <td style="color:var(--gray3);">${c.reason}</td>
				    <td><span class="bdg bdg-amber">쇼핑몰완료</span></td>
				    <td>
				      <button type="button" class="btn btn-blue btn-xs" 
				              onclick="openClaimModal('${c.ret_num}', '${c.order_num}', '${c.tp}', '${c.prod_name}', '${c.recv_name}', '${c.recv_phone}', '${c.recv_addr}')">
				        검수 및 처리
				      </button>
				    </td>
				  </tr>
				</c:forEach>
              <c:if var="isEmpty" test="${empty claimList}">
                <tr><td colspan="7" style="text-align:center; padding:40px; color:var(--gray4);">📥 처리 대기 중인 반품/교환 내역이 없습니다.</td></tr>
              </c:if>
            </tbody>
          </table>
        </div>
        
        <div class="pagination-wrap">
          <div class="page-info" id="claimPageInfo"></div>
          <div class="page-btns" id="claimPageBtns"></div>
        </div>
      </div>
    </div>

    <div id="sec-hist" style="display:none">
      <div class="tbl-card">
        <div class="tbl-top"><div class="tbl-top-info">최종 완결 이력 목록</div></div>
        <div class="tbl-wrap">
          <table>
            <thead>
              <tr>
                <th>접수번호</th>
                <th>주문번호</th>
                <th>구분</th>
                <th>상품명</th>
                <th>처리방식</th>
                <th>교환 운송장</th>
                <th>관리자 메모</th>
                <th>상태</th>
              </tr>
            </thead>
            <tbody id="histTbody">
              </tbody>
          </table>
        </div>
        <div class="pagination-wrap">
          <div class="page-info" id="histPageInfo"></div>
          <div class="page-btns" id="histPageBtns"></div>
        </div>
      </div>
    </div>
  </div>
</main>

<form id="claimProcessForm" method="post" action="${pageContext.request.contextPath}/logistics/claim/process.do" style="display:none;">
  <input type="hidden" name="retNum" id="f-retNum">
  <input type="hidden" name="orderNum" id="f-orderNum">
  <input type="hidden" name="tp" id="f-tp">
  <input type="hidden" name="processType" id="f-processType"> <input type="hidden" name="courier" id="f-courier">
  <input type="hidden" name="invoiceNo" id="f-invoiceNo">
  <input type="hidden" name="adminMemo" id="f-adminMemo">
</form>

	<div class="modal-bg" id="claimModal">
  <div class="modal" style="width:520px;">
    
    <div class="modal-hdr">
      <div class="modal-title" id="m-title">📦 반품/교환 상세 검수</div>
      <button class="modal-x" onclick="closeModal()">✕</button>
    </div>
    
	    <div class="modal-body" style="max-height: 60vh; overflow-y: auto; padding-right: 10px;">
	      
	      <div class="sec-title">👤 수령자(주문자) 배송 정보</div>
	      <div class="dr"><div class="dk">수령인</div><div class="dv" id="m-recvName"></div></div>
	      <div class="dr"><div class="dk">연락처</div><div class="dv" id="m-recvPhone"></div></div>
	      <div class="dr"><div class="dk">반송 주소</div><div class="dv" id="m-recvAddr"></div></div>
	      
	      <hr style="border:0; border-top:1px solid var(--gray6); margin:15px 0;">
	      
	      <div class="sec-title">👟 검수 대상 상품 정보</div>
	      <div class="dr"><div class="dk">접수/주문번호</div><div class="dv" id="m-nums"></div></div>
	      <div class="dr"><div class="dk">상품명</div><div class="dv" id="m-prodName" style="font-weight:700;"></div></div>
	
	      <div id="exchange-delivery-area" style="display:none; background: #f8faff; padding: 15px; border-radius: 8px; border: 1px solid #e1e8f5; margin-top: 10px;">
	        <div class="sec-title" style="color:var(--blue); font-size: 13px; margin-bottom: 10px;">🚚 교환 상품 재출고 정보 (필수)</div>
	        
	        <div class="dr" style="margin-bottom: 8px;">
	          <div class="dk" style="font-size: 12px; width: 80px;">택배사</div>
	          <div class="dv">
	            <select id="m-courier-sel" class="modal-input" style="width: 100%; padding: 6px; cursor:pointer;">
	              <option value="">택배사 선택</option>
	              <option value="CJ대한통운">CJ대한통운</option>
	              <option value="롯데택배">롯데택배</option>
	              <option value="한진택배">한진택배</option>
	              <option value="우체국택배">우체국택배</option>
	            </select>
	          </div>
	        </div>
	
	        <div class="dr">
	          <div class="dk" style="font-size: 12px; width: 80px;">송장번호</div>
	          <div class="dv" style="display:flex; gap:6px;">
	            <input type="text" id="m-invoice-input" class="modal-input" placeholder="우측 버튼을 눌러주세요" readonly style="flex:1; background:#fff; border:1px solid var(--gray5); padding:6px;">
	            <button type="button" class="btn btn-outline btn-xs" onclick="generateExchangeInvoice()" style="white-space:nowrap;">번호 생성</button>
	          </div>
	        </div>
	      </div>
	
	      <hr style="border:0; border-top:1px solid var(--gray6); margin:15px 0;">
	      
	      <div class="sec-title">📝 물류 담당자 특이사항 기록 (특수문자 허용)</div>
	      <div style="margin-top:6px;">
	        <textarea id="m-memo" style="width:100%; height:80px; padding:10px; border:1px solid var(--gray5); border-radius:6px; resize:none; font-size:13px;" placeholder="물류창고 상품 입고 상태 및 폐기 사유 기입..."></textarea>
	      </div>
	      
	    </div>
	    
	    <div class="modal-foot" style="display:flex; gap:10px; justify-content:flex-end;">
	      <button class="btn btn-outline" onclick="closeModal()">닫기</button>
	      <button class="btn btn-red" onclick="submitProcess('DISPOSAL')">🗑️ 불량 폐기 처리</button>
	      <button class="btn btn-green" onclick="submitProcess('RECOVERY')">✨ 양품 복구 입고</button>
	    </div>
	    
	  </div>
	</div>

<div class="toast" id="toast"></div>

<script>
// 이력 데이터 임시 Mock 객체 (형님 자바 리스트 연동용 포맷팅)
const historyData = [
  <c:forEach var="h" items="${historyList}">
  {
    ret_num: ${h.ret_num},
    order_num: ${h.order_num},
    tp: '${h.tp == 1 ? "반품" : "교환"}',
    prod_name: '${h.prod_name}',
    proc_type: '${h.reason}', // 🎯 DAO에서 디코딩해온 '양품복구'/'불량폐기' 문자열이 들어갑니다!
    invoice: '${empty h.invoice_no ? "-" : h.invoice_no}',
    memo: `${h.ret_note}`
  },
  </c:forEach>
];

let currentClaimPage = 1;
let currentHistPage = 1;
const itemsPerPage = 10; // 🎯 형님이 요구하신 10개씩 페이징!

function switchTab(tab) {
    const isClaim = tab === 'claim';
    document.getElementById('sec-claim').style.display = isClaim ? '' : 'none';
    document.getElementById('sec-hist').style.display = isClaim ? 'none' : '';
    document.getElementById('tab-claim-btn').classList.toggle('on', isClaim);
    document.getElementById('tab-hist-btn').classList.toggle('on', !isClaim);
    if(!isClaim) renderHistTable();
}

// 팝업 데이터 셋업 및 오픈
function openClaimModal(retNum, orderNum, tp, prodName, recvName, recvPhone, recvAddr) {
    // 폼 데이터 세팅 (Hidden 필드)
    document.getElementById('f-retNum').value = retNum;
    document.getElementById('f-orderNum').value = orderNum;
    document.getElementById('f-tp').value = tp;
    
    // 모달 상단 정보 세팅
    document.getElementById('m-title').innerText = (tp === '1') ? "🔄 [반품] 상세 검수 및 재고 처리" : "🔄 [교환] 상세 검수 및 교환 출고";
    document.getElementById('m-recvName').innerText = recvName;
    document.getElementById('m-recvPhone').innerText = recvPhone;
    document.getElementById('m-recvAddr').innerText = recvAddr;
    document.getElementById('m-nums').innerHTML = `접수번호: <b>${retNum}</b> / 주문번호: <b>#${orderNum}</b>`;
    document.getElementById('m-prodName').innerText = prodName;
    
    // 🎯 [교환 전용 구역] tp가 2(교환)일 때만 배송 정보 입력창을 보여줍니다.
    const dlvArea = document.getElementById('exchange-delivery-area');
    if(tp === '2') {
        dlvArea.style.display = 'block'; // 교환이면 표시
    } else {
        dlvArea.style.display = 'none';  // 반품이면 숨김
    }
    
    // 모달 내 입력값 초기화
    document.getElementById('m-courier-sel').value = "";
    document.getElementById('m-invoice-input').value = "";
    document.getElementById('m-memo').value = "";
    
    document.getElementById('claimModal').classList.add('open');
}

function closeModal() { document.getElementById('claimModal').classList.remove('open'); }

// 🚚 교환용 일련 랜덤 운송장 발행 로직
function generateExchangeInvoice() {
    const courier = document.getElementById('m-courier-sel').value;
    if(!courier) {
        alert('택배사를 먼저 선택해야 송장 번호를 딸 수 있습니다!');
        document.getElementById('m-courier-sel').focus();
        return;
    }

    // 날짜 조합 (YYYYMMDD)
    const now = new Date();
    const dateStr = now.getFullYear() + 
                    String(now.getMonth() + 1).padStart(2, '0') + 
                    String(now.getDate()).padStart(2, '0');

    // 택배사별 식별 프리픽스
    let prefix = "CJ";
    if(courier === '롯데택배') prefix = "LOTTE";
    else if(courier === '한진택배') prefix = "HJ";
    else if(courier === '우체국택배') prefix = "POST";

    // 랜덤 4자리 난수
    const randNum = String(Math.floor(Math.random() * 9000) + 1000);

    // 최종 결과물: 예) CJ-20260520-EX-1234
    const finalInvoice = prefix + "-" + dateStr + "-EX-" + randNum;

    // input 창에 즉시 기입
    document.getElementById('m-invoice-input').value = finalInvoice;
}

// 최종 완료 전송
function submitProcess(type) {
    const tp = document.getElementById('f-tp').value;
    document.getElementById('f-processType').value = type;
    document.getElementById('f-adminMemo').value = document.getElementById('m-memo').value;
    
    // 교환인데 정보 기입 누락 시 락 차단
    if(tp === '2') {
        const courier = document.getElementById('m-courier-sel').value;
        const invoice = document.getElementById('m-invoice-input').value;
        if(!courier || !invoice) {
            alert('형님, 교환 상품 배송 보낼 택배사와 운송장 번호를 완성해 주셔야 합니다!');
            return;
        }
        document.getElementById('f-courier').value = courier;
        document.getElementById('f-invoiceNo').value = invoice;
    }
    
    if(!confirm(`해당 건을 정말로 \${type === 'DISPOSAL' ? '불량 폐기' : '양품 복구입고'} 처리 완료하시겠습니까?`)) return;
    
    document.getElementById('claimProcessForm').submit();
}

// 📋 이력조회 전용 10개 단위 페이징 테이블 렌더러
function renderHistTable() {
    const tbody = document.getElementById('histTbody');
    if(!tbody) return;
    
    const start = (currentHistPage - 1) * itemsPerPage;
    const end = start + itemsPerPage;
    const pageData = historyData.slice(start, end);
    
    if(!pageData.length) {
        tbody.innerHTML = '<tr><td colspan="8" style="text-align:center; padding:30px; color:var(--gray4);">📭 처리 완료된 클레임 이력이 없습니다.</td></tr>';
        return;
    }
    
    let html = '';
    pageData.forEach(h => {
        // 🎯 스타일 배지 컬러 분기 처리 완벽 수정
        const procBdg = h.proc_type === '양품복구' ? 'bdg-green' : 'bdg-red';
        const tpBdg = h.tp === '반품' ? 'bdg-red' : 'bdg-blue';
        
        html += `<tr>
            <td>\${h.ret_num}</td>
            <td>#\${h.order_num}</td>
            <td><span class="bdg \${tpBdg}">\${h.tp}</span></td>
            <td style="text-align:left; font-weight:600;">\${h.prod_name}</td>
            <td><span class="bdg \${procBdg}">\${h.proc_type}</span></td>
            <td style="font-family:'DM Mono',monospace;">\${h.invoice}</td>
            <td style="text-align:left; color:var(--gray2); max-width:150px; overflow:hidden; text-overflow:ellipsis; white-space:nowrap;">\${h.memo}</td>
            <td><span class="bdg bdg-gray">처리완료</span></td>
        </tr>`;
    });
    tbody.innerHTML = html;
    renderHistPagination();
}

function renderHistPagination() {
    const totalPages = Math.ceil(historyData.length / itemsPerPage) || 1;
    const pageBtns = document.getElementById('histPageBtns');
    document.getElementById('histPageInfo').textContent = `\${currentHistPage} / \${totalPages} 페이지`;
    
    let btnHtml = '';
    for(let i=1; i<=totalPages; i++) {
        btnHtml += `<div class="pg-btn \${i === currentHistPage ? 'on' : ''}" onclick="changeHistPage(\${i})">\${i}</div>`;
    }
    pageBtns.innerHTML = btnHtml;
}

function changeHistPage(p) { currentHistPage = p; renderHistTable(); }

// 초기 가동
function showToast(msg) { /* 토스트 로직 생략 */ }
</script>
</body>
</html>