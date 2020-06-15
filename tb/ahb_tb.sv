

class ahb_tb extends uvm_env;
`uvm_component_utils(ahb_tb) 

master_agent_top	m_agent_toph;
slave_agent_top		s_agent_toph;
env_config			env_cfg;
ahb_coverage 		ahb_cvg;
ahb_virtual_sequencer		v_sequencer;

extern function new (string name = "ahb_tb", uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern function void connect_phase(uvm_phase phase);
endclass

function ahb_tb::new(string name = "ahb_tb", uvm_component parent);
super.new(name,parent);
endfunction


function void ahb_tb::build_phase(uvm_phase phase);
//super.build_phase(phase);

if(!uvm_config_db#(env_config)::get(this,"","env_config",env_cfg))
`uvm_fatal("failed to get env_config","in ahb_tb")

if(env_cfg.has_magent)
m_agent_toph=master_agent_top::type_id::create("m_agent_toph",this);

if(env_cfg.has_sagent)
s_agent_toph=slave_agent_top::type_id::create("s_agent_toph",this);

v_sequencer=ahb_virtual_sequencer::type_id::create("v_sequencer",this);
ahb_cvg = ahb_coverage::type_id::create("ahb_cvg",this);
endfunction

function void ahb_tb::connect_phase(uvm_phase phase);

foreach(v_sequencer.ma_sequencer[i])
v_sequencer.ma_sequencer[i] = m_agent_toph.agnth[i].m_sequencer;

foreach(v_sequencer.sl_sequencer[i])
v_sequencer.sl_sequencer[i] = s_agent_toph.agnth[i].m_sequencer;

foreach(v_sequencer.ma_sequencer[i])
m_agent_toph.agnth[i].monh.monitor_port.connect(ahb_cvg.analysis_export);

endfunction