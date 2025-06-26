#!/bin/bash

# Write the Flask backend application (app.py)
# This script generates the Python Flask application file for the web panel.

set -e

echo "Writing backend files..."

INSTALL_DIR="/opt/wingbits-station-web"
BACKEND_DIR="$INSTALL_DIR/backend"

cat > "$BACKEND_DIR/app.py" << 'EOF'
import os
import subprocess
import re
import glob
import time
import json
import platform
import socket
import psutil
from flask import jsonify
from datetime import datetime
from flask import Flask, request, jsonify, send_from_directory
from flask_cors import CORS # Import CORS

app = Flask(__name__)
CORS(app) # Enable CORS for all routes

# ---------- Multilingual descriptions support ----------
DESCRIPTIONS = {
    "readsb_status": {
        "ar": "عرض حالة خدمة readsb.",
        "en": "Show the status of the readsb service."
    },
    "readsb_restart": {
        "ar": "إعادة تشغيل خدمة readsb.",
        "en": "Restart the readsb service."
    },
    "readsb_logs": {
        "ar": "عرض آخر 50 سطر من سجلات readsb.",
        "en": "Show last 50 lines of readsb logs."
    },
    "readsb_set_location": {
        "ar": "تغيير موقع المحطة (خط الطول والعرض).",
        "en": "Set station location (latitude, longitude)."
    },
    "readsb_set_gain": {
        "ar": "ضبط كسب الاستقبال (Gain) للـ readsb.",
        "en": "Set gain value for readsb."
    },
    "wingbits_status": {
        "ar": "عرض حالة خدمة wingbits.",
        "en": "Show the status of the wingbits service."
    },
    "wingbits_restart": {
        "ar": "إعادة تشغيل خدمة wingbits.",
        "en": "Restart the wingbits service."
    },
    "wingbits_logs": {
        "ar": "عرض آخر 2000 سطر من سجلات wingbits.",
        "en": "Show last 2000 lines of wingbits logs."
    },
    "wingbits_update_client": {
        "ar": "تحديث عميل Wingbits.",
        "en": "Update Wingbits client."
    },
    "wingbits_geosigner_info": {
        "ar": "عرض معلومات GeoSigner.",
        "en": "Show GeoSigner information."
    },
    "wingbits_version": {
        "ar": "عرض إصدار Wingbits.",
        "en": "Show Wingbits version."
    },
    "tar1090_restart": {
        "ar": "إعادة تشغيل خدمة tar1090.",
        "en": "Restart tar1090 service."
    },
    "tar1090_route_info": {
        "ar": "تفعيل أو تعطيل معلومات مسار الرحلة في tar1090.",
        "en": "Enable/Disable route info in tar1090."
    },
    "graphs1090_restart": {
        "ar": "إعادة تشغيل خدمة graphs1090.",
        "en": "Restart graphs1090 service."
    },
    "graphs1090_colorscheme": {
        "ar": "تغيير مخطط الألوان للـ graphs1090.",
        "en": "Set color scheme for graphs1090."
    },
    "pi_restart": {
        "ar": "إعادة تشغيل الجهاز بالكامل.",
        "en": "Reboot the device."
    },
    "pi_shutdown": {
        "ar": "إيقاف تشغيل الجهاز بالكامل.",
        "en": "Shutdown the device."
    },
    "wingbits_debug": {
        "ar": "عرض معلومات تصحيح أخطاء Wingbits.",
        "en": "Show Wingbits debug information."
    }
}

def lang_desc(key, lang='en'):
    return DESCRIPTIONS.get(key, {}).get(lang, '')

def run_shell(cmd):
    try:
        output = subprocess.check_output(cmd, shell=True, stderr=subprocess.STDOUT, encoding='utf-8')
        return output.strip()
    except subprocess.CalledProcessError as e:
        return e.output.strip()

# Global variable to hold last reading
LAST_NET_STATS = {"time": 0, "iface": None, "rx_bytes": 0, "tx_bytes": 0}
ARCHIVE_PATH = "/opt/wingbits-station-web/live_stats_archive.json"
STATS_META_PATH = "/opt/wingbits-station-web/live_stats_meta.json"

def load_json(path):
    if os.path.exists(path):
        with open(path) as f:
            try:
                return json.load(f)
            except json.JSONDecodeError:
                return {}
    return {}

def save_json(path, data):
    with open(path, "w") as f:
        json.dump(data, f)

# ====== API Endpoints by Service/Function ======

