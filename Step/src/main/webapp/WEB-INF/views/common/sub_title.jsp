<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>   
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<style>
.topbar {
	height: 54px;
	border-bottom: 1px solid #1a1a1a;
	display: flex;
	align-items: center;
	padding: 0 24px;
	gap: 12px;
	background: var(--black);
	position: sticky;
	top: 0;
	z-index: 50
}

.topbar-title {
	font-family: 'Space Grotesk', sans-serif;
	font-size: 14px;
	font-weight: 700;
	color: #fff;
	letter-spacing: .02em
}

.topbar-path {
	font-size: 11px;
	color: #999
}

.topbar-right {
	margin-left: auto;
	display: flex;
	align-items: center;
	gap: 8px
}

.t-btn {
	width: 32px;
	height: 32px;
	border: 1px solid #333;
	background: transparent;
	display: flex;
	align-items: center;
	justify-content: center;
	cursor: pointer;
	font-size: 14px;
	color: #888;
	border-radius: 2px
}

.t-btn:hover {
	border-color: #555;
	color: #fff
}
</style> 
<!-- 타이틀 시작 -->    
<div class="topbar">
	<div class="topbar-title">${app_title}</div>
	<div class="topbar-path">Admin > ${app_title}</div>
	<div class="topbar-right">
		<div class="t-btn">🔔</div>
	</div>
</div>
<!-- 타이틀 끝 -->
