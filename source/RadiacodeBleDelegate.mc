import Toybox.BluetoothLowEnergy;
import Toybox.WatchUi;

// Scan-only diagnostic. Does not connect, pair or read measurements.
class RadiacodeBleDelegate extends BluetoothLowEnergy.BleDelegate {
    var _view;

    function initialize(view) {
        BleDelegate.initialize();
        _view = view;
    }

    function onScanResults(results) {
        var entry = results.next();
        while (entry != null) {
            var scanResult = entry as BluetoothLowEnergy.ScanResult;
            _view.onBleAdvertisement();
            var name = scanResult.getDeviceName();
            if (name != null) {
                _view.onBleDevice(name);
            }
            entry = results.next();
        }
    }

    function onScanStateChange(state, status) {
        if (status != BluetoothLowEnergy.STATUS_SUCCESS) {
            _view.setBleStatus("BLE SCAN ERROR");
        }
    }
}