# ---------- Live Stats / Dashboard ----------
@app.route('/api/stats/live', methods=['GET'])
def live_stats():
    stats_path = '/run/readsb/stats.json'
    if not os.path.exists(stats_path):
        stats_path = '/var/run/readsb/stats.json'

    # Monthly Archiving
    now = time.time()
    now_dt = datetime.now()
    current_month = now_dt.strftime("%Y-%m")
    # Retrieve last stored meta
    stats_meta = load_json(STATS_META_PATH)
    last_month = stats_meta.get("current_month", current_month)
    month_start_tx = stats_meta.get("month_start_tx", 0)

    # Interface detection
    def get_main_iface_bytes():
        max_bytes = 0
        main_iface = None
        rx_bytes = tx_bytes = 0
        try:
            with open('/proc/net/dev') as f:
                lines = f.readlines()[2:]
                for line in lines:
                    parts = line.strip().split()
                    if len(parts) < 17: continue
                    iface = parts[0].strip(':')
                    if iface == "lo": continue
                    _rx = int(parts[1])
                    _tx = int(parts[9])
                    if _rx + _tx > max_bytes:
                        max_bytes = _rx + _tx
                        rx_bytes = _rx
                        tx_bytes = _tx
                        main_iface = iface
        except FileNotFoundError:
            pass # Handle case where /proc/net/dev might not exist or be readable
        return main_iface, rx_bytes, tx_bytes

    iface, rx_bytes, tx_bytes = get_main_iface_bytes()

    # If month changes, archive previous month and reset counter for new month
    archive = load_json(ARCHIVE_PATH)
    if current_month != last_month:
        month_total_mb = round((tx_bytes - month_start_tx) / 1024 / 1024, 2)
        archive[last_month] = month_total_mb
        save_json(ARCHIVE_PATH, archive)
        month_start_tx = tx_bytes

    # Update meta
    stats_meta = {
        "current_month": current_month,
        "month_start_tx": month_start_tx
    }
    save_json(STATS_META_PATH, stats_meta)

    # Calculate current month's usage
    total_sent_month = round((tx_bytes - month_start_tx) / 1024 / 1024, 2)

    # Rest of the data as usual
    stats_data = {}
    if os.path.exists(stats_path):
        with open(stats_path) as f:
            stats_data = json.load(f)
    messages_per_sec = 0
    if "last1min" in stats_data:
        msgs_1min = stats_data["last1min"].get("messages_valid", 0)
        messages_per_sec = round(msgs_1min / 60, 1)
    aircraft_with_pos = stats_data.get("aircraft_with_pos", 0)
    aircraft_without_pos = stats_data.get("aircraft_without_pos", 0)
    total_aircraft = aircraft_with_pos + aircraft_without_pos
    max_range_m = stats_data.get("last1min", {}).get("max_distance", 0)
    max_range_km = round(max_range_m / 1000, 2) if max_range_m else 0
    avg_signal = stats_data.get("last1min", {}).get("local", {}).get("signal", 0)

    # Change over last period
    global LAST_NET_STATS
    net_usage_rx_kb = net_usage_tx_kb = 0
    if LAST_NET_STATS["iface"] == iface and LAST_NET_STATS["time"] and LAST_NET_STATS["rx_bytes"] and LAST_NET_STATS["tx_bytes"]:
        delta_time = now - LAST_NET_STATS["time"]
        delta_rx = rx_bytes - LAST_NET_STATS["rx_bytes"]
        delta_tx = tx_bytes - LAST_NET_STATS["tx_bytes"]
        if delta_time > 0:
            net_usage_rx_kb = round(delta_rx / 1024, 2)
            net_usage_tx_kb = round(delta_tx / 1024, 2)
    LAST_NET_STATS = {"time": now, "iface": iface, "rx_bytes": rx_bytes, "tx_bytes": tx_bytes}

    return jsonify({
        'ok': True,
        'live': {
            'messages_per_sec': messages_per_sec,
            'aircraft_now': total_aircraft,
            'aircraft_with_pos': aircraft_with_pos,
            'aircraft_without_pos': aircraft_without_pos,
            'max_range_km': max_range_km,
            'signal_avg_db': avg_signal,
            'data_usage_rx_kb': net_usage_rx_kb,
            'data_usage_tx_kb': net_usage_tx_kb,
            'rx_total': rx_bytes,
            'tx_total': tx_bytes,
            'total_sent_month': total_sent_month,
            'network_iface': iface or ""
        }
    })

@app.route('/api/stats/archive', methods=['GET'])
def stats_archive():
    archive = load_json(ARCHIVE_PATH)
    # Convert dict to a list sorted in descending order by month
    archive_list = sorted(archive.items(), key=lambda x: x[0], reverse=True)
    return jsonify({"ok": True, "archive": archive_list})

