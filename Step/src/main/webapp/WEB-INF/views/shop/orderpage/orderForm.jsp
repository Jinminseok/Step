<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<jsp:include page="/WEB-INF/views/common/header.jsp"/>

<div class="wrap">
    <div class="page-title">주문서 작성</div>
    
    <div class="cart-layout" style="grid-template-columns: 1fr 450px;">
        <div class="order-forms">
            <%-- 배송 정보 --%>
            <div class="form-sec" style="max-width:100%; margin-bottom:24px;">
                <div class="sec-title" style="margin-bottom:20px;">배송 정보</div>
                <div class="form-group"><label class="form-label">받는 사람</label><input type="text" class="form-input"></div>
                <div class="form-group"><label class="form-label">연락처</label><input type="text" class="form-input"></div>
                <div class="form-group"><label class="form-label">주소</label>
                    <div class="input-with-btn" style="margin-bottom:8px;"><input type="text" class="form-input" readonly><button class="btn btn-outline btn-sm">주소 검색</button></div>
                    <input type="text" class="form-input" style="margin-bottom:8px;"><input type="text" class="form-input">
                </div>
            </div>

            <%-- 결제 수단 --%>
            <div class="form-sec" style="max-width:100%;">
                <div class="sec-title" style="margin-bottom:20px;">결제 수단</div>
                <div style="display:grid; grid-template-columns: repeat(3, 1fr); gap:10px;">
                    <button class="btn btn-outline">신용카드</button>
                    <button class="btn btn-outline">무통장입금</button>
                    <button class="btn btn-outline">카카오페이</button>
                </div>
            </div>
        </div>
    </div>
</div>