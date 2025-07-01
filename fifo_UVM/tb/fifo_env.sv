class fifo_env extends uvm_env;

    // Components inside the environment
    fifo_driver     drv;
    fifo_sequencer  seqr;
    fifo_monitor    mon;
    fifo_scoreboard sb;

    `uvm_component_utils(fifo_env)

    // Constructor
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    // Build phase: create components
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        drv = fifo_driver::type_id::create("drv", this);
        seqr = fifo_sequencer::type_id::create("seqr", this);
        mon = fifo_monitor::type_id::create("mon", this);
        sb = fifo_scoreboard::type_id::create("sb", this);
    endfunction

    // Connect phase: wire things together
    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);

        // Connect driver to sequencer
        drv.seq_item_port.connect(seqr.seq_item_export);

        // Connect monitor and driver to scoreboard via analysis ports
        mon.ap.connect(sb.rd_imp);
        drv.ap.connect(sb.wr_imp);  // Requires that the driver includes ap (add this if missing)
    endfunction

endclass