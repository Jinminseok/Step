package kr.util;

import java.io.File;
import java.io.IOException;
import java.util.UUID;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.Part;

public class FileUtil {

	// 업로드 상대 경로
	public static final String UPLOAD_PATH = "/upload";

	// 파일 업로드
	public static String uploadFile(HttpServletRequest request, String param) throws IOException, ServletException {
		// 서버 내 실제 경로 추출
		String upload = request.getServletContext().getRealPath(UPLOAD_PATH);

		File saveDir = new File(upload);
		if (!saveDir.exists()) {
			saveDir.mkdirs();
		}

		Part part = request.getPart(param);
		String filename = part.getSubmittedFileName();

		if (filename != null && !filename.isEmpty()) {
			// 파일명이 중복되지 않도록 UUID 적용
			UUID uuid = UUID.randomUUID();
			filename = uuid.toString() + filename.substring(filename.lastIndexOf("."));

			// 지정된 경로에 파일 저장
			part.write(upload + File.separator + filename);
		}

		return filename;
	}

	// 파일 삭제
	public static void removeFile(HttpServletRequest request, String filename) {
		if (filename != null) {
			String upload = request.getServletContext().getRealPath(UPLOAD_PATH);
			File file = new File(upload + File.separator + filename);
			if (file.exists()) {
				file.delete();
			}
		}
	}

	// 다중 업로드 헤더에서 파일명 추출 (필요 시 사용)
	public static String getFilename(String headerName) {
		for (String name : headerName.split(";")) {
			if (name.trim().startsWith("filename")) {
				String filename = name.substring(name.indexOf("=") + 1).trim().replace("\"", "");
				int index = filename.lastIndexOf(File.separator);
				return filename.substring(index + 1);
			}
		}
		return null;
	}
}