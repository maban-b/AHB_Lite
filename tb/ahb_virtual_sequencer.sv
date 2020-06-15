

class ahb_virtual_sequencer extends uvm_sequencer#(uvm_sequence_item);
`uvm_component_utils(ahb_virtual_sequencer)

master_sequencer 	ma_sequencer[];
slave_sequencer 	sl_sequencer[];
env_config 			env_cfg;

extern function new (string name = "ahb_virtual_sequencer", uvm_component parent);
extern function void build_phase (uvm_phase phase);
endclass

function ahb_virtual_sequencer::new (string name ="ahb_virtual_sequencer", uvm_component parent);
super.new(name,parent);
endfunction

function void ahb_virtual_sequencer::build_phase(uvm_phase phase);

if(!uvm_config_db#(env_config)::get(this,"","env_config",env_cfg))
`uvm_fatal("failed to get env_config","in ahb_virtual_sequencer")
super.build_phase(phase);
if(env_cfg.has_magent)
ma_sequencer = new[env_cfg.no_of_master_agents];

if(env_cfg.has_sagent)
sl_sequencer = new[env_cfg.no_of_slave_agents];
endfunction