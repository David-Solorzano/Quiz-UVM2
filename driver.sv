// Driver
class driver extends uvm_driver #(transaction_item);
    `uvm_component_utils(driver)

    uvm_analysis_port #(trans_fifo #(.width(width))) driver_aport;

    virtual fifo_if #(.width(width)) vif;

    function new(string name = "driver", uvm_component parent = null);
        super.new(name, parent);
    endfunction


    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(virtual if_dut)::get(this, "", "_if", vif))
            `uvm_fatal("Driver", "Could not get vif")
    endfunction
	
	// Cada transaccion que recibe
    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
            @(posedge vif.clk);
        vif.rst=1;
        @(posedge vif.clk);
        forever begin
            trans_fifo #(.width(width)) item;
            vif.push = 0;
            vif.rst = 0;
            vif.pop = 0;
            vif.dato_in = 0;
            espera = 0;
            @(posedge vif.clk);
            seq_item_port.get_next_item(item);
            driver_item(item);
	    seq_item_port.item_done();

        end
    endtask
	
	// La señal en base al seq_item
    virtual task driver_item(trans_fifo #(.width(width)) transaction);
        transaction.print("Driver: Transaccion recibida");
        $display("Transacciones pendientes en el mbx agnt_drv = %g",agnt_drv_mbx.num());

        while(espera < transaction.retardo)begin
          @(posedge vif.clk);
          espera = espera+1;
          vif.dato_in = transaction.dato;
	end
        case(transaction.tipo)
	  lectura: begin
	     transaction.dato = vif.dato_out;
	     transaction.tiempo = $time;
	     @(posedge vif.clk);
	     vif.pop = 1;
	     driver_aport.write(transaction);
	     transaction.print("Driver: Transaccion ejecutada");
	   end
	   escritura: begin
	     vif.push = 1;
	     transaction.tiempo = $time;
	     driver_aport.write(transaction); 
	     transaction.print("Driver: Transaccion ejecutada");
	   end
	   reset: begin
	     vif.rst =1;
	     transaction.tiempo = $time;
	     driver_aport.write(transaction); 
	     transaction.print("Driver: Transaccion ejecutada");
	   end
	  default: begin
	    $display("[%g] Driver Error: la transacción recibida no tiene tipo valido",$time);
	    $finish;
	     end 
	    endcase    
	    @(posedge vif.clk);
    endtask
endclass