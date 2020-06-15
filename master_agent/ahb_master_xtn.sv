class master_xtn extends uvm_sequence_item;
`uvm_object_utils(master_xtn)
/*
rand htransfer_t transfer_type[];
rand hburst_t	 burst_mode;
rand hsize_t	 data_size;
rand bit[31:0] address[];
rand bit[31:0] hwdata[];
rand bit busy[];
rand int busy_txns;
rand rw_t read_write;
rand bit hresetn;
rand bit reset[];
rand bit [31:0] test[];
*/

rand htransfer_t 	transfer_type[];
rand hburst_t    	burst_mode;
rand hsize_t		data_size;
rand rw_t		read_write;
rand bit [31:0] address[];
rand bit [31:0] hwdata[];
rand bit busy [];
rand int busy_txns;
rand bit hresetn;
rand bit reset[];

constraint reset_h			{hresetn == 1'b1;}

constraint reset_size		{if(hresetn == 1'b0)
								{reset.size inside {[1:5]};
								 foreach(reset[i])
									{ if(i==reset.size-1)
										{reset[i] == 1'b1;}
									  else
										{reset[i] == 1'b0;}
									}
								}
							else 
								{reset.size == 1;
								reset[0] ==1'b1;
								}
							}
								
//constraint reset_order 		{
/*
constraint burst_m 			{if (burst_mode == SINGLE)
									address.size==1;
							 if (burst_mode == INCR)
									address.size <= (1024/(1<<data_size));
							 if (burst_mode == INCR4 || burst_mode == WRAP4)
									address.size==4;
							 if (burst_mode == INCR8 || burst_mode == WRAP8)
									address.size==8;
							 if (burst_mode == INCR16 || burst_mode == WRAP16)
									address.size==16;
							}
							
							
constraint kilobyte_b		{if(burst_mode != SINGLE && data_size == WORD)
								address[0][9:2] < (256-address.size);
								
							if(burst_mode != SINGLE && data_size == HALFWORD)
							address[0][9:1] < (512-address.size);
															
							if(burst_mode != SINGLE && data_size == BYTE)
							address[0][9:0] < (1024-address.size);
							}
							
constraint data_size_b		{if (data_size ==HALFWORD)
								{foreach(address[i])
									address[i][0] == 1'b0;
								}
							if (data_size ==WORD)
								{foreach(address[i])
									address[i][1:0] == 2'b0;
								}
							}
constraint incr 			{if (burst_mode==INCR || burst_mode==INCR4 || burst_mode==INCR8 || burst_mode==INCR16)
								{foreach(address[i])
									{if (i!=0)
										address[i] == address[i-1]+(1<<data_size);
									}
								}
							}

							
constraint wrap4_add_byte	{if((burst_mode == WRAP4) && (data_size == BYTE))
								{foreach(address[i])
									if(i!=0)
										{if (address[i-1][1:0] == 2'b11)
											{
											address[i][1:0]  == 2'b00;
											address[i][31:2]  == address[i-1][31:2];
											}											
										else 
											{
											address[i] == address[i-1]+(1<<data_size);
											}
								}
							}
							}
							
constraint wrap4_add_hw		{if((burst_mode == WRAP4) && (data_size == HALFWORD))
								{foreach(address[i])
									if(i!=0)
										{if (address[i-1][2:1] == 2'b11)
											{
											address[i][2:1]  == 2'b00;
											address[i][31:3]  == address[i-1][31:3];
											}											
										else 
											{
											address[i] == address[i-1]+(1<<data_size);
											}
								}
							}
							}

constraint wrap4_add_w	{if((burst_mode == WRAP4) && (data_size == WORD))
								{foreach(address[i])
									if(i!=0)
										{if (address[i-1][3:2] == 2'b11)
											{
											address[i][3:2]  == 2'b00;
											address[i][31:4]  == address[i-1][31:4];
											}											
										else 
											{
											address[i] == address[i-1]+(1<<data_size);
											}
								}
							}
							}			
constraint wrap8_add_byte	{if((burst_mode == WRAP8) && (data_size == BYTE))
								{foreach(address[i])
									if(i!=0)
										{if (address[i-1][2:0] == 3'b111)
											{
											address[i][2:0]  == 3'b000;
											address[i][31:3]  == address[i-1][31:3];
											}											
										else 
											{
											address[i] == address[i-1]+(1<<data_size);
											}
								}
							}
							}
							
constraint wrap8_add_hw		{if((burst_mode == WRAP8) && (data_size == HALFWORD))
								{foreach(address[i])
									if(i!=0)
										{if (address[i-1][3:1] == 3'b111)
											{
											address[i][3:1]  == 3'b00;
											address[i][31:4]  == address[i-1][31:4];
											}											
										else 
											{
											address[i] == address[i-1]+(1<<data_size);
											}
								}
							}
							}

constraint wrap8_add_w	{if((burst_mode == WRAP8) && (data_size == WORD))
								{foreach(address[i])
									if(i!=0)
										{if (address[i-1][4:2] == 3'b111)
											{
											address[i][4:2]  == 3'b000;
											address[i][31:5]  == address[i-1][31:5];
											}											
										else 
											{
											address[i] == address[i-1]+(1<<data_size);
											}
								}
							}
							}		

constraint wrap16_add_byte	{if((burst_mode == WRAP16) && (data_size == BYTE))
								{foreach(address[i])
									if(i!=0)
										{if (address[i-1][3:0] == 4'b1111)
											{
											address[i][3:0]  == 4'b0000;
											address[i][31:4]  == address[i-1][31:4];
											}											
										else 
											{
											address[i] == address[i-1]+(1<<data_size);
											}
								}
							}
							}
							
constraint wrap16_add_hw	{if((burst_mode == WRAP16) && (data_size == HALFWORD))
								{foreach(address[i])
									if(i!=0)
										{if (address[i-1][4:1] == 4'b1111)
											{
											address[i][4:1]  == 4'b0000;
											address[i][31:5]  == address[i-1][31:5];
											}											
										else 
											{
											address[i] == address[i-1]+(1<<data_size);
											}
								}
							}
							}

constraint wrap16_add_w	{if((burst_mode == WRAP16) && (data_size == WORD))
								{foreach(address[i])
									if(i!=0)
										{if (address[i-1][5:2] == 4'b1111)
											{
											address[i][5:2]  == 4'b0000;
											address[i][31:6]  == address[i-1][31:6];
											}											
										else 
											{
											address[i] == address[i-1]+(1<<data_size);
											}
								}
							}
							}								
						
constraint data_siz			{data_size inside {BYTE,HALFWORD,WORD};}
							
constraint busy_trns_value  {if (burst_mode != SINGLE)
								busy_txns inside {[0:10]};
							if  (burst_mode == SINGLE)
								busy_txns ==0;
							}

constraint transfer_size 	{transfer_type.size==busy.size;}

constraint transfer_typ		{if(burst_mode == INCR4 || burst_mode == WRAP4 || burst_mode == INCR8 || burst_mode == WRAP8 ||  
								burst_mode == INCR16 || burst_mode == WRAP16 )
								
								{foreach(transfer_type[i])
									{
										if(i==0)
											transfer_type[i]==NONSEQ;
											
										else if(i==transfer_type.size-1)
											transfer_type[i]==IDLE;
											
										else 
											transfer_type[i]==SEQ;
									}
								}
								
							if (burst_mode==INCR)
							
								{foreach(transfer_type[i])
									{
										if(i==0)
											transfer_type[i]==NONSEQ;
											
										else
											transfer_type[i]==SEQ;
									}
								}							
															
							
							if (burst_mode == SINGLE)
							{		foreach(transfer_type[i])
										transfer_type[i] inside {IDLE,NONSEQ};
								}
							}
							
constraint busy_size 		{if(burst_mode == INCR4 || burst_mode == WRAP4 || burst_mode == INCR8 || burst_mode == WRAP8 || burst_mode == INCR16 || 
									burst_mode == WRAP16 )
									
									busy.size == address.size+busy_txns+1;
									
							 if(burst_mode == INCR)
								
									busy.size == address.size+busy_txns;
									
							else 
							
									busy.size == 1;
							}

constraint busy_pos 		{if(burst_mode == INCR4 || burst_mode == WRAP4 || burst_mode == INCR8 || burst_mode == WRAP8 || burst_mode == INCR16 || 
									burst_mode == WRAP16 )
								{foreach(busy[i])
									if((i==0)||(i==1)||(i==busy.size-2)||(i==busy.size-1))
										busy[i]==0;}
							else if (burst_mode==INCR)
								busy[0]==0;
							}
constraint busy_no 			{busy.sum(X) with (int'(X*1))==busy_txns;}

constraint hwdata_size      {hwdata.size == address.size;}

*/
////////////////////////////////////////////////////////////////////////////////////////////////////////
/*
rand htransfer_t 	transfer_type[];
rand hburst_t    	burst;
rand hsize_t		size;
rand h_write		write;
rand bit [31:0] address[];
rand bit [31:0] hwdata[];
rand bit busy [];
rand int busy_txns;
*/

constraint address_size 		{ if (burst_mode == SINGLE)
									{address.size == 1;}
								 else if (burst_mode == INCR)
									{address.size <= (1024/(1<<data_size));}
								 else if (burst_mode == INCR4 || burst_mode == WRAP4)
									{address.size ==4;}
								 else if (burst_mode == INCR8 || burst_mode == WRAP8)
									{address.size ==8;} 
								 else if (burst_mode == INCR16 || burst_mode == WRAP16)
									{address.size ==16;}
								}

constraint kilobyte 		{ if (burst_mode != SINGLE && data_size == BYTE)
									{ address[0][9:0] < (1024-(address.size));}
							else if (burst_mode != SINGLE && data_size == HALFWORD)
									{ address[0][9:1] < (512-(address.size));}
							else if (burst_mode != SINGLE && data_size == WORD)
									{ address[0][9:2] < (256-(address.size));}
							}
						
constraint address_align 	{if (data_size ==HALFWORD)
								{ foreach(address[i])
									{address[i][0] == 1'b0;} }
							else if (data_size ==WORD)
								{ foreach(address[i])
									{address[i][1:0] == 2'b0;} }
							}
							
constraint size_typ			{data_size inside {[BYTE:WORD]};}
							
constraint add_incr 		{if (burst_mode == INCR || burst_mode == INCR4 || burst_mode == INCR8 || burst_mode == INCR16)
								{foreach(address[i])
								{ if (i !=0)
									{ address [i] == (address[i-1] + (1<<data_size));}
								}
								}
							}

constraint add_wrap4_b 		{if (burst_mode == WRAP4 && data_size == BYTE)
								{ foreach(address[i])
									{if (i !=0)
										{ if (address [i-1] [1:0] == 2'b11)
											{address [i] [1:0] == 2'b00;
											 address [i] [31:2] == address [i-1][31:2];
											}
										else 
											{ address [i] == (address[i-1] + (1<<data_size));}
										}		
									}
								}
							}	
								
constraint add_wrap4_hw 		{if (burst_mode == WRAP4 && data_size == HALFWORD)
								{ foreach(address[i])
									{if (i !=0)
										{ if (address [i-1] [2:1] == 2'b11)
											{address [i] [2:1] == 2'b00;
											 address [i] [31:3] == address [i-1][31:3];
											}
										else 
											{ address [i] == (address[i-1] + (1<<data_size));}
										}		
									}
								}
							}

constraint add_wrap4_w 		{if (burst_mode == WRAP4 && data_size == WORD)
								{ foreach(address[i])
									{if (i !=0)
										{ if (address [i-1] [3:2] == 2'b11)
											{address [i] [3:2] == 2'b00;
											 address [i] [31:4] == address [i-1][31:4];
											}
										else 
											{ address [i] == (address[i-1] + (1<<data_size));}
										}		
									}
								}
							}
							
constraint add_wrap8_b 		{if (burst_mode == WRAP8 && data_size == BYTE)
								{ foreach(address[i])
									{if (i !=0)
										{ if (address [i-1] [2:0] == 3'b111)
											{address [i] [2:0] == 3'b000;
											 address [i] [31:3] == address [i-1][31:3];
											}
										else 
											{ address [i] == (address[i-1] + (1<<data_size));}
										}		
									}
								}
							}	
								
constraint add_wrap8_hw 		{if (burst_mode == WRAP8 && data_size == HALFWORD)
								{ foreach(address[i])
									{if (i !=0)
										{ if (address [i-1] [3:1] == 3'b111)
											{address [i] [3:1] == 3'b000;
											 address [i] [31:4] == address [i-1][31:4];
											}
										else 
											{ address [i] == (address[i-1] + (1<<data_size));}
										}		
									}
								}
							}

constraint add_wrap8_w 		{if (burst_mode == WRAP8 && data_size == WORD)
								{ foreach(address[i])
									{if (i !=0)
										{ if (address [i-1] [4:2] == 3'b111)
											{address [i] [4:2] == 3'b000;
											 address [i] [31:5] == address [i-1][31:5];
											}
										else 
											{ address [i] == (address[i-1] + (1<<data_size));}
										}		
									}
								}
							}


constraint add_wrap16_b 		{if (burst_mode == WRAP16 && data_size == BYTE)
								{ foreach(address[i])
									{if (i !=0)
										{ if (address [i-1] [3:0] == 4'b1111)
											{address [i] [3:0] == 4'b0000;
											 address [i] [31:4] == address [i-1][31:4];
											}
										else 
											{ address [i] == (address[i-1] + (1<<data_size));}
										}		
									}
								}
							}	
								
constraint add_wrap16_hw 		{if (burst_mode == WRAP16 && data_size == HALFWORD)
								{ foreach(address[i])
									{if (i !=0)
										{ if (address [i-1] [4:1] == 4'b1111)
											{address [i] [4:1] == 4'b0000;
											 address [i] [31:5] == address [i-1][31:5];
											}
										else 
											{ address [i] == (address[i-1] + (1<<data_size));}
										}		
									}
								}
							}

constraint add_wrap16_w 		{if (burst_mode == WRAP16 && data_size == WORD)
								{ foreach(address[i])
									{if (i !=0)
										{ if (address [i-1] [5:2] == 4'b1111)
											{address [i] [5:2] == 4'b0000;
											 address [i] [31:6] == address [i-1][31:6];
											}
										else 
											{ address [i] == (address[i-1] + (1<<data_size));}
										}		
									}
								}
							}

constraint transfer_typ 	{ if (burst_mode == INCR4 || burst_mode == INCR8 || burst_mode == INCR16 || 
									burst_mode == WRAP4 || burst_mode == WRAP8 || burst_mode == WRAP16)
								{foreach(transfer_type[i])
									{if (i==0)
										{transfer_type[i]==NONSEQ;}
									else if (i==transfer_type.size-1)
										{transfer_type[i]==IDLE;}
									else
										{transfer_type[i]==SEQ;}
									}
								}
									
									else if (burst_mode == INCR)
								{
								foreach (transfer_type[i])
									{ if (i==0)
										{transfer_type[i]==NONSEQ;}
									else 
										{transfer_type[i] == SEQ;}
									}
								}
							 else 
								{ transfer_type[0] inside {IDLE,NONSEQ};}
							}
						
constraint busy_size		{ if (burst_mode == INCR4 || burst_mode == INCR8 || burst_mode == INCR16 || 
									burst_mode == WRAP4 || burst_mode == WRAP8 || burst_mode == WRAP16)
								{busy.size == address.size + busy_txns+1;}
							else if (burst_mode == INCR)
								{busy.size == address.size + busy_txns;}
							else
								{busy.size ==1;}
							}
							

constraint transfer_size    { transfer_type.size == busy.size;}

constraint busy_trans		{ if (burst_mode != SINGLE)
									{busy_txns inside {[1:10]};}
							  else 
								 {  busy_txns == 0;}
							}
							

constraint busy_typ			{if (burst_mode == INCR4 || burst_mode == INCR8 || burst_mode == INCR16 || 
									burst_mode == WRAP4 || burst_mode == WRAP8 || burst_mode == WRAP16)
									{foreach(busy[i])
										{if (i == 0 || i == transfer_type.size-1||i == transfer_type.size-2 )
											{ busy[i] == 0;}
										}
									}
							else 
								{busy[0] == 0;}
							}
						
constraint busy_pos 		{busy.sum(X) with (int'(X*1)) == busy_txns;}

constraint hwdata_size 		{hwdata.size == address.size;}


////////////////////////////////////////////////////////////////////////////////////////////////////////
extern function new (string name = "master_xtn");
extern function void post_randomize();
extern function void do_print(uvm_printer printer);
endclass

function master_xtn::new(string name = "master_xtn");
super.new(name);
endfunction

function void master_xtn::post_randomize();
if (burst_mode != SINGLE)
begin
foreach(busy[i])
begin
if (busy[i]==1)
	transfer_type[i]=BUSY;
end
end

if (burst_mode == INCR)
begin
//$display("address is %p", address);
address = new[address.size+1](address);
address[address.size-1] = address[address.size-2]+(1<<data_size);
//$display("address is %p", address);
end

//$display("test_address is %p", test);
//$display("address is %p", address);

endfunction

function void master_xtn::do_print(uvm_printer printer);
super.do_print(printer);
foreach(transfer_type[i])
printer.print_string("HTRANS",	this.transfer_type[i].name());
printer.print_string("HBURST",	this.burst_mode.name());
printer.print_string("HSIZE",	this.data_size.name());
foreach(address[i])
printer.print_field("HADDR",	this.address[i],		32,	UVM_DEC);
foreach(hwdata[i])
printer.print_field("HWDATA",	this.hwdata[i],		32,	UVM_DEC);
printer.print_field("HWRITE",	this.read_write,			 1,	UVM_DEC);



endfunction