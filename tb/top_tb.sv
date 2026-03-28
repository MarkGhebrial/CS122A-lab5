`include "src/top.sv"
`default_nettype none

module top_tb;
logic clk;

top 
(
    .clk(clk)
    /** add additional signals */
);

localparam CLK_PERIOD = /** clk period */;
always #(CLK_PERIOD/2) clk=~clk;

initial begin
    $dumpfile("build/top.vcd");
    $dumpvars(0, top_tb);
end

initial begin
    clk<=1'b1;
    #(CLK_PERIOD*3);
    // testbench logic goes below
    $finish;
end

endmodule
`default_nettype wire