# ---------- readsb Service Endpoints ----------
@app.route('/api/service/readsb/get-gain', methods=['GET'])
def api_readsb_get_gain():
    gain = ""
    config_path = "/etc/default/readsb"
    if not os.path.exists(config_path):
        return jsonify({'ok': False, 'msg': 'readsb config not found!', 'gain': ''})
    try:
        with open(config_path, "r") as f:
            for line in f:
                if "GAIN=" in line:
                    # Example: GAIN="auto-verbose,12,-24,-6,35"
                    gain = line.split("=")[-1].strip().replace('"','').replace("'","")
                elif "--gain" in line:
                    # Example: DECODER_OPTIONS="--gain 28"
                    parts = line.replace('"','').replace("'","").split()
                    if "--gain" in parts:
                        idx = parts.index("--gain")
                        if idx+1 < len(parts):
                            gain = parts[idx+1]
    except Exception as e:
        return jsonify({'ok': False, 'msg': str(e), 'gain': ''})
    return jsonify({'ok': True, 'gain': gain or ''})

@app.route('/api/service/readsb/get-location', methods=['GET'])
def api_readsb_get_location():
    lat, lon = None, None
    config_path = "/etc/default/readsb"
    if not os.path.exists(config_path):
        return jsonify({'ok': False, 'msg': 'readsb config not found!', 'lat': '', 'lon': ''})
    try:
        with open(config_path, "r") as f:
            lines = f.readlines()
        # Search for any line containing --lat and --lon (whether in a variable or otherwise)
        for line in lines:
            if '--lat' in line and '--lon' in line:
                # Remove quotes
                line = line.replace('"','').replace("'","")
                parts = line.split()
                for i, p in enumerate(parts):
                    if p == '--lat' and (i+1) < len(parts):
                        lat = parts[i+1]
                    if p == '--lon' and (i+1) < len(parts):
                        lon = parts[i+1]
        # If not found, search in other formats
        if not lat or not lon:
            for line in lines:
                if line.strip().startswith("DECODER_OPTIONS="):
                    vals = line.split("=")[-1].replace('"','').replace("'","")
                    p = vals.split()
                    if '--lat' in p:
                        lat = p[p.index('--lat')+1]
                    if '--lon' in p:
                        lon = p[p.index('--lon')+1]
    except Exception as e:
        return jsonify({'ok': False, 'msg': str(e), 'lat': '', 'lon': ''})
    return jsonify({'ok': True, 'lat': lat or '', 'lon': lon or ''})

@app.route('/api/service/readsb/heatmap', methods=['POST'])
def api_readsb_heatmap():
    data = request.get_json() or {}
    enable = data.get("enable", True)
    # Ensure the value is Boolean, not String
    if isinstance(enable, str):
        enable = (enable.lower() == "true")
    config_path = "/etc/default/readsb"
    options_to_add = "--heatmap-dir /var/globe_history --heatmap 30"

    try:
        lines = []
        if os.path.exists(config_path):
            with open(config_path, "r") as f:
                lines = f.readlines()

        found_json_options = False
        for i, line in enumerate(lines):
            if line.strip().startswith("JSON_OPTIONS="):
                found_json_options = True
                current_options = line.split('=', 1)[1].strip().strip('"').strip("'")

                if enable:
                    if options_to_add not in current_options:
                        new_options = f'"{current_options.strip()} {options_to_add}"'
                        lines[i] = f"JSON_OPTIONS={new_options}\n"
                else: # if disabling
                    if options_to_add in current_options:
                        new_options = current_options.replace(options_to_add, '').strip()
                        new_options = f'"{new_options}"' if new_options else '""'
                        lines[i] = f"JSON_OPTIONS={new_options}\n"
                break

        if not found_json_options:
            if enable:
                lines.append(f'JSON_OPTIONS="{options_to_add}"\n')

        with open(config_path, "w") as f:
            f.writelines(lines)

        if enable:
            if not os.path.exists("/var/globe_history"):
                subprocess.call(["sudo", "mkdir", "/var/globe_history"])
            subprocess.call(["sudo", "chown", "readsb", "/var/globe_history"])

        subprocess.call(["sudo", "systemctl", "restart", "readsb"])

        return jsonify({
            'ok': True,
            'result': f"Heatmap {'enabled' if enable else 'disabled'}.",
            'desc': "Experimental: Enable or disable heatmap in readsb"
        })
    except Exception as e:
        return jsonify({'ok': False, 'msg': str(e)})

@app.route('/api/service/readsb/status', methods=['GET'])
def api_readsb_status():
    lang = request.args.get('lang', 'en')
    return jsonify({
        'result': run_shell("systemctl status readsb"),
        'desc': lang_desc("readsb_status", lang)
    })

