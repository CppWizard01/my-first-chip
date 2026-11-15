module tt_um_my_first_chip (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

    // Tie off the bidirectional IOs since we aren't using them
    assign uio_out = 8'b0;
    assign uio_oe  = 8'b0;

    // Registers to hold our current count and clock division
    reg [25:0] clk_div;
    reg [3:0]  counter;

    // 1. The Clock Divider and Counter
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // When reset is pressed, clear everything to 0
            clk_div <= 0;
            counter <= 0;
        end else begin
            // 50,000,000 clock cycles = 1 second at 50MHz
            if (clk_div == 50_000_000 - 1) begin
                clk_div <= 0;
                
                // Count from 0 to 9, then loop back
                if (counter == 9)
                    counter <= 0;
                else
                    counter <= counter + 1;
            end else begin
                clk_div <= clk_div + 1;
            end
        end
    end

    // 2. The 7-Segment Decoder
    // Maps the 4-bit counter to the 8 output pins (dot, g, f, e, d, c, b, a)
    reg [7:0] seg_out;
    always @(*) begin
        case (counter)
            4'd0: seg_out = 8'b0011_1111;
            4'd1: seg_out = 8'b0000_0110;
            4'd2: seg_out = 8'b0101_1011;
            4'd3: seg_out = 8'b0100_1111;
            4'd4: seg_out = 8'b0110_0110;
            4'd5: seg_out = 8'b0110_1101;
            4'd6: seg_out = 8'b0111_1101;
            4'd7: seg_out = 8'b0000_0111;
            4'd8: seg_out = 8'b0111_1111;
            4'd9: seg_out = 8'b0110_1111;
            default: seg_out = 8'b0000_0000;
        endcase
    end

    // Send the decoded signals to the actual output pins
    assign uo_out = seg_out;

endmodule