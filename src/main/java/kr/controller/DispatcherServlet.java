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

// -상품등록시 사진을 올리기 위해 필요한 코드 작성-규민-
import jakarta.servlet.annotation.MultipartConfig; 

//상품등록시 사진을 올리기 위해 필요한 코드 작성
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 1,  // 1MB
    maxFileSize = 1024 * 1024 * 10,       // 10MB
    maxRequestSize = 1024 * 1024 * 50     // 15MB
)
public class DispatcherServlet extends HttpServlet{
	private static final long serialVersionUID = 4068304416616773907L;
	
	private Map<String,Action> commandMap = new HashMap<String,Action>();
	private String view_path;

	@Override
	public void init(ServletConfig config)throws ServletException{
		String propsPath = config.getInitParameter("propertiesPath");
		view_path = config.getInitParameter("viewPath");
		
        String[] propsArray = propsPath.split(",");
        if(propsArray == null){
        	propsArray = (String[])Arrays.asList(propsPath).toArray();
        }
        
        Properties pr = new Properties();
        for(String props : propsArray){
        	FileInputStream fis = null;
        	try {
        		String path = config.getServletContext().getRealPath(props);
        		fis = new FileInputStream(path);
            	pr.load(fis);
        	} catch (IOException e) {
            	throw new ServletException(e);
        	} finally {
            	if (fis != null) try { fis.close(); } catch(IOException ex) {}
        	} 	
        }

		Iterator<?> keyIter = pr.keySet().iterator();
		while(keyIter.hasNext()){
			String command = (String)keyIter.next(); 
			String className = pr.getProperty(command); 
			
			try {
				Class<?> commandClass = Class.forName(className);
				Object commandInstance = commandClass.getDeclaredConstructor().newInstance();
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
		if(command.indexOf(request.getContextPath())==0){
			command = command.substring(request.getContextPath().length());
		}

		com = commandMap.get(command);
		
		try{
			if (com == null) {
	            throw new ServletException("No mapping for " + command);
	        }
			view = com.execute(request, response);
		}catch(Exception e){
			throw new ServletException(e);
		}
		
		if(view.startsWith("redirect:")){
			view = view.substring("redirect:".length());
			response.sendRedirect(request.getContextPath()+view);
		}else{
			String path = (view_path == null ? "" : view_path)+view;
			RequestDispatcher dispatcher = request.getRequestDispatcher(path);
			dispatcher.forward(request, response);
		}
	}
}