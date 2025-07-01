class fifo_scoreboard extends uvm_component;

    // Analysis imports to receive transactions from driver and monitor
    uvm_analysis_imp #(fifo_transaction, fifo_scoreboard) wr_imp;
    uvm_analysis_imp #(fifo_transaction, fifo_scoreboard) rd_imp;

    // Queues to store written and read data
    fifo_transaction wr_queue[$];
    fifo_transaction rd_queue[$];

    `uvm_component_utils(fifo_scoreboard)

    function new(string name, uvm_component parent);
        super.new(name, parent);
        wr_imp = new("wr_imp", this);
        rd_imp = new("rd_imp", this);
    endfunction

    // Called when driver sends a write transaction
    function void write(fifo_transaction t);
        // Distinguish which port sent this — write or read
        if (t.wr_en && !t.rd_en) begin
            wr_queue.push_back(t);
        end else if (!t.wr_en && t.rd_en) begin
            rd_queue.push_back(t);
            compare();
        end
    endfunction

    // Compare the next read data to the next written data
    function void compare();
        if (wr_queue.size() == 0) begin
            `uvm_error("SCOREBOARD", "Read transaction received but write queue is empty!")
            return;
        end

        fifo_transaction expected = wr_queue.pop_front();
        fifo_transaction actual   = rd_queue.pop_front();

        if (expected.data !== actual.data) begin
            `uvm_error("SCOREBOARD", $sformatf("Mismatch! Expected: %0h, Got: %0h", expected.data, actual.data))
        end else begin
            `uvm_info("SCOREBOARD", $sformatf("PASS: %0h == %0h", expected.data, actual.data), UVM_LOW)
        end
    endfunction

endclass