import uvm_pkg::*;

class base_test extends uvm_test;
    `uvm_component_utils(base_test)

    function new(string name = "test", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    env e0;
    virtual fifo_if vif;

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        e0 = env::type_id::create("e0", this);
		// Se toma interfaz
        if(!uvm_config_db#(virtual fifo_if)::get(this, "", "_if", vif))
            `uvm_fatal("Test", "Could not get vif")

        uvm_config_db#(virtual fifo_if)::set(this, "e0.agent_inst.*", "_if", vif);
    endfunction
endclass

class test_espec extends base_test;
    `uvm_component_utils(test_espec)

    int width = 16;

    function new(string name = "test_espec", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
    	super.build_phase(phase);
    endfunction

    virtual task run_phase(uvm_phase phase);
        trans_especifica trans_especifica_inst = trans_especifica::type_id::create("trans_especifica_inst");
        phase.raise_objection(this);

        trans_especifica_inst.ret_spec = 3;
        trans_especifica_inst.ret_spec = 'h55;
        trans_especifica_inst.tpo_spec = escritura;
        trans_especifica_inst.start(e0.agent_inst.sequencer_inst);
        

        trans_especifica_inst.ret_spec = 8;
        trans_especifica_inst.dto_spec = 16'hA;
        trans_especifica_inst.tpo_spec = escritura;
        trans_especifica_inst.start(e0.agent_inst.sequencer_inst);
    
        trans_especifica_inst.ret_spec = 10;
        trans_especifica_inst.dto_spec = 16'hFF;
        trans_especifica_inst.tpo_spec = escritura;
        trans_especifica_inst.start(e0.agent_inst.sequencer_inst);
   
        trans_especifica_inst.ret_spec = 10;
        trans_especifica_inst.tpo_spec = lectura;
        trans_especifica_inst.start(e0.agent_inst.sequencer_inst);

        #1000;
        phase.drop_objection(this);
endtask
endclass
