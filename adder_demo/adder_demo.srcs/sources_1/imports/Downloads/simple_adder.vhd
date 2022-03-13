---------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all; 
---------------------------------------------------------------
ENTITY simple_adder IS
  PORT( 
    A        : IN  STD_LOGIC_VECTOR( 3 DOWNTO 0);
    B        : IN  STD_LOGIC_VECTOR( 3 DOWNTO 0);
    Y        : OUT STD_LOGIC_VECTOR( 3 DOWNTO 0);
    C        : OUT STD_LOGIC;
    Z        : OUT STD_LOGIC 
  );
END ENTITY simple_adder;
---------------------------------------------------------------

ARCHITECTURE Behavioral OF simple_adder IS
  SIGNAL y_sig    : STD_LOGIC_VECTOR(4 DOWNTO 0); 
 
BEGIN

  y_sig <= STD_LOGIC_VECTOR( UNSIGNED'("00000") + UNSIGNED(A) + UNSIGNED(B) ); 

  Y <= y_sig( 3 DOWNTO 0);   

  C <= y_sig(4); 
  
  Z <= '1' WHEN (y_sig(3 DOWNTO 0) = "0000" ) ELSE '0'; 


END ARCHITECTURE Behavioral;
---------------------------------------------------------------
