<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>ShoeMall - 마이페이지</title>
<link
	href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700;900&family=Space+Grotesk:wght@600;700&display=swap"
	rel="stylesheet">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/KR_style.css">
</head>
<body>
	<%-- 공통 헤더 --%>
	<jsp:include page="/WEB-INF/views/common/header.jsp" />

	<div class="wrap">
		<div class="page-title">마이페이지</div>

		<div class="my-layout">

			<%-- 왼쪽 메뉴 --%>
			<div class="my-menu">
				<div class="my-menu-hdr">${user.user_name}님</div>
				<div class="my-menu-item on" onclick="setMy(this,'my-page')">⭐
					내 정보</div>
				<div class="my-menu-item" id="menu-orders"
					onclick="setMy(this,'my-orders')">🧾 주문 내역</div>
				<div class="my-menu-item" onclick="setMy(this,'my-restock')">⏰
					재입고 알림</div>
				<div class="my-menu-item" onclick="setMy(this,'my-info')">👤 내
					정보 수정</div>
				<div class="my-menu-item" onclick="setMy(this,'my-return')">↩️
					반품/교환</div>
				<div class="my-menu-item" onclick="setMy(this,'my-deleteuser')">🚫
					회원 탈퇴</div>
				<div class="my-menu-item"
					onclick="location.href='${pageContext.request.contextPath}/shop/chat/userChat.do'">
					💬 채팅 문의</div>
			</div>

			<%-- 오른쪽 본문 영역 --%>
			<div class="my-body">

				<!-- 1. 내 정보 탭 -->
				<div class="my-sub on" id="my-page">
					<div class="sec-title">나의 쇼핑 혜택</div>

					<%-- DB 누적 금액 데이터 세팅 --%>
					<c:set var="total_spent"
						value="${empty user.total_amount ? 0 : user.total_amount}" />

					<%-- 등급별 목표 금액 세팅 (10만, 30만, 50만) --%>
					<c:choose>
						<c:when test="${user.grade == 1}">
							<c:set var="target_amount" value="100000" />
						</c:when>
						<c:when test="${user.grade == 2}">
							<c:set var="target_amount" value="300000" />
						</c:when>
						<c:when test="${user.grade == 3}">
							<c:set var="target_amount" value="500000" />
						</c:when>
						<c:otherwise>
							<c:set var="target_amount" value="500000" />
						</c:otherwise>
					</c:choose>

					<%-- 남은 금액 및 퍼센트 바 계산 --%>
					<c:set var="remain_amount" value="${target_amount - total_spent}" />
					<c:if test="${remain_amount < 0}">
						<c:set var="remain_amount" value="0" />
					</c:if>

					<c:set var="percent" value="${(total_spent / target_amount) * 100}" />
					<c:if test="${percent > 100}">
						<c:set var="percent" value="100" />
					</c:if>
					<%-- 최고 등급이면 100%로 보이도록 설정 --%>
					<c:if test="${user.grade >= 4}">
						<c:set var="percent" value="100" />
					</c:if>

					<div
						style="border: 1px solid var(--border); padding: 24px; border-radius: 4px; margin-bottom: 24px; display: flex; flex-direction: column; gap: 16px;">
						<div
							style="display: flex; justify-content: space-between; align-items: flex-end;">
							<div>
								<div
									style="font-size: 12px; color: var(--gray3); margin-bottom: 4px;">현재
									등급</div>
								<div
									style="font-size: 24px; font-weight: 700; color: var(--blue);">
									<c:choose>
										<c:when test="${user.grade == 1}">BRONZE</c:when>
										<c:when test="${user.grade == 2}">SILVER</c:when>
										<c:when test="${user.grade == 3}">GOLD</c:when>
										<c:when test="${user.grade == 4}">VIP</c:when>
										<c:otherwise>일반회원</c:otherwise>
									</c:choose>
								</div>
							</div>
							<div
								style="text-align: right; font-size: 13px; line-height: 1.4;">
								다음 등급 <strong style="color: var(--black);"> <c:choose>
										<c:when test="${user.grade == 1}">SILVER</c:when>
										<c:when test="${user.grade == 2}">GOLD</c:when>
										<c:when test="${user.grade == 3}">VIP</c:when>
										<c:when test="${user.grade == 4}">최고 등급</c:when>
										<c:otherwise>BRONZE</c:otherwise>
									</c:choose>
								</strong>까지<br>

								<%-- 남은 금액 동적 출력 --%>
								<c:choose>
									<c:when test="${user.grade >= 4}">
										<strong style="color: var(--blue); font-size: 16px;">최고
											등급입니다! 🎉</strong>
									</c:when>
									<c:otherwise>
										<strong style="color: var(--red); font-size: 16px;"><fmt:formatNumber
												value="${remain_amount}" pattern="#,###" />원</strong> 남았습니다!
                                    </c:otherwise>
								</c:choose>
							</div>
						</div>
						<div>
							<%-- 퍼센트 바 넓이 동적 적용 --%>
							<div
								style="width: 100%; height: 10px; background: var(--gray6); border-radius: 5px; overflow: hidden;">
								<div
									style="width: ${percent}%; height:100%; background:var(--black); transition: width 0.5s ease-in-out;"></div>
							</div>
							<div
								style="display: flex; justify-content: space-between; font-size: 11px; color: var(--gray4); margin-top: 6px;">
								<span>현재 누적: <fmt:formatNumber value="${total_spent}"
										pattern="#,###" />원
								</span> <span>목표: <fmt:formatNumber value="${target_amount}"
										pattern="#,###" />원
								</span>
							</div>
						</div>
					</div>

					<div class="sec-title" style="margin-top: 32px;">
						최근 주문 현황 <a
							onclick="document.getElementById('menu-orders').click()"
							style="cursor: pointer; font-size: 12px; color: var(--gray4);">더보기
							➔</a>
					</div>

					<%-- 최근 주문 리스트 출력 영역 --%>
					<c:if test="${empty recentOrderList}">
						<div
							style="text-align: center; padding: 40px; color: var(--gray4); background: var(--gray7); border: 1px solid var(--border);">
							최근 주문하신 내역이 없습니다.</div>
					</c:if>
					<c:forEach var="order" items="${recentOrderList}">
						<div class="order-card">
							<div class="order-hdr">
								<span class="order-num">#${order.order_num}</span> <span
									class="badge b-orange">결제완료</span>
							</div>
							<div class="order-body">
								<div class="order-thumb">
									<img
										src="${pageContext.request.contextPath}/upload/${order.prod_img_url}"
										style="width: 100%; height: 100%; object-fit: cover;"
										alt="상품이미지">
								</div>
								<div>
									<div class="order-info-name">${order.prod_name}</div>
									<div class="order-info-price">
										<fmt:formatNumber value="${order.pay_price}" pattern="#,###" />
										원
									</div>
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
					<div class="sec-title" style="margin-bottom: 16px;">신청한 재입고
						알림</div>

					<c:if test="${empty restockList}">
						<div
							style="text-align: center; padding: 40px; color: var(--gray4); background: var(--gray7); border: 1px solid var(--border);">
							신청하신 재입고 알림 내역이 없습니다.</div>
					</c:if>

					<c:forEach var="restock" items="${restockList}">
						<div class="order-card">
							<div class="order-hdr">
								<span class="order-num">신청일: ${restock.reg_date}</span>
								<c:choose>
									<c:when test="${restock.sent_yn eq 'Y'}">
										<span class="badge"
											style="background: #e8f5e9; color: #2e7d32; margin-left: auto;">
											✅ 재입고 완료 </span>
									</c:when>
									<c:otherwise>
										<span class="badge b-gray" style="margin-left: auto;">
											⏳ 입고 대기중 </span>
									</c:otherwise>
								</c:choose>
							</div>
							<div class="order-body">
								<div class="order-thumb">
									<img
										src="${pageContext.request.contextPath}/upload/${restock.prod_img_url}"
										style="width: 100%; height: 100%; object-fit: cover;"
										alt="상품이미지">
								</div>
								<div style="flex: 1;">
									<div class="order-info-name"
										style="color: var(--gray3); font-size: 11px;">${restock.brand_name}</div>
									<div class="order-info-name">${restock.prod_name}</div>
									<div
										style="font-size: 12px; color: var(--gray4); margin-top: 4px;">
										${restock.color} / ${restock.size_val}</div>
								</div>
								<%-- ✅ form submit 방식으로 취소 --%>
								<c:if test="${restock.sent_yn ne 'Y'}">
									<div style="flex-shrink: 0;">
										<form
											action="${pageContext.request.contextPath}/shop/restock/restockCancel.do"
											method="post"
											onsubmit="return confirm('재입고 알림 신청을 취소하시겠습니까?')">
											<input type="hidden" name="alert_num"
												value="${restock.alert_num}">
											<button type="submit" class="btn btn-outline btn-sm">알림
												취소</button>
										</form>
									</div>
								</c:if>
							</div>
						</div>
					</c:forEach>
				</div>

				<!-- 3. 전체 주문 내역 탭 -->
				<div class="my-sub" id="my-orders">
					<div class="tabs">
						<div class="tab on">전체</div>
						<div class="tab">배송중</div>
						<div class="tab">배송완료</div>
					</div>

					<%-- 실제 전체 주문 리스트 출력 영역 --%>
					<c:if test="${empty orderList}">
						<div
							style="text-align: center; padding: 40px; color: var(--gray4); background: var(--gray7); border: 1px solid var(--border); margin-top: 16px;">
							주문하신 내역이 없습니다.</div>
					</c:if>
					<c:forEach var="order" items="${orderList}">
						<div class="order-card" style="margin-top: 16px;">
							<div class="order-hdr">
								<span class="order-num">#${order.order_num}</span> <span
									class="badge b-blue">배송상태</span>
							</div>
							<div class="order-body">
								<div class="order-thumb">
									<img
										src="${pageContext.request.contextPath}/upload/${order.prod_img_url}"
										style="width: 100%; height: 100%; object-fit: cover;"
										alt="상품이미지">
								</div>
								<div>
									<div class="order-info-name">${order.prod_name}</div>
									<div class="order-info-price">
										<fmt:formatNumber value="${order.pay_price}" pattern="#,###" />
										원
									</div>
								</div>
							</div>
							<div class="order-foot">
								<button class="btn btn-gray btn-sm">배송 추적</button>
								<button class="btn btn-outline btn-sm"
									onclick="setMy(document.querySelector('.my-menu-item:last-child'),'my-return')">반품/교환</button>
							</div>
						</div>
					</c:forEach>
				</div>

				<!-- 4. 내 정보 수정 탭 -->
				<div class="my-sub" id="my-info">
					<form
						action="${pageContext.request.contextPath}/shop/user/modify.do"
						method="post" id="modifyForm">
						<div class="form-sec"
							style="border: none; padding: 0; max-width: 100%">
							<div class="form-group">
								<label class="form-label">아이디</label><input class="form-input"
									name="id" value="${user.user_id}" readonly
									style="background: var(--gray7); color: var(--gray4)">
							</div>
							<div class="form-row">
								<div class="form-group">
									<label class="form-label">이름</label><input class="form-input"
										name="name" value="${user.user_name}">
								</div>
								<div class="form-group">
									<label class="form-label">연락처</label><input class="form-input"
										name="phone" value="${user.phone}">
								</div>
							</div>
							<div class="form-group">
								<label class="form-label">이메일</label><input class="form-input"
									type="email" name="email" value="${user.email}">
							</div>
							<div class="form-group">
								<label class="form-label">주소</label>
								<div class="input-with-btn" style="margin-bottom: 8px">
									<input class="form-input" name="zipcode" id="zipcode"
										value="${user.zipcode}" readonly
										style="width: 110px; flex: 0 0 110px">
									<button type="button" class="btn btn-outline btn-sm">우편번호
										찾기</button>
								</div>
								<input class="form-input" name="addr1" id="addr1"
									value="${user.addr1}" style="margin-bottom: 6px"> <input
									class="form-input" name="addr2" id="addr2"
									value="${user.addr2}">
							</div>

							<div class="form-group">
								<label class="form-label">현재 비밀번호 (필수)</label><input
									class="form-input" type="password" name="passwd"
									placeholder="정보를 수정하려면 현재 비밀번호를 입력하세요">
							</div>

							<div class="form-row">
								<div class="form-group">
									<label class="form-label">새 비밀번호</label><input
										class="form-input" type="password" name="new_passwd"
										placeholder="변경 시에만 입력">
								</div>
								<div class="form-group">
									<label class="form-label">비밀번호 확인</label><input
										class="form-input" type="password" name="new_passwd_confirm"
										placeholder="변경 시에만 입력">
								</div>
							</div>
							<button type="submit" class="btn btn-black"
								style="margin-top: 4px; width: 100%">정보 수정하기</button>
						</div>
					</form>
				</div>

				<!-- 5. 반품/교환 탭 -->
				<div class="my-sub" id="my-return">
					
					<%-- 내부 탭 버튼 --%>
					<div class="tabs" id="return-tabs" style="margin-bottom: 24px;">
						<div class="tab on" onclick="switchReturnTab('available')">신청하기</div>
						<div class="tab" onclick="switchReturnTab('history')">신청 내역 조회</div>
					</div>

					<%-- 5-1. 반품/교환 신청 폼 (신청하기 탭) --%>
					<div id="return-available" style="display: block;">
						<form
							action="${pageContext.request.contextPath}/shop/user/returnRequest.do"
							method="post">
							<div class="form-sec" style="border: none; padding: 0; max-width: 100%">
								<div class="form-group">
									<label class="form-label">주문 선택 (배송완료 상품만 가능)</label> 
									<select class="form-input" name="order_num">
										<c:set var="deliveredCount" value="0" />
										<c:forEach var="order" items="${orderList}">
											<c:if test="${order.order_status == 4}">
												<option value="${order.order_num}">#${order.order_num} - ${order.prod_name}</option>
												<c:set var="deliveredCount" value="${deliveredCount + 1}" />
											</c:if>
										</c:forEach>
										<c:if test="${deliveredCount == 0}">
											<option value="">선택할 수 있는 배송완료 내역이 없습니다</option>
										</c:if>
									</select>
								</div>
								<div class="form-group">
									<label class="form-label">신청 유형</label>
									<div style="display: flex; gap: 16px; margin-top: 6px">
										<label style="display: flex; align-items: center; gap: 6px; font-size: 13px">
											<input type="radio" name="tp" value="1" checked>반품
										</label> 
										<label style="display: flex; align-items: center; gap: 6px; font-size: 13px">
											<input type="radio" name="tp" value="2">교환
										</label>
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
								<button type="submit" class="btn btn-black" style="margin-top: 4px; width: 100%">신청하기</button>
							</div>
						</form>
					</div>

					<%-- 5-2. 신청 내역 조회 탭 --%>
					<div id="return-history" style="display: none;">
						<c:if test="${empty returnList}">
							<div style="text-align: center; padding: 40px; color: var(--gray4); background: var(--gray7); border: 1px solid var(--border);">
								신청하신 반품/교환 내역이 없습니다.
							</div>
						</c:if>

						<c:forEach var="ret" items="${returnList}">
							<div class="order-card" style="margin-bottom: 16px;">
								<div class="order-hdr">
									<span class="order-num">신청번호: #${ret.ret_num} (원주문: #${ret.order_num})</span>
									<c:choose>
										<c:when test="${ret.ret_status == 1}"><span class="badge b-gray">처리 대기중</span></c:when>
										<c:when test="${ret.ret_status == 2}"><span class="badge b-blue">수거 진행중</span></c:when>
										<c:when test="${ret.ret_status == 3}"><span class="badge" style="background: #e8f5e9; color: #2e7d32;">처리 완료</span></c:when>
										<c:when test="${ret.ret_status == 4}"><span class="badge b-red">반려됨</span></c:when>
										<c:otherwise><span class="badge b-gray">상태 미상</span></c:otherwise>
									</c:choose>
								</div>
								
								<div class="order-body">
									<div class="order-thumb">
										<img src="${pageContext.request.contextPath}/upload/${ret.prod_img_url}"
											style="width: 100%; height: 100%; object-fit: cover;" alt="상품이미지">
									</div>
									<div style="flex: 1;">
										<div class="order-info-name">
											<strong style="color: var(--blue);">[${ret.tp == 1 ? '반품' : '교환'}]</strong> ${ret.prod_name}
										</div>
										<div style="font-size: 13px; color: var(--gray3); margin-top: 4px;">사유: ${ret.reason}</div>
										<div style="font-size: 12px; color: var(--gray4); margin-top: 4px;">상세: <c:out value="${ret.ret_note}"/></div>
									</div>
								</div>
								
								<%-- 상태가 '대기중(1)'일 때만 버튼 및 수정 폼 출력 --%>
								<c:if test="${ret.ret_status == 1}">
									<div class="order-foot" style="justify-content: flex-end; gap: 8px; display: flex;">
										<%-- 클릭 시 해당 ret_num을 가진 폼 영역을 토글 --%>
										<button type="button" class="btn btn-outline btn-sm" onclick="toggleReturnEdit(${ret.ret_num})">
											내용 수정
										</button>
										
										<form action="${pageContext.request.contextPath}/shop/user/returnDelete.do" method="post" onsubmit="return confirm('이 반품/교환 신청을 정말 취소하시겠습니까?');">
											<input type="hidden" name="ret_num" value="${ret.ret_num}">
											<button type="submit" class="btn btn-gray btn-sm">신청 취소</button>
										</form>
									</div>

									<%-- 🌟 아래로 펼쳐지는 인라인 수정 폼 (초기엔 display: none) 🌟 --%>
									<div id="edit-form-${ret.ret_num}" style="display: none; background: var(--gray7); padding: 16px; border-radius: 4px; margin-top: 16px; border: 1px solid var(--border);">
										<div style="font-weight: 600; margin-bottom: 12px; font-size: 14px;">수정할 내용 입력</div>
										
										<form action="${pageContext.request.contextPath}/shop/user/returnUpdate.do" method="post">
											<input type="hidden" name="ret_num" value="${ret.ret_num}">
											
											<div class="form-group">
												<label class="form-label" style="font-size: 12px;">신청 유형</label>
												<div style="display: flex; gap: 16px; margin-top: 4px">
													<label style="display: flex; align-items: center; gap: 6px; font-size: 13px">
														<input type="radio" name="tp" value="1" ${ret.tp == 1 ? 'checked' : ''}>반품
													</label> 
													<label style="display: flex; align-items: center; gap: 6px; font-size: 13px">
														<input type="radio" name="tp" value="2" ${ret.tp == 2 ? 'checked' : ''}>교환
													</label>
												</div>
											</div>
											
											<div class="form-group">
												<label class="form-label" style="font-size: 12px;">사유</label>
												<select class="form-input" name="reason">
													<option value="단순 변심" ${ret.reason == '단순 변심' ? 'selected' : ''}>단순 변심</option>
													<option value="사이즈 불량" ${ret.reason == '사이즈 불량' ? 'selected' : ''}>사이즈 불량</option>
													<option value="상품 불량" ${ret.reason == '상품 불량' ? 'selected' : ''}>상품 불량</option>
													<option value="오배송" ${ret.reason == '오배송' ? 'selected' : ''}>오배송</option>
													<option value="기타" ${ret.reason == '기타' ? 'selected' : ''}>기타</option>
												</select>
											</div>
											
											<div class="form-group">
												<label class="form-label" style="font-size: 12px;">상세 내용</label>
												<textarea class="form-input" name="ret_note" style="min-height: 80px;"><c:out value="${ret.ret_note}"/></textarea>
											</div>
											
											<div style="display: flex; gap: 8px; margin-top: 12px;">
												<button type="button" class="btn btn-outline" style="flex: 1;" onclick="toggleReturnEdit(${ret.ret_num})">닫기</button>
												<button type="submit" class="btn btn-black" style="flex: 1;">수정 완료</button>
											</div>
										</form>
									</div>
								</c:if>
							</div>
						</c:forEach>
					</div>
				</div>

				<!-- 6. 회원 탈퇴 탭 -->
				<div class="my-sub" id="my-deleteuser">
					<div class="sec-title"
						style="margin-bottom: 16px; color: var(--red);">회원 탈퇴</div>

					<%-- 경고 메시지 박스 --%>
					<div
						style="background: #ffebee; color: #b71c1c; padding: 20px; border-radius: 4px; margin-bottom: 24px; font-size: 13px; line-height: 1.6;">
						<strong>⚠️ 탈퇴 전 반드시 확인해 주세요!</strong><br> - 탈퇴 시 구매 내역, 장바구니,
						찜 목록 등 모든 이용 정보가 삭제되며 복구할 수 없습니다.<br> - 부정 이용 방지를 위해 <strong>동일한
							아이디로는 다시 가입할 수 없습니다.</strong><br> - 정보 확인을 위해 본인의 아이디, 이메일, 비밀번호를 정확히
						입력해 주세요.
					</div>

					<%-- 탈퇴 폼 (제출 전 자바스크립트로 검사) --%>
					<form
						action="${pageContext.request.contextPath}/shop/user/deleteUser.do"
						method="post" id="deleteForm" onsubmit="return checkDelete()">
						<div class="form-sec"
							style="border: none; padding: 0; max-width: 100%">

							<div class="form-row">
								<div class="form-group">
									<label class="form-label">아이디 확인</label> <input
										class="form-input" type="text" id="del_id" name="id"
										placeholder="아이디 입력">
								</div>
								<div class="form-group">
									<label class="form-label">이메일 확인</label> <input
										class="form-input" type="email" id="del_email" name="email"
										placeholder="등록된 이메일 입력">
								</div>
							</div>

							<div class="form-row">
								<div class="form-group">
									<label class="form-label">비밀번호</label> <input
										class="form-input" type="password" id="del_pwd" name="passwd"
										placeholder="현재 비밀번호 입력">
								</div>
								<div class="form-group">
									<label class="form-label">비밀번호 확인</label> <input
										class="form-input" type="password" id="del_pwd_confirm"
										placeholder="비밀번호 재입력">
								</div>
							</div>

							<button type="submit" class="btn btn-red"
								style="margin-top: 10px; width: 100%; height: 52px; font-size: 15px;">안내사항을
								확인하였으며, 탈퇴에 동의합니다</button>
						</div>
					</form>
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

