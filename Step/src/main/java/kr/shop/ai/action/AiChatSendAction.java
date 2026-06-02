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

    // 폴백 순서: 2.5-flash → 2.0-flash → 2.0-flash-lite
    private static final String[] FALLBACK_MODELS = {
        "gemini-2.5-flash",
        "gemini-2.0-flash",
        "gemini-2.0-flash-lite"
    };

    @Override
    public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
        request.setCharacterEncoding("UTF-8");

        // 1. 사용자 메시지 받기
        String userMsg = request.getParameter("userMsg");
        if (userMsg == null || userMsg.trim().isEmpty()) {
            request.setAttribute("errorMsg", "메시지를 입력해주세요.");
            return "shop/ai/aiPick.jsp";
        }

        // 2. 세션에서 대화 기록 가져오기 (API 키 체크보다 먼저)
        HttpSession session = request.getSession();
        @SuppressWarnings("unchecked")
        List<String[]> chatHistory = (List<String[]>) session.getAttribute("chatHistory");
        if (chatHistory == null) {
            chatHistory = new ArrayList<>();
        }

        // 3. API 키 가져오기
        ServletContext ctx = request.getServletContext();
        String apiKey = ctx.getInitParameter("GEMINI_API_KEY");

        if (apiKey == null || apiKey.trim().isEmpty()) {
            request.setAttribute("chatHistory", chatHistory);
            request.setAttribute("aiResponse", "API 키가 설정되지 않았습니다.");
            return "shop/ai/aiPick.jsp";
        }

        // 4. DB에서 상품 목록 조회
        String productContext = "";
        try {
            AiChatDAO dao = AiChatDAO.getInstance();
            List<String> productList = dao.getProductListForAI();

            System.out.println("[AI] 상품 목록 조회 성공: " + productList.size() + "개");

            StringBuilder productText = new StringBuilder();
            for (String prod : productList) {
                productText.append("- ").append(prod).append("\n");
            }
            productContext = productText.toString();
        } catch (Exception e) {
            System.err.println("[AI] 상품 목록 조회 실패: " + e.getMessage());
            e.printStackTrace();
            productContext = "(상품 목록 조회 실패: " + e.getMessage() + ")";
        }

        // 5. 시스템 프롬프트
        String systemPrompt = "당신은 ShoeMall의 친절한 AI 신발 추천 어시스턴트입니다.\n"
                + "아래는 현재 재고가 있는 판매 중인 상품 목록입니다. 반드시 이 목록에 있는 상품만 추천하세요.\n\n"
                + "=== 판매 상품 목록 ===\n"
                + productContext + "\n"
                + "=== 안내 사항 ===\n"
                + "1. 목록에 없는 상품은 절대 추천하지 마세요.\n"
                + "2. 추천 시 상품명, 브랜드, 카테고리, 가격을 명확히 알려주세요.\n"
                + "3. 친절하고 자연스러운 한국어로 답변하세요.\n"
                + "4. 조건에 맞는 상품이 없으면 '현재 해당 조건의 재고가 없습니다'라고 안내하세요.\n"
                + "5. 한 번에 2~3개 상품을 추천하고 각 상품의 특징을 간단히 설명해주세요.\n"
                + "6. 예산이 명시된 경우 반드시 그 범위 안에서만 추천하세요.\n"
                + "7. 사용자가 재고를 물어보면 상품 목록의 재고 수량을 알려주세요.\n"
                + "8. 재고가 10개 미만이면 '품절 임박'이라고 강조해주세요.\n"
                + "9. 재고 수량은 실시간이 아닌 조회 시점 기준임을 필요 시 안내하세요.";

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

        // 7. Gemini API 호출 (폴백 포함)
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

    /**
     * 폴백 모델 순서대로 시도. 429/503 발생 시 다음 모델로 전환.
     */
    private String callGeminiAPI(String apiKey, String requestBody) {
        for (int i = 0; i < FALLBACK_MODELS.length; i++) {
            String model = FALLBACK_MODELS[i];
            String endpoint = "https://generativelanguage.googleapis.com/v1beta/models/"
                            + model + ":generateContent?key=" + apiKey;
          //String endpoint = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash-lite:generateContent?key=" + apiKey;
        	//String endpoint = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=" + apiKey;

            // 첫 번째 시도 제외, 재시도 전 1.5초 대기
            if (i > 0) {
                try { Thread.sleep(1500); } catch (InterruptedException ignored) {}
            }

            String result = callGeminiWithEndpoint(endpoint, requestBody, model);
            if (result != null) {
                return result;
            }

            System.out.println("[AI] " + model + " 실패 → 다음 모델 시도");
        }

        return "현재 AI 서비스가 일시적으로 혼잡합니다. 잠시 후 다시 시도해주세요. 😊";
    }

    /**
     * 단일 엔드포인트 호출. 429/503이면 null 반환(폴백 신호).
     */
    private String callGeminiWithEndpoint(String endpoint, String requestBody, String model) {
        try {
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

            if (statusCode != 200) {
                System.err.println("[Gemini 오류] 모델: " + model + " / 상태코드: " + statusCode);
                System.err.println("[Gemini 오류] 응답내용: " + json);

                // 폴백 대상: 할당량 초과 or 서버 과부하 → null 반환
                if (statusCode == 429 || statusCode == 503) {
                    return null;
                }
                if (statusCode == 400) {
                    return "요청 형식 오류가 발생했습니다. (400)\n상세: " + json;
                }
                if (statusCode == 403) {
                    return "API 키가 유효하지 않습니다. web.xml의 GEMINI_API_KEY를 확인하세요. (403)";
                }
                return "일시적인 오류가 발생했습니다. (오류코드: " + statusCode + ")";
            }

            System.out.println("[AI] 응답 성공 - 사용 모델: " + model);

            // Gemini 응답 텍스트 추출
            String marker = "\"text\":";
            int start = json.indexOf(marker);
            if (start < 0) {
                return "응답 파싱 오류. 원본: " + json.substring(0, Math.min(json.length(), 300));
            }
            start += marker.length();
            while (start < json.length() && json.charAt(start) != '"') {
                start++;
            }
            start++;

            StringBuilder result = new StringBuilder();
            int idx = start;
            while (idx < json.length()) {
                char c = json.charAt(idx);
                if (c == '\\' && idx + 1 < json.length()) {
                    char next = json.charAt(idx + 1);
                    switch (next) {
                        case 'n':  result.append('\n'); idx += 2; break;
                        case 't':  result.append('\t'); idx += 2; break;
                        case '"':  result.append('"');  idx += 2; break;
                        case '\\': result.append('\\'); idx += 2; break;
                        default:   result.append(next); idx += 2; break;
                    }
                } else if (c == '"') {
                    break;
                } else {
                    result.append(c);
                    idx++;
                }
            }

            return result.toString().trim();

        } catch (Exception e) {
            System.err.println("[AI] 호출 예외 - 모델: " + model + " / " + e.getMessage());
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