<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>ShoeMall - 마이페이지</title>
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700;900&family=Space+Grotesk:wght@600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/KR_style.css">
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<style>
body { background: #f2f3f5; }

/* ── 전체 wrap ── */
.wrap { max-width: 1200px; margin: 0 auto; padding: 32px 24px 80px; }
.page-title { font-size: 22px; font-weight: 900; letter-spacing: -0.5px; color: #0d0d0d; margin-bottom: 24px; }

/* ── 레이아웃 ── */
.my-layout {
    display: grid;
    grid-template-columns: 210px 1fr;
    gap: 20px;
    align-items: start;
}

/* ── 왼쪽 메뉴 ── */
.my-menu {
    background: #fff;
    border: 1px solid #e4e6ea;
    border-radius: 12px;
    overflow: hidden;
    position: sticky;
    top: 80px;
}
.my-menu-hdr {
    padding: 18px 18px 14px;
    font-size: 15px; font-weight: 800;
    color: #0d0d0d; letter-spacing: -0.3px;
    border-bottom: 1px solid #f0f0f0;
    background: #fafafa;
}
.my-menu-item {
    padding: 13px 18px;
    font-size: 13px; font-weight: 500;
    color: #666; cursor: pointer;
    border-bottom: 1px solid #f5f5f5;
    transition: background .12s, color .12s;
    display: flex; align-items: center; gap: 8px;
}
.my-menu-item:last-child { border-bottom: none; }
.my-menu-item:hover { background: #f8f8f8; color: #0d0d0d; }
.my-menu-item.on {
    background: #f0f6ff;
    color: #1a6ef5;
    font-weight: 700;
    border-left: 3px solid #1a6ef5;
}

/* ── 오른쪽 본문 ── */
.my-body {
    background: #fff;
    border: 1px solid #e4e6ea;
    border-radius: 12px;
    padding: 28px;
    min-height: 500px;
}
.my-sub { display: none; }
.my-sub.on { display: block; }

/* ── 섹션 타이틀 ── */
.sec-title {
    font-size: 15px; font-weight: 800;
    color: #0d0d0d; letter-spacing: -0.3px;
    margin-bottom: 16px;
    display: flex; align-items: center; justify-content: space-between;
}

/* ── 등급 카드 ── */
.grade-card {
    background: linear-gradient(135deg, #0d0d0d 0%, #1a2a4a 100%);
    border-radius: 12px;
    padding: 24px;
    margin-bottom: 24px;
    color: #fff;
    position: relative;
    overflow: hidden;
}
.grade-card::before {
    content: '';
    position: absolute; top: -40px; right: -40px;
    width: 180px; height: 180px;
    background: rgba(26,110,245,.15);
    border-radius: 50%;
}
.grade-card-top {
    display: flex;
    justify-content: space-between;
    align-items: flex-end;
    margin-bottom: 20px;
    position: relative;
}
.grade-label { font-size: 11px; color: rgba(255,255,255,.5); margin-bottom: 4px; text-transform: uppercase; letter-spacing: .08em; }
.grade-name { font-size: 26px; font-weight: 900; color: #fff; letter-spacing: -0.5px; font-family: 'Space Grotesk', sans-serif; }
.grade-next { text-align: right; font-size: 12px; color: rgba(255,255,255,.55); line-height: 1.5; }
.grade-next strong { color: #fff; font-weight: 700; }
.grade-remain { color: #60a5fa; font-size: 16px; font-weight: 800; display: block; margin-top: 2px; }
.grade-bar-wrap { position: relative; }
.grade-bar-bg {
    width: 100%; height: 8px;
    background: rgba(255,255,255,.15);
    border-radius: 4px; overflow: hidden;
}
.grade-bar-fill {
    height: 100%;
    background: linear-gradient(90deg, #1a6ef5, #60a5fa);
    border-radius: 4px;
    transition: width .6s ease;
}
.grade-bar-info {
    display: flex; justify-content: space-between;
    font-size: 11px; color: rgba(255,255,255,.4);
    margin-top: 6px;
}

/* ── 탭 ── */
.tabs {
    display: flex;
    border-bottom: 2px solid #f0f0f0;
    margin-bottom: 20px;
    gap: 0;
}
.tab {
    padding: 10px 18px;
    font-size: 13px; font-weight: 500;
    color: #aaa; cursor: pointer;
    border-bottom: 2px solid transparent;
    margin-bottom: -2px;
    transition: color .15s, border-color .15s;
}
.tab:hover { color: #0d0d0d; }
.tab.on { color: #0d0d0d; font-weight: 700; border-bottom-color: #0d0d0d; }

/* ── 주문 카드 ── */
.order-card {
    border: 1px solid #e8e8e8;
    border-radius: 10px;
    margin-bottom: 12px;
    background: #fff;
    overflow: hidden;
    transition: box-shadow .15s;
}
.order-card:hover { box-shadow: 0 2px 12px rgba(0,0,0,.06); }
.order-hdr {
    display: flex; align-items: center; gap: 10px;
    padding: 12px 16px;
    border-bottom: 1px solid #f5f5f5;
    background: #fafafa;
}
.order-num { font-size: 12px; font-weight: 700; color: #555; font-family: 'Space Grotesk', sans-serif; }
.badge { display: inline-flex; align-items: center; padding: 3px 10px; border-radius: 20px; font-size: 11px; font-weight: 700; }
.b-orange { background: #fff3e0; color: #e65100; }
.b-blue   { background: #e3f2fd; color: #1565c0; }
.b-green  { background: #e8f5e9; color: #1b5e20; }
.b-red    { background: #ffebee; color: #b71c1c; }
.b-gray   { background: #f1f5f9; color: #64748b; }

.order-body {
    display: flex; gap: 14px;
    padding: 14px 16px;
    align-items: center;
    border-bottom: 1px solid #f8f8f8;
}
.order-body:last-of-type { border-bottom: none; }
.order-thumb {
    width: 64px; height: 64px; flex-shrink: 0;
    border-radius: 8px; overflow: hidden;
    border: 1px solid #eee; background: #f8f8f8;
}
.order-info-name { font-size: 13px; font-weight: 600; color: #0d0d0d; margin-bottom: 3px; }
.order-info-price { font-size: 14px; font-weight: 800; color: #0d0d0d; letter-spacing: -0.3px; }
.order-foot {
    display: flex; gap: 8px;
    padding: 10px 16px;
    border-top: 1px solid #f5f5f5;
    background: #fafafa;
}

/* ── 폼 공통 ── */
.form-sec { border: none; padding: 0; max-width: 100%; }
.form-group { margin-bottom: 16px; }
.form-label {
    font-size: 11px; font-weight: 700;
    color: #888; letter-spacing: .06em;
    text-transform: uppercase;
    margin-bottom: 8px; display: block;
}
.form-input {
    width: 100%; height: 44px;
    padding: 0 14px;
    border: 1.5px solid #e4e6ea;
    border-radius: 8px;
    font-size: 14px; color: #0d0d0d;
    font-family: inherit; outline: none;
    background: #fff;
    transition: border-color .18s, box-shadow .18s;
}
.form-input:focus { border-color: #0d0d0d; box-shadow: 0 0 0 3px rgba(0,0,0,.06); }
.form-input[readonly] { background: #f8f9fb; color: #aaa; }
select.form-input { cursor: pointer; }
textarea.form-input {
    height: auto; min-height: 90px;
    padding: 12px 14px; resize: vertical;
}
.form-row { display: grid; grid-template-columns: 1fr 1fr; gap: 14px; }
.input-with-btn { display: flex; gap: 8px; }
.input-with-btn .form-input { flex: 1; }

/* ── 버튼 ── */
.btn { padding: 10px 18px; border: none; cursor: pointer; font-size: 13px; font-weight: 700; font-family: inherit; transition: all .15s; display: inline-flex; align-items: center; justify-content: center; gap: 6px; border-radius: 6px; }
.btn-black { background: #0d0d0d; color: #fff; }
.btn-black:hover { background: #333; }
.btn-red { background: #fee2e2; color: #dc2626; border: 1px solid #fca5a5; }
.btn-red:hover { background: #fecaca; }
.btn-outline { background: #fff; color: #555; border: 1.5px solid #e4e6ea; }
.btn-outline:hover { border-color: #0d0d0d; color: #0d0d0d; }
.btn-gray { background: #f5f5f5; color: #666; border: 1px solid #e4e6ea; }
.btn-sm { padding: 6px 14px; font-size: 12px; }

/* ── 빈 상태 ── */
.my-empty {
    text-align: center; padding: 60px 0;
    color: #ccc; font-size: 14px;
    background: #fafafa; border-radius: 8px;
    border: 1px solid #f0f0f0;
}

/* ── 탈퇴 경고 ── */
.delete-warn {
    background: #fff5f5; color: #b71c1c;
    padding: 18px 20px; border-radius: 8px;
    margin-bottom: 24px; font-size: 13px;
    line-height: 1.7; border: 1px solid #fecaca;
}

/* ── 모달 공통 ── */
.modal-overlay {
    display: none; position: fixed; inset: 0;
    background: rgba(0,0,0,.5); z-index: 9999;
    align-items: center; justify-content: center;
}
.modal-box {
    background: #fff; width: 480px;
    border-radius: 12px; overflow: hidden;
    box-shadow: 0 16px 48px rgba(0,0,0,.2);
}
.modal-hdr {
    display: flex; align-items: center; justify-content: space-between;
    padding: 18px 24px; border-bottom: 1px solid #f0f0f0;
    background: #fafafa;
}
.modal-hdr-title { font-size: 16px; font-weight: 800; color: #0d0d0d; }
.modal-close { background: none; border: none; font-size: 22px; cursor: pointer; color: #bbb; }
.modal-close:hover { color: #555; }
.modal-body { padding: 24px; display: flex; flex-direction: column; gap: 16px; }
.modal-label { font-size: 12px; color: #888; margin-bottom: 6px; }
.modal-footer {
    padding: 14px 24px; border-top: 1px solid #f0f0f0;
    display: flex; gap: 8px; background: #fafafa;
}
.modal-footer button:first-child { flex: 1; height: 44px; background: #fff; border: 1.5px solid #e4e6ea; border-radius: 6px; cursor: pointer; font-weight: 600; font-family: inherit; }
.modal-footer button:last-child { flex: 2; height: 44px; background: #0d0d0d; color: #fff; border: none; border-radius: 6px; cursor: pointer; font-weight: 700; font-size: 15px; font-family: inherit; }

/* 반품/교환 인라인 수정폼 */
.return-edit-box {
    background: #f8f9fb; padding: 16px; border-radius: 8px;
    margin-top: 14px; border: 1px solid #e4e6ea; display: none;
}
.return-edit-title { font-weight: 700; margin-bottom: 12px; font-size: 14px; color: #0d0d0d; }
</style>
</head>
<body>
    <jsp:include page="/WEB-INF/views/common/header.jsp"/>

    <div class="wrap">
        <div class="page-title">마이페이지</div>

        <div class="my-layout">

            <%-- ── 왼쪽 메뉴 ── --%>
            <div class="my-menu">
                <div class="my-menu-hdr">${user.user_name}님</div>
                <div class="my-menu-item on"  onclick="setMy(this,'my-page')">⭐ 내 정보</div>
                <div class="my-menu-item" id="menu-orders" onclick="setMy(this,'my-orders')">🧾 주문 내역</div>
                <div class="my-menu-item" onclick="setMy(this,'my-restock')">⏰ 재입고 알림</div>
                <div class="my-menu-item" onclick="setMy(this,'my-info')">👤 내 정보 수정</div>
                <div class="my-menu-item" onclick="setMy(this,'my-return')">↩️ 반품/교환</div>
                <div class="my-menu-item" onclick="setMy(this,'my-deleteuser')">🚫 회원 탈퇴</div>
                <div class="my-menu-item"
                     onclick="location.href='${pageContext.request.contextPath}/shop/chat/userChat.do'">
                    💬 채팅 문의
                </div>
            </div>

            <%-- ── 오른쪽 본문 ── --%>
            <div class="my-body">

                <c:if test="${not empty modifyMsg}"><script>alert('${modifyMsg}');</script><c:remove var="modifyMsg" scope="session"/></c:if>
                <c:if test="${not empty cancelMsg}"><script>alert('${cancelMsg}');</script><c:remove var="cancelMsg" scope="session"/></c:if>
                <c:if test="${not empty reviewMsg}"><script>alert('${reviewMsg}');</script><c:remove var="reviewMsg" scope="session"/></c:if>

                <%-- ══ 내 정보 ══ --%>
                <div class="my-sub on" id="my-page">

                    <div class="sec-title">나의 쇼핑 혜택</div>

                    <c:set var="total_spent"   value="${empty user.total_amount ? 0 : user.total_amount}"/>
                    <c:choose>
                        <c:when test="${user.grade == 1}"><c:set var="target_amount" value="100000"/></c:when>
                        <c:when test="${user.grade == 2}"><c:set var="target_amount" value="300000"/></c:when>
                        <c:when test="${user.grade == 3}"><c:set var="target_amount" value="500000"/></c:when>
                        <c:otherwise><c:set var="target_amount" value="500000"/></c:otherwise>
                    </c:choose>
                    <c:set var="remain_amount" value="${target_amount - total_spent}"/>
                    <c:if test="${remain_amount < 0}"><c:set var="remain_amount" value="0"/></c:if>
                    <c:set var="percent" value="${(total_spent / target_amount) * 100}"/>
                    <c:if test="${percent > 100}"><c:set var="percent" value="100"/></c:if>
                    <c:if test="${user.grade >= 4}"><c:set var="percent" value="100"/></c:if>

                    <div class="grade-card">
                        <div class="grade-card-top">
                            <div>
                                <div class="grade-label">현재 등급</div>
                                <div class="grade-name">
                                    <c:choose>
                                        <c:when test="${user.grade == 1}">BRONZE</c:when>
                                        <c:when test="${user.grade == 2}">SILVER</c:when>
                                        <c:when test="${user.grade == 3}">GOLD</c:when>
                                        <c:when test="${user.grade == 4}">VIP</c:when>
                                        <c:otherwise>일반회원</c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                            <div class="grade-next">
                                다음 등급
                                <strong>
                                    <c:choose>
                                        <c:when test="${user.grade == 1}">SILVER</c:when>
                                        <c:when test="${user.grade == 2}">GOLD</c:when>
                                        <c:when test="${user.grade == 3}">VIP</c:when>
                                        <c:when test="${user.grade == 4}">최고 등급</c:when>
                                        <c:otherwise>BRONZE</c:otherwise>
                                    </c:choose>
                                </strong>까지
                                <c:choose>
                                    <c:when test="${user.grade >= 4}">
                                        <span class="grade-remain">최고 등급! 🎉</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="grade-remain"><fmt:formatNumber value="${remain_amount}" pattern="#,###"/>원</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                        <div class="grade-bar-wrap">
                            <div class="grade-bar-bg">
                                <div class="grade-bar-fill" style="width:${percent}%"></div>
                            </div>
                            <div class="grade-bar-info">
                                <span>누적: <fmt:formatNumber value="${total_spent}" pattern="#,###"/>원</span>
                                <span>목표: <fmt:formatNumber value="${target_amount}" pattern="#,###"/>원</span>
                            </div>
                        </div>
                    </div>

                    <div class="sec-title" style="margin-top:28px;">
                        최근 주문 현황
                        <a onclick="document.getElementById('menu-orders').click()"
                           style="cursor:pointer;font-size:12px;color:#1a6ef5;font-weight:600;">더보기 →</a>
                    </div>

                    <c:if test="${empty recentOrderList}">
                        <div class="my-empty">최근 주문하신 내역이 없습니다.</div>
                    </c:if>
                    <c:forEach var="order" items="${recentOrderList}">
                        <div class="order-card">
                            <div class="order-hdr">
                                <span class="order-num">#${order.order_num}</span>
                                <c:choose>
                                    <c:when test="${order.order_status == 1}"><span class="badge b-orange">📦 배송대기</span></c:when>
                                    <c:when test="${order.order_status == 2}"><span class="badge" style="background:#e0f2fe;color:#0369a1;">🏭 배송준비중</span></c:when>
                                    <c:when test="${order.order_status == 3}"><span class="badge b-blue">🚚 배송중</span></c:when>
                                    <c:when test="${order.order_status == 4}"><span class="badge" style="background:#dcfce7;color:#15803d;">✅ 배송완료</span></c:when>
                                    <c:when test="${order.order_status == 5}"><span class="badge" style="background:#fef2f2;color:#dc2626;">🚫 취소됨</span></c:when>
                                </c:choose>
                            </div>
                            <div class="order-body">
                                <div class="order-thumb">
                                    <img src="${pageContext.request.contextPath}/upload/${order.prod_img_url}"
                                         style="width:100%;height:100%;object-fit:cover;" alt="상품이미지">
                                </div>
                                <div>
                                    <div class="order-info-name">${order.prod_name}</div>
                                    <div class="order-info-price"><fmt:formatNumber value="${order.pay_price}" pattern="#,###"/>원</div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>

                <%-- ══ 재입고 알림 ══ --%>
                <div class="my-sub" id="my-restock">
                    <div class="sec-title">신청한 재입고 알림</div>
                    <c:if test="${empty restockList}">
                        <div class="my-empty">신청하신 재입고 알림 내역이 없습니다.</div>
                    </c:if>
                    <c:forEach var="restock" items="${restockList}">
                        <div class="order-card">
                            <div class="order-hdr">
                                <span class="order-num">신청일: ${restock.reg_date}</span>
                                <c:choose>
                                    <c:when test="${restock.sent_yn eq 'Y'}">
                                        <span class="badge" style="background:#e8f5e9;color:#2e7d32;margin-left:auto;">✅ 재입고 완료</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge b-gray" style="margin-left:auto;">⏳ 입고 대기중</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <div class="order-body">
                                <div class="order-thumb">
                                    <img src="${pageContext.request.contextPath}/upload/${restock.prod_img_url}"
                                         style="width:100%;height:100%;object-fit:cover;" alt="상품이미지">
                                </div>
                                <div style="flex:1;">
                                    <div style="font-size:11px;color:#aaa;font-weight:700;text-transform:uppercase;letter-spacing:.04em;margin-bottom:3px;">${restock.brand_name}</div>
                                    <div class="order-info-name">${restock.prod_name}</div>
                                    <div style="font-size:12px;color:#aaa;margin-top:3px;">${restock.color} / ${restock.size_val}</div>
                                </div>
                                <c:if test="${restock.sent_yn ne 'Y'}">
                                    <form action="${pageContext.request.contextPath}/shop/restock/restockCancel.do" method="post"
                                          onsubmit="return confirm('재입고 알림 신청을 취소하시겠습니까?')">
                                        <input type="hidden" name="alert_num" value="${restock.alert_num}">
                                        <button type="submit" class="btn btn-outline btn-sm">알림 취소</button>
                                    </form>
                                </c:if>
                            </div>
                        </div>
                    </c:forEach>
                </div>

                <%-- ══ 주문 내역 ══ --%>
                <div class="my-sub" id="my-orders">
                    <div class="tabs">
                        <div class="tab on" onclick="filterOrders(this, 0)">전체</div>
                        <div class="tab" onclick="filterOrders(this, 1)">배송대기</div>
                        <div class="tab" onclick="filterOrders(this, 4)">배송완료</div>
                    </div>
                    <c:if test="${empty groupedOrders}">
                        <div class="my-empty">주문하신 내역이 없습니다.</div>
                    </c:if>
                    <c:forEach var="entry" items="${groupedOrders}">
                        <c:set var="items"     value="${entry.value}"/>
                        <c:set var="firstItem" value="${items[0]}"/>
                        <div class="order-card order-item" data-status="${firstItem.order_status}" style="margin-top:12px;">
                            <div class="order-hdr">
                                <span class="order-num">#${firstItem.order_num}</span>
                                <c:choose>
                                    <c:when test="${firstItem.order_status == 1}"><span class="badge b-orange">📦 배송대기</span></c:when>
                                    <c:when test="${firstItem.order_status == 2}"><span class="badge" style="background:#e0f2fe;color:#0369a1;">🏭 배송준비중</span></c:when>
                                    <c:when test="${firstItem.order_status == 3}"><span class="badge b-blue">🚚 배송중</span></c:when>
                                    <c:when test="${firstItem.order_status == 4}"><span class="badge" style="background:#dcfce7;color:#15803d;">✅ 배송완료</span></c:when>
                                    <c:when test="${firstItem.order_status == 5}"><span class="badge" style="background:#fef2f2;color:#dc2626;">🚫 취소됨</span></c:when>
                                </c:choose>
                                <span style="font-size:11px;color:#bbb;margin-left:auto;">${firstItem.order_created_at}</span>
                            </div>
                            <c:forEach var="item" items="${items}">
                                <div class="order-body" style="border-bottom:1px solid #f5f5f5;padding-bottom:14px;margin-bottom:0;">
                                    <div class="order-thumb">
                                        <img src="${pageContext.request.contextPath}/upload/${item.prod_img_url}"
                                             style="width:100%;height:100%;object-fit:cover;" alt="상품이미지">
                                    </div>
                                    <div style="flex:1;">
                                        <div class="order-info-name">${item.prod_name}</div>
                                        <div style="font-size:12px;color:#aaa;margin-top:2px;">${item.opt_info} · ${item.order_item_qty}개</div>
                                        <div class="order-info-price"><fmt:formatNumber value="${item.order_item_price * item.order_item_qty}" pattern="#,###"/>원</div>
                                    </div>
                                    <c:if test="${firstItem.order_status == 4}">
                                        <div style="display:flex;flex-direction:column;gap:6px;flex-shrink:0;">
                                            <c:if test="${item.review_num == 0}">
                                                <button class="btn btn-black btn-sm"
                                                        onclick="openReviewModal(${item.order_num},${item.prod_num},'${item.prod_name}')">✏️ 리뷰 작성</button>
                                            </c:if>
                                            <c:if test="${item.review_num != 0}">
                                                <button class="btn btn-outline btn-sm"
                                                        onclick="openEditReviewModal(${item.review_num},${item.review_rating},'${item.review_content}','${item.prod_name}')">🖊️ 리뷰 수정</button>
                                                <form action="${pageContext.request.contextPath}/shop/review/deleteReview.do" method="post"
                                                      onsubmit="return confirm('리뷰를 삭제하시겠습니까?')">
                                                    <input type="hidden" name="reviewNum" value="${item.review_num}">
                                                    <button type="submit" class="btn btn-red btn-sm">🗑️ 삭제</button>
                                                </form>
                                            </c:if>
                                        </div>
                                    </c:if>
                                </div>
                            </c:forEach>
                            <div style="text-align:right;font-size:12px;color:#aaa;padding:8px 16px 4px;">
                                총 결제금액: <strong style="color:#0d0d0d;font-size:15px;">
                                    <fmt:formatNumber value="${firstItem.pay_price}" pattern="#,###"/>원
                                </strong>
                            </div>
                            <div class="order-foot">
                                <c:choose>
                                    <c:when test="${firstItem.order_status == 1}">
                                        <form action="${pageContext.request.contextPath}/shop/user/orderCancel.do" method="post"
                                              onsubmit="return confirm('주문 #${firstItem.order_num}을 취소하시겠습니까?')">
                                            <input type="hidden" name="orderNum" value="${firstItem.order_num}">
                                            <button type="submit" class="btn btn-red btn-sm">🚫 주문 취소</button>
                                        </form>
                                    </c:when>
                                    <c:when test="${firstItem.order_status == 4}">
                                        <button class="btn btn-outline btn-sm"
                                                onclick="setMy(document.querySelector('.my-menu-item:nth-child(6)'),'my-return')">↩️ 반품/교환</button>
                                    </c:when>
                                    <c:when test="${firstItem.order_status == 5}">
                                        <span style="font-size:12px;color:#bbb;">처리 완료된 주문입니다.</span>
                                    </c:when>
                                </c:choose>
                            </div>
                        </div>
                    </c:forEach>
                    <div id="order-pagination" class="pagination" style="margin-top: 24px; padding-bottom: 20px;"></div>
                </div>

                <%-- ══ 내 정보 수정 ══ --%>
                <div class="my-sub" id="my-info">
                    <div class="sec-title">내 정보 수정</div>
                    <form action="${pageContext.request.contextPath}/shop/user/modify.do" method="post" id="modifyForm">
                        <div class="form-sec">
                            <div class="form-group">
                                <label class="form-label">아이디</label>
                                <input class="form-input" name="id" value="${user.user_id}" readonly>
                            </div>
                            <div class="form-row">
                                <div class="form-group">
                                    <label class="form-label">이름</label>
                                    <input class="form-input" name="name" value="${user.user_name}">
                                </div>
                                <div class="form-group">
                                    <label class="form-label">연락처</label>
                                    <input class="form-input" name="phone" value="${user.phone}">
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="form-label">이메일</label>
                                <input class="form-input" type="email" name="email" value="${user.email}">
                            </div>
                            <div class="form-group">
                                <label class="form-label">주소</label>
                                <div class="input-with-btn" style="margin-bottom:8px;">
                                    <input class="form-input" name="zipcode" id="zipcode" value="${user.zipcode}" readonly style="flex:0 0 110px;width:110px;">
                                    <button type="button" class="btn btn-outline btn-sm" onclick="execDaumPostcode()">우편번호 찾기</button>
                                </div>
                                <input class="form-input" name="addr1" id="addr1" value="${user.addr1}" readonly style="margin-bottom:8px;display:block;">
                                <input class="form-input" name="addr2" id="addr2" value="${user.addr2}" placeholder="상세주소" style="display:block;">
                            </div>
                            <div class="form-group">
                                <label class="form-label">현재 비밀번호 (필수)</label>
                                <input class="form-input" type="password" name="passwd" placeholder="정보를 수정하려면 현재 비밀번호를 입력하세요">
                            </div>
                            <div class="form-row">
                                <div class="form-group">
                                    <label class="form-label">새 비밀번호</label>
                                    <input class="form-input" type="password" name="new_passwd" placeholder="변경 시에만 입력">
                                </div>
                                <div class="form-group">
                                    <label class="form-label">비밀번호 확인</label>
                                    <input class="form-input" type="password" name="new_passwd_confirm" placeholder="변경 시에만 입력">
                                </div>
                            </div>
                            <button type="submit" class="btn btn-black" style="width:100%;height:48px;font-size:14px;margin-top:4px;">정보 수정하기</button>
                        </div>
                    </form>
                </div>

                <%-- ══ 반품/교환 ══ --%>
                <div class="my-sub" id="my-return">
                    <div class="tabs" id="return-tabs" style="margin-bottom:24px;">
                        <div class="tab on" onclick="switchReturnTab('available')">신청하기</div>
                        <div class="tab" onclick="switchReturnTab('history')">신청 내역 조회</div>
                    </div>
                    <div id="return-available" style="display:block;">
                        <form action="${pageContext.request.contextPath}/shop/user/returnRequest.do" method="post">
                            <div class="form-sec">
                                <div class="form-group">
                                    <label class="form-label">반품/교환할 상품 선택 (배송완료 상품만 가능)</label>
                                    <select class="form-input" name="item_info" required>
                                        <option value="">상품을 선택해 주세요</option>
                                        <c:set var="itemCount" value="0"/>
                                        <c:forEach var="item" items="${deliveredItemList}">
                                            <option value="${item.order_num}_${item.prod_num}_${item.opt_num}">
                                                [주문 #${item.order_num}] ${item.prod_name} (옵션: ${item.opt_info == null ? '단일옵션' : item.opt_info})
                                            </option>
                                            <c:set var="itemCount" value="${itemCount + 1}"/>
                                        </c:forEach>
                                        <c:if test="${itemCount == 0}">
                                            <option value="" disabled>선택할 수 있는 배송완료 상품이 없습니다</option>
                                        </c:if>
                                    </select>
                                </div>
                                <div class="form-group">
                                    <label class="form-label">신청 유형</label>
                                    <div style="display:flex;gap:20px;margin-top:6px;">
                                        <label style="display:flex;align-items:center;gap:6px;font-size:13px;cursor:pointer;"><input type="radio" name="tp" value="1" checked>반품</label>
                                        <label style="display:flex;align-items:center;gap:6px;font-size:13px;cursor:pointer;"><input type="radio" name="tp" value="2">교환</label>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="form-label">사유</label>
                                    <select class="form-input" name="reason">
                                        <option value="단순 변심">단순 변심</option>
                                        <option value="사이즈 불량">사이즈 불량</option>
                                        <option value="상품 불량">상품 불량</option>
                                        <option value="오배송">오배송</option>
                                        <option value="기타">기타</option>
                                    </select>
                                </div>
                                <div class="form-group">
                                    <label class="form-label">상세 내용</label>
                                    <textarea class="form-input" name="ret_note" placeholder="자세한 내용을 입력해주세요"></textarea>
                                </div>
                                <button type="submit" class="btn btn-black" style="width:100%;height:48px;margin-top:4px;">신청하기</button>
                            </div>
                        </form>
                    </div>
                    <div id="return-history" style="display:none;">
                        <c:if test="${empty returnList}">
                            <div class="my-empty">신청하신 반품/교환 내역이 없습니다.</div>
                        </c:if>
                        <c:forEach var="ret" items="${returnList}">
                            <div class="order-card" style="margin-bottom:12px;">
                                <div class="order-hdr">
                                    <span class="order-num">신청번호: #${ret.ret_num} (원주문: #${ret.order_num})</span>
                                    <c:choose>
                                        <c:when test="${ret.ret_status == 1}"><span class="badge b-gray">처리 대기중</span></c:when>
                                        <c:when test="${ret.ret_status == 2}"><span class="badge b-blue">수거 진행중</span></c:when>
                                        <c:when test="${ret.ret_status == 3}"><span class="badge" style="background:#e8f5e9;color:#2e7d32;">처리 완료</span></c:when>
                                        <c:when test="${ret.ret_status == 4}"><span class="badge b-red">반려됨</span></c:when>
                                        <c:otherwise><span class="badge b-gray">상태 미상</span></c:otherwise>
                                    </c:choose>
                                </div>
                                <div class="order-body">
                                    <div class="order-thumb">
                                        <img src="${pageContext.request.contextPath}/upload/${ret.prod_img_url}"
                                             style="width:100%;height:100%;object-fit:cover;" alt="상품이미지">
                                    </div>
                                    <div style="flex:1;">
                                        <div class="order-info-name">
                                            <strong style="color:var(--blue);">[${ret.tp == 1 ? '반품' : '교환'}]</strong> ${ret.prod_name}
                                        </div>
                                        <div style="font-size:13px;color:#aaa;margin-top:4px;">사유: ${ret.reason}</div>
                                        <div style="font-size:12px;color:#bbb;margin-top:3px;"><c:out value="${ret.ret_note}"/></div>
                                    </div>
                                </div>
                                <c:if test="${ret.ret_status == 1}">
                                    <div class="order-foot" style="justify-content:flex-end;">
                                        <button type="button" class="btn btn-outline btn-sm" onclick="toggleReturnEdit(${ret.ret_num})">내용 수정</button>
                                        <form action="${pageContext.request.contextPath}/shop/user/returnDelete.do" method="post"
                                              onsubmit="return confirm('이 반품/교환 신청을 정말 취소하시겠습니까?');">
                                            <input type="hidden" name="ret_num" value="${ret.ret_num}">
                                            <button type="submit" class="btn btn-gray btn-sm">신청 취소</button>
                                        </form>
                                    </div>
                                    <div id="edit-form-${ret.ret_num}" class="return-edit-box">
                                        <div class="return-edit-title">수정할 내용 입력</div>
                                        <form action="${pageContext.request.contextPath}/shop/user/returnUpdate.do" method="post">
                                            <input type="hidden" name="ret_num" value="${ret.ret_num}">
                                            <div class="form-group">
                                                <label class="form-label" style="font-size:11px;">신청 유형</label>
                                                <div style="display:flex;gap:16px;margin-top:4px;">
                                                    <label style="display:flex;align-items:center;gap:6px;font-size:13px;cursor:pointer;"><input type="radio" name="tp" value="1" ${ret.tp == 1 ? 'checked' : ''}>반품</label>
                                                    <label style="display:flex;align-items:center;gap:6px;font-size:13px;cursor:pointer;"><input type="radio" name="tp" value="2" ${ret.tp == 2 ? 'checked' : ''}>교환</label>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="form-label" style="font-size:11px;">사유</label>
                                                <select class="form-input" name="reason">
                                                    <option value="단순 변심"  ${ret.reason == '단순 변심'  ? 'selected' : ''}>단순 변심</option>
                                                    <option value="사이즈 불량" ${ret.reason == '사이즈 불량' ? 'selected' : ''}>사이즈 불량</option>
                                                    <option value="상품 불량"  ${ret.reason == '상품 불량'  ? 'selected' : ''}>상품 불량</option>
                                                    <option value="오배송"     ${ret.reason == '오배송'     ? 'selected' : ''}>오배송</option>
                                                    <option value="기타"       ${ret.reason == '기타'       ? 'selected' : ''}>기타</option>
                                                </select>
                                            </div>
                                            <div class="form-group">
                                                <label class="form-label" style="font-size:11px;">상세 내용</label>
                                                <textarea class="form-input" name="ret_note" style="min-height:80px;"><c:out value="${ret.ret_note}"/></textarea>
                                            </div>
                                            <div style="display:flex;gap:8px;margin-top:12px;">
                                                <button type="button" class="btn btn-outline" style="flex:1;" onclick="toggleReturnEdit(${ret.ret_num})">닫기</button>
                                                <button type="submit" class="btn btn-black" style="flex:1;">수정 완료</button>
                                            </div>
                                        </form>
                                    </div>
                                </c:if>
                            </div>
                        </c:forEach>
                    </div>
                </div>

                <%-- ══ 회원 탈퇴 ══ --%>
                <div class="my-sub" id="my-deleteuser">
                    <div class="sec-title" style="color:#dc2626;">회원 탈퇴</div>
                    <div class="delete-warn">
                        <strong>⚠️ 탈퇴 전 반드시 확인해 주세요!</strong><br>
                        - 탈퇴 시 구매 내역, 장바구니, 찜 목록 등 모든 이용 정보가 삭제되며 복구할 수 없습니다.<br>
                        - 부정 이용 방지를 위해 <strong>동일한 아이디로는 다시 가입할 수 없습니다.</strong><br>
                        - 정보 확인을 위해 본인의 아이디, 이메일, 비밀번호를 정확히 입력해 주세요.
                    </div>
                    <form action="${pageContext.request.contextPath}/shop/user/deleteUser.do" method="post" id="deleteForm" onsubmit="return checkDelete()">
                        <div class="form-sec">
                            <div class="form-row">
                                <div class="form-group">
                                    <label class="form-label">아이디 확인</label>
                                    <input class="form-input" type="text" id="del_id" name="id" placeholder="아이디 입력">
                                </div>
                                <div class="form-group">
                                    <label class="form-label">이메일 확인</label>
                                    <input class="form-input" type="email" id="del_email" name="email" placeholder="등록된 이메일 입력">
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="form-group">
                                    <label class="form-label">비밀번호</label>
                                    <input class="form-input" type="password" id="del_pwd" name="passwd" placeholder="현재 비밀번호 입력">
                                </div>
                                <div class="form-group">
                                    <label class="form-label">비밀번호 확인</label>
                                    <input class="form-input" type="password" id="del_pwd_confirm" placeholder="비밀번호 재입력">
                                </div>
                            </div>
                            <button type="submit" class="btn btn-red" style="margin-top:8px;width:100%;height:50px;font-size:14px;background:#dc2626;color:#fff;border:none;">
                                안내사항을 확인하였으며, 탈퇴에 동의합니다
                            </button>
                        </div>
                    </form>
                </div>

            </div>
        </div>
    </div>

    <%-- ══ 리뷰 작성 모달 ══ --%>
    <div id="modal-review" style="display:none;position:fixed;inset:0;background:rgba(0,0,0,.5);z-index:9999;align-items:center;justify-content:center;">
        <div class="modal-box">
            <div class="modal-hdr">
                <div class="modal-hdr-title">✏️ 리뷰 작성</div>
                <button class="modal-close" onclick="closeReviewModal()">×</button>
            </div>
            <form action="${pageContext.request.contextPath}/shop/review/writeReview.do" method="post" id="reviewForm" enctype="multipart/form-data">
                <input type="hidden" name="orderNum" id="reviewOrderNum">
                <input type="hidden" name="prodNum" id="reviewProdNum">
                <div class="modal-body">
                    <div>
                        <div class="modal-label">상품명</div>
                        <div id="reviewProdName" style="font-weight:700;font-size:15px;color:#0d0d0d;"></div>
                    </div>
                    <div>
                        <div class="modal-label">별점 <span style="color:#dc2626;">*</span></div>
                        <div class="star-wrap" style="display:flex;gap:6px;font-size:32px;cursor:pointer;">
                            <span class="star" data-val="1">☆</span><span class="star" data-val="2">☆</span>
                            <span class="star" data-val="3">☆</span><span class="star" data-val="4">☆</span>
                            <span class="star" data-val="5">☆</span>
                        </div>
                        <input type="hidden" name="rating" id="reviewRating" value="0">
                    </div>
                    <div>
                        <div class="modal-label">리뷰 내용 <span style="color:#dc2626;">*</span></div>
                        <textarea name="reviewContent" id="reviewContent"
                                  style="width:100%;min-height:120px;padding:12px 14px;border:1.5px solid #e4e6ea;border-radius:8px;font-family:inherit;font-size:14px;resize:vertical;outline:none;"
                                  placeholder="상품에 대한 솔직한 리뷰를 남겨주세요. (최소 10자)"></textarea>
                    </div>
                    <div>
                        <div class="modal-label">사진 첨부 (다중 선택 가능)</div>
                        <input type="file" name="uploadFiles" multiple accept="image/*" class="form-input" style="height:auto; padding:10px 14px;">
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" onclick="closeReviewModal()">취소</button>
                    <button type="submit">리뷰 등록</button>
                </div>
            </form>
        </div>
    </div>

    <%-- ══ 리뷰 수정 모달 ══ --%>
    <div id="modal-edit-review" style="display:none;position:fixed;inset:0;background:rgba(0,0,0,.5);z-index:9999;align-items:center;justify-content:center;">
        <div class="modal-box">
            <div class="modal-hdr">
                <div class="modal-hdr-title">🖊️ 리뷰 수정</div>
                <button class="modal-close" onclick="closeEditReviewModal()">×</button>
            </div>
            <form action="${pageContext.request.contextPath}/shop/review/updateReview.do" method="post" id="editReviewForm" enctype="multipart/form-data">
                <input type="hidden" name="reviewNum" id="editReviewNum">
                <div class="modal-body">
                    <div>
                        <div class="modal-label">상품명</div>
                        <div id="editReviewProdName" style="font-weight:700;font-size:15px;color:#0d0d0d;"></div>
                    </div>
                    <div>
                        <div class="modal-label">별점 <span style="color:#dc2626;">*</span></div>
                        <div class="edit-star-wrap" style="display:flex;gap:6px;font-size:32px;cursor:pointer;">
                            <span class="edit-star" data-val="1">☆</span><span class="edit-star" data-val="2">☆</span>
                            <span class="edit-star" data-val="3">☆</span><span class="edit-star" data-val="4">☆</span>
                            <span class="edit-star" data-val="5">☆</span>
                        </div>
                        <input type="hidden" name="rating" id="editReviewRating" value="0">
                    </div>
                    <div>
                        <div class="modal-label">리뷰 내용 <span style="color:#dc2626;">*</span></div>
                        <textarea name="reviewContent" id="editReviewContent"
                                  style="width:100%;min-height:120px;padding:12px 14px;border:1.5px solid #e4e6ea;border-radius:8px;font-family:inherit;font-size:14px;resize:vertical;outline:none;"
                                  placeholder="수정할 내용을 입력해주세요. (최소 10자)"></textarea>
                    </div>
                    <div>
                        <div class="modal-label">새로운 사진 첨부 (기존 사진 대체)</div>
                        <input type="file" name="uploadFiles" multiple accept="image/*" class="form-input" style="height:auto; padding:10px 14px;">
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" onclick="closeEditReviewModal()">취소</button>
                    <button type="submit">수정 완료</button>
                </div>
            </form>
        </div>
    </div>

    <%-- ══ JS: 기능 동일 ══ --%>
    <script>
    function setMy(el, id) {
        document.querySelectorAll('.my-menu-item').forEach(m => m.classList.remove('on'));
        el.classList.add('on');
        document.querySelectorAll('.my-sub').forEach(s => s.classList.remove('on'));
        document.getElementById(id).classList.add('on');
    }

	// 주문내역 페이징 변수 설정
    let currentOrderPage = 1;
    const ordersPerPage = 5; 
    let currentOrderStatus = 0; 

    // 주문내역 탭 필터 및 페이징 렌더링 함수
    function renderOrderPagination(status) {
        const allCards = document.querySelectorAll('.order-item');
        let filteredCards = [];

        // 현재 탭에 맞는 카드만 추려내기
        allCards.forEach(card => {
            const s = parseInt(card.dataset.status);
            if (status === 0 || s === status) {
                filteredCards.push(card);
            }
            card.style.display = 'none';
        });

        const totalItems = filteredCards.length;
        const totalPages = Math.ceil(totalItems / ordersPerPage) || 1;

        // 페이지 초과 방지
        if (currentOrderPage > totalPages) currentOrderPage = totalPages;

        // 현재 페이지에 해당하는 카드만 화면에 보여주기
        const start = (currentOrderPage - 1) * ordersPerPage;
        const end = start + ordersPerPage;
        
        for (let i = start; i < end; i++) {
            if (filteredCards[i]) {
                filteredCards[i].style.display = '';
            }
        }

        // 페이징 버튼 생성
        const pageWrap = document.getElementById('order-pagination');
        if (!pageWrap) return;

        let pageHtml = '';
        
        if (totalItems > 0) {
            for (let i = 1; i <= totalPages; i++) {
                const isActive = (i === currentOrderPage) ? 'active' : '';
                pageHtml += '<a href="#" class="page-btn ' + isActive + '" onclick="changeOrderPage(' + i + '); return false;">' + i + '</a>';
            }
        }
        pageWrap.innerHTML = pageHtml;
    }

    // 페이지 번호 클릭 시 실행되는 함수
    function changeOrderPage(page) {
        currentOrderPage = page;
        renderOrderPagination(currentOrderStatus);
        document.getElementById('my-orders').scrollIntoView({ behavior: 'smooth', block: 'start' });
    }

    // 탭 클릭 시 필터링
    function filterOrders(el, status) {
        document.querySelectorAll('#my-orders .tab').forEach(t => t.classList.remove('on'));
        el.classList.add('on');
        
        currentOrderStatus = status; 
        currentOrderPage = 1;        
        
        renderOrderPagination(status);
    }

    // 화면 로드 시 초기 페이징 세팅
    document.addEventListener('DOMContentLoaded', function() {
        renderOrderPagination(0);
    });

    // 회원 탈퇴 유효성 체크
    function checkDelete() {
        const inputId = document.getElementById('del_id').value;
        const inputEmail = document.getElementById('del_email').value;
        const inputPwd = document.getElementById('del_pwd').value;
        const inputPwdConfirm = document.getElementById('del_pwd_confirm').value;
        const realId = '${user.user_id}';
        const realEmail = '${user.email}';
        if (inputId !== realId) { alert("입력하신 아이디가 로그인된 아이디와 일치하지 않습니다."); document.getElementById('del_id').focus(); return false; }
        if (inputEmail !== realEmail) { alert("입력하신 이메일이 등록된 이메일과 일치하지 않습니다."); document.getElementById('del_email').focus(); return false; }
        if (inputPwd === "") { alert("비밀번호를 입력해주세요."); document.getElementById('del_pwd').focus(); return false; }
        if (inputPwd !== inputPwdConfirm) { alert("비밀번호와 비밀번호 확인이 일치하지 않습니다."); document.getElementById('del_pwd_confirm').focus(); return false; }
        return confirm("정말로 ShoeMall에서 탈퇴하시겠습니까?\n이 작업은 되돌릴 수 없습니다.");
    }

    // 반품/교환 탭 및 모달 제어
    function switchReturnTab(tabName) {
        const tabs = document.querySelectorAll('#return-tabs .tab');
        tabs.forEach(t => t.classList.remove('on'));
        if (tabName === 'available') {
            tabs[0].classList.add('on');
            document.getElementById('return-available').style.display = 'block';
            document.getElementById('return-history').style.display = 'none';
        } else {
            tabs[1].classList.add('on');
            document.getElementById('return-available').style.display = 'none';
            document.getElementById('return-history').style.display = 'block';
        }
    }
    function toggleReturnEdit(retNum) {
        const el = document.getElementById('edit-form-' + retNum);
        el.style.display = (el.style.display === 'none' || el.style.display === '') ? 'block' : 'none';
    }
    function openReviewModal(orderNum, prodNum, prodName) {
        document.getElementById('reviewOrderNum').value = orderNum;
        document.getElementById('reviewProdNum').value  = prodNum;
        document.getElementById('reviewProdName').textContent = prodName;
        document.getElementById('reviewRating').value = 0;
        document.getElementById('reviewContent').value = '';
        setStars(0);
        document.getElementById('modal-review').style.display = 'flex';
    }
    function closeReviewModal() { document.getElementById('modal-review').style.display = 'none'; }
    function openEditReviewModal(reviewNum, rating, content, prodName) {
        document.getElementById('editReviewNum').value = reviewNum;
        document.getElementById('editReviewProdName').textContent = prodName;
        document.getElementById('editReviewContent').value = content;
        document.getElementById('editReviewRating').value = rating;
        setEditStars(rating);
        document.getElementById('modal-edit-review').style.display = 'flex';
    }
    function closeEditReviewModal() { document.getElementById('modal-edit-review').style.display = 'none'; }
    
    // 별점 렌더링
    function setStars(val) {
        document.querySelectorAll('.star').forEach(s => {
            s.textContent = parseInt(s.dataset.val) <= val ? '★' : '☆';
            s.style.color  = parseInt(s.dataset.val) <= val ? '#f59e0b' : '#ccc';
        });
    }
    function setEditStars(val) {
        document.querySelectorAll('.edit-star').forEach(s => {
            s.textContent = parseInt(s.dataset.val) <= val ? '★' : '☆';
            s.style.color  = parseInt(s.dataset.val) <= val ? '#f59e0b' : '#ccc';
        });
    }
    document.querySelectorAll('.star').forEach(s => {
        s.addEventListener('click', function() { const v = parseInt(this.dataset.val); document.getElementById('reviewRating').value = v; setStars(v); });
        s.addEventListener('mouseenter', function() { setStars(parseInt(this.dataset.val)); });
    });
    document.querySelector('.star-wrap')?.addEventListener('mouseleave', function() { setStars(parseInt(document.getElementById('reviewRating').value)); });
    document.querySelectorAll('.edit-star').forEach(s => {
        s.addEventListener('click', function() { const v = parseInt(this.dataset.val); document.getElementById('editReviewRating').value = v; setEditStars(v); });
        s.addEventListener('mouseenter', function() { setEditStars(parseInt(this.dataset.val)); });
    });
    document.querySelector('.edit-star-wrap')?.addEventListener('mouseleave', function() { setEditStars(parseInt(document.getElementById('editReviewRating').value)); });
    
    // 리뷰 폼 제출 검증
    document.getElementById('reviewForm')?.addEventListener('submit', function(e) {
        const rating = parseInt(document.getElementById('reviewRating').value);
        const content = document.getElementById('reviewContent').value.trim();
        if (rating < 1) { alert('별점을 선택해주세요.'); e.preventDefault(); return; }
        if (content.length < 10) { alert('리뷰 내용을 최소 10자 이상 입력해주세요.'); e.preventDefault(); return; }
    });
    document.getElementById('editReviewForm')?.addEventListener('submit', function(e) {
        const rating = parseInt(document.getElementById('editReviewRating').value);
        const content = document.getElementById('editReviewContent').value.trim();
        if (rating < 1) { alert('별점을 선택해주세요.'); e.preventDefault(); return; }
        if (content.length < 10) { alert('리뷰 내용을 최소 10자 이상 입력해주세요.'); e.preventDefault(); return; }
    });
    document.getElementById('modal-review')?.addEventListener('click', function(e) { if (e.target === this) closeReviewModal(); });
    document.getElementById('modal-edit-review')?.addEventListener('click', function(e) { if (e.target === this) closeEditReviewModal(); });
    
    // 정보 수정 검증
    document.getElementById('modifyForm')?.addEventListener('submit', function(e) {
        const currentPwd = this.passwd.value;
        const newPwd = this.new_passwd.value;
        const newPwdConfirm = this.new_passwd_confirm.value;
        if (!currentPwd) { alert("정보를 수정하려면 현재 비밀번호를 꼭 입력해야 합니다."); this.passwd.focus(); e.preventDefault(); return false; }
        if (newPwd !== "" && newPwd !== newPwdConfirm) { alert("새 비밀번호와 비밀번호 확인이 일치하지 않습니다."); this.new_passwd_confirm.focus(); e.preventDefault(); return false; }
    });
    </script>

    <%-- 우편번호 --%>
    <div id="layer" style="display:none;position:fixed;overflow:hidden;z-index:9999;-webkit-overflow-scrolling:touch;">
        <img src="//t1.daumcdn.net/postcode/resource/images/close.png" id="btnCloseLayer"
             style="cursor:pointer;position:absolute;right:-3px;top:-3px;z-index:1"
             onclick="closeDaumPostcode()" alt="닫기 버튼">
    </div>
    <script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
    <script>
    var element_layer = document.getElementById('layer');
    function closeDaumPostcode() { element_layer.style.display = 'none'; }
    function execDaumPostcode() {
        new daum.Postcode({
            oncomplete: function(data) {
                var addr = data.userSelectedType === 'R' ? data.roadAddress : data.jibunAddress;
                var extra = '';
                if (data.userSelectedType === 'R') {
                    if (data.bname !== '' && /[동|로|가]$/g.test(data.bname)) extra += data.bname;
                    if (data.buildingName !== '' && data.apartment === 'Y') extra += (extra !== '' ? ', ' + data.buildingName : data.buildingName);
                    if (extra !== '') extra = ' (' + extra + ')';
                }
                document.getElementById('zipcode').value = data.zonecode;
                document.getElementById('addr1').value = addr + extra;
                document.getElementById('addr2').focus();
                element_layer.style.display = 'none';
            },
            width: '100%', height: '100%', maxSuggestItems: 5
        }).embed(element_layer);
        element_layer.style.display = 'block';
        initLayerPosition();
    }
    function initLayerPosition() {
        var w = 300, h = 400, b = 5;
        element_layer.style.width  = w + 'px';
        element_layer.style.height = h + 'px';
        element_layer.style.border = b + 'px solid';
        element_layer.style.left = (((window.innerWidth  || document.documentElement.clientWidth)  - w) / 2 - b) + 'px';
        element_layer.style.top  = (((window.innerHeight || document.documentElement.clientHeight) - h) / 2 - b) + 'px';
    }
    </script>
</body>
</html>