<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>ShoeMall - 관리자</title>
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700;900&family=Space+Grotesk:wght@600;700&display=swap" rel="stylesheet">
<style>
*{margin:0;padding:0;box-sizing:border-box}
:root{
  --black:#000000;
  --white:#ffffff;
  --bg:#f5f5f5;
  --border:#e0e0e0;
  --gray1:#111111;
  --gray2:#333333;
  --gray3:#666666;
  --gray4:#999999;
  --gray5:#cccccc;
  --gray6:#e8e8e8;
  --gray7:#f5f5f5;
  --red:#ff0000;
  --blue:#0057ff;
  --orange:#ff6b00;
  --green:#008000;
}
body{font-family:'Noto Sans KR',sans-serif;background:var(--bg);color:var(--black);display:flex;min-height:100vh;font-size:14px}

/* ─── SIDEBAR ─────────────────────────────────── */
.sidebar{width:220px;background:var(--black);display:flex;flex-direction:column;position:fixed;height:100vh;z-index:100;flex-shrink:0}
.sb-logo{padding:20px;border-bottom:1px solid #1a1a1a;display:flex;align-items:center;gap:10px}
.sb-logo-mark{width:28px;height:28px;background:var(--red);display:flex;align-items:center;justify-content:center;font-size:13px;font-weight:700;color:#fff}
.sb-logo-txt{font-family:'Space Grotesk',sans-serif;font-size:16px;font-weight:700;color:#fff;letter-spacing:-0.5px}
.sb-logo-txt span{color:#ff4d4d}
.sb-logo-badge{font-size:9px;color:#555;margin-top:2px;letter-spacing:.15em;text-transform:uppercase}
.nav{flex:1;padding:10px 0;overflow-y:auto}
.nav::-webkit-scrollbar{width:3px}
.nav::-webkit-scrollbar-thumb{background:#333}
.nav-section{padding:8px 16px 4px;font-size:9px;font-weight:700;color:#444;letter-spacing:.15em;text-transform:uppercase;margin-top:4px}
.nav-item{display:flex;align-items:center;gap:9px;padding:9px 16px;cursor:pointer;color:#888;transition:all .18s;font-size:13px;border-left:2px solid transparent}
.nav-item:hover{color:#ddd;background:rgba(255,255,255,.04)}
.nav-item.active{color:#fff;background:rgba(255,255,255,.06);border-left-color:var(--red)}
.nav-icon{font-size:14px;width:18px;text-align:center;flex-shrink:0}
.nav-badge{margin-left:auto;background:var(--red);color:#fff;font-size:9px;padding:1px 5px;border-radius:2px;font-weight:700}
.sb-footer{padding:14px 16px;border-top:1px solid #1a1a1a}
.admin-row{display:flex;align-items:center;gap:9px}
.admin-av{width:30px;height:30px;border-radius:2px;background:var(--red);display:flex;align-items:center;justify-content:center;font-size:12px;font-weight:700;color:#fff;flex-shrink:0}
.admin-name{font-size:12px;font-weight:700;color:#fff}
.admin-role{font-size:10px;color:#555}
.logout-btn{margin-left:auto;font-size:10px;color:#555;cursor:pointer;padding:3px 7px;border:1px solid #333;border-radius:2px;transition:all .2s}
.logout-btn:hover{color:#fff;border-color:#666}

/* ─── MAIN ─────────────────────────────────────── */
.main{margin-left:220px;flex:1;display:flex;flex-direction:column;min-height:100vh}
.topbar{height:54px;border-bottom:1px solid #1a1a1a;display:flex;align-items:center;padding:0 24px;gap:12px;background:var(--black);position:sticky;top:0;z-index:50}
.topbar-title{font-family:'Space Grotesk',sans-serif;font-size:14px;font-weight:700;color:#fff;letter-spacing:.02em}
.topbar-path{font-size:11px;color:#444;margin-left:2px}
.topbar-right{margin-left:auto;display:flex;align-items:center;gap:8px}
.t-btn{width:32px;height:32px;border:1px solid #333;background:transparent;display:flex;align-items:center;justify-content:center;cursor:pointer;font-size:14px;color:#888;border-radius:2px;position:relative;transition:all .2s}
.t-btn:hover{border-color:#555;color:#fff}
.notif-dot{position:absolute;top:4px;right:4px;width:6px;height:6px;background:var(--red);border-radius:50%;border:1px solid var(--black)}
.content{padding:24px;flex:1}

/* ─── PAGE ─────────────────────────────────────── */
.page{display:none}
.page.active{display:block}

/* ─── PAGE HEADER ───────────────────────────────── */
.page-hdr{display:flex;align-items:center;justify-content:space-between;margin-bottom:20px}
.page-hdr-left{}
.page-hdr-title{font-size:20px;font-weight:900;letter-spacing:-.5px}
.page-hdr-sub{font-size:12px;color:var(--gray4);margin-top:2px}

/* ─── STATS ─────────────────────────────────────── */
.stats-row{display:grid;grid-template-columns:repeat(5,1fr);gap:1px;background:var(--border);margin-bottom:20px;border:1px solid var(--border)}
.stat-card{background:var(--white);padding:16px 18px}
.stat-label{font-size:10px;font-weight:700;color:var(--gray4);margin-bottom:8px;text-transform:uppercase;letter-spacing:.08em}
.stat-val{font-family:'Space Grotesk',sans-serif;font-size:24px;font-weight:700;letter-spacing:-1px}
.stat-change{font-size:11px;margin-top:5px}
.c-up{color:var(--blue)}
.c-dn{color:var(--red)}
.c-warn{color:var(--orange)}

/* ─── TOOLBAR ───────────────────────────────────── */
.toolbar{display:flex;align-items:center;gap:10px;margin-bottom:16px;flex-wrap:wrap}
.search-wrap{position:relative;flex:1;max-width:300px}
.search-wrap input{width:100%;padding:9px 12px 9px 36px;border:1px solid var(--border);background:var(--white);font-size:13px;font-family:inherit;outline:none;color:var(--black);transition:border .15s}
.search-wrap input:focus{border-color:var(--black)}
.search-wrap input::placeholder{color:var(--gray5)}
.search-ico{position:absolute;left:11px;top:50%;transform:translateY(-50%);color:var(--gray4);font-size:14px}
.sel{padding:9px 12px;border:1px solid var(--border);background:var(--white);font-size:12px;font-family:inherit;outline:none;color:var(--gray2);cursor:pointer}
.sel:focus{border-color:var(--black)}

/* ─── BUTTONS ───────────────────────────────────── */
.btn{padding:9px 16px;border:none;cursor:pointer;font-size:12px;font-weight:700;font-family:inherit;transition:all .18s;display:inline-flex;align-items:center;justify-content:center;gap:6px;letter-spacing:.02em}
.btn-black{background:var(--black);color:#fff}
.btn-black:hover{background:#333}
.btn-red{background:var(--red);color:#fff}
.btn-red:hover{background:#cc0000}
.btn-outline{background:var(--white);color:var(--gray2);border:1px solid var(--border)}
.btn-outline:hover{border-color:var(--black);color:var(--black)}
.btn-ghost{background:transparent;color:var(--gray3);border:1px solid var(--border)}
.btn-ghost:hover{color:var(--black);border-color:var(--black)}
.btn-danger{background:#fff0f0;color:var(--red);border:1px solid #ffd0d0}
.btn-danger:hover{background:var(--red);color:#fff}
.btn-sm{padding:5px 10px;font-size:11px}
.btn-xs{padding:3px 8px;font-size:10px}

/* ─── BADGE ─────────────────────────────────────── */
.badge{display:inline-flex;align-items:center;padding:2px 7px;font-size:10px;font-weight:700;letter-spacing:.03em}
.b-black{background:var(--black);color:#fff}
.b-red{background:#fff0f0;color:var(--red)}
.b-blue{background:#e8f0ff;color:var(--blue)}
.b-green{background:#e8f5e8;color:var(--green)}
.b-orange{background:#fff3e8;color:var(--orange)}
.b-gray{background:var(--gray7);color:var(--gray3)}

/* ─── TABLE ─────────────────────────────────────── */
.tbl-wrap{overflow-x:auto;background:var(--white);border:1px solid var(--border)}
table{width:100%;border-collapse:collapse}
th{padding:10px 14px;font-size:10px;font-weight:700;color:var(--gray4);letter-spacing:.08em;text-transform:uppercase;border-bottom:1px solid var(--border);text-align:left;background:var(--white)}
td{padding:12px 14px;border-bottom:1px solid var(--border);font-size:13px;color:var(--gray2);vertical-align:middle}
tr:last-child td{border-bottom:none}
tr:hover td{background:#fafafa}

/* ─── CARD ──────────────────────────────────────── */
.card{background:var(--white);border:1px solid var(--border);padding:20px;margin-bottom:16px}
.card-header{display:flex;align-items:center;justify-content:space-between;margin-bottom:16px}
.card-title{font-size:13px;font-weight:700;text-transform:uppercase;letter-spacing:.05em}

/* ─── GRID 2/3 col ──────────────────────────────── */
.grid-2{display:grid;grid-template-columns:1fr 1fr;gap:16px}
.grid-3{display:grid;grid-template-columns:1fr 1fr 1fr;gap:16px}
.grid-dash{display:grid;grid-template-columns:3fr 2fr;gap:16px}

/* ─── TABS ──────────────────────────────────────── */
.tabs{display:flex;border-bottom:2px solid var(--border);margin-bottom:20px}
.tab{padding:10px 18px;font-size:12px;font-weight:700;color:var(--gray4);cursor:pointer;border-bottom:2px solid transparent;margin-bottom:-2px;transition:all .15s;text-transform:uppercase;letter-spacing:.04em}
.tab.on{color:var(--black);border-bottom-color:var(--black)}
.tab:hover{color:var(--gray2)}

/* ─── FORM ──────────────────────────────────────── */
.form-grid{display:grid;grid-template-columns:1fr 1fr;gap:14px}
.form-group{display:flex;flex-direction:column;gap:6px}
.form-group.full{grid-column:1/-1}
.f-label{font-size:10px;font-weight:700;color:var(--gray3);text-transform:uppercase;letter-spacing:.07em}
.f-input{padding:10px 12px;border:1px solid var(--border);background:var(--white);font-size:13px;font-family:inherit;outline:none;color:var(--black);transition:border .15s;width:100%}
.f-input:focus{border-color:var(--black)}
.f-input::placeholder{color:var(--gray5)}
select.f-input option{background:var(--white)}
textarea.f-input{resize:vertical;min-height:90px}

/* ─── PRODUCT GRID (ADMIN CARDS) ─────────────────── */
.prod-admin-grid{display:grid;grid-template-columns:repeat(4,1fr);gap:0;border-left:1px solid var(--border);border-top:1px solid var(--border);margin-bottom:20px}
.prod-admin-card{background:var(--white);border-right:1px solid var(--border);border-bottom:1px solid var(--border);position:relative;transition:box-shadow .2s}
.prod-admin-card:hover{box-shadow:0 4px 20px rgba(0,0,0,.1);z-index:1}

/* image area */
.pac-img{height:200px;background:var(--gray7);display:flex;align-items:center;justify-content:center;font-size:80px;position:relative;overflow:hidden;cursor:pointer}
.pac-img:hover .pac-img-overlay{opacity:1}
.pac-img-overlay{position:absolute;inset:0;background:rgba(0,0,0,.55);display:flex;flex-direction:column;align-items:center;justify-content:center;gap:8px;opacity:0;transition:opacity .2s}
.pac-img-btn{background:rgba(255,255,255,.95);color:var(--black);border:none;padding:7px 16px;font-size:11px;font-weight:700;font-family:inherit;cursor:pointer;letter-spacing:.04em;width:120px;transition:background .15s}
.pac-img-btn:hover{background:#fff}
.pac-img-btn.del{background:rgba(255,0,0,.85);color:#fff}
.pac-img-btn.del:hover{background:var(--red)}

/* badges on image */
.pac-badges{position:absolute;top:8px;left:8px;display:flex;flex-direction:column;gap:3px;z-index:2}
.pac-status{position:absolute;top:8px;right:8px;z-index:2}
/* checkbox */
.pac-check{position:absolute;top:9px;left:9px;z-index:3}
.pac-check input{width:16px;height:16px;accent-color:var(--black);cursor:pointer}

/* info area */
.pac-info{padding:12px 14px}
.pac-brand{font-size:10px;font-weight:700;color:var(--gray3);text-transform:uppercase;letter-spacing:.05em;margin-bottom:3px}
.pac-name{font-size:13px;font-weight:700;color:var(--black);margin-bottom:2px;line-height:1.35;cursor:pointer}
.pac-name:hover{text-decoration:underline}
.pac-code{font-size:10px;color:var(--gray5);margin-bottom:6px}
.pac-price-row{display:flex;align-items:center;gap:6px;margin-bottom:8px}
.pac-disc{font-size:13px;font-weight:700;color:var(--red)}
.pac-price{font-size:13px;font-weight:700;color:var(--black)}
.pac-origin{font-size:11px;color:var(--gray5);text-decoration:line-through}
.pac-stock{font-size:11px;color:var(--gray4);margin-bottom:10px}
.pac-stock span{font-weight:700;color:var(--gray2)}
.pac-stock.low span{color:var(--red)}

/* action buttons below card */
.pac-actions{display:grid;grid-template-columns:1fr 1fr 1fr;border-top:1px solid var(--border)}
.pac-act-btn{padding:9px 4px;font-size:11px;font-weight:700;text-align:center;cursor:pointer;background:var(--white);border:none;border-right:1px solid var(--border);font-family:inherit;color:var(--gray3);transition:all .15s;letter-spacing:.02em}
.pac-act-btn:last-child{border-right:none}
.pac-act-btn:hover{background:var(--gray7);color:var(--black)}
.pac-act-btn.edit:hover{background:#e8f0ff;color:var(--blue)}
.pac-act-btn.hide:hover{background:#fff3e8;color:var(--orange)}
.pac-act-btn.del:hover{background:#fff0f0;color:var(--red)}

/* + 신규 등록 card */
.pac-add-card{background:var(--white);border-right:1px solid var(--border);border-bottom:1px solid var(--border);display:flex;flex-direction:column;align-items:center;justify-content:center;gap:14px;cursor:pointer;min-height:300px;transition:background .2s}
.pac-add-card:hover{background:var(--gray7)}
.pac-add-icon{width:56px;height:56px;border:2px dashed var(--gray5);display:flex;align-items:center;justify-content:center;font-size:24px;color:var(--gray5)}
.pac-add-card:hover .pac-add-icon{border-color:var(--black);color:var(--black)}
.pac-add-label{font-size:12px;font-weight:700;color:var(--gray4);text-transform:uppercase;letter-spacing:.08em}
.pac-add-card:hover .pac-add-label{color:var(--black)}

/* ─── MODAL ─────────────────────────────────────── */
.modal-overlay{display:none;position:fixed;inset:0;background:rgba(0,0,0,.6);z-index:300;align-items:center;justify-content:center}
.modal-overlay.open{display:flex}
.modal-box{background:var(--white);width:660px;max-height:90vh;display:flex;flex-direction:column;border:1px solid var(--border)}
.modal-hdr{display:flex;align-items:center;justify-content:space-between;padding:18px 22px;border-bottom:1px solid var(--border);background:var(--black);color:#fff}
.modal-title{font-family:'Space Grotesk',sans-serif;font-size:15px;font-weight:700;letter-spacing:.02em}
.modal-close{background:none;border:none;color:#888;cursor:pointer;font-size:20px;line-height:1;padding:0;transition:color .2s}
.modal-close:hover{color:#fff}
.modal-body{padding:22px;overflow-y:auto;flex:1}
.modal-footer{padding:14px 22px;border-top:1px solid var(--border);display:flex;gap:8px;justify-content:flex-end;background:var(--gray7)}

/* image upload zone */
.img-upload-zone{border:2px dashed var(--border);height:180px;display:flex;flex-direction:column;align-items:center;justify-content:center;gap:8px;cursor:pointer;transition:all .2s;margin-bottom:4px}
.img-upload-zone:hover{border-color:var(--black);background:var(--gray7)}
.img-upload-zone.has-img{border-style:solid;border-color:var(--border)}
.img-up-icon{font-size:32px;color:var(--gray5)}
.img-up-text{font-size:12px;color:var(--gray4);font-weight:500}
.img-up-sub{font-size:11px;color:var(--gray5)}
.img-previews{display:flex;gap:8px;flex-wrap:wrap;margin-top:8px}
.img-preview-item{width:72px;height:72px;background:var(--gray7);border:1px solid var(--border);display:flex;align-items:center;justify-content:center;font-size:28px;position:relative}
.img-del{position:absolute;top:-6px;right:-6px;width:16px;height:16px;background:var(--red);border-radius:50%;color:#fff;font-size:9px;display:flex;align-items:center;justify-content:center;cursor:pointer;font-weight:700;border:1px solid #fff}

/* color/size chips */
.option-row{display:flex;flex-wrap:wrap;gap:6px;margin-top:6px}
.opt-chip{padding:5px 12px;border:1px solid var(--border);font-size:12px;cursor:pointer;transition:all .15s;font-family:inherit;font-weight:500;background:var(--white);color:var(--gray3)}
.opt-chip.on{border-color:var(--black);color:var(--black);font-weight:700}
.opt-chip:hover{border-color:var(--gray3)}
.opt-chip.color-chip{display:flex;align-items:center;gap:6px}
.color-dot{width:12px;height:12px;border-radius:50%;border:1px solid var(--border)}

/* ─── DASHBOARD CHARTS ───────────────────────────── */
.bar-row{display:flex;align-items:center;gap:10px;margin-bottom:7px}
.bar-lbl{font-size:11px;color:var(--gray3);width:80px;text-align:right;flex-shrink:0}
.bar-track{flex:1;height:22px;background:var(--gray7);overflow:hidden}
.bar-fill{height:100%;display:flex;align-items:center;padding-left:8px;font-size:10px;font-weight:700;color:#fff}
.bar-val{font-size:11px;color:var(--gray4);width:55px;flex-shrink:0}

/* ─── STOCK BAR ─────────────────────────────────── */
.stk-track{width:90px;height:5px;background:var(--gray6);display:inline-block;border-radius:0;vertical-align:middle}
.stk-fill{height:100%}
.stk-ok{background:var(--blue)}
.stk-warn{background:var(--orange)}
.stk-low{background:var(--red)}

/* ─── ALERT ─────────────────────────────────────── */
.alert{display:flex;align-items:flex-start;gap:10px;padding:12px 14px;margin-bottom:14px;font-size:12px;line-height:1.7;border:1px solid}
.alert-warn{background:#fffbe8;border-color:#ffe070;color:#7a5800}
.alert-info{background:#e8f0ff;border-color:#b0c8ff;color:#003399}

/* ─── MEMBER TABLE ───────────────────────────────── */
.member-avatar{width:30px;height:30px;background:var(--gray6);border-radius:50%;display:flex;align-items:center;justify-content:center;font-size:12px;font-weight:700;flex-shrink:0;color:var(--gray3)}

/* ─── CHAT ──────────────────────────────────────── */
.chat-layout{display:grid;grid-template-columns:260px 1fr;height:540px;border:1px solid var(--border);background:var(--border);gap:1px}
.chat-list{background:var(--white);overflow-y:auto}
.chat-item{padding:13px 16px;border-bottom:1px solid var(--border);cursor:pointer;transition:background .15s}
.chat-item:hover,.chat-item.on{background:var(--gray7)}
.chat-name{font-size:13px;font-weight:700;margin-bottom:2px;display:flex;align-items:center;gap:6px}
.chat-preview{font-size:12px;color:var(--gray4);white-space:nowrap;overflow:hidden;text-overflow:ellipsis}
.chat-time{font-size:10px;color:var(--gray5);margin-top:3px}
.chat-room{background:var(--white);display:flex;flex-direction:column}
.chat-room-hdr{padding:14px 18px;border-bottom:1px solid var(--border);display:flex;align-items:center;gap:10px;background:var(--black);color:#fff}
.chat-msgs{flex:1;padding:14px 16px;overflow-y:auto;display:flex;flex-direction:column;gap:9px}
.msg{max-width:68%;padding:9px 13px;font-size:13px;line-height:1.6}
.msg-user{background:var(--gray7);border:1px solid var(--border);color:var(--gray2);align-self:flex-start}
.msg-admin{background:var(--black);color:#fff;align-self:flex-end}
.chat-input{padding:12px 14px;border-top:1px solid var(--border);display:flex;gap:8px}
.chat-input input{flex:1;padding:9px 12px;border:1px solid var(--border);font-size:13px;font-family:inherit;outline:none}
.chat-input input:focus{border-color:var(--black)}

/* ─── BANNER MANAGE ─────────────────────────────── */
.banner-card{background:var(--white);border:1px solid var(--border);margin-bottom:10px;display:flex;align-items:center;gap:14px;padding:14px}
.banner-preview{width:120px;height:60px;background:var(--gray7);border:1px solid var(--border);display:flex;align-items:center;justify-content:center;font-size:24px;flex-shrink:0}
.banner-info{flex:1}
.banner-title{font-size:13px;font-weight:700;margin-bottom:3px}
.banner-meta{font-size:11px;color:var(--gray4)}
.banner-actions{display:flex;gap:6px}
</style>
</head>
<body>

<!-- ═════════ SIDEBAR ═════════ -->
<aside class="sidebar">
  <div class="sb-logo">
    <div class="sb-logo-mark">A</div>
    <div>
      <div class="sb-logo-txt">Shoe<span>Mall</span></div>
      <div class="sb-logo-badge">Admin Panel</div>
    </div>
  </div>
  <nav class="nav">
    <div class="nav-section">대시보드</div>
    <div class="nav-item active" onclick="go('dashboard',this)"><span class="nav-icon">📊</span>통계 / 대시보드</div>

    <div class="nav-section">상품</div>
    <div class="nav-item" onclick="go('product',this)"><span class="nav-icon">👟</span>상품 관리</div>
    <div class="nav-item" onclick="go('category',this)"><span class="nav-icon">🏷️</span>카테고리 관리</div>

    <div class="nav-section">재고 / 물류</div>
    <div class="nav-item" onclick="go('stock',this)"><span class="nav-icon">📦</span>재고 관리<span class="nav-badge">2</span></div>
    <div class="nav-item" onclick="go('order',this)"><span class="nav-icon">🧾</span>주문 관리</div>
    <div class="nav-item" onclick="go('delivery',this)"><span class="nav-icon">🚚</span>배송 관리</div>
    <div class="nav-item" onclick="go('return',this)"><span class="nav-icon">↩️</span>반품/교환 관리</div>

    <div class="nav-section">고객</div>
    <div class="nav-item" onclick="go('member',this)"><span class="nav-icon">👤</span>회원 관리</div>
    <div class="nav-item" onclick="go('coupon',this)"><span class="nav-icon">🎫</span>쿠폰 관리</div>
    <div class="nav-item" onclick="go('chat',this)"><span class="nav-icon">💬</span>채팅 문의<span class="nav-badge">3</span></div>

    <div class="nav-section">운영</div>
    <div class="nav-item" onclick="go('banner',this)"><span class="nav-icon">🖼️</span>UI / 배너 관리</div>
    <div class="nav-item" onclick="go('store',this)"><span class="nav-icon">🗺️</span>매장 정보 관리</div>
    <div class="nav-item" onclick="go('notify',this)"><span class="nav-icon">🔔</span>알림 발송 관리</div>
  </nav>
  <div class="sb-footer">
    <div class="admin-row">
      <div class="admin-av">관</div>
      <div>
        <div class="admin-name">최슈퍼</div>
        <div class="admin-role">super admin</div>
      </div>
      <div class="logout-btn">로그아웃</div>
    </div>
  </div>
</aside>

<!-- ═════════ MAIN ═════════ -->
<main class="main">
  <div class="topbar">
    <div class="topbar-title" id="pg-title">통계 / 대시보드</div>
    <div class="topbar-path" id="pg-path">/ dashboard</div>
    <div class="topbar-right">
      <div class="t-btn">🔔<div class="notif-dot"></div></div>
      <div class="t-btn">⚙️</div>
    </div>
  </div>
  <div class="content">

    <!-- ══ 대시보드 ══ -->
    <div class="page active" id="pg-dashboard">
      <div class="stats-row">
        <div class="stat-card"><div class="stat-label">오늘 매출</div><div class="stat-val">₩2,840,000</div><div class="stat-change c-up">↑ 12.4% 전일 대비</div></div>
        <div class="stat-card"><div class="stat-label">오늘 주문</div><div class="stat-val" style="color:var(--blue)">38 건</div><div class="stat-change c-up">↑ 7건 증가</div></div>
        <div class="stat-card"><div class="stat-label">미처리 반품</div><div class="stat-val" style="color:var(--orange)">5 건</div><div class="stat-change c-warn">처리 대기 중</div></div>
        <div class="stat-card"><div class="stat-label">재고 부족</div><div class="stat-val" style="color:var(--red)">2 개</div><div class="stat-change c-dn">즉시 확인 필요</div></div>
        <div class="stat-card"><div class="stat-label">신규 회원</div><div class="stat-val">12 명</div><div class="stat-change c-up">↑ 3명 전일 대비</div></div>
      </div>
      <div class="grid-dash" style="gap:16px">
        <div class="card">
          <div class="card-header"><span class="card-title">월별 매출</span></div>
          <div class="bar-row"><div class="bar-lbl">1월</div><div class="bar-track"><div class="bar-fill" style="width:55%;background:var(--black)">₩55M</div></div><div class="bar-val">₩55M</div></div>
          <div class="bar-row"><div class="bar-lbl">2월</div><div class="bar-track"><div class="bar-fill" style="width:68%;background:var(--black)">₩68M</div></div><div class="bar-val">₩68M</div></div>
          <div class="bar-row"><div class="bar-lbl">3월</div><div class="bar-track"><div class="bar-fill" style="width:80%;background:var(--black)">₩80M</div></div><div class="bar-val">₩80M</div></div>
          <div class="bar-row"><div class="bar-lbl">4월</div><div class="bar-track"><div class="bar-fill" style="width:72%;background:var(--red)">₩72M (진행)</div></div><div class="bar-val">₩72M</div></div>
        </div>
        <div class="card">
          <div class="card-header"><span class="card-title">인기 상품</span></div>
          <div class="bar-row"><div class="bar-lbl">나이키 에어</div><div class="bar-track"><div class="bar-fill" style="width:85%;background:var(--black)">342건</div></div></div>
          <div class="bar-row"><div class="bar-lbl">아디다스</div><div class="bar-track"><div class="bar-fill" style="width:70%;background:var(--black)">280건</div></div></div>
          <div class="bar-row"><div class="bar-lbl">버켄스탁</div><div class="bar-track"><div class="bar-fill" style="width:55%;background:var(--gray3)">220건</div></div></div>
          <div class="bar-row"><div class="bar-lbl">뉴발란스</div><div class="bar-track"><div class="bar-fill" style="width:45%;background:var(--gray3)">180건</div></div></div>
        </div>
      </div>
      <div class="card">
        <div class="card-header"><span class="card-title">최근 주문</span><div class="btn btn-outline btn-sm" onclick="go('order',document.querySelector('[onclick*=order]'))">전체 보기 →</div></div>
        <div class="tbl-wrap" style="border:none">
          <table><thead><tr><th>주문번호</th><th>회원</th><th>상품</th><th>금액</th><th>상태</th><th>주문일</th></tr></thead>
          <tbody>
            <tr><td>#20240420-001</td><td>hong****</td><td>나이키 에어맥스 외 1건</td><td>₩189,000</td><td><span class="badge b-orange">결제완료</span></td><td>2024-04-20</td></tr>
            <tr><td>#20240420-002</td><td>kim****</td><td>아디다스 삼바</td><td>₩129,000</td><td><span class="badge b-blue">배송중</span></td><td>2024-04-20</td></tr>
            <tr><td>#20240420-003</td><td>lee****</td><td>버켄스탁 보스턴</td><td>₩89,000</td><td><span class="badge b-green">배송완료</span></td><td>2024-04-19</td></tr>
          </tbody></table>
        </div>
      </div>
    </div>

    <!-- ══ 상품 관리 ══ -->
    <div class="page" id="pg-product">
      <div class="page-hdr">
        <div class="page-hdr-left">
          <div class="page-hdr-title">상품 관리</div>
          <div class="page-hdr-sub">상품 이미지 위에 마우스를 올리면 수정·삭제·숨김 버튼이 나타납니다</div>
        </div>
        <button class="btn btn-black" onclick="openModal('modal-product')">+ 상품 등록</button>
      </div>
      <div class="toolbar">
        <div class="search-wrap"><span class="search-ico">🔍</span><input type="text" placeholder="상품명·브랜드·품번 검색"></div>
        <select class="sel"><option>전체 카테고리</option><option>👟 운동화</option><option>👡 샌들</option><option>👞 구두</option><option>🥾 부츠</option></select>
        <select class="sel"><option>전체 상태</option><option>판매중</option><option>숨김</option><option>재고부족</option><option>품절</option></select>
        <select class="sel"><option>정렬: 최신순</option><option>가격 낮은순</option><option>가격 높은순</option><option>재고 낮은순</option></select>
        <div style="margin-left:auto;display:flex;gap:6px">
          <button class="btn btn-outline btn-sm">선택 숨김</button>
          <button class="btn btn-danger btn-sm">선택 삭제</button>
        </div>
      </div>

      <!-- PRODUCT CARD GRID -->
      <div class="prod-admin-grid">

        <!-- + 등록 카드 -->
        <div class="pac-add-card" onclick="openModal('modal-product')">
          <div class="pac-add-icon">＋</div>
          <div class="pac-add-label">상품 등록</div>
        </div>

        <!-- 상품 카드 1 -->
        <div class="prod-admin-card">
          <div class="pac-img">
            👟
            <div class="pac-img-overlay">
              <button class="pac-img-btn" onclick="openModal('modal-product')">✏️ 이미지 수정</button>
              <button class="pac-img-btn" onclick="event.stopPropagation()">📷 사진 추가</button>
              <button class="pac-img-btn del">🗑 이미지 삭제</button>
            </div>
            <div class="pac-badges"><span class="badge b-black" style="font-size:9px">BEST</span></div>
            <div class="pac-status"><span class="badge b-green" style="font-size:9px">판매중</span></div>
          </div>
          <div class="pac-info">
            <div class="pac-brand">NIKE</div>
            <div class="pac-name" onclick="openModal('modal-product-edit')">에어맥스 270</div>
            <div class="pac-code">NK-AM270-GRY | SKU #10042</div>
            <div class="pac-price-row">
              <span class="pac-disc">20%</span>
              <span class="pac-price">₩151,200</span>
              <span class="pac-origin">₩189,000</span>
            </div>
            <div class="pac-stock">재고: <span>48개</span> | 색상 3종 · 사이즈 8종</div>
          </div>
          <div class="pac-actions">
            <button class="pac-act-btn edit" onclick="openModal('modal-product-edit')">✏️ 수정</button>
            <button class="pac-act-btn hide">🙈 숨김</button>
            <button class="pac-act-btn del">🗑 삭제</button>
          </div>
        </div>

        <!-- 상품 카드 2 -->
        <div class="prod-admin-card">
          <div class="pac-img">
            👟
            <div class="pac-img-overlay">
              <button class="pac-img-btn" onclick="openModal('modal-product')">✏️ 이미지 수정</button>
              <button class="pac-img-btn">📷 사진 추가</button>
              <button class="pac-img-btn del">🗑 이미지 삭제</button>
            </div>
            <div class="pac-badges"><span class="badge b-blue" style="font-size:9px">NEW</span></div>
            <div class="pac-status"><span class="badge b-green" style="font-size:9px">판매중</span></div>
          </div>
          <div class="pac-info">
            <div class="pac-brand">ADIDAS</div>
            <div class="pac-name">삼바 OG</div>
            <div class="pac-code">AD-SAMBA-BLK | SKU #10055</div>
            <div class="pac-price-row">
              <span class="pac-price">₩129,000</span>
            </div>
            <div class="pac-stock">재고: <span>67개</span> | 색상 2종 · 사이즈 9종</div>
          </div>
          <div class="pac-actions">
            <button class="pac-act-btn edit" onclick="openModal('modal-product-edit')">✏️ 수정</button>
            <button class="pac-act-btn hide">🙈 숨김</button>
            <button class="pac-act-btn del">🗑 삭제</button>
          </div>
        </div>

        <!-- 상품 카드 3 - 재고부족 -->
        <div class="prod-admin-card">
          <div class="pac-img" style="background:#fff8f8">
            👞
            <div class="pac-img-overlay">
              <button class="pac-img-btn" onclick="openModal('modal-product')">✏️ 이미지 수정</button>
              <button class="pac-img-btn">📷 사진 추가</button>
              <button class="pac-img-btn del">🗑 이미지 삭제</button>
            </div>
            <div class="pac-status"><span class="badge b-red" style="font-size:9px">재고부족</span></div>
          </div>
          <div class="pac-info">
            <div class="pac-brand">GUCCI</div>
            <div class="pac-name">로퍼 클래식</div>
            <div class="pac-code">GC-LOAFER-BRN | SKU #10021</div>
            <div class="pac-price-row">
              <span class="pac-price">₩520,000</span>
            </div>
            <div class="pac-stock low">재고: <span>3개</span> | 색상 1종 · 사이즈 6종</div>
          </div>
          <div class="pac-actions">
            <button class="pac-act-btn edit" onclick="openModal('modal-product-edit')">✏️ 수정</button>
            <button class="pac-act-btn hide">🙈 숨김</button>
            <button class="pac-act-btn del">🗑 삭제</button>
          </div>
        </div>

        <!-- 상품 카드 4 -->
        <div class="prod-admin-card">
          <div class="pac-img">
            👡
            <div class="pac-img-overlay">
              <button class="pac-img-btn" onclick="openModal('modal-product')">✏️ 이미지 수정</button>
              <button class="pac-img-btn">📷 사진 추가</button>
              <button class="pac-img-btn del">🗑 이미지 삭제</button>
            </div>
            <div class="pac-status"><span class="badge b-green" style="font-size:9px">판매중</span></div>
          </div>
          <div class="pac-info">
            <div class="pac-brand">BIRKENSTOCK</div>
            <div class="pac-name">보스턴 스웨이드</div>
            <div class="pac-code">BK-BOSTON-BEG | SKU #10038</div>
            <div class="pac-price-row">
              <span class="pac-disc">10%</span>
              <span class="pac-price">₩80,100</span>
              <span class="pac-origin">₩89,000</span>
            </div>
            <div class="pac-stock">재고: <span>12개</span> | 색상 4종 · 사이즈 7종</div>
          </div>
          <div class="pac-actions">
            <button class="pac-act-btn edit" onclick="openModal('modal-product-edit')">✏️ 수정</button>
            <button class="pac-act-btn hide">🙈 숨김</button>
            <button class="pac-act-btn del">🗑 삭제</button>
          </div>
        </div>

        <!-- 상품 카드 5 - 숨김 -->
        <div class="prod-admin-card" style="opacity:.55">
          <div class="pac-img" style="background:#f0f0f0">
            🥾
            <div class="pac-img-overlay">
              <button class="pac-img-btn">✏️ 이미지 수정</button>
              <button class="pac-img-btn">📷 사진 추가</button>
              <button class="pac-img-btn del">🗑 이미지 삭제</button>
            </div>
            <div class="pac-status"><span class="badge b-gray" style="font-size:9px">숨김</span></div>
          </div>
          <div class="pac-info">
            <div class="pac-brand">TIMBERLAND</div>
            <div class="pac-name">6인치 부츠</div>
            <div class="pac-code">TM-6INCH-WHT | SKU #10019</div>
            <div class="pac-price-row">
              <span class="pac-price">₩219,000</span>
            </div>
            <div class="pac-stock">재고: <span>22개</span> | 색상 2종 · 사이즈 8종</div>
          </div>
          <div class="pac-actions">
            <button class="pac-act-btn edit">✏️ 수정</button>
            <button class="pac-act-btn" style="color:var(--green)" onmouseenter="this.style.background='#e8f5e8'" onmouseleave="this.style.background=''">👁 공개</button>
            <button class="pac-act-btn del">🗑 삭제</button>
          </div>
        </div>

        <!-- 상품 카드 6 -->
        <div class="prod-admin-card">
          <div class="pac-img">
            👟
            <div class="pac-img-overlay">
              <button class="pac-img-btn">✏️ 이미지 수정</button>
              <button class="pac-img-btn">📷 사진 추가</button>
              <button class="pac-img-btn del">🗑 이미지 삭제</button>
            </div>
            <div class="pac-badges"><span class="badge" style="background:var(--orange);color:#fff;font-size:9px">SALE</span></div>
            <div class="pac-status"><span class="badge b-green" style="font-size:9px">판매중</span></div>
          </div>
          <div class="pac-info">
            <div class="pac-brand">NEW BALANCE</div>
            <div class="pac-name">990v5 메이드 인 USA</div>
            <div class="pac-code">NB-990V5-GRY | SKU #10061</div>
            <div class="pac-price-row">
              <span class="pac-disc">15%</span>
              <span class="pac-price">₩254,150</span>
              <span class="pac-origin">₩299,000</span>
            </div>
            <div class="pac-stock">재고: <span>31개</span> | 색상 3종 · 사이즈 9종</div>
          </div>
          <div class="pac-actions">
            <button class="pac-act-btn edit" onclick="openModal('modal-product-edit')">✏️ 수정</button>
            <button class="pac-act-btn hide">🙈 숨김</button>
            <button class="pac-act-btn del">🗑 삭제</button>
          </div>
        </div>

        <!-- 상품 카드 7 -->
        <div class="prod-admin-card">
          <div class="pac-img">
            👟
            <div class="pac-img-overlay">
              <button class="pac-img-btn">✏️ 이미지 수정</button>
              <button class="pac-img-btn">📷 사진 추가</button>
              <button class="pac-img-btn del">🗑 이미지 삭제</button>
            </div>
            <div class="pac-status"><span class="badge b-green" style="font-size:9px">판매중</span></div>
          </div>
          <div class="pac-info">
            <div class="pac-brand">HOKA</div>
            <div class="pac-name">클리프턴 9</div>
            <div class="pac-code">HK-CLIFF9-WHT | SKU #10072</div>
            <div class="pac-price-row">
              <span class="pac-price">₩179,000</span>
            </div>
            <div class="pac-stock">재고: <span>44개</span> | 색상 5종 · 사이즈 10종</div>
          </div>
          <div class="pac-actions">
            <button class="pac-act-btn edit" onclick="openModal('modal-product-edit')">✏️ 수정</button>
            <button class="pac-act-btn hide">🙈 숨김</button>
            <button class="pac-act-btn del">🗑 삭제</button>
          </div>
        </div>

      </div><!-- /prod-admin-grid -->
    </div>

    <!-- ══ 카테고리 ══ -->
    <div class="page" id="pg-category">
      <div class="grid-2">
        <div class="card">
          <div class="card-header"><span class="card-title">카테고리 목록</span><button class="btn btn-black btn-sm">+ 추가</button></div>
          <div class="tbl-wrap" style="border:none"><table><thead><tr><th>카테고리명</th><th>상품 수</th><th>순서</th><th>관리</th></tr></thead>
          <tbody>
            <tr><td>👟 운동화</td><td>42개</td><td>1</td><td><button class="btn btn-outline btn-xs">수정</button> <button class="btn btn-danger btn-xs">삭제</button></td></tr>
            <tr><td>👡 샌들</td><td>28개</td><td>2</td><td><button class="btn btn-outline btn-xs">수정</button> <button class="btn btn-danger btn-xs">삭제</button></td></tr>
            <tr><td>👞 구두</td><td>35개</td><td>3</td><td><button class="btn btn-outline btn-xs">수정</button> <button class="btn btn-danger btn-xs">삭제</button></td></tr>
            <tr><td>🥾 부츠</td><td>19개</td><td>4</td><td><button class="btn btn-outline btn-xs">수정</button> <button class="btn btn-danger btn-xs">삭제</button></td></tr>
          </tbody></table></div>
        </div>
        <div class="card">
          <div class="card-header"><span class="card-title">카테고리 추가</span></div>
          <div class="form-group" style="margin-bottom:12px"><label class="f-label">카테고리명</label><input class="f-input" placeholder="예: 슬리퍼"></div>
          <div class="form-group" style="margin-bottom:12px"><label class="f-label">이모지 아이콘</label><input class="f-input" placeholder="🩴"></div>
          <div class="form-group" style="margin-bottom:16px"><label class="f-label">설명</label><textarea class="f-input" style="min-height:70px" placeholder="카테고리 설명"></textarea></div>
          <button class="btn btn-black">저장</button>
        </div>
      </div>
    </div>

    <!-- ══ 재고 관리 ══ -->
    <div class="page" id="pg-stock">
      <div class="alert alert-warn">⚠️ 재고 부족 상품 <strong>2개</strong>가 있습니다. 물류 담당자에게 입고 요청하세요.</div>
      <div class="tabs">
        <div class="tab on" onclick="setTab(this,'t-stock','stab')">재고 현황</div>
        <div class="tab" onclick="setTab(this,'t-adjust','stab')">재고 조정</div>
      </div>
      <div id="t-stock" class="stab">
        <div class="toolbar">
          <div class="search-wrap"><span class="search-ico">🔍</span><input placeholder="상품명·품번 검색"></div>
          <select class="sel"><option>전체 브랜드</option><option>나이키</option><option>아디다스</option></select>
        </div>
        <div class="tbl-wrap"><table><thead><tr><th>상품명</th><th>품번</th><th>카테고리</th><th>전체 재고</th><th>현황</th><th>재고 상태</th><th>최근 입고일</th></tr></thead>
        <tbody>
          <tr><td>나이키 에어맥스 270</td><td style="font-size:11px;color:var(--gray4)">NK-AM270-GRY</td><td>운동화</td><td>48개</td><td><div class="stk-track"><div class="stk-fill stk-ok" style="width:80%"></div></div></td><td><span class="badge b-green">정상</span></td><td>2024-04-15</td></tr>
          <tr><td>아디다스 삼바 OG</td><td style="font-size:11px;color:var(--gray4)">AD-SAMBA-BLK</td><td>운동화</td><td>67개</td><td><div class="stk-track"><div class="stk-fill stk-ok" style="width:100%"></div></div></td><td><span class="badge b-green">정상</span></td><td>2024-04-18</td></tr>
          <tr><td>버켄스탁 보스턴</td><td style="font-size:11px;color:var(--gray4)">BK-BOSTON-BEG</td><td>샌들</td><td>12개</td><td><div class="stk-track"><div class="stk-fill stk-warn" style="width:24%"></div></div></td><td><span class="badge b-orange">주의</span></td><td>2024-04-10</td></tr>
          <tr><td>구찌 로퍼</td><td style="font-size:11px;color:var(--gray4)">GC-LOAFER-BRN</td><td>구두</td><td>3개</td><td><div class="stk-track"><div class="stk-fill stk-low" style="width:6%"></div></div></td><td><span class="badge b-red">부족</span></td><td>2024-03-28</td></tr>
        </tbody></table></div>
      </div>
      <div id="t-adjust" class="stab" style="display:none">
        <div class="card" style="max-width:480px">
          <div class="form-grid">
            <div class="form-group full"><label class="f-label">상품 선택</label><select class="f-input"><option>나이키 에어맥스 270</option><option>구찌 로퍼</option></select></div>
            <div class="form-group"><label class="f-label">조정 유형</label><select class="f-input"><option>증가 (+)</option><option>감소 (-)</option></select></div>
            <div class="form-group"><label class="f-label">수량</label><input class="f-input" type="number" placeholder="0"></div>
            <div class="form-group full"><label class="f-label">조정 사유</label><textarea class="f-input" placeholder="조정 사유를 입력하세요 (필수)"></textarea></div>
          </div>
          <button class="btn btn-black" style="margin-top:14px">재고 조정 적용</button>
        </div>
      </div>
    </div>

    <!-- ══ 주문 관리 ══ -->
    <div class="page" id="pg-order">
      <div class="toolbar">
        <div class="search-wrap"><span class="search-ico">🔍</span><input placeholder="주문번호 / 회원 검색"></div>
        <select class="sel"><option>전체 상태</option><option>결제완료</option><option>배송준비</option><option>배송중</option><option>배송완료</option><option>취소</option></select>
        <input type="date" class="sel" style="padding:9px 10px">
        <span style="font-size:12px;color:var(--gray4)">~</span>
        <input type="date" class="sel" style="padding:9px 10px">
      </div>
      <div class="tbl-wrap"><table><thead><tr><th>주문번호</th><th>회원</th><th>상품</th><th>금액</th><th>상태</th><th>주문일</th><th>처리</th></tr></thead>
      <tbody>
        <tr><td>#20240420-001</td><td>hong****</td><td>나이키 에어맥스 외 1건</td><td>₩189,000</td><td><span class="badge b-orange">결제완료</span></td><td>2024-04-20</td><td><button class="btn btn-black btn-xs">배송준비</button></td></tr>
        <tr><td>#20240420-002</td><td>kim****</td><td>아디다스 삼바</td><td>₩129,000</td><td><span class="badge b-blue">배송중</span></td><td>2024-04-20</td><td><button class="btn btn-outline btn-xs">상세</button></td></tr>
        <tr><td>#20240419-015</td><td>lee****</td><td>버켄스탁</td><td>₩89,000</td><td><span class="badge b-green">배송완료</span></td><td>2024-04-19</td><td><button class="btn btn-outline btn-xs">상세</button></td></tr>
        <tr><td>#20240419-014</td><td>park****</td><td>구찌 로퍼</td><td>₩520,000</td><td><span class="badge b-gray">취소</span></td><td>2024-04-19</td><td><button class="btn btn-outline btn-xs">상세</button></td></tr>
      </tbody></table></div>
    </div>

    <!-- ══ 배송 관리 ══ -->
    <div class="page" id="pg-delivery">
      <div class="tbl-wrap"><table><thead><tr><th>주문번호</th><th>수령인</th><th>우편번호</th><th>택배사</th><th>송장번호</th><th>상태</th><th>관리</th></tr></thead>
      <tbody>
        <tr><td>#20240420-002</td><td>김민준</td><td>06234</td><td>CJ대한통운</td><td>123456789012</td><td><span class="badge b-blue">배송중</span></td><td><button class="btn btn-outline btn-xs">수정</button></td></tr>
        <tr><td>#20240419-015</td><td>이지수</td><td>13209</td><td>롯데택배</td><td>987654321098</td><td><span class="badge b-blue">배송중</span></td><td><button class="btn btn-outline btn-xs">수정</button></td></tr>
        <tr><td>#20240419-014</td><td>박서연</td><td>07281</td><td>한진택배</td><td>111222333444</td><td><span class="badge b-green">배송완료</span></td><td><button class="btn btn-outline btn-xs">수정</button></td></tr>
      </tbody></table></div>
    </div>

    <!-- ══ 반품/교환 ══ -->
    <div class="page" id="pg-return">
      <div class="tbl-wrap"><table><thead><tr><th>신청번호</th><th>회원</th><th>상품</th><th>사유</th><th>유형</th><th>상태</th><th>처리</th></tr></thead>
      <tbody>
        <tr><td>RT-2024-041</td><td>hong****</td><td>나이키 에어맥스</td><td>사이즈 불량</td><td><span class="badge b-blue">교환</span></td><td><span class="badge b-orange">대기중</span></td><td><button class="btn btn-black btn-xs">승인</button> <button class="btn btn-danger btn-xs">거절</button></td></tr>
        <tr><td>RT-2024-040</td><td>lee****</td><td>버켄스탁 보스턴</td><td>단순 변심</td><td><span class="badge b-gray">반품</span></td><td><span class="badge b-orange">대기중</span></td><td><button class="btn btn-black btn-xs">승인</button> <button class="btn btn-danger btn-xs">거절</button></td></tr>
        <tr><td>RT-2024-038</td><td>kim****</td><td>아디다스 삼바</td><td>상품 불량</td><td><span class="badge b-blue">교환</span></td><td><span class="badge b-green">승인완료</span></td><td><button class="btn btn-outline btn-xs">상세</button></td></tr>
      </tbody></table></div>
    </div>

    <!-- ══ 회원 관리 ══ -->
    <div class="page" id="pg-member">
      <div class="toolbar">
        <div class="search-wrap"><span class="search-ico">🔍</span><input placeholder="아이디 / 이름 / 이메일 검색"></div>
        <select class="sel"><option>전체 회원</option><option>일반</option><option>VIP</option><option>골드</option><option>정지</option></select>
      </div>
      <div class="tbl-wrap"><table><thead><tr><th></th><th>아이디</th><th>이름</th><th>이메일</th><th>가입일</th><th>등급</th><th>상태</th><th>관리</th></tr></thead>
      <tbody>
        <tr>
          <td><div class="member-avatar">홍</div></td>
          <td>hong1234</td><td>홍길동</td><td>hong@email.com</td><td>2024-01-15</td>
          <td><span class="badge b-orange">골드</span></td>
          <td><span class="badge b-green">정상</span></td>
          <td><button class="btn btn-outline btn-xs">상세</button></td>
        </tr>
        <tr>
          <td><div class="member-avatar">김</div></td>
          <td>kim5678</td><td>김민준</td><td>kim@email.com</td><td>2024-02-20</td>
          <td><span class="badge b-gray">일반</span></td>
          <td><span class="badge b-green">정상</span></td>
          <td><button class="btn btn-outline btn-xs">상세</button></td>
        </tr>
        <tr>
          <td><div class="member-avatar" style="background:#ffe0e0;color:var(--red)">이</div></td>
          <td>lee9012</td><td>이지수</td><td>lee@email.com</td><td>2024-03-05</td>
          <td><span class="badge b-gray">일반</span></td>
          <td><span class="badge b-red">정지</span></td>
          <td><button class="btn btn-outline btn-xs">상세</button> <button class="btn btn-black btn-xs">잠금해제</button></td>
        </tr>
      </tbody></table></div>
    </div>

    <!-- ══ 쿠폰 관리 ══ -->
    <div class="page" id="pg-coupon">
      <div class="page-hdr">
        <div><div class="page-hdr-title">쿠폰 관리</div></div>
        <button class="btn btn-black" onclick="openModal('modal-coupon')">+ 쿠폰 생성</button>
      </div>
      <div class="tbl-wrap"><table><thead><tr><th>쿠폰명</th><th>유형</th><th>할인</th><th>최소 주문</th><th>사용 기간</th><th>발급 수</th><th>상태</th><th>관리</th></tr></thead>
      <tbody>
        <tr><td>신규 가입 쿠폰</td><td>정률</td><td>10%</td><td>₩50,000</td><td>~2024-12-31</td><td>1,204장</td><td><span class="badge b-green">활성</span></td><td><button class="btn btn-outline btn-xs">수정</button></td></tr>
        <tr><td>골드 등급 전용 쿠폰</td><td>정액</td><td>₩20,000</td><td>₩150,000</td><td>~2024-06-30</td><td>328장</td><td><span class="badge b-green">활성</span></td><td><button class="btn btn-outline btn-xs">수정</button></td></tr>
        <tr><td>봄 시즌 프로모션</td><td>정률</td><td>20%</td><td>₩100,000</td><td>~2024-04-30</td><td>5,000장</td><td><span class="badge b-gray">만료</span></td><td><button class="btn btn-outline btn-xs">복사</button></td></tr>
      </tbody></table></div>
    </div>

    <!-- ══ 채팅 문의 ══ -->
    <div class="page" id="pg-chat">
      <div class="chat-layout">
        <div class="chat-list">
          <div style="padding:12px 16px;border-bottom:1px solid var(--border);font-size:12px;font-weight:700;color:var(--gray3);text-transform:uppercase;letter-spacing:.06em">문의 목록 <span class="badge b-red" style="margin-left:6px">3</span></div>
          <div class="chat-item on">
            <div class="chat-name">hong1234 <span class="badge b-orange" style="font-size:9px">미답변</span></div>
            <div class="chat-preview">사이즈 교환이 가능한가요?</div>
            <div class="chat-time">방금 전</div>
          </div>
          <div class="chat-item">
            <div class="chat-name">kim5678 <span class="badge b-orange" style="font-size:9px">미답변</span></div>
            <div class="chat-preview">배송이 언제 오나요?</div>
            <div class="chat-time">10분 전</div>
          </div>
          <div class="chat-item">
            <div class="chat-name">lee9012</div>
            <div class="chat-preview">감사합니다!</div>
            <div class="chat-time">1시간 전</div>
          </div>
        </div>
        <div class="chat-room">
          <div class="chat-room-hdr">
            <div style="width:30px;height:30px;border-radius:50%;background:var(--red);display:flex;align-items:center;justify-content:center;font-size:12px;font-weight:700;color:#fff">H</div>
            <div><div style="font-size:13px;font-weight:700">hong1234</div><div style="font-size:10px;color:#666">온라인</div></div>
            <div style="margin-left:auto"><button class="btn btn-ghost btn-sm" style="color:#888;border-color:#333">문의 종료</button></div>
          </div>
          <div class="chat-msgs">
            <div class="msg msg-user">안녕하세요, 나이키 에어맥스 270 구매했는데 사이즈가 너무 커요. 교환 가능한가요?</div>
            <div class="msg msg-admin">네, 교환 가능합니다! 수령 후 7일 이내 미착용 상태이면 교환 신청하실 수 있어요.</div>
            <div class="msg msg-user">어디서 신청하면 되나요?</div>
          </div>
          <div class="chat-input">
            <input type="text" placeholder="답변을 입력하세요...">
            <button class="btn btn-black">전송</button>
          </div>
        </div>
      </div>
    </div>

    <!-- ══ UI/배너 관리 ══ -->
    <div class="page" id="pg-banner">
      <div class="page-hdr"><div><div class="page-hdr-title">UI / 배너 관리</div></div><button class="btn btn-black">+ 배너 등록</button></div>
      <div class="banner-card">
        <div class="banner-preview">🛍️</div>
        <div class="banner-info">
          <div class="banner-title">봄 신상 컬렉션 배너</div>
          <div class="banner-meta">위치: 메인 상단 슬라이더 · 기간: 2024-04-01 ~ 2024-04-30 · 상태: <span style="color:var(--green)">●</span> 노출 중</div>
        </div>
        <div class="banner-actions">
          <button class="btn btn-outline btn-sm">수정</button>
          <button class="btn btn-danger btn-sm">삭제</button>
        </div>
      </div>
      <div class="banner-card">
        <div class="banner-preview">👟</div>
        <div class="banner-info">
          <div class="banner-title">나이키 에어맥스 프로모션</div>
          <div class="banner-meta">위치: 메인 슬라이더 2번 · 기간: 2024-04-01 ~ 2024-05-15 · 상태: <span style="color:var(--green)">●</span> 노출 중</div>
        </div>
        <div class="banner-actions">
          <button class="btn btn-outline btn-sm">수정</button>
          <button class="btn btn-danger btn-sm">삭제</button>
        </div>
      </div>
    </div>

    <!-- ══ 매장 정보 ══ -->
    <div class="page" id="pg-store">
      <div class="page-hdr"><div><div class="page-hdr-title">매장 정보 관리</div></div><button class="btn btn-black">+ 매장 등록</button></div>
      <div style="background:var(--gray7);border:1px solid var(--border);height:300px;display:flex;align-items:center;justify-content:center;margin-bottom:16px;flex-direction:column;gap:8px">
        <div style="font-size:32px">🗺️</div>
        <div style="font-size:13px;color:var(--gray4);font-weight:500">카카오맵 API 연동 영역</div>
        <div style="font-size:11px;color:var(--gray5)">API 키 등록 후 지도가 표시됩니다</div>
      </div>
      <div class="tbl-wrap"><table><thead><tr><th>매장명</th><th>주소</th><th>전화번호</th><th>운영시간</th><th>관리</th></tr></thead>
      <tbody>
        <tr><td>강남점</td><td>서울 강남구 테헤란로 123</td><td>02-1234-5678</td><td>10:00~21:00</td><td><button class="btn btn-outline btn-xs">수정</button> <button class="btn btn-danger btn-xs">삭제</button></td></tr>
        <tr><td>홍대점</td><td>서울 마포구 홍익로 45</td><td>02-9876-5432</td><td>11:00~22:00</td><td><button class="btn btn-outline btn-xs">수정</button> <button class="btn btn-danger btn-xs">삭제</button></td></tr>
      </tbody></table></div>
    </div>

    <!-- ══ 알림 발송 ══ -->
    <div class="page" id="pg-notify">
      <div class="grid-2">
        <div class="card">
          <div class="card-header"><span class="card-title">공지 알림 발송</span></div>
          <div class="form-group" style="margin-bottom:12px"><label class="f-label">대상</label>
            <select class="f-input"><option>전체 회원</option><option>골드 등급 이상</option><option>특정 회원 선택</option></select>
          </div>
          <div class="form-group" style="margin-bottom:12px"><label class="f-label">제목</label><input class="f-input" placeholder="알림 제목"></div>
          <div class="form-group" style="margin-bottom:16px"><label class="f-label">내용</label><textarea class="f-input" placeholder="알림 내용을 입력하세요"></textarea></div>
          <button class="btn btn-black">알림 발송</button>
        </div>
        <div class="card">
          <div class="card-header"><span class="card-title">최근 발송 내역</span></div>
          <div class="tbl-wrap" style="border:none"><table><thead><tr><th>제목</th><th>대상</th><th>발송일</th></tr></thead>
          <tbody>
            <tr><td>봄 신상 도착 알림</td><td>전체</td><td>04-15</td></tr>
            <tr><td>골드 쿠폰 발급 안내</td><td>골드</td><td>04-10</td></tr>
          </tbody></table></div>
        </div>
      </div>
    </div>

  </div><!-- /content -->
</main>

<!-- ═════════ MODALS ═════════ -->

<!-- 상품 등록 모달 -->
<div class="modal-overlay" id="modal-product">
  <div class="modal-box">
    <div class="modal-hdr">
      <div class="modal-title">상품 등록</div>
      <button class="modal-close" onclick="closeModal('modal-product')">✕</button>
    </div>
    <div class="modal-body">
      <!-- 이미지 업로드 -->
      <div class="form-group full" style="margin-bottom:16px">
        <label class="f-label">상품 이미지</label>
        <div class="img-upload-zone" onclick="document.getElementById('file-input').click()">
          <div class="img-up-icon">📸</div>
          <div class="img-up-text">클릭하여 이미지 업로드</div>
          <div class="img-up-sub">JPG, PNG, WEBP · 최대 5MB · 최대 10장</div>
        </div>
        <input type="file" id="file-input" accept="image/*" multiple style="display:none" onchange="previewImages(this)">
        <div class="img-previews" id="img-previews"></div>
      </div>

      <div class="form-grid">
        <div class="form-group full"><label class="f-label">상품명</label><input class="f-input" placeholder="상품명을 입력하세요"></div>
        <div class="form-group"><label class="f-label">브랜드</label><select class="f-input"><option>나이키</option><option>아디다스</option><option>뉴발란스</option><option>버켄스탁</option><option>구찌</option><option>호카</option></select></div>
        <div class="form-group"><label class="f-label">카테고리</label><select class="f-input"><option>운동화</option><option>샌들</option><option>구두</option><option>부츠</option></select></div>
        <div class="form-group"><label class="f-label">정가 (원)</label><input class="f-input" type="number" placeholder="0"></div>
        <div class="form-group"><label class="f-label">할인율 (%)</label><input class="f-input" type="number" placeholder="0" min="0" max="100"></div>
        <div class="form-group"><label class="f-label">품번 (SKU)</label><input class="f-input" placeholder="NK-AM270-GRY"></div>
        <div class="form-group"><label class="f-label">성별</label><select class="f-input"><option>공용</option><option>남성</option><option>여성</option></select></div>

        <!-- 컬러 선택 -->
        <div class="form-group full">
          <label class="f-label">컬러 옵션</label>
          <div class="option-row">
            <button class="opt-chip color-chip on" type="button" onclick="this.classList.toggle('on')"><div class="color-dot" style="background:#fff;border-color:#ccc"></div>화이트</button>
            <button class="opt-chip color-chip" type="button" onclick="this.classList.toggle('on')"><div class="color-dot" style="background:#111"></div>블랙</button>
            <button class="opt-chip color-chip" type="button" onclick="this.classList.toggle('on')"><div class="color-dot" style="background:#888"></div>그레이</button>
            <button class="opt-chip color-chip" type="button" onclick="this.classList.toggle('on')"><div class="color-dot" style="background:#c8a87a"></div>베이지</button>
            <button class="opt-chip color-chip" type="button" onclick="this.classList.toggle('on')"><div class="color-dot" style="background:#2255aa"></div>네이비</button>
            <button class="opt-chip color-chip" type="button" onclick="this.classList.toggle('on')"><div class="color-dot" style="background:#cc2222"></div>레드</button>
          </div>
        </div>

        <!-- 사이즈 선택 -->
        <div class="form-group full">
          <label class="f-label">사이즈 옵션 (mm)</label>
          <div class="option-row">
            <button class="opt-chip" type="button" onclick="this.classList.toggle('on')">220</button>
            <button class="opt-chip" type="button" onclick="this.classList.toggle('on')">225</button>
            <button class="opt-chip on" type="button" onclick="this.classList.toggle('on')">230</button>
            <button class="opt-chip on" type="button" onclick="this.classList.toggle('on')">235</button>
            <button class="opt-chip on" type="button" onclick="this.classList.toggle('on')">240</button>
            <button class="opt-chip on" type="button" onclick="this.classList.toggle('on')">245</button>
            <button class="opt-chip on" type="button" onclick="this.classList.toggle('on')">250</button>
            <button class="opt-chip on" type="button" onclick="this.classList.toggle('on')">255</button>
            <button class="opt-chip on" type="button" onclick="this.classList.toggle('on')">260</button>
            <button class="opt-chip on" type="button" onclick="this.classList.toggle('on')">265</button>
            <button class="opt-chip on" type="button" onclick="this.classList.toggle('on')">270</button>
            <button class="opt-chip" type="button" onclick="this.classList.toggle('on')">275</button>
            <button class="opt-chip" type="button" onclick="this.classList.toggle('on')">280</button>
            <button class="opt-chip" type="button" onclick="this.classList.toggle('on')">285</button>
          </div>
        </div>

        <div class="form-group full"><label class="f-label">상품 설명</label><textarea class="f-input" placeholder="상품 상세 설명을 입력하세요"></textarea></div>
      </div>
    </div>
    <div class="modal-footer">
      <button class="btn btn-outline" onclick="closeModal('modal-product')">취소</button>
      <button class="btn btn-black">상품 등록하기</button>
    </div>
  </div>
</div>

<!-- 상품 수정 모달 -->
<div class="modal-overlay" id="modal-product-edit">
  <div class="modal-box">
    <div class="modal-hdr">
      <div class="modal-title">상품 수정 — 나이키 에어맥스 270</div>
      <button class="modal-close" onclick="closeModal('modal-product-edit')">✕</button>
    </div>
    <div class="modal-body">
      <div class="form-group full" style="margin-bottom:16px">
        <label class="f-label">등록된 이미지</label>
        <div class="img-previews" style="margin-top:0">
          <div class="img-preview-item">👟<div class="img-del">✕</div></div>
          <div class="img-preview-item">👟<div class="img-del">✕</div></div>
          <div class="img-preview-item">👟<div class="img-del">✕</div></div>
          <div class="img-preview-item" style="border:2px dashed var(--border);cursor:pointer;color:var(--gray5);font-size:20px">+</div>
        </div>
      </div>
      <div class="form-grid">
        <div class="form-group full"><label class="f-label">상품명</label><input class="f-input" value="나이키 에어맥스 270"></div>
        <div class="form-group"><label class="f-label">정가 (원)</label><input class="f-input" type="number" value="189000"></div>
        <div class="form-group"><label class="f-label">할인율 (%)</label><input class="f-input" type="number" value="20"></div>
        <div class="form-group full"><label class="f-label">상품 설명</label><textarea class="f-input">나이키의 혁신적인 에어 쿠셔닝 기술을 탑재한 라이프스타일 운동화입니다.</textarea></div>
      </div>
    </div>
    <div class="modal-footer">
      <button class="btn btn-outline" onclick="closeModal('modal-product-edit')">취소</button>
      <button class="btn btn-black">수정 저장</button>
    </div>
  </div>
</div>

<!-- 쿠폰 생성 모달 -->
<div class="modal-overlay" id="modal-coupon">
  <div class="modal-box" style="width:520px">
    <div class="modal-hdr">
      <div class="modal-title">쿠폰 생성</div>
      <button class="modal-close" onclick="closeModal('modal-coupon')">✕</button>
    </div>
    <div class="modal-body">
      <div class="form-grid">
        <div class="form-group full"><label class="f-label">쿠폰명</label><input class="f-input" placeholder="쿠폰 이름"></div>
        <div class="form-group"><label class="f-label">할인 유형</label><select class="f-input"><option>정률 (%)</option><option>정액 (원)</option></select></div>
        <div class="form-group"><label class="f-label">할인값</label><input class="f-input" type="number" placeholder="0"></div>
        <div class="form-group"><label class="f-label">최소 주문 금액</label><input class="f-input" type="number" placeholder="0"></div>
        <div class="form-group"><label class="f-label">최대 할인 금액</label><input class="f-input" type="number" placeholder="0 (제한없음)"></div>
        <div class="form-group"><label class="f-label">시작일</label><input class="f-input" type="date"></div>
        <div class="form-group"><label class="f-label">종료일</label><input class="f-input" type="date"></div>
        <div class="form-group full"><label class="f-label">발급 대상</label><select class="f-input"><option>전체 회원</option><option>골드 등급 이상</option><option>신규 가입자</option></select></div>
      </div>
    </div>
    <div class="modal-footer">
      <button class="btn btn-outline" onclick="closeModal('modal-coupon')">취소</button>
      <button class="btn btn-black">쿠폰 생성</button>
    </div>
  </div>
</div>

<script>
// PAGE NAV
const pgTitles = {
  dashboard:['통계 / 대시보드','/ dashboard'],
  product:['상품 관리','/ product'],
  category:['카테고리 관리','/ category'],
  stock:['재고 관리','/ stock'],
  order:['주문 관리','/ order'],
  delivery:['배송 관리','/ delivery'],
  return:['반품/교환 관리','/ returns'],
  member:['회원 관리','/ members'],
  coupon:['쿠폰 관리','/ coupon'],
  chat:['채팅 문의','/ chat'],
  banner:['UI / 배너 관리','/ banner'],
  store:['매장 정보 관리','/ store'],
  notify:['알림 발송 관리','/ notify'],
};
function go(id, el) {
  document.querySelectorAll('.page').forEach(p => p.classList.remove('active'));
  document.querySelectorAll('.nav-item').forEach(n => n.classList.remove('active'));
  document.getElementById('pg-' + id).classList.add('active');
  if (el) el.classList.add('active');
  if (pgTitles[id]) {
    document.getElementById('pg-title').textContent = pgTitles[id][0];
    document.getElementById('pg-path').textContent = pgTitles[id][1];
  }
  window.scrollTo({top:0,behavior:'smooth'});
}
// TABS
function setTab(el, showId, groupClass) {
  el.closest('.tabs').querySelectorAll('.tab').forEach(t => t.classList.remove('on'));
  el.classList.add('on');
  document.querySelectorAll('.' + groupClass).forEach(t => t.style.display = 'none');
  document.getElementById(showId).style.display = 'block';
}
// MODAL
function openModal(id) { document.getElementById(id).classList.add('open'); }
function closeModal(id) { document.getElementById(id).classList.remove('open'); }
document.querySelectorAll('.modal-overlay').forEach(o => {
  o.addEventListener('click', e => { if (e.target === o) o.classList.remove('open'); });
});
// IMAGE PREVIEW
function previewImages(input) {
  const container = document.getElementById('img-previews');
  Array.from(input.files).forEach(file => {
    const reader = new FileReader();
    reader.onload = e => {
      const div = document.createElement('div');
      div.className = 'img-preview-item';
      div.innerHTML = `<img src="${e.target.result}" style="width:100%;height:100%;object-fit:cover"><div class="img-del" onclick="this.parentElement.remove()">✕</div>`;
      container.appendChild(div);
    };
    reader.readAsDataURL(file);
  });
}
</script>
</body>
</html>
