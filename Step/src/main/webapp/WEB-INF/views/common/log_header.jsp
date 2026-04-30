<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String currentMenu = (String) request.getAttribute("currentMenu");
    if (currentMenu == null) currentMenu = "";
    String cp = request.getContextPath();
%>
<style>
/* ── 사이드바 핵심 스타일 ──────────────────────────── */

.nav-item a {
    color: rgba(255, 255, 255, 0.48);
    text-decoration: none;
    font-size: 12.5px;
    font-weight: 500;
}
.nav-item a:link,
.nav-item a:visited {
    color: rgba(255, 255, 255, 0.48);
    text-decoration: none;
}
.nav-item:hover a {
    color: rgba(255, 255, 255, 0.85);
}
.nav-item.active a {
    color: #fff;
    font-weight: 600;
}
</style>

<!-- ═══ SIDEBAR ═══ -->
<aside class="sidebar">

    <!-- 헤더 -->
    <div class="sb-header">
        <div class="sb-logo">
            <div class="sb-logo-mark">S</div>
            <div class="sb-logo-txt">Step<em>WMS</em></div>
        </div>
        <div class="sb-sys-badge">
            <div class="sb-sys-dot"></div>
            <div class="sb-sys-txt">실시간 운영 중</div>
        </div>
    </div>

    <!-- 내비게이션 -->
    <nav class="nav">

        <div class="nav-section">대시보드</div>
        <div class="nav-item <%= "dash".equals(currentMenu) ? "active" : "" %>" onclick="location.href='${pageContext.request.contextPath }/logistics/log_dash/log_dashForm.do'">
            <span class="nav-ico">📊</span>물류 대시보드
        </div>

        <div class="nav-section">재고 관리</div>
        <div class="nav-item <%= "stk".equals(currentMenu) ? "active" : "" %>" onclick="location.href='${pageContext.request.contextPath }/logistics/log_stk/log_stkForm.do'">
            <span class="nav-ico">🗃️</span>재고현황 조회
        </div>
        <div class="nav-item <%= "prod".equals(currentMenu) ? "active" : "" %>" onclick="location.href='${pageContext.request.contextPath }/logistics/log_prod/log_prodForm.do'">
            <span class="nav-ico">📑</span>상품 마스터 관리
        </div>

        <div class="nav-section">입출고</div>
        <div class="nav-item <%= "in".equals(currentMenu) ? "active" : "" %>" onclick="location.href='${pageContext.request.contextPath }/logistics/log_in/log_inForm.do'">
            <span class="nav-ico">📥</span>입고 관리
        </div>
        <div class="nav-item <%= "out".equals(currentMenu) ? "active" : "" %>" onclick="location.href='${pageContext.request.contextPath }/logistics/log_out/log_outForm.do'">
            <span class="nav-ico">📤</span>출고 관리
        </div>

        <div class="nav-section">반품 / 교환 재고반영</div>
        <div class="nav-item <%= "ret".equals(currentMenu) ? "active" : "" %>"onclick="location.href='${pageContext.request.contextPath }/logistics/log_return/log_returnForm.do'">
            <span class="nav-ico">↩️</span>반품/교환 재고 반영
        </div>

        <div class="nav-section">리포트</div>
        <div class="nav-item <%= "rep".equals(currentMenu) ? "active" : "" %>" onclick="location.href='${pageContext.request.contextPath }/logistics/log_report/log_reportForm.do'">
            <span class="nav-ico">📋</span>물류 리포트
        </div>

    </nav>

    <!-- 하단 사용자 -->
    <div class="sb-footer">
        <div class="user-card">
            <div class="user-av">이</div>
            <div>
                <div class="user-name">이지훈</div>
                <div class="user-role">물류 담당자</div>
            </div>
            <div class="logout-btn"
                 onclick="window.location.href='<%= cp %>/logis/logout'">
                로그아웃
            </div>
        </div>
    </div>

</aside>
