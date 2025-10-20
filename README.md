# Aegis Firewall – A Verilog-Based Embedded Firewall System

**Aegis Firewall** is a modular RTL-level embedded firewall written in Verilog. It monitors memory access patterns and data inputs to detect rule violations and suspicious signatures. A finite state machine (FSM) manages system behavior by transitioning between `NORMAL`, `ALERT`, `ISOLATE`, and `RECOVER` states. The design includes an ASCII conversion module for violation encoding, intended for future use with logging or monitoring interfaces.

---

## Features

- Rule-based filtering: restricted addresses, write operations, and data patterns
- Pattern-based detection: signature match and repeated data
- FSM-controlled threat handling and isolation
- ASCII encoding of violation status for external use
- Modular Verilog design with clean hierarchy

---

## Module Descriptions

| Module               | Description                                                  |
|----------------------|--------------------------------------------------------------|
| `top_firewall.v`     | Integrates all submodules and handles system connections     |
| `packet_filter.v`    | Flags rule violations |
| `pattern_checker.v`  | Detects signature values and repeated inputs (3× same value)|
| `fsm_firewall.v`     | Controls system state transitions based on violation history |
| `ascii_converter.v`  | Converts detected violation codes into human-readable ASCII characters for use in logging modules, UART output, or debugging interfaces       |
| `tb_top_firewall.v`  | Testbench covering all functional scenarios                  |

---

## Testbench Overview

The testbench (`tb_top_firewall.v`) applies a variety of stimuli to test:

- Clean data inputs (no violation)
- Rule violations (e.g., forbidden write address, known malicious data)
- Pattern violations (signature match, repeated values)
- FSM transitions across all four states

A waveform file (`top_firewall.vcd`) is generated for GTKWave analysis.

## Run Simulation (with Icarus Verilog):

```bash
iverilog -o sim.out testbench/tb_top_firewall.v src/top_firewall.v src/packet_filter.v src/pattern_checker.v src/fsm_firewall.v src/ascii_converter.v 
vvp sim.out
gtkwave top_firewall.vcd
````
---
## File Structure
```bash
.
├── Vivado
├── docs/
│   └── gtkwave.png
│   └── Schematic.png
├── src/
│   ├── top_firewall.v
│   ├── packet_filter.v
│   ├── pattern_checker.v
│   ├── fsm_firewall.v
│   └── ascii_converter.v
├── .gitignore
├── tb_top_firewall.v
├── top_firewall.vcd
├── LICENSE
└── README.md
 
````
---
## FSM Summary

| State               | Meaning                                                  |
|----------------------|--------------------------------------------------------------|
| `NORMAL`     | System idle and operating normally    |
| `ALERT`    | Initial violations detected |
| `ISOLATE`  | Block system access temporarily |
| `RECOVER`     | Waits for clean state before resuming |

---
## Note

The design is simulation-verified on Vivado and Icarus Verilog.

---
## Author

Bhakti Sushant Prabhu Dessai<br>
B.Tech, Electronics and Communication Engineering<br>
NIT Goa<br>

---

## License

This project is licensed under the **MIT License** — see the [LICENSE](./LICENSE) file for details.

You are free to use, modify, and distribute this project, provided that proper credit is given to the author.

---


