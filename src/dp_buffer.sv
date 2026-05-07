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

    always @(posedge clk) begin
        // Write to the memory
        if (we) begin
            // mem[7] <= 16'h00FF;
            mem[waddr] <= wdata;
        end

        // Read from the memory
        if (we && raddr == waddr) begin
            // Update rdata immediately if we're reading and writing from the same address
            rdata <= wdata;
        end else begin
            rdata <= mem[raddr];  // synchronous read -> EB
        end
    end

endmodule