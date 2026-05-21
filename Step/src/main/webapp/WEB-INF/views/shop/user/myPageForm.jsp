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
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
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

				<%-- ✅ 주문 취소 결과 메시지 --%>
				<c:if test="${not empty cancelMsg}">
					<script>alert('${cancelMsg}');</script>
					<c:remove var="cancelMsg" scope="session" />
				</c:if>
				<%-- 리뷰 등록 결과 메시지 --%>
				<c:if test="${not empty reviewMsg}">
					<script> alert('${reviewMsg}'); </script>
					<c:remove var="reviewMsg" scope="session" />
				</c:if>

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

				<!-- 3. 전체 주문 내역 탭 ✅ 상태별 배지 + 조건부 버튼 적용 -->
				<div class="my-sub" id="my-orders">
					<div class="tabs">
						<div class="tab on" onclick="filterOrders(this, 0)">전체</div>
						<div class="tab" onclick="filterOrders(this, 1)">배송대기</div>
						<div class="tab" onclick="filterOrders(this, 4)">배송완료</div>
					</div>

					<c:if test="${empty orderList}">
						<div
							style="text-align: center; padding: 40px; color: var(--gray4); background: var(--gray7); border: 1px solid var(--border); margin-top: 16px;">
							주문하신 내역이 없습니다.</div>
					</c:if>

					<c:forEach var="order" items="${orderList}">
						<div class="order-card order-item"
							data-status="${order.order_status}" style="margin-top: 16px;">
							<div class="order-hdr">
								<span class="order-num">#${order.order_num}</span>

								<%-- ✅ 실제 배송 상태 배지 --%>
								<c:choose>
									<c:when test="${order.order_status == 1}">
										<span class="badge b-orange">📦 배송대기</span>
									</c:when>
									<c:when test="${order.order_status == 2}">
										<span class="badge"
											style="background: #e0f2fe; color: #0369a1;">🏭 배송준비중</span>
									</c:when>
									<c:when test="${order.order_status == 3}">
										<span class="badge b-blue">🚚 배송중</span>
									</c:when>
									<c:when test="${order.order_status == 4}">
										<span class="badge"
											style="background: #dcfce7; color: #15803d;">✅ 배송완료</span>
									</c:when>
									<c:when test="${order.order_status == 5}">
										<span class="badge"
											style="background: #fef2f2; color: #dc2626;">🚫 취소됨</span>
									</c:when>
								</c:choose>
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

							<%-- ✅ 상태별 조건부 버튼 --%>
							<div class="order-foot">
								<c:choose>

									<%-- 배송대기: 주문 취소만 가능 --%>
									<c:when test="${order.order_status == 1}">
										<form
											action="${pageContext.request.contextPath}/shop/user/orderCancel.do"
											method="post"
											onsubmit="return confirm('주문 #${order.order_num}을 취소하시겠습니까?\n취소 후에는 되돌릴 수 없습니다.')">
											<input type="hidden" name="orderNum"
												value="${order.order_num}">
											<button type="submit" class="btn btn-red btn-sm">🚫
												주문 취소</button>
										</form>
									</c:when>



									<%-- 배송완료: 리뷰 작성 여부에 따라 버튼 분기 --%>
									<c:when test="${order.order_status == 4}">
										<button class="btn btn-outline btn-sm"
											onclick="setMy(document.querySelector('.my-menu-item:nth-child(6)'), 'my-return')">
											↩️ 반품/교환</button>

										<%--리뷰 미작성 --%>
										<c:if test="${order.review_num == 0}">
											<button class="btn btn-black btn-sm"
												onclick="openReviewModal(${order.order_num}, ${order.prod_num}, '${order.prod_name}')">
												✏️ 리뷰 작성</button>
										</c:if>

										<%-- 리뷰 작성 완료 --%>
										<c:if test="${order.review_num != 0}">
											<button class="btn btn-outline btn-sm"
												onclick="openEditReviewModal(${order.review_num}, ${order.review_rating}, '${order.review_content}', '${order.prod_name}')">
												🖊️ 리뷰 수정</button>
											<form
												action="${pageContext.request.contextPath}/shop/review/deleteReview.do"
												method="post" onsubmit="return confirm('리뷰를 삭제하시겠습니까?')">
												<input type="hidden" name="reviewNum"
													value="${order.review_num}">
												<button type="submit" class="btn btn-red btn-sm">🗑️
													리뷰 삭제</button>
											</form>
										</c:if>
									</c:when>

									<%-- 취소됨 --%>
									<c:when test="${order.order_status == 5}">
										<span style="font-size: 12px; color: var(--gray4);">처리
											완료된 주문입니다.</span>
									</c:when>

								</c:choose>
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

					<div class="tabs" id="return-tabs" style="margin-bottom: 24px;">
						<div class="tab on" onclick="switchReturnTab('available')">신청하기</div>
						<div class="tab" onclick="switchReturnTab('history')">신청 내역
							조회</div>
					</div>

					<div id="return-available" style="display: block;">
						<form
							action="${pageContext.request.contextPath}/shop/user/returnRequest.do"
							method="post">
							<div class="form-sec"
								style="border: none; padding: 0; max-width: 100%">
								<div class="form-group">
									<label class="form-label">반품/교환할 상품 선택 (배송완료 상품만 가능)</label> <select
										class="form-input" name="item_info" required>
										<option value="">상품을 선택해 주세요</option>
										<c:set var="itemCount" value="0" />
										<c:forEach var="item" items="${deliveredItemList}">
											<option
												value="${item.order_num}_${item.prod_num}_${item.opt_num}">
												[주문 #${item.order_num}] ${item.prod_name} (옵션:
												${item.opt_info == null ? '단일옵션' : item.opt_info})</option>
											<c:set var="itemCount" value="${itemCount + 1}" />
										</c:forEach>
										<c:if test="${itemCount == 0}">
											<option value="" disabled>선택할 수 있는 배송완료 상품이 없습니다</option>
										</c:if>
									</select>
								</div>
								<div class="form-group">
									<label class="form-label">신청 유형</label>
									<div style="display: flex; gap: 16px; margin-top: 6px">
										<label
											style="display: flex; align-items: center; gap: 6px; font-size: 13px">
											<input type="radio" name="tp" value="1" checked>반품
										</label> <label
											style="display: flex; align-items: center; gap: 6px; font-size: 13px">
											<input type="radio" name="tp" value="2">교환
										</label>
									</div>
								</div>
								<div class="form-group">
									<label class="form-label">사유</label> <select class="form-input"
										name="reason">
										<option value="단순 변심">단순 변심</option>
										<option value="사이즈 불량">사이즈 불량</option>
										<option value="상품 불량">상품 불량</option>
										<option value="오배송">오배송</option>
										<option value="기타">기타</option>
									</select>
								</div>
								<div class="form-group">
									<label class="form-label">상세 내용</label>
									<textarea class="form-input" name="ret_note"
										placeholder="자세한 내용을 입력해주세요"></textarea>
								</div>
								<button type="submit" class="btn btn-black"
									style="margin-top: 4px; width: 100%">신청하기</button>
							</div>
						</form>
					</div>

					<div id="return-history" style="display: none;">
						<c:if test="${empty returnList}">
							<div
								style="text-align: center; padding: 40px; color: var(--gray4); background: var(--gray7); border: 1px solid var(--border);">
								신청하신 반품/교환 내역이 없습니다.</div>
						</c:if>

						<c:forEach var="ret" items="${returnList}">
							<div class="order-card" style="margin-bottom: 16px;">
								<div class="order-hdr">
									<span class="order-num">신청번호: #${ret.ret_num} (원주문:
										#${ret.order_num})</span>
									<c:choose>
										<c:when test="${ret.ret_status == 1}">
											<span class="badge b-gray">처리 대기중</span>
										</c:when>
										<c:when test="${ret.ret_status == 2}">
											<span class="badge b-blue">수거 진행중</span>
										</c:when>
										<c:when test="${ret.ret_status == 3}">
											<span class="badge"
												style="background: #e8f5e9; color: #2e7d32;">처리 완료</span>
										</c:when>
										<c:when test="${ret.ret_status == 4}">
											<span class="badge b-red">반려됨</span>
										</c:when>
										<c:otherwise>
											<span class="badge b-gray">상태 미상</span>
										</c:otherwise>
									</c:choose>
								</div>
								<div class="order-body">
									<div class="order-thumb">
										<img
											src="${pageContext.request.contextPath}/upload/${ret.prod_img_url}"
											style="width: 100%; height: 100%; object-fit: cover;"
											alt="상품이미지">
									</div>
									<div style="flex: 1;">
										<div class="order-info-name">
											<strong style="color: var(--blue);">[${ret.tp == 1 ? '반품' : '교환'}]</strong>
											${ret.prod_name}
										</div>
										<div
											style="font-size: 13px; color: var(--gray3); margin-top: 4px;">사유:
											${ret.reason}</div>
										<div
											style="font-size: 12px; color: var(--gray4); margin-top: 4px;">
											상세:
											<c:out value="${ret.ret_note}" />
										</div>
									</div>
								</div>
								<c:if test="${ret.ret_status == 1}">
									<div class="order-foot"
										style="justify-content: flex-end; gap: 8px; display: flex;">
										<button type="button" class="btn btn-outline btn-sm"
											onclick="toggleReturnEdit(${ret.ret_num})">내용 수정</button>
										<form
											action="${pageContext.request.contextPath}/shop/user/returnDelete.do"
											method="post"
											onsubmit="return confirm('이 반품/교환 신청을 정말 취소하시겠습니까?');">
											<input type="hidden" name="ret_num" value="${ret.ret_num}">
											<button type="submit" class="btn btn-gray btn-sm">신청
												취소</button>
										</form>
									</div>
									<div id="edit-form-${ret.ret_num}"
										style="display: none; background: var(--gray7); padding: 16px; border-radius: 4px; margin-top: 16px; border: 1px solid var(--border);">
										<div
											style="font-weight: 600; margin-bottom: 12px; font-size: 14px;">수정할
											내용 입력</div>
										<form
											action="${pageContext.request.contextPath}/shop/user/returnUpdate.do"
											method="post">
											<input type="hidden" name="ret_num" value="${ret.ret_num}">
											<div class="form-group">
												<label class="form-label" style="font-size: 12px;">신청
													유형</label>
												<div style="display: flex; gap: 16px; margin-top: 4px">
													<label
														style="display: flex; align-items: center; gap: 6px; font-size: 13px">
														<input type="radio" name="tp" value="1"
														${ret.tp == 1 ? 'checked' : ''}>반품
													</label> <label
														style="display: flex; align-items: center; gap: 6px; font-size: 13px">
														<input type="radio" name="tp" value="2"
														${ret.tp == 2 ? 'checked' : ''}>교환
													</label>
												</div>
											</div>
											<div class="form-group">
												<label class="form-label" style="font-size: 12px;">사유</label>
												<select class="form-input" name="reason">
													<option value="단순 변심"
														${ret.reason == '단순 변심' ? 'selected' : ''}>단순 변심</option>
													<option value="사이즈 불량"
														${ret.reason == '사이즈 불량' ? 'selected' : ''}>사이즈
														불량</option>
													<option value="상품 불량"
														${ret.reason == '상품 불량' ? 'selected' : ''}>상품 불량</option>
													<option value="오배송"
														${ret.reason == '오배송' ? 'selected' : ''}>오배송</option>
													<option value="기타" ${ret.reason == '기타' ? 'selected' : ''}>기타</option>
												</select>
											</div>
											<div class="form-group">
												<label class="form-label" style="font-size: 12px;">상세
													내용</label>
												<textarea class="form-input" name="ret_note"
													style="min-height: 80px;"><c:out
														value="${ret.ret_note}" /></textarea>
											</div>
											<div style="display: flex; gap: 8px; margin-top: 12px;">
												<button type="button" class="btn btn-outline"
													style="flex: 1;" onclick="toggleReturnEdit(${ret.ret_num})">닫기</button>
												<button type="submit" class="btn btn-black" style="flex: 1;">수정
													완료</button>
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
					<div
						style="background: #ffebee; color: #b71c1c; padding: 20px; border-radius: 4px; margin-bottom: 24px; font-size: 13px; line-height: 1.6;">
						<strong>⚠️ 탈퇴 전 반드시 확인해 주세요!</strong><br> - 탈퇴 시 구매 내역, 장바구니,
						찜 목록 등 모든 이용 정보가 삭제되며 복구할 수 없습니다.<br> - 부정 이용 방지를 위해 <strong>동일한
							아이디로는 다시 가입할 수 없습니다.</strong><br> - 정보 확인을 위해 본인의 아이디, 이메일, 비밀번호를 정확히
						입력해 주세요.
					</div>
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
								style="margin-top: 10px; width: 100%; height: 52px; font-size: 15px;">
								안내사항을 확인하였으며, 탈퇴에 동의합니다</button>
						</div>
					</form>
				</div>

			</div>
		</div>
	</div>

	<%-- ✅ 리뷰 작성 모달 --%>
	<div id="modal-review"
		style="display: none; position: fixed; inset: 0; background: rgba(0, 0, 0, .5); z-index: 9999; align-items: center; justify-content: center;">
		<div
			style="background: #fff; width: 480px; border-radius: 8px; overflow: hidden; box-shadow: 0 10px 30px rgba(0, 0, 0, .2);">

			<div
				style="display: flex; align-items: center; justify-content: space-between; padding: 20px 24px; border-bottom: 1px solid var(--border); background: var(--gray7);">
				<div style="font-size: 17px; font-weight: 700;">✏️ 리뷰 작성</div>
				<button onclick="closeReviewModal()"
					style="background: none; border: none; font-size: 22px; cursor: pointer; color: var(--gray4);">×</button>
			</div>

			<form
				action="${pageContext.request.contextPath}/shop/review/writeReview.do"
				method="post" id="reviewForm">
				<input type="hidden" name="orderNum" id="reviewOrderNum"> <input
					type="hidden" name="prodNum" id="reviewProdNum">

				<div
					style="padding: 24px; display: flex; flex-direction: column; gap: 16px;">

					<div>
						<div
							style="font-size: 12px; color: var(--gray3); margin-bottom: 6px;">상품명</div>
						<div id="reviewProdName"
							style="font-weight: 600; font-size: 15px;"></div>
					</div>

					<div>
						<div
							style="font-size: 12px; color: var(--gray3); margin-bottom: 8px;">
							별점 <span style="color: var(--red);">*</span>
						</div>
						<div class="star-wrap"
							style="display: flex; gap: 6px; font-size: 32px; cursor: pointer;">
							<span class="star" data-val="1">☆</span> <span class="star"
								data-val="2">☆</span> <span class="star" data-val="3">☆</span> <span
								class="star" data-val="4">☆</span> <span class="star"
								data-val="5">☆</span>
						</div>
						<input type="hidden" name="rating" id="reviewRating" value="0">
					</div>

					<div>
						<div
							style="font-size: 12px; color: var(--gray3); margin-bottom: 6px;">
							리뷰 내용 <span style="color: var(--red);">*</span>
						</div>
						<textarea name="reviewContent" id="reviewContent"
							style="width: 100%; min-height: 120px; padding: 12px; border: 1px solid var(--border); border-radius: 4px; font-family: inherit; font-size: 14px; resize: vertical; outline: none;"
							placeholder="상품에 대한 솔직한 리뷰를 남겨주세요. (최소 10자)"></textarea>
					</div>
				</div>

				<div
					style="padding: 16px 24px; border-top: 1px solid var(--border); display: flex; gap: 8px; background: var(--gray7);">
					<button type="button" onclick="closeReviewModal()"
						style="flex: 1; height: 44px; background: #fff; border: 1px solid var(--border); border-radius: 4px; cursor: pointer; font-weight: 600;">
						취소</button>
					<button type="submit"
						style="flex: 2; height: 44px; background: var(--black); color: #fff; border: none; border-radius: 4px; cursor: pointer; font-weight: 700; font-size: 15px;">
						리뷰 등록</button>
				</div>
			</form>
		</div>
	</div>
	<%-- ✅ 리뷰 수정 모달 --%>
	<div id="modal-edit-review"
		style="display: none; position: fixed; inset: 0; background: rgba(0, 0, 0, .5); z-index: 9999; align-items: center; justify-content: center;">
		<div
			style="background: #fff; width: 480px; border-radius: 8px; overflow: hidden; box-shadow: 0 10px 30px rgba(0, 0, 0, .2);">

			<div
				style="display: flex; align-items: center; justify-content: space-between; padding: 20px 24px; border-bottom: 1px solid var(--border); background: var(--gray7);">
				<div style="font-size: 17px; font-weight: 700;">🖊️ 리뷰 수정</div>
				<button onclick="closeEditReviewModal()"
					style="background: none; border: none; font-size: 22px; cursor: pointer; color: var(--gray4);">×</button>
			</div>

			<form
				action="${pageContext.request.contextPath}/shop/review/updateReview.do"
				method="post" id="editReviewForm">
				<input type="hidden" name="reviewNum" id="editReviewNum">

				<div
					style="padding: 24px; display: flex; flex-direction: column; gap: 16px;">
					<div>
						<div
							style="font-size: 12px; color: var(--gray3); margin-bottom: 6px;">상품명</div>
						<div id="editReviewProdName"
							style="font-weight: 600; font-size: 15px;"></div>
					</div>
					<div>
						<div
							style="font-size: 12px; color: var(--gray3); margin-bottom: 8px;">
							별점 <span style="color: var(--red);">*</span>
						</div>
						<div class="edit-star-wrap"
							style="display: flex; gap: 6px; font-size: 32px; cursor: pointer;">
							<span class="edit-star" data-val="1">☆</span> <span
								class="edit-star" data-val="2">☆</span> <span class="edit-star"
								data-val="3">☆</span> <span class="edit-star" data-val="4">☆</span>
							<span class="edit-star" data-val="5">☆</span>
						</div>
						<input type="hidden" name="rating" id="editReviewRating" value="0">
					</div>
					<div>
						<div
							style="font-size: 12px; color: var(--gray3); margin-bottom: 6px;">
							리뷰 내용 <span style="color: var(--red);">*</span>
						</div>
						<textarea name="reviewContent" id="editReviewContent"
							style="width: 100%; min-height: 120px; padding: 12px; border: 1px solid var(--border); border-radius: 4px; font-family: inherit; font-size: 14px; resize: vertical; outline: none;"
							placeholder="수정할 내용을 입력해주세요. (최소 10자)"></textarea>
					</div>
				</div>

				<div
					style="padding: 16px 24px; border-top: 1px solid var(--border); display: flex; gap: 8px; background: var(--gray7);">
					<button type="button" onclick="closeEditReviewModal()"
						style="flex: 1; height: 44px; background: #fff; border: 1px solid var(--border); border-radius: 4px; cursor: pointer; font-weight: 600;">
						취소</button>
					<button type="submit"
						style="flex: 2; height: 44px; background: var(--black); color: #fff; border: none; border-radius: 4px; cursor: pointer; font-weight: 700; font-size: 15px;">
						수정 완료</button>
				</div>
			</form>
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

