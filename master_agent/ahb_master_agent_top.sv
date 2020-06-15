

class master_agent_top extends uvm_env;
`uvm_component_utils(master_agent_top)

env_config		env_cfg;
master_config 	m_cfg;
master_agent 	agnth[];

extern function new (string name = "master_agent_top", uvm_component parent);
extern function void build_phase (uvm_phase phase);
extern task run_phase (uvm_phase phase);
endclass

function master_agent_top::new (string name = "master_agent_top", uvm_component parent);
super.new(name,parent);
endfunction 

function void master_agent_top::build_phase(uvm_phase phase);
super.build_phase(phase);
if(!uvm_config_db#(env_config)::get(this,"","env_config",env_cfg))
`uvm_fatal("failed to get env_config", "in master_agent_top")

agnth = new[env_cfg.no_of_master_agents];

foreach(agnth[i])
begin
agnth[i] = master_agent::type_id::create($sformatf("agnth[%0d]",i),this);
uvm_config_db#(master_config)::set(this,$sformatf("agnth[%0d]*",i),"master_config",env_cfg.m_cfg[i]);
end
endfunction

task master_agent_top::run_phase(uvm_phase phase);
uvm_top.print_topology;
endtask
