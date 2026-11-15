`ifndef SIM
// Synthesis tools need to know the ports exist, but shouldn't look inside.
(* blackbox *)
module RM_IHPSG13_1P_1024x32_c2_bm_bist (
    input A_CLK, input A_MEN, input A_WEN, input A_REN,
    input [9:0] A_ADDR, input [31:0] A_DIN, input A_DLY,
    output [31:0] A_DOUT, input [31:0] A_BM,
    input A_BIST_CLK, input A_BIST_EN, input A_BIST_MEN,
    input A_BIST_WEN, input A_BIST_REN, input [9:0] A_BIST_ADDR,
    input [31:0] A_BIST_DIN, input [31:0] A_BIST_BM
);
endmodule
`endif

module tt_um_my_first_chip (
    input  wire [7:0] ui_in,
    output wire [7:0] uo_out,
    input  wire [7:0] uio_in,
    output wire [7:0] uio_out,
    output wire [7:0] uio_oe,
    input  wire       ena,
    input  wire       clk,
    input  wire       rst_n
);
    assign uio_out = 8'b0;
    assign uio_oe  = 8'b0;

    wire [31:0] sram_dout;

    // Instantiate the 4KB IHP SRAM Macro
    RM_IHPSG13_1P_1024x32_c2_bm_bist i_sram (
        .A_CLK       (clk),
        .A_MEN       (ena),          // enable when chip is selected
        .A_WEN       (ui_in[0]),     // use pin 0 for write enable
        .A_REN       (!ui_in[0]),    // read when not writing
        .A_ADDR      ({2'b00, ui_in[7:0]}), // padded to 10 bits
        .A_DIN       ({24'b0, ui_in}),      // write inputs to memory
        .A_DLY       (1'b1),         
        .A_DOUT      (sram_dout),
        .A_BM        (32'hFFFFFFFF), // Write all bits
        .A_BIST_CLK  (1'b0),
        .A_BIST_EN   (1'b0),         
        .A_BIST_MEN  (1'b0),
        .A_BIST_WEN  (1'b0),
        .A_BIST_REN  (1'b0),
        .A_BIST_ADDR (10'h0),        // padded to 10 bits
        .A_BIST_DIN  (32'h0),
        .A_BIST_BM   (32'h0)
    );

    // Send the lowest 8 bits of SRAM data to the output pins
    assign uo_out = sram_dout[7:0];
endmodule