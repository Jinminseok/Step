<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>물류 리포트</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/YH_style.css" type="text/css">
<link href="https://fonts.googleapis.com/css2?family=Pretendard:wght@300;400;500;600;700&family=DM+Mono:wght@400;500&display=swap" rel="stylesheet">
<style>
.page{flex:1;overflow-y:auto;padding:24px}
.page::-webkit-scrollbar{width:5px}
.page::-webkit-scrollbar-thumb{background:var(--gray5);border-radius:3px}
.kpi.blue{cursor:pointer}.kpi.green{cursor:pointer}.kpi.teal{cursor:pointer}.kpi.amber{cursor:pointer}.kpi.red{cursor:pointer}

/* 검색바 */
.search-bar{display:flex;align-items:center;gap:8px;margin-bottom:20px;flex-wrap:wrap;
  padding:14px 18px;background:var(--white);border:1px solid var(--gray6);border-radius:10px;
  box-shadow:0 1px 3px rgba(15,32,68,.05);}
.search-bar .sel{padding:8px 10px;border:1.5px solid var(--gray5);background:var(--white);
  font-size:12.5px;font-family:'Pretendard',sans-serif;color:var(--gray2);outline:none;border-radius:7px;cursor:pointer;}

/* 바 차트 레이블 너비 확장 */
.bar-lbl{min-width:70px}

/* 월별 트렌드 카드 */
.trend-grid{display:grid;grid-template-columns:repeat(3,1fr);gap:10px;margin-top:4px}
.trend-item{text-align:center;background:var(--bg2);border-radius:8px;padding:12px 8px;border:1px solid var(--gray6)}
.trend-mon{font-size:10px;font-weight:700;color:var(--gray3);text-transform:uppercase;margin-bottom:8px}
.trend-in{font-family:'DM Mono',monospace;font-size:15px;font-weight:700;color:var(--blue)}
.trend-out{font-family:'DM Mono',monospace;font-size:13px;font-weight:600;color:var(--green);margin-top:4px}
.trend-label{font-size:9px;color:var(--gray4);margin-top:2px}

/* 빈 데이터 */
.empty-chart{text-align:center;padding:30px;color:var(--gray4);font-size:12px}

.kpi-row { grid-template-columns: repeat(4, 1fr) !important; }
</style>
</head>
<body>
<jsp:include page="/WEB-INF/views/common/log_header.jsp"/>

