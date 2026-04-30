<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    /*
     * 파일명 : logis_main.jsp
     * 경로   : src/main/webapp/WEB-INF/views/main/logis_main.jsp
     * 역할   : 물류 담당자 로그인 화면
     * 호출   : Log_LoginAction.java (GET /logis/login)
     */
    String contextPath = request.getContextPath();
    String loginError  = (String) request.getAttribute("loginError");
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Step WMS — 물류 담당자 로그인</title>

    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Pretendard:wght@300;400;500;600;700&family=DM+Mono:wght@400;500&display=swap" rel="stylesheet">

    <!-- 물류 전용 CSS -->
    <link rel="stylesheet" href="<%= contextPath %>/css/login.css">
</head>
<body>

<!-- ══ 탑 헤더 ══════════════════════════════════════ -->
<header class="log-top-header">
    <div class="log-logo">
        <div class="log-logo-mark">S</div>
        <div class="log-logo-name">Step<span>WMS</span></div>
        <div class="log-logo-sub">Warehouse Management System</div>
    </div>
</header>

<!-- ══ 메인 영역 ═════════════════════════════════════ -->
<div class="log-main">

    <!-- ─── 왼쪽 소개 패널 ──────────────────────── -->
    <div class="log-left">
        <div class="log-left-bg"></div>
        <div class="log-left-grid"></div>
        <div class="log-left-content">

            <!-- 운영 뱃지 -->
            <div class="log-sys-badge">
                <div class="log-badge-pulse"></div>
                <div class="log-badge-txt">실시간 운영 중</div>
            </div>

            <!-- 타이틀 -->
            <h1 class="log-left-title">
                신발 물류<br>
                <span class="log-accent">통합 관리 시스템</span>
            </h1>
            <p class="log-left-desc">
                입고부터 출고, 재고 현황, 반품 처리까지<br>
                신발 물류 전 과정을 하나의 플랫폼에서.
            </p>

            <!-- 기능 목록 -->
            <div class="log-feat-list">
                <div class="log-feat-item">
                    <div class="log-feat-ico">📥</div>
                    <div class="log-feat-txt">
                        <strong>입고 관리</strong>
                        <span>상품·사이즈·컬러별 입고 처리 및 이력 추적</span>
                    </div>
                </div>
                <div class="log-feat-item">
                    <div class="log-feat-ico">📤</div>
                    <div class="log-feat-txt">
                        <strong>출고 / 배송 관리</strong>
                        <span>주문 연동 자동 출고, 송장 등록, 배송 상태 추적</span>
                    </div>
                </div>
                <div class="log-feat-item">
                    <div class="log-feat-ico">📊</div>
                    <div class="log-feat-txt">
                        <strong>실시간 재고 현황</strong>
                        <span>사이즈·컬러별 재고 수량, 부족 알림, 조정 이력</span>
                    </div>
                </div>
                <div class="log-feat-item">
                    <div class="log-feat-ico">↩️</div>
                    <div class="log-feat-txt">
                        <strong>반품 / 교환 처리</strong>
                        <span>반품 검수, 양품·불량 구분, 재고 복구 자동화</span>
                    </div>
                </div>
            </div>

            <!-- 하단 통계 -->
            <div class="log-left-stats">
                <div>
                    <div class="log-stat-num">4,821</div>
                    <div class="log-stat-lbl">총 재고 (켤레)</div>
                </div>
                <div>
                    <div class="log-stat-num">127</div>
                    <div class="log-stat-lbl">오늘 입고</div>
                </div>
                <div>
                    <div class="log-stat-num">84</div>
                    <div class="log-stat-lbl">오늘 출고</div>
                </div>
            </div>

        </div>
    </div><!-- /log-left -->

    <!-- ─── 오른쪽 로그인 폼 ─────────────────────── -->
    <div class="log-right">
        <div class="log-right-top">
            <div class="log-right-top-ico">🔒</div>
            <div class="log-right-top-txt">물류 담당자 전용</div>
        </div>

        <div class="log-form-wrap">
            <div class="log-form-title">로그인</div>
            <div class="log-form-sub">
                물류 전용 계정으로 로그인하세요.<br>
                쇼핑몰 관리자·사용자 계정과 별도로 운영됩니다.
            </div>

            <%-- 로그인 실패 오류 메시지 --%>
            <% if (loginError != null) { %>
                <div class="log-error-msg">⚠ <%= loginError %></div>
            <% } %>

            <%-- 로그인 폼 --%>
            <form id="logLoginForm"
                  action="<%= contextPath %>/logis/login"
                  method="POST">

                <%-- CSRF 방지 토큰 (Spring Security 미사용 시 직접 구현) --%>
                <%-- <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"> --%>

                <div class="log-field">
                    <label class="log-field-label" for="logId">
                        담당자 아이디
                    </label>
                    <div class="log-field-wrap">
                        <span class="log-field-ico">👤</span>
                        <input class="log-field-input"
                               type="text"
                               id="logId"
                               name="loginId"
                               placeholder="아이디를 입력하세요"
                               autocomplete="username"
                               required>
                    </div>
                </div>

                <div class="log-field">
                    <label class="log-field-label" for="logPwd">
                        비밀번호
                    </label>
                    <div class="log-field-wrap">
                        <span class="log-field-ico" id="logPwdToggle"
                              style="cursor:pointer" title="비밀번호 표시">🔑</span>
                        <input class="log-field-input"
                               type="password"
                               id="logPwd"
                               name="pwd"
                               placeholder="비밀번호를 입력하세요"
                               autocomplete="current-password"
                               required>
                    </div>
                </div>

                <div class="log-form-row">
                    <label class="log-check-label">
                        <input type="checkbox" name="rememberMe"> 로그인 상태 유지
                    </label>
                    <span class="log-forgot">비밀번호 찾기</span>
                </div>

                <button type="submit" class="log-btn-login">로그인</button>
            </form>

            <!-- 보안 안내 -->
            <div class="log-warn-box">
                <div class="log-warn-box-title">⚠ 보안 안내</div>
                <ul>
                    <li>물류 시스템은 허가된 담당자만 접근 가능합니다.</li>
                </ul>
            </div>

            <!-- 시스템 상태 -->
            <div class="log-sys-indicators">
                <div class="log-ind-row">
                    <span class="log-ind-lbl">마지막 업데이트</span>
                    <span class="log-ind-date" id="logCurrentTime">수정일 삽입</span>
                </div>
            </div>

        </div><!-- /log-form-wrap -->
    </div><!-- /log-right -->

</div><!-- /log-main -->

<!-- ══ 푸터 ══════════════════════════════════════════ -->
<footer class="log-footer">
    <div class="log-footer-txt">
        © 2026 Step WMS — Warehouse Management System. 물류 담당자 전용 시스템
    </div>
</footer>

<!-- JS -->
<script src="<%= contextPath %>/js/logis_login.js"></script>

</body>
</html>
