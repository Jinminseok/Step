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
        String productContext = "";
        try {
            AiChatDAO dao = AiChatDAO.getInstance();
            List<String> productList = dao.getProductListForAI();
            StringBuilder productText = new StringBuilder();
            for (String prod : productList) {
                productText.append("- ").append(prod).append("\n");
            }
            productContext = productText.toString();
        } catch (Exception e) {
            productContext = "(상품 목록 조회 실패)";
        }

        // 5. 시스템 프롬프트
        String systemPrompt = "당신은 ShoeMall의 친절한 AI 신발 추천 어시스턴트입니다.\n"
                + "아래는 현재 판매 중인 상품 목록입니다. 반드시 이 목록에 있는 상품만 추천하세요.\n\n"
                + "=== 판매 상품 목록 ===\n"
                + productContext + "\n"
                + "=== 안내 사항 ===\n"
                + "1. 목록에 없는 상품은 절대 추천하지 마세요.\n"
                + "2. 추천 시 상품명, 가격을 명확히 알려주세요.\n"
                + "3. 친절하고 자연스러운 한국어로 답변하세요.\n"
                + "4. 조건에 맞는 상품이 없으면 솔직하게 없다고 말하세요.";

        // 6. Gemini API 요청 JSON 구성
        StringBuilder contentsJson = new StringBuilder();
        contentsJson.append("[");
        for (String[] chat : chatHistory) {
            String role = chat[0].equals("assistant") ? "model" : "user";
            contentsJson.append("{")
                        .append("\"role\":\"").append(role).append("\",")
                        .append("\"parts\":[{\"text\":\"").append(escapeJson(chat[1])).append("\"}]")
                        .append("},");
        }
        contentsJson.append("{")
                    .append("\"role\":\"user\",")
                    .append("\"parts\":[{\"text\":\"").append(escapeJson(userMsg)).append("\"}]")
                    .append("}");
        contentsJson.append("]");

        String requestBody = "{"
                + "\"system_instruction\":{\"parts\":[{\"text\":\"" + escapeJson(systemPrompt) + "\"}]},"
                + "\"contents\":" + contentsJson.toString()
                + "}";

        // 7. Gemini API 호출
        String aiResponse = callGeminiAPI(apiKey, requestBody);

        // 8. 대화 기록 업데이트
        chatHistory.add(new String[]{"user", userMsg});
        chatHistory.add(new String[]{"assistant", aiResponse});
        if (chatHistory.size() > 20) {
            chatHistory = new ArrayList<>(chatHistory.subList(chatHistory.size() - 20, chatHistory.size()));
        }
        session.setAttribute("chatHistory", chatHistory);

        // 9. JSP로 전달
        request.setAttribute("chatHistory", chatHistory);

        return "shop/ai/aiPick.jsp";
    }

    private String callGeminiAPI(String apiKey, String requestBody) {
        try {
        	String endpoint = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash-lite:generateContent?key=" + apiKey;

            URL url = new URL(endpoint);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Content-Type", "application/json; charset=UTF-8");
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

            String json = sb.toString();

            // 상태 코드 오류 처리
            if (statusCode != 200) {
                return "AI 오류 (코드: " + statusCode + "): " + json;
            }

            // ── Gemini 응답 텍스트 추출 ──────────────────────────────
            // 응답 형식: {"candidates":[{"content":{"parts":[{"text":"..."}]}}]}
            // "text":" 다음 값을 추출
            String marker = "\"text\":";
            int start = json.indexOf(marker);
            if (start < 0) {
                return "응답 파싱 오류. 원본: " + json.substring(0, Math.min(json.length(), 300));
            }
            start += marker.length();
            // "text": 뒤에 오는 첫 번째 " 찾기 (공백 무시)
            while (start < json.length() && json.charAt(start) != '"') {
                start++;
            }
            start++;

            // 닫히는 " 찾기 (이스케이프된 \" 제외)
            StringBuilder result = new StringBuilder();
            int i = start;
            while (i < json.length()) {
                char c = json.charAt(i);
                if (c == '\\' && i + 1 < json.length()) {
                    char next = json.charAt(i + 1);
                    switch (next) {
                        case 'n':  result.append('\n'); i += 2; break;
                        case 't':  result.append('\t'); i += 2; break;
                        case '"':  result.append('"');  i += 2; break;
                        case '\\': result.append('\\'); i += 2; break;
                        default:   result.append(next); i += 2; break;
                    }
                } else if (c == '"') {
                    break; // 문자열 끝
                } else {
                    result.append(c);
                    i++;
                }
            }

            return result.toString().trim();

        } catch (Exception e) {
            return "API 호출 중 오류 발생: " + e.getMessage();
        }
    }

    private String escapeJson(String text) {
        if (text == null) return "";
        return text.replace("\\", "\\\\")
                   .replace("\"", "\\\"")
                   .replace("\n", "\\n")
                   .replace("\r", "\\r")
                   .replace("\t", "\\t");
    }
}
