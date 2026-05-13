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
        <%-- 1. 로그인 상태일 때 --%>
        <c:when test="${!empty sessionScope.user_num}">
          
          <div class="noti-wrap">
            <button class="hdr-btn" onclick="toggleNoti(event)">
              <span class="hdr-btn-icon">🔔</span><span class="hdr-btn-label">알림</span>
              <span class="hdr-badge" style="background:var(--blue)">1</span>
            </button>
            
            <div class="noti-modal" id="notiModal" onclick="event.stopPropagation()">
              <div class="noti-m-hdr">
                <div class="noti-m-title">알림센터</div>
                <div style="cursor:pointer;color:var(--gray4);font-size:16px;">⚙️</div>
              </div>
              <div class="noti-m-tabs">
                <div class="noti-m-tab on">알림</div>
                <div class="noti-m-tab">대화</div>
              </div>
              <div class="noti-m-body">
                <div class="noti-sec-title">오늘 받은 알림</div>
                <div class="noti-item unread">
                  <div class="noti-i-icon img">🎁</div>
                  <div class="noti-i-txt">
                    <div class="noti-i-top">
                      <span class="noti-i-shop" style="font-size:13px;font-weight:700">[5% 할인 쿠폰] 도착!</span>
                      <span class="noti-i-time">방금 전</span>
                    </div>
                    <div class="noti-i-desc">케익팩토리 딜리버리의 혜택을 확인해보세요!</div>
                  </div>
                </div>

                <div class="noti-sec-title" style="margin-top:20px;">이전 알림</div>
                <div class="noti-chips">
                  <div class="noti-chip on">전체</div>
                  <div class="noti-chip">혜택·이벤트</div>
                  <div class="noti-chip">회원·인증</div>
                </div>
                <div class="noti-item">
                  <div class="noti-i-icon">📦</div>
                  <div class="noti-i-txt">
                    <div class="noti-i-top">
                      <span class="noti-i-shop" style="font-size:13px;font-weight:700">배송 출발 안내</span>
                      <span class="noti-i-time">4월 24일</span>
                    </div>
                    <div class="noti-i-desc">주문하신 상품의 배송이 시작되었습니다.</div>
                  </div>
                </div>
              </div>
            </div>
          </div>
          <button class="hdr-btn" onclick="location.href='${pageContext.request.contextPath}/shop/ai/aiPick.do'">
          	<span class="hdr-btn-icon">🤖</span>
          	<span class="hdr-btn-label">AI추천</span>
          </button>
          <button class="hdr-btn" onclick="location.href='${pageContext.request.contextPath}/shop/userstore/userStoreList.do'">
	        <span class="hdr-btn-icon">🗺️</span>
	        <span class="hdr-btn-label">매장찾기</span>
	      </button>
	      <button class="hdr-btn" onclick="location.href='${pageContext.request.contextPath}/shop/wish/wishList.do'">
	        <span class="hdr-btn-icon">🤍</span>
	        <span class="hdr-btn-label">찜</span>
	        <span class="hdr-badge" style="background:#4d94ff">2</span>
	      </button>
          <button class="hdr-btn" onclick="location.href='${pageContext.request.contextPath}/shop/cart/cartList.do'">
            <span class="hdr-btn-icon">🛒</span>
            <span class="hdr-btn-label">장바구니</span>
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
        
        <%-- 2. 비로그인 상태일 때 --%>
        <c:otherwise>
          <button class="hdr-btn" onclick="location.href='${pageContext.request.contextPath}/shop/ai/aiPick.do'">
          	<span class="hdr-btn-icon">🤖</span>
          	<span class="hdr-btn-label">AI추천</span>
          </button>
          <button class="hdr-btn" onclick="location.href='${pageContext.request.contextPath}/shop/userstore/userStoreList.do'">
	        <span class="hdr-btn-icon">🗺️</span>
	        <span class="hdr-btn-label">매장찾기</span>
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
    <%-- 선택된 카테고리가 0이거나 없을 때 '전체' 탭 활성화 --%>
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
// 종 모양 버튼 클릭 시 알림창 열기/닫기
function toggleNoti(e) {
  e.stopPropagation();
  const modal = document.getElementById('notiModal');
  if(modal) {
      modal.classList.toggle('show');
  }
}

// 화면 빈 곳 클릭 시 알림창 닫기
document.addEventListener('click', function(e) {
  const modal = document.getElementById('notiModal');
  if (modal && modal.classList.contains('show') && !e.target.closest('.noti-wrap')) {
    modal.classList.remove('show');
  }
});

</script>