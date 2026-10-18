# Radiacode Garmin Monitor

A Connect IQ watch app for displaying radiation measurements from a Radiacode 103 on a Garmin vívoactive 5.

> **Project status: v0.3 BLE discovery experiment — not yet device-tested.** Both readings are synthetic. There is **no connection to a Radiacode device yet**, and the app must not be used for radiation safety decisions.

## Display

The watch app currently displays:

- **Dose rate** in µSv/h (currently a static example value: 0.124 µSv/h).
- **Accumulated dose** in µSv (currently a static example value: 0.86 µSv).

The layout was tested in the Connect IQ simulator with the vívoactive 5 profile.

## Requirements

- Garmin Connect IQ SDK and SDK Manager
- Visual Studio Code with the Monkey C extension
- Java available on `PATH`
- Garmin vívoactive 5 device profile
- Local Connect IQ developer key (keep it private)

The project targets **vívoactive 5** and specifies **minimum Connect IQ API 5.2.0**.

## Build and test

1. Clone the repository and open it in Visual Studio Code.
2. Install the target device in the Connect IQ SDK Manager.
3. Generate/configure your own developer key in the Monkey C extension.
4. Select the `vivoactive5` target and start the Connect IQ simulator (e.g. with **F5**).

Do not commit your developer key. Key files (`*.der`, `*.pem`, `*.key`) and build output are ignored by Git.

## Simulation behavior\n\nThe sample timer runs every 1000 ms while the app view is visible. The demonstration integrates each sample as `rate / 3600` µSv. It is deliberately not a calibrated dosimeter; values reset when the app is launched again. The accumulated dose is rendered with four decimals to make small changes visible.\n\n## BLE scan test (v0.3)\n\nThe watch app starts a 15-second BLE scan when opened. The bottom status line shows scanning, a count of distinct advertised device names, or `RADIACODE FOUND` when a device advertises a name containing `radiacode` (case-insensitive). The scan does **not** pair or connect. BLE logs also print device names to the simulator/debug console if available. Restart the app to scan again.\n\nTo test on real hardware, install the development build on a vívoactive 5 and keep the Radiacode 103 powered on nearby. Disconnect the Radiacode iPhone app during the test. The simulator cannot prove radio discovery. A device that does not advertise its name will not count towards the named-device total.\n\n## Planned milestones

- **v0.1:** Static dose and dose-rate display in the simulator — done.
- **v0.2:** Periodically changing simulated dose-rate values and accumulated dose — implemented; simulator test pending.
- **v0.3:** BLE discovery diagnostic (15-second scan, advertised names, on-screen scan status) — implemented, awaiting hardware verification. GATT connection and real measurements are not yet implemented.
- **v1.0:** Stable display with real measurements, connection status and stale-data handling.

### Data transport limitations

The vívoactive 5 Connect IQ environment does not currently provide a confirmed direct generic BLE connection to Radiacode 103. A working bridge or other supported transport must be verified experimentally. No live device support is claimed at this stage.

## License

MIT — see [LICENSE](LICENSE).

## Real-device BLE discovery findings (2026-10-18)

The vívoactive 5 scan and callback work on hardware, but the Radiacode 103 does not appear in the scan results (`P0 N0`). A controlled ESP32-CAM experiment indicates a strong relationship between BLE discoverability flags and Garmin scan visibility (`0x05` and `0x06` visible; no flags and `0x04` invisible). This is an observed behavior, not a confirmed Garmin firmware specification. **See [BLE discovery test log](docs/BLE_DISCOVERY_TESTS.md)** for conditions, measurements, and official API constraints. The app is not connected to the Radiacode; on-screen dose values are simulated.
