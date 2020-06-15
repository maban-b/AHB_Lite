

class master_monitor extends uvm_monitor;
`uvm_component_utils(master_monitor)

virtual ahb_if.MMN_MP vif;
master_config m_cfg;
uvm_analysis_port #(master_xtn) monitor_port;

extern function new (string name ="master_monitor", uvm_component parent);
extern function void build_phase (uvm_phase phase);
extern function void connect_phase (uvm_phase phase);
extern task run_phase (uvm_phase phase);
extern task collect_data();

endclass

function master_monitor::new (string name = "master_monitor", uvm_component parent);
super.new(name,parent);
	monitor_port = new("monitor_port",this);
endfunction 

function void master_monitor::build_phase (uvm_phase phase);
super.build_phase(phase);
if(!uvm_config_db#(master_config)::get(this,"","master_config",m_cfg))
`uvm_fatal("failed to get master_config","in master_monitor")
endfunction

function void master_monitor::connect_phase(uvm_phase phase);
vif = m_cfg.vif_m;
endfunction

task master_monitor::run_phase(uvm_phase phase);
super.run_phase(phase);
forever 
collect_data();
endtask

task master_monitor::collect_data();
master_xtn data_sent;
data_sent = master_xtn::type_id::create("data_sent");
data_sent.transfer_type=new[1];
data_sent.address = new [1];
data_sent.hwdata = new[1];

@(vif.mmn_cb);
wait(vif.mmn_cb.HREADYOUT)
//begin
$cast(data_sent.transfer_type[0],vif.mmn_cb.HTRANS);
data_sent.address[0]= vif.mmn_cb.HADDR;
data_sent.hwdata[0]= vif.mmn_cb.HWDATA;
$cast(data_sent.read_write,vif.mmn_cb.HWRITE);
$cast(data_sent.burst_mode,vif.mmn_cb.HBURST);
$cast(data_sent.data_size,vif.mmn_cb.HSIZE);

//end
monitor_port.write(data_sent);
`uvm_info("randomizing write from single address class",$sformatf("the value are %s \n",data_sent.sprint),UVM_MEDIUM)
`uvm_info("master_monitor",$sformatf("the value are %d \n",vif.mmn_cb.HWRITE),UVM_MEDIUM)
`uvm_info("master_monitor",$sformatf("the of transfer is  are %d \n",vif.mmn_cb.HTRANS),UVM_LOW)
`uvm_info("master_monitor",$sformatf("the of transfer is  are %d \n",data_sent.transfer_type[0]),UVM_LOW)
endtask
