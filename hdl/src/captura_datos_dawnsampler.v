`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:47:30 02/08/2020 
// Design Name: 
// Module Name:    captura_datos_dawnsampler 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module captura_de_datos_downsampler(
	input PCLK,
	input HREF,
	input VSYNC,
	input [7:0]D,
	output reg [7:0] DP_RAM_data_in,
	output reg [16:0] DP_RAM_addr_in,
	output reg DP_RAM_regW
   );
	
	reg cont=1'b0;
	
	always@(posedge PCLK)
	begin
		if(HREF & ~VSYNC)
		begin			
		
			
			if (cont==0)
			begin
				
				DP_RAM_data_in[7:2] = {D[7:5],D[2:0],DP_RAM_data_in[1:0]};
				DP_RAM_regW = 0;
			end
			else 
			begin
				
				DP_RAM_data_in[1:0] = D[4:3];
				DP_RAM_regW = 1;
			end
			cont = cont+1;	
		end
	end
	
	always@(negedge PCLK)
	begin
		if(HREF & ~VSYNC & (cont == 1))
		begin
			DP_RAM_addr_in =DP_RAM_addr_in+1;
		end
		if(DP_RAM_addr_in == 76800)
			DP_RAM_addr_in = 0;
	end

endmodule
	