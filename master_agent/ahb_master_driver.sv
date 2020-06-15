
class master_driver extends uvm_driver#(master_xtn);
`uvm_component_utils(master_driver)

virtual ahb_if.MDR_MP vif;
master_config m_cfg;

extern function new (string name ="master_driver", uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern function void connect_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);
extern task send_to_dut(master_xtn xtn);
extern task reset();
extern task drive(master_xtn xtn);

endclass

function master_driver::new (string name ="master_driver", uvm_component parent);
super.new(name,parent);
endfunction 

function void master_driver::build_phase(uvm_phase phase);
super.build_phase(phase);
if(!uvm_config_db#(master_config)::get(this,"","master_config",m_cfg))
`uvm_fatal("failed to get m_cfg","in master_driver")
endfunction

function void master_driver::connect_phase(uvm_phase phase);
vif = m_cfg.vif_m;
endfunction

task master_driver::run_phase (uvm_phase phase);
		forever
		begin
			seq_item_port.get_next_item(req);
			send_to_dut(req);
			seq_item_port.item_done();
			end
endtask

task master_driver::send_to_dut (master_xtn xtn );

begin
	
		reset();
		drive(req);
	
end
endtask


task master_driver::reset();


vif.mdr_cb.HSEL<=1'b0;
vif.mdr_cb.HBURST<=3'b0;
vif.mdr_cb.HSIZE<=3'b0;
vif.mdr_cb.HREADY<=1'b1;
vif.mdr_cb.HWRITE<=1'b0;
vif.mdr_cb.HTRANS<=2'b0;
vif.mdr_cb.HADDR<=32'b0;
vif.mdr_cb.HWDATA<=32'b0;
vif.mdr_cb.HRESETn<=1'b0;
repeat(3)
@(vif.mdr_cb);
vif.mdr_cb.HRESETn<=1'b1;
endtask


task master_driver::drive(master_xtn xtn);
int j=0;
//repeat(2)
@(vif.mdr_cb);
vif.mdr_cb.HSEL<=1'b1;
vif.mdr_cb.HBURST<=xtn.burst_mode;
vif.mdr_cb.HSIZE<=xtn.data_size;
vif.mdr_cb.HREADY<=1'b1;
vif.mdr_cb.HWRITE<=xtn.read_write;
vif.mdr_cb.HRESETn<=xtn.reset[0];

foreach(xtn.transfer_type[i])
begin
	if (xtn.transfer_type[i]==NONSEQ &&(~ vif.mdr_cb.HRESP) )//|| xtn.transfer_type[i]==SEQ )  //nonseq is first
	begin
		vif.mdr_cb.HTRANS<=xtn.transfer_type[i];
		vif.mdr_cb.HADDR<=xtn.address[j];
		vif.mdr_cb.HWDATA<=xtn.hwdata[j];
		@(vif.mdr_cb);
		wait(vif.mdr_cb.HREADYOUT); //HREADY
		//j++;
	end
	else if (xtn.transfer_type[i] == BUSY&&(~ vif.mdr_cb.HRESP))// || xtn.transfer_type[i]==IDLE )
	begin
		if (xtn.transfer_type[i-1]==BUSY)
		begin
			vif.mdr_cb.HTRANS<=xtn.transfer_type[i];
			vif.mdr_cb.HADDR<=xtn.address[j];
			vif.mdr_cb.HWDATA<=xtn.hwdata[j];
			@(vif.mdr_cb);
		end
		else if (xtn.transfer_type[i-1]==NONSEQ || xtn.transfer_type[i-1]==SEQ)
		begin
			j++;
			vif.mdr_cb.HTRANS<=xtn.transfer_type[i];
			vif.mdr_cb.HADDR<=xtn.address[j];
			vif.mdr_cb.HWDATA<=xtn.hwdata[j];
			@(vif.mdr_cb);
		end			
	end
	else if (xtn.transfer_type[i]==SEQ&&(~ vif.mdr_cb.HRESP))
	begin
		 if (xtn.transfer_type[i-1]==BUSY)
		 begin
		 	vif.mdr_cb.HTRANS<=xtn.transfer_type[i];
			vif.mdr_cb.HADDR<=xtn.address[j];
			vif.mdr_cb.HWDATA<=xtn.hwdata[j];
			@(vif.mdr_cb);
			wait(vif.mdr_cb.HREADYOUT); 
