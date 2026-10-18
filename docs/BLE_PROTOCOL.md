# Radiacode 103 BLE analysis

This directory contains an **offline analysis prototype**, not a production measurement library.

## Observations from iPhone/Radiacode captures

- Radiacode advertises as `RadiaCode-103`.
- ATT writes were seen on handle `0x000E`; notifications on `0x0010`.
- Common protocol commands: `0x0826` (read virtual string / data buffer), `0x0824` (read virtual SFR).
- `RealTimeData` carries count rate and dose rate, `RareData` carries accumulated dose and duration.
- The measurements in the fifth capture were broadly consistent with a phone screenshot showing 7.73 CPS and 0.09 µSv/h, plus a later displayed dose of about 0.34 µSv at 04:44:00.
- **A multiplication by 10,000 for the captured float dose values is a working hypothesis, not a rigorously verified device-wide conversion.** The timestamps and displayed values were not perfectly simultaneous.

The Python implementation at https://github.com/cdump/radiacode documents the underlying command and buffer record formats.

## Running the offline record extractor

Given an `ATT CSV` exported by the separate BLE/L2CAP reassembly step, with columns `opcode`, `handle`, `value_hex`:

```powershell
py tools/radiacode_recover_measurements.py koppelung_5_att.csv --output measurements.csv
```

The output contains **raw protocol floats**, not guaranteed calibrated µSv/h or µSv.

## Remaining work

1. Audit the reassembly for dropped, repeated and out-of-order BLE packets.
2. Validate units and scaling against simultaneous readings from the original device.
3. Verify the Garmin vívoactive 5 generic BLE scan/connection capability on hardware before abandoning direct BLE.
4. Do not present stale or demo data as live radiation measurements.
