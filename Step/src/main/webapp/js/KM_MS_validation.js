$(document).ready(function() {
    
    // 1. 화면 전환 이벤트 (페이지 이동)
    $('#btnGoRegister').on('click', function() {
        // 회원가입 폼을 띄우는 Action으로 이동 (properties에 매핑된 주소 입력)
        location.href = 'registerForm.do'; 
    });

    $('#btnGoLogin').on('click', function() {
        location.href = 'loginForm.do';
    });

    // 2. 로그인 폼 유효성 검사
    $('#loginForm').on('submit', function(e) {
        if ($('#id').val().trim() === '') {
            alert('아이디를 입력해주세요.');
            $('#id').focus();
            e.preventDefault(); // 폼 전송 막기
            return;
        }
        if ($('#pwd').val().trim() === '') {
            alert('비밀번호를 입력해주세요.');
            $('#pwd').focus();
            e.preventDefault();
            return;
        }
        // 백엔드 구현 전 테스트 시에는 아래 alert 주석 해제 후 preventDefault 유지
        // alert('프론트 통과! 백엔드로 로그인 데이터 전송됨');
    });

    // 3. 회원가입 폼 유효성 검사
    $('#registerForm').on('submit', function(e) {
        if ($('#reg_id').val().trim() === '') {
            alert('아이디를 입력해주세요.');
            $('#reg_id').focus();
            e.preventDefault();
            return;
        }
        if ($('#reg_pwd').val().trim() === '') {
            alert('비밀번호를 입력해주세요.');
            $('#reg_pwd').focus();
            e.preventDefault();
            return;
        }
        if ($('#name').val().trim() === '') {
            alert('이름을 입력해주세요.');
            $('#name').focus();
            e.preventDefault();
            return;
        }
        // 이메일이나 연락처 정규식 검사는 필요시 추가
    });

    // 4. 아이디 중복확인 버튼 임시 처리 (나중에 AJAX로 변경)
    $('#btnCheckId').on('click', function() {
        let inputId = $('#reg_id').val().trim();
        if(inputId === '') {
            alert('중복 확인할 아이디를 먼저 입력하세요.');
            $('#reg_id').focus();
            return;
        }
        alert('백엔드 구현 후 AJAX로 DB와 연동될 예정임. (현재 입력값: ' + inputId + ')');
    });
});