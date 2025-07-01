class fifo_monitor extends uvm_monitor;

    // Virtual interface to observe
    virtual fifo_if vif;

    // Analysis port to send observed transactions to the scoreboard or others
    uvm_analysis_port #(fifo_transaction) ap;

    // Register with the factory
    `uvm_component_utils(fifo_monitor)

    // Constructor
    function new(string name, uvm_component parent);
        super.new(name, parent);
        ap = new("ap", this);  // Create the analysis port
    endfunction

    // Connect the virtual interface
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if (!uvm_config_db#(virtual fifo_if)::get(this, "", "vif", vif)) begin
            `uvm_fatal("MON", "Virtual interface not found")
        end
    endfunction

    // Main task: sample the interface on every clock and publish transactions
    task run_phase(uvm_phase phase);
        fifo_transaction tx;

        forever begin
            @(posedge vif.clk);

            // If read enable is active, capture the output data
            if (vif.rd_en && !vif.empty) begin
                tx = fifo_transaction::type_id::create("tx");

                // In this case we’re only interested in what comes out of the FIFO
                tx.wr_en = 0;
                tx.rd_en = 1;
                tx.data  = vif.dout;

                // Send the transaction to the scoreboard
                ap.write(tx);
            end
        end
    endtask

endclass