// ✅ 주문내역 탭 필터 (전체 / 배송중 / 배송완료)
function filterOrders(el, status) {
    document.querySelectorAll('#my-orders .tab').forEach(t => t.classList.remove('on'));
    el.classList.add('on');
    document.querySelectorAll('.order-item').forEach(card => {
        const s = parseInt(card.dataset.status);
        card.style.display = (status === 0 || s === status) ? '' : 'none';
    });
}

// 주문내역의 탭(전체/배송중/배송완료) 스크립트 - 기존 유지
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

// 반품/교환 내부 탭 전환 함수
function switchReturnTab(tabName) {
    const tabs = document.querySelectorAll('#return-tabs .tab');
    tabs.forEach(t => t.classList.remove('on'));
    if (tabName === 'available') {
        tabs[0].classList.add('on');
        document.getElementById('return-available').style.display = 'block';
        document.getElementById('return-history').style.display = 'none';
        closeEditReturnForm();
    } else {
        tabs[1].classList.add('on');
        document.getElementById('return-available').style.display = 'none';
        document.getElementById('return-history').style.display = 'block';
    }
}

// 반품/교환 인라인 폼 토글
function toggleReturnEdit(retNum) {
    const editForm = document.getElementById('edit-form-' + retNum);
    editForm.style.display = (editForm.style.display === 'none' || editForm.style.display === '') ? 'block' : 'none';
}

