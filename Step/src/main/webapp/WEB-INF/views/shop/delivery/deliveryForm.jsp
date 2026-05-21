<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>ShoeMall - 배송 관리</title>
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

/* 👇 사이드바 너비만큼 본문을 밀어줍니다 */
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

/* STATS ROW */
.stats-row { display: grid; grid-template-columns: repeat(5, 1fr); gap: 20px; margin-bottom: 30px; }
.stat-card { background: #fff; padding: 20px 24px; border: 1px solid #e9ecef; border-radius: 12px; box-shadow: 0 2px 4px rgba(0,0,0,0.02); cursor: pointer; transition: all 0.2s ease; }
.stat-card:hover { transform: translateY(-2px); box-shadow: 0 4px 12px rgba(0,0,0,0.05); }

/* 활성화된 탭 카드 스타일 스타일리시하게 변경 */
.stat-card.active { background: #111827; border-color: #111827; }
.stat-card.active .stat-label { color: #9ca3af; }
.stat-card.active .stat-val { color: #fff !important; }
.stat-card.active .stat-change { color: #6b7280; }

.stat-label { font-size: 12px; font-weight: 600; color: #868e96; margin-bottom: 8px; }
.stat-val { font-family: 'Space Grotesk', sans-serif; font-size: 28px; font-weight: 700; color: #212529; }
.stat-change { font-size: 12px; margin-top: 8px; color: #adb5bd; }

/* ── 🚨 툴바 및 필터 영역 정렬 ── */
.toolbar { display: flex; align-items: center; gap: 12px; margin-bottom: 16px; flex-wrap: wrap; }
.search-wrap { position: relative; width: 320px; flex-shrink: 0; }
.search-wrap input {
    width: 100%;
    height: 40px; /* 높이 40px 통일 */
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

/* BUTTONS */
.btn {
    height: 40px; /* 높이 40px 통일 */
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
.btn-green { background: #e6fcf5; color: #059669; border: 1px solid #bbf7d0; }
.btn-green:hover { background: #059669; color: #fff; border-color: #059669; }

.btn-xs { height: 28px; padding: 0 10px; font-size: 11px; }

/* STATE BADGES */
.badge { display: inline-flex; align-items: center; padding: 4px 10px; border-radius: 12px; font-size: 11px; font-weight: 600; }
.b-wait { background: #fff4e6; color: #d9480f; }      /* 배송대기 */
.b-ready { background: #e0f2fe; color: #0369a1; }     /* 준비중 */
.b-shipping { background: #dbeafe; color: #2563eb; }  /* 배송중 */
.b-done { background: #dcfce7; color: #059669; }      /* 완료 */
.b-cancel { background: #fef2f2; color: #ef4444; }    /* 취소 */

/* TABLE LIST */
.tbl-wrap { background: #fff; border: 1px solid #e2e8f0; border-radius: 8px; overflow: hidden; box-shadow: 0 1px 2px rgba(0,0,0,0.05); }
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

/* ── MODAL OVERLAY & BOX (통일감 구현) ── */
.modal-overlay { display: none; position: fixed; inset: 0; background: rgba(0,0,0,.5); z-index: 3000; align-items: center; justify-content: center; }
.modal-overlay.open { display: flex; }
.modal-box { background: #fff; width: 560px; border-radius: 12px; height: 90vh; max-height: 90vh; display: flex; flex-direction: column; box-shadow: 0 10px 25px rgba(0,0,0,0.2); overflow: hidden; }
.modal-hdr { display: flex; align-items: center; justify-content: space-between; padding: 20px 24px; border-bottom: 1px solid #e2e8f0; background: #f8fafc; }
.modal-title { font-size: 17px; font-weight: 700; color: #0f172a; }
.modal-close { background: none; border: none; color: #94a3b8; cursor: pointer; font-size: 22px; padding: 0; transition: color 0.2s; }
.modal-close:hover { color: #ef4444; }
.modal-body { padding: 24px; overflow-y: auto; flex: 1; min-height: 0; }
.modal-footer { padding: 16px 24px; border-top: 1px solid #e2e8f0; display: flex; gap: 8px; justify-content: flex-end; background: #f8fafc; }
.modal-box > form {
    display: flex;
    flex-direction: column;
    flex: 1;
    min-height: 0;
    overflow: hidden;
}
/* FORM & DETAILED BOX */
.form-group { display: flex; flex-direction: column; gap: 8px; margin-bottom: 16px; }
.f-label { font-size: 13px; font-weight: 600; color: #334155; }
.f-input { height: 40px; padding: 0 12px; border: 1px solid #e2e8f0; border-radius: 6px; background: #fff; font-size: 13.5px; outline: none; color: #0f172a; width: 100%; transition: border 0.2s; }
.f-input:focus { border-color: #3b82f6; }
.f-input[readonly] { background: #f8fafc; color: #64748b; cursor: default; }
.f-row { display: grid; grid-template-columns: 1fr 1fr; gap: 12px; }
.info-section { background: #f8fafc; border: 1px solid #e2e8f0; padding: 16px; margin-bottom: 20px; border-radius: 8px; }
.info-section-title { font-size: 13px; font-weight: 700; color: #0f172a; margin-bottom: 12px; border-bottom: 2px solid #0f172a; padding-bottom: 4px; }

/* ── 🚚 배송 모달 스텝바 그래픽 리디자인 ── */
.dlv-track-wrap { background: #f8fafc; border: 1px solid #e2e8f0; border-radius: 8px; padding: 24px; margin-bottom: 20px; }
.dlv-track-title { font-size: 13px; font-weight: 700; color: #0f172a; margin-bottom: 20px; }
.dlv-track { display: flex; align-items: flex-start; justify-content: center; position: relative; }
.dlv-step { display: flex; flex-direction: column; align-items: center; gap: 8px; flex: 1; position: relative; z-index: 1; cursor: pointer; }
.dlv-step-icon { width: 48px; height: 48px; border-radius: 50%; background: #e2e8f0; display: flex; align-items: center; justify-content: center; font-size: 20px; border: 3px solid #e2e8f0; transition: all .2s; }
.dlv-step-label { font-size: 12px; font-weight: 500; color: #94a3b8; text-align: center; transition: all .2s; line-height: 1.3; }

/* 스텝바 유기적 컬러 변환 */
.dlv-step.done .dlv-step-icon { background: #3b82f6; border-color: #3b82f6; color: #fff; }
.dlv-step.done .dlv-step-label { color: #3b82f6; font-weight: 600; }
.dlv-step.active .dlv-step-icon { background: #fff; border-color: #111827; box-shadow: 0 0 0 4px rgba(17, 24, 39, 0.1); transform: scale(1.1); }
.dlv-step.active .dlv-step-label { color: #111827; font-weight: 700; }
.dlv-step:hover .dlv-step-icon { transform: scale(1.08); }

.dlv-connector { flex: 1; height: 4px; background: #e2e8f0; margin-top: 22px; transition: background .2s; z-index: 0; }
.dlv-connector.done { background: #3b82f6; }
.dlv-status-label { text-align: center; margin-top: 16px; padding: 12px; background: #fff; border: 1px solid #e2e8f0; border-radius: 6px; font-size: 13.5px; font-weight: 600; color: #1e293b; }

/* 상품상세 카드 카드 팩 디자인 */
.item-card { display: flex; gap: 14px; padding: 14px 0; border-bottom: 1px solid #e2e8f0; }
.item-card:last-child { border-bottom: none; }
.item-img { width: 72px; height: 72px; object-fit: cover; border: 1px solid #e2e8f0; border-radius: 6px; flex-shrink: 0; background: #f8fafc; }
.item-img-placeholder { width: 72px; height: 72px; border: 1px solid #e2e8f0; border-radius: 6px; flex-shrink: 0; background: #f8fafc; display: flex; align-items: center; justify-content: center; font-size: 24px; }
.item-info { flex: 1; min-width: 0; text-align: left; }
.item-name { font-weight: 600; font-size: 14px; color: #111827; margin-bottom: 4px; }
.item-brand { font-size: 12px; color: #64748b; margin-bottom: 8px; }
.item-opts { display: flex; gap: 5px; flex-wrap: wrap; margin-bottom: 8px; }
.item-opt-badge { padding: 2px 8px; background: #f1f5f9; border-radius: 4px; font-size: 11px; color: #475569; font-weight: 500; }
.item-price-row { display: flex; align-items: center; justify-content: space-between; }
.item-qty { font-size: 12px; color: #64748b; }
.item-price { font-weight: 700; font-size: 15px; color: #0f172a; font-family: 'Space Grotesk', sans-serif; }

.toast { position: fixed; bottom: 30px; left: 50%; transform: translateX(-50%) translateY(20px); background: #111827; color: #fff; padding: 12px 24px; border-radius: 8px; font-size: 14px; font-weight: 500; opacity: 0; transition: all .3s; z-index: 9999; pointer-events: none; box-shadow: 0 4px 12px rgba(0,0,0,0.15); }
.toast.show { opacity: 1; transform: translateX(-50%) translateY(0); }
</style>
</head>
<body>

<%@ include file="../../common/shopAdminHeader.jsp"%>

<div class="main">
  <c:set var="pageTitle" value="배송 관리" scope="request" />
  <jsp:include page="/WEB-INF/views/common/sub_title.jsp" />

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
        <div class="stat-val" style="color:#d9480f">${statusCount.wait}</div>
        <div class="stat-change">📦 처리 필요</div>
      </div>
      <div class="stat-card ${statusSel eq '2' ? 'active' : ''}"
           onclick="location.href='${pageContext.request.contextPath}/shop/delivery/deliveryForm.do?status=2'">
        <div class="stat-label">배송준비중</div>
        <div class="stat-val" style="color:#0369a1">${statusCount.ready}</div>
        <div class="stat-change">🏭 준비 중</div>
      </div>
      <div class="stat-card ${statusSel eq '3' ? 'active' : ''}"
           onclick="location.href='${pageContext.request.contextPath}/shop/delivery/deliveryForm.do?status=3'">
        <div class="stat-label">배송중</div>
        <div class="stat-val" style="color:#2563eb">${statusCount.shipping}</div>
        <div class="stat-change">🚚 이동 중</div>
      </div>
      <div class="stat-card ${statusSel eq '4' ? 'active' : ''}"
           onclick="location.href='${pageContext.request.contextPath}/shop/delivery/deliveryForm.do?status=4'">
        <div class="stat-label">배송완료</div>
        <div class="stat-val" style="color:#059669">${statusCount.done}</div>
        <div class="stat-change">✅ 완료</div>
      </div>
    </div>

    <form action="${pageContext.request.contextPath}/shop/delivery/deliveryForm.do" method="get" class="toolbar">
      <input type="hidden" name="status" value="${statusSel}">
      <div class="search-wrap">
        <span class="search-ico"><i class="fa-solid fa-magnifying-glass"></i></span>
        <input type="text" name="keyword" value="${keyword}" placeholder="수령인, 송장번호, 주문번호 검색">
      </div>
      <button type="submit" class="btn btn-outline"><i class="fa-solid fa-rotate-right"></i> 조회</button>
      <a href="${pageContext.request.contextPath}/shop/delivery/deliveryForm.do?status=5"
         class="btn btn-danger">🚫 취소 목록</a>
    </form>

    <div class="tbl-wrap">
      <table>
        <thead>
          <tr>
            <th style="width:90px;">배송번호</th>
            <th style="width:100px;">주문번호</th>
            <th>회원명</th>
            <th>수령인</th>
            <th style="width:130px; text-align: right;">결제금액</th>
            <th style="width:130px;">배송상태</th>
            <th style="width:110px;">택배사</th>
            <th style="width:160px;">송장번호</th>
            <th style="width:140px;">주문일시</th>
            <th style="width:220px;">관리</th>
          </tr>
        </thead>
        <%-- 🌟 id="deliveryTbody" 추가 🌟 --%>
        <tbody id="deliveryTbody">
          <c:forEach var="d" items="${deliveryList}">
            <%-- 🌟 class="delivery-row" 추가 🌟 --%>
            <tr class="delivery-row">
              <td style="color:#64748b; font-size:13px; font-family: 'Space Grotesk', sans-serif;">${d.dlvNum}</td>
              <td style="font-size:13px; font-family: 'Space Grotesk', sans-serif;">${d.orderNum}</td>
              <td style="font-weight:600; color:#0f172a;">${d.userName}</td>
              <td>${d.recvName}</td>
              <td style="text-align: right; font-weight:600; font-family: 'Space Grotesk';"><fmt:formatNumber value="${d.payPrice}" pattern="#,###"/>원</td>
              <td>
                <c:choose>
                  <c:when test="${d.dlvStatus == 1}"><span class="badge b-wait">● 배송대기</span></c:when>
                  <c:when test="${d.dlvStatus == 2}"><span class="badge b-ready">● 준비중</span></c:when>
                  <c:when test="${d.dlvStatus == 3}"><span class="badge b-shipping">● 배송중</span></c:when>
                  <c:when test="${d.dlvStatus == 4}"><span class="badge b-done">● 완료</span></c:when>
                  <c:when test="${d.dlvStatus == 5}"><span class="badge b-cancel">● 취소</span></c:when>
                </c:choose>
              </td>
              <td style="font-size:13px; color:#475569">${empty d.courier ? '-' : d.courier}</td>
              <td style="font-size:13px; color:#475569; font-family: 'Space Grotesk';">${empty d.invoiceNo ? '-' : d.invoiceNo}</td>
              <td style="font-size:13px; color:#64748b">${d.orderCreatedAt}</td>
              <td>
                <div style="display:flex; gap:5px; flex-wrap:wrap; justify-content:center;">
                  <button class="btn btn-green btn-xs"
                    onclick="openDetailModal(
                      ${d.orderNum},
                      '${d.recvName}',
                      '${d.orderCreatedAt}',
                      ${d.payPrice})">
                    📋 상세
                  </button>

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
                    <span style="font-size:12px; color:#94a3b8; font-weight: 500;">처리완료</span>
                  </c:if>
                </div>
              </td>
            </tr>
          </c:forEach>
          <c:if test="${empty deliveryList}">
            <tr>
              <td colspan="10" style="text-align:center; padding:60px 0; color:#94a3b8;">
                <i class="fa-solid fa-truck-fast" style="font-size:32px; display:block; margin-bottom:12px; color:#e2e8f0;"></i>해당 배송 정보가 없습니다.
              </td>
            </tr>
          </c:if>
        </tbody>
      </table>

      <%-- 🌟 PAGINATION HTML (새로 추가됨) 🌟 --%>
      <div class="pagination-wrap" id="deliveryPagination" style="display:none;">
        <div class="page-info" id="deliveryPageInfo">총 <strong>0</strong>건</div>
        <div class="page-btns" id="deliveryPageBtns"></div>
      </div>

    </div>

  </div>
</div>

<div class="modal-overlay" id="modal-detail">
  <div class="modal-box" style="width:620px">
    <div class="modal-hdr">
      <div class="modal-title">📋 주문 상품 상세</div>
      <button type="button" class="modal-close" onclick="closeModal('modal-detail')"><i class="fa-solid fa-xmark"></i></button>
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
          <div style="text-align:center; padding:30px; color:#94a3b8;"><i class="fa-solid fa-spinner fa-spin"></i> 불러오는 중...</div>
        </div>
        <div style="border-top:2px solid #111827; padding-top:16px; margin-top:16px; display:flex; justify-content:space-between; align-items:center">
          <span style="font-size:13px; color:#64748b; font-weight: 500;">총 결제금액</span>
          <span id="detailTotalPrice" style="font-size:22px; font-weight:800; color:#ef4444; font-family:'Space Grotesk';"></span>
        </div>
      </div>

    </div>
    <div class="modal-footer">
      <button type="button" class="btn btn-black" onclick="closeModal('modal-detail')">닫기</button>
    </div>
  </div>
</div>

<div class="modal-overlay" id="modal-update">
  <div class="modal-box">
    <div class="modal-hdr">
      <div class="modal-title">🚚 배송 정보 수정</div>
      <button type="button" class="modal-close" onclick="closeModal('modal-update')"><i class="fa-solid fa-xmark"></i></button>
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
              <select class="f-input" name="courier" id="updateCourier" style="height:40px; padding:0 12px; cursor:pointer;">
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
          <div id="trackBtnWrap" style="display:none; margin-top:8px">
            <button type="button" class="btn btn-outline" style="width:100%" onclick="trackDelivery()">
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
        '<div style="text-align:center; padding:30px; color:#9ca3af"><i class="fa-solid fa-spinner fa-spin"></i> 불러오는 중...</div>';
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
            
            // 🚨 이 부분을 수정해 주세요! (경로 중간에 '/upload/' 추가)
            var imgHtml = (item.prodImgUrl && item.prodImgUrl !== '')
                ? '<img class="item-img" src="' + ctxPath + '/upload/' + item.prodImgUrl + '" onerror="this.outerHTML=\'<div class=item-img-placeholder>👟</div>\'">'
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
                '<div style="text-align:center;padding:30px;color:#ef4444">❌ 상품 정보 조회에 실패했습니다.</div>';
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

// 🌟 PAGINATION JAVASCRIPT LOGIC (새로 추가됨) 🌟
let currentDeliveryPage = 1;
const deliveryItemsPerPage = 10; // 한 페이지에 보여줄 개수
let allDeliveryRows = [];

window.addEventListener('load', function() {
    const tbody = document.getElementById('deliveryTbody');
    if (tbody) {
        allDeliveryRows = Array.from(tbody.querySelectorAll('tr.delivery-row'));
        if (allDeliveryRows.length > 0) {
            renderDeliveryTable();
        } else {
            document.getElementById('deliveryPagination').style.display = 'none';
        }
    }
});

function renderDeliveryTable() {
    allDeliveryRows.forEach(r => r.style.display = 'none');
    const start = (currentDeliveryPage - 1) * deliveryItemsPerPage;
    const end = start + deliveryItemsPerPage;
    
    for (let i = start; i < end && i < allDeliveryRows.length; i++) {
        allDeliveryRows[i].style.display = '';
    }
    renderDeliveryPagination();
}

function renderDeliveryPagination() {
    const totalPages = Math.ceil(allDeliveryRows.length / deliveryItemsPerPage);
    const pw = document.getElementById('deliveryPagination');
    const pi = document.getElementById('deliveryPageInfo');
    const pb = document.getElementById('deliveryPageBtns');

    if (!pw || !pb) return;

    if (allDeliveryRows.length === 0) {
        pw.style.display = 'none';
        return;
    }

    pw.style.display = 'flex';
    const sn = (currentDeliveryPage - 1) * deliveryItemsPerPage + 1;
    const en = Math.min(currentDeliveryPage * deliveryItemsPerPage, allDeliveryRows.length);
    
    // JSP 처리 방지를 위해 \${} 이스케이프 사용
    pi.innerHTML = `총 <strong style="color:#0f172a">\${allDeliveryRows.length}</strong>건 · \${sn}-\${en}`;

    let h = `<div class="pg-btn \${currentDeliveryPage === 1 ? 'disabled' : ''}" onclick="changeDeliveryPage(\${currentDeliveryPage - 1})">‹</div>`;

    // 최대 9개의 버튼만 보여지도록 제한
    let maxVisible = 9;
    let startPage = Math.max(1, currentDeliveryPage - Math.floor(maxVisible / 2));
    let endPage = Math.min(totalPages, startPage + maxVisible - 1);

    if (endPage - startPage + 1 < maxVisible) {
        startPage = Math.max(1, endPage - maxVisible + 1);
    }

    for (let i = startPage; i <= endPage; i++) {
        h += `<div class="pg-btn \${i === currentDeliveryPage ? 'on' : ''}" onclick="changeDeliveryPage(\${i})">\${i}</div>`;
    }

    h += `<div class="pg-btn \${currentDeliveryPage === totalPages ? 'disabled' : ''}" onclick="changeDeliveryPage(\${currentDeliveryPage + 1})">›</div>`;
    pb.innerHTML = h;
}

function changeDeliveryPage(p) {
    const totalPages = Math.ceil(allDeliveryRows.length / deliveryItemsPerPage);
    if (p < 1 || p > totalPages) return;
    currentDeliveryPage = p;
    renderDeliveryTable();
}
</script>
</body>
</html>