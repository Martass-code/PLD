library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
----------------------------------------------------------------------------------
entity edge_detector is
    Port ( sig_in : in STD_LOGIC;
           clk : in STD_LOGIC;
           edge_pos : out STD_LOGIC := '0';
           edge_neg : out STD_LOGIC := '0';
           edge_any : out STD_LOGIC := '0'
           );
end edge_detector;
----------------------------------------------------------------------------------
architecture Behavioral of edge_detector is
----------------------------------------------------------------------------------
--SIGNAL sig_in_last : STD_LOGIC := '0';
SIGNAL btn_delayed : STD_LOGIC := '0';
SIGNAL btn_pressed : STD_LOGIC := '0';
----------------------------------------------------------------------------------
begin
----------------------------------------------------------------------------------
  edge_detector_reg: PROCESS (clk) BEGIN
    IF rising_edge(clk) THEN
--      alternativa - je to ale zpozdene o jeden hodin cyklus    
--      edge_pos <= '0';
--      edge_neg <= '0';
--      edge_any <= '0';    
--      --detekce nabezne hrany
--      IF sig_in = '1' AND sig_in_last = '0' THEN
--        edge_pos <= '1';
--        edge_any <= '1';
--        sig_in_last <= '1';
--      END IF;
--      --detekce sestupne hrany
--       IF sig_in = '0' AND sig_in_last = '1' THEN
--        edge_neg <= '1';
--        edge_any <= '1';
--        sig_in_last <= '0';
--      END IF;
      
--      IF sig_in = sig_in_last THEN
--        edge_pos <= '0';
--        edge_neg <= '0';
--        edge_any <= '0';
--      END IF;

      btn_delayed <= sig_in; --zpozdeni signal z tlacitka  o jednu periodu clk 
           
    END IF;
  END PROCESS;  
  
  edge_detector_comb : PROCESS(sig_in, btn_delayed, btn_pressed) BEGIN
    edge_pos <= '0';--zamezeni latch
    edge_neg <= '0';--zamezeni latch
    edge_any <= '0';--zamezeni latch
    
    --generuje pulz o sirce 1 periody pri stisku a pusteni tlacitka
    --neni tam vpodstate zadne zpozdeni
    btn_pressed <= sig_in XOR btn_delayed; 
    
    --detekce nabezne hrany
    IF btn_pressed = '1' AND sig_in = '1' THEN
      edge_pos <= '1';
      edge_neg <= '0';
      edge_any <= '1';      
    END IF;
    --detekce sestupne hrany
    IF btn_pressed = '1' AND sig_in = '0' THEN
      edge_pos <= '0';
      edge_neg <= '1';
      edge_any <= '1';      
    END IF;    
    
  END PROCESS;  
----------------------------------------------------------------------------------
end Behavioral;
----------------------------------------------------------------------------------