<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<header>
  <div class="hdr-top">
    <div class="logo" onclick="location.href='${pageContext.request.contextPath}/shop/user/main.do'">Shoe<span>Mall</span></div>
    <div class="hdr-search">
      <input type="text" placeholder="브랜드, 상품, 카테고리 검색">
      <button class="hdr-search-btn">🔍</button>
    </div>
    <div class="hdr-actions">
      <c:choose>
        <%-- 로그인 상태 --%>
        <c:when test="${!empty sessionScope.user_num}">

          <%-- 알림 버튼 --%>
          <div class="noti-wrap">
            <button class="hdr-btn" onclick="toggleNoti(event)">
              <span class="hdr-btn-icon">🔔</span>
              <span class="hdr-btn-label">알림</span>
              <span class="hdr-badge" id="notiCountBadge" style="background:var(--blue); display:none;">0</span>
            </button>

            <div class="noti-modal" id="notiModal" onclick="event.stopPropagation()">
              <div class="noti-m-hdr">
                <div class="noti-m-title">알림센터</div>
              </div>
              <div class="noti-m-tabs">
                <div class="noti-m-tab on">알림</div>
              </div>
              <%-- 알림 목록은 JS로 동적 렌더링 --%>
              <div class="noti-m-body" id="notiBody">
                <div style="text-align:center;padding:40px;color:#aaa;font-size:14px;">로딩 중...</div>
              </div>
            </div>
          </div>

          <button class="hdr-btn" onclick="location.href='${pageContext.request.contextPath}/shop/ai/aiPick.do'">
            <span class="hdr-btn-icon">🤖</span><span class="hdr-btn-label">AI추천</span>
          </button>
          <button class="hdr-btn" onclick="location.href='${pageContext.request.contextPath}/shop/userstore/userStoreList.do'">
            <span class="hdr-btn-icon">🗺️</span><span class="hdr-btn-label">매장찾기</span>
          </button>
          <button class="hdr-btn" onclick="location.href='${pageContext.request.contextPath}/shop/wish/wishList.do'">
            <span class="hdr-btn-icon">🤍</span><span class="hdr-btn-label">찜</span>
            <span class="hdr-badge" id="headerWishBadge" style="background:#4d94ff; display:none;">0</span>
          </button>
          <button class="hdr-btn" onclick="location.href='${pageContext.request.contextPath}/shop/cart/cartList.do'">
            <span class="hdr-btn-icon">🛒</span><span class="hdr-btn-label">장바구니</span>
            <span class="hdr-badge" id="headerCartBadge" style="background:var(--red); display:none;">0</span>
          </button>
          <div style="width:1px;height:28px;background:#333;margin:0 4px"></div>
          <button class="hdr-btn" onclick="location.href='${pageContext.request.contextPath}/shop/user/myPageForm.do'">
            <span class="hdr-btn-icon" style="width:28px;height:28px;background:#ff0000;border-radius:50%;display:flex;align-items:center;justify-content:center;font-size:13px;font-weight:700;color:#fff">M</span>
            <span class="hdr-btn-label" style="color:#fff">마이페이지</span>
          </button>
          <button class="hdr-btn" onclick="location.href='${pageContext.request.contextPath}/shop/user/logout.do'">
            <span class="hdr-btn-label" style="font-size:12px;font-weight:700">로그아웃</span>
          </button>

        </c:when>

        <%-- 비로그인 상태 --%>
        <c:otherwise>
          <button class="hdr-btn" onclick="location.href='${pageContext.request.contextPath}/shop/ai/aiPick.do'">
            <span class="hdr-btn-icon">🤖</span><span class="hdr-btn-label">AI추천</span>
          </button>
          <button class="hdr-btn" onclick="location.href='${pageContext.request.contextPath}/shop/userstore/userStoreList.do'">
            <span class="hdr-btn-icon">🗺️</span><span class="hdr-btn-label">매장찾기</span>
          </button>
          <div style="width:1px;height:28px;background:#333;margin:0 4px"></div>
          <button class="hdr-btn" onclick="location.href='${pageContext.request.contextPath}/shop/user/loginForm.do'" style="color:#fff;background:rgba(255,255,255,.08);border-radius:3px;padding:6px 14px;">
            <span class="hdr-btn-label" style="font-size:12px;font-weight:700">로그인</span>
          </button>
          <button class="hdr-btn" onclick="location.href='${pageContext.request.contextPath}/shop/user/registerForm.do'" style="color:#000;background:#fff;border-radius:3px;padding:6px 14px;">
            <span class="hdr-btn-label" style="font-size:12px;font-weight:700">회원가입</span>
          </button>
        </c:otherwise>
      </c:choose>
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
  const modal = document.getElementById('notiModal');
  if (!modal) return;
  const opening = !modal.classList.contains('show');
  modal.classList.toggle('show');
  if (opening) loadNotiList();
}

document.addEventListener('click', function(e) {
  const modal = document.getElementById('notiModal');
  if (modal && modal.classList.contains('show') && !e.target.closest('.noti-wrap')) {
    modal.classList.remove('show');
  }
});

<c:if test="${!empty sessionScope.user_num}">
$(document).ready(function() {
  updateWishBadge();
  updateCartBadge();
  updateNotiBadge();
  setInterval(updateNotiBadge, 30000); // 30초 폴링
});

/* ── 미읽음 뱃지 갱신 ── */
function updateNotiBadge() {
  $.ajax({
    url: '${pageContext.request.contextPath}/shop/notify/getUnreadCount.do',
    type: 'GET',
    dataType: 'json',
    success: function(data) {
      var badge = $('#notiCountBadge');
      if (data.count > 0) {
        badge.text(data.count).show();
      } else {
        badge.hide();
      }
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
            // ✅ list가 문자열로 오므로 JSON.parse 필요
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

function buildNotiItem(n) {
  var iconMap = { 1: '📦', 2: '🔁', 3: '🎁', 4: '🎉' };
  var icon    = iconMap[n.notify_type] || '🔔';
  var unread  = n.read_yn === 'N' ? 'unread' : '';
  return '<div class="noti-item ' + unread + '">'
    + '<div class="noti-i-icon">' + icon + '</div>'
    + '<div class="noti-i-txt">'
    + '<div class="noti-i-top">'
    + '<span class="noti-i-shop" style="font-size:13px;font-weight:700">' + n.notify_title + '</span>'
    + '<span class="noti-i-time">' + n.formatted_date + '</span>'
    + '</div>'
    + '<div class="noti-i-desc">' + n.notify_content + '</div>'
    + '</div></div>';
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