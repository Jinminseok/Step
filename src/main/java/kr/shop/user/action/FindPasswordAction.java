package kr.shop.user.action;

import org.mindrot.jbcrypt.BCrypt;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.controller.Action;
import kr.shop.dao.UserDAO;
import kr.shop.vo.UserVO;
import kr.shop.vo.EmailVO;
import kr.util.EmailSenderUtil;
import kr.util.StringUtil;

public class FindPasswordAction implements Action {

    @Override
    public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
        
        String id = request.getParameter("id");
        String email = request.getParameter("email");
        
        UserDAO dao = UserDAO.getInstance();
        // 입력받은 아이디로 유저 정보 조회
        UserVO user = dao.checkUser(id); 
        boolean check = false;
        
        // 아이디가 존재하고(탈퇴회원 제외 auth > 1), 이메일이 일치하는지 확인
        if(user != null && user.getAuth() > 1 && user.getEmail() != null && user.getEmail().equals(email)) {
            check = true;
            
            //임시 비밀번호 10자리 랜덤 생성
            String passwd = StringUtil.randomPassword(10);
            
            //임시 비밀번호를 BCrypt로 암호화하여 DB에 저장
            dao.updatePassword(BCrypt.hashpw(passwd, BCrypt.gensalt()), user.getUser_num());
            
            //이메일 발송 객체 세팅
            EmailVO emailVO = new EmailVO();
            emailVO.setContent("요청하신 ShoeMall 임시 비밀번호는 [ " + passwd + " ] 입니다.\n로그인 후 마이페이지에서 반드시 비밀번호를 변경해 주세요.");
            emailVO.setReceiver(user.getEmail());
            emailVO.setSubject("[ShoeMall] " + user.getUser_id() + "님, 비밀번호 찾기 안내 메일입니다.");
            
            //이메일 전송 유틸 호출
            EmailSenderUtil.sendEmail(emailVO);
        }
        
        request.setAttribute("check", check);
        
        return "shop/user/emailSendSuccess.jsp";
    }
}