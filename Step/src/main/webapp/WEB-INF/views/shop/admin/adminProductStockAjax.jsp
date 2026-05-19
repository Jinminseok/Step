<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:forEach var="item" items="${stockList}">
	<tr>
		<td style="font-weight: 600;">${item.size_val}mm</td>
		<td>${item.color}</td>
		<td
			style="font-weight: 700; color: ${item.stock_qty < 10 ? '#d9480f' : '#0f172a'}">
			${item.stock_qty}개</td>
		<td>
			<div
				style="width: 100px; height: 6px; background: #e2e8f0; border-radius: 4px; overflow: hidden; margin: 0 auto;">
				<div
					style="height: 100%; border-radius: 4px; background: ${item.stock_qty < 10 ? '#ef4444' : '#3b82f6'}; 
							width: ${item.stock_qty > 50 ? 100 : item.stock_qty * 2}%;"></div>
			</div>
		</td>
		<td><c:choose>
				<c:when test="${item.stock_qty == 0}">
					<span class="status-badge"
						style="background: #fef2f2; color: #ef4444;">● 품절</span>
				</c:when>
				<c:when test="${item.stock_qty < 10}">
					<span class="status-badge"
						style="background: #fff4e6; color: #d9480f;">● 부족</span>
				</c:when>
				<c:otherwise>
					<span class="status-badge"
						style="background: #dcfce7; color: #059669;">● 정상</span>
				</c:otherwise>
			</c:choose></td>
	</tr>
</c:forEach>