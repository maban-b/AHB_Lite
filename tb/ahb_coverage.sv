
class ahb_coverage extends uvm_subscriber#(master_xtn);
`uvm_component_utils(ahb_coverage)

env_config env_cfg;
master_xtn cov_xtn;
master_xtn cov_data;

real cov;

//uvm_tlm_analysis_fifo #(master_xtn) fifo_cvgh;

covergroup ahb_cvg;
	option.per_instance=1;
		Wr_rd     : coverpoint cov_data.read_write {
			bins write = {1};
			bins read  = {0};
			}
		burst_seq	: coverpoint cov_data.transfer_type[0] {
		
			bins addr_4  = (NONSEQ => SEQ[->3]=>IDLE);
			bins addr_8  = (NONSEQ => SEQ[->7]=>IDLE);
			bins addr_16 = (NONSEQ => SEQ[->15]=>IDLE);
		}
		burst_type	: coverpoint cov_data.burst_mode {
			bins incr = {INCR4,INCR8,INCR16};
			bins wrap = {WRAP4,WRAP8,WRAP16};
		}
		data_size  : coverpoint cov_data.data_size {
			bins d_byte = {BYTE};
			bins d_halfword = {HALFWORD};
			bins d_word = {WORD};
		}
		
	burst : cross burst_seq , burst_type , data_size;
		
		
endgroup

extern function new (string name = "ahb_coverage" , uvm_component parent);
//extern  task run_phase(uvm_phase phase);
extern function void write (master_xtn t);
extern function void extract_phase (uvm_phase phase);
extern function void report_phase (uvm_phase phase);

endclass

function ahb_coverage::new (string name = "ahb_coverage", uvm_component parent);
super.new (name,parent);
cov_data = master_xtn::type_id::create("cov_data");
if (!uvm_config_db#(env_config)::get(this,"","env_config",env_cfg))
`uvm_fatal("failed to get env_config", "in ahbcoverage")
if (env_cfg.has_coverage)
begin
ahb_cvg = new();
end
endfunction 

/*
task ahb_coverage::run_phase(uvm_phase phase);

forever
begin
write(cov_xtn);
end

endtask
*/
function void ahb_coverage::write(master_xtn t);
                cov_data = t;
				`uvm_info(get_type_name(),$sformatf("value of burst mode is %d",cov_data.burst_mode),UVM_LOW)
                ahb_cvg.sample();
endfunction


function void ahb_coverage::extract_phase (uvm_phase phase);
 cov = ahb_cvg.get_coverage();
endfunction

function void ahb_coverage::report_phase (uvm_phase phase);
 `uvm_info(get_type_name(), $sformatf("Coverage is: %f", cov), UVM_LOW)
endfunction
