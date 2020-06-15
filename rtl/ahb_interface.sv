interface ahb_if(input bit HCLK);

        logic 			HRESETn;
        logic 			HREADY;
        logic [1:0] 	HTRANS;
        logic [2:0] 	HBURST;
        logic [2:0] 	HSIZE;
        logic 			HWRITE;
		logic			HSEL;
        logic [31:0] 	HADDR;
        logic [31:0] 	HWDATA;
        logic [31:0] 	HRDATA;
        logic 		 	HRESP;
		logic			HREADYOUT;
		//bit 			HCLK;
		//assign HCLK = clock;
		
clocking mdr_cb @(posedge HCLK);
default input #1 output #1 ;
	output HRESETn;
	output HREADY;
	output HTRANS;
	output HBURST;
	output HSIZE;
	output HWRITE;
	output HSEL;
	output HADDR;
	output HWDATA;
	input  HRDATA;
	input  HREADYOUT;
	input  HRESP;

endclocking 

clocking mmn_cb @(posedge HCLK);
default input #1 output #1 ;
	input HRESETn;
	input HREADY;
	input HTRANS;
	input HBURST;
	input HSIZE;
	input HWRITE;
	input HSEL;
	input HADDR;
	input HWDATA;
	input HRDATA;
	input HREADYOUT;
	input HRESP;
	
endclocking 

clocking sdr_cb @(posedge HCLK);
default input #1 output #1 ;
	input  HRESETn;
	input  HREADY;
	input  HTRANS;
	input  HBURST;
	input  HSIZE;
	input  HWRITE;
	input  HSEL;
	input  HADDR;
	input  HWDATA;
	output HRDATA;
	inout HREADYOUT;
	output HRESP;
endclocking 

clocking smn_cb @(posedge HCLK);
default input #1 output #1 ;
	input HRESETn;
	input HREADY;
	input HTRANS;
	input HBURST;
	input HSIZE;
	input HWRITE;
	input HSEL;
	input HADDR;
	input HWDATA;
	input HRDATA;
	input HREADYOUT;
	input HRESP;
	
endclocking

modport MDR_MP (clocking mdr_cb);
modport MMN_MP (clocking mmn_cb);
modport SDR_MP (clocking sdr_cb);
modport SMN_MP (clocking smn_cb);


property incr_addr;
	@(posedge HCLK) disable iff (!HRESETn)
		($past(HREADYOUT,1)==1'b1 &&(HTRANS == 2'b01|| HTRANS == 2'b11) && (($past(HTRANS,1)==2'b11) || ($past(HTRANS,1)==2'b10)) && (HBURST==3'b001 || HBURST==3'b011
				|| HBURST==3'b101 ||HBURST==3'b111)) |-> ((HADDR[16:0] == ($past(HADDR[16:0],1)+2**HSIZE)));//,  $display("present HADDR %d past haddr %d and expected  is %d",HADDR[16:0],$past(HADDR[16:0],1),($past(HADDR[16:0],1)+2**HSIZE)));
				endproperty
//(HADDR[16:0] == ($past(HADDR[16:0],1)+2**HSIZE),

// present address should be past + hsize 
//if we calculate present + hsize for fixed burts in last seq address will incremeant but it will be nonseq or idlw with different address 
//so property will fail 
//best way is to do present is past + hsize if transfer is seq and for busy past should be 
//to increase address past should be hready and transfer should be nonseq or seq and prsent can be busy or seq 


		bit [2:0] add_width;
		always @ (HBURST)
		begin
		case (HBURST)
		3'b010 : add_width = 3'b010;
		3'b100 : add_width = 3'b011;
		3'b110 : add_width = 3'b100;
		endcase
		end
		
		logic [31:0] wrap_haddr;
		
		always @(posedge HCLK)
		wrap_haddr <= HADDR;

