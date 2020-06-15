

class slave_xtn extends uvm_sequence_item;
`uvm_object_utils(slave_xtn)


htransfer_t transfer_type;
hburst_t	 burst_mode;
hsize_t	 data_size;
bit[31:0] address;
bit[31:0] hrdata;
bit hreadyout;
rand bit hready[];

constraint hready_size {hready.size inside {[0:100]};}

extern function new (string name = "slave_xtn");
extern function void do_print(uvm_printer printer);
endclass


function slave_xtn::new (string name = "slave_xtn");
super.new(name);
endfunction

function void slave_xtn::do_print(uvm_printer printer);
super.do_print(printer);
printer.print_string("HTRANS",	this.transfer_type.name());
printer.print_string("HBURST",	this.burst_mode.name());
printer.print_string("HSIZE",	this.data_size.name());
printer.print_field("HADDR",	this.address,		32,	UVM_DEC);
printer.print_field("HRDATA",	this.hrdata,		32,	UVM_DEC);
printer.print_field("HREADYOUT",	this.hreadyout,		1,	UVM_DEC);
endfunction