<main class="main">
  <div class="topbar">
    <div class="breadcrumb">
      <span class="breadcrumb-root">Step WMS</span>
      <span class="breadcrumb-sep">›</span>
      <span class="breadcrumb-cur">물류 리포트</span>
    </div>
    <div class="topbar-right">
      <div class="tb-date" id="realTimeClock"></div>
      <div class="tb-btn">🔔<div class="notif-dot"></div></div>
    </div>
  </div>

  <div class="page">

    <!-- ── 검색 바 ── -->
    <form action="${pageContext.request.contextPath}/logistics/log_report/log_reportForm.do" method="get" class="search-bar">
      <select class="sel" id="quickSel" onchange="setQuick(this.value)">
        <option value="">기간 선택</option>
        <option value="this_month">이번 달</option>
        <option value="last_month">지난 달</option>
        <option value="3month">최근 3개월</option>
        <option value="6month">최근 6개월</option>
      </select>
      <input type="date" name="startDate" id="startDate" class="sel" value="${startDate}">
      <span style="color:var(--gray4);font-size:12px">~</span>
      <input type="date" name="endDate"   id="endDate"   class="sel" value="${endDate}">
      <button type="submit" class="btn btn-blue btn-sm">조회</button>
      <span style="font-size:11px;color:var(--gray4);margin-left:4px">
        조회 기간: <strong style="color:var(--gray2)">${startDate} ~ ${endDate}</strong>
      </span>
    </form>

    <!-- ── KPI ── -->
    <div class="kpi-row">
      <div class="kpi blue" onclick="location.href='${pageContext.request.contextPath}/logistics/log_in/log_inForm.do'">
        <div class="kpi-label">기간 내 입고</div>
        <div class="kpi-val colored-blue">${thisInQty}</div>
        <c:choose>
          <c:when test="${inPct >= 0}">
            <div class="kpi-change up">▲ ${inPct}% &nbsp;<span class="neutral">전월 대비</span></div>
          </c:when>
          <c:otherwise>
            <div class="kpi-change dn">▼ ${-inPct}% &nbsp;<span class="neutral">전월 대비</span></div>
          </c:otherwise>
        </c:choose>
      </div>
      <div class="kpi green" onclick="location.href='${pageContext.request.contextPath}/logistics/log_out/log_outForm.do'">
        <div class="kpi-label">기간 내 출고</div>
        <div class="kpi-val colored-green">${thisOutQty}</div>
        <c:choose>
          <c:when test="${outPct >= 0}">
            <div class="kpi-change up">▲ ${outPct}% &nbsp;<span class="neutral">전월 대비</span></div>
          </c:when>
          <c:otherwise>
            <div class="kpi-change dn">▼ ${-outPct}% &nbsp;<span class="neutral">전월 대비</span></div>
          </c:otherwise>
        </c:choose>
      </div>
      <div class="kpi teal" onclick="location.href='${pageContext.request.contextPath}/logistics/log_stk/log_stkForm.do'">
        <div class="kpi-label">현재 전체 재고</div>
        <div class="kpi-val">${totalStock}</div>
        <div class="kpi-change neutral">켤레 보유</div>
      </div>
      
      <div class="kpi red" onclick="location.href='${pageContext.request.contextPath}/logistics/log_return/log_returnForm.do'">
        <div class="kpi-label">미처리 반품</div>
        <div class="kpi-val colored-red">-</div>
        <div class="kpi-change neutral">반품 구현 후 연동</div>
      </div>
    </div>

    <!-- ── 월별 입출고 추이 ── -->
    <div class="card" style="margin-bottom:18px">
      <div class="card-hdr">
        <span class="card-title">📈 월별 입출고 추이 (최근 3개월)</span>
      </div>
      <div class="card-body">
        <div style="display:flex;align-items:center;gap:12px;margin-bottom:14px">
          <span style="display:inline-flex;align-items:center;gap:4px;font-size:11px;color:var(--gray3)">
            <span style="width:10px;height:10px;border-radius:2px;background:var(--blue);display:inline-block"></span>입고
          </span>
          <span style="display:inline-flex;align-items:center;gap:4px;font-size:11px;color:var(--gray3)">
            <span style="width:10px;height:10px;border-radius:2px;background:var(--green);display:inline-block"></span>출고
          </span>
        </div>
        <c:choose>
          <c:when test="${empty monthlyTrend}">
            <div class="empty-chart">📭 데이터가 없습니다.</div>
          </c:when>
          <c:otherwise>
            <%-- 최대값 계산 --%>
            <c:set var="maxVal" value="1"/>
            <c:forEach var="m" items="${monthlyTrend}">
              <c:if test="${m.inQty  > maxVal}"><c:set var="maxVal" value="${m.inQty}"/></c:if>
              <c:if test="${m.outQty > maxVal}"><c:set var="maxVal" value="${m.outQty}"/></c:if>
            </c:forEach>
            <div class="trend-grid">
              <c:forEach var="m" items="${monthlyTrend}">
                <div class="trend-item">
                  <div class="trend-mon">${m.mon}</div>
                  <div class="trend-in">${m.inQty}</div>
                  <div class="trend-label">입고</div>
                  <div class="trend-out">${m.outQty}</div>
                  <div class="trend-label">출고</div>
                  <div style="margin-top:8px">
                    <div style="height:4px;background:var(--gray6);border-radius:2px;overflow:hidden;margin-bottom:3px">
                      <div style="height:100%;background:var(--blue);border-radius:2px;width:${m.inQty * 100 / maxVal}%"></div>
                    </div>
                    <div style="height:4px;background:var(--gray6);border-radius:2px;overflow:hidden">
                      <div style="height:100%;background:var(--green);border-radius:2px;width:${m.outQty * 100 / maxVal}%"></div>
                    </div>
                  </div>
                </div>
              </c:forEach>
            </div>
          </c:otherwise>
        </c:choose>
      </div>
    </div>

    <!-- ── 3단 차트 ── -->
    <div class="grid-3" style="display:grid;grid-template-columns:1fr 1fr 1fr;gap:16px;margin-bottom:18px">

      <!-- 브랜드별 출고 -->
      <div class="card">
        <div class="card-hdr"><span class="card-title">🏷️ 브랜드별 출고</span></div>
        <div class="card-body">
          <c:choose>
            <c:when test="${empty brandOutbound}">
              <div class="empty-chart">출고 데이터가 없습니다.</div>
            </c:when>
            <c:otherwise>
              <c:set var="maxBrand" value="1"/>
              <c:forEach var="b" items="${brandOutbound}">
                <c:if test="${b.qty > maxBrand}"><c:set var="maxBrand" value="${b.qty}"/></c:if>
              </c:forEach>
              <div class="bar-list">
                <c:forEach var="b" items="${brandOutbound}">
                  <c:set var="bw" value="${b.qty * 100 / maxBrand}"/>
                  <div class="bar-row">
                    <div class="bar-lbl">${b.brandName}</div>
                    <div class="bar-track">
                      <div class="bar-fill bar-in" style="width:${bw}%">${b.qty}건</div>
                    </div>
                  </div>
                </c:forEach>
              </div>
            </c:otherwise>
          </c:choose>
        </div>
      </div>

      <!-- 인기 사이즈 TOP5 -->
      <div class="card">
        <div class="card-hdr"><span class="card-title">👟 인기 사이즈 TOP5</span></div>
        <div class="card-body">
          <c:choose>
            <c:when test="${empty topSizes}">
              <div class="empty-chart">출고 데이터가 없습니다.</div>
            </c:when>
            <c:otherwise>
              <c:set var="maxSize" value="1"/>
              <c:forEach var="s" items="${topSizes}">
                <c:if test="${s.qty > maxSize}"><c:set var="maxSize" value="${s.qty}"/></c:if>
              </c:forEach>
              <div class="bar-list">
                <c:forEach var="s" items="${topSizes}" varStatus="vs">
                  <c:set var="sw" value="${s.qty * 100 / maxSize}"/>
                  <c:set var="colors" value="var(--blue),var(--teal),var(--green),var(--amber),var(--gray4)"/>
                  <div class="bar-row">
                    <div class="bar-lbl">${s.sizeVal}mm</div>
                    <div class="bar-track">
                      <div class="bar-fill bar-in" style="width:${sw}%">${s.qty}건</div>
                    </div>
                  </div>
                </c:forEach>
              </div>
            </c:otherwise>
          </c:choose>
        </div>
      </div>

      <!-- 인기 카테고리 TOP5 -->
      <div class="card">
        <div class="card-hdr"><span class="card-title">📂 인기 카테고리 TOP5</span></div>
        <div class="card-body">
          <c:choose>
            <c:when test="${empty topCategories}">
              <div class="empty-chart">출고 데이터가 없습니다.</div>
            </c:when>
            <c:otherwise>
              <c:set var="maxCat" value="1"/>
              <c:forEach var="ct" items="${topCategories}">
                <c:if test="${ct.qty > maxCat}"><c:set var="maxCat" value="${ct.qty}"/></c:if>
              </c:forEach>
              <c:set var="totalCatQty" value="0"/>
              <c:forEach var="ct" items="${topCategories}">
                <c:set var="totalCatQty" value="${totalCatQty + ct.qty}"/>
              </c:forEach>
              <div class="bar-list">
                <c:forEach var="ct" items="${topCategories}">
                  <c:set var="cw" value="${ct.qty * 100 / maxCat}"/>
                  <c:set var="pct" value="${totalCatQty > 0 ? ct.qty * 100 / totalCatQty : 0}"/>
                  <div class="bar-row">
                    <div class="bar-lbl">${ct.catName}</div>
                    <div class="bar-track">
                      <div class="bar-fill bar-out" style="width:${cw}%">${ct.qty}건 (${pct}%)</div>
                    </div>
                  </div>
                </c:forEach>
              </div>
            </c:otherwise>
          </c:choose>
        </div>
      </div>

    </div>

  </div><%-- /page --%>
