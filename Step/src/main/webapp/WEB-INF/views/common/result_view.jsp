<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>ShoeMall - ${result_title}</title>
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700;900&family=Space+Grotesk:wght@600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/KR_style.css" type="text/css">
</head>
<body>
    <jsp:include page="/WEB-INF/views/common/header.jsp"/>
    
    <div class="wrap">
        <div class="result-wrap">
            <div class="result-box">
                <div style="font-size: 52px; margin-bottom: 24px;">🎉</div>
                
                <div class="result-title">${result_title}</div>
                <div class="result-msg">${result_msg}</div>
                
                <button class="btn btn-black" style="width: 200px; height: 50px; font-size: 16px;" onclick="location.href='${result_url}'">확인</button>
            </div>
        </div>
    </div>
</body>
</html>