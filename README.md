# 👟 Step & ShoeMall

> 신발 물류 WMS + B2C 쇼핑몰 통합 플랫폼  
> Java MVC2 팀 프로젝트 (4인 / 2026.04 ~ 2026.06)

[![체험용 데모 바로가기](https://img.shields.io/badge/👟_체험용_데모_바로가기-2563EB?style=for-the-badge)](https://jinminseok.github.io/step-demo/)

💡 **[데모 사이트](https://jinminseok.github.io/step-demo/)** 에서 로그인 없이 비회원 · 회원 · 쇼핑몰 관리자 · 물류(WMS) 화면을 직접 눌러볼 수 있습니다. 데모는 실제 애플리케이션을 테스트 데이터로 실행해 화면 흐름을 저장한 **정적 버전**이며, 실제 서비스는 Servlet/JSP(MVC2) + Oracle 기반으로 구현했습니다.

| 역할 | 둘러볼 수 있는 화면 |
|------|------|
| 비회원 | 상품 탐색 · 카테고리/브랜드/성별 필터 · 상품 상세(옵션별 재고·리뷰) · 매장 찾기 |
| 회원 | 마이페이지(주문·배송 추적, 반품/교환) · 장바구니 · 찜 · 등급 할인 주문서 · 1:1 채팅 · AI 추천 |
| 쇼핑몰 관리자 | 매출 대시보드 · 상품/카테고리/브랜드 · 주문·배송 상태 관리 · 반품 처리 · 회원 등급 · 배너 · 알림 발송 |
| 물류 WMS | 입·출고 대시보드 · 상품 마스터 · 입고 등록 · 출고 처리 · 사이즈별 재고 · 반품 검수 · 리포트 |

> ⚠️ 데모에서는 저장·수정·삭제·결제가 실제로 반영되지 않으며, 상품·회원 데이터와 이미지는 데모용 가상 데이터입니다.

---

## 📌 프로젝트 소개

**Step & ShoeMall**은 신발 브랜드의 **물류 창고 관리(WMS)** 와 **B2C 온라인 쇼핑몰**을 하나의 시스템으로 통합한 웹 애플리케이션입니다.  
물류 담당자는 입·출고 / 재고 / 반품을 관리하고, 일반 사용자는 상품 탐색부터 카카오페이 결제 · 반품까지 온라인으로 처리할 수 있습니다.

---

## 👥 팀 구성 및 역할

| 이름 | 담당 |
|------|------|
| 진민석(팀장)| 프로젝트 총괄 및 아키텍처 설계, 백오피스(Admin/물류) 풀스택, 사용자 서비스 통합 , AI추천 API 연동 |
| 정윤호 | 프로젝트 기획·시스템 모델링, 쇼핑몰-물류 통합 시스템 Full-Stack, 지도 API 연동 |
| 김경록 | 주문/결제 및 CS 시스템 구축, 상품 상세 탐색 및 프론트엔드 상태 관리  , 카카오 API 연동|
| 김규민 | 통계 및 대시보드 구현, 상품관리 목록 조회 구현 |

---

## 🛠 기술 스택

| 구분 | 기술 |
|------|------|
| Language | Java 17 |
| Server | Apache Tomcat 10 |
| Frontend | JSP, JSTL, HTML5, CSS3, JavaScript, jQuery |
| Backend | Servlet (MVC Model 2 / 커스텀 DispatcherServlet) |
| Database | Oracle DB (JDBC, DBCP 커넥션 풀) |
| Security | jBCrypt (비밀번호 해시 암호화) |
| External API | Kakao Pay, Kakao Map, Google Gemini API |
| Mail | Jakarta Mail (이메일 인증) |

---

## 📂 프로젝트 구조

```
Step/
├── src/main/java/
│   ├── kr/controller/           # DispatcherServlet, Action 인터페이스
│   ├── kr/shop/                 # 쇼핑몰 전체 (action / dao / vo)
│   ├── kr/admin/                # 어드민 주문 관리
│   ├── kr/adminreturn/          # 어드민 반품 처리
│   ├── kr/util/                 # DBUtil, FileUtil, PagingUtil 등 공통
│   ├── logis_action/            # WMS Action 클래스
│   ├── logis_dao/               # WMS DAO
│   └── logis_vo/                # WMS Value Object
│
└── src/main/webapp/
    ├── META-INF/context.xml     # ⚠ DB 접속 정보 — .gitignore 처리
    ├── WEB-INF/
    │   ├── web.xml              # 서블릿 설정 (API Key 플레이스홀더로 교체)
    │   ├── KM.properties        # 진민석 담당 URL → Action 매핑
    │   ├── *.properties         # 팀원별 URL 매핑 파일
    │   ├── views/shop/          # 쇼핑몰 JSP 화면
    │   └── views/logistics/     # WMS JSP 화면
    ├── css/
    ├── js/
    ├── sql/                     # 테이블 DDL SQL
    └── upload/                  # 상품 이미지 — .gitignore 처리
```

---

## 🏗 아키텍처

### 커스텀 MVC — DispatcherServlet

Spring 없이 **순수 Servlet으로 구현한 프론트 컨트롤러 패턴**입니다.

```
브라우저 요청 (*.do)
        │
        ▼
DispatcherServlet
  └─ 5개 .properties 파일에서 URL → Action 클래스 매핑 로드
        │
        ▼
Action.execute()   ← 비즈니스 로직 + DAO 호출
        │
        ▼
  JSP View  /  redirect:
```

- `.properties` 파일을 팀원 4명이 각각 분리(KM / KR / MS / YH)하여 URL 충돌 없이 병렬 개발
- `redirect:` prefix로 PRG (Post-Redirect-Get) 패턴 구현
- DB 연결은 JNDI 커넥션 풀 방식으로 재사용

---
## ✨ 팀원별 주요 기능

### ⭐진민석
### 1. 프로젝트 총괄 및 아키텍처 설계

- 비즈니스 로직 설계: 상품 등록 → 결제 → CS에 이르는 전체 비즈니스 워크플로우 정의
- DB 스키마 설계: 대규모 데이터 처리 및 무결성 유지를 위한 RDBMS 설계

### 2. 백오피스(Admin/물류) 풀스택 개발

**물류 및 재고 통합 관리**
- 실시간 재고 트래킹 및 물류 현황 통합 대시보드 구축
- 오늘의 주문 건수 / 매출 / 신규 회원 / 배송 준비 현황 실시간 집계
- 월별 매출 차트 및 상품별 판매 TOP 순위 제공

**쇼핑몰 코어 시스템(CRUD)**
- 계층형 브랜드 및 카테고리 관리 기능 구현으로 효율적인 상품 전시 인프라 마련

**주문 / 배송 관리**
- 단계별 주문 / 배송 상태 제어 기능
- 실시간 알림 발송 시스템 (전체 / 등급별 / 특정 회원 대상)
- UI / 배너 관리 페이지 개발

### 3. 사용자 서비스 통합 및 편의 기능 개발

**개인화 및 고객 참여 강화**
- AI 추전 API를 연동한 맞춤형 상품 큐레이션 제공
- 상세한 상품 리뷰 작성 시스템 구축

**고객 리텐션**
- 품절 재입고 알림 기능으로 즉각 대응 가능한 실시간 채팅 도입

**UX 개선**
- 배송 상태별 추이가 가능한 직관적인 마이페이지 및 리뷰 시스템

---

### 정윤호 — 쇼핑몰-물류 통합 Full-Stack

| 기능 | 설명 |
|------|------|
| 물류 인프라 구축 | 신발 특성을 고려한 입고, 출고, 반품, 교환의 전체 워크플로우 개발 |
| 실시간 데이터 동기화 | 쇼핑몰 관리자 페이지와 WMS 간의 실시간 재고 현황 및 클레임 처리 이력 연동 |
| 공공/오픈 API 연동 | Kakao Map 기반 오프라인 매장 검색, 관리자 매장 데이터 관리 시스템 구현 |

### 김경록 — 주문/결제 및 CS 시스템

| 기능 | 설명 |
|------|------|
| 결제 및 주문 워크플로우 | 장바구니 연동 및 커머스 핵심 결제 로직 설계 |
| 개인화 대시보드 | 누적 구매에 기반한 회원 등급 담성률 시각화 |
| 등급 프로파일링 | 사용자 등급별 자동 할인 혜택 자동 연산 및 적용 |
| 옵션 및 재고 제어 | 색상/사이즈 조합별 재고 실시간 검증 및 UI 상태 제어 |
| 비동기 쇼핑 액션 처리 | 찜/장바구니 추가 시 새로고침 없이 헤더 뱃지 수량 업데이트 |
| 카카오 결제 연동 | 카카오 API를 활용한 사용자 친화적 결제 프로세스 구축 |

### 김규민 — 통계 및 상품관리

| 기능 | 설명 |
|------|------|
| 관리자 대시보드 | 쇼핑몰 전반의 운영 상태를 한눈에 파악하는 UI 및 백엔드 로직 |
| 다조건 검색 필터링 | 상품명·카테고리·재고 상태 등 다양한 기준 조합으로 데이터 검색 |
| 페이징 처리 | 데이터 로딩 속도 및 서버 부하 최적화를 위한 백엔드 페이징 구현 |

---

## 🗃 ERD 주요 테이블

| 도메인 | 테이블 |
|--------|--------|
| 회원 | USERS, USERS_DETAIL |
| 상품 | PRODUCTS, PROD_OPTIONS, PROD_IMGS, CATEGORIES, BRANDS |
| 주문/결제 | ORDERS, ORDER_ITEMS, PAYMENTS, CART, WISHLIST |
| 배송/반품 | DELIVERY, RETURNS |
| 재고/물류 | STOCK, INBOUND, OUTBOUND |
| 알림/채팅 | NOTIFY, CHAT_ROOMS, CHAT_MSGS |
| 운영 | STORES, BANNERS, REVIEWS, RESTOCK_ALERT |

---

## 🚀 실행 방법

### 사전 요구사항
- JDK 17+
- Apache Tomcat 10.x
- Oracle DB

### 설정

**1. DB 설정** — `src/main/webapp/META-INF/context.xml`
```xml
<Resource name="jdbc/xe"
          username="본인_DB계정"
          password="본인_DB비밀번호"
          url="jdbc:oracle:thin:@본인_DB_IP:1521:xe" ... />
```

**2. API Key 설정** — `src/main/webapp/WEB-INF/web.xml`
```xml
<context-param>
    <param-name>GEMINI_API_KEY</param-name>
    <param-value>본인_Gemini_API_Key</param-value>
</context-param>
```

**3. DB 초기화** — `src/main/webapp/sql/` 폴더의 SQL 파일 순서대로 실행

**4. Tomcat 기동 후 접속**
- 쇼핑몰: `http://localhost:8080/Step/`
- WMS: `http://localhost:8080/Step/logis_index.jsp`

---

## 💡 프로젝트를 통해 배운 점

- Spring 없이 DispatcherServlet을 직접 구현하며 프론트 컨트롤러 패턴의 동작 원리를 깊이 이해
- `.properties` 파일을 팀원별로 분리해 URL 매핑 충돌 없이 4인이 병렬 개발하는 협업 전략 습득
- 전체 비즈니스 워크플로우(상품 등록 → 결제 → CS)를 설계하며 시스템 간 데이터 흐름 이해
- 어드민 대시보드에서 여러 DAO를 조합해 실시간 통계를 구성하는 설계 경험
- Ajax를 활용한 재고 수량 실시간 조회로 페이지 새로고침 없는 UX 구현 경험
