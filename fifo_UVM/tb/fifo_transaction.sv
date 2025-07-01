class fifo_transaction extends uvm_sequence_item;

    // These fields will be randomized during simulation
    rand bit wr_en;         // Write enable signal
    rand bit rd_en;         // Read enable signal
    rand bit [7:0] data;    // Data to be written into the FIFO

    // Register this class with the UVM factory
    `uvm_object_utils(fifo_transaction)

    // Constructor
    function new(string name = "fifo_transaction");
        super.new(name);
    endfunction

    function void do_print(uvm_printer printer);
        super.do_print(printer);
        printer.print_field_int("wr_en", wr_en, 1);
        printer.print_field_int("rd_en", rd_en, 1);
        printer.print_field_int("data", data, 8);
    endfunction

endclass