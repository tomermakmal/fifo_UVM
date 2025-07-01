// top.sv
`timescale 1ns/1ps

// Define the FIFO interface
interface fifo_if(input logic clk);
    logic rst;
    logic wr_en;
    logic rd_en;
    logic [7:0] din;
    logic [7:0] dout;
    logic full;
    logic empty;
endinterface

// Top module that instantiates DUT and connects it to the interface
module top;

    // Clock signal
    logic clk;
    // Reset signal
    logic rst;

    // Instantiate the interface with the clock
    fifo_if fifo_if_inst(clk);

    // Instantiate the FIFO DUT
    fifo #(
        .DEPTH(8),
        .WIDTH(8)
    ) dut (
        .clk(clk),
        .rst(rst),
        .wr_en(fifo_if_inst.wr_en),
        .rd_en(fifo_if_inst.rd_en),
        .din(fifo_if_inst.din),
        .dout(fifo_if_inst.dout),
        .full(fifo_if_inst.full),
        .empty(fifo_if_inst.empty)
    );

    // Clock generation: 10ns period (100 MHz)
    initial clk = 0;
    always #5 clk = ~clk;

    // Reset generation
    initial begin
        rst = 1;
        #20;
        rst = 0;
    end

    // Connect reset signal to interface
    assign fifo_if_inst.rst = rst;

    // Set virtual interface for UVM
    initial begin
        // Pass the interface instance to the UVM config DB for all components
        uvm_config_db#(virtual fifo_if)::set(null, "*", "vif", fifo_if_inst);

        // Run the UVM test named "fifo_test"
        run_test("fifo_test");
    end

endmodule