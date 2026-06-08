<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>안내</title>
<link rel="stylesheet" href="${ pageContext.request.contextPath }/css/style.css" type="text/css">
</head>
<body>
<div class="page-main">
   <jsp:include page="/WEB-INF/views/common/header.jsp"/>
   <div class="content-main">
      <h4>안내</h4>
      <div class="result-display">
         잘못된 접속입니다.
         <br>
         <input type="button" value="홈으로" onclick="location.href='${ pageContext.request.contextPath }/main/main.do'">
      </div>
   </div>
</div>
</body>
</html>