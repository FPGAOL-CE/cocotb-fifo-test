-- Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
-- Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2023.2 (win64) Build 4029153 Fri Oct 13 20:14:34 MDT 2023
-- Date        : Sun Apr  7 14:32:00 2024
-- Host        : DESKTOP-8O6FINE running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode synth_stub
--               c:/Users/Armin/Desktop/MIPI_CSI_VHDL111222+HDMI/MIPI_CSI_VHDL/MIPI_CSI_VHDL.gen/sources_1/ip/axis_data_fifo_0/axis_data_fifo_0_stub.vhdl
-- Design      : axis_data_fifo_0
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7a100tcsg324-2
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity axis_data_fifo_0 is
  Port ( 
    s_axis_aresetn : in STD_LOGIC;
    s_axis_aclk : in STD_LOGIC;
    s_axis_tvalid : in STD_LOGIC;
    s_axis_tready : out STD_LOGIC;
    s_axis_tdata : in STD_LOGIC_VECTOR ( 23 downto 0 );
    m_axis_aclk : in STD_LOGIC;
    m_axis_tvalid : out STD_LOGIC;
    m_axis_tready : in STD_LOGIC;
    m_axis_tdata : out STD_LOGIC_VECTOR ( 23 downto 0 );
    axis_rd_data_count : out STD_LOGIC_VECTOR ( 31 downto 0 )
  );

end axis_data_fifo_0;

architecture stub of axis_data_fifo_0 is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "s_axis_aresetn,s_axis_aclk,s_axis_tvalid,s_axis_tready,s_axis_tdata[23:0],m_axis_aclk,m_axis_tvalid,m_axis_tready,m_axis_tdata[23:0],axis_rd_data_count[31:0]";
attribute X_CORE_INFO : string;
attribute X_CORE_INFO of stub : architecture is "axis_data_fifo_v2_0_11_top,Vivado 2023.2";
begin
end;
