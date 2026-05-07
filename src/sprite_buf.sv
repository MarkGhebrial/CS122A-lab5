module dp_buffer #(
    parameter DEPTH = 256,
    parameter WIDTH = 16,
    parameter ADDR_W = $clog2(DEPTH)
) (
    input  logic clk,

    // Write port
    input  wire we,
    input  logic [ADDR_W-1:0] waddr,
    input  logic [WIDTH-1:0]  wdata,

    // Read port
    input  logic [ADDR_W-1:0] raddr,
    output logic [WIDTH-1:0]  rdata
);
    logic [WIDTH-1:0] mem [0:DEPTH-1];

    // initial begin
    //     for (int i = 0; i < DEPTH; i = i + 1) begin
    //         mem[i] <= 16'h0000;
    //     end
    // end

    always_ff @(posedge clk) begin
        if (we) begin
            // mem[7] <= 16'h00FF;
            mem[waddr] <= wdata;
        end
        rdata <= mem[raddr];  // synchronous read -> EBR
    end

endmodule