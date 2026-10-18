# Radiacode Garmin Monitor

A Connect IQ watch app for displaying radiation measurements from a Radiacode 103 on a Garmin vívoactive 5.

> **Project status: v0.1 — display prototype.** Values shown on the watch are hard-coded examples. There is **no connection to a Radiacode device yet**, and the app must not be used for radiation safety decisions.

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

## Planned milestones

- **v0.1:** Static dose and dose-rate display in the simulator — done.
- **v0.2:** Periodically changing simulated dose-rate values and accumulated dose.
- **v0.3:** Evaluate and implement a compatible transport for real Radiacode 103 data.
- **v1.0:** Stable display with real measurements, connection status and stale-data handling.

### Data transport limitations

The vívoactive 5 Connect IQ environment does not currently provide a confirmed direct generic BLE connection to Radiacode 103. A working bridge or other supported transport must be verified experimentally. No live device support is claimed at this stage.

## License

MIT — see [LICENSE](LICENSE).
