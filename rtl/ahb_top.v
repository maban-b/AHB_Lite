


module cmsdk_ahb_to_extmem #(
  parameter  AW = 16)
 (

  input  wire          HCLK,      // system bus clock
  input  wire          HRESETn,   // system bus reset
  input  wire          HSEL,      // AHB peripheral select
  input  wire          HREADY,    // AHB ready input
  input  wire    [1:0] HTRANS,    // AHB transfer type
  input  wire    [2:0] HSIZE,     // AHB hsize
  input  wire          HWRITE,    // AHB hwrite
  input  wire [AW-1:0] HADDR,     // AHB address bus
  input  wire   [31:0] HWDATA,    // AHB write data bus
  output wire          HREADYOUT, // AHB ready output to S->M mux
  output wire          HRESP,     // AHB response
  output wire   [31:0] HRDATA);
  
  
  
  //internal wires
  wire   [31:0] SRAMRDATA; // SRAM Read Data
  wire [AW-3:0] SRAMADDR; // SRAM address
  wire    [3:0] SRAMWEN;   // SRAM write enable (active high)
  wire   [31:0] SRAMWDATA; // SRAM write data
  wire          SRAMCS;
  

  
  cmsdk_ahb_to_sram
    #(.AW (AW))
      u_cmsdk_ahb_to_sram (
    .HCLK         (HCLK),
    .HRESETn      (HRESETn),
    .HSEL         (HSEL),
    .HADDR        (HADDR),
    .HTRANS       (HTRANS),
    .HSIZE        (HSIZE),
    .HWRITE       (HWRITE),
    .HREADY       (HREADY),
    .HWDATA       (HWDATA),

    .HREADYOUT    (HREADYOUT),
    .HRDATA       (HRDATA),
    .HRESP        (HRESP),
	.SRAMRDATA	  (SRAMRDATA),
	.SRAMADDR	  (SRAMADDR),
	.SRAMWEN	  (SRAMWEN),
	.SRAMWDATA	  (SRAMWDATA),
	.SRAMCS		  (SRAMCS));
	
	
	sram
	 #(.AW (AW))
	 u_sram (
	.SRAMRDATA	  (SRAMRDATA),
	.SRAMADDR	  (SRAMADDR),
	.SRAMWEN	  (SRAMWEN),
	.SRAMWDATA	  (SRAMWDATA),
	.SRAMCS		  (SRAMCS));
	
	endmodule
	