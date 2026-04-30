<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>물류 대시보드</title>
<link rel="stylesheet" href="${pageContext.request.contextPath }/css/YH_style.css" type="text/css">
</head>
<body>
	<jsp:include page="/WEB-INF/views/common/log_header.jsp"/>
<!-- ═══ MAIN ═══ -->
<main class="main">
  <!-- TOPBAR -->
  <div class="topbar">
    <div class="breadcrumb">
      <span class="breadcrumb-root">Step WMS</span>
      <span class="breadcrumb-sep">›</span>
      <span class="breadcrumb-cur" id="pg-title">물류 대시보드</span>
    </div>
    <div class="topbar-right">
      <div class="tb-date">2025-04-24 &nbsp;09:14</div>	<!-- 실시간 시간 보여주기 (추가) -->
      <div class="tb-btn">🔔<div class="notif-dot"></div></div>	<!-- 알림창 보여주기 (추가) -->
      <div class="tb-btn">⚙️</div>
    </div>
  </div>
</body>
</html>