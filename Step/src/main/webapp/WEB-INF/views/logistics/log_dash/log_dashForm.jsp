<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>물류 대시보드</title>
<link rel="stylesheet" href="${pageContext.request.contextPath }/css/YH_style.css" type="text/css">
<link href="https://fonts.googleapis.com/css2?family=Pretendard:wght@300;400;500;600;700&family=DM+Mono:wght@400;500&display=swap" rel="stylesheet">
<style>
/* CONTENT */
.content{flex:1;overflow-y:auto;padding:24px}
.content::-webkit-scrollbar{width:5px}
.content::-webkit-scrollbar-thumb{background:var(--gray5);border-radius:3px}

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
      <span class="breadcrumb-cur" id="pg-title">물류 대시보드</span>
    </div>
    <div class="topbar-right">
      <div class="tb-date" id="realTimeClock"></div>
      <div class="tb-btn">🔔<div class="notif-dot"></div></div>	<!-- 알림창 보여주기 (추가) -->      
    </div>
  </div>

<!-- CONTENT(대시보드 내용) 시작 -->
<div class="content">

    <!-- ══════ 대시보드 ══════ -->
    <div class="page active" id="pg-dashboard">

      <!-- KPI -->
      <div class="kpi-row">
        <div class="kpi blue" onclick="location.href='${ pageContext.request.contextPath }/logistics/log_in/log_inForm.do'">
          <div class="kpi-label">오늘 입고</div>
          <div class="kpi-val colored-blue">127</div> <!-- 입고 테이블에서 수량정보 가져오기 -->
          <!-- 입고테이블에서 날짜를 기준으로 비교해서 수량 정보 가죠오기 -->
          <div class="kpi-change up">▲ 23 &nbsp;<span class="neutral">어제 대비</span></div>
        </div>
        <div class="kpi green" onclick="location.href='${ pageContext.request.contextPath }/logistics/log_out/log_outForm.do'">
          <div class="kpi-label">오늘 출고</div>	<!-- 출고 테이블에서 수량정보 가져오기 -->
          <div class="kpi-val colored-green">84</div>
          <!-- 출고테이블에서 날짜를 기준으로 비교해서 수량 정보 가져오기 -->
          <div class="kpi-change up">▲ 11 &nbsp;<span class="neutral">어제 대비</span></div>
        </div>
        <div class="kpi teal" onclick="location.href='${pageContext.request.contextPath }/logistics/log_stk/log_stkForm.do'">
          <div class="kpi-label">전체 재고</div>
          <div class="kpi-val">4,821</div><!-- 재고 테이블의 총 수량 정보 가져오기 -->
          <div class="kpi-change neutral">켤레 보유</div>
        </div>
        <div class="kpi amber" onclick="location.href='${pageContext.request.contextPath }/logistics/log_stk/log_stkForm.do'">
          <div class="kpi-label">재고 부족 상품</div> <!-- 재고테이블에서 기준수량보다 적은 상품 정보 가져오기 -->
          <div class="kpi-val colored-amber">7</div>
          <div class="kpi-change dn">재고 10개 미만</div>
        </div>
        <div class="kpi red" onclick="location.href='${pageContext.request.contextPath }/logistics/log_return/log_returnForm.do'">
          <div class="kpi-label">미처리 반품</div>
          <div class="kpi-val colored-red">3</div> <!-- 반품/교환 테이블의 정보 가져오기 -->
          <div class="kpi-change dn">처리 대기 중</div>
        </div>
      </div>

      <!-- 알림 -->    <!-- 이 부분은 뺄지 아리면 넣을지 생각 넣을 시 재고 테이블에서 if문을 걸어서 부족한거 있으면 알림보내게끔 구현	 -->
      <div class="alert alert-amber">
        <span class="alert-ico">⚠</span>
        <div><strong>재고 부족 경고</strong> — 나이키 에어맥스 270 (240·245mm), 아디다스 울트라부스트 (260mm) 등 7개 사이즈 재고 10개 미만입니다. 입고 등록을 검토하세요.</div>
      </div>
      <div class="alert alert-blue" style="margin-bottom:20px">
        <span class="alert-ico">ℹ</span>
        <div><strong>재입고 알림 대기</strong> — 5개 상품에 재입고 신청 사용자가 있습니다. 입고 처리 후 자동 알림이 발송됩니다.</div>
      </div>

      <!-- 차트 + 재고 부족 -->
      <div class="grid-3-2">
        <div class="card">
          <div class="card-hdr">
            <span class="card-title">주간 입출고 현황</span>
            <button class="btn btn-outline btn-sm" onclick="location.href='${ pageContext.request.contextPath }/logistics/log_report/log_reportForm.do'">리포트 보기</button>
          </div>
          <div class="card-body">
            <div class="bar-list">
              <div style="display:flex;align-items:center;gap:8px;margin-bottom:10px">
                <span style="display:inline-flex;align-items:center;gap:4px;font-size:11px;color:var(--gray3)"><span style="width:10px;height:10px;border-radius:2px;background:var(--blue);display:inline-block"></span>입고</span>
                <span style="display:inline-flex;align-items:center;gap:4px;font-size:11px;color:var(--gray3)"><span style="width:10px;height:10px;border-radius:2px;background:var(--green);display:inline-block"></span>출고</span>
              </div>
              <!-- 입고테이블과 출고테이블의 수량들을 뽑아서 정보 나타내기 -->
              <div class="bar-row"><div class="bar-lbl">월</div><div class="bar-track"><div class="bar-fill bar-in" style="width:55%">98</div></div></div>
              <div class="bar-row" style="margin-bottom:6px"><div class="bar-lbl"></div><div class="bar-track"><div class="bar-fill bar-out" style="width:42%">75</div></div></div>
              <div class="bar-row"><div class="bar-lbl">화</div><div class="bar-track"><div class="bar-fill bar-in" style="width:48%">86</div></div></div>
              <div class="bar-row" style="margin-bottom:6px"><div class="bar-lbl"></div><div class="bar-track"><div class="bar-fill bar-out" style="width:50%">90</div></div></div>
              <div class="bar-row"><div class="bar-lbl">수</div><div class="bar-track"><div class="bar-fill bar-in" style="width:62%">110</div></div></div>
              <div class="bar-row" style="margin-bottom:6px"><div class="bar-lbl"></div><div class="bar-track"><div class="bar-fill bar-out" style="width:38%">68</div></div></div>
              <div class="bar-row"><div class="bar-lbl" style="color:var(--blue);font-weight:700">목 ●</div><div class="bar-track"><div class="bar-fill bar-in" style="width:71%">127</div></div></div>
              <div class="bar-row"><div class="bar-lbl"></div><div class="bar-track"><div class="bar-fill bar-out" style="width:47%">84</div></div></div>
            </div>
          </div>
        </div>

        <div class="card">
          <div class="card-hdr">
            <span class="card-title">재고 부족 TOP 5</span>
            <button class="btn btn-blue btn-sm" onclick="location.href='${ pageContext.request.contextPath }/logistics/log_in/log_inForm.do'">+ 입고 등록</button>
          </div>
          <div class="card-body-np">
            <table>
              <thead><tr><th>상품명</th><th>사이즈</th><th>재고</th></tr></thead>
              <tbody>
              <!-- 재고테이블에서 수량이 제일 부족한상품들을 rank로 뽑아서 정보 가져오기 -->
                <tr><td>나이키 에어맥스 270</td><td>240mm</td><td><span class="bdg bdg-red">3개</span></td></tr>
                <tr><td>나이키 에어맥스 270</td><td>245mm</td><td><span class="bdg bdg-red">2개</span></td></tr>
                <tr><td>아디다스 울트라부스트</td><td>260mm</td><td><span class="bdg bdg-amber">7개</span></td></tr>
                <tr><td>뉴발란스 990</td><td>270mm</td><td><span class="bdg bdg-amber">8개</span></td></tr>
                <tr><td>나이키 조던 1</td><td>255mm</td><td><span class="bdg bdg-amber">9개</span></td></tr>
              </tbody>
            </table>
          </div>
        </div>
      </div>

      <!-- 최근 입고 + 출고 대기 -->
      <div class="grid-2">
        <div class="card">
          <div class="card-hdr">
            <span class="card-title">최근 입고 내역</span>
            <button class="btn btn-outline btn-sm" onclick="go('inbound',document.querySelector('[onclick*=inbound]'))">전체 보기</button> <!-- 입고 이력 조회 경로 추가 -->
          </div>
          <div class="card-body-np">
            <table>
              <thead><tr><th>입고일시</th><th>상품명</th><th>사이즈/컬러</th><th>수량</th><th>담당자</th></tr></thead>
              <tbody>
              <!-- 입고테이블에서 가장 최근에 입고된 상품들을 순서대로 정렬해서 정보 가져오기(날짜를 기준으로 오름차순 -->
                <tr><td style="font-family:'DM Mono',monospace;font-size:11px;color:var(--gray3)">09:14</td><td>나이키 에어포스1</td><td><span class="bdg bdg-gray">265 / 화이트</span></td><td><span class="bdg bdg-blue">30개</span></td><td>이지훈</td></tr>
                <tr><td style="font-family:'DM Mono',monospace;font-size:11px;color:var(--gray3)">09:02</td><td>아디다스 삼바</td><td><span class="bdg bdg-gray">270 / 블랙</span></td><td><span class="bdg bdg-blue">24개</span></td><td>이지훈</td></tr>
                <tr><td style="font-family:'DM Mono',monospace;font-size:11px;color:var(--gray3)">어제 17:30</td><td>뉴발란스 327</td><td><span class="bdg bdg-gray">255 / 그레이</span></td><td><span class="bdg bdg-blue">18개</span></td><td>박수진</td></tr>
                <tr><td style="font-family:'DM Mono',monospace;font-size:11px;color:var(--gray3)">어제 15:10</td><td>나이키 조던 1</td><td><span class="bdg bdg-gray">260 / 레드</span></td><td><span class="bdg bdg-blue">12개</span></td><td>박수진</td></tr>
              </tbody>
            </table>
          </div>
        </div>

        <div class="card">
          <div class="card-hdr">
            <span class="card-title">출고 대기 주문</span>
            <span class="bdg bdg-amber">5건 대기</span>
          </div>
          <div class="card-body-np">
            <table>
              <thead><tr><th>주문번호</th><th>상품명</th><th>수량</th><th>상태</th></tr></thead>
              <tbody>
              <!--  주문이 들어온 상품에 관해서 출고전에 출고대기를 표시 -->
                <tr><td style="font-family:'DM Mono',monospace;font-size:11px">#0082</td><td>나이키 에어맥스</td><td>1</td><td><span class="bdg bdg-amber">출고 대기</span></td></tr>
                <tr><td style="font-family:'DM Mono',monospace;font-size:11px">#0081</td><td>아디다스 울트라부스트</td><td>1</td><td><span class="bdg bdg-amber">출고 대기</span></td></tr>
                <tr><td style="font-family:'DM Mono',monospace;font-size:11px">#0079</td><td>나이키 조던 1</td><td>2</td><td><span class="bdg bdg-amber">출고 대기</span></td></tr>
                <tr><td style="font-family:'DM Mono',monospace;font-size:11px">#0077</td><td>뉴발란스 990</td><td>1</td><td><span class="bdg bdg-amber">출고 대기</span></td></tr>
                <tr><td style="font-family:'DM Mono',monospace;font-size:11px">#0075</td><td>호카 클리프턴 9</td><td>1</td><td><span class="bdg bdg-amber">출고 대기</span></td></tr>
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </div>

   
</main>
<script>
function updateClock() {
    const now = new Date();
    
    // 년, 월, 일 구하기
    const year = now.getFullYear();
    const month = String(now.getMonth() + 1).padStart(2, '0');
    const day = String(now.getDate()).padStart(2, '0');
    
    // 시, 분 구하기
    const hours = String(now.getHours()).padStart(2, '0');
    const minutes = String(now.getMinutes()).padStart(2, '0');
    
    // 🚨 수정한 부분: JSP가 가로채지 못하게 + 기호로 안전하게 문자열 연결!
    const timeString = year + "-" + month + "-" + day + " " + hours + ":" + minutes;
    
    // 화면에 밀어넣기
    document.getElementById("realTimeClock").innerText = timeString;
}

// 화면이 켜지자마자 바로 시계 표시
updateClock();

// 1분(60000ms)마다 갱신
setInterval(updateClock, 60000);
</script>
</body>
</html>





















