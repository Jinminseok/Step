<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>ShoeMall - 회원가입</title>
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700;900&family=Space+Grotesk:wght@600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/KR_style.css">
</head>
<body>
    <jsp:include page="/WEB-INF/views/common/header.jsp"/>

    <div class="auth-page-wrap">

        <%-- ── 왼쪽 비주얼 패널 ── --%>
        <div class="auth-left">
            <div class="auth-left-content">

                <div class="auth-left-logo">Shoe<span>Mall</span></div>

                <div class="auth-left-title">
                    지금 가입하고<br>
                    <em>첫 구매 혜택</em>
                </div>
                <div class="auth-left-desc">
                    회원가입 즉시 BRONZE 등급으로 시작!<br>
                    누적 구매 금액에 따라 VIP까지 승급됩니다.
                </div>

                <div class="auth-features">
                    <div class="auth-feat-item">
                        <div class="auth-feat-ico">🎁</div>
                        <div class="auth-feat-txt">
                            <strong>가입 즉시 혜택</strong>
                            <span>신규 회원 전용 웰컴 할인 쿠폰 지급</span>
                        </div>
                    </div>
                    <div class="auth-feat-item">
                        <div class="auth-feat-ico">📦</div>
                        <div class="auth-feat-txt">
                            <strong>주문 · 배송 관리</strong>
                            <span>내 주문 현황을 한눈에 확인</span>
                        </div>
                    </div>
                    <div class="auth-feat-item">
                        <div class="auth-feat-ico">🤍</div>
                        <div class="auth-feat-txt">
                            <strong>찜 목록 저장</strong>
                            <span>마음에 드는 상품을 저장해두고 나중에</span>
                        </div>
                    </div>
                    <div class="auth-feat-item">
                        <div class="auth-feat-ico">💬</div>
                        <div class="auth-feat-txt">
                            <strong>1:1 채팅 문의</strong>
                            <span>빠른 고객센터 채팅 지원</span>
                        </div>
                    </div>
                </div>

            </div>
        </div>

        <%-- ── 오른쪽 폼 패널 ── --%>
        <div class="auth-right scroll">

            <div class="auth-right-logo" style="margin-bottom:6px">Shoe<span>Mall</span></div>
            <div class="auth-form-title">회원가입</div>
            <div class="auth-sub">ShoeMall 회원이 되어보세요</div>

            <form action="${pageContext.request.contextPath}/shop/user/register.do" method="post" id="register_form">

                <div class="auth-section-label">계정 정보</div>

                <div class="form-group">
                    <label class="form-label">아이디</label>
                    <div class="input-with-btn">
                        <input class="form-input" type="text" name="user_id" id="user_id"
                               placeholder="아이디" required>
                        <button type="button" class="btn btn-outline">중복확인</button>
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label class="form-label">비밀번호</label>
                        <input class="form-input" type="password" name="pwd" id="pwd"
                               placeholder="비밀번호" required>
                    </div>
                    <div class="form-group">
                        <label class="form-label">비밀번호 확인</label>
                        <input class="form-input" type="password" id="passwd_check"
                               placeholder="확인" required>
                    </div>
                </div>

                <div class="auth-section-label">개인 정보</div>

                <div class="form-row">
                    <div class="form-group">
                        <label class="form-label">이름</label>
                        <input class="form-input" type="text" name="user_name" id="user_name"
                               placeholder="이름" required>
                    </div>
                    <div class="form-group">
                        <label class="form-label">연락처</label>
                        <input class="form-input" type="text" name="phone" id="phone"
                               placeholder="010-0000-0000" required>
                    </div>
                </div>

                <div class="form-group">
                    <label class="form-label">이메일</label>
                    <input class="form-input" type="email" name="email" id="email"
                           placeholder="hong@email.com" required>
                </div>

                <div class="auth-section-label">배송지 정보</div>

                <div class="form-group">
                    <label class="form-label">주소</label>
                    <div class="input-with-btn" style="margin-bottom:8px">
                        <input class="form-input" type="text" name="zipcode" id="zipcode"
                               placeholder="우편번호" style="flex:0 0 120px;width:120px" readonly required>
                        <button type="button" class="btn btn-outline"
                                onclick="execDaumPostcode()">우편번호 찾기</button>
                    </div>
                    <input class="form-input" type="text" name="addr1" id="addr1"
                           placeholder="기본주소" style="margin-bottom:8px;display:block" readonly required>
                    <input class="form-input" type="text" name="addr2" id="addr2"
                           placeholder="상세주소" style="display:block">
                </div>

                <button type="submit" class="btn btn-black btn-full"
                        style="margin-top:8px">회원가입 완료</button>

            </form>

            <div class="auth-divider">또는</div>

            <div style="text-align:center; font-size:13px; color:var(--gray4)">
                이미 회원이신가요?&nbsp;
                <a href="${pageContext.request.contextPath}/shop/user/loginForm.do" class="auth-link">로그인</a>
            </div>

        </div>
    </div>

    <%-- 우편번호 (기존 기능 그대로) --%>
    <div id="layer" style="display:none;position:fixed;overflow:hidden;z-index:9999;-webkit-overflow-scrolling:touch;">
        <img src="//t1.daumcdn.net/postcode/resource/images/close.png"
             style="cursor:pointer;position:absolute;right:-3px;top:-3px;z-index:1"
             onclick="closeDaumPostcode()" alt="닫기 버튼">
    </div>
    <script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
    <script>
    var element_layer = document.getElementById('layer');
    function closeDaumPostcode() { element_layer.style.display = 'none'; }
    function execDaumPostcode() {
        new daum.Postcode({
            oncomplete: function(data) {
                var addr = data.userSelectedType === 'R' ? data.roadAddress : data.jibunAddress;
                var extra = '';
                if (data.userSelectedType === 'R') {
                    if (data.bname !== '' && /[동|로|가]$/g.test(data.bname)) extra += data.bname;
                    if (data.buildingName !== '' && data.apartment === 'Y')
                        extra += (extra !== '' ? ', ' + data.buildingName : data.buildingName);
                    if (extra !== '') extra = ' (' + extra + ')';
                }
                document.getElementById('zipcode').value = data.zonecode;
                document.getElementById('addr1').value = addr + extra;
                document.getElementById('addr2').focus();
                element_layer.style.display = 'none';
            },
            width: '100%', height: '100%', maxSuggestItems: 5
        }).embed(element_layer);
        element_layer.style.display = 'block';
        var w=300, h=400, b=5;
        element_layer.style.cssText += ';width:'+w+'px;height:'+h+'px;border:'+b+'px solid;'
            +'left:'+(((window.innerWidth||document.documentElement.clientWidth)-w)/2-b)+'px;'
            +'top:'+(((window.innerHeight||document.documentElement.clientHeight)-h)/2-b)+'px';
    }
    </script>
</body>
</html>
