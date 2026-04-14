# Verification Mini Project

This repository contains my VLSI III SP26 verification mini-project work for
`bsg_serial_in_parallel_out_dynamic` from BaseJump STL.

## DUT

The design under test is:

- `basejump_stl/bsg_dataflow/bsg_serial_in_parallel_out_dynamic.sv`

This module accepts a serial stream of input words and assembles them into a
parallel output packet. The packet length is provided on the first word.

## Repository Contents

- `bsg_serial_in_parallel_out_dynamic/testbench.py`
  Cocotb starter testbench.
- `bsg_serial_in_parallel_out_dynamic/bsg_serial_in_parallel_out_dynamic_wrapper.sv`
  SystemVerilog wrapper used as the top-level module for simulation.
- `bsg_serial_in_parallel_out_dynamic/bsg_serial_in_parallel_out_dynamic_cov.sv`
  Functional coverage file.
- `bsg_serial_in_parallel_out_dynamic/Makefile`
  Simulation makefile for cocotb.

## Notes

- The local `basejump_stl` clone is intentionally ignored by git.
- This repository is focused on the verification environment and coverage work,
  not on vendoring the full upstream BaseJump STL codebase.