</main>

<script>
function updateClock() {
    var now = new Date();
    var s = now.getFullYear() + "-"
          + String(now.getMonth()+1).padStart(2,'0') + "-"
          + String(now.getDate()).padStart(2,'0') + " "
          + String(now.getHours()).padStart(2,'0') + ":"
          + String(now.getMinutes()).padStart(2,'0');
    document.getElementById("realTimeClock").innerText = s;
}
updateClock();
setInterval(updateClock, 60000);

// 빠른 기간 선택
function setQuick(val) {
    var now  = new Date();
    var sEl  = document.getElementById('startDate');
    var eEl  = document.getElementById('endDate');
    var fmt  = function(d){ return d.getFullYear()+'-'+String(d.getMonth()+1).padStart(2,'0')+'-'+String(d.getDate()).padStart(2,'0'); };

    if (val === 'this_month') {
        var s = new Date(now.getFullYear(), now.getMonth(), 1);
        sEl.value = fmt(s); eEl.value = fmt(now);
    } else if (val === 'last_month') {
        var s = new Date(now.getFullYear(), now.getMonth()-1, 1);
        var e = new Date(now.getFullYear(), now.getMonth(), 0);
        sEl.value = fmt(s); eEl.value = fmt(e);
    } else if (val === '3month') {
        var s = new Date(now.getFullYear(), now.getMonth()-2, 1);
        sEl.value = fmt(s); eEl.value = fmt(now);
    } else if (val === '6month') {
        var s = new Date(now.getFullYear(), now.getMonth()-5, 1);
        sEl.value = fmt(s); eEl.value = fmt(now);
    }
}
</script>
</body>
</html>