@app.route('/api/service/readsb/restart', methods=['POST'])
def api_readsb_restart():
    lang = request.args.get('lang', 'en')
    result = run_shell("sudo systemctl restart readsb")
    return jsonify({'result': result, 'desc': lang_desc("readsb_restart", lang)})

@app.route('/api/service/readsb/logs', methods=['GET'])
def api_readsb_logs():
    lang = request.args.get('lang', 'en')
    return jsonify({
        'result': run_shell("journalctl -n 50 -u readsb --no-pager"),
        'desc': lang_desc("readsb_logs", lang)
    })

@app.route('/api/service/readsb/set-location', methods=['POST'])
def api_readsb_set_location():
    lang = request.args.get('lang', 'en')
    data = request.json
    lat = str(data.get("latitude", ""))
    lon = str(data.get("longitude", ""))
    result = run_shell(f"sudo readsb-set-location {lat} {lon}")
    return jsonify({
        'result': result,
        'desc': lang_desc("readsb_set_location", lang)
    })

@app.route('/api/service/readsb/set-gain', methods=['POST'])
def api_readsb_set_gain():
    lang = request.args.get('lang', 'en')
    data = request.json
    gain = str(data.get("gain", ""))
    result = run_shell(f"sudo readsb-gain {gain}")
    return jsonify({
        'result': result,
        'desc': lang_desc("readsb_set_gain", lang)
    })

# ---------- Wingbits Service Endpoints ----------
@app.route('/api/service/wingbits/get-station-id', methods=['GET'])
def api_get_station_id():
    id_path = "/etc/wingbits/device"
    station_id = ""
    if os.path.exists(id_path):
        try:
            with open(id_path) as f:
                station_id = f.read().strip()
        except Exception as e:
            return jsonify({'ok': False, 'msg': str(e), 'station_id': ''})
    return jsonify({'ok': True, 'station_id': station_id})

@app.route('/api/service/wingbits/set-station-id', methods=['POST'])
def api_set_station_id():
    data = request.json
    station_id = data.get("station_id", "").strip()
    import re
    valid = False
    # Accepts UUID v4 format
    if re.match(r"^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$", station_id):
        valid = True
    # Or three lowercase words separated by hyphens
    elif re.match(r"^[a-z]+-[a-z]+-[a-z]+$", station_id):
        valid = True
    # Or 18 connected hex characters
    elif re.match(r"^[0-9a-fA-F]{18}$", station_id):
        valid = True
    if not valid:
        return jsonify({'ok': False, 'msg': 'Invalid Station ID format'})
    id_path = "/etc/wingbits/device"
    try:
        with open(id_path, "w") as f:
            f.write(station_id)
        # Restart wingbits service automatically (optional)
        import subprocess
        subprocess.call(["sudo", "systemctl", "restart", "wingbits"])
    except Exception as e:
        return jsonify({'ok': False, 'msg': str(e)})
    return jsonify({'ok': True, 'msg': 'Station ID updated!', 'station_id': station_id})

@app.route('/api/service/wingbits/status', methods=['GET'])
def api_wingbits_status():
    lang = request.args.get('lang', 'en')
    return jsonify({
        'result': run_shell("systemctl status wingbits"),
        'desc': lang_desc("wingbits_status", lang)
    })

@app.route('/api/service/wingbits/last-install-log', methods=['GET'])
def api_wingbits_last_install_log():
    log_files = sorted(glob.glob("/var/log/wingbits/install_*.log"))
    if not log_files:
        return jsonify({
            'result': 'No install logs found.',
            'desc': 'last Wingbits install log'
        })
    last_log = log_files[-1]
    try:
        with open(last_log) as f:
            content = f.read()[-3500:]  # Displays only the last 3500 characters for easier viewing
    except Exception as e:
        content = str(e)
    return jsonify({
        'result': content,
        'desc': 'last Wingbits install log'
    })

@app.route('/api/service/wingbits/debug', methods=['GET'])
def api_wingbits_debug():
    lang = request.args.get('lang', 'en')
    # Execute the debug script directly, as done in wb-config
    result = run_shell("curl -sL \"https://gitlab.com/wingbits/config/-/raw/master/debug.sh\" | sudo bash 2>&1")

    # Filter ANSI color codes
    result = re.sub(r'\x1B\[[0-9;]*[mGKF]', '', result)
    # Filter tput messages if they appear
    result = re.sub(r'tput: unknown terminal "[^"]+"\n?', '', result)
    result = re.sub(r'\r', '', result)

    return jsonify({
        'result': result,
        'desc': lang_desc("wingbits_debug", lang)
    })

@app.route('/api/service/wingbits/restart', methods=['POST'])
def api_wingbits_restart():
    lang = request.args.get('lang', 'en')
    result = run_shell("sudo systemctl restart wingbits")
    return jsonify({'result': result, 'desc': lang_desc("wingbits_restart", lang)})

