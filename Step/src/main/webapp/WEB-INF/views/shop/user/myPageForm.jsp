<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>ShoeMall - 마이페이지</title>
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700;900&family=Space+Grotesk:wght@600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/KR_style.css">
</head>
<body>
    <%-- 공통 헤더 --%>
    <jsp:include page="/WEB-INF/views/common/header.jsp"/>

    <div class="wrap">
        <div class="page-title">마이페이지</div>
        
        <div class="my-layout">
            
            <%-- 왼쪽 메뉴 --%>
            <div class="my-menu">
                <div class="my-menu-hdr">${user.user_name} 님</div>
                <div class="my-menu-item on" onclick="setMy(this,'my-page')">⭐ 내 정보</div>
                <div class="my-menu-item" id="menu-orders" onclick="setMy(this,'my-orders')">🧾 주문 내역</div>
                <div class="my-menu-item" onclick="setMy(this,'my-restock')">⏰ 재입고 알림</div>
                <div class="my-menu-item" onclick="setMy(this,'my-info')">👤 내 정보 수정</div>
                <div class="my-menu-item" onclick="setMy(this,'my-return')">↩️ 반품/교환</div>
            </div>
            
            <%-- 오른쪽 본문 영역 --%>
            <div class="my-body">

                <!-- 1. 내 정보 탭 -->
                <div class="my-sub on" id="my-page">
                    <div class="sec-title">나의 쇼핑 혜택</div>
                    
                    <div style="border:1px solid var(--border); padding: 24px; border-radius: 4px; margin-bottom: 24px; display:flex; flex-direction:column; gap:16px;">
                        <div style="display:flex; justify-content:space-between; align-items:flex-end;">
                            <div>
                                <div style="font-size:12px; color:var(--gray3); margin-bottom:4px;">현재 등급</div>
                                <div style="font-size:24px; font-weight:700; color:var(--blue);">
								    <c:choose>
								        <c:when test="${user.grade == 1}">BRONZE</c:when>
								        <c:when test="${user.grade == 2}">SILVER</c:when>
								        <c:when test="${user.grade == 3}">GOLD</c:when>
								        <c:when test="${user.grade == 4}">VIP</c:when>
								        <c:otherwise>일반회원</c:otherwise>
								    </c:choose>
								</div>
                            </div>
                            <div style="text-align:right; font-size:13px; line-height: 1.4;">
				            	다음 등급
				            	<strong style="color:var(--black);">
				            		<c:choose>
				            			<c:when test="${user.grade == 1}">SILVER</c:when>
				            			<c:when test="${user.grade == 2}">GOLD</c:when>
				            			<c:when test="${user.grade == 3}">VIP</c:when>
				            			<c:when test="${user.grade == 4}">최고 등급</c:when>
				            			<c:otherwise>BRONZE</c:otherwise>
				            		</c:choose>
				            	</strong>까지<br>
				            	<strong style="color:var(--red); font-size: 16px;">(누적 금액 필요)</strong> 남았습니다!
				            </div>
                        </div>
                        <div>
				            <div style="width:100%; height:10px; background:var(--gray6); border-radius:5px; overflow:hidden;">
				            	<div style="width: <c:choose>
									            		<c:when test='${user.grade == 1}'>25</c:when>
									            		<c:when test='${user.grade == 2}'>50</c:when>
									            		<c:when test='${user.grade == 3}'>75</c:when>
				            							<c:otherwise>100</c:otherwise>
				            						</c:choose>%; height:100%; background:var(--black);">
				            	</div>
				            </div>
				            <div style="display:flex; justify-content:space-between; font-size:11px; color:var(--gray4); margin-top: 6px;">
				            	<span>0원</span>
				            	<span>누적 500,000원 달성 시 등급업</span>
				            </div>
				        </div>
                    </div>

                    <div class="sec-title" style="margin-top: 32px;">
                        최근 주문 현황 
                        <a onclick="document.getElementById('menu-orders').click()" style="cursor:pointer; font-size:12px; color:var(--gray4);">더보기 ➔</a>
                    </div>
                    
                    <%-- 실제 최근 주문 리스트 (recentOrderList) 출력 영역 --%>
                    <c:if test="${empty recentOrderList}">
                        <div style="text-align:center; padding:40px; color:var(--gray4); background:var(--gray7); border:1px solid var(--border);">
                            최근 주문하신 내역이 없습니다.
                        </div>
                    </c:if>
                    <c:forEach var="order" items="${recentOrderList}">
                        <div class="order-card">
                            <div class="order-hdr">
                                <span class="order-num">#${order.order_num}</span>
                                <span class="badge b-orange">결제완료</span>
                            </div>
                            <div class="order-body">
                                <div class="order-thumb">
                                    <img src="${pageContext.request.contextPath}/upload/${order.prod_img_url}" style="width:100%;height:100%;object-fit:cover;" alt="상품이미지">
                                </div>
                                <div>
                                    <div class="order-info-name">${order.prod_name}</div>
                                    <div class="order-info-price"><fmt:formatNumber value="${order.pay_price}" pattern="#,###"/>원</div>
                                </div>
                            </div>
                            <div class="order-foot">
                                <button class="btn btn-gray btn-sm">배송 추적</button>
                            </div>
                        </div>
                    </c:forEach>
                </div>

                <!-- 2. 재입고 알림 탭 -->
                <div class="my-sub" id="my-restock">
                    <div class="sec-title" style="margin-bottom:16px;">신청한 재입고 알림</div>
                    
                    <%-- 실제 재입고 알림 리스트 (restockList) 출력 영역 --%>
                    <c:if test="${empty restockList}">
                        <div style="text-align:center; padding:40px; color:var(--gray4); background:var(--gray7); border:1px solid var(--border);">
                            신청하신 재입고 알림 내역이 없습니다.
                        </div>
                    </c:if>
                    <c:forEach var="restock" items="${restockList}">
                        <div class="order-card">
                            <div class="order-hdr">
                                <span class="order-num">신청일: ${restock.reg_date}</span>
                                <span class="badge b-gray" style="margin-left:auto">입고 대기중</span>
                            </div>
                            <div class="order-body">
                                <div class="order-thumb">
                                    <img src="${pageContext.request.contextPath}/upload/${restock.prod_img_url}" style="width:100%;height:100%;object-fit:cover;" alt="상품이미지">
                                </div>
                                <div style="flex:1;">
                                    <div class="order-info-name" style="color:var(--gray3);font-size:11px;">${restock.brand_name}</div>
                                    <div class="order-info-name">${restock.prod_name}</div>
                                </div>
                                <div style="flex-shrink:0;">
                                    <button class="btn btn-outline btn-sm">알림 취소</button>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>

                <!-- 3. 전체 주문 내역 탭 -->
                <div class="my-sub" id="my-orders">
                    <div class="tabs"><div class="tab on">전체</div><div class="tab">배송중</div><div class="tab">배송완료</div></div>
                    
                    <%-- 실제 전체 주문 리스트 (orderList) 출력 영역 --%>
                    <c:if test="${empty orderList}">
                        <div style="text-align:center; padding:40px; color:var(--gray4); background:var(--gray7); border:1px solid var(--border); margin-top:16px;">
                            주문하신 내역이 없습니다.
                        </div>
                    </c:if>
                    <c:forEach var="order" items="${orderList}">
                        <div class="order-card" style="margin-top:16px;">
                            <div class="order-hdr">
                                <span class="order-num">#${order.order_num}</span>
                                <span class="badge b-blue">배송상태</span>
                            </div>
                            <div class="order-body">
                                <div class="order-thumb">
                                    <img src="${pageContext.request.contextPath}/upload/${order.prod_img_url}" style="width:100%;height:100%;object-fit:cover;" alt="상품이미지">
                                </div>
                                <div>
                                    <div class="order-info-name">${order.prod_name}</div>
                                    <div class="order-info-price"><fmt:formatNumber value="${order.pay_price}" pattern="#,###"/>원</div>
                                </div>
                            </div>
                            <div class="order-foot">
                                <button class="btn btn-gray btn-sm">배송 추적</button>
                                <button class="btn btn-outline btn-sm" onclick="setMy(document.querySelector('.my-menu-item:last-child'),'my-return')">반품/교환</button>
                            </div>
                        </div>
                    </c:forEach>
                </div>

                <!-- 4. 내 정보 수정 탭 (기존 유지) -->
                <div class="my-sub" id="my-info">
                    <form action="${pageContext.request.contextPath}/shop/user/modify.do" method="post" id="modifyForm">
                        <div class="form-sec" style="border:none;padding:0;max-width:100%">
                            <div class="form-group"><label class="form-label">아이디</label><input class="form-input" name="id" value="${user.user_id}" readonly style="background:var(--gray7);color:var(--gray4)"></div>
                            <div class="form-row">
                                <div class="form-group"><label class="form-label">이름</label><input class="form-input" name="name" value="${user.user_name}"></div>
                                <div class="form-group"><label class="form-label">연락처</label><input class="form-input" name="phone" value="${user.phone}"></div>
                            </div>
                            <div class="form-group"><label class="form-label">이메일</label><input class="form-input" type="email" name="email" value="${user.email}"></div>
                            <div class="form-group"><label class="form-label">주소</label>
                                <div class="input-with-btn" style="margin-bottom:8px">
                                    <input class="form-input" name="zipcode" id="zipcode" value="${user.zipcode}" readonly style="width:110px;flex:0 0 110px">
                                    <button type="button" class="btn btn-outline btn-sm">우편번호 찾기</button>
                                </div>
                                <input class="form-input" name="addr1" id="addr1" value="${user.addr1}" style="margin-bottom:6px">
                                <input class="form-input" name="addr2" id="addr2" value="${user.addr2}">
                            </div>
                            
                            <div class="form-group"><label class="form-label">현재 비밀번호 (필수)</label><input class="form-input" type="password" name="passwd" placeholder="정보를 수정하려면 현재 비밀번호를 입력하세요"></div>
                            
                            <div class="form-row">
                                <div class="form-group"><label class="form-label">새 비밀번호</label><input class="form-input" type="password" name="new_passwd" placeholder="변경 시에만 입력"></div>
                                <div class="form-group"><label class="form-label">비밀번호 확인</label><input class="form-input" type="password" name="new_passwd_confirm" placeholder="변경 시에만 입력"></div>
                            </div>
                            <button type="submit" class="btn btn-black" style="margin-top:4px; width:100%">정보 수정하기</button>
                        </div>
                    </form>
                </div>

                <!-- 5. 반품/교환 탭 -->
                <div class="my-sub" id="my-return">
                    <div class="form-sec" style="border:none;padding:0;max-width:100%">
                        <div class="form-group">
                            <label class="form-label">주문 선택</label>
                            <select class="form-input" name="order_num">
                                <%-- 나중에 진짜 주문 리스트가 넘어오면 이 부분이 채워짐 --%>
                                <c:if test="${empty orderList}">
                                    <option value="">선택할 수 있는 주문 내역이 없습니다</option>
                                </c:if>
                                <c:forEach var="order" items="${orderList}">
                                    <option value="${order.order_num}">#${order.order_num} - ${order.prod_name}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="form-group"><label class="form-label">신청 유형</label><div style="display:flex;gap:16px;margin-top:6px"><label style="display:flex;align-items:center;gap:6px;font-size:13px"><input type="radio" name="rt" checked>반품</label><label style="display:flex;align-items:center;gap:6px;font-size:13px"><input type="radio" name="rt">교환</label></div></div>
                        <div class="form-group"><label class="form-label">사유</label><select class="form-input"><option>단순 변심</option><option>사이즈 불량</option><option>상품 불량</option><option>오배송</option></select></div>
                        <div class="form-group"><label class="form-label">상세 내용</label><textarea class="form-input" placeholder="자세한 내용을 입력해주세요"></textarea></div>
                        <button class="btn btn-black" style="margin-top:4px; width:100%">신청하기</button>
                    </div>
                </div>

            </div>
        </div>
    </div>

<script>
// 마이페이지 탭 전환 스크립트
function setMy(el, id) {
    document.querySelectorAll('.my-menu-item').forEach(m => m.classList.remove('on'));
    el.classList.add('on');
    
    document.querySelectorAll('.my-sub').forEach(s => s.classList.remove('on'));
    document.getElementById(id).classList.add('on');
}

// 주문내역의 탭(전체/배송중/배송완료) 스크립트
document.querySelectorAll('.tab').forEach(t => t.addEventListener('click', function() {
    this.closest('.tabs').querySelectorAll('.tab').forEach(x => x.classList.remove('on'));
    this.classList.add('on');
}));
</script>
</body>
</html>