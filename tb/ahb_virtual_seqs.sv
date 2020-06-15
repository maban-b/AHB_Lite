

class ahb_virtual_sequence extends uvm_sequence#(uvm_sequence_item);
`uvm_object_utils(ahb_virtual_sequence)

master_sequencer		ma_sequencer[];
slave_sequencer			sl_sequencer[];
ahb_virtual_sequencer	v_sequencer;
env_config				env_cfg;

master_reset_seq		master_reset_txn;
master_incr4_seq		master_incr4_txn;
master_incr8_seq		master_incr8_txn;
master_incr16_seq		master_incr16_txn;
master_wrap4_seq		master_wrap4_txn;
master_wrap8_seq		master_wrap8_txn;
master_wrap16_seq		master_wrap16_txn;
slave_test_seq			slave_test_txn;

extern function new (string name = "ahb_virtual_sequence");
extern task body(); 

endclass

function ahb_virtual_sequence::new (string name = "ahb_virtual_sequence");
super.new(name);
endfunction

task ahb_virtual_sequence::body();
if(!uvm_config_db#(env_config)::get(null,get_full_name(),"env_config",env_cfg))
`uvm_fatal("failed to get env_config","in virtual_sequence")


if (env_cfg.has_magent)
ma_sequencer = new[env_cfg.no_of_master_agents];

if(env_cfg.has_sagent)
sl_sequencer = new[env_cfg.no_of_slave_agents];

if(!$cast(v_sequencer,m_sequencer))
`uvm_error("failed to cast","v_sequencer with m_sequenecr")

foreach(ma_sequencer[i])
 ma_sequencer[i] = v_sequencer.ma_sequencer[i] ;

foreach(sl_sequencer[i])
 sl_sequencer[i] = v_sequencer.sl_sequencer[i];

endtask

class ahb_reset_seq extends ahb_virtual_sequence;
`uvm_object_utils(ahb_reset_seq)

extern function new (string name ="ahb_reset_seq");
extern task body();
endclass

function ahb_reset_seq::new (string name ="ahb_reset_seq");
super.new(name);
endfunction

task ahb_reset_seq::body();
super.body();
master_reset_txn = master_reset_seq::type_id::create("master_reset_txn");
if(env_cfg.has_magent)
begin
for (int i=0; i<env_cfg.no_of_master_agents;i++)
master_reset_txn.start(ma_sequencer[i]);
end


endtask


class ahb_incr4_seq extends ahb_virtual_sequence;
`uvm_object_utils(ahb_incr4_seq)

extern function new (string name ="ahb_incr4_seq");
extern task body();
endclass

function ahb_incr4_seq::new (string name ="ahb_incr4_seq");
super.new(name);
endfunction

task ahb_incr4_seq::body();
super.body();
master_incr4_txn = master_incr4_seq::type_id::create("master_incr4_txn");
if(env_cfg.has_magent)
begin
for (int i=0; i<env_cfg.no_of_master_agents;i++)
master_incr4_txn.start(ma_sequencer[i]);
end


endtask


class ahb_incr8_seq extends ahb_virtual_sequence;
`uvm_object_utils(ahb_incr8_seq)

extern function new (string name ="ahb_incr8_seq");
extern task body();
endclass

function ahb_incr8_seq::new (string name ="ahb_incr8_seq");
super.new(name);
endfunction

task ahb_incr8_seq::body();
super.body();
master_incr8_txn = master_incr8_seq::type_id::create("master_incr8_txn");
if(env_cfg.has_magent)
begin
for (int i=0; i<env_cfg.no_of_master_agents;i++)
master_incr8_txn.start(ma_sequencer[i]);
end


endtask


class ahb_incr16_seq extends ahb_virtual_sequence;
`uvm_object_utils(ahb_incr16_seq)

extern function new (string name ="ahb_incr16_seq");
extern task body();
endclass

function ahb_incr16_seq::new (string name ="ahb_incr16_seq");
super.new(name);
endfunction

task ahb_incr16_seq::body();
super.body();
master_incr16_txn = master_incr16_seq::type_id::create("master_incr16_txn");
if(env_cfg.has_magent)
begin
for (int i=0; i<env_cfg.no_of_master_agents;i++)
master_incr16_txn.start(ma_sequencer[i]);
end


endtask




class ahb_wrap4_seq extends ahb_virtual_sequence;
`uvm_object_utils(ahb_wrap4_seq)

extern function new (string name ="ahb_wrap4_seq");
extern task body();
endclass

function ahb_wrap4_seq::new (string name ="ahb_wrap4_seq");
super.new(name);
endfunction

task ahb_wrap4_seq::body();
super.body();
master_wrap4_txn = master_wrap4_seq::type_id::create("master_wrap4_txn");
if(env_cfg.has_magent)
begin
for (int i=0; i<env_cfg.no_of_master_agents;i++)
master_wrap4_txn.start(ma_sequencer[i]);
end


endtask


class ahb_wrap8_seq extends ahb_virtual_sequence;
`uvm_object_utils(ahb_wrap8_seq)

extern function new (string name ="ahb_wrap8_seq");
extern task body();
endclass

function ahb_wrap8_seq::new (string name ="ahb_wrap8_seq");
super.new(name);
endfunction

task ahb_wrap8_seq::body();
super.body();
master_wrap8_txn = master_wrap8_seq::type_id::create("master_wrap8_txn");
if(env_cfg.has_magent)
begin
for (int i=0; i<env_cfg.no_of_master_agents;i++)
master_wrap8_txn.start(ma_sequencer[i]);
end


endtask


class ahb_wrap16_seq extends ahb_virtual_sequence;
`uvm_object_utils(ahb_wrap16_seq)

extern function new (string name ="ahb_wrap16_seq");
extern task body();
endclass

function ahb_wrap16_seq::new (string name ="ahb_wrap16_seq");
super.new(name);
endfunction

task ahb_wrap16_seq::body();
super.body();
master_wrap16_txn = master_wrap16_seq::type_id::create("master_wrap16_txn");
if(env_cfg.has_magent)
begin
for (int i=0; i<env_cfg.no_of_master_agents;i++)
master_wrap16_txn.start(ma_sequencer[i]);
end


endtask