// ✅ 리뷰 모달 열기
function openReviewModal(orderNum, prodNum, prodName) {
    document.getElementById('reviewOrderNum').value = orderNum;
    document.getElementById('reviewProdNum').value  = prodNum;
    document.getElementById('reviewProdName').textContent = prodName;
    document.getElementById('reviewRating').value = 0;
    document.getElementById('reviewContent').value = '';
    setStars(0);
    document.getElementById('modal-review').style.display = 'flex';
}
//✅ 수정 모달 열기
function openEditReviewModal(reviewNum, rating, content, prodName) {
    document.getElementById('editReviewNum').value = reviewNum;
    document.getElementById('editReviewProdName').textContent = prodName;
    document.getElementById('editReviewContent').value = content;
    document.getElementById('editReviewRating').value = rating;
    setEditStars(rating);
    document.getElementById('modal-edit-review').style.display = 'flex';
}

function closeEditReviewModal() {
    document.getElementById('modal-edit-review').style.display = 'none';
}

// ✅ 수정 모달 별점
function setEditStars(val) {
    document.querySelectorAll('.edit-star').forEach(s => {
        s.textContent = parseInt(s.dataset.val) <= val ? '★' : '☆';
        s.style.color  = parseInt(s.dataset.val) <= val ? '#f59e0b' : '#ccc';
    });
}

