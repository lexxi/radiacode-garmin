import Toybox.Communications;
import Toybox.Graphics;
import Toybox.System;
import Toybox.Timer;
import Toybox.WatchUi;

// v0.4 HTTPS diagnostic. These are static DEMO values, NOT live Radiacode measurements.
class RadiacodeMonitorView extends WatchUi.View {
    const DEMO_URL = "https://raw.githubusercontent.com/lexxi/radiacode-garmin/main/data/demo.json";

    var _timer;
    var _seconds = 0;
    var _lastPoll = -15;
    var _requestPending = false;
    var _httpStatus = "HTTP: WAIT";
    var _doseRate = 0.0;
    var _dose = 0.0;

    function initialize() {
        View.initialize();
        _timer = new Timer.Timer();
    }

    function onShow() {
        _seconds = 0;
        _lastPoll = -15;
        _requestPending = false;
        _httpStatus = "HTTP: WAIT";
        _timer.start(method(:onTick), 1000, true);
        pollDemo();
    }

    function onHide() {
        _timer.stop();
    }

    function onTick() {
        _seconds += 1;
        // Keep requests infrequent for the initial proof of concept.
        if (!_requestPending && _seconds - _lastPoll >= 15) {
            pollDemo();
        }
        WatchUi.requestUpdate();
    }

    function pollDemo() {
        _lastPoll = _seconds;
        _requestPending = true;
        _httpStatus = "HTTP: LOADING";
        try {
            var options = {
                :method => Communications.HTTP_REQUEST_METHOD_GET,
                :responseType => Communications.HTTP_RESPONSE_CONTENT_TYPE_JSON
            };
            Communications.makeWebRequest(DEMO_URL, null, options, method(:onDemoResponse));
        } catch (e) {
            _requestPending = false;
            _httpStatus = "HTTP: EXCEPTION";
            System.println("HTTP request exception: " + e);
        }
        WatchUi.requestUpdate();
    }

    function onDemoResponse(code, data) {
        _requestPending = false;
        if (code == 200 && data != null && (data instanceof Toybox.Lang.Dictionary)) {
            var rate = data["dose_rate"];
            var dose = data["dose"];
            if (rate != null && dose != null) {
                _doseRate = rate.toFloat();
                _dose = dose.toFloat();
                _httpStatus = "HTTP: 200 DEMO";
            } else {
                _httpStatus = "HTTP: BAD JSON";
            }
        } else {
            _httpStatus = "HTTP: " + code.toString();
        }
        WatchUi.requestUpdate();
    }

    function onUpdate(dc) {
        var w = dc.getWidth();
        var h = dc.getHeight();
        var x = w / 2;

        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();

        dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
        dc.drawText(x, h * 6 / 100, Graphics.FONT_XTINY,
            _httpStatus, Graphics.TEXT_JUSTIFY_CENTER);

        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(x, h * 16 / 100, Graphics.FONT_SMALL,
            "DOSISLEISTUNG", Graphics.TEXT_JUSTIFY_CENTER);

        dc.setColor(Graphics.COLOR_GREEN, Graphics.COLOR_TRANSPARENT);
        dc.drawText(x + 35, h * 33 / 100, Graphics.FONT_NUMBER_MEDIUM,
            _doseRate.format("%.3f"), Graphics.TEXT_JUSTIFY_RIGHT);
        dc.drawText(x + 40, h * 39 / 100, Graphics.FONT_SMALL,
            "\u00B5Sv/h", Graphics.TEXT_JUSTIFY_LEFT);

        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(x, h * 59 / 100, Graphics.FONT_SMALL,
            "DOSIS", Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(x + 20, h * 74 / 100, Graphics.FONT_LARGE,
            _dose.format("%.4f"), Graphics.TEXT_JUSTIFY_RIGHT);
        dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
        dc.drawText(x + 25, h * 77 / 100, Graphics.FONT_SMALL,
            "\u00B5Sv", Graphics.TEXT_JUSTIFY_LEFT);
    }
}
