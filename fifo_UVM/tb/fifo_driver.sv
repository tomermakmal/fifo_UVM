class fifo_driver extends uvm_driver #(fifo_transaction);

    // Virtual interface to the DUT
    virtual fifo_if vif;

    // Analysis port to send write transactions to the scoreboard
    uvm_analysis_port #(fifo_transaction) ap;

    // Register the component
    `uvm_component_utils(fifo_driver)

    // Constructor
    function new(string name, uvm_component parent);
        super.new(name, parent);
        ap = new("ap", this);  // Create the analysis port
    endfunction

    // Get virtual interface from config
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if (!uvm_config_db#(virtual fifo_if)::get(this, "", "vif", vif)) begin
            `uvm_fatal("DRV", "Virtual interface not found")
        end
    endfunction

    // Main run logic
    task run_phase(uvm_phase phase);
        fifo_transaction tx;

        forever begin
            // Get next transaction from sequencer
            seq_item_port.get_next_item(tx);

            // Drive transaction to the DUT
            vif.wr_en <= tx.wr_en;
            vif.rd_en <= tx.rd_en;
            vif.din   <= tx.data;

            // Wait for one clock cycle
            @(posedge vif.clk);

            // Clear control signals
            vif.wr_en <= 0;
            vif.rd_en <= 0;

            // Send transaction to scoreboard if it's a write
            if (tx.wr_en && !tx.rd_en)
                ap.write(tx);

            // Notify sequencer that we're done
            seq_item_port.item_done();
        end
    endtask

endclass