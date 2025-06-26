#!/bin/bash

# Write the frontend (index.html)

set -e

echo "Writing frontend files..."

INSTALL_DIR="/opt/wingbits-station-web"
FRONTEND_DIR="$INSTALL_DIR/frontend"

# ========== index.html file ==========
cat > "$FRONTEND_DIR/index.html" << 'EOF'
<!DOCTYPE html>
<html lang="en" dir="ltr">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width,initial-scale=1" />
  <title>Wingbits Station Web Config</title>
  <link rel="icon" type="image/png" href="https://wingbits.com/apple-icon.png?34e8dd62bf865c3e" />
  <style>
  .tabs-bar {
  display: flex;
  gap: 0px;
  border-bottom: 2px solid #e2e8f0;
  margin-bottom: 22px;
  margin-top: 18px;
}
.tab-btn {
  background: none;
  color: #202540;
  border: none;
  border-bottom: 3px solid transparent;
  padding: 11px 32px 10px 32px;
  margin: 0;
  font-size: 1.13em;
  font-weight: 600;
  cursor: pointer;
  transition: 0.13s;
  border-radius: 13px 13px 0 0;
  outline: none;
}
.tab-btn.active {
  background: #f4f7fd;
  color: #1976d2;
  border-bottom: 3px solid #2196f3;
  font-weight: bold;
}
.tab-content {
  display: none;
  min-height: 200px;
}
.tab-content.active {
  display: block;
  animation: fadein .4s;
}
@keyframes fadein {
  from {opacity:0;}
  to {opacity:1;}
}
  body {
    background: #f5f8fe;
    font-family: 'Segoe UI', 'system-ui', Arial, sans-serif;
    margin: 0;
    padding: 0;
    direction: ltr;
  }
  .container {
    display: flex;
    height: 100vh;
    width: 100vw;
  }
  .sidebar {
    background: #1a2940;
    color: #fff;
    width: 200px;
    min-width: unset;
    padding: 24px 4px 0 4px;
    display: flex;
    flex-direction: column;
    align-items: center;
    border-top-right-radius: 22px;
    border-bottom-right-radius: 22px;
    box-shadow: 2px 0 24px #0002;
	overflow-y: auto;
    max-height: 100vh;
  }
  .logo {
    width: 38px;
    margin-bottom: 12px;
    border-radius: 12px;
    background: #fff;
    box-shadow: 0 2px 16px #0003;
  }
  .side-title {
    margin-bottom: 13px;
    font-size: 1.15rem;
    font-weight: 700;
    text-align: center;
    letter-spacing: 0.01em;
    white-space: pre-line;
  }
  .side-menu {
    width: 100%;
    margin-bottom: 18px;
  }
  .side-menu button {
    background: none;
    border: none;
    color: #fff;
    font-size: 1.03rem;
    width: 100%;
    padding: 10px 0 10px 7px;
    margin-bottom: 4px;
    text-align: left;
    cursor: pointer;
    border-radius: 8px;
    transition: background 0.16s;
    font-weight: 500;
  }
  .lang-switch {
    margin-top: auto;
    margin-bottom: 11px;
    width: 100%;
    display: flex;
    gap: 4px;
  }
  .lang-switch button {
    flex: 1;
    border-radius: 7px;
    border: none;
    background: #fff;
    color: #1a2940;
    font-weight: 600;
    font-size: 0.98rem;
    padding: 7px 0;
    cursor: pointer;
    transition: background 0.15s;
  }
  .lang-switch button.active {
    background: #1366f6;
    color: #fff;
    box-shadow: 0 2px 8px #1366f650;
  }
  .main {
    flex: 1;
    padding: 48px 7vw;
    display: flex;
    flex-direction: column;
    overflow-y: auto;
  }
  .form-group {
    margin-bottom: 26px;
  }
  .label {
    font-weight: 600;
    margin-bottom: 7px;
    display: block;
    font-size: 1.06em;
    color: #1a2940;
  }
  input, select, textarea, button.action {
    font-size: 1rem;
    padding: 10px 12px;
    border-radius: 9px;
    border: 1px solid #e3eaf4;
    background: #f6faff;
    margin-bottom: 9px;
    width: 100%;
    transition: border 0.16s;
  }
  input:focus, select:focus, textarea:focus {
    border-color: #1366f6;
    outline: none;
  }
  button.action {
    background: #1366f6;
    color: #fff;
    border: none;
    cursor: pointer;
    margin-top: 6px;
    transition: background 0.17s, box-shadow 0.18s;
    box-shadow: 0 1px 5px #1366f640;
    font-weight: 600;
    letter-spacing: 0.02em;
  }
  button.action:hover {
    background: #0956cb;
    box-shadow: 0 2px 12px #1366f655;
  }
  .result-block {
    background: #fff;
    border-radius: 18px;
    padding: 18px 18px;
    margin: 20px 0 10px 0;
    box-shadow: 0 2px 14px #0001;
    direction: ltr;
    font-family: monospace;
    font-size: 1.07em;
    overflow-x: auto;
    white-space: pre-wrap;
    color: #333;
  }
  .desc-block {
    font-size: 1.07em;
    color: #1366f6;
    margin-top: 9px;
    margin-bottom: 19px;
  }
  hr {
    border: none;
    height: 2px;
    background: #e4eaf6;
    border-radius: 2px;
    margin: 18px 0 22px 0;
  }
  @media (max-width: 700px) {
    .main { padding: 13px 1vw; }
    .sidebar { min-width: 66px; padding-left: 3px; padding-right: 3px;}
    .side-title { font-size: 1.06rem; }
    .logo { width: 38px; }
    .side-menu button { font-size: 0.98rem;}
    .lang-switch { font-size: 0.97rem;}
  }
  body.rtl .container {
  flex-direction: row-reverse;
}

body.rtl .sidebar {
  border-top-right-radius: 0;
  border-bottom-right-radius: 0;
  border-top-left-radius: 22px;
  border-bottom-left-radius: 22px;
  box-shadow: -2px 0 24px #0002;
}
body.rtl .sidebar {
  text-align: right;
}
body.rtl .side-menu button {
  text-align: right;
  padding-right: 12px;
}
body.rtl .main {
  text-align: right;
}