@app.route('/api/service/wingbits/logs', methods=['GET'])
def api_wingbits_logs():
    lang = request.args.get('lang', 'en')
    return jsonify({
        'result': run_shell("journalctl -n 2000 -u wingbits --no-pager"),
        'desc': lang_desc("wingbits_logs", lang)
    })

@app.route('/api/service/wingbits/update-client', methods=['POST'])
def api_wingbits_update_client():
    lang = request.args.get('lang', 'en')
    result = run_shell("curl -sL https://gitlab.com/wingbits/config/-/raw/master/install-client.sh | sudo bash")
    return jsonify({
        'result': result,
        'desc': lang_desc("wingbits_update_client", lang)
    })

@app.route('/api/service/wingbits/geosigner-info', methods=['GET'])
def api_wingbits_geosigner_info():
    lang = request.args.get('lang', 'en')
    result = run_shell("wingbits geosigner info")
    return jsonify({
        'result': result,
        'desc': lang_desc("wingbits_geosigner_info", lang)
    })

@app.route('/api/service/wingbits/version', methods=['GET'])
def api_wingbits_version():
    lang = request.args.get('lang', 'en')
    result = run_shell("wingbits -v")
    return jsonify({
        'result': result,
        'desc': lang_desc("wingbits_version", lang)
    })

# ---------- tar1090 Service Endpoints ----------
@app.route('/api/service/tar1090/restart', methods=['POST'])
def api_tar1090_restart():
    lang = request.args.get('lang', 'en')
    result = run_shell("sudo systemctl restart tar1090")
    return jsonify({'result': result, 'desc': lang_desc("tar1090_restart", lang)})

@app.route('/api/service/tar1090/route-info', methods=['POST'])
def api_tar1090_route_info():
    lang = request.args.get('lang', 'en')
    data = request.get_json() or {}
    enable = data.get("enable", True)
    if isinstance(enable, str):
        enable = (enable.lower() == "true")
    config_path = "/usr/local/share/tar1090/html/config.js"
    if not os.path.exists(config_path):
        result = "config.js not found!"
    else:
        with open(config_path, "r") as f:
            js = f.read()
        import re
        # Modifies the line if it's in the format : or = with any spaces
        if re.search(r"useRouteAPI\s*[:=]\s*(true|false)", js):
            js = re.sub(r"useRouteAPI\s*[:=]\s*(true|false)",
                        f"useRouteAPI = {'true' if enable else 'false'}", js)
        else:
            # If the line does not exist, add it to the end of the file
            if not js.endswith('\n'):
                js += '\n'
            js += f"useRouteAPI = {'true' if enable else 'false'};\n"
        with open(config_path, "w") as f:
            f.write(js)
        result = f"Route info {'enabled' if enable else 'disabled'}."
    return jsonify({
        'result': result,
        'desc': lang_desc("tar1090_route_info", lang)
    })

# ---------- graphs1090 Service Endpoints ----------
@app.route('/api/service/graphs1090/restart', methods=['POST'])
def api_graphs1090_restart():
    lang = request.args.get('lang', 'en')
    return jsonify({
        'result': run_shell("sudo systemctl restart graphs1090"),
        'desc': lang_desc("graphs1090_restart", lang)
    })

@app.route('/api/service/graphs1090/colorscheme', methods=['POST'])
def api_graphs1090_colorscheme():
    data = request.get_json()
    color = data.get('color', '')
    if color not in ['dark', 'default']:
        return jsonify({'ok': False, 'msg': 'Invalid color'})
    config_path = "/etc/default/graphs1090"
    try:
        # Read all old lines
        lines = []
        if os.path.exists(config_path):
            with open(config_path, "r") as f:
                lines = f.readlines()
        found = False
        # Modify the colorscheme line if it exists
        for i in range(len(lines)):
            if lines[i].strip().startswith("colorscheme="):
                lines[i] = f"colorscheme={color}\n"
                found = True
        # If not found, add the line
        if not found:
            lines.append(f"colorscheme={color}\n")
        # Rewrite the file
        with open(config_path, "w") as f:
            f.writelines(lines)
        # Restart the service
        import subprocess
        subprocess.call(["sudo", "systemctl", "restart", "graphs1090"])
        return jsonify({'ok': True, 'result': f"graphs1090 {color} mode enabled. Reload your graphs1090 page"})
    except Exception as e:
        return jsonify({'ok': False, 'msg': str(e)})

