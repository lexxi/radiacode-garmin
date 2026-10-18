# BLE discovery investigation — vívoactive 5 / Radiacode 103

Status: reproducible on real hardware, 2026-10-18. **No direct Radiacode connection achieved.** The app still displays simulated radiation readings.

## Hardware and observations

- Garmin vívoactive 5, Connect IQ watch app from `test/ble-diagnostics`; scan interval 15 s.
- Radiacode 103 (advertised name `RadiaCode-103`, observed BLE address `52:43:06:70:0F:F5` in earlier captures).
- ESP32-CAM (AI Thinker) using Arduino ESP32 BLE library as a controlled advertiser.
- nRF52840 USB dongle with Wireshark BLE sniffer for independent packet capture.

In the Garmin diagnostics, `P` counts observed scan entries; `N` counts distinct non-null advertised names. `CB 1/0` means scan-state callback 1 with success status 0, and `CB 0/0` is the successful stop callback. These state callbacks **do not themselves imply received advertisements**.

| BLE transmitter / configuration | Watch result |
|---|---|
| Radiacode 103, iPhone Bluetooth disabled during scan | `P0 N0`; `CB 1/0` then `CB 0/0` |
| ESP32-CAM, initial SDK-generated advertising with 128-bit service UUID | `P126` |
| ESP32-CAM, same sketch but `addServiceUUID` commented out | `P140 N1` |
| ESP32-CAM, explicit advertising data with name and no flags or UUID | `P0 N0` |
| Same explicit advertising, `advData.setFlags(0x06)` | `P139 N1` |
| Same explicit advertising, `advData.setFlags(0x04)` | `P0 N0` |
| Same explicit advertising, `advData.setFlags(0x05)` | `P136 N1` |

Flag bits:
- `0x01`: LE Limited Discoverable Mode
- `0x02`: LE General Discoverable Mode
- `0x04`: BR/EDR Not Supported

**Interpretation:** With the controlled ESP32 transmitter, Garmin scan results appeared when either discoverable bit was set (`0x05`, `0x06`) and disappeared when neither was set (absent or `0x04`). A service UUID was not required. This strongly suggests a discoverability-based filtering condition somewhere in the real-device BLE scan path. It is not proof of the internal firmware implementation and should not be described as a guaranteed Garmin API contract.

Earlier Radiacode sniffing suggests that the normal ADV payload carries its device name rather than discoverable Flags; a corresponding Scan Response carried other data. **Recheck actual Radiacode ADV/SCAN_RSP bytes against a saved capture before treating this as definitive.** The ESP32 experiment did not distinguish empty scan-response behavior from every Radiacode-specific behavior, but changing just flags between its final variants isolated the flags' effect for that transmitter.

## Primary SDK documentation

- [Garmin Toybox.BluetoothLowEnergy](https://developer.garmin.com/connect-iq/api-docs/Toybox/BluetoothLowEnergy.html): `setScanState`, `onScanResults`, `pairDevice(scanResult)`, `getPairedDevices()`, `getBondedDevices()`, `registerProfile()`.
- [ScanResult](https://developer.garmin.com/connect-iq/api-docs/Toybox/BluetoothLowEnergy/ScanResult.html): returned from scanning, cannot be constructed by an app; includes `hasAddress()`.
- [Device](https://developer.garmin.com/connect-iq/api-docs/Toybox/BluetoothLowEnergy/Device.html): get devices through pairing or system-paired list.
- [Garmin Developer Forum: Connect IQ BLE scan issue](https://forums.garmin.com/developer/connect-iq/i/bug-reports/connect-iq-ble-scan-issue): analogous missing results when a discoverable flag was absent, and Garmin response acknowledging an investigation ticket.

## Supported pairing routes / next steps

`BluetoothLowEnergy.pairDevice()` **requires a real `ScanResult`**, so the captured device MAC cannot simply be supplied to directly connect. `ScanResult.hasAddress()` filters an already-received result and is not a way to generate one. Registering a profile exposes the UUIDs/characteristics for later GATT access; it is not documented as an override to discovery filtering.

`getPairedDevices()` and `getBondedDevices()` are worth evaluating only if the Radiacode was genuinely paired/bonded with the Garmin system and accessible to the Connect IQ app. This has not been established. There is no documented connect-by-MAC or raw scan-flags override in the checked public API.

**Next non-proxy experiment:** verify the Radiacode ADV/SCAN_RSP bytes once more; investigate whether it can intentionally advertise discoverability under any supported device mode. If impossible, direct Connect IQ access is blocked at discovery on the tested watch/firmware. An intermediary BLE advertiser would remain an option, but is not yet part of this branch.
