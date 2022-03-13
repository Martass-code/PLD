library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
----------------------------------------------------------------------------------
entity btn_in is
    GENERIC(
      DEB_PERIOD  : POSITIVE := 3
    );
    Port ( clk : in STD_LOGIC;
           ce : in STD_LOGIC;
           btn : in STD_LOGIC;
           btn_debounced : out STD_LOGIC;
           btn_edge_pos : out STD_LOGIC;
           btn_edge_neg : out STD_LOGIC;
           btn_edge_any : out STD_LOGIC
           );
end btn_in;
----------------------------------------------------------------------------------
architecture Behavioral of btn_in is
----------------------------------------------------------------------------------
  SIGNAL btn_meta_removed_signal : STD_LOGIC := '0'; 
  SIGNAL btn_debounced_signal : STD_LOGIC := '0';

  COMPONENT sync_reg is
      PORT ( sig_in : in STD_LOGIC;
             clk : in STD_LOGIC;
             sig_out : out STD_LOGIC
             );
  END COMPONENT;
  
  COMPONENT debouncer is
      GENERIC(
        DEB_PERIOD  : POSITIVE := 20
      );
      Port ( btn_in : in STD_LOGIC;
             ce : in STD_LOGIC;
             clk : in STD_LOGIC;
             btn_out : out STD_LOGIC
             );
  END COMPONENT;
  
  COMPONENT edge_detector is
      Port ( sig_in : in STD_LOGIC;
             clk : in STD_LOGIC;
             edge_pos : out STD_LOGIC;
             edge_neg : out STD_LOGIC;
             edge_any : out STD_LOGIC
             );
  END COMPONENT;
----------------------------------------------------------------------------------
begin
----------------------------------------------------------------------------------
  sync_reg_i : sync_reg
  PORT MAP(
    sig_in => btn,
    clk => clk,
    sig_out => btn_meta_removed_signal    
  );
  
  debouncer_i : debouncer
  PORT MAP(
    btn_in => btn_meta_removed_signal, 
    ce => ce,    
    clk => clk,   
    btn_out => btn_debounced_signal    
  );
  
  edge_detector_i : edge_detector
  PORT MAP (
    sig_in => btn_debounced_signal,  
    clk  => clk,
    edge_pos => btn_edge_pos,
    edge_neg => btn_edge_neg,
    edge_any => btn_edge_any  
  );
  
  btn_debounced <= btn_debounced_signal; --vystup btn_in
----------------------------------------------------------------------------------
end Behavioral;
----------------------------------------------------------------------------------