// 회원 탈퇴 유효성 체크
function checkDelete() {
    const inputId = document.getElementById('del_id').value;
    const inputEmail = document.getElementById('del_email').value;
    const inputPwd = document.getElementById('del_pwd').value;
    const inputPwdConfirm = document.getElementById('del_pwd_confirm').value;

    const realId = '${user.user_id}';
    const realEmail = '${user.email}';

    if(inputId !== realId) {
        alert("입력하신 아이디가 로그인된 아이디와 일치하지 않습니다.");
        document.getElementById('del_id').focus();
        return false;
    }
    if(inputEmail !== realEmail) {
        alert("입력하신 이메일이 등록된 이메일과 일치하지 않습니다.");
        document.getElementById('del_email').focus();
        return false;
    }
    if(inputPwd === "") {
        alert("비밀번호를 입력해주세요.");
        document.getElementById('del_pwd').focus();
        return false;
    }
    if(inputPwd !== inputPwdConfirm) {
        alert("비밀번호와 비밀번호 확인이 일치하지 않습니다.");
        document.getElementById('del_pwd_confirm').focus();
        return false;
    }
    return confirm("정말로 ShoeMall에서 탈퇴하시겠습니까?\n이 작업은 되돌릴 수 없습니다.");
}

//반품/교환 내부 탭 전환 함수
function switchReturnTab(tabName) {
    const tabs = document.querySelectorAll('#return-tabs .tab');
    tabs.forEach(t => t.classList.remove('on'));

    if (tabName === 'available') {
        tabs[0].classList.add('on');
        document.getElementById('return-available').style.display = 'block';
        document.getElementById('return-history').style.display = 'none';
        closeEditReturnForm(); // 탭 이동 시 수정 폼 닫기
    } else {
        tabs[1].classList.add('on');
        document.getElementById('return-available').style.display = 'none';
        document.getElementById('return-history').style.display = 'block';
    }
}

//반품/교환 인라인 폼 토글 (열기/닫기)
function toggleReturnEdit(retNum) {
    const editForm = document.getElementById('edit-form-' + retNum);
    
    if (editForm.style.display === 'none' || editForm.style.display === '') {
        // 숨겨져 있으면 보이게 처리 (부드러운 효과를 위해 block 대신 사용)
        editForm.style.display = 'block';
    } else {
        // 보이고 있으면 숨기기
        editForm.style.display = 'none';
    }
}

</script>
</body>
</html>