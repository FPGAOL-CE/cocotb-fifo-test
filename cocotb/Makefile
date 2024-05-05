#
# Authored by: Robert Metchev / Chips & Scripts (rmetchev@ieee.org)
#
# CERN Open Hardware Licence Version 2 - Permissive
#
# Copyright (C) 2024 Robert Metchev
#

SHELL=/bin/bash
# defaults
SIM ?= verilator
#SIM ?= icarus
export SIM := $(SIM)

TOPLEVEL_LANG ?= verilog

SRC := $(realpath ../src)

VERILOG_SOURCES += \
        $(SRC)/axis_data_fifo_0.sv \
        $(SRC)/afifo.v \
        $(SRC)/DpBeRam.sv

VERILOG_INCLUDE_DIRS += $(SRC)

ifeq ($(SIM),verilator)
        EXTRA_ARGS += --no-timing
        ifeq ($(WAVES),1)
                EXTRA_ARGS += --trace --trace-structs --trace-fst
        endif
        WNO = fatal WIDTHTRUNC WIDTHEXPAND ASCRANGE EOFNEWLINE PINCONNECTEMPTY DECLFILENAME GENUNNAMED VARHIDDEN UNUSEDPARAM
        EXTRA_ARGS += -Wall $(WNO:%=-Wno-%)
endif
ifeq ($(SIM),icarus)
        COMPILE_ARGS += -DICARUS
        COMPILE_ARGS += -Wall
        #COMPILE_ARGS += -g2005-sv
endif

# Convert Xs for now
export COCOTB_RESOLVE_X := ZEROS    

# TOPLEVEL is the name of the toplevel module in your Verilog or VHDL file
TOPLEVEL = axis_data_fifo_0

# MODULE is the basename of the Python test file
MODULE = test_fifo
export PYTHONPATH := $(realpath .)

# include cocotb's make rules to take care of the simulator setup
include $(shell cocotb-config --makefiles)/Makefile.sim

g gtkwave:
ifeq ($(SIM),icarus)
	gtkwave sim_build/$(TOPLEVEL).fst
endif
ifeq ($(SIM),verilator)
	gtkwave dump.fst -o # -a 1.gtkw
endif

clean::
	rm -rf __pycache__ results.xml
	rm -rf dump.vcd dump.vcd.fst dump.vcd.fst.hier 
	rm -rf transcript modelsim.ini vsim.wlf vsim_stacktrace.vstf vish_stacktrace.vstf
