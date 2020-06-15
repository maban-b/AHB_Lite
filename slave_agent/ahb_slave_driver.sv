
class slave_driver extends uvm_driver#(slave_xtn);
`uvm_component_utils(slave_driver)

slave_config	s_cfg;
virtual ahb_if.SDR_MP vif;

extern function new (string name = "slave_driver", uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern function void connect_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);
extern task send_to_dut(slave_xtn);
endclass


function slave_driver::new(string name ="slave_driver", uvm_component parent);
super.new(name,parent);
endfunction 

function void slave_driver::build_phase(uvm_phase phase);
super.build_phase(phase);
if(!uvm_config_db#(slave_config)::get(this,"","slave_config",s_cfg))
`uvm_fatal("failed to get slave_config", "in slave_driver")
endfunction

function void slave_driver::connect_phase(uvm_phase phase);
vif = s_cfg.vif_s;
endfunction 

task slave_driver::run_phase(uvm_phase phase);
super.run_phase(phase);
forever
begin
seq_item_port.get_next_item(req);
send_to_dut(req);
seq_item_port.item_done();
end
endtask

task slave_driver::send_to_dut(slave_xtn xtn);
foreach(xtn.hready[i])
begin
vif.sdr_cb.HREADYOUT <=xtn.hready[i];
@(vif.sdr_cb);
//$display("value of HREADYOUT is %d",xtn.hready[i]);
end
endtask

