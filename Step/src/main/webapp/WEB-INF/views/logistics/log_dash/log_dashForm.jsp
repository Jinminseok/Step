<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>물류 대시보드</title>
<link rel="stylesheet" href="${pageContext.request.contextPath }/css/YH_style.css" type="text/css">
<link href="https://fonts.googleapis.com/css2?family=Pretendard:wght@300;400;500;600;700&family=DM+Mono:wght@400;500&display=swap" rel="stylesheet">
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
      <div class="tb-date" id="realTimeClock"></div>	<!-- 실시간 시간 보여주기 (추가) -->
      <div class="tb-btn">🔔<div class="notif-dot"></div></div>	<!-- 알림창 보여주기 (추가) -->      
    </div>
  </div>

<!-- CONTENT(대시보드 내용) 시작 -->
<div class="content">

    <!-- ══════ 대시보드 ══════ -->
    <div class="page active" id="pg-dashboard">

      <!-- KPI -->
      <div class="kpi-row">
        <div class="kpi blue">
          <div class="kpi-label">오늘 입고</div>
          <div class="kpi-val colored-blue">127</div>
          <div class="kpi-change up">▲ 23 &nbsp;<span class="neutral">어제 대비</span></div>
        </div>
        <div class="kpi green">
          <div class="kpi-label">오늘 출고</div>	
          <div class="kpi-val colored-green">84</div>
          <div class="kpi-change up">▲ 11 &nbsp;<span class="neutral">어제 대비</span></div>
        </div>
        <div class="kpi teal">
          <div class="kpi-label">전체 재고</div>
          <div class="kpi-val">4,821</div>
          <div class="kpi-change neutral">켤레 보유</div>
        </div>
        <div class="kpi amber">
          <div class="kpi-label">재고 부족 상품</div>
          <div class="kpi-val colored-amber">7</div>
          <div class="kpi-change dn">재고 10개 미만</div>
        </div>
        <div class="kpi red">
          <div class="kpi-label">미처리 반품</div>
          <div class="kpi-val colored-red">3</div>
          <div class="kpi-change dn">처리 대기 중</div>
        </div>
      </div>

      <!-- 알림 -->
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

    <!-- ══════ 재고 현황 ══════ -->
    <div class="page" id="pg-stock">
      <div class="search-bar">
        <div class="search-wrap"><span class="search-ico">🔍</span><input placeholder="상품명·브랜드·품번 검색"></div>
        <select class="sel"><option>전체 브랜드</option><option>나이키</option><option>아디다스</option><option>뉴발란스</option><option>호카</option></select>
        <select class="sel"><option>전체 상태</option><option>정상</option><option>주의</option><option>부족</option></select>
        <div style="margin-left:auto;display:flex;gap:8px">
          <button class="btn btn-outline btn-sm">엑셀 다운로드</button>
          <button class="btn btn-blue btn-sm" onclick="go('inbound',document.querySelector('[onclick*=inbound]'))">+ 입고 등록</button>
        </div>
      </div>
      <div class="tabs">
        <div class="tab on" onclick="setTab(this)">전체 재고</div>
        <div class="tab" onclick="setTab(this)">재고 부족 <span style="background:var(--red);color:#fff;border-radius:10px;padding:0 5px;font-size:9px;margin-left:4px">7</span></div>
        <div class="tab" onclick="setTab(this)">품절 상품</div>
      </div>
      <div class="card">
        <div class="card-hdr"><span class="card-title">상품별 재고 현황</span></div>
        <div class="tbl-wrap">
          <table>
            <thead><tr><th>품번</th><th>브랜드</th><th>상품명</th><th>전체 재고</th><th>재고율</th><th>상태</th><th>관리</th></tr></thead>
            <tbody>
              <tr>
                <td style="font-family:'DM Mono',monospace;font-size:11px;color:var(--gray3)">NK-AF1-WHT</td>
                <td>나이키</td><td>에어포스 1</td>
                <td style="font-family:'DM Mono',monospace">148개</td>
                <td><div class="progress-wrap"><div class="progress-track"><div class="progress-fill prog-ok" style="width:74%"></div></div><div class="prog-pct">74%</div></div></td>
                <td><span class="bdg bdg-green">정상</span></td>
                <td><button class="btn btn-outline btn-xs">사이즈별 보기</button></td>
              </tr>
              <tr>
                <td style="font-family:'DM Mono',monospace;font-size:11px;color:var(--gray3)">AD-UB-BLK</td>
                <td>아디다스</td><td>울트라부스트 22</td>
                <td style="font-family:'DM Mono',monospace">32개</td>
                <td><div class="progress-wrap"><div class="progress-track"><div class="progress-fill prog-warn" style="width:32%"></div></div><div class="prog-pct">32%</div></div></td>
                <td><span class="bdg bdg-amber">주의</span></td>
                <td><button class="btn btn-outline btn-xs">사이즈별 보기</button></td>
              </tr>
              <tr>
                <td style="font-family:'DM Mono',monospace;font-size:11px;color:var(--gray3)">NK-AM270-GRY</td>
                <td>나이키</td><td>에어맥스 270</td>
                <td style="font-family:'DM Mono',monospace">11개</td>
                <td><div class="progress-wrap"><div class="progress-track"><div class="progress-fill prog-low" style="width:11%"></div></div><div class="prog-pct">11%</div></div></td>
                <td><span class="bdg bdg-red">부족</span></td>
                <td><button class="btn btn-blue btn-xs">입고 등록</button></td>
              </tr>
              <tr>
                <td style="font-family:'DM Mono',monospace;font-size:11px;color:var(--gray3)">NB-990V5-NVY</td>
                <td>뉴발란스</td><td>990v5</td>
                <td style="font-family:'DM Mono',monospace">87개</td>
                <td><div class="progress-wrap"><div class="progress-track"><div class="progress-fill prog-ok" style="width:87%"></div></div><div class="prog-pct">87%</div></div></td>
                <td><span class="bdg bdg-green">정상</span></td>
                <td><button class="btn btn-outline btn-xs">사이즈별 보기</button></td>
              </tr>
            </tbody>
          </table>
        </div>
        <div style="padding:20px;border-top:1px solid var(--gray7)">
          <div style="font-size:11px;font-weight:700;color:var(--gray3);margin-bottom:10px;text-transform:uppercase;letter-spacing:.07em">나이키 에어맥스 270 · 그레이 — 사이즈별 재고</div>
          <div class="size-grid">
            <div class="size-cell"><div class="size-mm">225</div><div class="size-cnt cnt-ok">18</div></div>
            <div class="size-cell"><div class="size-mm">230</div><div class="size-cnt cnt-ok">22</div></div>
            <div class="size-cell"><div class="size-mm">240</div><div class="size-cnt cnt-low">3</div></div>
            <div class="size-cell"><div class="size-mm">245</div><div class="size-cnt cnt-low">2</div></div>
            <div class="size-cell"><div class="size-mm">250</div><div class="size-cnt cnt-warn">8</div></div>
            <div class="size-cell"><div class="size-mm">255</div><div class="size-cnt cnt-ok">19</div></div>
            <div class="size-cell"><div class="size-mm">260</div><div class="size-cnt cnt-ok">24</div></div>
            <div class="size-cell"><div class="size-mm">265</div><div class="size-cnt cnt-ok">17</div></div>
            <div class="size-cell"><div class="size-mm">270</div><div class="size-cnt cnt-warn">9</div></div>
            <div class="size-cell"><div class="size-mm">275</div><div class="size-cnt cnt-ok">11</div></div>
            <div class="size-cell"><div class="size-mm">280</div><div class="size-cnt cnt-ok">6</div></div>
          </div>
        </div>
      </div>
    </div>

    <!-- ══════ 입고 관리 ══════ -->
    <div class="page" id="pg-inbound">
      <div class="tabs">
        <div class="tab on" onclick="setTab(this)">입고 등록</div>
        <div class="tab" onclick="setTab(this)">입고 이력 조회</div>
      </div>
      <div class="grid-2">
        <div class="card">
          <div class="card-hdr"><span class="card-title">입고 등록</span></div>
          <div class="card-body">
            <div class="form-grid">
              <div class="fg full"><label>상품 검색 (품번 / 상품명)</label><input class="fi" placeholder="NK-AF1-WHT 또는 에어포스 1"></div>
              <div class="fg"><label>브랜드</label><select class="fi"><option>나이키</option><option>아디다스</option><option>뉴발란스</option><option>호카</option></select></div>
              <div class="fg"><label>컬러</label><select class="fi"><option>화이트</option><option>블랙</option><option>그레이</option><option>네이비</option></select></div>
              <div class="fg"><label>사이즈 (mm)</label><select class="fi"><option>225</option><option>230</option><option>240</option><option>250</option><option>255</option><option>260</option><option>265</option><option>270</option></select></div>
              <div class="fg"><label>입고 수량</label><input class="fi" type="number" placeholder="수량 입력" min="1"></div>
              <div class="fg full"><label>입고일</label><input class="fi" type="date"></div>
              <div class="fg full"><label>메모 (선택)</label><textarea class="fi" placeholder="특이사항"></textarea></div>
              <div class="fg full" style="display:flex;gap:8px;justify-content:flex-end">
                <button class="btn btn-outline">초기화</button>
                <button class="btn btn-blue">입고 처리</button>
              </div>
            </div>
          </div>
        </div>
        <div class="card">
          <div class="card-hdr"><span class="card-title">오늘 입고 내역</span><span class="bdg bdg-blue">127건</span></div>
          <div class="card-body-np">
            <table>
              <thead><tr><th>시간</th><th>상품명</th><th>사이즈</th><th>수량</th></tr></thead>
              <tbody>
                <tr><td style="font-family:'DM Mono',monospace;font-size:11px">09:14</td><td>나이키 에어포스1 화이트</td><td>265</td><td><span class="bdg bdg-blue">30</span></td></tr>
                <tr><td style="font-family:'DM Mono',monospace;font-size:11px">09:02</td><td>아디다스 삼바 블랙</td><td>270</td><td><span class="bdg bdg-blue">24</span></td></tr>
                <tr><td style="font-family:'DM Mono',monospace;font-size:11px">08:45</td><td>뉴발란스 990 네이비</td><td>255</td><td><span class="bdg bdg-blue">18</span></td></tr>
                <tr><td style="font-family:'DM Mono',monospace;font-size:11px">08:30</td><td>호카 클리프턴 9 화이트</td><td>260</td><td><span class="bdg bdg-blue">36</span></td></tr>
              </tbody>
            </table>
          </div>
          <div class="card-body" style="padding-top:14px">
            <div class="alert alert-blue" style="margin-bottom:0">
              <span class="alert-ico">🔔</span>재입고 신청 상품이 입고 처리되면 해당 사용자에게 자동 알림이 발송됩니다.
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- ══════ 출고 관리 ══════ -->
    <div class="page" id="pg-outbound">
      <div class="alert alert-amber" style="margin-bottom:20px">
        <span class="alert-ico">⚠</span>
        출고 대기 주문 <strong>5건</strong>이 있습니다. 출고 처리 시 주문 상태가 '배송 중'으로 변경되며 재고가 차감됩니다.
      </div>
      <div class="search-bar">
        <div class="search-wrap"><span class="search-ico">🔍</span><input placeholder="주문번호·상품명 검색"></div>
        <select class="sel"><option>전체 상태</option><option>출고 대기</option><option>출고 완료</option></select>
        <div style="margin-left:auto"><button class="btn btn-blue btn-sm">선택 항목 일괄 출고</button></div>
      </div>
      <div class="card">
        <div class="card-hdr"><span class="card-title">출고 대기 목록</span><span class="bdg bdg-amber">5건</span></div>
        <div class="tbl-wrap">
          <table>
            <thead><tr><th><input type="checkbox"></th><th>주문번호</th><th>주문일시</th><th>상품명</th><th>사이즈/컬러</th><th>수량</th><th>배송지</th><th>상태</th><th>처리</th></tr></thead>
            <tbody>
              <tr>
                <td><input type="checkbox" checked></td>
                <td style="font-family:'DM Mono',monospace;font-size:11px">#20250421-0082</td>
                <td style="font-size:11px;color:var(--gray3)">09:30</td>
                <td>나이키 에어맥스 270</td><td><span class="bdg bdg-gray">265 / 그레이</span></td><td>1</td>
                <td style="font-size:12px">서울 강남구</td>
                <td><span class="bdg bdg-amber">출고 대기</span></td>
                <td><button class="btn btn-blue btn-xs">출고 처리</button></td>
              </tr>
              <tr>
                <td><input type="checkbox" checked></td>
                <td style="font-family:'DM Mono',monospace;font-size:11px">#20250421-0081</td>
                <td style="font-size:11px;color:var(--gray3)">09:15</td>
                <td>아디다스 울트라부스트</td><td><span class="bdg bdg-gray">270 / 블랙</span></td><td>1</td>
                <td style="font-size:12px">경기 수원시</td>
                <td><span class="bdg bdg-amber">출고 대기</span></td>
                <td><button class="btn btn-blue btn-xs">출고 처리</button></td>
              </tr>
              <tr>
                <td><input type="checkbox"></td>
                <td style="font-family:'DM Mono',monospace;font-size:11px">#20250421-0079</td>
                <td style="font-size:11px;color:var(--gray3)">08:55</td>
                <td>나이키 조던 1 레트로</td><td><span class="bdg bdg-gray">260 / 레드</span></td><td>2</td>
                <td style="font-size:12px">부산 해운대구</td>
                <td><span class="bdg bdg-amber">출고 대기</span></td>
                <td><button class="btn btn-blue btn-xs">출고 처리</button></td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
    </div>

    <!-- ══════ 반품/교환 ══════ -->
    <div class="page" id="pg-returns">
      <div class="tabs">
        <div class="tab on" onclick="setTab(this)">재고 반영 대기 <span style="background:var(--red);color:#fff;border-radius:10px;padding:0 5px;font-size:9px;margin-left:4px">3</span></div>
        <div class="tab" onclick="setTab(this)">처리 완료</div>
      </div>
      <div class="card">
        <div class="card-hdr"><span class="card-title">반품/교환 재고 반영 대기</span></div>
        <div class="tbl-wrap">
          <table>
            <thead><tr><th>접수일</th><th>주문번호</th><th>유형</th><th>상품명</th><th>사이즈/컬러</th><th>사유</th><th>재고상태</th><th>처리</th></tr></thead>
            <tbody>
              <tr>
                <td style="font-size:11px;color:var(--gray3)">04-21</td>
                <td style="font-family:'DM Mono',monospace;font-size:11px">#0051</td>
                <td><span class="bdg bdg-red">반품</span></td>
                <td>나이키 에어포스1</td><td><span class="bdg bdg-gray">260 / 화이트</span></td>
                <td style="font-size:12px">단순 변심</td>
                <td><span class="bdg bdg-gray">검수 전</span></td>
                <td style="display:flex;gap:5px">
                  <button class="btn btn-blue btn-xs">양품 복구</button>
                  <button class="btn btn-danger btn-xs">불량 폐기</button>
                </td>
              </tr>
              <tr>
                <td style="font-size:11px;color:var(--gray3)">04-20</td>
                <td style="font-family:'DM Mono',monospace;font-size:11px">#0038</td>
                <td><span class="bdg bdg-amber">교환</span></td>
                <td>아디다스 삼바</td><td><span class="bdg bdg-gray">265→270 / 블랙</span></td>
                <td style="font-size:12px">사이즈 불일치</td>
                <td><span class="bdg bdg-gray">검수 전</span></td>
                <td><button class="btn btn-blue btn-xs">교환 출고 처리</button></td>
              </tr>
              <tr>
                <td style="font-size:11px;color:var(--gray3)">04-20</td>
                <td style="font-family:'DM Mono',monospace;font-size:11px">#0031</td>
                <td><span class="bdg bdg-red">반품</span></td>
                <td>뉴발란스 990v5</td><td><span class="bdg bdg-gray">255 / 네이비</span></td>
                <td style="font-size:12px">상품 불량</td>
                <td><span class="bdg bdg-gray">검수 전</span></td>
                <td style="display:flex;gap:5px">
                  <button class="btn btn-blue btn-xs">양품 복구</button>
                  <button class="btn btn-danger btn-xs">불량 폐기</button>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
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
        <div style="margin-left:auto"><button class="btn btn-outline btn-sm">📥 엑셀 다운로드</button></div>
      </div>
      <div class="kpi-row">
        <div class="kpi blue"><div class="kpi-label">이번 달 입고</div><div class="kpi-val colored-blue">2,847</div><div class="kpi-change up">▲ 12% 전월 대비</div></div>
        <div class="kpi green"><div class="kpi-label">이번 달 출고</div><div class="kpi-val colored-green">2,103</div><div class="kpi-change up">▲ 8% 전월 대비</div></div>
        <div class="kpi red"><div class="kpi-label">이번 달 반품</div><div class="kpi-val colored-red">89</div><div class="kpi-change neutral">반품률 4.2%</div></div>
        <div class="kpi amber"><div class="kpi-label">평균 재고 소진</div><div class="kpi-val colored-amber">18일</div><div class="kpi-change neutral">재고 회전율</div></div>
        <div class="kpi red"><div class="kpi-label">불량 폐기</div><div class="kpi-val colored-red">12</div><div class="kpi-change neutral">건</div></div>
      </div>
      <div class="grid-2">
        <div class="card">
          <div class="card-hdr"><span class="card-title">브랜드별 출고 현황</span></div>
          <div class="card-body">
            <div class="bar-list">
              <div class="bar-row"><div class="bar-lbl">나이키</div><div class="bar-track"><div class="bar-fill bar-in" style="width:72%">742건 (35%)</div></div></div>
              <div class="bar-row"><div class="bar-lbl">아디다스</div><div class="bar-track"><div class="bar-fill" style="width:48%;background:var(--teal)">498건 (24%)</div></div></div>
              <div class="bar-row"><div class="bar-lbl">뉴발란스</div><div class="bar-track"><div class="bar-fill bar-out" style="width:35%">362건 (17%)</div></div></div>
              <div class="bar-row"><div class="bar-lbl">호카</div><div class="bar-track"><div class="bar-fill" style="width:22%;background:var(--amber)">227건 (11%)</div></div></div>
              <div class="bar-row"><div class="bar-lbl">기타</div><div class="bar-track"><div class="bar-fill" style="width:28%;background:var(--gray4)">274건 (13%)</div></div></div>
            </div>
          </div>
        </div>
        <div class="card">
          <div class="card-hdr"><span class="card-title">인기 사이즈 TOP 5</span></div>
          <div class="card-body">
            <div class="bar-list">
              <div class="bar-row"><div class="bar-lbl">260mm</div><div class="bar-track"><div class="bar-fill bar-in" style="width:65%">684건</div></div></div>
              <div class="bar-row"><div class="bar-lbl">265mm</div><div class="bar-track"><div class="bar-fill" style="width:58%;background:var(--teal)">611건</div></div></div>
              <div class="bar-row"><div class="bar-lbl">270mm</div><div class="bar-track"><div class="bar-fill bar-out" style="width:50%">527건</div></div></div>
              <div class="bar-row"><div class="bar-lbl">255mm</div><div class="bar-track"><div class="bar-fill" style="width:44%;background:var(--amber)">463건</div></div></div>
              <div class="bar-row"><div class="bar-lbl">250mm</div><div class="bar-track"><div class="bar-fill" style="width:36%;background:var(--gray4)">379건</div></div></div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- ══════ 상품 마스터 ══════ -->
    <div class="page" id="pg-master">
      <div class="search-bar">
        <div class="search-wrap"><span class="search-ico">🔍</span><input placeholder="품번·상품명·브랜드 검색"></div>
        <div style="margin-left:auto;display:flex;gap:8px">
          <button class="btn btn-outline btn-sm">엑셀 업로드</button>
          <button class="btn btn-blue btn-sm">+ 상품 등록</button>
        </div>
      </div>
      <div class="card">
        <div class="card-hdr"><span class="card-title">상품 마스터 목록</span></div>
        <div class="tbl-wrap">
          <table>
            <thead><tr><th>품번(SKU)</th><th>브랜드</th><th>상품명</th><th>유형</th><th>사이즈 범위</th><th>컬러 수</th><th>총 재고</th><th>상태</th><th>관리</th></tr></thead>
            <tbody>
              <tr><td style="font-family:'DM Mono',monospace;font-size:11px">NK-AF1-WHT</td><td>나이키</td><td>에어포스 1 로우</td><td>캐주얼</td><td>225~280</td><td>3색</td><td style="font-family:'DM Mono',monospace">148</td><td><span class="bdg bdg-green">판매중</span></td><td><button class="btn btn-outline btn-xs">수정</button></td></tr>
              <tr><td style="font-family:'DM Mono',monospace;font-size:11px">AD-UB22-BLK</td><td>아디다스</td><td>울트라부스트 22</td><td>러닝</td><td>230~280</td><td>5색</td><td style="font-family:'DM Mono',monospace">32</td><td><span class="bdg bdg-amber">재고 주의</span></td><td><button class="btn btn-outline btn-xs">수정</button></td></tr>
              <tr><td style="font-family:'DM Mono',monospace;font-size:11px">NK-SBJRD-RED</td><td>나이키</td><td>에어 조던 1 레트로</td><td>농구화</td><td>240~285</td><td>4색</td><td style="font-family:'DM Mono',monospace">0</td><td><span class="bdg bdg-red">품절</span></td><td><button class="btn btn-blue btn-xs">입고 등록</button></td></tr>
            </tbody>
          </table>
        </div>
      </div>
    </div>

  </div>