# ---------- System Information & Control Endpoints ----------
@app.route('/api/system/info', methods=['GET'])
def system_info():
    try:
        # System specifications
        cpu_name = None
        if os.path.exists("/proc/cpuinfo"):
            cpu_name_output = os.popen('cat /proc/cpuinfo | grep "model name" | head -1').read()
            if cpu_name_output:
                cpu_name = cpu_name_output.split(":")[-1].strip()
        if not cpu_name:
            cpu_name = platform.processor()

        info = {
            "hostname": platform.node(),
            "os": platform.platform(),
            "cpu": cpu_name,
            "arch": platform.machine(),
            "cores": psutil.cpu_count(logical=True),
            "load_avg": os.getloadavg() if hasattr(os, "getloadavg") else [0, 0, 0],
            "ram_total_mb": round(psutil.virtual_memory().total/1024/1024,1),
            "ram_free_mb": round(psutil.virtual_memory().available/1024/1024,1),
            "disk_total_gb": round(psutil.disk_usage('/').total/1024/1024/1024,2),
            "disk_free_gb": round(psutil.disk_usage('/').free/1024/1024/1024,2),
            "uptime_hr": round((psutil.boot_time() and ((time.time()-psutil.boot_time())/3600)) or 0,1)
        }

        # CPU temperature (for Raspberry Pi or supported devices)
        temp = None
        try:
            if os.path.exists('/sys/class/thermal/thermal_zone0/temp'):
                with open('/sys/class/thermal/thermal_zone0/temp') as f:
                    temp = round(int(f.read()) / 1000, 1)
            else:
                temp_out = os.popen("sensors | grep 'CPU' | grep '°C'").read()
                if temp_out:
                    temp = temp_out
        except:
            temp = None
        info["cpu_temp"] = temp

        # SDR dongle status
        sdr_status = "not_connected"
        try:
            sdr_out = subprocess.check_output('lsusb | grep -i "RTL2832"', shell=True).decode().strip()
            if sdr_out:
                sdr_status = "connected"
        except:
            sdr_status = "not_connected"
        info["sdr_status"] = sdr_status

        return jsonify({"ok": True, "info": info})
    except Exception as e:
        return jsonify({"ok": False, "msg": str(e)})

@app.route('/api/netstatus')
def api_netstatus():
    import requests
    # Check internet connection
    try:
        r = requests.get("https://1.1.1.1", timeout=3)
        online = (r.status_code == 200 or r.status_code == 301 or r.status_code == 302)
    except requests.exceptions.RequestException:
        online = False

    # Check Wingbits server
    try:
        r2 = requests.get("https://api.wingbits.com/ping", timeout=5)
        server_ok = (r2.status_code == 200)
    except requests.exceptions.RequestException:
        server_ok = False

    # Get last sync time from local file (example, not mandatory)
    last_sync = None
    meta_path = "/opt/wingbits-station-web/live_stats_meta.json"
    if os.path.exists(meta_path):
        try:
            with open(meta_path) as f:
                meta = json.load(f)
            last_sync = meta.get("last_sync", "")
        except json.JSONDecodeError:
            pass

    return jsonify({"ok": True, "net": {
        "online": online,
        "server_ok": server_ok,
        "last_sync": last_sync or ""
    }})

@app.route('/api/alerts', methods=['GET'])
def api_alerts():
    import subprocess, os, re
    alerts = []

    # 1. Check systemctl service status
    services = [("wingbits", "Wingbits"), ("readsb", "readsb"), ("tar1090", "tar1090")]
    for svc, label in services:
        try:
            out = subprocess.check_output(['systemctl', 'is-active', svc], stderr=subprocess.STDOUT).decode().strip()
            if out != "active":
                alerts.append(f"{label} service is NOT running!")
        except Exception as e:
            alerts.append(f"{label} service status unknown: {e}")

    # 2. Check for missing SDR (example)
    try:
        sdr = subprocess.check_output("lsusb | grep -i RTL2832", shell=True).decode().strip()
        if not sdr:
            alerts.append("SDR dongle is NOT detected! (RTL2832)")
    except Exception as e:
        alerts.append("SDR check failed: " + str(e))

    # 3. Check disk space
    try:
        st = os.statvfs("/")
        percent = 100 - (st.f_bavail / st.f_blocks * 100)
        if percent > 95:
            alerts.append(f"Disk is almost full: {percent:.1f}% used")
    except:
        pass

    # 4. Tail log files (wingbits, readsb, tar1090)
    logfiles = [
        ("/var/log/wingbits.log", "wingbits"),
        ("/var/log/readsb.log", "readsb"),
        ("/var/log/tar1090.log", "tar1090"),
    ]
    keywords = re.compile(r"(ERROR|FATAL|FAIL|WARNING|WARN)", re.IGNORECASE)
    for logfile, label in logfiles:
        if os.path.exists(logfile):
            try:
                lines = subprocess.check_output(["tail", "-n", "200", logfile]).decode(errors="ignore").splitlines()
                for line in lines:
                    if keywords.search(line):
                        # Don't duplicate alerts if the text is the same
                        if not any(line in a for a in alerts):
                            alerts.append(f"[{label}] {line.strip()[:400]}")
            except:
                pass

    return {"ok": True, "alerts": alerts}

