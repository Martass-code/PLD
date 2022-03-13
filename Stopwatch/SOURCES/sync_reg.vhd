library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
----------------------------------------------------------------------------------
entity sync_reg is
    Port ( sig_in : in STD_LOGIC;
           clk : in STD_LOGIC;
           sig_out : out STD_LOGIC);
end sync_reg;
----------------------------------------------------------------------------------
architecture Behavioral of sync_reg is
----------------------------------------------------------------------------------
SIGNAL  sig_reg : STD_LOGIC := '0';

attribute ASYNC_REG : string;
attribute ASYNC_REG of sig_reg : signal is "TRUE";
attribute ASYNC_REG of sig_out : signal is "TRUE";

attribute SHREG_EXTRACT : string;
attribute SHREG_EXTRACT of sig_reg : signal is "NO";
attribute SHREG_EXTRACT of sig_out : signal is "NO";
----------------------------------------------------------------------------------
begin
----------------------------------------------------------------------------------
  PROCESS(clk) BEGIN
    IF rising_edge(clk) THEN
      sig_reg <= sig_in;
      sig_out <= sig_reg;
    END IF;
  END PROCESS;

----------------------------------------------------------------------------------
end Behavioral;
----------------------------------------------------------------------------------
