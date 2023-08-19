----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:09:32 08/04/2023 
-- Design Name: 
-- Module Name:    Reciver_controller - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Reciver_controller is port 
(
	BCLK       : in  std_logic ;
	RX_BIT     : in	 std_logic ;
	rst        : in  std_logic ;
	RX_FINISH  : out std_logic ;
	RX_REG : out std_logic_vector (7 downto 0) 
);

end Reciver_controller;

architecture Behavioral of Reciver_controller is

	--signal Rx_signal 	  : std_logic ;
	signal REG    		  : std_logic_vector (7 downto 0) ;
	signal sample		  : std_logic ;
	signal finish 		  : std_logic ;
	signal Shift_reg 	  : std_logic_vector (7 downto 0) ;
	--Insert the following in the architecture before the begin keyword
   --Use descriptive names for the states, like st1_reset, st2_search
   type state_type is (st1, st2,st3); 
   signal state, next_state : state_type; 
   --Declare internal signals for all outputs of the state-machine
   --other outputs
 

begin
		  -- FINISH Flag 
		  RX_FINISH <= finish ;
		
		   Timer_proc: process (BCLK,rst)
			variable Bit_Count 		 : integer range 0 to 15 ;
			variable count           : integer range 0 to 7  ;
			variable first_time       : integer range 0 to 1 ;
						
						begin
							
							if ( rst = '1') then
								count     :=  0 ;
								sample    <= '0';
                                first_time := 0;
 								elsif ( rising_edge(BCLK)  ) then
								
										if ( count = 7 and first_time = 0 ) then 
											sample <= '1';
											first_time := 1;
											count :=0;
											Bit_Count :=0;
										elsif ( Bit_Count = 15 ) then 
											sample <= '1';
											Bit_Count := 0;
										else 
										count := count +1 ;
										Bit_Count := Bit_Count +1 ;	
										sample <= '0';
										end if;
								
							end if;
							
						end process;
	
	frame_counter : process( BCLK,rst , state )
	variable Frame_count : integer range 0 to 7 ;
	begin

		if ( rst = '1') then
			Frame_count := 0 ;
			finish <= '0';
			elsif ( rising_edge(BCLK)  ) then
				if state = st2 then
					if sample = '1' and Frame_count = 7 then
						finish <= '1';
						elsif sample = '1' then
						finish <= '0';
						Frame_count := Frame_count+1;
						else 
						finish <= '0';
		     		end if ;
				else
				Frame_count := 0 ;
				finish <= '0';
				end if ;
		end if;
		
	end process ; -- identifier					
		
		
--Insert the following in the architecture after the begin keyword
   SYNC_PROC: process (BCLK,rst)
   begin
		
		if ( rst = '1') then
			state <= st1;
			elsif ( rising_edge(BCLK ) ) then
			state <= next_state;
		end if;
		
   end process;



process (sample ,RX_BIT,BCLK ,rst,state)
begin

	if ( rst ='1') then 
	--rx_signal <='1';
	Shift_reg <=x"00";
   elsif  rising_edge (BCLK)  then  
		if (sample ='1' and state = st2) then
			--rx_signal <= RX_BIT;
			Shift_reg<= Shift_reg(6 downto 0) & RX_BIT;						
			else 
			--rx_signal<=rx_signal;
			Shift_reg<= Shift_reg;
			end if;
   end if;
end process;


OUTPUT : process( REG , BCLK , finish , rst )
begin
		if rst = '1' then
			RX_REG <= x"00";
			elsif rising_edge(BCLK) then
				if finish = '1' then
					RX_REG(0) <= REG(7);
					RX_REG(1) <= REG(6);
					RX_REG(2) <= REG(5);
					RX_REG(3) <= REG(4);
					RX_REG(4) <= REG(3);
					RX_REG(5) <= REG(2);
					RX_REG(6) <= REG(1);
					RX_REG(7) <= REG(0);
				end if ;
		end if ;

	
end process ; -- OUTPUT


   NEXT_STATE_DECODE: process (state ,RX_BIT,finish,Shift_reg,sample)
   begin
 --default is to stay in current state
      case (state) is
         when st1 =>
            if  sample = '1' and RX_BIT = '0' then
				REG  <= x"00";
				next_state <= st2;
					else 
				REG  <= x"00";
				next_state <= st1;
            end if;
         when st2 =>
            if  finish = '1' then
				 next_state <= st3;
				 REG <= Shift_reg ;
			  else		
			     REG  <= x"00";
				 next_state <= st2;
            end if;				
			when st3 =>
				if  ( RX_BIT = '1'and sample = '1'  )then
					next_state <= st1;
					REG <= Shift_reg;
					else 
					REG <= Shift_reg;
					next_state <= st3;
            end if;
         when others =>
				 REG <= x"00";
			     next_state <= st1 ;
      end case;      
   end process;
	
	
	
	


end Behavioral;

