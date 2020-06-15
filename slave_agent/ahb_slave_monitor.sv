class slave_monitor extends uvm_monitor;
`uvm_component_utils(slave_monitor)

slave_config	s_cfg;
virtual ahb_if.SMN_MP vif;
uvm_analysis_port#(slave_xtn) monitor_port;

extern function new (string name = "slave_monitor", uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern function void connect_phase(uvm_phase phase);
extern task run_phase(uvm_phase);
extern task collect_data();
endclass

function slave_monitor::new (string name ="slave_monitor", uvm_component parent);
super.new(name,parent);
endfunction

function void slave_monitor::build_phase(uvm_phase phase);
super.build_phase(phase);
if(!uvm_config_db#(slave_config)::get(this,"","slave_config",s_cfg))
`uvm_fatal("failed to get slave_config", "in slave_monitor")
monitor_port = new("monitor_port",this);
endfunction 

function void slave_monitor::connect_phase(uvm_phase phase);
vif = s_cfg.vif_s;
endfunction 

task slave_monitor::run_phase(uvm_phase phase);
super.run_phase(phase);
forever
collect_data();
endtask

task slave_monitor::collect_data();
slave_xtn data_send;
data_send = slave_xtn::type_id::create("data_send");
@(vif.smn_cb);
wait(!vif.smn_cb.HWRITE&&vif.smn_cb.HTRANS[1])
//begin
$cast(data_send.transfer_type,vif.smn_cb.HTRANS);
data_send.address= vif.smn_cb.HADDR;
data_send.hrdata= vif.smn_cb.HRDATA;
data_send.hreadyout = vif.smn_cb.HREADYOUT;
$cast(data_send.burst_mode, vif.smn_cb.HBURST);
$cast(data_send.data_size,vif.smn_cb.HSIZE);
//data_send.hreadyout = vif.smn_cb.HREADYOUT;
//end
monitor_port.write(data_send);
`uvm_info("randomizing  from slave monitor",$sformatf("the value are %s \n",data_send.sprint),UVM_MEDIUM)
endtask

