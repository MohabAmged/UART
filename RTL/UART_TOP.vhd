----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 18.08.2023 17:24:41
-- Design Name: 
-- Module Name: UART_LCD - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
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
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity UART is Port (
rst : in std_logic ;
clk : in std_logic ;
RX       : in   std_logic;
TX       : out  std_logic;
RX_FIN   : out  std_logic;
TX_FIN   : out  std_logic;
RX_buff  : out  std_logic_vector( 7 downto 0);
TX_buff  : in   std_logic_vector( 7 downto 0);
DLH      : in  std_logic_vector (7 downto 0);
DLL      : in  std_logic_vector (7 downto 0);
DLAB     : in std_logic; 
Enable   : in  std_logic

 );
end UART;

architecture Behavioral of UART is
signal BCLK_sig :  std_logic;


component Reciver_controller port 
(
	BCLK       : in  std_logic ;
	RX_BIT     : in	 std_logic ;
	rst        : in  std_logic ;
	RX_FINISH  : out std_logic ;
	RX_REG : out std_logic_vector (7 downto 0) 
);
end component;

component Baud_Rate_Gen port (
    clk   : in std_logic ;
    rst   : in std_logic ;
    DLH   : in std_logic_vector (7 downto 0);
    DLL   : in std_logic_vector (7 downto 0);
    DLAB  : in std_logic;
    BCLK  : out std_logic
  ) ;
end component;

component TX_UART 
port (
    rst         : in std_logic ;
    BCLK        : in std_logic ;
    Enable      : in std_logic ;
   -- DATA_E      : in std_logic ;
    DATA_TX     : in std_logic_vector ( 7 downto 0 );
    TX_BIT      : out std_logic ;
    FINISH_FLAG : out std_logic 

  ) ;
end component;


begin

T1 : TX_UART

 port map  (
    rst         =>  rst ,
    BCLK        =>  BCLK_sig,
    Enable      =>  Enable,
    DATA_TX     =>  TX_buff,
    TX_BIT      =>  TX,
    FINISH_FLAG =>  TX_FIN 

);

R1: Reciver_controller port map
(
	BCLK         =>  BCLK_sig       ,
	RX_BIT       =>   RX            ,
	rst          =>   rst           ,
	RX_FINISH    =>   RX_FIN        ,
	RX_REG       =>   RX_buff            
);


B1 :  Baud_Rate_Gen port map (
    clk   =>  clk            ,
    rst   =>  rst            ,
    DLH   =>  DLH            ,
    DLL   =>  DLL            ,
    DLAB  =>  DLAB           ,
    BCLK  =>  BCLK_sig       
  ) ;




end Behavioral;



		
