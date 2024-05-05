####!/bin/tcsh -f
### 
######!/bin/bash -f
######PROJECT_NAME="tb_fifo"
######set PROJECT_NAME = "tb_fifo"

#------------------------------------------------
rm -rf output
mkdir output

verilator \
    --cc \
    --timescale-override 1ns/1ns \
    --timing \
    --trace-fst \
    --trace-structs \
    --assert \
    --exe versimSV.cpp \
    --Mdir ./output \
    --bbox-unsup \
    \
    tb_fifo.sv \
    axis_data_fifo_0.v \
    axis_data_fifo_v2_0_vl_rfs.v \
    axis_infrastructure_v1_1_vl_rfs.v \
    xpm_fifo.sv \
    xpm_cdc.sv \
    xpm_memory.sv \
    glbl.v \
    \
    -Wno-MULTIDRIVEN \
    -Wno-COMBDLY \
    -Wno-WIDTHTRUNC \
    -Wno-WIDTHEXPAND \
    -Wno-INITIALDLY \
    -Wno-REALCVT \
    -Wno-WIDTHCONCAT \
    -Wno-IMPLICITSTATIC \
    -Wno-MULTITOP


cd output
make -f Vtb_fifo.mk Vtb_fifo

./Vtb_fifo

gtkwave waveform.fst