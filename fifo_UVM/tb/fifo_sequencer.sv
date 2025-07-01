class fifo_sequencer extends uvm_sequencer #(fifo_transaction);

    // Register the sequencer with the factory
    `uvm_component_utils(fifo_sequencer)

    // Constructor
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

endclass
