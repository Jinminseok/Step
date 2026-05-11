package kr.shop.ai.action;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.ArrayList;
import java.util.List;

import jakarta.servlet.ServletContext;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import kr.controller.Action;
import kr.shop.dao.AiChatDAO;

public class AiChatSendAction implements Action {

    @Override
    public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
        request.setCharacterEncoding("UTF-8");

        // 1. 사용자 메시지 받기
        String userMsg = request.getParameter("userMsg");
        if (userMsg == null || userMsg.trim().isEmpty()) {
            request.setAttribute("errorMsg", "메시지를 입력해주세요.");
            return "shop/ai/aiPick.jsp";
        }

        // 2. API 키 가져오기 (web.xml에서)
        ServletContext ctx = request.getServletContext();
        String apiKey = ctx.getInitParameter("GEMINI_API_KEY");

        // 3. 세션에서 대화 기록 가져오기
        HttpSession session = request.getSession();
        @SuppressWarnings("unchecked")
        List<String[]> chatHistory = (List<String[]>) session.getAttribute("chatHistory");
        if (chatHistory == null) {
            chatHistory = new ArrayList<>();
        }

        // 4. DB에서 상품 목록 조회
        AiChatDAO dao = AiChatDAO.getInstance();
        List<String> productList = dao.getProductListForAI();

        // 5. 상품 목록 텍스트 구성
        StringBuilder productText = new StringBuilder();
        for (String prod : productList) {
            productText.append("- ").append(prod).append("\n");
        }

        // 6. 시스템 프롬프트
        String systemPrompt = "당신은 ShoeMall의 친절한 AI 신발 추천 어시스턴트입니다.\n"
                + "아래는 현재 판매 중인 상품 목록입니다. 반드시 이 목록에 있는 상품만 추천하세요.\n\n"
                + "=== 판매 상품 목록 ===\n"
                + productText.toString() + "\n"
                + "=== 안내 사항 ===\n"
                + "1. 목록에 없는 상품은 절대 추천하지 마세요.\n"
                + "2. 추천 시 상품명, 가격을 명확히 알려주세요.\n"
                + "3. 친절하고 자연스러운 한국어로 답변하세요.\n"
                + "4. 조건에 맞는 상품이 없으면 솔직하게 없다고 말하세요.";

        // 7. Gemini API 요청 JSON 구성
        StringBuilder contentsJson = new StringBuilder();
        contentsJson.append("[");

        for (String[] chat : chatHistory) {
            // Gemini는 assistant 대신 "model" 사용
            String role = chat[0].equals("assistant") ? "model" : "user";
            contentsJson.append("{")
                        .append("\"role\":\"").append(role).append("\",")
                        .append("\"parts\":[{\"text\":\"").append(escapeJson(chat[1])).append("\"}]")
                        .append("},");
        }

        // 현재 사용자 메시지 추가
        contentsJson.append("{")
                    .append("\"role\":\"user\",")
                    .append("\"parts\":[{\"text\":\"").append(escapeJson(userMsg)).append("\"}]")
                    .append("}");
        contentsJson.append("]");

        String requestBody = "{"
                + "\"system_instruction\":{\"parts\":[{\"text\":\"" + escapeJson(systemPrompt) + "\"}]},"
                + "\"contents\":" + contentsJson.toString()
                + "}";

        // 8. Gemini API 호출
        String aiResponse = callGeminiAPI(apiKey, requestBody);

        // 9. 대화 기록 업데이트 (최근 20개 유지)
        chatHistory.add(new String[]{"user", userMsg});
        chatHistory.add(new String[]{"assistant", aiResponse});
        if (chatHistory.size() > 20) {
            chatHistory = new ArrayList<>(chatHistory.subList(chatHistory.size() - 20, chatHistory.size()));
        }
        session.setAttribute("chatHistory", chatHistory);

        // 10. JSP로 전달
        request.setAttribute("chatHistory", chatHistory);
        request.setAttribute("userMsg", userMsg);
        request.setAttribute("aiResponse", aiResponse);

        return "shop/ai/aiPick.jsp";
    }

    // Gemini API 호출
    private String callGeminiAPI(String apiKey, String requestBody) throws Exception {
        String endpoint = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=" + apiKey;

        URL url = new URL(endpoint);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("POST");
        conn.setRequestProperty("Content-Type", "application/json");
        conn.setDoOutput(true);
        conn.setConnectTimeout(15000);
        conn.setReadTimeout(30000);

        try (OutputStream os = conn.getOutputStream()) {
            os.write(requestBody.getBytes("UTF-8"));
        }

        int statusCode = conn.getResponseCode();
        BufferedReader br;
        if (statusCode == 200) {
            br = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"));
        } else {
            br = new BufferedReader(new InputStreamReader(conn.getErrorStream(), "UTF-8"));
        }

        StringBuilder sb = new StringBuilder();
        String line;
        while ((line = br.readLine()) != null) {
            sb.append(line);
        }
        br.close();

        String jsonResponse = sb.toString();

        if (statusCode != 200) {
            return "죄송합니다. AI 응답 중 오류가 발생했습니다. (오류코드: " + statusCode + ")\n상세: " + jsonResponse;
        }

        // Gemini 응답에서 텍스트 추출
        String marker = "\"text\":\"";
        int start = jsonResponse.indexOf(marker);
        if (start == -1) return "응답을 처리하는 중 오류가 발생했습니다.";

        start += marker.length();
        int end = start;
        while (end < jsonResponse.length()) {
            if (jsonResponse.charAt(end) == '"' && jsonResponse.charAt(end - 1) != '\\') break;
            end++;
        }

        String text = jsonResponse.substring(start, end);
        text = text.replace("\\n", "\n")
                   .replace("\\\"", "\"")
                   .replace("\\'", "'")
                   .replace("\\\\", "\\");

        return text;
    }

    // JSON 이스케이프
    private String escapeJson(String text) {
        if (text == null) return "";
        return text.replace("\\", "\\\\")
                   .replace("\"", "\\\"")
                   .replace("\n", "\\n")
                   .replace("\r", "\\r")
                   .replace("\t", "\\t");
    }
}