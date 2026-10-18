import Toybox.Graphics;
import Toybox.Timer;
import Toybox.WatchUi;

class RadiacodeMonitorView extends WatchUi.View {

    // DEMO only: no connection to a real Radiacode device.
    var _timer;
    var _seconds = 0;
    var _doseRate = 0.124;
    var _dose = 0.0;

    function initialize() {
        View.initialize();
        _timer = new Timer.Timer();
    }

    function onShow() {
        // One simulated sample per second while the view is visible.
        _timer.start(method(:onSample), 1000, true);
    }

    function onHide() {
        _timer.stop();
    }

    function onSample() {
        _seconds += 1;

        // Deterministic test pattern: 0.104 ... 0.144 µSv/h.
        // A non-random pattern makes simulator testing reproducible.
        _doseRate = 0.104 + ((_seconds % 5) * 0.010);

        // Dose in µSv = dose rate in µSv/h multiplied by 1/3600 h.
        // This is a demo estimate, not a reading from Radiacode.
        _dose += _doseRate / 3600.0;

        WatchUi.requestUpdate();
    }

    function onUpdate(dc) {
        var w = dc.getWidth();
        var h = dc.getHeight();
        var x = w / 2;

        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();

        // DOSISLEISTUNG (unchanged layout)
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(
            x, h * 16 / 100,
            Graphics.FONT_SMALL,
            "DOSISLEISTUNG",
            Graphics.TEXT_JUSTIFY_CENTER
        );

        dc.setColor(Graphics.COLOR_GREEN, Graphics.COLOR_TRANSPARENT);
        dc.drawText(
            x + 35, h * 33 / 100,
            Graphics.FONT_NUMBER_MEDIUM,
            _doseRate.format("%.3f"),
            Graphics.TEXT_JUSTIFY_RIGHT
        );
        dc.drawText(
            x + 40, h * 39 / 100,
            Graphics.FONT_SMALL,
            "\u00B5Sv/h",
            Graphics.TEXT_JUSTIFY_LEFT
        );

        // DOSIS (unchanged layout)
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(
            x, h * 59 / 100,
            Graphics.FONT_SMALL,
            "DOSIS",
            Graphics.TEXT_JUSTIFY_CENTER
        );

        dc.drawText(
            x + 20, h * 74 / 100,
            Graphics.FONT_LARGE,
            _dose.format("%.4f"),
            Graphics.TEXT_JUSTIFY_RIGHT
        );
        dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
        dc.drawText(
            x + 25, h * 77 / 100,
            Graphics.FONT_SMALL,
            "\u00B5Sv",
            Graphics.TEXT_JUSTIFY_LEFT
        );
    }
}
