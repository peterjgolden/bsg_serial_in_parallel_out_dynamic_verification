TOPLEVEL_LANG = verilog
SIM ?= icarus

PWD := $(shell pwd)
BASEJUMP_STL_DIR := $(abspath ../basejump_stl)

VERILOG_SOURCES = \
	$(BASEJUMP_STL_DIR)/bsg_misc/bsg_defines.sv \
	$(BASEJUMP_STL_DIR)/bsg_misc/bsg_counter_clear_up.sv \
	$(BASEJUMP_STL_DIR)/bsg_misc/bsg_dff_reset_en.sv \
	$(BASEJUMP_STL_DIR)/bsg_misc/bsg_dff_en.sv \
	$(BASEJUMP_STL_DIR)/bsg_misc/bsg_decode_with_v.sv \
	$(BASEJUMP_STL_DIR)/bsg_misc/bsg_one_fifo.sv \
	$(BASEJUMP_STL_DIR)/bsg_dataflow/bsg_two_fifo.sv \
	$(BASEJUMP_STL_DIR)/bsg_dataflow/bsg_serial_in_parallel_out_dynamic.sv \
	$(PWD)/bsg_serial_in_parallel_out_dynamic_cov.sv \
	$(PWD)/bsg_serial_in_parallel_out_dynamic_wrapper.sv

TOPLEVEL = bsg_serial_in_parallel_out_dynamic_wrapper
MODULE = testbench

COMPILE_ARGS += -g2012

include $(shell cocotb-config --makefiles)/Makefile.sim
