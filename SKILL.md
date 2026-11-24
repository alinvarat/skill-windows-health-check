---
name: windows-health-check
description: Measure Windows temperature, load, drivers or power settings. Use linux-troubleshooting for Linux incidents.
---

# Windows health check

1. Confirm the target OS/device. This skill's PowerShell/GPU-Z helpers are Windows-only; do not run them on Debian or report another host's readings. Historical model: HP 15s-eq3xxx, Ryzen 5 5625U/integrated Radeon; verify if context differs.
2. Temperature: when GPU-Z is running, run `powershell -NoProfile -ExecutionPolicy Bypass -File <actual-skill-folder>/scripts/read-gpuz.ps1`. Resolve the installed Windows skill folder first, not the Linux path. It reads GPU-Z shared memory. If unavailable, an already installed GPU-Z may be launched when appropriate; retry once after it starts. Treat 0°C, implausible values and stale/missing records as unverified, not proof of health. Do not install tools automatically.
3. Workload: measure over a stated interval. For process CPU-time deltas, divide by elapsed time and logical processor count; do not divide an already normalized system percentage again. Separate instantaneous usage from cumulative CPU time; a short sample does not prove the cause.
4. Drivers: inspect present PnP errors and installed drivers. No PnP error does not prove the latest driver. Firmware is a separate, model-specific action.
5. Power/sleep: inspect existing settings and preserve unrelated choices. Restart, firmware, uninstall or power changes require authorization within the current request.
6. Re-measure after an authorized change. Report actual readings, interval, changes and gaps. A temperature snapshot is not proof of sustained stability or a completed fix.
