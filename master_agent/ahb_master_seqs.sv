class master_base_seq extends uvm_sequence #(master_xtn);

`uvm_object_utils(master_base_seq)


extern function new (string name="master_base_seq");
endclass

function master_base_seq::new (string name = "master_base_seq");
	super.new(name);
endfunction

class master_reset_seq extends master_base_seq;
`uvm_object_utils(master_reset_seq)

extern function new (string name = "master_reset_seq");
extern task body();
endclass

function master_reset_seq::new(string name = "master_reset_seq");
	super.new(name);
endfunction

task master_reset_seq::body();


begin
	req = master_xtn::type_id::create("req");
	start_item(req);
	req.reset_h.constraint_mode(0);
	assert(req.randomize()with {hresetn==1'b0; burst_mode==SINGLE; });
	`uvm_info("randomizing write from single address class",$sformatf("the value are %s \n",req.sprint),UVM_MEDIUM)
	finish_item(req);
	end
endtask


class master_incr4_seq extends master_base_seq;
`uvm_object_utils(master_incr4_seq)

extern function new (string name = "master_incr4_seq");
extern task body ();
endclass


function master_incr4_seq::new (string name = "master_incr4_seq");
super.new(name);
endfunction 


task master_incr4_seq::body();
	begin
	req = master_xtn::type_id::create("req");
	start_item(req);
	//req.hresetn.constraint_mode(0);
		if(!(req.randomize()with {hresetn==1'b1;burst_mode==INCR4;}))
		begin
		$display("burst_mode is %d", req.burst_mode);
		$display("data_size is %d", req.data_size);
		$display("transfer_type is %p", req.transfer_type);
		end
	finish_item(req);

	end
	endtask
	
	
	
class master_incr8_seq extends master_base_seq;
`uvm_object_utils(master_incr8_seq)

extern function new (string name = "master_incr8_seq");
extern task body ();
endclass


function master_incr8_seq::new (string name = "master_incr8_seq");
super.new(name);
endfunction 


task master_incr8_seq::body();
	begin
	req = master_xtn::type_id::create("req");
	start_item(req);
	//req.hresetn.constraint_mode(0);
		if(!(req.randomize()with {hresetn==1'b1;burst_mode==INCR8;}))
		begin
		$display("burst_mode is %d", req.burst_mode);
		$display("data_size is %d", req.data_size);
		$display("transfer_type is %p", req.transfer_type);
		end
	finish_item(req);

	end
	endtask
	
	
class master_incr16_seq extends master_base_seq;
`uvm_object_utils(master_incr16_seq)

extern function new (string name = "master_incr16_seq");
extern task body ();
endclass


function master_incr16_seq::new (string name = "master_incr16_seq");
super.new(name);
endfunction 


task master_incr16_seq::body();
	begin
	req = master_xtn::type_id::create("req");
	start_item(req);
	//req.hresetn.constraint_mode(0);
		if(!(req.randomize()with {hresetn==1'b1;burst_mode==INCR16;}))
		begin
		$display("burst_mode is %d", req.burst_mode);
		$display("data_size is %d", req.data_size);
		$display("transfer_type is %p", req.transfer_type);
		end
	finish_item(req);

	end
	endtask
	
	

class master_wrap4_seq extends master_base_seq;
`uvm_object_utils(master_wrap4_seq)

extern function new (string name = "master_wrap4_seq");
extern task body ();
endclass


function master_wrap4_seq::new (string name = "master_wrap4_seq");
super.new(name);
endfunction 


task master_wrap4_seq::body();
	begin
	req = master_xtn::type_id::create("req");
	start_item(req);
	//req.hresetn.constraint_mode(0);
		if(!(req.randomize()with {hresetn==1'b1;burst_mode==WRAP4;}))
		begin
		$display("burst_mode is %d", req.burst_mode);
		$display("data_size is %d", req.data_size);
		$display("transfer_type is %p", req.transfer_type);
		end
	finish_item(req);

	end
	endtask
	
	
	
class master_wrap8_seq extends master_base_seq;
`uvm_object_utils(master_wrap8_seq)

extern function new (string name = "master_wrap8_seq");
extern task body ();
endclass


function master_wrap8_seq::new (string name = "master_wrap8_seq");
super.new(name);
endfunction 


task master_wrap8_seq::body();
	begin
	req = master_xtn::type_id::create("req");
	start_item(req);
	//req.hresetn.constraint_mode(0);
		if(!(req.randomize()with {hresetn==1'b1;burst_mode==WRAP8;}))
		begin
		$display("burst_mode is %d", req.burst_mode);
		$display("data_size is %d", req.data_size);
		$display("transfer_type is %p", req.transfer_type);
		end
	finish_item(req);

	end
	endtask
	
	
class master_wrap16_seq extends master_base_seq;
`uvm_object_utils(master_wrap16_seq)

extern function new (string name = "master_wrap16_seq");
extern task body ();
endclass


function master_wrap16_seq::new (string name = "master_wrap16_seq");
super.new(name);
endfunction 


task master_wrap16_seq::body();
	begin
	req = master_xtn::type_id::create("req");
	start_item(req);
	//req.hresetn.constraint_mode(0);
		if(!(req.randomize()with {hresetn==1'b1;burst_mode==WRAP16;}))
		begin
		$display("burst_mode is %d", req.burst_mode);
		$display("data_size is %d", req.data_size);
		$display("transfer_type is %p", req.transfer_type);
		end
	finish_item(req);

	end
	endtask