document.querySelectorAll('.edit-star').forEach(s => {
    s.addEventListener('click', function() {
        const val = parseInt(this.dataset.val);
        document.getElementById('editReviewRating').value = val;
        setEditStars(val);
    });
    s.addEventListener('mouseenter', function() {
        setEditStars(parseInt(this.dataset.val));
    });
});

document.querySelector('.edit-star-wrap')?.addEventListener('mouseleave', function() {
    setEditStars(parseInt(document.getElementById('editReviewRating').value));
});

// ✅ 수정 폼 유효성 검사
document.getElementById('editReviewForm')?.addEventListener('submit', function(e) {
    const rating  = parseInt(document.getElementById('editReviewRating').value);
    const content = document.getElementById('editReviewContent').value.trim();
    if (rating < 1) { alert('별점을 선택해주세요.'); e.preventDefault(); return; }
    if (content.length < 10) { alert('리뷰 내용을 최소 10자 이상 입력해주세요.'); e.preventDefault(); return; }
});

// 수정 모달 외부 클릭 시 닫기
document.getElementById('modal-edit-review')?.addEventListener('click', function(e) {
    if (e.target === this) closeEditReviewModal();
});
function closeReviewModal() {
    document.getElementById('modal-review').style.display = 'none';
}

// ✅ 별점 렌더링
function setStars(val) {
    document.querySelectorAll('.star').forEach(s => {
        s.textContent = parseInt(s.dataset.val) <= val ? '★' : '☆';
        s.style.color  = parseInt(s.dataset.val) <= val ? '#f59e0b' : '#ccc';
    });
}

document.querySelectorAll('.star').forEach(s => {
    s.addEventListener('click', function() {
        const val = parseInt(this.dataset.val);
        document.getElementById('reviewRating').value = val;
        setStars(val);
    });
    s.addEventListener('mouseenter', function() {
        setStars(parseInt(this.dataset.val));
    });
});

document.querySelector('.star-wrap')?.addEventListener('mouseleave', function() {
    setStars(parseInt(document.getElementById('reviewRating').value));
});

// ✅ 리뷰 폼 유효성 검사
document.getElementById('reviewForm')?.addEventListener('submit', function(e) {
    const rating  = parseInt(document.getElementById('reviewRating').value);
    const content = document.getElementById('reviewContent').value.trim();
    if (rating < 1) {
        alert('별점을 선택해주세요.');
        e.preventDefault();
        return;
    }
    if (content.length < 10) {
        alert('리뷰 내용을 최소 10자 이상 입력해주세요.');
        e.preventDefault();
        return;
    }
});

// 모달 외부 클릭 시 닫기
document.getElementById('modal-review')?.addEventListener('click', function(e) {
    if (e.target === this) closeReviewModal();
});
	</script>
</body>
</html>
