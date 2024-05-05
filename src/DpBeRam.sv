`include "clogb2.vh"

module DpBeRam #(
  parameter W = 256,
  parameter D = 64 
)(
  input   logic                   clka,

  input   logic                   ena,
  input   logic[clogb2(D)-1:0]    addra,
  input   logic[(W/8)-1:0]        wea,
  input   logic[W-1:0]            dina,
  output  logic[W-1:0]            douta,

  input   logic                   clkb,

  input   logic                   enb,
  input   logic[clogb2(D)-1:0]    addrb,
  input   logic[(W/8)-1:0]        web,
  input   logic[W-1:0]            dinb,
  output  logic[W-1:0]            doutb
);

// storage
logic[W-1:0] m[D-1:0];

// initialize RAM to 0
initial
  for (int i=0; i<D; i=i+1)
    m[i] = 'h0;

genvar i;
generate

for (i=0; i<(W/8); i=i+1) begin
  always_ff @(posedge clka)
  if (ena) begin: Ma
    if (wea[i])
      m[addra][8*i +: 8] <= dina[8*i +: 8];
  end
end

endgenerate

always_ff @(posedge clka)
if (ena)
  douta <= m[addra];

genvar j;
generate

for (j=0; j<(W/8); j=j+1) begin
  always_ff @(posedge clkb)
  if (enb) begin: Mb
    if (web[j])
      m[addrb][8*j +: 8] <= dinb[8*j +: 8];
  end
end

endgenerate

always_ff @(posedge clkb)
if (enb)
  doutb <= m[addrb];

endmodule

