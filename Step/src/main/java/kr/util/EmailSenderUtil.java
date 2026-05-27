package kr.util;

import java.io.UnsupportedEncodingException;
import java.util.Date;
import java.util.Properties;

import javax.mail.Authenticator;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.AddressException;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

import kr.shop.vo.EmailVO;

public class EmailSenderUtil{

	public static void sendEmail(EmailVO email) throws Exception {

		Properties prop = System.getProperties();
		//로그인시 TLS를 사용할 것인지 여부 지정
		prop.put("mail.smtp.starttls.enable", "true");
		//이메일 발송 처리 SMTP서버
		prop.put("mail.smtp.host", "smtp.gmail.com");
		//SMTP 서버 인증 사용
		prop.put("mail.smtp.auth", "true");
		//포트번호 지정
		prop.put("mail.smtp.port", "587");

		//soket, protocol 정보 지정
		prop.put("mail.smtp.ssl.trust", "smtp.gmail.com");
		prop.put("mail.smtp.socketFactory.fallback", "false");
		prop.put("mail.smtp.ssl.protocols", "TLSv1.2");
		   
		//구글 메뉴 : Google 계정관리>보안및로그인>2단계 인증>앱 비밀번호 에서 설정
                                                  //이메일 발송 주소            비밀번호
		Authenticator auth = new MyAuthentication("dragonyxit@gmail.com","ubruicbyxubdfdlq");
		Session session = Session.getInstance(prop, auth);
		MimeMessage msg = new MimeMessage(session);

		try {
			// 보내는 날짜 지정
			msg.setSentDate(new Date());

			// 발송자를 지정한다. 발송자의 메일, 발송자명
			msg.setFrom(new InternetAddress("dragonyxit@gmail.com", "관리자"));

			// 수신자의 메일을 생성한다.
			InternetAddress to = new InternetAddress(email.getReceiver());

			// Message 클래스의 setRecipient() 메소드를 사용하여 수신자를 설정한다. setRecipient() 메소드로 수신자, 참조,
			// 숨은 참조 설정이 가능하다.
			// Message.RecipientType.TO : 받는 사람
			// Message.RecipientType.CC : 참조
			// Message.RecipientType.BCC : 숨은 참조
			msg.setRecipient(Message.RecipientType.TO, to);

			// 메일의 제목 지정
			msg.setSubject(email.getSubject(), "UTF-8");

			// Transport는 메일을 최종적으로 보내는 클래스로 메일을 보내는 부분이다.
			msg.setText(email.getContent(), "UTF-8");

			Transport.send(msg);

		} catch (AddressException ae) {
			System.out.println("AddressException : " + ae.getMessage());
		} catch (MessagingException me) {
			System.out.println("MessagingException : " + me.getMessage());
		} catch (UnsupportedEncodingException e) {
			System.out.println("UnsupportedEncodingException : " + e.getMessage());
		}
	}
}
class MyAuthentication extends Authenticator {

    private PasswordAuthentication passwordAuthentication;

    public MyAuthentication(String mailId, String mailPass) {
    	passwordAuthentication = new PasswordAuthentication(mailId, mailPass);  
    }

    public PasswordAuthentication getPasswordAuthentication() {
        return passwordAuthentication;
    }
}