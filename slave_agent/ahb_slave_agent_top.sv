/*
class slave_agent_top extends uvm_env;
`uvm_component_utils(slave_agent_top)

env_config		env_cfg;
slave_config	s_cfg;
slave_agent		agnth[];

extern function new (string name = "slave_agent_top", uvm_component parent);
extern function void build_phase (uvm_phase phase);
endclass

function slave_agent_top::new(string name = "slave_agent_top" , uvm_component parent);
super.new(name,parent);
endfunction 

function void slave_agent_top::build_phase(uvm_phase phase);
super.build_phase(phase);
if(!uvm_config_db#(env_config)::get(this,"","env_config",env_cfg))
`uvm_fatal("failed to get env_config","in slave_agent_top")

agnth = new[env_cfg.no_of_slave_agents];

foreach(agnth[i])
begin
agnth[i] = slave_agent::type_id::create($sformatf("agnth[%0d]",i),this);
uvm_config_db#(slave_config)::set(this,$sformatf("agnth[%0d]*",i),"slave_config",env_cfg.s_cfg[i]);
end
endfunction
*/
class slave_agent_top extends uvm_env;
`uvm_component_utils(slave_agent_top)

env_config		env_cfg;
slave_config 	s_cfg;
slave_agent 	agnth[];

extern function new (string name = "slave_agent_top", uvm_component parent);
extern function void build_phase (uvm_phase phase);
//extern task run_phase (uvm_phase phase);
endclass

function slave_agent_top::new (string name = "slave_agent_top", uvm_component parent);
super.new(name,parent);
endfunction 

function void slave_agent_top::build_phase(uvm_phase phase);
super.build_phase(phase);
if(!uvm_config_db#(env_config)::get(this,"","env_config",env_cfg))
`uvm_fatal("failed to get env_config", "in slave_agent_top")

agnth = new[env_cfg.no_of_slave_agents];

foreach(agnth[i])
begin
agnth[i] = slave_agent::type_id::create($sformatf("agnth[%0d]",i),this);
uvm_config_db#(slave_config)::set(this,$sformatf("agnth[%0d]*",i),"slave_config",env_cfg.s_cfg[i]);
end
endfunction
