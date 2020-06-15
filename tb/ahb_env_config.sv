

class env_config extends uvm_object;
`uvm_object_utils(env_config)

bit has_magent = 1;
bit has_sagent = 1;
bit has_coverage = 1;

int no_of_master_agents = 1;
int no_of_slave_agents = 1;

master_config m_cfg[];
slave_config  s_cfg[];

extern function new (string name = "env_config");
endclass

function env_config::new (string name = "env_config");
super.new(name);
endfunction