import Toybox.Graphics;
import Toybox.BluetoothLowEnergy;
import Toybox.System;
import Toybox.Timer;
import Toybox.WatchUi;

class RadiacodeMonitorView extends WatchUi.View {

    // DEMO only: no connection to a real Radiacode device.
    var _timer;
    var _bleDelegate;
    var _bleStatus = "BLE: NOT STARTED";
    var _deviceCount = 0;
    var _knownNames = [];
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
        startBleScan();
    }

    function onHide() {
        _timer.stop();
        try {
            BluetoothLowEnergy.setScanState(BluetoothLowEnergy.SCAN_STATE_OFF);
        } catch (e) {
            System.println("BLE stop: " + e);
        }
    }

    function setBleStatus(status) {
        _bleStatus = status;
        WatchUi.requestUpdate();
    }

    function onBleDevice(name) {
        // Count unique advertised names; unnamed advertisements are ignored.
        if (_knownNames.indexOf(name) == -1) {
            _knownNames.add(name);
            _deviceCount += 1;
            System.println("BLE found: " + name);
        }
        if (name.toLower().find("radiacode") != null) {
            _bleStatus = "RADIACODE FOUND";
        } else if (_bleStatus != "RADIACODE FOUND") {
            _bleStatus = "BLE DEVICES: " + _deviceCount;
        }
        WatchUi.requestUpdate();
    }

    function startBleScan() {
        _knownNames = [];
        _deviceCount = 0;
        _seconds = 0;
        _bleStatus = "BLE: SCANNING";
        try {
            _bleDelegate = new RadiacodeBleDelegate(self);
            BluetoothLowEnergy.setDelegate(_bleDelegate);
            BluetoothLowEnergy.setScanState(BluetoothLowEnergy.SCAN_STATE_SCANNING);
        } catch (e) {
            _bleStatus = "BLE UNAVAILABLE";
            System.println("BLE scan failed: " + e);
        }
        WatchUi.requestUpdate();
    }

    function stopBleScan() {
        try {
            BluetoothLowEnergy.setScanState(BluetoothLowEnergy.SCAN_STATE_OFF);
        } catch (e) {
            System.println("BLE scan stop failed: " + e);
        }
        if (_bleStatus == "BLE: SCANNING") {
            _bleStatus = "BLE: NO NAMED DEV";
        }
        WatchUi.requestUpdate();
    }

    function onSample() {
        _seconds += 1;
        // Use the already working 1-second simulation timer to end BLE scanning.
        if (_seconds == 15) {
            stopBleScan();
        }

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

        // BLE diagnostic above the existing measurement layout.
        dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
        dc.drawText(
            x, h * 6 / 100,
            Graphics.FONT_XTINY,
            _bleStatus,
            Graphics.TEXT_JUSTIFY_CENTER
        );

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
