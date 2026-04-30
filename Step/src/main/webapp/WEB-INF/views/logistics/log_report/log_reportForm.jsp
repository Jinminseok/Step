<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>물류 리포트</title>
<link rel="stylesheet" href="${pageContext.request.contextPath }/css/YH_style.css" type="text/css">
<link href="https://fonts.googleapis.com/css2?family=Pretendard:wght@300;400;500;600;700&family=DM+Mono:wght@400;500&display=swap" rel="stylesheet">
<style>
/* CONTENT */
.page{flex:1;overflow-y:auto;padding:24px}
.page::-webkit-scrollbar{width:5px}
.page::-webkit-scrollbar-thumb{background:var(--gray5);border-radius:3px}

.kpi.blue{cursor: pointer;}
.kpi.green{cursor: pointer;}
.kpi.teal{cursor: pointer;}
.kpi.amber{cursor: pointer;}
.kpi.red{cursor: pointer;}
</style>
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
      <span class="breadcrumb-cur" id="pg-title">물류 리포트</span>
    </div>
    <div class="topbar-right">
      <div class="tb-date">2025-04-24 &nbsp;09:14</div>
      <div class="tb-btn">🔔<div class="notif-dot"></div></div>
      <div class="tb-btn">⚙️</div>
    </div>
  </div>
  
   <!-- ══════ 물류 리포트 ══════ -->
    <div class="page" id="pg-report">
      <div class="search-bar">
        <select class="sel"><option>이번 달</option><option>지난 달</option><option>최근 3개월</option></select>
        <input type="date" class="sel" style="padding:8px 10px">
        <span style="color:var(--gray4);font-size:12px">~</span>
        <input type="date" class="sel" style="padding:8px 10px">
        <button class="btn btn-blue btn-sm">조회</button>
        
      </div>
      <div class="kpi-row">
        <div class="kpi blue" onclick="location.href='${ pageContext.request.contextPath }/logistics/log_in/log_inForm.do'">
        	<div class="kpi-label">이번 달 입고</div>
        	<div class="kpi-val colored-blue">2,847</div>
        	<div class="kpi-change up">▲ 12% 전월 대비</div>
        </div>
        <div class="kpi green" onclick="location.href='${ pageContext.request.contextPath }/logistics/log_out/log_outForm.do'">
	        <div class="kpi-label">이번 달 출고</div>
	        <div class="kpi-val colored-green">2,103</div>
	        <div class="kpi-change up">▲ 8% 전월 대비</div>
        </div>
        <div class="kpi red" onclick="location.href='${pageContext.request.contextPath }/logistics/log_return/log_returnForm.do'">
	        <div class="kpi-label">이번 달 반품</div>
	        <div class="kpi-val colored-red">89</div>
	        <div class="kpi-change neutral">반품률 4.2%</div>
        </div>
        <div class="kpi amber" onclick="location.href='${pageContext.request.contextPath }/logistics/log_stk/log_stkForm.do'">
	        <div class="kpi-label">평균 재고 소진</div>
	        <div class="kpi-val colored-amber">18일</div>
	        <div class="kpi-change neutral">재고 회전율</div>
        </div>
        <div class="kpi red" onclick="location.href='${pageContext.request.contextPath }/logistics/log_return/log_returnForm.do'">
	        <div class="kpi-label">불량 폐기</div>
	        <div class="kpi-val colored-red">12</div>
	        <div class="kpi-change neutral">건</div>
        </div>
      </div>
      <div class="grid-2">
        <div class="card">
          <div class="card-hdr"><span class="card-title">브랜드별 출고 현황</span></div>
          <div class="card-body">
            <div class="bar-list">
              <div class="bar-row">
	              <div class="bar-lbl">나이키</div>
	              <div class="bar-track">
	              	<div class="bar-fill bar-in" style="width:72%">742건 (35%)</div>
	              </div>
              </div>
              <div class="bar-row">
	              <div class="bar-lbl">아디다스</div>
	              <div class="bar-track">
	              	<div class="bar-fill" style="width:48%;background:var(--teal)">498건 (24%)</div>
	              </div>
              </div>
              <div class="bar-row">
	              <div class="bar-lbl">뉴발란스</div>
	              <div class="bar-track">
	              	<div class="bar-fill bar-out" style="width:35%">362건 (17%)</div>
	              </div>
              </div>
              <div class="bar-row">
	              <div class="bar-lbl">호카</div>
	              <div class="bar-track">
	              	<div class="bar-fill" style="width:22%;background:var(--amber)">227건 (11%)</div>
	              </div>
              </div>
              <div class="bar-row">
	              <div class="bar-lbl">기타</div>
	              <div class="bar-track">
	              	<div class="bar-fill" style="width:28%;background:var(--gray4)">274건 (13%)</div>
	              </div>
              </div>
            </div>
          </div>
        </div>
        <div class="card">
          <div class="card-hdr"><span class="card-title">인기 사이즈 TOP 5</span></div>
          <div class="card-body">
            <div class="bar-list">
              <div class="bar-row">
	              <div class="bar-lbl">260mm</div>
	              <div class="bar-track">
	              	<div class="bar-fill bar-in" style="width:65%">684건</div>
	              </div>
              </div>
              <div class="bar-row">
	              <div class="bar-lbl">265mm</div>
	              <div class="bar-track">
	              	<div class="bar-fill" style="width:58%;background:var(--teal)">611건</div>
	              </div>
              </div>
              <div class="bar-row">
	              <div class="bar-lbl">270mm</div>
	              <div class="bar-track">
	              	<div class="bar-fill bar-out" style="width:50%">527건</div>
	              </div>
              </div>
              <div class="bar-row">
	              <div class="bar-lbl">255mm</div>
	              <div class="bar-track">
	              	<div class="bar-fill" style="width:44%;background:var(--amber)">463건</div>
	              </div>
              </div>
              <div class="bar-row">
	              <div class="bar-lbl">250mm</div>
	              <div class="bar-track">
	              	<div class="bar-fill" style="width:36%;background:var(--gray4)">379건</div>
	              </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  
</body>
</html>