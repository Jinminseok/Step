<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<style>
/* ── 알림 아이템 텍스트 말줄임 ── */
.noti-item {
    display: flex;
    align-items: flex-start;
    gap: 10px;
    padding: 12px 16px;
    border-bottom: 1px solid #f1f5f9;
    min-width: 0;
}
.noti-i-txt {
    flex: 1;
    min-width: 0;
}
.noti-i-top {
    display: flex;
    justify-content: space-between;
    align-items: center;
    gap: 8px;
    margin-bottom: 3px;
}
.noti-i-shop {
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
    flex: 1;
}
.noti-i-time {
    white-space: nowrap;
    font-size: 11px;
    color: #94a3b8;
    flex-shrink: 0;
}
.noti-i-desc {
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
    font-size: 13px;
    color: #64748b;
}
.noti-item.unread {
    background: #f0f7ff;
    border-left: 3px solid #3b82f6;
}
.noti-item:last-child { border-bottom: none; }
.noti-item:hover { background: #f8fafc; }
.noti-item.unread:hover { background: #e8f3ff; }

/* ── 알림 모달 너비 고정 ── */
.noti-modal {
    width: 360px;
    overflow: hidden;
}
.noti-m-body {
    max-height: 400px;
    overflow-y: auto;
}

/* ── 알림 상세 모달 ── */
.noti-detail-overlay {
    display: none;
    position: fixed;
    top: 0; left: 0;
    width: 100%; height: 100%;
    background: rgba(0,0,0,0.4);
    z-index: 9998;
}
.noti-detail-modal {
    display: none;
    position: fixed;
    top: 50%; left: 50%;
    transform: translate(-50%, -50%);
    background: #fff;
    border-radius: 12px;
    width: 380px;
    box-shadow: 0 8px 30px rgba(0,0,0,0.15);
    z-index: 9999;
    overflow: hidden;
}
.noti-detail-hdr {
    background: #f8fafc;
    padding: 24px 24px 16px;
    border-bottom: 1px solid #e2e8f0;
    text-align: center;
}
.noti-detail-type-icon {
    font-size: 36px;
    margin-bottom: 10px;
}
.noti-detail-title {
    font-size: 16px;
    font-weight: 700;
    color: #0f172a;
    margin-bottom: 6px;
    line-height: 1.4;
}
.noti-detail-time {
    font-size: 12px;
    color: #94a3b8;
}
.noti-detail-body {
    padding: 20px 24px;
    font-size: 14px;
    color: #334155;
    line-height: 1.7;
    min-height: 80px;
    word-break: break-all;
}
.noti-detail-footer {
    display: flex;
    gap: 10px;
    padding: 16px 24px;
    border-top: 1px solid #e2e8f0;
    justify-content: flex-end;
}
.noti-detail-btn-del {
    padding: 9px 18px;
    font-size: 13px;
    font-weight: 600;
    color: #ef4444;
    background: #fff0f0;
    border: 1px solid #fca5a5;
    border-radius: 6px;
    cursor: pointer;
    transition: background 0.2s;
}
.noti-detail-btn-del:hover { background: #fee2e2; }
.noti-detail-btn-close {
    padding: 9px 18px;
    font-size: 13px;
    font-weight: 600;
    color: #475569;
    background: #f1f5f9;
    border: 1px solid #cbd5e1;
    border-radius: 6px;
    cursor: pointer;
    transition: background 0.2s;
}
.noti-detail-btn-close:hover { background: #e2e8f0; }
</style>

<header>
    <div class="hdr-top">
        <div class="logo"
            onclick="location.href='${pageContext.request.contextPath}/shop/user/main.do'">
            Shoe<span>Mall</span>
        </div>
        <form class="hdr-search" action="${pageContext.request.contextPath}/shop/user/main.do" method="get">
            <input type="text" name="keyword" value="${param.keyword}" placeholder="브랜드, 상품, 카테고리 검색">
            <button type="submit" class="hdr-search-btn">🔍</button>
        </form>
        <div class="hdr-actions">
            <c:choose>
                <%-- 로그인 상태 --%>
                <c:when test="${!empty sessionScope.user_num}">

                    <%-- 알림 버튼 --%>
                    <div class="noti-wrap">
                        <button class="hdr-btn" onclick="toggleNoti(event)">
                            <span class="hdr-btn-icon">🔔</span>
                            <span class="hdr-btn-label">알림</span>
                            <span class="hdr-badge" id="notiCountBadge"
                                style="background:var(--blue); display:none;">0</span>
                        </button>

                        <div class="noti-modal" id="notiModal" onclick="event.stopPropagation()">
                            <div class="noti-m-hdr">
                                <div class="noti-m-title">알림센터</div>
                            </div>
                            <div class="noti-m-tabs">
                                <div class="noti-m-tab on">알림</div>
                            </div>
                            <div class="noti-m-body" id="notiBody">
                                <div style="text-align:center;padding:40px;color:#aaa;font-size:14px;">로딩 중...</div>
                            </div>
                        </div>
                    </div>

                    <button class="hdr-btn"
                        onclick="location.href='${pageContext.request.contextPath}/shop/ai/aiPick.do'">
                        <span class="hdr-btn-icon">🤖</span><span class="hdr-btn-label">AI추천</span>
                    </button>
                    <button class="hdr-btn"
                        onclick="location.href='${pageContext.request.contextPath}/shop/userstore/userStoreList.do'">
                        <span class="hdr-btn-icon">🗺️</span><span class="hdr-btn-label">매장찾기</span>
                    </button>
                    <button class="hdr-btn"
                        onclick="location.href='${pageContext.request.contextPath}/shop/wish/wishList.do'">
                        <span class="hdr-btn-icon">🤍</span><span class="hdr-btn-label">찜</span>
                        <span class="hdr-badge" id="headerWishBadge"
                            style="background:#4d94ff; display:none;">0</span>
                    </button>
                    <button class="hdr-btn"
                        onclick="location.href='${pageContext.request.contextPath}/shop/cart/cartList.do'">
                        <span class="hdr-btn-icon">🛒</span><span class="hdr-btn-label">장바구니</span>
                        <span class="hdr-badge" id="headerCartBadge"
                            style="background:var(--red); display:none;">0</span>
                    </button>
                    <div style="width:1px;height:28px;background:#333;margin:0 4px"></div>
                    <button class="hdr-btn"
                        onclick="location.href='${pageContext.request.contextPath}/shop/user/myPageForm.do'">
                        <span class="hdr-btn-icon"
                            style="width:28px;height:28px;background:#ff0000;border-radius:50%;display:flex;align-items:center;justify-content:center;font-size:13px;font-weight:700;color:#fff">M</span>
                        <span class="hdr-btn-label" style="color:#fff">마이페이지</span>
                    </button>
                    <button class="hdr-btn"
                        onclick="location.href='${pageContext.request.contextPath}/shop/user/logout.do'">
                        <span class="hdr-btn-label" style="font-size:12px;font-weight:700">로그아웃</span>
                    </button>

                </c:when>

                <%-- 비로그인 상태 --%>
                <c:otherwise>
                    <button class="hdr-btn"
                        onclick="location.href='${pageContext.request.contextPath}/shop/ai/aiPick.do'">
                        <span class="hdr-btn-icon">🤖</span><span class="hdr-btn-label">AI추천</span>
                    </button>
                    <button class="hdr-btn"
                        onclick="location.href='${pageContext.request.contextPath}/shop/userstore/userStoreList.do'">
                        <span class="hdr-btn-icon">🗺️</span><span class="hdr-btn-label">매장찾기</span>
                    </button>
                    <div style="width:1px;height:28px;background:#333;margin:0 4px"></div>
                    <button class="hdr-btn"
                        onclick="location.href='${pageContext.request.contextPath}/shop/user/loginForm.do'"
                        style="color:#fff;background:rgba(255,255,255,.08);border-radius:3px;padding:6px 14px;">
                        <span class="hdr-btn-label" style="font-size:12px;font-weight:700">로그인</span>
                    </button>
                    <button class="hdr-btn"
                        onclick="location.href='${pageContext.request.contextPath}/shop/user/registerForm.do'"
                        style="color:#000;background:#fff;border-radius:3px;padding:6px 14px;">
                        <span class="hdr-btn-label" style="font-size:12px;font-weight:700">회원가입</span>
                    </button>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <%-- 알림 상세 모달 --%>
    <div class="noti-detail-overlay" id="notiDetailOverlay" onclick="closeNotiDetail()"></div>
    <div class="noti-detail-modal" id="notiDetailModal">
        <div class="noti-detail-hdr">
            <div class="noti-detail-type-icon" id="detailIcon">🔔</div>
            <div class="noti-detail-title" id="detailTitle"></div>
            <div class="noti-detail-time" id="detailTime"></div>
        </div>
        <div class="noti-detail-body" id="detailContent"></div>
        <div class="noti-detail-footer">
            <button class="noti-detail-btn-del" onclick="deleteNotify()">🗑️ 삭제</button>
            <button class="noti-detail-btn-close" onclick="closeNotiDetail()">닫기</button>
        </div>
    </div>

</header>

<div class="cat-nav">
    <div class="cat-nav-inner">
        <div class="cat-item ${empty param.cat_num or param.cat_num == '0' ? 'active' : ''}"
            onclick="location.href='${pageContext.request.contextPath}/shop/user/main.do'">전체</div>
        <div class="cat-item ${param.cat_num == '1' ? 'active' : ''}"
            onclick="location.href='${pageContext.request.contextPath}/shop/user/main.do?cat_num=1'">👟 운동화</div>
        <div class="cat-item ${param.cat_num == '2' ? 'active' : ''}"
            onclick="location.href='${pageContext.request.contextPath}/shop/user/main.do?cat_num=2'">👡 샌들</div>
        <div class="cat-item ${param.cat_num == '3' ? 'active' : ''}"
            onclick="location.href='${pageContext.request.contextPath}/shop/user/main.do?cat_num=3'">⚽ 축구화</div>
        <div class="cat-item ${param.cat_num == '4' ? 'active' : ''}"
            onclick="location.href='${pageContext.request.contextPath}/shop/user/main.do?cat_num=4'">🩴 슬리퍼</div>
    </div>
</div>

<script>
/* ── 알림 모달 토글 ── */
function toggleNoti(e) {
    e.stopPropagation();
    var modal = document.getElementById('notiModal');
    if (!modal) return;
    var opening = !modal.classList.contains('show');
    modal.classList.toggle('show');
    if (opening) loadNotiList();
}

document.addEventListener('click', function(e) {
    var modal = document.getElementById('notiModal');
    if (modal && modal.classList.contains('show') && !e.target.closest('.noti-wrap')) {
        modal.classList.remove('show');
    }
});

<c:if test="${!empty sessionScope.user_num}">
$(document).ready(function() {
    updateWishBadge();
    updateCartBadge();
    updateNotiBadge();
    setInterval(updateNotiBadge, 30000);
});

/* ── 미읽음 뱃지 갱신 ── */
function updateNotiBadge() {
    $.ajax({
        url: '${pageContext.request.contextPath}/shop/notify/getUnreadCount.do',
        type: 'GET',
        dataType: 'json',
        success: function(data) {
            var badge = $('#notiCountBadge');
            if (data.count > 0) badge.text(data.count).show();
            else badge.hide();
        }
    });
}

/* ── 알림 목록 로드 ── */
function loadNotiList() {
    $.ajax({
        url: '${pageContext.request.contextPath}/shop/notify/getNotiList.do',
        type: 'GET',
        dataType: 'json',
        success: function(data) {
            var list = typeof data.list === 'string' ? JSON.parse(data.list) : data.list;
            renderNotiList(list);
            $.post('${pageContext.request.contextPath}/shop/notify/markAllRead.do');
            $('#notiCountBadge').hide();
        },
        error: function() {
            $('#notiBody').html('<div style="text-align:center;padding:40px;color:#aaa;">알림을 불러오지 못했습니다.</div>');
        }
    });
}

/* ── 알림 목록 렌더링 ── */
function renderNotiList(list) {
    var body = document.getElementById('notiBody');
    if (!body) return;

    if (!list || list.length === 0) {
        body.innerHTML = '<div style="text-align:center;padding:40px;color:#aaa;font-size:14px;">받은 알림이 없습니다.</div>';
        return;
    }

    var todayItems = list.filter(function(n) { return /^\d{2}:\d{2}$/.test(n.formatted_date); });
    var prevItems  = list.filter(function(n) { return !/^\d{2}:\d{2}$/.test(n.formatted_date); });

    var html = '';
    if (todayItems.length > 0) {
        html += '<div class="noti-sec-title">오늘 받은 알림</div>';
        todayItems.forEach(function(n) { html += buildNotiItem(n); });
    }
    if (prevItems.length > 0) {
        html += '<div class="noti-sec-title" style="margin-top:20px;">이전 알림</div>';
        prevItems.forEach(function(n) { html += buildNotiItem(n); });
    }
    body.innerHTML = html;
}

/* ── 알림 아이템 HTML 생성 ── */
var currentNotifyNum = 0;

function buildNotiItem(n) {
    var iconMap = { 1: '📦', 2: '🔁', 3: '🎁', 4: '🎉' };
    var icon   = iconMap[n.notify_type] || '🔔';
    var unread = n.read_yn === 'N' ? 'unread' : '';

    return '<div class="noti-item ' + unread + '" style="cursor:pointer;" '
        + 'onclick="openNotiDetail('
        + n.notify_num + ', \''
        + escapeHtml(n.notify_title) + '\', \''
        + escapeHtml(n.notify_content) + '\', \''
        + n.formatted_date + '\', '
        + n.notify_type + ')">'
        + '<div class="noti-i-icon">' + icon + '</div>'
        + '<div class="noti-i-txt">'
        + '<div class="noti-i-top">'
        + '<span class="noti-i-shop" style="font-size:13px;font-weight:700">' + n.notify_title + '</span>'
        + '<span class="noti-i-time">' + n.formatted_date + '</span>'
        + '</div>'
        + '<div class="noti-i-desc">' + n.notify_content + '</div>'
        + '</div></div>';
}

/* ── 상세 모달 열기 ── */
function openNotiDetail(notify_num, title, content, date, type) {
    var iconMap = { 1: '📦', 2: '🔁', 3: '🎁', 4: '🎉' };
    currentNotifyNum = notify_num;

    document.getElementById('detailIcon').textContent    = iconMap[type] || '🔔';
    document.getElementById('detailTitle').textContent   = title;
    document.getElementById('detailContent').textContent = content;
    document.getElementById('detailTime').textContent    = date;

    document.getElementById('notiDetailOverlay').style.display = 'block';
    document.getElementById('notiDetailModal').style.display   = 'block';
    document.getElementById('notiModal').classList.remove('show');
}

/* ── 상세 모달 닫기 ── */
function closeNotiDetail() {
    document.getElementById('notiDetailOverlay').style.display = 'none';
    document.getElementById('notiDetailModal').style.display   = 'none';
    currentNotifyNum = 0;
}

/* ── 알림 삭제 ── */
function deleteNotify() {
    if (!confirm('이 알림을 삭제하시겠습니까?')) return;
    $.ajax({
        url: '${pageContext.request.contextPath}/shop/notify/deleteNotify.do',
        type: 'POST',
        data: { notify_num: currentNotifyNum },
        dataType: 'json',
        success: function(data) {
            if (data.result === 'ok') {
                closeNotiDetail();
                loadNotiList();
                updateNotiBadge();
            }
        },
        error: function() {
            alert('삭제 중 오류가 발생했습니다.');
        }
    });
}

/* ── 특수문자 이스케이프 ── */
function escapeHtml(str) {
    if (!str) return '';
    return str.replace(/\\/g, '\\\\').replace(/'/g, "\\'").replace(/"/g, '&quot;');
}

/* ── 찜 뱃지 ── */
function updateWishBadge() {
    $.ajax({
        url: '${pageContext.request.contextPath}/shop/wish/getWishCount.do',
        type: 'GET', dataType: 'json',
        success: function(param) {
            if (param.count > 0) $('#headerWishBadge').text(param.count).show();
            else $('#headerWishBadge').hide();
        }
    });
}

/* ── 장바구니 뱃지 ── */
function updateCartBadge() {
    $.ajax({
        url: '${pageContext.request.contextPath}/shop/cart/getCartCount.do',
        type: 'GET', dataType: 'json',
        success: function(param) {
            if (param.count > 0) $('#headerCartBadge').text(param.count).show();
            else $('#headerCartBadge').hide();
        }
    });
}
</c:if>
</script>