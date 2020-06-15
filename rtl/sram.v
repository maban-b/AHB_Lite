

module sram #(
  parameter  AW = 16)
  (
  output  wire   [31:0] SRAMRDATA, // SRAM Read Data
  input   wire [AW-3:0] SRAMADDR,  // SRAM address
  input   wire    [3:0] SRAMWEN,   // SRAM write enable (active high)
  input   wire   [31:0] SRAMWDATA, // SRAM write data
  input   wire          SRAMCS);
  
  
  
reg [31:0] mem [0:AW-3];


always@(SRAMWDATA,SRAMWEN,SRAMCS,SRAMADDR)
  if (SRAMWEN && SRAMCS)
      mem[SRAMADDR]=SRAMWDATA;

 
assign SRAMRDATA= (SRAMCS && !SRAMWEN) ? mem[SRAMADDR] : 32'hzz;

endmodule 