<!-- CONTENT(대시보드 내용) 끝 -->	

<script>
const titles = {
  dashboard:'물류 대시보드',stock:'재고 현황 조회',
  inbound:'입고 관리',outbound:'출고 관리',
  returns:'반품/교환 재고 반영',report:'물류 리포트',master:'상품 마스터 관리'
};
function go(id, el){
  document.querySelectorAll('.page').forEach(p=>p.classList.remove('active'));
  document.querySelectorAll('.nav-item').forEach(n=>n.classList.remove('active'));
  document.getElementById('pg-'+id).classList.add('active');
  if(el) el.classList.add('active');
  document.getElementById('pg-title').textContent = titles[id]||id;
  window.scrollTo({top:0});
}
function setTab(el){
  el.closest('.tabs').querySelectorAll('.tab').forEach(t=>t.classList.remove('on'));
  el.classList.add('on');
}

function updateClock() {
    const now = new Date();
    
    // 년, 월, 일 구하기 (padStart를 써서 1자리면 앞에 '0'을 붙여줌)
    const year = now.getFullYear();
    const month = String(now.getMonth() + 1).padStart(2, '0'); // 자바스크립트 월은 0부터 시작해서 +1 필요
    const day = String(now.getDate()).padStart(2, '0');
    
    // 시, 분 구하기
    const hours = String(now.getHours()).padStart(2, '0');
    const minutes = String(now.getMinutes()).padStart(2, '0');
    
    // 초까지 원하시면 아래 주석을 풀고 사용하세요!
    // const seconds = String(now.getSeconds()).padStart(2, '0');
    
    // 문자열 조립 (요청하신 YYYY-MM-DD HH:mm 형태)
    const timeString = `${year}-${month}-${day} ${hours}:${minutes}`;
    // 초까지 보여줄 경우: const timeString = `${year}-${month}-${day} ${hours}:${minutes}:${seconds}`;
    
    // 화면에 밀어넣기
    document.getElementById("realTimeClock").innerText = timeString;
}

// 화면이 켜지자마자 바로 시계 표시 (이거 없으면 1분 뒤에 켜짐)
updateClock();

// 60000밀리초(1분)마다 updateClock 함수 반복 실행
// (초 단위까지 보여주게 수정하셨다면 60000을 1000으로 바꾸셔야 1초마다 갱신됩니다!)
setInterval(updateClock, 60000);
</script>
</body>
</html>





