@app.route('/api/status/check')
def api_status_check():
    import subprocess, os
    def svc_status(name):
        try:
            out = subprocess.check_output(['systemctl', 'is-active', name], stderr=subprocess.STDOUT).decode().strip()
            return out == "active"
        except:
            return False

    import socket
    try:
        # Check internet
        online = False
        try:
            socket.create_connection(("8.8.8.8", 53), timeout=2)
            online = True
        except:
            online = False

        # Get wingbits status output
        try:
            wb_status = subprocess.check_output(['sudo', 'wingbits', 'status'], stderr=subprocess.STDOUT).decode().strip()
        except Exception as e:
            wb_status = "Error: " + str(e)

        return jsonify({
            "ok": True,
            "status": {
                "internet": online,
                "wingbits": svc_status("wingbits"),
                "readsb": svc_status("readsb"),
                "tar1090": svc_status("tar1090"),
                "wb_details": wb_status  # Full wingbits status output
            }
        })
    except Exception as e:
        return jsonify({"ok": False, "msg": str(e)})

@app.route('/api/update/reinstall', methods=['POST'])
def api_update_reinstall():
    import subprocess
    import json
    req = request.get_json(force=True)
    comps = req.get("components", [])

    steps = []
    try:
        if "deps" in comps:
            steps.append(("deps", subprocess.getoutput('sudo apt update && sudo apt install --reinstall -y python3 python3-pip rtl-sdr')))
        if "wingbits" in comps:
            steps.append(("wingbits", subprocess.getoutput('sudo systemctl stop wingbits ; wget -O /usr/local/bin/wingbits https://dl.wingbits.com/latest/wingbits-linux-arm64 ; chmod +x /usr/local/bin/wingbits ; sudo systemctl restart wingbits')))
        if "readsb" in comps:
            steps.append(("readsb", subprocess.getoutput('sudo systemctl stop readsb ; cd /tmp && wget https://github.com/wiedehopf/adsb-scripts/releases/latest/download/readsb.tar.xz ; tar -xJf readsb.tar.xz -C /usr/local/bin ; sudo systemctl restart readsb')))
        if "tar1090" in comps:
            steps.append(("tar1090", subprocess.getoutput('cd /usr/local/share/tar1090/html && sudo git pull')))
        if "panel" in comps:
            steps.append(("panel", subprocess.getoutput('cd /opt/wingbits-station-web && sudo git pull ; sudo systemctl restart wingbits-web-panel')))
        detail = "\n".join([f"[{name}]\n{out}" for name, out in steps])
        return jsonify({"ok": True, "msg": "All selected components updated!", "detail": detail})
    except Exception as e:
        return jsonify({"ok": False, "msg": str(e)})

@app.route("/api/feeder/versions")
def feeder_versions():
    import os, datetime
    try:
        wingbits_ver = os.popen("wingbits --version 2>/dev/null").read().strip() or None
        readsb_ver = os.popen("readsb --version 2>/dev/null").read().strip() or None
        tar1090_ver = os.popen("tar1090 --version 2>/dev/null").read().strip() or None
        panel_ver = "1.0.0"
        return jsonify({
            "ok": True,
            "versions": {
                "wingbits": wingbits_ver,
                "readsb": readsb_ver,
                "tar1090": tar1090_ver,
                "panel": panel_ver
            },
            "checked_at": datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')
        })
    except Exception as e:
        return jsonify({"ok": False, "msg": str(e)})

@app.route('/api/service/urls', methods=['GET'])
def api_get_urls():
    import socket
    # Get the device's primary IP
    def get_ip_address():
        s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        try:
            # Try connecting to a public IP to get the actual outbound IP
            s.connect(("8.8.8.8", 80))
            ip = s.getsockname()[0]
        except Exception:
            ip = "127.0.0.1"
        finally:
            s.close()
        return ip

    ip_addr = get_ip_address()
    urls = [
        {"title": "Live map (tar1090)", "url": f"http://{ip_addr}/tar1090"},
        {"title": "Statistics (graphs1090)", "url": f"http://{ip_addr}/graphs1090"},
        {"title": "Advanced Web Panel", "url": f"http://{ip_addr}:5000"},
        {"title": "Wingbits Dashboard", "url": "https://dash.wingbits.com/"},
    ]
    return jsonify({"ok": True, "urls": urls})

