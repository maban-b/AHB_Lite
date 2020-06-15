

class ahb_base_test extends uvm_test;
`uvm_component_utils(ahb_base_test)

ahb_tb envh;
env_config env_cfg;

master_config m_cfg[];
slave_config  s_cfg[];

bit has_magent = 1;
bit has_sagent = 1;

int no_of_master_agents = 1;
int no_of_slave_agents  = 1;



extern function new (string name = "ahb_base_test" , uvm_component parent);
extern function void build_phase (uvm_phase phase);
//extern task config_ahb();
endclass

function ahb_base_test::new (string name = "ahb_base_test" , uvm_component parent);
super.new(name,parent);
endfunction 

function void ahb_base_test::build_phase(uvm_phase phase);

env_cfg = env_config::type_id::create("env_cfg");

if(has_magent)
m_cfg = new[no_of_master_agents];
env_cfg.m_cfg = new[no_of_master_agents];

foreach(m_cfg[i])
begin
m_cfg[i] = master_config::type_id::create($sformatf("m_cfg[%0d]",i));
m_cfg[i].is_active = UVM_ACTIVE;
if(!uvm_config_db#(virtual ahb_if)::get(this,"","vif",m_cfg[i].vif_m))
`uvm_fatal("failed to get","interface details in vtest")
`uvm_info("the values is ", $sformatf("%s",m_cfg[i].is_active),UVM_LOW)
env_cfg.m_cfg[i] = m_cfg[i];
end


if(has_sagent)

s_cfg = new[no_of_slave_agents];
env_cfg.s_cfg = new[no_of_slave_agents];

foreach(s_cfg[i])
begin
s_cfg[i] = slave_config::type_id::create($sformatf("s_cfg[%0d]",i));
s_cfg[i].is_active = UVM_ACTIVE;
if(!uvm_config_db#(virtual ahb_if)::get(this,"","vif",s_cfg[i].vif_s))
`uvm_fatal("failed to get","interface details in vtest")
`uvm_info("the values is ", $sformatf("%s",s_cfg[i].is_active),UVM_LOW)
env_cfg.s_cfg[i]=s_cfg[i];
end




uvm_config_db#(env_config)::set(this,"*","env_config",env_cfg);
super.build_phase(phase);
envh = ahb_tb::type_id::create("envh",this);
endfunction



class ahb_reset_test extends ahb_base_test;
`uvm_component_utils(ahb_reset_test)

ahb_reset_seq ahb_seqh;

extern function new (string name = "ahb_reset_test", uvm_component parent);
extern function void build_phase (uvm_phase phase);
extern task run_phase (uvm_phase phase);
endclass


function ahb_reset_test::new (string name = "ahb_reset_test" , uvm_component parent);
super.new(name,parent);
endfunction

function void ahb_reset_test::build_phase (uvm_phase phase);
super.build_phase(phase);
//m_trans = master_transaction::type_id::create("m_trans");
endfunction

task ahb_reset_test::run_phase (uvm_phase phase);


	phase.raise_objection(this);
	ahb_seqh= ahb_reset_seq::type_id::create("ahb_seqh");
	ahb_seqh.start(envh.v_sequencer);
	phase.drop_objection(this);
	
	endtask



class ahb_incr4_test extends ahb_base_test;
`uvm_component_utils(ahb_incr4_test)

ahb_incr4_seq ahb_seqh;

extern function new (string name = "ahb_incr4_test", uvm_component parent);
extern function void build_phase (uvm_phase phase);
extern task run_phase (uvm_phase phase);
endclass


function ahb_incr4_test::new (string name = "ahb_incr4_test" , uvm_component parent);
super.new(name,parent);
endfunction

function void ahb_incr4_test::build_phase (uvm_phase phase);
super.build_phase(phase);
//m_trans = master_transaction::type_id::create("m_trans");
endfunction

task ahb_incr4_test::run_phase (uvm_phase phase);


	phase.raise_objection(this);
	ahb_seqh= ahb_incr4_seq::type_id::create("ahb_seqh");
	ahb_seqh.start(envh.v_sequencer);
	phase.drop_objection(this);
	
	endtask



class ahb_incr8_test extends ahb_base_test;
`uvm_component_utils(ahb_incr8_test)

ahb_incr8_seq ahb_seqh;

extern function new (string name = "ahb_incr8_test", uvm_component parent);
extern function void build_phase (uvm_phase phase);
extern task run_phase (uvm_phase phase);
endclass


