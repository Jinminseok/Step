<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>ShoeMall - Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;700&display=swap" rel="stylesheet">
</head>
<body>

<aside class="sidebar">
    <div class="sb-logo"><span>S</span> ShoeAdmin</div>
    
    <div class="nav-section">MANAGEMENT</div>
    <div class="nav-item">📊 대시보드</div>
    <div class="nav-item">📦 주문 관리</div>
    <div class="nav-item">↩️ 취소/반품/교환</div>
    
    <div class="nav-section">INVENTORY</div>
    <div class="nav-item active">👟 상품 관리</div>
    <div class="nav-item">🏷️ 카테고리 관리</div>
    <div class="nav-item">🕒 실시간 재고 관리</div>
    
    <div class="nav-section">COMMUNITY & UI</div>
    <div class="nav-item">💬 상품 리뷰 관리</div>
    <div class="nav-item">❓ 상품 Q&A 관리</div>
    <div class="nav-item">🖼️ 메인진열 / 배너</div>
</aside>

<main class="main">
    <div class="header">
        <div class="title">상품 관리 <span style="font-size:12px; color:#999; font-weight:normal;">Home > Inventory > 상품 관리</span></div>
    </div>

    <div class="tabs">
        <div class="tab active">전체 상품</div>
        <div class="tab">판매중</div>
        <div class="tab">숨김/품절</div>
    </div>

    <div class="toolbar">
        <div class="search-box">
            <select><option>상태 전체</option></select>
            <input type="text" placeholder="상품명 검색..." style="width:250px;">
        </div>
        <button class="btn-black">+ 신규 상품 등록</button>
    </div>

    <table>
        <thead>
            <tr>
                <th>번호</th>
                <th>이미지</th>
                <th>상품정보</th>
                <th>판매가</th>
                <th>재고</th>
                <th>상태</th>
                <th>관리</th>
            </tr>
        </thead>
        <tbody>
            <tr>
                <td>1</td>
                <td><div style="width:40px; height:40px; background:#eee; display:flex; align-items:center; justify-content:center;">👟</div></td>
                <td><strong>에어포스 1 '07</strong><br><span style="color:#999; font-size:11px;">CW2288-111</span></td>
                <td>139,000원</td>
                <td>42</td>
                <td><span class="badge b-green">판매중</span></td>
                <td>
                    <button class="btn-sm">수정</button>
                    <button class="btn-sm btn-del">삭제</button>
                </td>
            </tr>
            <tr>
                <td>2</td>
                <td><div style="width:40px; height:40px; background:#eee; display:flex; align-items:center; justify-content:center;">🏃</div></td>
                <td><strong>울트라부스트 22</strong><br><span style="color:#999; font-size:11px;">GX5464</span></td>
                <td>229,000원</td>
                <td>0</td>
                <td><span class="badge b-orange">품절</span></td>
                <td>
                    <button class="btn-sm">수정</button>
                    <button class="btn-sm btn-del">삭제</button>
                </td>
            </tr>
        </tbody>
    </table>
</main>

</body>
</html>