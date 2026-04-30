<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>상품 마스터 관리</title>
<link rel="stylesheet" href="${pageContext.request.contextPath }/css/MS_style.css" type="text/css">
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
      <span class="breadcrumb-cur" id="pg-title">상품 마스터 관리</span>
    </div>
    <div class="topbar-right">
      <div class="tb-date">2025-04-24 &nbsp;09:14</div>
      <div class="tb-btn">🔔<div class="notif-dot"></div></div>
      <div class="tb-btn">⚙️</div>
    </div>
  </div>
  <div class="prod_form">
  	<span>품번·상품명·브랜드 검색</span>
  </div>
</body>
</html>