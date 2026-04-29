<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<!-- ═══ SIDEBAR ═══ -->
<aside class="sidebar">
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

  <nav class="nav">
    <div class="nav-section">대시보드</div>
    <div class="nav-item active" onclick="go('dashboard',this)">
      <span class="nav-ico">📊</span>
      <a href="${pageContext.request.contextPath }/logistics/log_dash/log_dashForm.do">물류 대시보드
      </a>
    </div>

    <div class="nav-section">재고 관리</div>
    <div class="nav-item" onclick="go('stock',this)">
      <span class="nav-ico">🗃️</span>
      <a href="${pageContext.request.contextPath }/logistics/log_stk/log_stkForm.do">재고현황 조회
      </a>      
    </div>
    <div class="nav-item" onclick="go('master',this)">
      <span class="nav-ico">📑</span>
      <a href="${pageContext.request.contextPath }/logistics/log_prod/log_prodForm.do">상품 마스터 관리
      </a>
    </div>

    <div class="nav-section">입출고</div>
    <div class="nav-item" onclick="go('inbound',this)">
      <span class="nav-ico">📥</span>
      <a href="${pageContext.request.contextPath }/logistics/log_in/log_inForm.do">입고 관리
      </a>
    </div>
    <div class="nav-item" onclick="go('outbound',this)">
      <span class="nav-ico">📤</span>
      <a href="${pageContext.request.contextPath }/logistics/log_out/log_outForm.do">출고 관리
      </a>    
    </div>

    <div class="nav-section">반품 / 교환 재고반영</div>
    <div class="nav-item" onclick="go('returns',this)">
      <span class="nav-ico">↩️</span>
      <a href="${pageContext.request.contextPath }/logistics/log_return/log_returnForm.do">반품/교환 재고 반영
      </a>     
    </div>

    <div class="nav-section">리포트</div>
    <div class="nav-item" onclick="go('report',this)">
      <span class="nav-ico">📋</span>
      <a href="${pageContext.request.contextPath }/logistics/log_report/log_reportForm.do">물류 리포트
      </a>
    </div>
  </nav>

  <div class="sb-footer">
    <div class="user-card">
      <div class="user-av">이</div>
      <div>
        <div class="user-name">이지훈</div>
        <div class="user-role">물류 담당자</div>
      </div>
      <div class="logout-btn" onclick="window.location.href='04_logistics_login_new.html'">로그아웃</div>
    </div>
  </div>
</aside>

</body>
</html>