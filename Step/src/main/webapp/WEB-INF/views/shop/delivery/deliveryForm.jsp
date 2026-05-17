<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>ShoeMall - 배송 관리</title>
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700;900&family=Space+Grotesk:wght@600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/KM_style.css">
<style>
.main{margin-left:220px;flex:1;display:flex;flex-direction:column;min-height:100vh}
.topbar{height:54px;border-bottom:1px solid #1a1a1a;display:flex;align-items:center;padding:0 24px;gap:12px;background:var(--black);position:sticky;top:0;z-index:50}
.topbar-title{font-family:'Space Grotesk',sans-serif;font-size:14px;font-weight:700;color:#fff;letter-spacing:.02em}
.topbar-path{font-size:11px;color:#444}
.topbar-right{margin-left:auto;display:flex;align-items:center;gap:8px}
.t-btn{width:32px;height:32px;border:1px solid #333;background:transparent;display:flex;align-items:center;justify-content:center;cursor:pointer;font-size:14px;color:#888;border-radius:2px}
.t-btn:hover{border-color:#555;color:#fff}
.content{padding:24px;flex:1}
.page-hdr{display:flex;align-items:center;justify-content:space-between;margin-bottom:20px}
.page-hdr-title{font-size:20px;font-weight:900;letter-spacing:-.5px}
.page-hdr-sub{font-size:12px;color:var(--gray4);margin-top:2px}
.stats-row{display:grid;grid-template-columns:repeat(5,1fr);gap:1px;background:var(--border);margin-bottom:20px;border:1px solid var(--border)}
.stat-card{background:var(--white);padding:16px 18px;cursor:pointer;transition:background .15s}
.stat-card:hover{background:#f5f5f5}
.stat-card.active{background:#111}
.stat-card.active .stat-label{color:rgba(255,255,255,0.6)}
.stat-card.active .stat-val{color:#fff}
.stat-label{font-size:10px;font-weight:700;color:var(--gray4);margin-bottom:8px;text-transform:uppercase;letter-spacing:.08em}
.stat-val{font-family:'Space Grotesk',sans-serif;font-size:24px;font-weight:700;letter-spacing:-1px}
.stat-change{font-size:11px;margin-top:5px;color:var(--gray4)}
.toolbar{display:flex;align-items:center;gap:10px;margin-bottom:16px;flex-wrap:wrap}
.search-wrap{position:relative;flex:1;max-width:300px}
.search-wrap input{width:100%;padding:9px 12px 9px 36px;border:1px solid var(--border);background:var(--white);font-size:13px;font-family:inherit;outline:none;color:var(--black)}
.search-wrap input:focus{border-color:var(--black)}
.search-wrap input::placeholder{color:var(--gray5)}
.search-ico{position:absolute;left:11px;top:50%;transform:translateY(-50%);color:var(--gray4);font-size:14px}
.btn{padding:9px 16px;border:none;cursor:pointer;font-size:12px;font-weight:700;font-family:inherit;transition:all .18s;display:inline-flex;align-items:center;justify-content:center;gap:6px;white-space:nowrap}
.btn-black{background:var(--black);color:#fff}
.btn-black:hover{background:#333}
.btn-outline{background:var(--white);color:var(--gray2);border:1px solid var(--border)}
.btn-outline:hover{border-color:var(--black);color:var(--black)}
.btn-danger{background:#fff0f0;color:var(--red);border:1px solid #ffd0d0}
.btn-danger:hover{background:var(--red);color:#fff}
.btn-blue{background:#e8f0ff;color:var(--blue);border:1px solid #c0d0ff}
.btn-blue:hover{background:var(--blue);color:#fff}
.btn-green{background:#e8f5e8;color:#155724;border:1px solid #c3e6cb}
.btn-green:hover{background:#155724;color:#fff}
.btn-sm{padding:5px 10px;font-size:11px}
.btn-xs{padding:3px 8px;font-size:10px;white-space:nowrap}
.badge{display:inline-flex;align-items:center;padding:3px 9px;font-size:11px;font-weight:700;border-radius:20px}
.b-wait{background:#fff3cd;color:#856404}
.b-ready{background:#cfe2ff;color:#0a58ca}
.b-shipping{background:#d1ecf1;color:#0c5460}
.b-done{background:#d4edda;color:#155724}
.b-cancel{background:#f8d7da;color:#721c24}
.tbl-wrap{overflow-x:auto;background:var(--white);border:1px solid var(--border)}
table{width:100%;border-collapse:collapse}
th{padding:10px 14px;font-size:10px;font-weight:700;color:var(--gray4);letter-spacing:.08em;text-transform:uppercase;border-bottom:1px solid var(--border);text-align:left;background:var(--white)}
td{padding:12px 14px;border-bottom:1px solid var(--border);font-size:13px;color:var(--gray2);vertical-align:middle;white-space:nowrap}
tr:last-child td{border-bottom:none}
tr:hover td{background:#fafafa}
.modal-overlay{display:none;position:fixed;inset:0;background:rgba(0,0,0,.6);z-index:300;align-items:center;justify-content:center}
.modal-overlay.open{display:flex}
.modal-box{background:var(--white);width:560px;max-height:90vh;display:flex;flex-direction:column;border:1px solid var(--border)}
.modal-hdr{display:flex;align-items:center;justify-content:space-between;padding:18px 22px;border-bottom:1px solid var(--border);background:var(--black);color:#fff}
.modal-title{font-family:'Space Grotesk',sans-serif;font-size:15px;font-weight:700}
.modal-close{background:none;border:none;color:#888;cursor:pointer;font-size:20px;line-height:1;padding:0}
.modal-close:hover{color:#fff}
.modal-body{padding:22px;overflow-y:auto;flex:1}
.modal-footer{padding:14px 22px;border-top:1px solid var(--border);display:flex;gap:8px;justify-content:flex-end;background:var(--gray7)}
.form-group{display:flex;flex-direction:column;gap:6px;margin-bottom:14px}
.f-label{font-size:10px;font-weight:700;color:var(--gray3);text-transform:uppercase;letter-spacing:.07em}
.f-input{padding:10px 12px;border:1px solid var(--border);background:var(--white);font-size:13px;font-family:inherit;outline:none;color:var(--black);width:100%}
.f-input:focus{border-color:var(--black)}
.f-input[readonly]{background:#f9f9f9;color:var(--gray3)}
.f-row{display:grid;grid-template-columns:1fr 1fr;gap:12px}
.info-section{background:#f9f9f9;border:1px solid var(--border);padding:14px 16px;margin-bottom:14px;border-radius:4px}
.info-section-title{font-size:10px;font-weight:700;color:var(--gray3);text-transform:uppercase;letter-spacing:.07em;margin-bottom:10px}
.dlv-track-wrap{background:#f9fafb;border:1px solid var(--border);border-radius:8px;padding:20px;margin-bottom:16px}
.dlv-track-title{font-size:10px;font-weight:700;color:var(--gray3);text-transform:uppercase;letter-spacing:.07em;margin-bottom:20px}
.dlv-track{display:flex;align-items:flex-start;justify-content:center;position:relative}
.dlv-step{display:flex;flex-direction:column;align-items:center;gap:8px;flex:1;position:relative;z-index:1;cursor:pointer}
.dlv-step-icon{width:52px;height:52px;border-radius:50%;background:#e5e7eb;display:flex;align-items:center;justify-content:center;font-size:22px;border:3px solid #e5e7eb;transition:all .25s}
.dlv-step-label{font-size:11px;font-weight:700;color:#9ca3af;text-align:center;transition:all .25s;line-height:1.4}
.dlv-step.done .dlv-step-icon{background:#111;border-color:#111}
.dlv-step.done .dlv-step-label{color:#555}
.dlv-step.active .dlv-step-icon{background:#fff;border-color:#111;box-shadow:0 0 0 5px rgba(0,0,0,0.08);transform:scale(1.1)}
.dlv-step.active .dlv-step-label{color:#111;font-weight:900}
.dlv-step:hover .dlv-step-icon{transform:scale(1.12)}
.dlv-step.active:hover .dlv-step-icon{transform:scale(1.15)}
.dlv-connector{flex:1;height:3px;background:#e5e7eb;margin-top:25px;transition:background .25s;z-index:0}
.dlv-connector.done{background:#111}
.dlv-status-label{text-align:center;margin-top:16px;padding:10px;background:#fff;border:1px solid var(--border);border-radius:6px;font-size:14px;font-weight:700;color:#111}
/* 상품 카드 */
.item-card{display:flex;gap:14px;padding:14px 0;border-bottom:1px solid var(--border)}
.item-card:last-child{border-bottom:none}
.item-img{width:72px;height:72px;object-fit:cover;border:1px solid var(--border);border-radius:6px;flex-shrink:0;background:#f5f5f5}
.item-img-placeholder{width:72px;height:72px;border:1px solid var(--border);border-radius:6px;flex-shrink:0;background:#f5f5f5;display:flex;align-items:center;justify-content:center;font-size:28px}
.item-info{flex:1;min-width:0}
.item-name{font-weight:700;font-size:14px;color:#111;margin-bottom:3px;white-space:normal}
.item-brand{font-size:11px;color:var(--gray4);margin-bottom:7px}
.item-opts{display:flex;gap:5px;flex-wrap:wrap;margin-bottom:8px}
.item-opt-badge{padding:2px 8px;background:#fff;border:1px solid var(--border);border-radius:4px;font-size:11px;color:var(--gray2)}
.item-price-row{display:flex;align-items:center;justify-content:space-between}
.item-qty{font-size:12px;color:var(--gray4)}
.item-price{font-weight:900;font-size:15px;color:#111}
.toast{position:fixed;bottom:28px;left:50%;transform:translateX(-50%) translateY(20px);background:var(--black);color:#fff;padding:11px 22px;font-size:13px;font-weight:500;opacity:0;transition:all .3s;z-index:999;pointer-events:none}
.toast.show{opacity:1;transform:translateX(-50%) translateY(0)}
</style>
</head>
<body>

<%@ include file="../../common/shopAdminHeader.jsp"%>

<div class="main">
  <div class="topbar">
    <div class="topbar-title">배송 관리</div>
    <div class="topbar-path">Admin > 배송 관리</div>
    <div class="topbar-right"><div class="t-btn">🔔</div></div>
  </div>

  <div class="content">

    <c:if test="${not empty msg}">
      <c:choose>
        <c:when test="${msg eq 'update_ok'}">
          <script>window.onload=function(){showToast('배송 정보가 업데이트되었습니다.');}</script>
        </c:when>
        <c:when test="${msg eq 'cancel_ok'}">
          <script>window.onload=function(){showToast('주문이 취소되었습니다. 재고가 복구되고 고객에게 알림이 발송되었습니다.');}</script>
        </c:when>
      </c:choose>
    </c:if>

    <div class="page-hdr">
      <div>
        <div class="page-hdr-title">배송 관리</div>
        <div class="page-hdr-sub">배송 상태 변경, 송장 입력, 주문 취소를 관리합니다.</div>
      </div>
    </div>

    <!-- 통계 카드 -->
    <div class="stats-row">
      <div class="stat-card ${statusSel == null || statusSel eq '' ? 'active' : ''}"
           onclick="location.href='${pageContext.request.contextPath}/shop/delivery/deliveryForm.do'">
        <div class="stat-label">전체</div>
        <div class="stat-val">${statusCount.wait + statusCount.ready + statusCount.shipping + statusCount.done + statusCount.cancel}</div>
        <div class="stat-change">전체 배송 건</div>
      </div>
      <div class="stat-card ${statusSel eq '1' ? 'active' : ''}"
           onclick="location.href='${pageContext.request.contextPath}/shop/delivery/deliveryForm.do?status=1'">
        <div class="stat-label">배송대기</div>
        <div class="stat-val" style="color:#856404">${statusCount.wait}</div>
        <div class="stat-change">📦 처리 필요</div>
      </div>
      <div class="stat-card ${statusSel eq '2' ? 'active' : ''}"
           onclick="location.href='${pageContext.request.contextPath}/shop/delivery/deliveryForm.do?status=2'">
        <div class="stat-label">배송준비중</div>
        <div class="stat-val" style="color:#0a58ca">${statusCount.ready}</div>
        <div class="stat-change">🏭 준비 중</div>
      </div>
      <div class="stat-card ${statusSel eq '3' ? 'active' : ''}"
           onclick="location.href='${pageContext.request.contextPath}/shop/delivery/deliveryForm.do?status=3'">
        <div class="stat-label">배송중</div>
        <div class="stat-val" style="color:#0c5460">${statusCount.shipping}</div>
        <div class="stat-change">🚚 이동 중</div>
      </div>
      <div class="stat-card ${statusSel eq '4' ? 'active' : ''}"
           onclick="location.href='${pageContext.request.contextPath}/shop/delivery/deliveryForm.do?status=4'">
        <div class="stat-label">배송완료</div>
        <div class="stat-val" style="color:#155724">${statusCount.done}</div>
        <div class="stat-change">✅ 완료</div>
      </div>
    </div>

    <!-- 툴바 -->
    <form action="${pageContext.request.contextPath}/shop/delivery/deliveryForm.do" method="get" class="toolbar">
      <input type="hidden" name="status" value="${statusSel}">
      <div class="search-wrap">
        <span class="search-ico">🔍</span>
        <input type="text" name="keyword" value="${keyword}" placeholder="수령인, 송장번호, 주문번호 검색">
      </div>
      <button type="submit" class="btn btn-outline btn-sm">🔄 조회</button>
      <a href="${pageContext.request.contextPath}/shop/delivery/deliveryForm.do?status=5"
         class="btn btn-danger btn-sm">🚫 취소 목록</a>
    </form>

    <!-- 테이블 -->
    <div class="tbl-wrap">
      <table>
        <thead>
          <tr>
            <th style="width:70px">배송번호</th>
            <th style="width:80px">주문번호</th>
            <th>회원명</th>
            <th>수령인</th>
            <th style="width:100px">결제금액</th>
            <th style="width:110px">배송상태</th>
            <th style="width:90px">택배사</th>
            <th style="width:140px">송장번호</th>
            <th style="width:130px">주문일시</th>
            <th style="width:210px">관리</th>
          </tr>
        </thead>
        <tbody>
          <c:forEach var="d" items="${deliveryList}">
            <tr>
              <td style="color:var(--gray4);font-size:12px">${d.dlvNum}</td>
              <td style="font-size:12px">${d.orderNum}</td>
              <td style="font-weight:700">${d.userName}</td>
              <td>${d.recvName}</td>
              <td><fmt:formatNumber value="${d.payPrice}" pattern="#,###"/>원</td>
              <td>
                <c:choose>
                  <c:when test="${d.dlvStatus == 1}"><span class="badge b-wait">📦 배송대기</span></c:when>
                  <c:when test="${d.dlvStatus == 2}"><span class="badge b-ready">🏭 준비중</span></c:when>
                  <c:when test="${d.dlvStatus == 3}"><span class="badge b-shipping">🚚 배송중</span></c:when>
                  <c:when test="${d.dlvStatus == 4}"><span class="badge b-done">✅ 완료</span></c:when>
                  <c:when test="${d.dlvStatus == 5}"><span class="badge b-cancel">🚫 취소</span></c:when>
                </c:choose>
              </td>
              <td style="font-size:12px;color:var(--gray3)">${d.courier}</td>
              <td style="font-size:12px;color:var(--gray3)">${d.invoiceNo}</td>
              <td style="font-size:12px;color:var(--gray4)">${d.orderCreatedAt}</td>
              <td>
                <div style="display:flex;gap:5px;flex-wrap:wrap">
                  <%-- 상세 버튼: 항상 표시 --%>
                  <button class="btn btn-green btn-xs"
                    onclick="openDetailModal(
                      ${d.orderNum},
                      '${d.recvName}',
                      '${d.orderCreatedAt}',
                      ${d.payPrice})">
                    📋 상세
                  </button>

                  <%-- 수정/취소: 취소 아닐 때만 --%>
                  <c:if test="${d.dlvStatus ne 5}">
                    <button class="btn btn-blue btn-xs"
                      onclick="openUpdateModal(
                        ${d.dlvNum}, ${d.dlvStatus},
                        '${d.courier}', '${d.invoiceNo}',
                        '${d.recvName}', '${d.recvPhone}',
                        '${d.recvAddr1}')">
                      ✏️ 수정
                    </button>
                    <c:if test="${d.dlvStatus eq 1}">
                      <button class="btn btn-danger btn-xs"
                        onclick="cancelOrder(${d.dlvNum}, ${d.orderNum}, ${d.userNum}, '${d.recvName}')">
                        🚫 취소
                      </button>
                    </c:if>
                  </c:if>

                  <c:if test="${d.dlvStatus eq 5}">
                    <span style="font-size:11px;color:var(--gray4)">처리완료</span>
                  </c:if>
                </div>
              </td>
            </tr>
          </c:forEach>
          <c:if test="${empty deliveryList}">
            <tr>
              <td colspan="10" style="text-align:center;padding:40px;color:var(--gray4)">
                📭 해당 배송 정보가 없습니다.
              </td>
            </tr>
          </c:if>
        </tbody>
      </table>
    </div>

  </div>
</div>

<!-- ===== 주문 상세 모달 ===== -->
<div class="modal-overlay" id="modal-detail">
  <div class="modal-box" style="width:620px">
    <div class="modal-hdr">
      <div class="modal-title">📋 주문 상품 상세</div>
      <button class="modal-close" onclick="closeModal('modal-detail')">✕</button>
    </div>
    <div class="modal-body">

      <div class="info-section">
        <div class="info-section-title">주문 정보</div>
        <div class="f-row">
          <div class="form-group" style="margin-bottom:0">
            <label class="f-label">수령인</label>
            <input class="f-input" type="text" id="detailRecvName" readonly>
          </div>
          <div class="form-group" style="margin-bottom:0">
            <label class="f-label">주문일시</label>
            <input class="f-input" type="text" id="detailOrderDate" readonly>
          </div>
        </div>
      </div>

      <div class="info-section" style="margin-bottom:0">
        <div class="info-section-title">주문 상품 목록</div>
        <div id="detailItemList">
          <div style="text-align:center;padding:30px;color:var(--gray4)">🔄 불러오는 중...</div>
        </div>
        <div style="border-top:2px solid #111;padding-top:14px;margin-top:4px;display:flex;justify-content:space-between;align-items:center">
          <span style="font-size:12px;color:var(--gray4)">총 결제금액</span>
          <span id="detailTotalPrice" style="font-size:20px;font-weight:900;color:#111"></span>
        </div>
      </div>

    </div>
    <div class="modal-footer">
      <button type="button" class="btn btn-black" onclick="closeModal('modal-detail')">닫기</button>
    </div>
  </div>
</div>

<!-- ===== 배송 수정 모달 ===== -->
<div class="modal-overlay" id="modal-update">
  <div class="modal-box">
    <div class="modal-hdr">
      <div class="modal-title">🚚 배송 정보 수정</div>
      <button class="modal-close" onclick="closeModal('modal-update')">✕</button>
    </div>
    <form action="${pageContext.request.contextPath}/shop/delivery/deliveryUpdate.do" method="post">
      <input type="hidden" name="dlvNum"    id="updateDlvNum">
      <input type="hidden" name="dlvStatus" id="updateDlvStatus" value="1">
      <div class="modal-body">

        <div class="dlv-track-wrap">
          <div class="dlv-track-title">📦 배송 단계 선택 (클릭하여 변경)</div>
          <div class="dlv-track">
            <div class="dlv-step" id="step1" onclick="setStep(1)">
              <div class="dlv-step-icon">📦</div>
              <div class="dlv-step-label">배송<br>대기</div>
            </div>
            <div class="dlv-connector" id="line1"></div>
            <div class="dlv-step" id="step2" onclick="setStep(2)">
              <div class="dlv-step-icon">🏭</div>
              <div class="dlv-step-label">배송<br>준비중</div>
            </div>
            <div class="dlv-connector" id="line2"></div>
            <div class="dlv-step" id="step3" onclick="setStep(3)">
              <div class="dlv-step-icon">🚚</div>
              <div class="dlv-step-label">배송중</div>
            </div>
            <div class="dlv-connector" id="line3"></div>
            <div class="dlv-step" id="step4" onclick="setStep(4)">
              <div class="dlv-step-icon">✅</div>
              <div class="dlv-step-label">배송<br>완료</div>
            </div>
          </div>
          <div class="dlv-status-label" id="stepLabel">📦 배송대기</div>
        </div>

        <div class="info-section">
          <div class="info-section-title">📍 배송지 정보</div>
          <div class="f-row">
            <div class="form-group">
              <label class="f-label">수령인</label>
              <input class="f-input" type="text" id="updateRecvName" readonly>
            </div>
            <div class="form-group">
              <label class="f-label">연락처</label>
              <input class="f-input" type="text" id="updateRecvPhone" readonly>
            </div>
          </div>
          <div class="form-group" style="margin-bottom:0">
            <label class="f-label">주소</label>
            <input class="f-input" type="text" id="updateAddr" readonly>
          </div>
        </div>

        <div class="info-section" style="margin-bottom:0">
          <div class="info-section-title">📮 택배 정보</div>
          <div class="f-row">
            <div class="form-group">
              <label class="f-label">택배사</label>
              <select class="f-input" name="courier" id="updateCourier">
                <option value="">선택</option>
                <option value="CJ대한통운">CJ대한통운</option>
                <option value="롯데택배">롯데택배</option>
                <option value="한진택배">한진택배</option>
                <option value="우체국택배">우체국택배</option>
                <option value="로젠택배">로젠택배</option>
              </select>
            </div>
            <div class="form-group">
              <label class="f-label">송장번호</label>
              <input class="f-input" type="text" name="invoiceNo" id="updateInvoiceNo" placeholder="송장번호 입력">
            </div>
          </div>
          <div id="trackBtnWrap" style="display:none;margin-top:4px">
            <button type="button" class="btn btn-outline btn-sm" style="width:100%" onclick="trackDelivery()">
              🔍 네이버 배송 조회
            </button>
          </div>
        </div>

      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-outline" onclick="closeModal('modal-update')">닫기</button>
        <button type="submit" class="btn btn-black">💾 저장</button>
      </div>
    </form>
  </div>
</div>

<!-- 취소 폼 -->
<form id="cancelForm" action="${pageContext.request.contextPath}/shop/delivery/deliveryCancel.do" method="post">
  <input type="hidden" name="dlvNum"   id="cancelDlvNum">
  <input type="hidden" name="orderNum" id="cancelOrderNum">
  <input type="hidden" name="userNum"  id="cancelUserNum">
</form>

<div class="toast" id="toast"></div>

<script>
var ctxPath = '${pageContext.request.contextPath}';

var stepLabels = {
    1: '📦 배송대기 — 상품이 출고 대기 중입니다.',
    2: '🏭 배송준비중 — 택배사에 상품을 전달 중입니다.',
    3: '🚚 배송중 — 상품이 배송 중입니다.',
    4: '✅ 배송완료 — 상품이 고객에게 전달되었습니다.'
};

function setStep(status) {
    for (var i = 1; i <= 4; i++) {
        document.getElementById('step' + i).className = 'dlv-step';
        if (i < 4) document.getElementById('line' + i).className = 'dlv-connector';
    }
    for (var i = 1; i < status; i++) {
        document.getElementById('step' + i).className = 'dlv-step done';
        if (i < 4) document.getElementById('line' + i).className = 'dlv-connector done';
    }
    document.getElementById('step' + status).className = 'dlv-step active';
    if (status > 1) {
        document.getElementById('line' + (status - 1)).className = 'dlv-connector done';
    }
    document.getElementById('updateDlvStatus').value = status;
    document.getElementById('stepLabel').textContent = stepLabels[status];
    document.getElementById('trackBtnWrap').style.display = status >= 3 ? 'block' : 'none';
}

function openUpdateModal(dlvNum, dlvStatus, courier, invoiceNo, recvName, recvPhone, addr) {
    document.getElementById('updateDlvNum').value    = dlvNum;
    document.getElementById('updateCourier').value   = courier   || '';
    document.getElementById('updateInvoiceNo').value = invoiceNo || '';
    document.getElementById('updateRecvName').value  = recvName  || '';
    document.getElementById('updateRecvPhone').value = recvPhone || '';
    document.getElementById('updateAddr').value      = addr      || '';
    setStep(dlvStatus || 1);
    document.getElementById('modal-update').classList.add('open');
}

function openDetailModal(orderNum, recvName, orderDate, payPrice) {
    document.getElementById('detailRecvName').value  = recvName  || '';
    document.getElementById('detailOrderDate').value = orderDate || '';
    document.getElementById('detailTotalPrice').textContent =
        Number(payPrice).toLocaleString() + '원';
    document.getElementById('detailItemList').innerHTML =
        '<div style="text-align:center;padding:30px;color:#9ca3af">🔄 불러오는 중...</div>';
    document.getElementById('modal-detail').classList.add('open');

    fetch(ctxPath + '/shop/delivery/deliveryDetail.do?orderNum=' + orderNum)
        .then(function(res) { return res.json(); })
        .then(function(items) {
            if (!items || items.length === 0) {
                document.getElementById('detailItemList').innerHTML =
                    '<div style="text-align:center;padding:30px;color:#9ca3af">📭 상품 정보가 없습니다.</div>';
                return;
            }
            var html = '';
            items.forEach(function(item) {
                var imgHtml = (item.prodImgUrl && item.prodImgUrl !== '')
                    ? '<img class="item-img" src="' + ctxPath + item.prodImgUrl + '" onerror="this.outerHTML=\'<div class=item-img-placeholder>👟</div>\'">'
                    : '<div class="item-img-placeholder">👟</div>';

                var totalItemPrice = Number(item.itemPrice) * Number(item.qty);

                html += '<div class="item-card">';
                html +=   imgHtml;
                html +=   '<div class="item-info">';
                html +=     '<div class="item-name">' + (item.prodName || '') + '</div>';
                html +=     '<div class="item-brand">' + (item.brandName || '') + (item.catName ? ' · ' + item.catName : '') + '</div>';
                html +=     '<div class="item-opts">';
                html +=       '<span class="item-opt-badge">📏 ' + (item.sizeVal || '') + 'mm</span>';
                html +=       '<span class="item-opt-badge">🎨 ' + (item.color || '') + '</span>';
                html +=     '</div>';
                html +=     '<div class="item-price-row">';
                html +=       '<span class="item-qty">수량: ' + (item.qty || 0) + '개</span>';
                html +=       '<span class="item-price">' + totalItemPrice.toLocaleString() + '원</span>';
                html +=     '</div>';
                html +=   '</div>';
                html += '</div>';
            });
            document.getElementById('detailItemList').innerHTML = html;
        })
        .catch(function() {
            document.getElementById('detailItemList').innerHTML =
                '<div style="text-align:center;padding:30px;color:red">❌ 상품 정보 조회에 실패했습니다.</div>';
        });
}

function closeModal(id) {
    document.getElementById(id).classList.remove('open');
}

document.querySelectorAll('.modal-overlay').forEach(function(o) {
    o.addEventListener('click', function(e) {
        if (e.target === o) o.classList.remove('open');
    });
});

function cancelOrder(dlvNum, orderNum, userNum, name) {
    if (!confirm(
        '[' + name + '] 주문을 취소합니다.\n\n' +
        '✔ 재고가 자동으로 복구됩니다.\n' +
        '✔ 고객에게 취소 알림이 발송됩니다.\n\n' +
        '계속하시겠습니까?'
    )) return;
    document.getElementById('cancelDlvNum').value   = dlvNum;
    document.getElementById('cancelOrderNum').value = orderNum;
    document.getElementById('cancelUserNum').value  = userNum;
    document.getElementById('cancelForm').submit();
}

function trackDelivery() {
    var courier   = document.getElementById('updateCourier').value;
    var invoiceNo = document.getElementById('updateInvoiceNo').value;
    if (!courier || !invoiceNo) {
        alert('택배사와 송장번호를 입력해주세요.');
        return;
    }
    window.open(
        'https://search.naver.com/search.naver?query=' +
        encodeURIComponent(courier + ' ' + invoiceNo + ' 배송조회'),
        '_blank'
    );
}

function showToast(msg) {
    var t = document.getElementById('toast');
    t.textContent = msg;
    t.classList.add('show');
    setTimeout(function(){ t.classList.remove('show'); }, 3000);
}
</script>
</body>
</html>
