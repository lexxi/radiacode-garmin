import Toybox.BluetoothLowEnergy as Ble;
import Toybox.WatchUi;

// Scan-only diagnostic. Does not connect, pair or read measurements.
class RadiacodeBleDelegate extends Ble.BleDelegate {
    var _view;

    function initialize(view) {
        BleDelegate.initialize();
        _view = view;
    }

    function onScanResults(results) {
        var entry = results.next();
        while (entry != null) {
            var name = entry.getDeviceName();
            if (name != null) {
                _view.onBleDevice(name);
            }
            entry = results.next();
        }
    }

    function onScanStateChange(state, status) {
        if (status != Ble.STATUS_SUCCESS) {
            _view.setBleStatus("BLE SCAN ERROR");
        }
    }
}