//HREADY
		 end
		 else if (xtn.transfer_type[i-1]==NONSEQ || xtn.transfer_type[i-1]==SEQ)
		 begin
			j++;
		 	vif.mdr_cb.HTRANS<=xtn.transfer_type[i];
			vif.mdr_cb.HADDR<=xtn.address[j];
			vif.mdr_cb.HWDATA<=xtn.hwdata[j];
			@(vif.mdr_cb);
			wait(vif.mdr_cb.HREADYOUT); //HREADY
		 end
	end
	else if (xtn.transfer_type[i]==IDLE&&(~ vif.mdr_cb.HRESP))
	begin
		vif.mdr_cb.HTRANS<=xtn.transfer_type[i];
		vif.mdr_cb.HADDR<=xtn.address[j];
		vif.mdr_cb.HWDATA<=xtn.hwdata[j];
		@(vif.mdr_cb);
	end
	else if ((xtn.transfer_type[i]==IDLE || xtn.transfer_type[i]==NONSEQ || xtn.transfer_type[i]==SEQ || xtn.transfer_type[i]==BUSY)
					&&(vif.mdr_cb.HRESP)&&(~vif.mdr_cb.HREADYOUT))
	begin
		vif.mdr_cb.HTRANS<=2'b00;
		break;
	end
	end
	vif.mdr_cb.HTRANS<=2'b00;
	repeat(2)
	@(vif.mdr_cb);
endtask



/*
int j =0;

if(!xtn.hresetn)
begin
@(vif.mdr_cb);
vif.mdr_cb.HSEL<=1'b0;
vif.mdr_cb.HBURST<=3'b0;
vif.mdr_cb.HSIZE<=3'b0;
vif.mdr_cb.HREADY<=1'b1;
vif.mdr_cb.HWRITE<=1'b0;
vif.mdr_cb.HTRANS<=2'b0;
vif.mdr_cb.HADDR<=32'b0;
vif.mdr_cb.HWDATA<=32'b0;
end


@(vif.mdr_cb);

vif.mdr_cb.HRESETn<=xtn.hresetn;
$display("value for hresetn is %d", xtn.hresetn);
vif.mdr_cb.HSEL<=1'b1;
vif.mdr_cb.HBURST<=xtn.burst_mode;
vif.mdr_cb.HSIZE<=xtn.data_size;
vif.mdr_cb.HREADY<=1'b1;
vif.mdr_cb.HWRITE<=xtn.read_write;


foreach(xtn.transfer_type[i])
begin
// if busy address and hwdata should change 

if (xtn.transfer_type[i] == BUSY)
begin
if (xtn.transfer_type[i-1] == BUSY)
begin
vif.mdr_cb.HTRANS<=xtn.transfer_type[i];
vif.mdr_cb.HADDR<=xtn.address[j];
vif.mdr_cb.HWDATA<=xtn.hwdata[j];
$display("transfer type is %s", xtn.transfer_type[i]);
$display("address is %d", xtn.address[j]);
@(vif.mdr_cb);
end
else if (xtn.transfer_type[i-1] == NONSEQ || xtn.transfer_type[i-1] == SEQ)
begin
j++;
vif.mdr_cb.HTRANS<=xtn.transfer_type[i];
vif.mdr_cb.HADDR<=xtn.address[j];
vif.mdr_cb.HWDATA<=xtn.hwdata[j];
$display("transfer type is %s", xtn.transfer_type[i]);
$display("address is %d", xtn.address[j]);
@(vif.mdr_cb);
end
end
else if (xtn.transfer_type[i] == SEQ)
begin
if (xtn.transfer_type[i-1] == BUSY)
begin
vif.mdr_cb.HTRANS<=xtn.transfer_type[i];
vif.mdr_cb.HADDR<=xtn.address[j];
vif.mdr_cb.HWDATA<=xtn.hwdata[j];
$display("transfer type is %s", xtn.transfer_type[i]);
$display("address is %d", xtn.address[j]);
@(vif.mdr_cb);
wait (vif.mdr_cb.HREADYOUT);
end
else if (xtn.transfer_type[i-1] == NONSEQ || xtn.transfer_type[i-1] == SEQ)
begin
j++;
vif.mdr_cb.HTRANS<=xtn.transfer_type[i];
vif.mdr_cb.HADDR<=xtn.address[j];
vif.mdr_cb.HWDATA<=xtn.hwdata[j];
$display("transfer type is %s", xtn.transfer_type[i]);
$display("address is %d", xtn.address[j]);
@(vif.mdr_cb);
wait (vif.mdr_cb.HREADYOUT);
end
end
else if (xtn.transfer_type[i]==IDLE)
begin
vif.mdr_cb.HTRANS<=xtn.transfer_type[i];
vif.mdr_cb.HADDR<=xtn.address[j];
vif.mdr_cb.HWDATA<=xtn.hwdata[j];
$display("transfer type is %s", xtn.transfer_type[i]);
$display("address is %d", xtn.address[j]);
@(vif.mdr_cb);
end

else
begin
vif.mdr_cb.HTRANS<=xtn.transfer_type[i];
vif.mdr_cb.HADDR<=xtn.address[j];
vif.mdr_cb.HWDATA<=xtn.hwdata[j];
$display("transfer type is %s", xtn.transfer_type[i]);
$display("address is %d", xtn.address[j]);
@(vif.mdr_cb);
wait (vif.mdr_cb.HREADYOUT);
end
$display ("the hready is  are %d" , vif.mdr_cb.HREADYOUT);
end
$display ("the values of transaction are %p" , xtn.transfer_type);
$display ("the values of transaction are %p" , xtn.address);
//end
*/
//endtask;