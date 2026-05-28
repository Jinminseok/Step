<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>물류 대시보드</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/YH_style.css" type="text/css">
<link href="https://fonts.googleapis.com/css2?family=Pretendard:wght@300;400;500;600;700&family=DM+Mono:wght@400;500&display=swap" rel="stylesheet">
<style>
.content{flex:1;overflow-y:auto;padding:24px}
.content::-webkit-scrollbar{width:5px}
.content::-webkit-scrollbar-thumb{background:var(--gray5);border-radius:3px}
.kpi.blue{cursor:pointer}
.kpi.green{cursor:pointer}
.kpi.teal{cursor:pointer}
.kpi.amber{cursor:pointer}
.kpi.red{cursor:pointer}
</style>
</head>
<body>
<jsp:include page="/WEB-INF/views/common/log_header.jsp"/>

<main class="main">
  <div class="topbar">
    <div class="breadcrumb">
      <span class="breadcrumb-root">Step WMS</span>
      <span class="breadcrumb-sep">›</span>
      <span class="breadcrumb-cur" id="pg-title">물류 대시보드</span>
    </div>
    <div class="topbar-right">
      <div class="tb-date" id="realTimeClock"></div>
      
    </div>
  </div>

  <div class="content">
    <div class="page active" id="pg-dashboard">

      <!-- KPI -->
      <div class="kpi-row">

        <div class="kpi blue" onclick="location.href='${pageContext.request.contextPath}/logistics/log_in/log_inForm.do'">
          <div class="kpi-label">오늘 입고</div>
          <div class="kpi-val colored-blue">${todayInQty}</div>
          <c:choose>
            <c:when test="${inDiff >= 0}">
              <div class="kpi-change up">▲ ${inDiff} &nbsp;<span class="neutral">어제 대비</span></div>
            </c:when>
            <c:otherwise>
              <div class="kpi-change dn">▼ ${-inDiff} &nbsp;<span class="neutral">어제 대비</span></div>
            </c:otherwise>
          </c:choose>
        </div>

        <div class="kpi green" onclick="location.href='${pageContext.request.contextPath}/logistics/log_out/log_outForm.do'">
          <div class="kpi-label">오늘 출고</div>
          <div class="kpi-val colored-green">${todayOutQty}</div>
          <c:choose>
            <c:when test="${outDiff >= 0}">
              <div class="kpi-change up">▲ ${outDiff} &nbsp;<span class="neutral">어제 대비</span></div>
            </c:when>
            <c:otherwise>
              <div class="kpi-change dn">▼ ${-outDiff} &nbsp;<span class="neutral">어제 대비</span></div>
            </c:otherwise>
          </c:choose>
        </div>

        <div class="kpi teal" onclick="location.href='${pageContext.request.contextPath}/logistics/log_stk/log_stkForm.do'">
          <div class="kpi-label">전체 재고</div>
          <div class="kpi-val">${totalStock}</div>
          <div class="kpi-change neutral">켤레 보유</div>
        </div>

        <div class="kpi amber" onclick="location.href='${pageContext.request.contextPath}/logistics/log_stk/log_stkForm.do'">
          <div class="kpi-label">재고 부족 상품</div>
          <div class="kpi-val colored-amber">${lowStockCount}</div>
          <div class="kpi-change dn">재고 10개 미만</div>
        </div>

        <div class="kpi red" onclick="location.href='${pageContext.request.contextPath}/logistics/log_return/log_returnForm.do'">
          <div class="kpi-label">미처리 반품</div>
          <div class="kpi-val colored-red">-</div>
          <div class="kpi-change dn">처리 대기 중</div>
        </div>

      </div>

      <!-- 알림 -->
      <div class="alert alert-amber">
        <span class="alert-ico">⚠</span>
        <div><strong>재고 부족 경고</strong> — 재고 10개 미만 상품이 ${lowStockCount}개 있습니다. 입고 등록을 검토하세요.</div>
      </div>
      <div class="alert alert-blue" style="margin-bottom:20px">
        <span class="alert-ico">ℹ</span>
        <div><strong>재입고 알림 대기</strong> — 재입고 신청 사용자가 있는 상품이 있습니다. 입고 처리 후 자동 알림이 발송됩니다.</div>
      </div>

      <!-- 차트 + 재고 부족 TOP5 -->
      <div class="grid-3-2">

        <div class="card">
          <div class="card-hdr">
            <span class="card-title">주간 입출고 현황</span>
            <button class="btn btn-outline btn-sm" onclick="location.href='${pageContext.request.contextPath}/logistics/log_report/log_reportForm.do'">리포트 보기</button>
          </div>
          <div class="card-body">
            <div class="bar-list">
              <div style="display:flex;align-items:center;gap:8px;margin-bottom:10px">
                <span style="display:inline-flex;align-items:center;gap:4px;font-size:11px;color:var(--gray3)">
                  <span style="width:10px;height:10px;border-radius:2px;background:var(--blue);display:inline-block"></span>입고
                </span>
                <span style="display:inline-flex;align-items:center;gap:4px;font-size:11px;color:var(--gray3)">
                  <span style="width:10px;height:10px;border-radius:2px;background:var(--green);display:inline-block"></span>출고
                </span>
              </div>

              <c:choose>
                <c:when test="${empty weeklyInbound}">
                  <div style="text-align:center;color:var(--gray4);padding:30px;font-size:12px;">이번 주 입고 데이터가 없습니다.</div>
                </c:when>
                <c:otherwise>
                  <c:set var="maxQty" value="1"/>
                  <c:forEach var="w" items="${weeklyInbound}">
                    <c:if test="${w.qty > maxQty}"><c:set var="maxQty" value="${w.qty}"/></c:if>
                  </c:forEach>
                  <c:forEach var="out" items="${weeklyOutbound}">
                    <c:if test="${out.qty > maxQty}"><c:set var="maxQty" value="${out.qty}"/></c:if>
                  </c:forEach>

                  <c:forEach var="w" items="${weeklyInbound}">
                    <c:set var="inWidth" value="${w.qty * 100 / maxQty}"/>
                    <div class="bar-row">
                      <div class="bar-lbl">${w.dayLabel}</div>
                      <div class="bar-track"><div class="bar-fill bar-in" style="width:${inWidth}%">${w.qty}</div></div>
                    </div>
                    <c:forEach var="out" items="${weeklyOutbound}">
                      <c:if test="${out.dayLabel eq w.dayLabel}">
                        <c:set var="outWidth" value="${out.qty * 100 / maxQty}"/>
                        <div class="bar-row" style="margin-bottom:6px">
                          <div class="bar-lbl"></div>
                          <div class="bar-track"><div class="bar-fill bar-out" style="width:${outWidth}%">${out.qty}</div></div>
                        </div>
                      </c:if>
                    </c:forEach>
                  </c:forEach>
                </c:otherwise>
              </c:choose>

            </div>
          </div>
        </div>

        <div class="card">
          <div class="card-hdr">
            <span class="card-title">재고 부족 TOP 5</span>
            <button class="btn btn-blue btn-sm" onclick="location.href='${pageContext.request.contextPath}/logistics/log_in/log_inForm.do'">+ 입고 등록</button>
          </div>
          <div class="card-body-np">
            <table>
              <thead><tr><th>상품명</th><th>사이즈</th><th>재고</th></tr></thead>
              <tbody>
                <c:forEach var="s" items="${lowStockTop5}">
                  <tr>
                    <td>${s.prodName}</td>
                    <td>${s.sizeVal}mm</td>
                    <td>
                      <c:choose>
                        <c:when test="${s.stockQty <= 3}"><span class="bdg bdg-red">${s.stockQty}개</span></c:when>
                        <c:otherwise><span class="bdg bdg-amber">${s.stockQty}개</span></c:otherwise>
                      </c:choose>
                    </td>
                  </tr>
                </c:forEach>
                <c:if test="${empty lowStockTop5}">
                  <tr><td colspan="3" style="text-align:center;color:var(--gray4);padding:20px;">재고 부족 상품이 없습니다.</td></tr>
                </c:if>
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
            <button class="btn btn-outline btn-sm" onclick="location.href='${pageContext.request.contextPath}/logistics/log_in/log_inForm.do'">전체 보기</button>
          </div>
          <div class="card-body-np">
            <table>
              <thead><tr><th>입고일시</th><th>상품명</th><th>사이즈/컬러</th><th>수량</th><th>담당자</th></tr></thead>
              <tbody>
                <c:forEach var="i" items="${recentInboundList}">
                  <tr>
                    <td style="font-family:'DM Mono',monospace;font-size:11px;color:var(--gray3)">${i.inDate}<br>${i.inTime}</td>
                    <td>${i.prodName}</td>
                    <td><span class="bdg bdg-gray">${i.sizeVal}mm / ${i.color}</span></td>
                    <td><span class="bdg bdg-blue">${i.inQty}개</span></td>
                    <td>${i.userName}</td>
                  </tr>
                </c:forEach>
                <c:if test="${empty recentInboundList}">
                  <tr><td colspan="5" style="text-align:center;color:var(--gray4);padding:20px;">최근 입고 내역이 없습니다.</td></tr>
                </c:if>
              </tbody>
            </table>
          </div>
        </div>

        <div class="card">
          <div class="card-hdr">
            <span class="card-title">출고 대기 주문</span>
            <span class="bdg bdg-amber">${pendingOutboundCount}건 대기</span>
          </div>
          <div class="card-body-np">
            <table>
              <thead><tr><th>주문번호</th><th>상품명</th><th>수량</th><th>상태</th></tr></thead>
              <tbody>
                <c:forEach var="o" items="${pendingOutboundList}">
                  <tr>
                    <td style="font-family:'DM Mono',monospace;font-size:11px">#${o.orderNum}</td>
                    <td>${o.prodName}</td>
                    <td>${o.qty}</td>
                    <td><span class="bdg bdg-amber">출고 대기</span></td>
                  </tr>
                </c:forEach>
                <c:if test="${empty pendingOutboundList}">
                  <tr><td colspan="4" style="text-align:center;color:var(--gray4);padding:20px;">출고 대기 주문이 없습니다.</td></tr>
                </c:if>
              </tbody>
            </table>
          </div>
        </div>

      </div>

    </div>
  </div>
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
</script>
</body>
</html>
