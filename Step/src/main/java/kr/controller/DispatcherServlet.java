package kr.controller;

import java.io.FileInputStream;
import java.io.IOException;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Properties;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class DispatcherServlet extends HttpServlet{
	private static final long serialVersionUID = 4068304416616773907L;
	
	private Map<String,Action> commandMap = new HashMap<String,Action>();
	private String view_path;

	@Override
	public void init(ServletConfig config)throws ServletException{
		// "/WEB-INF/ActionMap.properties" 반환
		String propsPath = config.getInitParameter("propertiesPath");
		view_path = config.getInitParameter("viewPath");
		
		//web.xml에 아래와 같이 properties 파일 분할할 경우
        // /WEB-INF/ActionMap.properties,/WEB-INF/ActionMap2.properties
        String[] propsArray = propsPath.split(",");
        if(propsArray == null){
        	//properties 파일이 분리되어 있지 않아도 배열로 변환
        	propsArray = (String[])Arrays.asList(propsPath).toArray();
        }
        
        Properties pr = new Properties();//명령어와 처리클래스의 매핑정보를 저장할 Properties객체 생성
        for(String props : propsArray){
        	FileInputStream fis = null;
        	try {
        		String path = config.getServletContext().getRealPath(props);
        		fis = new FileInputStream(path); //ActionMap.properties파일의 내용을 읽어옴
            		pr.load(fis);//ActionMap.properties파일의 정보를  Properties객체에 저장
        	} catch (IOException e) {
            		throw new ServletException(e);
        	} finally {
            		if (fis != null) try { fis.close(); } catch(IOException ex) {}
        	} 	
        }
		//Properties 객체에서 key 구하기
		Iterator<?> keyIter = pr.keySet().iterator();
		while(keyIter.hasNext()){
			String command = (String)keyIter.next(); //key
			String className = pr.getProperty(command); //value
			
			try {
				//문자열을 이용해 클래스를 찾아 Class 타입으로 반환
				Class<?> commandClass = Class.forName(className);
				//객체로 생성
				Object commandInstance = commandClass.getDeclaredConstructor().newInstance();
				
				//HashMap에 key와 value로 등록
				commandMap.put(command, (Action)commandInstance);
			} catch (Exception e) {
				throw new ServletException(e);
			} 
		}
	}
	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		requestPro(request,response);
	}
	@Override
	protected void doPost(HttpServletRequest request,HttpServletResponse response) throws ServletException, IOException {
		requestPro(request,response);
	}
	private void requestPro(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		String view = null;
		Action com = null;
		
		String command = request.getRequestURI();
		System.out.println("[DispatcherServlet] Request URL : " + command);
		
		if(command.indexOf(request.getContextPath())==0){
			command = command.substring(request.getContextPath().length());
		}
		//HashMap에 key를 넣어서 value(모델 객체)를 얻음
		com = commandMap.get(command);
		
		try{
			if (com == null) {
	            throw new ServletException("No mapping for " + command);
	        }
			System.out.println("[DispatcherServlet] Request URL key(" + command + ") -> Processing Instance (" + com + ")");
			
			//데이터를 생성해서 request에 저장하고 
			//jsp 경로 반환
			view = com.execute(request, response);
			System.out.println("[DispatcherServlet] Mapped View Path : " + view);
		}catch(Exception e){
			throw new ServletException(e);
		}
		
		if(view.startsWith("redirect:")){//리다이렉트
			view = view.substring("redirect:".length());
			response.sendRedirect(request.getContextPath()+view);
			System.out.println("[DispatcherServlet] Redirecting to : " + request.getContextPath()+view);
			System.out.println("---------------------------------------------------------------------------------------");
		}else{
			//forward 방식으로 view(jsp) 호출
			String path = (view_path == null ? "" : view_path)+view;
			RequestDispatcher dispatcher = request.getRequestDispatcher(path);
			dispatcher.forward(request, response);
			System.out.println("[DispatcherServlet] Forwarding to Real View Path: " + path);
			System.out.println("---------------------------------------------------------------------------------------");
		}
	}
}
