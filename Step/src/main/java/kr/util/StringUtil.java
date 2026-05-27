package kr.util;

import java.io.IOException;
import java.util.Map;

import org.codehaus.jackson.JsonGenerationException;
import org.codehaus.jackson.map.JsonMappingException;
import org.codehaus.jackson.map.ObjectMapper;

import jakarta.servlet.http.HttpServletRequest;

public class StringUtil {
	/*
	 * HTML 태그를 허용하면서 줄바꿈
	 */
	public static String useBrHtml(String str) {
		if(str == null) return null;
		
		return str.replaceAll("\r\n", "<br>")
				  .replaceAll("\r", "<br>")
				  .replaceAll("\n", "<br>"); 
	}
	/*
	 * HTML 태그를 허용하지 않으면서 줄바꿈
	 */
	public static String useBrNoHtml(String str) {
		if(str==null) return null;
		
		return str.replaceAll("<", "&lt;")
				  .replaceAll(">", "&gt;")
				  .replaceAll("\r\n", "<br>")
				  .replaceAll("\r", "<br>")
				  .replaceAll("\n", "<br>");
	}
	/*
	 * HTML를 허용하지 않음
	 */
	public static String useNoHtml(String str) {
		if(str == null) return null;
		
		return str.replaceAll("<", "&lt;")
				  .replaceAll(">", "&gt;");
	}
	/*
	 * 큰 따옴표 처리
	 */
	public static String parseQuot(String str) {
		if(str == null) return null;
		
		return str.replaceAll("\"", "&quot;");
	}
	
	/*
	 * JSON문자열 변환
	 */
	//제네릭 표현의 ? : 제네릭 자료형을 특정 자료형으로 한정하지 않고 임의의 자료형으로 지정하고자 할때 
	//				 ?(와일드 카드) 사용
	public static String parseJSON(HttpServletRequest request, Map<String,?> map)
							throws JsonGenerationException, JsonMappingException, IOException
		{
			//JSON 데이터 생성
			ObjectMapper mapper = new ObjectMapper();
			String ajaxData = mapper.writeValueAsString(map);
			
			//request에 JSON 문자열 저장
			request.setAttribute("ajaxData", ajaxData);
			
			return "common/ajax_view.jsp";
	}
	
	/*
	 * 임시비밀번호 처리를 위한 난수 발생
	 */
	public static String randomPassword(int length){
		int index = 0;
		char[] charSet = new char[]{
				'0','1','2','3','4','5','6','7','8','9'
				,'A','B','C','D','E','F','G','H','I','J','K','L','M'
				,'N','O','P','Q','R','S','T','U','V','W','X','Y','Z'
				,'a','b','c','d','e','f','g','h','i','h','k','l','m'
				,'n','o','p','q','r','s','t','u','v','w','x','y','z'
		};

		StringBuffer sb = new StringBuffer();

		for(int i=0;i<length;i++){
			index = (int)(charSet.length * Math.random());
			sb.append(charSet[index]);
		}

		return sb.toString();
	}
	
}







