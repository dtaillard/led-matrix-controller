`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
//
// Dual-port RAM With Synchronous Read (Read Through)
// Modified from XST v-rams-11
//
//////////////////////////////////////////////////////////////////////////////////

module dual_port_ram_sync
  #(parameter ADDR_WIDTH = 6,
    parameter DATA_WIDTH = 8,
    parameter INIT_FILE = ""
  )
   (input clk, 
    input we,
    input [ADDR_WIDTH-1:0] addr_a,
    input [ADDR_WIDTH-1:0] addr_b,
    input [DATA_WIDTH-1:0] din,
    output [DATA_WIDTH-1:0] dout_a,
    output [DATA_WIDTH-1:0] dout_b
  );
    
    reg [DATA_WIDTH-1:0] ram [2**ADDR_WIDTH-1:0];
    reg [ADDR_WIDTH-1:0] r_addr_a;
    reg [ADDR_WIDTH-1:0] r_addr_b;
    
    initial
    begin
        $readmemh(INIT_FILE, ram);
    end
    
    always @(posedge clk)
    begin
        if (we)
        begin
            ram[addr_a] <= din;
        end
        r_addr_a <= addr_a;
        r_addr_b <= addr_b;
    end
    
    assign dout_a = ram[r_addr_a];
    assign dout_b = ram[r_addr_b];
endmodule
