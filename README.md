# FIFO UVM Verification Environment

This repository contains a simple SystemVerilog FIFO module along with a UVM-based verification environment.

## Project Structure

- `rtl/`  
  Contains the FIFO RTL module (`fifo.sv`).

- `tb/`  
  Contains UVM testbench components: driver, monitor, sequencer, sequence, scoreboard, environment, transactions, and test classes.

- `top.sv`  
  Top-level module that instantiates the FIFO DUT and connects it to the verification interface.

## Features

- Parameterized FIFO module with configurable depth and width.
- UVM verification environment including:
  - Transaction (`fifo_transaction`)
  - Sequence and sequencer
  - Driver and monitor with virtual interface
  - Scoreboard for data checking
  - Test class to run the verification sequence
- Usage of UVM factory and config DB for flexible configuration.
- Clock and reset generation in the top-level.

## How to Run

1. Use a SystemVerilog simulator with UVM support (e.g., QuestaSim, VCS, Xcelium).
2. Compile all RTL and testbench files, including `top.sv`.
3. Run simulation; the UVM testbench will automatically run the `fifo_test`.
4. Check simulation log for scoreboard results and UVM reports.

## Notes

- This is a learning project designed to demonstrate a basic UVM environment.
- You can extend the sequences, add coverage, and enhance the scoreboard for more thorough verification.

## License

This project is open for personal and educational use.

---

Feel free to open issues or submit pull requests for improvements!
