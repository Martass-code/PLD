library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
----------------------------------------------------------------------------------
entity edge_detector is
    Port ( sig_in : in STD_LOGIC;
           clk : in STD_LOGIC;
           edge_pos : out STD_LOGIC;
           edge_neg : out STD_LOGIC;
           edge_any : out STD_LOGIC);
end edge_detector;
----------------------------------------------------------------------------------
architecture Behavioral of edge_detector is
----------------------------------------------------------------------------------

----------------------------------------------------------------------------------
begin
----------------------------------------------------------------------------------
  PROCESS (clk) BEGIN
    IF rising_edge(clk) THEN
      
    END IF;
  END PROCESS;
----------------------------------------------------------------------------------
end Behavioral;
----------------------------------------------------------------------------------