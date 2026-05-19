<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>ShoeMall - 재입고 알림</title>
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700;900&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/KR_style.css">
</head>
<body>
    <jsp:include page="/WEB-INF/views/common/header.jsp"/>

    <div class="wrap">
        <div class="page-title">재입고 알림 신청 목록</div>

        <%-- 결과 메시지 --%>
        <c:if test="${result eq 'success'}">
            <div style="background:#e8f5e9; color:#2e7d32; padding:14px 20px; 
                        border-radius:4px; margin-bottom:20px; font-size:14px;">
                ✅ 재입고 알림 신청이 완료되었습니다. 재입고 시 알림을 보내드립니다.
            </div>
        </c:if>
        <c:if test="${result eq 'duplicate'}">
            <div style="background:#fff3e0; color:#e65100; padding:14px 20px; 
                        border-radius:4px; margin-bottom:20px; font-size:14px;">
                ⚠️ 이미 재입고 알림을 신청하신 옵션입니다.
            </div>
        </c:if>
        <c:if test="${result eq 'cancel_ok'}">
            <div style="background:#fce4ec; color:#b71c1c; padding:14px 20px; 
                        border-radius:4px; margin-bottom:20px; font-size:14px;">
                🗑️ 재입고 알림 신청이 취소되었습니다.
            </div>
        </c:if>

        <%-- 목록 없을 때 --%>
        <c:if test="${empty restockList}">
            <div style="text-align:center; padding:60px; color:var(--gray4); 
                        background:var(--gray7); border:1px solid var(--border);">
                신청하신 재입고 알림 내역이 없습니다.
            </div>
        </c:if>

        <%-- 목록 출력 --%>
        <c:forEach var="restock" items="${restockList}">
            <div class="order-card">
                <div class="order-hdr">
                    <span class="order-num">신청일: ${restock.reg_date}</span>
                    <c:choose>
                        <c:when test="${restock.sent_yn eq 'Y'}">
                            <span class="badge" 
                                  style="background:#e8f5e9; color:#2e7d32; margin-left:auto;">
                                ✅ 재입고 완료
                            </span>
                        </c:when>
                        <c:otherwise>
                            <span class="badge b-gray" style="margin-left:auto;">
                                ⏳ 입고 대기중
                            </span>
                        </c:otherwise>
                    </c:choose>
                </div>
                <div class="order-body">
                    <div class="order-thumb">
                        <img src="${pageContext.request.contextPath}/upload/${restock.prod_img_url}"
                             style="width:100%; height:100%; object-fit:cover;" alt="상품이미지">
                    </div>
                    <div style="flex:1;">
                        <div class="order-info-name" 
                             style="color:var(--gray3); font-size:11px;">${restock.brand_name}</div>
                        <div class="order-info-name">${restock.prod_name}</div>
                        <div style="font-size:12px; color:var(--gray4); margin-top:4px;">
                            ${restock.color} / ${restock.size_val}
                        </div>
                    </div>
                    <%-- 대기중일 때만 취소 버튼 --%>
                    <c:if test="${restock.sent_yn ne 'Y'}">
                        <div style="flex-shrink:0;">
                            <form action="${pageContext.request.contextPath}/shop/restock/restockCancel.do"
                                  method="post"
                                  onsubmit="return confirm('재입고 알림 신청을 취소하시겠습니까?')">
                                <input type="hidden" name="alert_num" value="${restock.alert_num}">
                                <button type="submit" class="btn btn-outline btn-sm">알림 취소</button>
                            </form>
                        </div>
                    </c:if>
                </div>
            </div>
        </c:forEach>

        <div style="margin-top:24px;">
            <button class="btn btn-gray" onclick="history.back()">← 돌아가기</button>
        </div>
    </div>
</body>
</html>