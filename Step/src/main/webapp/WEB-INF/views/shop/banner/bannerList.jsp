<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>ShoeMall - 배너 관리</title>
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700;900&family=Space+Grotesk:wght@600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/KM_style.css">
<style>
.main{margin-left:220px;flex:1;display:flex;flex-direction:column;min-height:100vh}
.topbar{height:54px;border-bottom:1px solid #1a1a1a;display:flex;align-items:center;padding:0 24px;background:var(--black);position:sticky;top:0;z-index:50}
.topbar-title{font-family:'Space Grotesk',sans-serif;font-size:14px;font-weight:700;color:#fff;}
.content{padding:24px;flex:1}
.banner-preview{width:160px; height:50px; object-fit:cover; border:1px solid var(--border); border-radius:4px;}
.badge{display:inline-flex;align-items:center;padding:3px 9px;font-size:11px;font-weight:700;border-radius:20px}
.b-normal{background:#e8f5e8;color:var(--green)}
.b-silver{background:#f0f0f0;color:#555}
.modal-overlay{display:none;position:fixed;inset:0;background:rgba(0,0,0,.6);z-index:300;align-items:center;justify-content:center}
.modal-overlay.open{display:flex}
.modal-box{background:var(--white);width:500px;border:1px solid var(--border)}
.modal-hdr{padding:18px 22px;background:var(--black);color:#fff;display:flex;justify-content:space-between;align-items:center;}
.f-input{padding:10px; border:1px solid var(--border); width:100%; margin-bottom:15px; outline:none;}
</style>
</head>
<body>
<%@ include file="../../common/shopAdminHeader.jsp"%>
<div class="main">
    <div class="topbar"><div class="topbar-title">UI / 배너 관리</div></div>
    <div class="content">
        <div class="page-hdr" style="display:flex; justify-content:space-between; margin-bottom:20px;">
            <div>
                <h2 style="font-size:24px; font-weight:900;">메인 배너 관리</h2>
                <p style="color:var(--gray4); font-size:13px;">메인 슬라이드 배너의 이미지와 연결 상품을 관리합니다.</p>
            </div>
            <button class="btn btn-black" onclick="document.getElementById('modal-reg').classList.add('open')" style="padding:10px 20px; cursor:pointer; background:var(--black); color:#fff; border:none; font-weight:700;">＋ 배너 등록</button>
        </div>
        <div class="tbl-wrap">
            <table style="width:100%; border-collapse:collapse; background:#fff; border:1px solid var(--border);">
                <thead style="background:#f9f9f9;">
                    <tr>
                        <th style="padding:12px; border-bottom:1px solid var(--border);">순서</th>
                        <th style="padding:12px; border-bottom:1px solid var(--border);">이미지</th>
                        <th style="padding:12px; border-bottom:1px solid var(--border);">배너 제목</th>
                        <th style="padding:12px; border-bottom:1px solid var(--border);">상품번호</th>
                        <th style="padding:12px; border-bottom:1px solid var(--border);">상태</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="b" items="${bannerList}">
                        <tr style="text-align:center; border-bottom:1px solid var(--border);">
                            <td>${b.banner_sort_no}</td>
                            <td style="padding:10px;"><img src="${pageContext.request.contextPath}/upload/${b.banner_img_url}" class="banner-preview"></td>
                            <td style="font-weight:700;">${b.banner_title}</td>
                            <td>[No.${b.prod_num}] ${b.prod_name}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${b.banner_use_yn == 'Y'}"><span class="badge b-normal">노출중</span></c:when>
                                    <c:otherwise><span class="badge b-silver">숨김</span></c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</div>

<div class="modal-overlay" id="modal-reg">
    <div class="modal-box">
        <div class="modal-hdr">
            <span style="font-weight:700;">배너 등록</span>
            <button onclick="document.getElementById('modal-reg').classList.remove('open')" style="background:none; border:none; color:#fff; cursor:pointer; font-size:20px;">✕</button>
        </div>
        <form action="${pageContext.request.contextPath}/shop/banner/bannerInsert.do" method="post" enctype="multipart/form-data" style="padding:20px;">
            <label style="font-size:12px; font-weight:700; color:#666;">배너 제목</label>
            <input type="text" name="banner_title" class="f-input" required>
            
            <label style="font-size:12px; font-weight:700; color:#666;">연결 상품 번호 (PROD_NUM)</label>
            <input type="number" name="prod_num" class="f-input" required>
            
            <div style="display:grid; grid-template-columns:1fr 1fr; gap:10px;">
                <div>
                    <label style="font-size:12px; font-weight:700; color:#666;">노출 순서 (BANNER_SORT_NO)</label>
                    <input type="number" name="banner_sort_no" class="f-input" value="1">
                </div>
                <div>
                    <label style="font-size:12px; font-weight:700; color:#666;">노출 여부 (BANNER_USE_YN)</label>
                    <select name="banner_use_yn" class="f-input">
                        <option value="Y">Y (노출)</option>
                        <option value="N">N (숨김)</option>
                    </select>
                </div>
            </div>
            <label style="font-size:12px; font-weight:700; color:#666;">이미지 파일</label>
            <input type="file" name="uploadFile" class="f-input" required>
            <button type="submit" style="width:100%; padding:12px; margin-top:10px; cursor:pointer; background:var(--black); color:#fff; border:none; font-weight:700;">배너 저장하기</button>
        </form>
    </div>
</div>
</body>
</html>