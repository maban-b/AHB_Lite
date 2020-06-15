

module top();


    import ahb_test_pkg::*;

	import uvm_pkg::*;
	bit clock;

ahb_if inf(clock);

cmsdk_ahb_to_extmem DUT (
	.HCLK         (clock),
    .HRESETn      (inf.HRESETn),
    .HSEL         (inf.HSEL),
    .HADDR        (inf.HADDR),
    .HTRANS       (inf.HTRANS),
    .HSIZE        (inf.HSIZE),
    .HWRITE       (inf.HWRITE),
    .HREADY       (inf.HREADY),
    .HWDATA       (inf.HWDATA),
    .HREADYOUT    (inf.HREADYOUT),
    .HRDATA       (inf.HRDATA),
    .HRESP        (inf.HRESP));



initial 
begin
//clock = 1'b0;
forever #5 clock = ~clock;
end




initial
begin

uvm_config_db#(virtual ahb_if)::set(null,"*","vif",inf);


run_test();
end
endmodule