class trans_aleatoria extends uvm_sequence;
    `uvm_object_utils(trans_aleatoria)

    int max_retardo = 10;

    function new(name = "trans_aleatoria");
        super.new(name);
    endfunction

    virtual task body();
        trans_fifo item = trans_fifo::type_id::create("item");
        start_item(item);
        if(item.randomize()) begin
            `uvm_error("No randomized", $sformatf("\nUnable to randomize seq_item"));
        end
        item.max_retardo = max_retardo;
        `uvm_info("SEQ", $sformatf("\nNew item: \n %s", item.sprint()), UVM_MEDIUM)
        finish_item(item);
    endtask

endclass

class sec_trans_aleatorias extends uvm_sequence;
    `uvm_object_utils(sec_trans_aleatorias)

    int num_transacciones = 2;
    int max_retardo = 10;

    function new(name = "sec_trans_aleatorias");
        super.new(name);
    endfunction

    virtual task body();
        for(int i = 0; i<num_transacciones; i++) begin
            trans_fifo item = trans_fifo::type_id::create("item");
            start_item(item);
            if(item.randomize()) begin
                `uvm_error("No randomized", $sformatf("\nUnable to randomize seq_item"));
            end
            item.max_retardo = max_retardo;
            `uvm_info("SEQ", $sformatf("\nNew item: \n %s", item.sprint()), UVM_MEDIUM)
            finish_item(item);
        end
    endtask

endclass


class trans_especifica extends uvm_sequence;
    `uvm_object_utils(trans_especifica)

    tipo_trans tpo_spec;
    bit [width-1:0] dto_spec;
    int ret_spec;

    function new(name = "trans_especifica");
        super.new(name);
    endfunction

    virtual task body();
        trans_fifo item = trans_fifo::type_id::create("item");
        start_item(item);
        item.tipo = this.tpo_spec;
        item.dato = this.dto_spec;
        item.retardo = this.ret_spec;
        `uvm_info("SEQ", $sformatf("\nNew item: \n %s", item.sprint()), UVM_MEDIUM)
        finish_item(item);
    endtask

endclass

class llenado_aleatorio extends uvm_sequence;
    `uvm_object_utils(llenado_aleatorio)

    tipo_trans tpo_spec;
    bit [width-1:0] dto_spec;
    int ret_spec;
    int max_retardo = 10;

    function new(name = "llenado_aleatorio");
        super.new(name);
    endfunction

    virtual task body();
        for(int i = 0; i<num_transacciones; i++) begin
            trans_fifo item = trans_fifo::type_id::create("item");
            start_item(item);
            item.max_retardo = max_retardo;
            if(item.randomize()) begin
                `uvm_error("No randomized", $sformatf("\Unable to randomize seq_item"));
            end
            item.tipo = escritura;
            item.retardo = this.ret_spec;
            `uvm_info("SEQ", $sformatf("\nNew item: \n %s", item.sprint()), UVM_MEDIUM)
            finish_item(item);
        end
        for(int i = 0; i<num_transacciones; i++) begin
            trans_fifo item = trans_fifo::type_id::create("item");
            start_item(item);
            if(item.randomize()) begin
                `uvm_error("No randomized", $sformatf("\Unable to randomize seq_item"));
            end
            item.tipo = lectura;
            `uvm_info("SEQ", $sformatf("\nNew item: \n %s", item.sprint()), UVM_MEDIUM)
            finish_item(item);
        end
    endtask

endclass