# ---------- System Reboot/Shutdown Endpoints ----------
@app.route('/api/system/reboot', methods=['POST'])
def api_reboot():
    lang = request.args.get('lang', 'en')
    run_shell("sudo reboot")
    return jsonify({'result': "Device is rebooting...", 'desc': lang_desc("pi_restart", lang)})

@app.route('/api/system/shutdown', methods=['POST'])
def api_shutdown():
    lang = request.args.get('lang', 'en')
    run_shell("sudo shutdown -h now")
    return jsonify({'result': "Device is shutting down...", 'desc': lang_desc("pi_shutdown", lang)})

# ---------- Miscellaneous System Info/Checks (For debug if needed) ----------
@app.route('/api/system/is-pi', methods=['GET'])
def api_is_pi():
    lang = request.args.get('lang', 'en')
    cpuinfo = run_shell("cat /proc/cpuinfo")
    is_pi = 'Raspberry Pi' in cpuinfo or 'BCM' in cpuinfo
    return jsonify({
        'result': is_pi,
        'desc': lang_desc("is_pi", lang) if "is_pi" in DESCRIPTIONS else "Check if device is Raspberry Pi"
    })

@app.route('/api/system/is-runnable', methods=['GET'])
def api_is_runnable():
    lang = request.args.get('lang', 'en')
    etc_issue = run_shell("cat /etc/issue")
    is_debian = 'Debian' in etc_issue or 'Ubuntu' in etc_issue or 'Raspbian' in etc_issue
    return jsonify({
        'result': is_debian,
        'desc': lang_desc("is_runnable", lang) if "is_runnable" in DESCRIPTIONS else "Check if OS is Debian-based"
    })

@app.route('/api/system/nc-installed', methods=['GET'])
def api_nc_installed():
    lang = request.args.get('lang', 'en')
    res = run_shell("which nc")
    return jsonify({
        'result': bool(res),
        'desc': lang_desc("nc_installed", lang) if "nc_installed" in DESCRIPTIONS else "Check if netcat is installed"
    })

@app.route('/api/system/curl-installed', methods=['GET'])
def api_curl_installed():
    lang = request.args.get('lang', 'en')
    res = run_shell("which curl")
    return jsonify({
        'result': bool(res),
        'desc': lang_desc("curl_installed", lang) if "curl_installed" in DESCRIPTIONS else "Check if curl is installed"
    })

def get_ip_address():
    import socket
    try:
        s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        s.connect(("8.8.8.8", 80))
        ip = s.getsockname()[0]
        s.close()
    except Exception:
        ip = "127.0.0.1"
    return ip

@app.route('/api/debug/info', methods=['GET'])
def api_debug_info():
    try:
        # Collect information for debug
        station_id = ""
        id_path = "/etc/wingbits/device"
        if os.path.exists(id_path):
            with open(id_path) as f:
                station_id = f.read().strip()

        hostname = platform.node()
        ip = get_ip_address() # Re-using function from api_get_urls
        
        # Get location and versions using existing functions
        loc_data = api_readsb_get_location().json['lat'], api_readsb_get_location().json['lon']
        lat, lon = loc_data[0], loc_data[1]
        
        versions = feeder_versions().json['versions']
        wingbits_ver = versions.get('wingbits', '-')
        readsb_ver = versions.get('readsb', '-')
        tar1090_ver = versions.get('tar1090', '-')

        # Fetch recent logs (last 50 lines from wingbits and readsb)
        wingbits_logs = run_shell("journalctl -n 50 -u wingbits --no-pager")
        readsb_logs = run_shell("journalctl -n 50 -u readsb --no-pager")
        all_logs = f"--- Wingbits Logs ---\n{wingbits_logs}\n\n--- readsb Logs ---\n{readsb_logs}"

        debug_info = {
            "station_id": station_id,
            "hostname": hostname,
            "ip": ip,
            "lat": lat,
            "lon": lon,
            "wingbits_ver": wingbits_ver,
            "readsb_ver": readsb_ver,
            "tar1090_ver": tar1090_ver,
            "logs": all_logs
        }
        return jsonify({"ok": True, "info": debug_info})
    except Exception as e:
        return jsonify({"ok": False, "msg": str(e)})


# ----------- Frontend files -----------
@app.route('/', defaults={'path': ''})
@app.route('/<path:path>')
def serve_frontend(path):
    root = '/opt/wingbits-station-web/frontend'
    if path != "" and os.path.exists(os.path.join(root, path)):
        return send_from_directory(root, path)
    else:
        return send_from_directory(root, "index.html")

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
EOF

echo "Backend Flask app written."
echo ""