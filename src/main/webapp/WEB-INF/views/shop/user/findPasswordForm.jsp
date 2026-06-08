<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>ShoeMall - 비밀번호 찾기</title>
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700;900&family=Space+Grotesk:wght@600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/KR_style.css">
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script>
$(function(){
    $('#find_form').submit(function(e){
        let isValid = true;
        $('.form-input').each(function(){
            if($(this).val().trim() == ''){
                alert($(this).parent().find('.form-label').text() + '을(를) 입력해주세요.');
                $(this).focus();
                isValid = false;
                return false; 
            }
        });
        if(!isValid) e.preventDefault();
    });
});
</script>
</head>
<body>
    <jsp:include page="/WEB-INF/views/common/header.jsp"/>

    <div class="wrap">
        <div class="auth-wrap" style="max-width:480px; margin: 0 auto;">
            <div class="auth-logo">ShoeMall</div>
            <div class="auth-sub" style="margin-bottom:12px; font-weight:700;">비밀번호 찾기</div>
            <div style="font-size:13px; color:var(--gray3); text-align:center; line-height:1.5; margin-bottom:32px;">
                가입할 때 사용한 아이디와 이메일을 입력하시면<br>해당 이메일로 <strong>임시 비밀번호</strong>를 발송해 드립니다.
            </div>
            
            <form id="find_form" action="${pageContext.request.contextPath}/shop/user/findPassword.do" method="post">
                <div class="form-group">
                    <label class="form-label" for="id">아이디</label>
                    <input type="text" name="id" id="id" class="form-input" maxlength="12" placeholder="아이디 입력">
                </div>
                <div class="form-group">
                    <label class="form-label" for="email">이메일</label>
                    <input type="email" name="email" id="email" class="form-input" maxlength="50" placeholder="가입 시 등록한 이메일 입력">   
                </div>
                
                <button type="submit" class="btn btn-black btn-full" style="height:48px; font-size:14px; margin-top:16px;">임시 비밀번호 전송</button>
                
                <div class="auth-divider"></div>
                <div style="text-align:center;">
                    <a href="${pageContext.request.contextPath}/shop/user/loginForm.do" class="auth-link" style="color:var(--gray3); text-decoration:none;">로그인 화면으로 돌아가기</a>
                </div>
            </form>
        </div>
    </div>
</body>
</html>