body.rtl .result-block,
body.rtl .desc-block,
body.rtl h2,
body.rtl h3,
body.rtl h4,
body.rtl .form-group,
body.rtl .tabs-bar,
body.rtl .tab-content,
body.rtl .tab-btn,
body.rtl input,
body.rtl select,
body.rtl textarea,
body.center button,
body.rtl table,
body.rtl #main-content {
  direction: rtl;
  text-align: right;
}
</style>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body>
  <div class="container" id="container">
    <div class="sidebar">
      <img class="logo" src="https://wingbits.com/apple-icon.png?34e8dd62bf865c3e" alt="Wingbits" />
      <div class="side-title" id="side-title">Wingbits Web Config</div>
      <div class="side-menu" id="side-menu">
        </div>
      <div class="lang-switch">
        <button id="en-btn" class="active" onclick="setLang('en')">EN</button>
        <button id="ar-btn" onclick="setLang('ar')">العربية</button>
      </div>
    </div>
    <div class="main" id="main-content">
      </div>
  </div>
  <script>
    // --------- Interface text translation ----------
    const txt = {
      en: {
        main_title: "Wingbits Station Web Config",
        menu: [
          "Service Control", "Logs", "Settings", "Reboot/Shutdown", "About"
        ],
        readsb: "readsb Service",
        wingbits: "wingbits Service",
        tar1090: "tar1090 Service",
        graphs1090: "graphs1090 Service",
        btn_status: "Status",
        btn_restart: "Restart",
        btn_logs: "Logs",
        btn_update: "Update",
        btn_geosigner: "GeoSigner Info",
        btn_version: "Version",
        btn_set_location: "Set Location",
        btn_set_gain: "Set Gain",
        btn_colorscheme: "Colorscheme",
        btn_routeinfo: "Route Info",
        btn_dark: "Dark",
        btn_light: "Light",
        btn_enable: "Enable",
        btn_disable: "Disable",
        btn_signalreport: "Signal Report",
        btn_debug: "Debug",
        logs_head: "View Logs",
        settings_head: "System Info & Tools",
        reboot: "Reboot",
        shutdown: "Shutdown",
        about: "About & Help",
        please_wait: "Please wait...",
        location_lat: "Latitude",
        location_lon: "Longitude",
        gain_value: "Gain value",
        apply: "Apply",
        service: "Service",
        select: "Select",
        colorscheme: "Colorscheme",
        pi_restart: "Reboot Device",
        pi_shutdown: "Shutdown Device",
        info_system: "System Info",
        yes: "Yes",
        no: "No",
        logout: "Logout"  
      },
      ar: {
        main_title: "إعداد محطة Wingbits عبر الويب",
        menu: [
          "تحكم الخدمات", "السجلات", "الإعدادات", "إعادة/إيقاف التشغيل", "حول"
        ],
        readsb: "خدمة readsb",
        wingbits: "خدمة wingbits",
        tar1090: "خدمة tar1090",
        graphs1090: "خدمة graphs1090",
        btn_status: "الحالة",
        btn_restart: "إعادة تشغيل",
        btn_logs: "السجلات",
        btn_update: "تحديث",
        btn_geosigner: "معلومات GeoSigner",
        btn_version: "الإصدار",
        btn_set_location: "ضبط الموقع",
        btn_set_gain: "ضبط الكسب",
        btn_colorscheme: "مخطط الألوان",
        btn_routeinfo: "معلومات المسار",
        btn_dark: "غامق",
        btn_light: "فاتح",
        btn_enable: "تفعيل",
        btn_disable: "تعطيل",
        btn_signalreport: "تقرير الإشارة",
        btn_debug: "تصحيح",
        logs_head: "عرض السجلات",
        settings_head: "معلومات النظام وأدواته",
        reboot: "إعادة تشغيل",
        shutdown: "إيقاف تشغيل",
        about: "حول & مساعدة",
        please_wait: "يرجى الانتظار...",
        location_lat: "خط العرض",
        location_lon: "خط الطول",
        gain_value: "قيمة الكسب",
        apply: "تطبيق",
        service: "الخدمة",
        select: "اختر",
        colorscheme: "مخطط الألوان",
        pi_restart: "إعادة تشغيل الجهاز",
        pi_shutdown: "إيقاف تشغيل الجهاز",
        info_system: "معلومات النظام",
        yes: "نعم",
        no: "لا",
        logout: "خروج"
      }
    };

    let LANG = localStorage.getItem("wb_lang") || "en";

    // --- Language Settings ---
    function setLang(l) {
      LANG = l;
      localStorage.setItem("wb_lang", l);
      document.body.dir = (l === "ar") ? "rtl" : "ltr";
	  document.body.classList.toggle("rtl", l === "ar");
      document.getElementById("en-btn").classList.toggle("active", l === "en");
      document.getElementById("ar-btn").classList.toggle("active", l === "ar");
      document.getElementById("side-title").innerText = txt[LANG].main_title;
      renderMenu();
      renderMenuPage('live_stats');
    }

    // --- Sidebar Menu Control ---
    function renderMenu(activeKey = 'set_location', supportSub = '', qolSub = '') {
      const mainMenu = [
        { key: 'live_stats', label: LANG === 'ar' ? 'الحالة الحية' : 'Live Stats' },
        { key: 'set_location', label: LANG === 'ar' ? 'تعيين الموقع' : 'Set Location' },
        { key: 'set_gain', label: LANG === 'ar' ? 'ضبط الكسب' : 'Set Gain' },
        { key: 'set_station_id', label: LANG === 'ar' ? 'معرف المحطة' : 'Set Station ID' },
        { key: 'qol_options', label: LANG === 'ar' ? 'خيارات الجودة' : 'QOL Options' },
        { key: 'urls', label: LANG === 'ar' ? 'روابط محلية' : 'URLs' },
        { key: 'support_menu', label: LANG === 'ar' ? 'الدعم' : 'Support Menu' },
        { key: 'restart', label: LANG === 'ar' ? 'إعادة التشغيل' : 'Restart' },
        { key: 'help', label: LANG === 'ar' ? 'مساعدة' : 'Help' }
      ];
      let menu = '';
      for (let i = 0; i < mainMenu.length; ++i) {
        let isActive = (mainMenu[i].key === activeKey) ? "active" : "";
        menu += `<button class="${isActive}" onclick="renderMenuPage('${mainMenu[i].key}')">${mainMenu[i].label}</button>`;
        if (mainMenu[i].key === 'qol_options' && activeKey === 'qol_options') {
          menu += `
            <div style="margin-left:18px;">
              <button class="${qolSub==='graphs_colorscheme'?'active':''}" onclick="renderMenuPage('qol_options', '', 'graphs_colorscheme')">${LANG === 'ar' ? 'مخطط ألوان graphs1090' : 'graphs1090 colorscheme'}</button>
              <button class="${qolSub==='tar_routes'?'active':''}" onclick="renderMenuPage('qol_options', '', 'tar_routes')">${LANG === 'ar' ? 'مسارات tar1090' : 'tar1090 routes'}</button>
              <button class="${qolSub==='tar_heatmaps'?'active':''}" onclick="renderMenuPage('qol_options', '', 'tar_heatmaps')">${LANG === 'ar' ? 'خرائط الحرارة tar1090' : 'tar1090 heatmaps'}</button>
            </div>
          `;
        }
        if (mainMenu[i].key === 'support_menu' && activeKey === 'support_menu') {
          menu += `
            <div style="margin-left:18px;">
              <button class="${supportSub==='debug'?'active':''}" onclick="renderMenuPage('support_menu','debug')">${LANG === 'ar' ? 'تصحيح' : 'Debug'}</button>
              <button class="${supportSub==='wingbits_status'?'active':''}" onclick="renderMenuPage('support_menu','wingbits_status')">${LANG === 'ar' ? 'حالة wingbits' : 'wingbits status'}</button>
              <button class="${supportSub==='readsb_status'?'active':''}" onclick="renderMenuPage('support_menu','readsb_status')">${LANG === 'ar' ? 'حالة readsb' : 'readsb status'}</button>
              <button class="${supportSub==='wingbits_logs'?'active':''}" onclick="renderMenuPage('support_menu','wingbits_logs')">${LANG === 'ar' ? 'سجلات wingbits' : 'wingbits logs'}</button>
              <button class="${supportSub==='readsb_logs'?'active':''}" onclick="renderMenuPage('support_menu','readsb_logs')">${LANG === 'ar' ? 'سجلات readsb' : 'readsb logs'}</button>
              <button class="${supportSub==='all_logs'?'active':''}" onclick="renderMenuPage('support_menu','all_logs')">${LANG === 'ar' ? 'جميع السجلات الحديثة' : 'All recent logs'}</button>
              <button class="${supportSub==='last_install_log'?'active':''}" onclick="renderMenuPage('support_menu','last_install_log')">${LANG === 'ar' ? 'سجل التثبيت الأخير' : 'Last install log'}</button>
              <button class="${supportSub==='update_client'?'active':''}" onclick="renderMenuPage('support_menu','update_client')">${LANG === 'ar' ? 'تحديث العميل' : 'Update Client'}</button>
            </div>
          `;
        }
      }
      document.getElementById("side-menu").innerHTML = menu;
    }

    function renderMenuPage(key, sub = '', qolSub = '') {
      if (key === 'support_menu') {
        renderMenu('support_menu', sub, qolSub);
        if (sub === 'debug') return renderDebug();
        if (sub === 'wingbits_status') return callAPI('/api/service/wingbits/status', 'GET', null, 'main-content');
        if (sub === 'readsb_status') return callAPI('/api/service/readsb/status', 'GET', null, 'main-content');
        if (sub === 'wingbits_logs') return callAPI('/api/service/wingbits/logs', 'GET', null, 'main-content');
        if (sub === 'readsb_logs') return callAPI('/api/service/readsb/logs', 'GET', null, 'main-content');
        if (sub === 'all_logs') return renderAllLogs();
        if (sub === 'last_install_log') return renderLastInstallLog();
        if (sub === 'update_client') return callAPI('/api/service/wingbits/update-client', 'POST', null, 'main-content');
        document.getElementById("main-content").innerHTML = `<h2>${LANG === "ar" ? "يرجى اختيار خيار فرعي..." : "Please select a Support sub-option..."}</h2>`;
        return;
      }
      renderMenu(key, '', qolSub);
      if (key === 'live_stats') return renderLiveStats();
      if (key === 'set_location') return renderSetLocation();
      if (key === 'set_gain') return renderSetGain();
      if (key === 'set_station_id') return renderSetStationID();
      if (key === 'qol_options') {
        if (qolSub === 'graphs_colorscheme') return renderGraphsColorscheme();
        if (qolSub === 'tar_routes') return renderTarRoutes();
        if (qolSub === 'tar_heatmaps') return renderTarHeatmaps();
        document.getElementById("main-content").innerHTML = `<h2>${LANG === "ar" ? "يرجى اختيار خيار فرعي..." : "Please select a QOL sub-option..."}</h2>`;
        return;
      }
      if (key === 'urls') return renderURLs();
      if (key === 'restart') return renderPower();
      if (key === 'help') return renderHelp();
      document.getElementById("main-content").innerHTML = `<h2>Coming Soon</h2>`;
    }

    // --- Live Stats / Dashboard Functions ---
    let liveChart = null;
    let liveStatsHistory = [];
    let liveTimer = null;

    function renderLiveStats() {
      document.getElementById("main-content").innerHTML = `
        <h2>${LANG === "ar" ? "لوحة مراقبة المحطة" : "Station Dashboard"}</h2>
        <div class="tabs-bar">
          <button class="tab-btn active" id="tabbtn_live" onclick="switchTab('live')">${LANG==="ar"?"الحالة الحية":"Live Stats"}</button>
          <button class="tab-btn" id="tabbtn_tools" onclick="switchTab('tools')">${LANG==="ar"?"أدوات":"Tools"}</button>
          <button class="tab-btn" id="tabbtn_alerts" onclick="switchTab('alerts')">${LANG==="ar"?"تنبيهات":"Alerts"}</button>
        </div>
        <div id="tabcontent_live" class="tab-content active"></div>
        <div id="tabcontent_tools" class="tab-content"></div>
        <div id="tabcontent_alerts" class="tab-content"></div>
      `;
      switchTab('live');
    }

    function switchTab(tab) {
      ["live","tools","alerts"].forEach(t => {
        document.getElementById("tabbtn_"+t).classList.toggle("active", t === tab);
        document.getElementById("tabcontent_"+t).classList.toggle("active", t === tab);
      });

      if(tab === "live") {
        document.getElementById("tabcontent_live").innerHTML = `
          <div>
            <canvas id="liveChart" style="width:100%;max-width:1000px;height:180px;display:block;margin:auto"></canvas>
          </div>
          <div id="live-values" style="padding:14px 0 0 0;margin:0;display:flex;flex-direction:column;align-items:center;gap:5px;"></div>
          <div style="display:flex;justify-content:center;gap:12px;margin-bottom:18px;">
            <button class="action" onclick="updateLiveStats(true)">${LANG === "ar" ? "تحديث الآن" : "Refresh Now"}</button>
            <button class="action" onclick="showStatsArchive()">${LANG === "ar" ? "عرض سجل استهلاك البيانات الشهري" : "Show Monthly Usage Archive"}</button>
          </div>
          <div id="netstatus-block" style="margin:9px 0 16px 0;text-align:center"></div>
          <div style="margin:30px 0 0 0">
            <h3 style="font-size:1.1em;margin-bottom:7px">
              ${LANG==="ar" ? "معلومات النظام والهاردوير" : "System & Hardware Info"}
            </h3>
            <div id="system-info-block" style="font-family:monospace;font-size:1em"></div>
          </div>
          <div style="margin-top:10px;color:#888;font-size:0.92em" id="live-chart-note"></div>
        `;
        liveStatsHistory = [];

        if (window.liveChart && typeof window.liveChart.destroy === "function") {
          window.liveChart.destroy();
          window.liveChart = null;
        }

        setTimeout(() => initLiveChart(), 200);

        if (liveTimer) clearInterval(liveTimer);
        liveTimer = setInterval(updateLiveStats, 10000); // 10 seconds
        setTimeout(updateLiveStats, 120);
        setTimeout(updateSystemInfoBlock, 140);
        setTimeout(updateNetStatusBlock, 180);
      }
      else if(tab === "tools") {
        document.getElementById("tabcontent_tools").innerHTML = `
          <div style="padding:24px;max-width:700px;margin:auto">
            <div style="margin-bottom:20px">
              <button class="action" onclick="copyDebugInfo()">
                ${LANG === "ar" ? "نسخ بيانات التشخيص" : "Copy Debug Info"}
              </button>
              <span id="copy-debug-info-status" style="margin-left:12px;color:green"></span>
            </div>

            <div style="margin-bottom:20px">
              <button class="action" onclick="openUpdateModal()">
        ${LANG === "ar" ? "تثبيت/تحديث المكونات" : "Update/Reinstall Components"}
      </button>
              <span id="reinstall-all-status" style="margin-left:12px;color:blue"></span>
            </div>

            <div style="margin-bottom:20px">
        <h4 style="margin:8px 0 8px 0">${LANG === "ar" ? "إصدارات الخدمات" : "Client/Feeder Versions"}</h4>
        <div id="feeder-versions-block" style="font-family:monospace"></div>
        <button class="action" onclick="loadFeederVersions()" id="refresh-versions-btn">
          ${LANG==="ar" ? "تحديث إصدارات الخدمات" : "Refresh Versions"}
        </button>
      </div>

            <div style="margin-bottom:20px">
        <h4 style="margin:8px 0 8px 0">${LANG==="ar"?"حالة النظام والخدمات":"System/Service Status"}</h4>
        <div id="status-block" style="font-family:monospace"></div>
        <button class="action" onclick="loadStatusBlock()">${LANG==="ar"?"تحديث الحالة":"Refresh Status"}</button>
      </div>
          </div>
        `;
        setTimeout(()=>{
          loadFeederVersions();
          loadStatusBlock();
        },200);
      }
      else if(tab === "alerts") {
        document.getElementById("tabcontent_alerts").innerHTML = `
          <div style="padding:24px;">
            <h3>${LANG === "ar" ? "تنبيهات وتشخيص" : "Alerts & Diagnostics"}</h3>
            <div id="alerts-content"></div>
            <button class="action" onclick="loadAlerts()">${LANG === "ar" ? "تحديث" : "Refresh"}</button>
          </div>
        `;
        loadAlerts();
      }
    }

    function initLiveChart() {
      const ctx = document.getElementById('liveChart').getContext('2d');
      liveChart = new Chart(ctx, {
        type: 'line',
        data: {
          labels: [],
          datasets: [
            {
              label: LANG === "ar" ? "رسائل/ثانية" : "Messages/sec",
              data: [],
              borderWidth: 2,
              fill: false,
              borderColor: 'rgb(75, 192, 192)',
              tension: 0.1
            },
            {
              label: LANG === "ar" ? "عدد الطائرات" : "Aircraft",
              data: [],
              borderWidth: 2,
              fill: false,
              borderColor: 'rgb(255, 99, 132)',
              tension: 0.1
            },
            {
              label: LANG === "ar" ? "استهلاك البيانات (KB)" : "Data Usage (KB)",
              data: [],
              borderWidth: 2,
              fill: false,
              borderColor: 'rgb(54, 162, 235)',
              tension: 0.1
            },
          ]
        },
        options: {
          responsive: true,
          scales: {
            y: { beginAtZero: true },
            x: { title: { display: true, text: LANG === "ar" ? "الوقت" : "Time" } }
          }
        }
      });
    }

    function updateLiveStats(manual = false) {
      fetch('/api/stats/live?lang='+LANG).then(res => res.json()).then(js => {
        if (js && js.ok) {
          const d = js.live;
          document.getElementById("live-values").innerHTML = `
      <div style="display:flex;flex-wrap:wrap;justify-content:center;align-items:center;gap:22px 14px;font-size:1.05em;margin:18px 0 0 0">
        <div>${LANG === "ar" ? "عدد الرسائل/ثانية" : "Messages/sec"}: <b>${d.messages_per_sec ?? "-"}</b></div>
        <div>${LANG === "ar" ? "عدد الطائرات الآن" : "Aircraft now"}: <b>${d.aircraft_now ?? "-"}</b></div>
        <div>${LANG === "ar" ? "طائرات مع موقع" : "Aircraft with pos"}: <b>${d.aircraft_with_pos ?? "-"}</b></div>
        <div>${LANG === "ar" ? "طائرات بدون موقع" : "Aircraft w/o pos"}: <b>${d.aircraft_without_pos ?? "-"}</b></div>
        <div>${LANG === "ar" ? "أقصى نطاق (كم)" : "Max range (km)"}: <b>${d.max_range_km ?? "-"}</b></div>
        <div>${LANG === "ar" ? "متوسط الإشارة (dB)" : "Avg signal (dB)"}: <b>${d.signal_avg_db ?? "-"}</b></div>
        <div>${LANG === "ar" ? "الإنترفيس الشبكي" : "Network Interface"}: <b>${d.network_iface || "-"}</b></div>
        <div>${LANG === "ar" ? "البيانات المستقبلة خلال 10 ثواني (KB)" : "Data Received/10s (KB)"}: <b>${d.data_usage_rx_kb ?? "-"}</b></div>
        <div>${LANG === "ar" ? "البيانات المرسلة خلال 10 ثواني (KB)" : "Data Sent/10s (KB)"}: <b>${d.data_usage_tx_kb ?? "-"}</b></div>
        <div>${LANG === "ar" ? "إجمالي المستلم (MB)" : "Total Received (MB)"}: <b>${(d.rx_total/1024/1024).toFixed(2)}</b></div>
        <div>${LANG === "ar" ? "إجمالي المرسل (MB)" : "Total Sent (MB)"}: <b>${(d.tx_total/1024/1024).toFixed(2)}</b></div>
      </div>
    `;
          const timeLabel = new Date().toLocaleTimeString().slice(0, 8);
          liveStatsHistory.push({
            time: timeLabel,
            messages: d.messages_per_sec,
            aircraft: d.aircraft_now,
            data_kb: (Number(d.data_usage_rx_kb) || 0) + (Number(d.data_usage_tx_kb) || 0),
          });
          if (liveStatsHistory.length > 50) liveStatsHistory.shift();

          if (liveChart) {
            liveChart.data.labels = liveStatsHistory.map(x => x.time);
            liveChart.data.datasets[0].data = liveStatsHistory.map(x => x.messages);
            liveChart.data.datasets[1].data = liveStatsHistory.map(x => x.aircraft);
            liveChart.data.datasets[2].data = liveStatsHistory.map(x => x.data_kb);
            liveChart.update();
          }

          document.getElementById("live-chart-note").innerText = manual ? "Data refreshed manually." : "";
        } else {
          document.getElementById("live-values").innerHTML = `
            <div style="color:red;text-align:center;padding:20px;font-size:1.1em">
              ${LANG === "ar" ? "خطأ في جلب البيانات" : "Error:"} ${js.msg || "Unknown error"}
            </div>
          `;
          if (liveChart) {
            liveChart.data.labels = [];
            liveChart.data.datasets.forEach(ds => ds.data = []);
            liveChart.update();
          }
        }
      }).catch(e => {
        document.getElementById("live-values").innerHTML = `
          <div style="color:red;text-align:center;padding:20px;font-size:1.1em">
            ${LANG === "ar" ? "خطأ في الاتصال بالشبكة." : "Network error."}
          </div>
        `;
      });
    }

    function showStatsArchive() {
      fetch('/api/stats/archive')
        .then(res => res.json())
        .then(js => {
          if(js.ok) {
            let html = `<table border="1" style="width:100%;text-align:center">
              <tr><th>${LANG === "ar" ? "الشهر" : "Month"}</th>
              <th>${LANG === "ar" ? "البيانات المرسلة (MB)" : "Total Sent (MB)"}</th></tr>`;
            for(const [month, mb] of js.archive) {
              html += `<tr><td>${month}</td><td>${mb}</td></tr>`;
            }
            html += "</table>";
            showModal(`${LANG === "ar" ? "سجل استهلاك البيانات الشهري" : "Monthly Data Usage Archive"}`, html);
          } else {
            alert("Error loading archive!");
          }
        });
    }

    // --- Set Location Functions ---
    function renderSetLocation() {
      Promise.all([
        callAPI('/api/service/readsb/get-location', 'GET', null, null, true),
        callAPI('/api/service/wingbits/geosigner-info','GET',null,null,true)
      ]).then(([locRes, geoRes]) => {
        let currentLat = (locRes && locRes.lat) ? locRes.lat : (LANG === "ar" ? "غير محدد" : "Not set");
        let currentLon = (locRes && locRes.lon) ? locRes.lon : (LANG === "ar" ? "غير محدد" : "Not set");
        let geoLocation = geoRes && geoRes.result ? geoRes.result : (LANG === "ar" ? "لا يوجد" : "N/A");
        let html = `
          <h2 style="color:#219150">${LANG === "ar" ? "تعيين الموقع" : "Set Station Location"}</h2>
          <div class="result-block" style="color:#1a2940;font-size:1.04em;">
            <div><b>${LANG === "ar" ? "الموقع الحالي:" : "Current location:"}</b> ${currentLat}, ${currentLon}</div>
            <div><b>${LANG === "ar" ? "إحداثيات GeoSigner GPS:" : "GeoSigner GPS location:"}</b> ${geoLocation}</div>
          </div>
          <div style="margin:15px 0 8px 0;">
            ${LANG === "ar"
              ? "أدخل خط العرض والطول:"
              : "Enter latitude and longitude below:"}
          </div>
          <input id="lat" placeholder="${txt[LANG].location_lat}" style="margin-bottom:6px;" />
          <input id="lon" placeholder="${txt[LANG].location_lon}" style="margin-bottom:8px;" />
          <button class="action" onclick="setLocation()">${txt[LANG].apply}</button>
          <div id="result-location"></div>
        `;
        document.getElementById("main-content").innerHTML = html;
      });
    }

    function setLocation() {
      let lat = document.getElementById("lat").value, lon = document.getElementById("lon").value;
      if (!lat || !lon) return alert(LANG === "ar" ? "خط العرض والطول مطلوبان" : "Lat & Lon required");
      localStorage.setItem("cur_lat", lat);
      localStorage.setItem("cur_lon", lon);
      callAPI('/api/service/readsb/set-location', 'POST', {latitude: lat, longitude: lon}, 'result-location');
    }

    // --- Set Gain Functions ---
    function renderSetGain() {
      callAPI('/api/service/readsb/get-gain', 'GET', null, null, true).then((gainRes) => {
        let currentGain = gainRes && gainRes.gain ? gainRes.gain : (LANG === "ar" ? "غير محدد" : "Not set");
        let html = `
          <h2 style="color:#219150">${LANG === "ar" ? "ضبط الكسب" : "Set Gain"}</h2>
          <div class="result-block" style="color:#1a2940;font-size:1.04em;">
            <div><b>${LANG === "ar" ? "الكسب الحالي:" : "Current Gain:"}</b> ${currentGain}</div>
          </div>
          <div style="margin:15px 0 8px 0;">
            ${LANG === "ar"
              ? "يمكنك إدخال auto أو auto-verbose أو رقم مثل 28 أو متقدم مثل auto-verbose,12,-24,-6,35"
              : "You can enter: auto, auto-verbose, a number like 28, or advanced: auto-verbose,12,-24,-6,35"}
          </div>
          <input id="gain" type="text" placeholder="${txt[LANG].gain_value} (e.g. auto, auto-verbose, 28, auto-verbose,12,-24,-6,35)" />
          <button class="action" onclick="setGain()">${txt[LANG].apply}</button>
          <div id="result-gain"></div>
        `;
        document.getElementById("main-content").innerHTML = html;
      });
    }

    function setGain() {
      let gain = document.getElementById("gain").value;
      if (!gain) return alert(LANG === "ar" ? "قيمة الكسب مطلوبة" : "Gain required");
      callAPI('/api/service/readsb/set-gain', 'POST', {gain: gain}, 'result-gain');
    }

    // --- Set Station ID Functions ---
    function renderSetStationID() {
      callAPI('/api/service/wingbits/get-station-id', 'GET', null, null, true).then((res) => {
        let curID = (res && res.station_id) ? res.station_id : (LANG === "ar" ? "غير محدد" : "Not set");
        let html = `
          <h2 style="color:#219150">${LANG === "ar" ? "معرف المحطة" : "Station ID"}</h2>
          <div class="result-block" style="color:#1a2940;font-size:1.04em;">
            <div><b>${LANG === "ar" ? "المعرف الحالي:" : "Current ID:"}</b> ${curID}</div>
          </div>
          <div style="margin:15px 0 8px 0;">
            ${LANG === "ar"
              ? "أدخل معرف محطة جديد (مثال: smiling-blissful-apple أو 18 رمز سداسي عشرى)"
              : "Enter a new station ID (e.g. smiling-blissful-apple or 18 hex chars)"}
          </div>
          <input id="station_id" type="text" placeholder="${LANG === 'ar' ? 'معرف جديد...' : 'New station ID...'}" style="margin-bottom:8px;" />
          <button class="action" onclick="setStationID()">${txt[LANG].apply}</button>
          <div id="result-stationid"></div>
        `;
        document.getElementById("main-content").innerHTML = html;
      });
    }

    function setStationID() {
      let id = document.getElementById("station_id").value.trim();
      if (!id) return alert(LANG === "ar" ? "يرجى إدخال المعرف" : "Please enter the station ID");
      callAPI('/api/service/wingbits/set-station-id', 'POST', {station_id: id}, 'result-stationid');
    }

    // --- QOL Options Functions ---
    function renderGraphsColorscheme() {
      let html = `
        <h2 style="color:#219150">${LANG === "ar" ? "وضع الرسوم البيانية" : "graphs1090 mode"}</h2>
        <div style="margin:20px 0;">${
          LANG === "ar"
            ? "اختر وضع العرض لصفحة الرسوم البيانية (graphs1090):"
            : "Which mode do you prefer for graphs1090 page/chart display?"
        }</div>
        <div style="display:flex;gap:20px;">
          <button class="action" onclick="setColorscheme('dark')">${LANG === "ar" ? "غامق" : "Dark"}</button>
          <button class="action" onclick="setColorscheme('default')">${LANG === "ar" ? "فاتح" : "Light"}</button>
        </div>
        <div id="result-graphs1090"></div>
      `;
      document.getElementById("main-content").innerHTML = html;
    }

    function setColorscheme(color) {
      callAPI('/api/service/graphs1090/colorscheme', 'POST', {color: color}, 'result-graphs1090');
    }

    function renderTarRoutes() {
      let html = `
        <h2 style="color:#219150">${LANG === "ar" ? "مسارات الرحلات" : "Route Info"}</h2>
        <div style="margin:20px 0;">
          ${LANG === "ar" ? "تفعيل أو تعطيل معلومات مسار الرحلات في tar1090:" : "Enable or disable tar1090 route info:"}
        </div>
        <button class="action" onclick="toggleRouteInfo(true)">${LANG === "ar" ? "تفعيل" : "Enable"}</button>
        <button class="action" onclick="toggleRouteInfo(false)">${LANG === "ar" ? "تعطيل" : "Disable"}</button>
        <div id="result-tar1090"></div>
      `;
      document.getElementById("main-content").innerHTML = html;
    }
    function toggleRouteInfo(enable) {
      if (typeof enable === "boolean") {
        callAPI('/api/service/tar1090/route-info', 'POST', {enable: enable}, 'result-tar1090');
        return;
      }
      let ask = confirm(LANG === "ar" ? "تفعيل معلومات المسار؟" : "Enable route info?");
      callAPI('/api/service/tar1090/route-info', 'POST', {enable: ask}, 'result-tar1090');
    }

    function renderTarHeatmaps() {
      let html = `
        <h2 style="color:#219150">${LANG === "ar" ? "خرائط الحرارة" : "Heatmaps"}</h2>
        <div style="margin:20px 0;">
          ${LANG === "ar"
            ? "ميزة تجريبية: تفعيل أو تعطيل جمع بيانات خرائط الحرارة (heatmap) في readsb (قد تحتاج سكربت إضافي)."
            : "Experimental: Enable/disable readsb heatmap data (may need extra script support)."}
        </div>
        <div style="margin:16px 0;">
          <button class="action" onclick="enableHeatmap()">${LANG === "ar" ? "تفعيل" : "Enable"}</button>
          <button class="action" onclick="disableHeatmap()">${LANG === "ar" ? "تعطيل" : "Disable"}</button>
        </div>
    	<div id="result-heatmap"></div>
      `;
      document.getElementById("main-content").innerHTML = html;
    }
    function enableHeatmap() {
      callAPI('/api/service/readsb/heatmap', 'POST', {enable: true}, 'result-heatmap');
    }
    function disableHeatmap() {
      callAPI('/api/service/readsb/heatmap', 'POST', {enable: false}, 'result-heatmap');
    }

    // --- URLs Functions ---
    function renderURLs() {
      document.getElementById("main-content").innerHTML = `<h2>Station URLs</h2>
        <div id="urls-list" style="margin-top:12px;">Loading...</div>`;
      fetch('/api/service/urls')
        .then(res => res.json())
        .then(js => {
          if (js && js.urls && js.urls.length > 0) {
            let html = js.urls.map(
              url => `<div style="margin-bottom:9px;">
                <b>${url.title}:</b><br>
                <a href="${url.url}" target="_blank">${url.url}</a>
              </div>`
            ).join('');
            document.getElementById("urls-list").innerHTML = html;
          } else {
            document.getElementById("urls-list").innerHTML = `<span style="color:#c00">No URLs found.</span>`;
          }
        }).catch(err => {
          document.getElementById("urls-list").innerHTML = `<span style="color:#c00">${err.message}</span>`;
        });
    }

    // --- Support Menu Functions ---
    function renderDebug() {
      document.getElementById("main-content").innerHTML = `<h2>${LANG === "ar" ? "نتائج التصحيح" : "Debugging Output"}</h2>
        <div id="debug-block">Loading...</div>`;
      callAPI('/api/service/wingbits/debug', 'GET', null, 'debug-block');
    }

    function renderAllLogs() {
      document.getElementById("main-content").innerHTML = `<h2>${LANG === "ar" ? "جميع السجلات الحديثة" : "All Recent Logs"}</h2>
        <div id="result-alllogs">Loading...</div>`;
      callAPI('/api/service/wingbits/logs', 'GET', null, 'result-alllogs');
      callAPI('/api/service/readsb/logs', 'GET', null, 'result-alllogs');
    }

    function renderLastInstallLog() {
      document.getElementById("main-content").innerHTML = `<h2>${LANG === "ar" ? "سجل التثبيت الأخير" : "Last Install Log"}</h2>
        <div id="result-installlog">Loading...</div>`;
      callAPI('/api/service/wingbits/last-install-log', 'GET', null, 'result-installlog');
    }

    function openUpdateModal() {
      let old = document.getElementById('update-modal');
      if (old) old.remove();

      const modal = document.createElement('div');
      modal.id = 'update-modal';
      modal.style = "display:flex;position:fixed;left:0;top:0;width:100vw;height:100vh;z-index:3000;background:rgba(0,0,0,0.33);justify-content:center;align-items:center;";
      modal.innerHTML = `
        <div style="background:#fff;max-width:370px;width:95vw;padding:26px 20px 20px 20px;border-radius:12px;box-shadow:0 3px 18px #0003;position:relative">
          <h3 style="margin-bottom:16px;text-align:${LANG==='ar'?'right':'left'}">${LANG==="ar"?"تحديث أو إعادة تثبيت المكونات":"Update/Reinstall Components"}</h3>
          <div>
            <div style="display:flex;align-items:center;gap:8px;margin-bottom:12px;direction:ltr;">
              <input type="checkbox" id="comp_wingbits" checked style="width:18px;height:18px;">
              <label for="comp_wingbits" style="font-size:1.12em;min-width:110px;cursor:pointer">${LANG==="ar"?"عميل Wingbits":"Wingbits Client"}</label>
            </div>
            <div style="display:flex;align-items:center;gap:8px;margin-bottom:12px;direction:ltr;">
              <input type="checkbox" id="comp_readsb" checked style="width:18px;height:18px;">
              <label for="comp_readsb" style="font-size:1.12em;min-width:110px;cursor:pointer">readsb</label>
            </div>
            <div style="display:flex;align-items:center;gap:8px;margin-bottom:12px;direction:ltr;">
              <input type="checkbox" id="comp_tar1090" checked style="width:18px;height:18px;">
              <label for="comp_tar1090" style="font-size:1.12em;min-width:110px;cursor:pointer">tar1090</label>
            </div>
            <div style="display:flex;align-items:center;gap:8px;margin-bottom:12px;direction:ltr;">
              <input type="checkbox" id="comp_panel" style="width:18px;height:18px;">
              <label for="comp_panel" style="font-size:1.12em;min-width:110px;cursor:pointer">${LANG==="ar"?"لوحة التحكم":"Web Panel"}</label>
            </div>
            <div style="display:flex;align-items:center;gap:8px;margin-bottom:8px;direction:ltr;">
              <input type="checkbox" id="comp_deps" style="width:18px;height:18px;">
              <label for="comp_deps" style="font-size:1.12em;min-width:110px;cursor:pointer">${LANG==="ar"?"الاعتماديات (python, rtl-sdr)":"Dependencies (python, rtl-sdr)"}</label>
            </div>
          </div>
          <div id="update-modal-status" style="margin:14px 0 8px 0; color:#1560db;"></div>
          <div style="text-align:right;margin-top:12px">
            <button onclick="doUpdateReinstall()" style="padding:6px 18px">${LANG==="ar"?"تأكيد":"Confirm"}</button>
            <button onclick="closeUpdateModal()" style="padding:6px 18px">${LANG==="ar"?"إغلاق":"Close"}</button>
          </div>
        </div>
      `;
      document.body.appendChild(modal);
    }

    function closeUpdateModal() {
      let modal = document.getElementById('update-modal');
      if (modal) modal.remove();
    }

    function doUpdateReinstall() {
      const comps = [];
      if(document.getElementById("comp_wingbits").checked) comps.push("wingbits");
      if(document.getElementById("comp_readsb").checked) comps.push("readsb");
      if(document.getElementById("comp_tar1090").checked) comps.push("tar1090");
      if(document.getElementById("comp_panel").checked) comps.push("panel");
      if(document.getElementById("comp_deps").checked) comps.push("deps");

      if(comps.length === 0) {
        document.getElementById("update-modal-status").style.color = "red";
        document.getElementById("update-modal-status").innerText = LANG==="ar"?"اختر مكون واحد على الأقل!":"Please select at least one component!";
        return;
      }
      document.getElementById("update-modal-status").style.color = "#1560db";
      document.getElementById("update-modal-status").innerText = LANG==="ar"?"جاري التنفيذ...":"Running, please wait...";
      fetch('/api/update/reinstall', {
        method: "POST",
        headers: {'Content-Type': 'application/json'},
        body: JSON.stringify({components: comps})
      }).then(res=>res.json()).then(js=>{
        if(js.ok) {
          document.getElementById("update-modal-status").style.color = "green";
          document.getElementById("update-modal-status").innerText = (js.msg || (LANG==="ar"?"تم التنفيذ!":"Done!")) + "\n" + (js.detail||"");
        } else {
          document.getElementById("update-modal-status").style.color = "red";
          document.getElementById("update-modal-status").innerText = (js.msg||"Unknown error");
        }
      }).catch(()=>{
        document.getElementById("update-modal-status").style.color = "red";
        document.getElementById("update-modal-status").innerText = LANG==="ar"?"خطأ في الاتصال!":"Network error!";
      });
    }

    function loadFeederVersions() {
      console.log("loadFeederVersions called");
      const block = document.getElementById("feeder-versions-block");
      block.innerHTML = (LANG === "ar" ? "جاري التحميل..." : "Loading...");
      fetch('/api/feeder/versions').then(res => res.json()).then(js => {
        if (js && js.ok && js.versions) {
          const v = js.versions;
          block.innerHTML = `
            <div style="font-size:1em">
              <b>Wingbits:</b> ${v.wingbits || '-'}<br>
              <b>readsb:</b> ${v.readsb || '-'}<br>
              <b>tar1090:</b> ${v.tar1090 || '-'}<br>
              <b>${LANG === "ar" ? "لوحة التحكم" : "Web Panel"}:</b> ${v.panel || '-'}<br>
            </div>
            <div style="color:#666;font-size:0.92em;margin-top:4px">
              ${LANG === "ar" ? "آخر تحديث:" : "Checked at:"} ${js.checked_at || "-"}
            </div>
          `;
        } else {
          block.innerHTML = `<span style="color:red">${(js && js.msg) ? js.msg : (LANG === "ar" ? "تعذر جلب الإصدارات" : "Failed to load versions")}</span>`;
        }
      }).catch(e => {
        block.innerHTML = `<span style="color:red">${LANG === "ar" ? "خطأ في الشبكة!" : "Network error!"}</span>`;
      });
    }

    function loadStatusBlock() {
      const block = document.getElementById("status-block");
      block.innerHTML = (LANG === "ar" ? "جاري الفحص..." : "Checking...");
      fetch('/api/status/check').then(res=>res.json()).then(js=>{
        if(js && js.ok && js.status) {
          const s = js.status;
          let html = `
            <div style="display:grid;grid-template-columns:1fr 1fr;gap:8px 22px;font-size:1em;margin-bottom:12px">
              <div>${LANG==="ar"?"الإنترنت":"Internet"}</div>
              <div>${s.internet?'<span style="color:green">&#10004;</span>':'<span style="color:red">&#10008;</span>'}</div>
              <div>Wingbits</div>
              <div>${s.wingbits?'<span style="color:green">&#10004;</span>':'<span style="color:red">&#10008;</span>'}</div>
              <div>readsb</div>
              <div>${s.readsb?'<span style="color:green">&#10004;</span>':'<span style="color:red">&#10008;</span>'}</div>
              <div>tar1090</div>
              <div>${s.tar1090?'<span style="color:green">&#10004;</span>':'<span style="color:red">&#10008;</span>'}</div>
            </div>
          `;

          if(s.wb_details) {
            let lines = s.wb_details.split('\n')
              .filter(line => line.trim() && !/^Wingbits version/i.test(line));
            html += `<div style="background:#f7f7fa;padding:10px 16px;border-radius:7px;border:1px solid #eee;font-size:1em">`;
            lines.forEach(line => {
              let color = line.includes("OK") || line.includes("✓") ? "green"
                : (line.includes("fail") || line.includes("not") || line.includes("Error") || line.includes("✗")) ? "red" : "#333";
              html += `<div style="color:${color}">${line.replace("✓", "&#10004;").replace("✗", "&#10008;")}</div>`;
            });
            html += `</div>`;
          }
          block.innerHTML = html;
        } else {
          block.innerHTML = `<div style="color:red">${LANG === "ar" ? "فشل جلب الحالة" : "Failed to fetch status"}</div>`;
        }
      }).catch(e=>{
        block.innerHTML = `<div style="color:red">${LANG === "ar" ? "خطأ في الاتصال" : "Network error"}</div>`;
      });
    }

    function loadAlerts() {
      const block = document.getElementById("alerts-content");
      block.innerHTML = `<div style="padding:32px;text-align:center;color:#888;font-size:1.1em">${LANG==="ar"?"جاري البحث عن تنبيهات...":"Checking for alerts..."}</div>`;
      fetch('/api/alerts?lang='+LANG).then(res=>res.json()).then(js=>{
        if(js && js.ok) {
          if(js.alerts && js.alerts.length) {
            block.innerHTML = js.alerts.map(a=>`
              <div style="background:#fff3f3;border:1px solid #e7b1b1;color:#c70a0a;border-radius:7px;margin-bottom:12px;padding:12px 17px;font-size:1.1em;">
                <span style="font-family:monospace">${a}</span>
              </div>
            `).join('');
          } else {
            block.innerHTML = `<div style="padding:28px;text-align:center;color:green;font-size:1.13em">${LANG==="ar"?"لا توجد أخطاء أو تحذيرات نشطة":"No active alerts."}</div>`;
          }
        } else {
          block.innerHTML = `<div style="padding:20px;color:red">${LANG==="ar"?"فشل تحميل التنبيهات":"Failed to load alerts."}</div>`;
        }
      }).catch(e=>{
        block.innerHTML = `<div style="padding:20px;color:red">${LANG==="ar"?"خطأ بالشبكة":"Network error."}</div>`;
      });
    }

    function updateSystemInfoBlock() {
      fetch('/api/system/info').then(res=>res.json()).then(js=>{
        if(js && js.ok) {
          const d = js.info;
          document.getElementById("system-info-block").innerHTML = `
          <div style="display:grid;grid-template-columns:1fr 1fr;gap:0.3em 1.7em">
            <div>${LANG==="ar" ? "اسم المضيف" : "Hostname"}</div><div><b>${d.hostname}</b></div>
            <div>${LANG==="ar" ? "النظام" : "OS"}</div><div><b>${d.os}</b></div>
            <div>${LANG==="ar" ? "المعالج" : "CPU"}</div><div><b>${d.cpu}</b></div>
            <div>${LANG==="ar" ? "عدد الأنوية" : "Cores"}</div><div><b>${d.cores}</b></div>
            <div>${LANG==="ar" ? "المعمارية" : "Arch"}</div><div><b>${d.arch}</b></div>
            <div>${LANG==="ar" ? "متوسط التحميل" : "Load Avg"}</div><div><b>${d.load_avg ? d.load_avg.map(x=>x.toFixed(2)).join(' / ') : "-"}</b></div>
            <div>${LANG==="ar" ? "الرام الكلي (MB)" : "Total RAM (MB)"}</div><div><b>${d.ram_total_mb}</b></div>
            <div>${LANG==="ar" ? "الرام المتاح (MB)" : "Free RAM (MB)"}</div><div><b>${d.ram_free_mb}</b></div>
            <div>${LANG==="ar" ? "الهارد الكلي (GB)" : "Disk total (GB)"}</div><div><b>${d.disk_total_gb}</b></div>
            <div>${LANG==="ar" ? "الهارد المتاح (GB)" : "Disk free (GB)"}</div><div><b>${d.disk_free_gb}</b></div>
            <div>${LANG==="ar" ? "مدة التشغيل (ساعة)" : "Uptime (hours)"}</div><div><b>${d.uptime_hr}</b></div>
            <div>${LANG==="ar" ? "درجة حرارة المعالج" : "CPU Temp (°C)"}</div><div><b>${d.cpu_temp ?? "-"}</b></div>
            <div>${LANG==="ar" ? "حالة SDR" : "SDR Dongle"}</div>
            <div><b>${
              d.sdr_status === "connected"
              ? (LANG === "ar" ? "متصل" : "Connected")
              : (LANG === "ar" ? "غير متصل" : "Not Connected")
            }</b></div>
    		<div><b>
    		</b></div>
    		<div><b>
    		</b></div>
          </div>
          `;
        } else {
          document.getElementById("system-info-block").innerHTML = `<div style="color:red">Error: ${js.msg || "unknown error"}</div>`;
        }
      });
    }

    function updateNetStatusBlock() {
      fetch('/api/netstatus').then(res=>res.json()).then(js=>{
        if(js && js.ok) {
          const d = js.net;
          let txtConn = (LANG==="ar" ? 
            (d.online ? "متصل بالإنترنت" : "غير متصل بالإنترنت") :
            (d.online ? "Internet: Connected" : "Internet: Not connected"));
          let txtSrv = (LANG==="ar" ?
            (d.server_ok ? "متصل بسيرفر Wingbits" : "تعذر الاتصال بسيرفر Wingbits") :
            (d.server_ok ? "Wingbits server: Connected" : "Wingbits server: Not reachable"));
          let txtLast = d.last_sync ?
            ((LANG==="ar" ? "آخر مزامنة:" : "Last Sync:") + " <b>" + d.last_sync + "</b>") : "";

          document.getElementById("netstatus-block").innerHTML = `
            <div style="color:${d.online ? "#197b1f":"#b80c09"};font-weight:bold;margin-bottom:2px">${txtConn}</div>
            <div style="color:${d.server_ok ? "#1355c2":"#bb0d27"};font-weight:bold;margin-bottom:2px">${txtSrv}</div>
            <div style="color:#5c5c5c;font-size:0.98em">${txtLast}</div>
          `;
        } else {
          document.getElementById("netstatus-block").innerHTML = `<span style="color:red">${LANG==="ar"?"خطأ":"Error"}</span>`;
        }
      }).catch(e=>{
        document.getElementById("netstatus-block").innerHTML = `<span style="color:red">${LANG==="ar"?"خطأ بالشبكة":"Network Error"}</span>`;
      });
    }

    function copyDebugInfo() {
      const statusEl = document.getElementById("copy-debug-info-status");
      statusEl.style.color = "black";
      statusEl.innerText = LANG === "ar" ? "جاري التجميع..." : "Gathering info...";
      fetch('/api/debug/info').then(res => {
        if (!res.ok) throw new Error("Network response was not ok");
        return res.json();
      }).then(js => {
        if(js && js.ok && js.info) {
          const d = js.info;
          let infoText =
`Station Debug Info
----------------------------------------
ID: ${d.station_id || "-"}
Host: ${d.hostname || "-"}
IP: ${d.ip || "-"}
Location: ${d.lat || "-"},${d.lon || "-"}
Wingbits: ${d.wingbits_ver || "-"}
readsb: ${d.readsb_ver || "-"}
tar1090: ${d.tar1090_ver || "-"}
Recent Logs:
${d.logs || "-"}
`;
          if (navigator.clipboard && navigator.clipboard.writeText) {
            navigator.clipboard.writeText(infoText).then(() => {
              statusEl.style.color = "green";
              statusEl.innerText = LANG === "ar" ? "تم نسخ بيانات التشخيص!" : "Debug info copied!";
              setTimeout(() => statusEl.innerText = "", 3000);
            }).catch(err => {
              statusEl.style.color = "red";
              statusEl.innerText = (LANG === "ar" ? "فشل النسخ: " : "Copy failed: ") + err;
            });
          } else {
            let textarea = document.createElement('textarea');
            textarea.value = infoText;
            document.body.appendChild(textarea);
            textarea.select();
            try {
              document.execCommand('copy');
              statusEl.style.color = "green";
              statusEl.innerText = LANG === "ar" ? "تم النسخ يدويًا!" : "Copied manually!";
            } catch (e) {
              statusEl.style.color = "red";
              statusEl.innerText = LANG === "ar" ? "فشل النسخ اليدوي!" : "Manual copy failed!";
            }
            document.body.removeChild(textarea);
          }
        } else {
          statusEl.style.color = "red";
          statusEl.innerText = (js && js.msg) ? js.msg : (LANG === "ar" ? "خطأ غير معروف!" : "Unknown error!");
        }
      }).catch(err => {
        statusEl.style.color = "red";
        statusEl.innerText = (LANG === "ar" ? "Network error: " : "Network error: ") + err;
      });
    }

    // --- Restart / Shutdown Functions ---
    function renderPower() {
      let html = `
        <h2>${LANG === "ar" ? "إعادة تشغيل الخدمات / الجهاز" : "Restart / Shutdown"}</h2>
        <div class="result-block" style="margin-bottom:18px;">
          <b>wingbits restart</b><br>
          Restart the wingbits service<br>
          <button class="action" onclick="callAPI('/api/service/wingbits/restart','POST',null,'result-wingbits-restart')">${LANG === "ar" ? "إعادة تشغيل" : "Restart"}</button>
          <div id="result-wingbits-restart"></div>
          <hr/>
          <b>readsb restart</b><br>
          Restart the readsb service<br>
          <button class="action" onclick="callAPI('/api/service/readsb/restart','POST',null,'result-readsb-restart')">${LANG === "ar" ? "إعادة تشغيل" : "Restart"}</button>
          <div id="result-readsb-restart"></div>
          <hr/>
          <b>tar1090 restart</b><br>
          Restart tar1090 service<br>
          <button class="action" onclick="callAPI('/api/service/tar1090/restart','POST',null,'result-tar1090-restart')">${LANG === "ar" ? "إعادة تشغيل" : "Restart"}</button>
          <div id="result-tar1090-restart"></div>
          <hr/>
          <b>Device restart</b><br>
          Restart the Wingbits Station<br>
          <button class="action" style="background:#d35400" onclick="confirmReboot()">${LANG === "ar" ? "إعادة تشغيل الجهاز" : "Restart Device"}</button>
          <div id="result-pi-reboot"></div>
          <hr/>
          <b>SHUTDOWN device</b><br>
          Shutdown the Wingbits Station<br>
          <button class="action" style="background:#e74c3c" onclick="confirmShutdown()">${LANG === "ar" ? "إيقاف التشغيل" : "Shutdown Device"}</button>
          <div id="result-pi-shutdown"></div>
        </div>
      `;
      document.getElementById("main-content").innerHTML = html;
    }

    function confirmReboot() {
      if(confirm(LANG === "ar" ? "سيتم إعادة تشغيل الجهاز!" : "Device will reboot!")) {
        callAPI('/api/system/reboot', 'POST', null, 'result-pi-reboot');
      }
    }
    function confirmShutdown() {
      if(confirm(LANG === "ar" ? "سيتم إيقاف تشغيل الجهاز!" : "Device will shutdown!")) {
        callAPI('/api/system/shutdown', 'POST', null, 'result-pi-shutdown');
      }
    }

    // --- Help / About Page Functions ---
    function renderHelp() {
      let html = `<h2>${txt[LANG].about}</h2>
        <div style="margin:10px 0;">
          <b>Wingbits Station Web Config</b><br/>
          ${LANG === "ar" ? "لوحة تحكم مبنية باستخدام بايثون وHTML لسهولة إدارة محطة التتبع." : "A simple Python+HTML dashboard for easy station management."}
          <br/><br/>
          </div>
        <div style="margin:14px 0 0 0;font-size:0.98em;color:#888;">by Said Albalushi</div>
        <div id="result-block"></div>
      `;
      document.getElementById("main-content").innerHTML = html;
    }

    // --- General Utility Functions ---
    function showModal(title, content) {
      let m = document.createElement("div");
      m.style = "position:fixed;left:0;top:0;width:100vw;height:100vh;z-index:999;background:rgba(0,0,0,0.4);display:flex;align-items:center;justify-content:center";
      m.innerHTML = `<div style="background:#fff;padding:16px 22px;min-width:280px;max-width:96vw;max-height:85vh;overflow:auto;border-radius:12px;box-shadow:0 6px 32px #0003">
        <div style="font-weight:bold;font-size:1.2em;margin-bottom:10px">${title}</div>
        ${content}
        <div style="text-align:center;margin-top:12px"><button onclick="this.parentNode.parentNode.parentNode.remove()">OK</button></div>
      </div>`;
      document.body.appendChild(m);
    }

    function escapeHTML(txt) {
      return (""+txt).replace(/[<>&"]/g, function(c) {
        return {'<':'&lt;','>':'&gt;','&':'&amp;','"':'&quot;'}[c];
      });
    }

    // --- API Communication with Backend ---
    async function callAPI(url, method = 'GET', data = null, resultId = "result-block", returnPromise = false) {
      if(resultId && document.getElementById(resultId)) {
        document.getElementById(resultId).innerHTML = `<span style="color:#888">${txt[LANG].please_wait}</span>`;
      }
      let opts = {method: method};
      opts.headers = {'Content-Type': 'application/json'};
      if(data) opts.body = JSON.stringify(data);
      try {
        let q = url.includes("?") ? "&" : "?";
        let res = await fetch(url + q + "lang=" + LANG, opts);
        let js = await res.json();

        let result = js.result || js.msg || js.ok || "";
        let desc = js.desc ? `<div class="desc-block">${js.desc}</div>` : "";
        if(resultId && document.getElementById(resultId)) {
          document.getElementById(resultId).innerHTML =
            desc + (result ? `<div class="result-block">${escapeHTML(result)}</div>` : "");
        }
        if (returnPromise) return js;
      } catch (e) {
        if(resultId && document.getElementById(resultId)) {
          document.getElementById(resultId).innerHTML = `<div style="color:#e74c3c">${e.message}</div>`;
        }
        if (returnPromise) return null;
      }
    }

    // --- Page Initialization ---
    window.onload = function() {
      setLang(LANG);
      renderMenuPage('live_stats');
    }
  </script>
</body>
</html>
EOF

echo "Frontend files written."
echo ""