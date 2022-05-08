`timescale 1ns / 1ps

module block_controller(
	input clk, //this clock must be a slow enough clock to view the changing positions of the objects
	input slower_clk,
	input bright,
	input rst,
	input up, input down, input left, input right,
	input [9:0] hCount, vCount,
	output reg [11:0] rgb,
	output reg [11:0] background
   );
   
	wire block_fill;
	wire block_fill1;
	wire block_fill2;
	wire block_fill3;
	wire block_fill4;
	wire block_fill5;
	wire block_fill6;
	wire block_fill7;
	wire block_fill8;
	wire block_fill9;
	wire block_fill10;
	wire block_fill11;
	wire block_fill12;
	wire block_fill13;
	wire block_fill14;
	wire block_fill15;
	wire block_fill16;
	wire block_fill17;

	wire food;
	//these two values dictate the center of the block, incrementing and decrementing them leads the block to move in certain directions
	reg [9:0] headx = 450;
	reg [9:0] heady = 250;
	reg [9:0] headx2, heady2 = 0;
	reg [9:0] headx3, heady3 = 0;
	reg [9:0] headx4, heady4 = 0;
	reg [9:0] headx5, heady5 = 0;
	reg [9:0] headx6, heady6 = 0;
	reg [9:0] headx7, heady7 = 0;
	reg [9:0] headx8, heady8 = 0;
	reg [9:0] headx9, heady9 = 0;
	reg [9:0] headx10, heady10 = 0;
	reg [9:0] headx11, heady11 = 0;
	reg [9:0] headx12, heady12 = 0;
	reg [9:0] headx13, heady13 = 0;		
	reg [9:0] headx14, heady14 = 0;
	reg [9:0] headx15, heady15 = 0;
	reg [9:0] headx16, heady16 = 0;
	reg [9:0] headx17, heady17 = 0;

	reg [9:0] xposfood = 470;
	reg [9:0] yposfood = 300;
	reg [2:0] state;
	reg done_flag;
	integer len = 2;
	reg foodeat = 0;
	parameter RED   = 12'b1111_0000_0000;
	parameter GREEN   = 12'b0000_1111_0000;
	parameter BLUE = 12'b0000_0000_1111;
	localparam
	INI	= 3'b001,
	MOVING_LEFT = 3'b010,
	MOVING_RIGHT = 3'b011,
	MOVING_UP = 3'b100,
	MOVING_DOWN = 3'b101,
	DONE = 3'b110;
	
	/*when outputting the rgb value in an always block like this, make sure to include the if(~bright) statement, as this ensures the monitor 
	will output some data to every pixel and not just the images you are trying to display*/
	always@ (*) begin
    	if(~bright )	//force black if not inside the display area
			rgb = 12'b0000_0000_0000;
		else if (block_fill || block_fill2 || block_fill3 || block_fill4 || block_fill5 || block_fill6 || block_fill7 || block_fill8 || block_fill9 || block_fill10 || 
		block_fill11 || block_fill12 || block_fill13 || block_fill14 || block_fill15 || block_fill16 || block_fill17) 
			rgb = RED;
		else if (food)
			rgb = GREEN;
		else	
			rgb=background;
	end
	
	
	//the +-5 for the positions give the dimension of the block (i.e. it will be 10x10 pixels)	
	assign block_fill=vCount>=(heady-5) && vCount<=(heady+5) && hCount>=(headx-5) && hCount<=(headx+5);
	assign block_fill2=vCount>=(heady2-5) && vCount<=(heady2+5) && hCount>=(headx2-5) && hCount<=(headx2+5);
	assign block_fill3=vCount>=(heady3-5) && vCount<=(heady3+5) && hCount>=(headx3-5) && hCount<=(headx3+5);
	assign block_fill4=vCount>=(heady4-5) && vCount<=(heady4+5) && hCount>=(headx4-5) && hCount<=(headx4+5);
	assign block_fill5=vCount>=(heady5-5) && vCount<=(heady5+5) && hCount>=(headx5-5) && hCount<=(headx5+5);
	assign block_fill6=vCount>=(heady6-5) && vCount<=(heady6+5) && hCount>=(headx6-5) && hCount<=(headx6+5);
	assign block_fill7=vCount>=(heady7-5) && vCount<=(heady7+5) && hCount>=(headx7-5) && hCount<=(headx7+5);
	assign block_fill8=vCount>=(heady8-5) && vCount<=(heady8+5) && hCount>=(headx8-5) && hCount<=(headx8+5);
	assign block_fill9=vCount>=(heady9-5) && vCount<=(heady9+5) && hCount>=(headx9-5) && hCount<=(headx9+5);
	assign block_fill10=vCount>=(heady10-5) && vCount<=(heady10+5) && hCount>=(headx10-5) && hCount<=(headx10+5);
	assign block_fill11=vCount>=(heady11-5) && vCount<=(heady11+5) && hCount>=(headx11-5) && hCount<=(headx11+5);
	assign block_fill12=vCount>=(heady12-5) && vCount<=(heady12+5) && hCount>=(headx12-5) && hCount<=(headx12+5);
	assign block_fill13=vCount>=(heady13-5) && vCount<=(heady13+5) && hCount>=(headx13-5) && hCount<=(headx13+5);
	assign block_fill14=vCount>=(heady14-5) && vCount<=(heady14+5) && hCount>=(headx14-5) && hCount<=(headx14+5);
	assign block_fill15=vCount>=(heady15-5) && vCount<=(heady15+5) && hCount>=(headx15-5) && hCount<=(headx15+5);
	assign block_fill16=vCount>=(heady16-5) && vCount<=(heady16+5) && hCount>=(headx16-5) && hCount<=(headx16+5);
	assign block_fill17=vCount>=(heady17-5) && vCount<=(heady17+5) && hCount>=(headx17-5) && hCount<=(headx17+5);


	assign food=vCount>=(yposfood-5) && vCount<=(yposfood+5) && hCount>=(xposfood-5) && hCount<=(xposfood+5);
	
	
	always@(posedge clk, posedge rst) 
	begin
		if(rst)
		begin 
			//rough values for center of screen
			state <= INI;
		end
		else if (clk) begin
		
		/* Note that the top left of the screen does NOT correlate to vCount=0 and hCount=0. The display_controller.v file has the 
			synchronizing pulses for both the horizontal sync and the vertical sync begin at vcount=0 and hcount=0. Recall that after 
			the length of the pulse, there is also a short period called the back porch before the display area begins. So effectively, 
			the top left corner corresponds to (hcount,vcount)~(144,35). Which means with a 640x480 resolution, the bottom right corner 
			corresponds to ~(783,515).  
		*/
			
			(* full_case, parallel_case *)
			 case (state)
				INI	: 
				  begin
					 // state transitions in the control unit
					 if(right) begin
						state <= MOVING_RIGHT;
					 end
					 else if(left) begin
						state <= MOVING_LEFT;
					 end
					 else if(up) begin
						state <= MOVING_UP;
					end
					else if(down) begin
						state <= MOVING_DOWN;
					end
				  end
				MOVING_RIGHT : 
				  begin
					// state transition
					if(up) begin
						state <= MOVING_UP;
					end
					else if(down) begin
						state <= MOVING_DOWN;
					end
					if(headx==800 || done_flag == 1) //these are rough values to attempt looping around, you can fine-tune them to make it more accurate- refer to the block comment above
						state <= DONE;
				  end
				MOVING_LEFT	: 
				  begin
					// state transition
					if(up) begin
						state <= MOVING_UP;
					end
					else if(down) begin
						state <= MOVING_DOWN;
					end
					if(headx==150 || done_flag == 1)
						state <= DONE;
				  end
				MOVING_UP	: 
				  begin
					// state transition
					if(right) begin
						state <= MOVING_RIGHT;
					end
					else if(left) begin
						state <= MOVING_LEFT;
					end
					if(heady==30 || done_flag == 1)
						state <= DONE;
					 
				  end
				MOVING_DOWN	: 
				  begin
					// state transition
					if(right) begin
						state <= MOVING_RIGHT;
					end
					else if(left) begin
						state <= MOVING_LEFT;
					end
					if(heady==520 || done_flag == 1)
						state <= DONE;
				  end
				DONE	:
				  begin  
					 // state transitions in the control unit
					  state <= INI;
				   end    
			endcase
		end
	end
	

	always @(posedge slower_clk)
	begin
		if((((headx - xposfood < 10) & (headx - xposfood >= 0)) 
		|| ((xposfood - headx >= 0) & (xposfood - headx < 10))) 
		& (((heady - yposfood < 10) & (heady - yposfood >= 0))
		|| ((yposfood - heady < 10)) & (yposfood - heady >= 0))) // checks if block is being eaten, by comparing top left corner
														  // of food block and head of the snake.      
			begin
				len = len + 1; // increase length by 1 if food block is being eaten.
				foodeat = 1; // set foodeat=1 to triger new food block generation
			end

		
		if(foodeat)
			begin
				xposfood = 144 + (headx*2 + headx2*2 + headx3*1)%621; 
				yposfood = 35 + (heady*2 + headx2)%404; 
				foodeat = 0;
			end
		if(len>2)       // if a block exists, it'll replace the next block
		begin
			heady2 <= heady;
			headx2 <= headx;
		end
		// similar checking of length and replacement for all valid blocks.
		if(len>3)
		begin
			heady3 <= heady2;
			headx3 <= headx2;
		end
		if(len>4)
		begin
			heady4 <= heady3;
			headx4 <= headx3;
		end
		if(len>5)
		begin
			heady5 <= heady4;
			headx5 <= headx4;
		end
		if(len>6)
		begin
			heady6 <= heady5;
			headx6 <= headx5;
		end
		if(len>7)
		begin
			heady7 <= heady6;
			headx7 <= headx6;
            if ((((headx - headx6 < 10) & (headx - headx6 >= 0)) 
		    || ((headx6 - headx >= 0) & (headx6 - headx < 10))) 
		    & (((heady - heady6 < 10) & (heady - heady6 >= 0))
		    || ((heady6 - heady < 10)) & (heady6 - heady >= 0)))
		  begin
		    done_flag <= 1;
		  end
		end
		if(len>8)
		begin
			heady8 <= heady7;
			headx8 <= headx7;
          if ((((headx - headx7 < 10) & (headx - headx7 >= 0)) 
		  || ((headx7 - headx >= 0) & (headx7 - headx < 10))) 
		  & (((heady - heady7 < 10) & (heady - heady7 >= 0))
		  || ((heady7 - heady < 10)) & (heady7 - heady >= 0)))
		  begin
		    done_flag <= 1;
		  end
		  if ((((headx - headx6 < 10) & (headx - headx6 >= 0)) 
		  || ((headx6 - headx >= 0) & (headx6 - headx < 10))) 
		  & (((heady - heady6 < 10) & (heady - heady6 >= 0))
		  || ((heady6 - heady < 10)) & (heady6 - heady >= 0)))
		  begin
		    done_flag <= 1;
		  end
		end
		if(len>9)
		begin
			heady9 <= heady8;
			headx9 <= headx8;
		 if ((((headx - headx8 < 10) & (headx - headx8 >= 0)) 
		  || ((headx8 - headx >= 0) & (headx8 - headx < 10))) 
		  & (((heady - heady8 < 10) & (heady - heady8 >= 0))
		  || ((heady8 - heady < 10)) & (heady8 - heady >= 0)))
		  begin
		    done_flag <= 1;
		  end
		  if ((((headx - headx7 < 10) & (headx - headx7 >= 0)) 
		  || ((headx7 - headx >= 0) & (headx7 - headx < 10))) 
		  & (((heady - heady7 < 10) & (heady - heady7 >= 0))
		  || ((heady7 - heady < 10)) & (heady7 - heady >= 0)))
		  begin
		    done_flag <= 1;
		  end
		  if ((((headx - headx6 < 10) & (headx - headx6 >= 0)) 
		  || ((headx6 - headx >= 0) & (headx6 - headx < 10))) 
		  & (((heady - heady6 < 10) & (heady - heady6 >= 0))
		  || ((heady6 - heady < 10)) & (heady6 - heady >= 0)))
		  begin
		    done_flag <= 1;
		  end
		 if ((((headx - headx5 < 10) & (headx - headx5 >= 0)) 
		  || ((headx5 - headx >= 0) & (headx5 - headx < 10))) 
		  & (((heady - heady5 < 10) & (heady - heady5 >= 0))
		  || ((heady5 - heady < 10)) & (heady5 - heady >= 0)))
		  begin
		    done_flag <= 1;
		  end
		end
		if(len>10)
		begin
			heady10 <= heady9;
			headx10 <= headx9;
		  if ((((headx - headx9 < 10) & (headx - headx9 >= 0)) 
		  || ((headx9 - headx >= 0) & (headx9 - headx < 10))) 
		  & (((heady - heady9 < 10) & (heady - heady9 >= 0))
		  || ((heady9 - heady < 10)) & (heady9 - heady >= 0)))
		  begin
		    done_flag <= 1;
		  end
		  if ((((headx - headx8 < 10) & (headx - headx8 >= 0)) 
		  || ((headx8 - headx >= 0) & (headx8 - headx < 10))) 
		  & (((heady - heady8 < 10) & (heady - heady8 >= 0))
		  || ((heady8 - heady < 10)) & (heady8 - heady >= 0)))
		  begin
		    done_flag <= 1;
		  end
		  if ((((headx - headx7 < 10) & (headx - headx7 >= 0)) 
		  || ((headx7 - headx >= 0) & (headx7 - headx < 10))) 
		  & (((heady - heady7 < 10) & (heady - heady7 >= 0))
		  || ((heady7 - heady < 10)) & (heady7 - heady >= 0)))
		  begin
		    done_flag <= 1;
		  end
		  if ((((headx - headx6 < 10) & (headx - headx6 >= 0)) 
		  || ((headx6 - headx >= 0) & (headx6 - headx < 10))) 
		  & (((heady - heady6 < 10) & (heady - heady6 >= 0))
		  || ((heady6 - heady < 10)) & (heady6 - heady >= 0)))
		  begin
		    done_flag <= 1;
		  end
		 if ((((headx - headx5 < 10) & (headx - headx5 >= 0)) 
		  || ((headx5 - headx >= 0) & (headx5 - headx < 10))) 
		  & (((heady - heady5 < 10) & (heady - heady5 >= 0))
		  || ((heady5 - heady < 10)) & (heady5 - heady >= 0)))
		  begin
		    done_flag <= 1;
		  end
		end
		if(len>11)
		begin
			heady11 <= heady10;
			headx11 <= headx10;
		  if ((((headx - headx10 < 10) & (headx - headx10 >= 0)) 
		  || ((headx10 - headx >= 0) & (headx10 - headx < 10))) 
		  & (((heady - heady10 < 10) & (heady - heady10 >= 0))
		  || ((heady10 - heady < 10)) & (heady10 - heady >= 0)))
		  begin
		    done_flag <= 1;
		  end
		  if ((((headx - headx9 < 10) & (headx - headx9 >= 0)) 
		  || ((headx9 - headx >= 0) & (headx9 - headx < 10))) 
		  & (((heady - heady9 < 10) & (heady - heady9 >= 0))
		  || ((heady9 - heady < 10)) & (heady9 - heady >= 0)))
		  begin
		    done_flag <= 1;
		  end
		  if ((((headx - headx8 < 10) & (headx - headx8 >= 0)) 
		  || ((headx8 - headx >= 0) & (headx8 - headx < 10))) 
		  & (((heady - heady8 < 10) & (heady - heady8 >= 0))
		  || ((heady8 - heady < 10)) & (heady8 - heady >= 0)))
		  begin
		    done_flag <= 1;
		  end
		  if ((((headx - headx7 < 10) & (headx - headx7 >= 0)) 
		  || ((headx7 - headx >= 0) & (headx7 - headx < 10))) 
		  & (((heady - heady7 < 10) & (heady - heady7 >= 0))
		  || ((heady7 - heady < 10)) & (heady7 - heady >= 0)))
		  begin
		    done_flag <= 1;
		  end
		  if ((((headx - headx6 < 10) & (headx - headx6 >= 0)) 
		  || ((headx6 - headx >= 0) & (headx6 - headx < 10))) 
		  & (((heady - heady6 < 10) & (heady - heady6 >= 0))
		  || ((heady6 - heady < 10)) & (heady6 - heady >= 0)))
		  begin
		    done_flag <= 1;
		  end
		 if ((((headx - headx5 < 10) & (headx - headx5 >= 0)) 
		  || ((headx5 - headx >= 0) & (headx5 - headx < 10))) 
		  & (((heady - heady5 < 10) & (heady - heady5 >= 0))
		  || ((heady5 - heady < 10)) & (heady5 - heady >= 0)))
		  begin
		    done_flag <= 1;
		  end 
		end
		if(len>12)
		begin
			heady12 <= heady11;
			headx12 <= headx11;
		  if ((((headx - headx11 < 10) & (headx - headx11 >= 0)) 
		  || ((headx11 - headx >= 0) & (headx11 - headx < 10))) 
		  & (((heady - heady11 < 10) & (heady - heady11 >= 0))
		  || ((heady11 - heady < 10)) & (heady11 - heady >= 0)))
		  begin
		    done_flag <= 1;
		  end
		  if ((((headx - headx10 < 10) & (headx - headx10 >= 0)) 
		  || ((headx10 - headx >= 0) & (headx10 - headx < 10))) 
		  & (((heady - heady10 < 10) & (heady - heady10 >= 0))
		  || ((heady10 - heady < 10)) & (heady10 - heady >= 0)))
		  begin
		    done_flag <= 1;
		  end
		  if ((((headx - headx9 < 10) & (headx - headx9 >= 0)) 
		  || ((headx9 - headx >= 0) & (headx9 - headx < 10))) 
		  & (((heady - heady9 < 10) & (heady - heady9 >= 0))
		  || ((heady9 - heady < 10)) & (heady9 - heady >= 0)))
		  begin
		    done_flag <= 1;
		  end
		  if ((((headx - headx8 < 10) & (headx - headx8 >= 0)) 
		  || ((headx8 - headx >= 0) & (headx8 - headx < 10))) 
		  & (((heady - heady8 < 10) & (heady - heady8 >= 0))
		  || ((heady8 - heady < 10)) & (heady8 - heady >= 0)))
		  begin
		    done_flag <= 1;
		  end
		  if ((((headx - headx7 < 10) & (headx - headx7 >= 0)) 
		  || ((headx7 - headx >= 0) & (headx7 - headx < 10))) 
		  & (((heady - heady7 < 10) & (heady - heady7 >= 0))
		  || ((heady7 - heady < 10)) & (heady7 - heady >= 0)))
		  begin
		    done_flag <= 1;
		  end
		  if ((((headx - headx6 < 10) & (headx - headx6 >= 0)) 
		  || ((headx6 - headx >= 0) & (headx6 - headx < 10))) 
		  & (((heady - heady6 < 10) & (heady - heady6 >= 0))
		  || ((heady6 - heady < 10)) & (heady6 - heady >= 0)))
		  begin
		    done_flag <= 1;
		  end
		 if ((((headx - headx5 < 10) & (headx - headx5 >= 0)) 
		  || ((headx5 - headx >= 0) & (headx5 - headx < 10))) 
		  & (((heady - heady5 < 10) & (heady - heady5 >= 0))
		  || ((heady5 - heady < 10)) & (heady5 - heady >= 0)))
		  begin
		    done_flag <= 1;
		  end 
		end
		if(len>13)
		begin
			heady13 <= heady12;
			headx13 <= headx12;
		  if ((((headx - headx12 < 10) & (headx - headx12 >= 0)) 
		  || ((headx12 - headx >= 0) & (headx12 - headx < 10))) 
		  & (((heady - heady12 < 10) & (heady - heady12 >= 0))
		  || ((heady12 - heady < 10)) & (heady12 - heady >= 0)))
		  begin
		    done_flag <= 1;
		  end
		  if ((((headx - headx11 < 10) & (headx - headx11 >= 0)) 
		  || ((headx11 - headx >= 0) & (headx11 - headx < 10))) 
		  & (((heady - heady11 < 10) & (heady - heady11 >= 0))
		  || ((heady11 - heady < 10)) & (heady11 - heady >= 0)))
		  begin
		    done_flag <= 1;
		  end
		  if ((((headx - headx10 < 10) & (headx - headx10 >= 0)) 
		  || ((headx10 - headx >= 0) & (headx10 - headx < 10))) 
		  & (((heady - heady10 < 10) & (heady - heady10 >= 0))
		  || ((heady10 - heady < 10)) & (heady10 - heady >= 0)))
		  begin
		    done_flag <= 1;
		  end
		  if ((((headx - headx9 < 10) & (headx - headx9 >= 0)) 
		  || ((headx9 - headx >= 0) & (headx9 - headx < 10))) 
		  & (((heady - heady9 < 10) & (heady - heady9 >= 0))
		  || ((heady9 - heady < 10)) & (heady9 - heady >= 0)))
		  begin
		    done_flag <= 1;
		  end
		  if ((((headx - headx8 < 10) & (headx - headx8 >= 0)) 
		  || ((headx8 - headx >= 0) & (headx8 - headx < 10))) 
		  & (((heady - heady8 < 10) & (heady - heady8 >= 0))
		  || ((heady8 - heady < 10)) & (heady8 - heady >= 0)))
		  begin
		    done_flag <= 1;
		  end
		  if ((((headx - headx7 < 10) & (headx - headx7 >= 0)) 
		  || ((headx7 - headx >= 0) & (headx7 - headx < 10))) 
		  & (((heady - heady7 < 10) & (heady - heady7 >= 0))
		  || ((heady7 - heady < 10)) & (heady7 - heady >= 0)))
		  begin
		    done_flag <= 1;
		  end
		  if ((((headx - headx6 < 10) & (headx - headx6 >= 0)) 
		  || ((headx6 - headx >= 0) & (headx6 - headx < 10))) 
		  & (((heady - heady6 < 10) & (heady - heady6 >= 0))
		  || ((heady6 - heady < 10)) & (heady6 - heady >= 0)))
		  begin
		    done_flag <= 1;
		  end
		 if ((((headx - headx5 < 10) & (headx - headx5 >= 0)) 
		  || ((headx5 - headx >= 0) & (headx5 - headx < 10))) 
		  & (((heady - heady5 < 10) & (heady - heady5 >= 0))
		  || ((heady5 - heady < 10)) & (heady5 - heady >= 0)))
		  begin
		    done_flag <= 1;
		  end 
		end
		if(len>14)
		begin
			heady14 <= heady13;
			headx14 <= headx13;
		  if ((((headx - headx13 < 10) & (headx - headx13 >= 0)) 
		  || ((headx13 - headx >= 0) & (headx13 - headx < 10))) 
		  & (((heady - heady12 < 10) & (heady - heady13 >= 0))
		  || ((heady13 - heady < 10)) & (heady13 - heady >= 0)))
		  begin
		    done_flag <= 1;
		  end
		   if ((((headx - headx12 < 10) & (headx - headx12 >= 0)) 
		  || ((headx12 - headx >= 0) & (headx12 - headx < 10))) 
		  & (((heady - heady12 < 10) & (heady - heady12 >= 0))
		  || ((heady12 - heady < 10)) & (heady12 - heady >= 0)))
		  begin
		    done_flag <= 1;
		  end
		  if ((((headx - headx11 < 10) & (headx - headx11 >= 0)) 
		  || ((headx11 - headx >= 0) & (headx11 - headx < 10))) 
		  & (((heady - heady11 < 10) & (heady - heady11 >= 0))
		  || ((heady11 - heady < 10)) & (heady11 - heady >= 0)))
		  begin
		    done_flag <= 1;
		  end
		  if ((((headx - headx10 < 10) & (headx - headx10 >= 0)) 
		  || ((headx10 - headx >= 0) & (headx10 - headx < 10))) 
		  & (((heady - heady10 < 10) & (heady - heady10 >= 0))
		  || ((heady10 - heady < 10)) & (heady10 - heady >= 0)))
		  begin
		    done_flag <= 1;
		  end
		  if ((((headx - headx9 < 10) & (headx - headx9 >= 0)) 
		  || ((headx9 - headx >= 0) & (headx9 - headx < 10))) 
		  & (((heady - heady9 < 10) & (heady - heady9 >= 0))
		  || ((heady9 - heady < 10)) & (heady9 - heady >= 0)))
		  begin
		    done_flag <= 1;
		  end
		  if ((((headx - headx8 < 10) & (headx - headx8 >= 0)) 
		  || ((headx8 - headx >= 0) & (headx8 - headx < 10))) 
		  & (((heady - heady8 < 10) & (heady - heady8 >= 0))
		  || ((heady8 - heady < 10)) & (heady8 - heady >= 0)))
		  begin
		    done_flag <= 1;
		  end
		  if ((((headx - headx7 < 10) & (headx - headx7 >= 0)) 
		  || ((headx7 - headx >= 0) & (headx7 - headx < 10))) 
		  & (((heady - heady7 < 10) & (heady - heady7 >= 0))
		  || ((heady7 - heady < 10)) & (heady7 - heady >= 0)))
		  begin
		    done_flag <= 1;
		  end
		  if ((((headx - headx6 < 10) & (headx - headx6 >= 0)) 
		  || ((headx6 - headx >= 0) & (headx6 - headx < 10))) 
		  & (((heady - heady6 < 10) & (heady - heady6 >= 0))
		  || ((heady6 - heady < 10)) & (heady6 - heady >= 0)))
		  begin
		    done_flag <= 1;
		  end
		 if ((((headx - headx5 < 10) & (headx - headx5 >= 0)) 
		  || ((headx5 - headx >= 0) & (headx5 - headx < 10))) 
		  & (((heady - heady5 < 10) & (heady - heady5 >= 0))
		  || ((heady5 - heady < 10)) & (heady5 - heady >= 0)))
		  begin
		    done_flag <= 1;
		  end 
		end
		if(len>15)
		begin
			heady15 <= heady14;
			headx15 <= headx14;
		  if ((((headx - headx14 < 10) & (headx - headx14 >= 0)) 
		  || ((headx14 - headx >= 0) & (headx14 - headx < 10))) 
		  & (((heady - heady14 < 10) & (heady - heady14 >= 0))
		  || ((heady14 - heady < 10)) & (heady14 - heady >= 0)))
		  begin
		    done_flag <= 1;
		  end
		  if ((((headx - headx13 < 10) & (headx - headx13 >= 0)) 
		  || ((headx13 - headx >= 0) & (headx13 - headx < 10))) 
		  & (((heady - heady12 < 10) & (heady - heady13 >= 0))
		  || ((heady13 - heady < 10)) & (heady13 - heady >= 0)))
		  begin
		    done_flag <= 1;
		  end
		   if ((((headx - headx12 < 10) & (headx - headx12 >= 0)) 
		  || ((headx12 - headx >= 0) & (headx12 - headx < 10))) 
		  & (((heady - heady12 < 10) & (heady - heady12 >= 0))
		  || ((heady12 - heady < 10)) & (heady12 - heady >= 0)))
		  begin
		    done_flag <= 1;
		  end
		  if ((((headx - headx11 < 10) & (headx - headx11 >= 0)) 
		  || ((headx11 - headx >= 0) & (headx11 - headx < 10))) 
		  & (((heady - heady11 < 10) & (heady - heady11 >= 0))
		  || ((heady11 - heady < 10)) & (heady11 - heady >= 0)))
		  begin
		    done_flag <= 1;
		  end
		  if ((((headx - headx10 < 10) & (headx - headx10 >= 0)) 
		  || ((headx10 - headx >= 0) & (headx10 - headx < 10))) 
		  & (((heady - heady10 < 10) & (heady - heady10 >= 0))
		  || ((heady10 - heady < 10)) & (heady10 - heady >= 0)))
		  begin
		    done_flag <= 1;
		  end
		  if ((((headx - headx9 < 10) & (headx - headx9 >= 0)) 
		  || ((headx9 - headx >= 0) & (headx9 - headx < 10))) 
		  & (((heady - heady9 < 10) & (heady - heady9 >= 0))
		  || ((heady9 - heady < 10)) & (heady9 - heady >= 0)))
		  begin
		    done_flag <= 1;
		  end
		  if ((((headx - headx8 < 10) & (headx - headx8 >= 0)) 
		  || ((headx8 - headx >= 0) & (headx8 - headx < 10))) 
		  & (((heady - heady8 < 10) & (heady - heady8 >= 0))
		  || ((heady8 - heady < 10)) & (heady8 - heady >= 0)))
		  begin
		    done_flag <= 1;
		  end
		  if ((((headx - headx7 < 10) & (headx - headx7 >= 0)) 
		  || ((headx7 - headx >= 0) & (headx7 - headx < 10))) 
		  & (((heady - heady7 < 10) & (heady - heady7 >= 0))
		  || ((heady7 - heady < 10)) & (heady7 - heady >= 0)))
		  begin
		    done_flag <= 1;
		  end
		  if ((((headx - headx6 < 10) & (headx - headx6 >= 0)) 
		  || ((headx6 - headx >= 0) & (headx6 - headx < 10))) 
		  & (((heady - heady6 < 10) & (heady - heady6 >= 0))
		  || ((heady6 - heady < 10)) & (heady6 - heady >= 0)))
		  begin
		    done_flag <= 1;
		  end
		 if ((((headx - headx5 < 10) & (headx - headx5 >= 0)) 
		  || ((headx5 - headx >= 0) & (headx5 - headx < 10))) 
		  & (((heady - heady5 < 10) & (heady - heady5 >= 0))
		  || ((heady5 - heady < 10)) & (heady5 - heady >= 0)))
		  begin
		    done_flag <= 1;
		  end 
		end
		if(len>16)
		begin
			heady16 <= heady15;
			headx16 <= headx15;
		  if ((((headx - headx15 < 10) & (headx - headx15 >= 0)) 
		  || ((headx15 - headx >= 0) & (headx15 - headx < 10))) 
		  & (((heady - heady15 < 10) & (heady - heady15 >= 0))
		  || ((heady15 - heady < 10)) & (heady15 - heady >= 0)))
		  begin
		    done_flag <= 1;
		  end
		  if ((((headx - headx14 < 10) & (headx - headx14 >= 0)) 
		  || ((headx14 - headx >= 0) & (headx14 - headx < 10))) 
		  & (((heady - heady14 < 10) & (heady - heady14 >= 0))
		  || ((heady14 - heady < 10)) & (heady14 - heady >= 0)))
		  begin
		    done_flag <= 1;
		  end
		  if ((((headx - headx13 < 10) & (headx - headx13 >= 0)) 
		  || ((headx13 - headx >= 0) & (headx13 - headx < 10))) 
		  & (((heady - heady12 < 10) & (heady - heady13 >= 0))
		  || ((heady13 - heady < 10)) & (heady13 - heady >= 0)))
		  begin
		    done_flag <= 1;
		  end
		   if ((((headx - headx12 < 10) & (headx - headx12 >= 0)) 
		  || ((headx12 - headx >= 0) & (headx12 - headx < 10))) 
		  & (((heady - heady12 < 10) & (heady - heady12 >= 0))
		  || ((heady12 - heady < 10)) & (heady12 - heady >= 0)))
		  begin
		    done_flag <= 1;
		  end
		  if ((((headx - headx11 < 10) & (headx - headx11 >= 0)) 
		  || ((headx11 - headx >= 0) & (headx11 - headx < 10))) 
		  & (((heady - heady11 < 10) & (heady - heady11 >= 0))
		  || ((heady11 - heady < 10)) & (heady11 - heady >= 0)))
		  begin
		    done_flag <= 1;
		  end
		  if ((((headx - headx10 < 10) & (headx - headx10 >= 0)) 
		  || ((headx10 - headx >= 0) & (headx10 - headx < 10))) 
		  & (((heady - heady10 < 10) & (heady - heady10 >= 0))
		  || ((heady10 - heady < 10)) & (heady10 - heady >= 0)))
		  begin
		    done_flag <= 1;
		  end
		  if ((((headx - headx9 < 10) & (headx - headx9 >= 0)) 
		  || ((headx9 - headx >= 0) & (headx9 - headx < 10))) 
		  & (((heady - heady9 < 10) & (heady - heady9 >= 0))
		  || ((heady9 - heady < 10)) & (heady9 - heady >= 0)))
		  begin
		    done_flag <= 1;
		  end
		  if ((((headx - headx8 < 10) & (headx - headx8 >= 0)) 
		  || ((headx8 - headx >= 0) & (headx8 - headx < 10))) 
		  & (((heady - heady8 < 10) & (heady - heady8 >= 0))
		  || ((heady8 - heady < 10)) & (heady8 - heady >= 0)))
		  begin
		    done_flag <= 1;
		  end
		  if ((((headx - headx7 < 10) & (headx - headx7 >= 0)) 
		  || ((headx7 - headx >= 0) & (headx7 - headx < 10))) 
		  & (((heady - heady7 < 10) & (heady - heady7 >= 0))
		  || ((heady7 - heady < 10)) & (heady7 - heady >= 0)))
		  begin
		    done_flag <= 1;
		  end
		  if ((((headx - headx6 < 10) & (headx - headx6 >= 0)) 
		  || ((headx6 - headx >= 0) & (headx6 - headx < 10))) 
		  & (((heady - heady6 < 10) & (heady - heady6 >= 0))
		  || ((heady6 - heady < 10)) & (heady6 - heady >= 0)))
		  begin
		    done_flag <= 1;
		  end
		 if ((((headx - headx5 < 10) & (headx - headx5 >= 0)) 
		  || ((headx5 - headx >= 0) & (headx5 - headx < 10))) 
		  & (((heady - heady5 < 10) & (heady - heady5 >= 0))
		  || ((heady5 - heady < 10)) & (heady5 - heady >= 0)))
		  begin
		    done_flag <= 1;
		  end 
		end
		if(len>17)
		begin
			done_flag <= 1;
		end
		(* full_case, parallel_case *)
		 case (state)
			INI	: 
			  begin
				 // RTL operations in the DPU (Data Path Unit) 
				len = 2;
				headx <= 450;
				heady <= 250;
				xposfood <= 470;
				yposfood <= 300;
				foodeat = 0;
				headx2 = 0;
				heady2 = 0;
				headx3 = 0;
				heady3 = 0;
				headx4 = 0;
				heady4 = 0;
				headx5 = 0;
				heady5 = 0;
				headx6 = 0;
				heady6 = 0;
				headx7 = 0;
				heady7 = 0;
				headx8 = 0;
				heady8 = 0;
				headx9 = 0;
				heady9 = 0;
				headx10 = 0;
				heady10 = 0;
				headx11 = 0;
				heady11 = 0;
				headx12 = 0;
				heady12 = 0;
				headx13 = 0;
				heady13 = 0;
				headx14 = 0;
				heady14 = 0;
				headx15 = 0;
				heady15 = 0;
				headx16 = 0;
				heady16 = 0;
				headx17 = 0;
				heady17 = 0;
				done_flag = 0;
			  end
			MOVING_RIGHT : 
			  begin
				headx<=headx+10; //change the amount you increment to make the speed faster 
			  end
			MOVING_LEFT	: 
			  begin
				headx<=headx-10;
			  end
			MOVING_UP	: 
			  begin
				heady<=heady-10;
			  end
			MOVING_DOWN	: 
			  begin
				heady<=heady+10;
			  end
			DONE	:
			  begin  
				 // state transitions in the control unit
				  done_flag <= 0;
			   end    
		endcase
	end
endmodule
