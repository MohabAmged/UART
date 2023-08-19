library ieee; 
use ieee.std_logic_1164.all;

entity TX_UART is
  port (
    rst         : in std_logic ;
    BCLK        : in std_logic ;
    Enable      : in std_logic ;
   -- DATA_E      : in std_logic ;
    DATA_TX     : in std_logic_vector ( 7 downto 0 );
    TX_BIT      : out std_logic ;
    FINISH_FLAG : out std_logic 

  ) ;
end TX_UART;

architecture arch of TX_UART is
    signal TX     : std_logic ;
    signal TX_sig : std_logic ;
    signal DATA_V : std_logic ;
    signal finish : std_logic ;              
    signal data   : std_logic_vector ( 7 downto 0);
    signal TX_CLK : std_logic ;
    signal DATA_SH : std_logic_vector (7 downto 0 );
    type state_type is (st1 ,st2 ,st3,st4 ) ;
    signal state , next_state : state_type ;
begin

        TX_BIT <= TX;


    Counter : process( BCLK ,rst   )
   
        variable count : integer range 0 to 15 ;

    begin
        
        if rst = '1'  then
            count := 0;
            TX_CLK <= '0';

            elsif rising_edge(BCLK) then
                 
                if count = 15 then
                    count :=0;
                    TX_CLK <= '1';
                else
                    count := count + 1 ;  
                    TX_CLK <= '0';  
                end if ;

        end if ;

    end process ; -- Counter
    
  DATA_REG : process( BCLK , rst , DATA_TX , Enable,state)
     begin
        if rst = '1' then
            data <= "00000000";
            DATA_V<= '0' ;           
            elsif rising_edge ( BCLK) then
                if Enable = '1' and state = st1 then
                    data <= DATA_TX ;
                    DATA_V<= '1';
                 else 
                  DATA_V <= '0';  
                end if ;
        end if ;
   
    end process ; -- DATA_REG

    
    

    FRAME_COUNTER : process( TX_CLK ,rst )
   
        variable count_frame : integer range 0 to 7 ;

    begin
        
        if rst = '1'  then
            count_frame := 0;
            finish <= '0';    
            elsif rising_edge(TX_CLK) then
               if next_state = st3 then
                    if count_frame = 7  then
                        count_frame :=0;
                        finish <= '1';
                    else
                    count_frame := count_frame + 1 ;
                    finish <= '0';     
                    end if ;
                else 
                finish <= '0';
                count_frame :=0;    
                end if;
        end if ;

    end process ; -- Counter




    FSM_SEQ : process( rst , TX_CLK , next_state  )
    begin
        if rst = '1'  then
            state <= st1;
            elsif rising_edge(TX_CLK) then
               if Enable = '1' then
                state <= next_state; 
                else
                state <= st1; 
               end if ;
        end if ;
    end process ; -- TX


    FSM_COMBO : process( state, DATA_v ,finish ,TX_sig)
    
    begin
         case( state ) is
         
            when st1 =>
                    if DATA_v = '1' then
                        next_state <= st2 ;
                        else
                        next_state <= st1 ;
                    end if ;
                    FINISH_FLAG <= '1';          
                    TX <= '1' ;
            when st2 =>
                    FINISH_FLAG <= '0';          
                    next_state <= st3 ;
                    TX <= '0' ;                  
            when st3 =>
                    TX <= TX_sig;
                    FINISH_FLAG <= '0';          
                    if finish ='1' then
                        next_state <= st4 ;
                        else
                        next_state <= st3 ;                        
                    end if ;        
            when st4 =>     
                     TX <= '1' ;
                     next_state <= st1 ; 
                     FINISH_FLAG <= '1';          
            when others =>
                     FINISH_FLAG <= '1';          
                     TX <= '1' ;
                     next_state <= st1 ; 
         end case ;


    end process ; -- FSM_COMBO


   SHIFT_REG : process (state , TX_CLK , rst ,DATA_SH,data , data_v )
   begin
         if rst = '1'  then
            TX_sig <= '0';
            DATA_SH <= x"00";
            elsif rising_edge(TX_CLK) then
                if data_v = '1' then 
                DATA_SH <= data ;
              elsif next_state = st3 then
                    TX_sig     <= DATA_SH(0);
                    DATA_SH(0) <= DATA_SH(1);
                    DATA_SH(1) <= DATA_SH(2);
                    DATA_SH(2) <= DATA_SH(3);
                    DATA_SH(3) <= DATA_SH(4);
                    DATA_SH(4) <= DATA_SH(5);
                    DATA_SH(5) <= DATA_SH(6);
                    DATA_SH(6) <= DATA_SH(7);
                    DATA_SH(7) <= '0';   
                end if ;

         end if ;   

end process;


end arch ; -- arch