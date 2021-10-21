import uvm_pkg::*;

class base_test extends uvm_test;
    `uvm_component_utils(test)

    function new(string name = "test", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    env e0;
    virtual if_dut vif;

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        e0 = env::type_id::create("e0", this);
		// Se toma interfaz
        if(!uvm_config_db#(virtual if_dut)::get(this, "", "_if", vif))
            `uvm_fatal("Test", "Could not get vif")

        uvm_config_db#(virtual if_dut)::set(this, "e0.agent_inst.*", "_if", vif);
    endfunction
endclass

class test_espec extends base_test;
    `uvm_component_utils(test_espec)
    virtual function void run_phase(uvm_phase phase);
        
    endfunction
endclass