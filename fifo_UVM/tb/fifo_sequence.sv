class fifo_sequence extends uvm_sequence #(fifo_transaction);

    // Register the sequence with the UVM factory
    `uvm_object_utils(fifo_sequence)

    // Constructor
    function new(string name = "fifo_sequence");
        super.new(name);
    endfunction

    virtual task body();
        fifo_transaction tx;

        // Generate 10 transactions 
        repeat (10) begin
            // Create a new transaction object
            tx = fifo_transaction::type_id::create("tx");

            // Randomize the transaction fields
            if (!tx.randomize()) begin
                `uvm_error("SEQ", "Randomization failed")
            end

            // Send the transaction to the sequencer
            start_item(tx);
            finish_item(tx);
        end
    endtask

endclass