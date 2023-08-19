library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
-- Ports
entity Baud_Rate_Gen is
  port (
    clk   : in std_logic ;
    rst   : in std_logic ;
    DLH   : in std_logic_vector (7 downto 0);
    DLL   : in std_logic_vector (7 downto 0);
    DLAB  : in std_logic;
    BCLK  : out std_logic
  ) ;
end Baud_Rate_Gen;

-- ARCH The Baud Rate is Working on x16 Sampling 
architecture arch of Baud_Rate_Gen is

    signal  DLH_REG , DLL_REG : std_logic_vector (7 downto 0);
    signal tmp : std_logic; 
    signal count_sh : std_logic_vector (15 downto 0);
begin

        BCLK <= tmp;
    BAUD : process( clk, rst ,DLAB,DLL,DLH)
    variable count : std_logic_vector (15 downto 0);
    begin
      if( rst = '1' ) then
        DLH_REG  <= x"00";
        DLL_REG  <= x"00";  
        count := x"0000"; 
        count_sh <= x"0000";
        tmp <='0';
      elsif( rising_edge(clk) ) then
            if DLAB = '1' then
                DLH_REG  <= DLH ;
                DLL_REG  <= DLL ;
                count_sh <= DLH_REG & DLL_REG;
                count := x"0000";
               else
               if count < count_sh then
                    count := std_logic_vector(unsigned(count)+1);
                    else
                    count := x"0000";
                    tmp <= not tmp;
                end if;
            end if ;
      end if ;
    end process ; -- BAUD
    

end arch ; -- arch