property wrap_addr;

		bit [9:0] mask = {10{1'b1}};
		bit [9:0] hadd_nxt = wrap_haddr[9:0] + (1'b1 << HSIZE);				
		bit [9:0] hadd_mask = (mask<<HSIZE)<<add_width;		
		bit [9:0] hadd_wrap_nxt= (HADDR[9:0] & hadd_mask)  | (hadd_nxt & ~(hadd_mask));
				
	@(posedge HCLK) disable iff (!HRESETn)

		($past(HREADYOUT,1)==1'b1 && (HTRANS == 2'b01|| HTRANS == 2'b11) && (($past(HTRANS,1)==2'b11) || ($past(HTRANS,1)==2'b10)) && (HBURST==3'b010 || HBURST==3'b100
				|| HBURST==3'b110)) |-> (HADDR[9:0]==hadd_wrap_nxt);//, $display("address  next %b\n and address 9  is %b\n tot add is %b\n ",hadd_wrap_nxt,HADDR[9:0],HADDR ));
				endproperty



//during busy cycle or seq transfer present and past signals should be same
//as starting transfer is nonseq  and incr can terminate with busy 
property controls_cnst_burst;
	@(posedge HCLK) disable iff (!HRESETn)
	(HTRANS == 2'b01 || HTRANS == 2'b11) |=> (HSIZE == $past(HSIZE,1) && HBURST == $past(HBURST,1) && HADDR[31:10] == $past(HADDR[31:10],1)
												&& HWRITE == $past(HWRITE,1) );
endproperty


//if there is a busy cycle or seq transfer after a busy cycle the control signals should be same 
//indicating there will be on seq transfer or busy cycle after a busy cycle
property controls_cnst_busy;
	@(posedge HCLK) disable iff (!HRESETn)
	(( $past(HTRANS,1) == 2'b01) && (HTRANS == 2'b01 || HTRANS == 2'b11)) |-> (HSIZE == $past(HSIZE,1) && HBURST == $past(HBURST,1) && HADDR[31:10] 									== $past(HADDR[31:10],1) && HWRITE == $past(HWRITE,1) );
endproperty

//after idle cycle there should be nonseq 		
property first_no_busy;
	@(posedge HCLK) disable iff (!HRESETn)
			(HTRANS == 2'b01)|->($past(HTRANS,1)!=2'b00);
endproperty

bit [3:0] address_size;
bit [3:0] count;

always @ (HBURST)
	begin 
	case (HBURST)
	3'b010, 3'b011: address_size = 4'b0011;
	3'b100, 3'b101: address_size = 4'b0111;
	3'b110, 3'b111: address_size = 4'b1111;
	3'b000:			address_size = 4'b0000;
	default : 		address_size = 4'bxxxx;
	endcase
	end

always @ (posedge HCLK)
begin
if (HTRANS == 2'b00 || (HTRANS == 2'b10 && HBURST == 3'b001))
	count <= 4'b0000;
if (HTRANS == 2'b10 && HBURST !=3'b001 && HREADYOUT)
	count <=address_size;
if (HTRANS == 2'b11 && HREADYOUT)
	count <= count-1'b1;
end

property last_no_busy;
	@(posedge HCLK) disable iff (!HRESETn)
		(count == 4'b0000 && HBURST != 3'b001) |-> (HTRANS != 2'b01);
endproperty 		


//wait transfers happen when slave sends hready 0 
//for wait transfers signals should be same 
//busy cycle can process when hready is zero 
property const_ctrl_wait_trns;
	@(posedge HCLK) disable iff(!HRESETn)
	($past(HREADYOUT,1)==1'b0 && $past(HTRANS,1)==HTRANS && ($past(HTRANS,1) != 2'b00)) |-> ($past(HADDR,1)==HADDR && $past(HBURST,1)==HBURST && 
							$past(HSIZE,1)==HSIZE && $past(HWRITE,1)==HWRITE) ;
endproperty

property idle_after_rst;
	@(posedge HCLK) disable iff(!HRESETn)
		$past(HRESETn,1)==1'b0 |-> HTRANS == 2'b00;
endproperty

//waited transfers
//nonseq or seq 
/*
property waited_nonseq_seq;
	@(posedge HCLK) disable iff(!HRESETn)
	(($past(HREADYOUT,1) == 1'b0)&&(HTRANS == 2'b10 || HTRANS ==2'b11)) |-> ((HTRANS==$past(HTRANS,1) || (($past(HREADYOUT == 1'b0)&&
		$past(HRESP,1)==1'b1)&&((HTRANS==2'b00) &&(HRESP==1'b1)&&(HREADYOUT==1'b1))));
endproperty


property waited_busy;
	@(posedge HCLK) disable iff(!HRESETn)
	(($past(HREADYOUT,1)==1'b0) && ($past(HTRANS==2'b01))) |-> ((HTRANS == 2'b01 || HTRANS == 2'b11) || (($past(HREADYOUT == 1'b0)&&
		$past(HRESP,1)==1'b1)&&((HTRANS==2'b00) &&(HRESP==1'b1)&&(HREADYOUT==1'b1)));
endproperty
*/	
	INCR_ADDR: 				assert property(incr_addr);
	WRAP_ADDR: 				assert property(wrap_addr);
	CONTROLS_CNST_BURST: 	assert property(controls_cnst_burst);
	CONTROLS_CNST_BUSY: 	assert property(controls_cnst_busy);
	FIRST_NO_BURST:			assert property(first_no_busy);
	LAST_NO_BURST:			assert property(last_no_busy);
	CONST_CTRL_WAIT_TRNS:	assert property(const_ctrl_wait_trns);	
	IDLE_AFTER_RST:			assert property(idle_after_rst);
//	WAITED_NONSEQ_SEQ:		assert property(waited_nonseq_seq);
//	WAITED_BUSY:			assert property(waited_busy);
	

endinterface