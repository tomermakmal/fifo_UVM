class fifo_test extends uvm_test;

    fifo_env env;

    `uvm_component_utils(fifo_test)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    // Build phase: create environment
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        env = fifo_env::type_id::create("env", this);

        // Set virtual interface for driver and monitor via config DB
        virtual fifo_if vif;
        if (!uvm_config_db#(virtual fifo_if)::get(null, "", "vif", vif)) begin
            `uvm_fatal("TEST", "Virtual interface not found")
        end
    endfunction

    // Run phase: start the sequence
    task run_phase(uvm_phase phase);
        fifo_sequence seq;

        phase.raise_objection(this);

        seq = fifo_sequence::type_id::create("seq");
        seq.start(env.seqr);

        phase.drop_objection(this);
    endtask

endclass