function ahb_incr8_test::new (string name = "ahb_incr8_test" , uvm_component parent);
super.new(name,parent);
endfunction

function void ahb_incr8_test::build_phase (uvm_phase phase);
super.build_phase(phase);
//m_trans = master_transaction::type_id::create("m_trans");
endfunction

task ahb_incr8_test::run_phase (uvm_phase phase);


	phase.raise_objection(this);
	ahb_seqh= ahb_incr8_seq::type_id::create("ahb_seqh");
	ahb_seqh.start(envh.v_sequencer);
	phase.drop_objection(this);
	
	endtask
	
	
	
class ahb_incr16_test extends ahb_base_test;
`uvm_component_utils(ahb_incr16_test)

ahb_incr16_seq ahb_seqh;

extern function new (string name = "ahb_incr16_test", uvm_component parent);
extern function void build_phase (uvm_phase phase);
extern task run_phase (uvm_phase phase);
endclass


function ahb_incr16_test::new (string name = "ahb_incr16_test" , uvm_component parent);
super.new(name,parent);
endfunction

function void ahb_incr16_test::build_phase (uvm_phase phase);
super.build_phase(phase);
//m_trans = master_transaction::type_id::create("m_trans");
endfunction

task ahb_incr16_test::run_phase (uvm_phase phase);


	phase.raise_objection(this);
	ahb_seqh= ahb_incr16_seq::type_id::create("ahb_seqh");
	ahb_seqh.start(envh.v_sequencer);
	phase.drop_objection(this);
	
	endtask
	
	
class ahb_wrap4_test extends ahb_base_test;
`uvm_component_utils(ahb_wrap4_test)

ahb_wrap4_seq ahb_seqh;

extern function new (string name = "ahb_wrap4_test", uvm_component parent);
extern function void build_phase (uvm_phase phase);
extern task run_phase (uvm_phase phase);
endclass


function ahb_wrap4_test::new (string name = "ahb_wrap4_test" , uvm_component parent);
super.new(name,parent);
endfunction

function void ahb_wrap4_test::build_phase (uvm_phase phase);
super.build_phase(phase);
//m_trans = master_transaction::type_id::create("m_trans");
endfunction

task ahb_wrap4_test::run_phase (uvm_phase phase);


	phase.raise_objection(this);
	ahb_seqh= ahb_wrap4_seq::type_id::create("ahb_seqh");
	ahb_seqh.start(envh.v_sequencer);
	phase.drop_objection(this);
	
	endtask



class ahb_wrap8_test extends ahb_base_test;
`uvm_component_utils(ahb_wrap8_test)

ahb_wrap8_seq ahb_seqh;

extern function new (string name = "ahb_wrap8_test", uvm_component parent);
extern function void build_phase (uvm_phase phase);
extern task run_phase (uvm_phase phase);
endclass


function ahb_wrap8_test::new (string name = "ahb_wrap8_test" , uvm_component parent);
super.new(name,parent);
endfunction

function void ahb_wrap8_test::build_phase (uvm_phase phase);
super.build_phase(phase);
//m_trans = master_transaction::type_id::create("m_trans");
endfunction

task ahb_wrap8_test::run_phase (uvm_phase phase);


	phase.raise_objection(this);
	ahb_seqh= ahb_wrap8_seq::type_id::create("ahb_seqh");
	ahb_seqh.start(envh.v_sequencer);
	phase.drop_objection(this);
	
	endtask
	
	
	
class ahb_wrap16_test extends ahb_base_test;
`uvm_component_utils(ahb_wrap16_test)

ahb_wrap16_seq ahb_seqh;

extern function new (string name = "ahb_wrap16_test", uvm_component parent);
extern function void build_phase (uvm_phase phase);
extern task run_phase (uvm_phase phase);
endclass


function ahb_wrap16_test::new (string name = "ahb_wrap16_test" , uvm_component parent);
super.new(name,parent);
endfunction

function void ahb_wrap16_test::build_phase (uvm_phase phase);
super.build_phase(phase);
//m_trans = master_transaction::type_id::create("m_trans");
endfunction

task ahb_wrap16_test::run_phase (uvm_phase phase);


	phase.raise_objection(this);
	ahb_seqh= ahb_wrap16_seq::type_id::create("ahb_seqh");
	ahb_seqh.start(envh.v_sequencer);
	phase.drop_objection(this);
	
	endtask