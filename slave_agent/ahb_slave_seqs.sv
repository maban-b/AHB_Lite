class slave_seq_base extends uvm_sequence#(slave_xtn);
`uvm_object_utils(slave_seq_base)

extern function new (string name = "slave_seq_base");
endclass

function slave_seq_base::new(string name = "slave_seq_base");
super.new(name);
endfunction


class slave_test_seq extends slave_seq_base;
`uvm_object_utils(slave_test_seq)

extern function new (string name = "slave_test_seq");
extern task body();
endclass


function slave_test_seq::new (string name = "slave_test_seq");
super.new(name);
endfunction

task slave_test_seq::body();
//super.body();

repeat(10)
begin
	req = slave_xtn::type_id::create("req");
	start_item(req);
	assert(req.randomize());
	finish_item(req);
end
endtask