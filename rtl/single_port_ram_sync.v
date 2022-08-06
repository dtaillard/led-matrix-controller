`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
//
// Single-port RAM With Synchronous Read (Read Through)
// Modified from XST v-rams-07
//
//////////////////////////////////////////////////////////////////////////////////

module single_port_ram_sync
  #(parameter ADDR_WIDTH = 6,
    parameter DATA_WIDTH = 8,
    parameter INIT_FILE = ""
  )
   (input clk, 
    input we,
    input [ADDR_WIDTH-1:0] addr,
    input [DATA_WIDTH-1:0] din,
    output [DATA_WIDTH-1:0] dout
  );
    
    reg [DATA_WIDTH-1:0] ram [2**ADDR_WIDTH-1:0];
    reg [ADDR_WIDTH-1:0] r_addr;
    
    initial
    begin
        $readmemh(INIT_FILE, ram);
    end
    
    always @(posedge clk)
    begin
        if (we)
        begin
            ram[addr] <= din;
        end
        r_addr <= addr;
    end
    
    assign dout = ram[r_addr];
endmodule
