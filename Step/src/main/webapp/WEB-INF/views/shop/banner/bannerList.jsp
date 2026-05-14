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
.topbar{height:54px;border-bottom:1px solid #1a1a1a;display:flex;align-items:center;padding:0 24px;gap:12px;background:var(--black);position:sticky;top:0;z-index:50}
.topbar-title{font-family:'Space Grotesk',sans-serif;font-size:14px;font-weight:700;color:#fff;letter-spacing:.02em}
.topbar-path{font-size:11px;color:#444}
.content{padding:24px;flex:1}
.page-hdr{display:flex;align-items:center;justify-content:space-between;margin-bottom:20px}
.page-hdr-title{font-size:20px;font-weight:900;letter-spacing:-.5px}
.page-hdr-sub{font-size:12px;color:var(--gray4);margin-top:2px}
.btn{padding:9px 16px;border:none;cursor:pointer;font-size:12px;font-weight:700;font-family:inherit;transition:all .18s;display:inline-flex;align-items:center;justify-content:center;gap:6px;letter-spacing:.02em;}
.btn-black{background:var(--black);color:#fff}
.btn-black:hover{background:#333}
.tbl-wrap{overflow-x:auto;background:var(--white);border:1px solid var(--border)}
table{width:100%;border-collapse:collapse}
th{padding:10px 14px;font-size:10px;font-weight:700;color:var(--gray4);letter-spacing:.08em;text-transform:uppercase;border-bottom:1px solid var(--border);text-align:left;}
td{padding:12px 14px;border-bottom:1px solid var(--border);font-size:13px;color:var(--gray2);vertical-align:middle;}
tr:hover td{background:#fafafa}
.badge{display:inline-flex;align-items:center;padding:3px 9px;font-size:11px;font-weight:700;border-radius:20px}
.b-normal{background:#e8f5e8;color:var(--green)}
.b-silver{background:#f0f0f0;color:#555}
.banner-preview{width:180px; height:60px; object-fit:cover; border:1px solid var(--border); border-radius:4px;}
.modal-overlay{display:none;position:fixed;inset:0;background:rgba(0,0,0,.6);z-index:300;align-items:center;justify-content:center}
.modal-overlay.open{display:flex}
.modal-box{background:var(--white);width:520px;display:flex;flex-direction:column;border:1px solid var(--border)}
.modal-hdr{display:flex;align-items:center;justify-content:space-between;padding:18px 22px;border-bottom:1px solid var(--border);background:var(--black);color:#fff}
.modal-title{font-family:'Space Grotesk',sans-serif;font-size:15px;font-weight:700}
.modal-close{background:none;border:none;color:#888;cursor:pointer;font-size:20px;line-height:1;padding:0}
.modal-body{padding:22px;}
.modal-footer{padding:14px 22px;border-top:1px solid var(--border);display:flex;justify-content:flex-end;background:var(--gray7)}
.form-group{display:flex;flex-direction:column;gap:6px;margin-bottom:14px}
.f-label{font-size:10px;font-weight:700;color:var(--gray3);text-transform:uppercase;}
.f-input{padding:10px 12px;border:1px solid var(--border);background:var(--white);font-size:13px;width:100%;outline:none;}
.f-row{display:grid;grid-template-columns:1fr 1fr;gap:12px}
</style>
</head>
<body>

<%@ include file="../../common/shopAdminHeader.jsp"%>

<div class="main">
    <div class="topbar">
        <div class="topbar-title">UI / 배너 관리</div>
        <div class="topbar-path">Admin > UI / 배너 관리</div>
    </div>

    <div class="content">
        <div class="page-hdr">
            <div>
                <div class="page-hdr-title">메인 배너 리스트</div>
                <div class="page-hdr-sub">쇼핑몰 메인 화면에 자동 슬라이드되는 배너를 등록하고 순서를 지정합니다.</div>
            </div>
            <button class="btn btn-black" onclick="document.getElementById('modal-reg').classList.add('open')">＋ 새 배너 등록</button>
        </div>

        <div class="tbl-wrap">
            <table>
                <thead>
                    <tr>
                        <th style="width:60px">순서</th>
                        <th style="width:200px">미리보기</th>
                        <th>배너 명칭</th>
                        <th>연결 상품 번호</th>
                        <th style="width:80px">노출여부</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="b" items="${bannerList}">
                        <tr>
                            <td style="font-weight:700">${b.banner_order}</td>
                            <td><img src="${pageContext.request.contextPath}/upload/${b.banner_img}" class="banner-preview"></td>
                            <td style="font-weight:700">${b.banner_title}</td>
                            <td style="color:var(--gray3)">[No.${b.prod_num}] ${b.prod_name}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${b.banner_status == 'Y'}"><span class="badge b-normal">노출중</span></c:when>
                                    <c:otherwise><span class="badge b-silver">숨김</span></c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty bannerList}">
                        <tr><td colspan="5" style="text-align:center;padding:40px;color:var(--gray4)">📭 등록된 배너가 없습니다.</td></tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>
</div>

<div class="modal-overlay" id="modal-reg">
    <div class="modal-box">
        <div class="modal-hdr">
            <div class="modal-title">신규 배너 등록</div>
            <button class="modal-close" onclick="document.getElementById('modal-reg').classList.remove('open')">✕</button>
        </div>
        <form action="${pageContext.request.contextPath}/shop/admin/bannerInsert.do" method="post" enctype="multipart/form-data">
            <div class="modal-body">
                <div class="form-group">
                    <label class="f-label">배너 제목</label>
                    <input type="text" name="banner_title" class="f-input" placeholder="예: 나이키 신상 기획전" required>
                </div>
                <div class="form-group">
                    <label class="f-label">클릭 시 이동할 상품 번호</label>
                    <input type="number" name="prod_num" class="f-input" placeholder="상품 번호 입력" required>
                </div>
                <div class="f-row">
                    <div class="form-group">
                        <label class="f-label">노출 순서</label>
                        <input type="number" name="banner_order" class="f-input" value="1" required>
                    </div>
                    <div class="form-group">
                        <label class="f-label">노출 상태</label>
                        <select name="banner_status" class="f-input">
                            <option value="Y">Y (메인 노출)</option>
                            <option value="N">N (숨김처리)</option>
                        </select>
                    </div>
                </div>
                <div class="form-group">
                    <label class="f-label">배너 이미지 첨부</label>
                    <input type="file" name="uploadFile" class="f-input" accept="image/*" required>
                </div>
            </div>
            <div class="modal-footer">
                <button type="submit" class="btn btn-black">저장하기</button>
            </div>
        </form>
    </div>
</div>
</body>
</html>