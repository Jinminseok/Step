<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<c:forEach var="item" items="${stockList}">
	<c:set var="percent"
		value="${item.stock_qty >= maxBarStock ? 100 : (item.stock_qty * 100.0) / maxBarStock}" />

	<tr>
		<td style="font-weight: 600;">${item.size_val}mm</td>
		<td>${item.color}</td>
		<td
			style="font-weight: 700; color: ${item.stock_qty < lowStockThreshold ? '#d9480f' : '#0f172a'}">
			${item.stock_qty}개</td>
		<td>
			<div
				style="display: flex; align-items: center; justify-content: center; gap: 8px;">
				<div
					style="width: 70px; height: 6px; background: #e2e8f0; border-radius: 4px; overflow: hidden;">
					<div
						style="height: 100%; border-radius: 4px; background: ${item.stock_qty < lowStockThreshold ? '#ef4444' : '#3b82f6'}; 
								width: ${percent}%;"></div>
				</div>
				<span
					style="font-size: 12px; color: #64748b; font-weight: 600; min-width: 36px; text-align: right;">
					<fmt:formatNumber value="${percent}" maxFractionDigits="0" />%
				</span>
			</div>
		</td>
		<td><c:choose>
				<c:when test="${item.stock_qty <= 0}">
					<span class="status-badge"
						style="background: #fef2f2; color: #ef4444;">● 품절</span>
				</c:when>
				<c:when test="${item.stock_qty < lowStockThreshold}">
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