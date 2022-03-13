----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 13.02.2022 20:46:30
-- Design Name: 
-- Module Name: RP_TOP - Behavioral
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
----------------------------------------------------------------------------------
entity RP_TOP is
    Port ( BTN : in STD_LOGIC_VECTOR (3 downto 0);
           SW : in STD_LOGIC_VECTOR (3 downto 0);
           LED : out STD_LOGIC_VECTOR (7 downto 0));
end RP_TOP;
----------------------------------------------------------------------------------
architecture Behavioral of RP_TOP is
----------------------------------------------------------------------------------
-- vlozeno z simple_adder.vhd
  COMPONENT simple_adder 
  PORT( --port - piny co jdou vena a dovnitr
    --VZDY! veskere vstup vystup budou STD_LOGIC_VECTOR nebo STD_LOGIC 
    --       smer signalu (defaoulne vstupni)   definice rozmeru 4 (konvence nejmene vyznamny bit je 0)
    A        : IN  STD_LOGIC_VECTOR( 3 DOWNTO 0);
    B        : IN  STD_LOGIC_VECTOR( 3 DOWNTO 0);
    Y        : OUT STD_LOGIC_VECTOR( 3 DOWNTO 0);
    C        : OUT STD_LOGIC;
    Z        : OUT STD_LOGIC --posledni signal v PORT mape - nedava se ; !!
  );
  END COMPONENT simple_adder;
----------------------------------------------------------------------------------
begin
----------------------------------------------------------------------------------
  simple_addre_i : simple_adder 
  PORT MAP ( --port - piny co jdou vena a dovnitr
    --VZDY! veskere vstup vystup budou STD_LOGIC_VECTOR nebo STD_LOGIC 
    --       smer signalu (defaoulne vstupni)   definice rozmeru 4 (konvence nejmene vyznamny bit je 0)
    A        => BTN,
    B        => SW,
    Y        => LED(3 DOWNTO 0),
    C        => LED(5),
    Z        => LED(7)
  );
  
  --osetreni nezapojenych ledek
  LED(4) <= '0';
  LED(6) <= '0';
----------------------------------------------------------------------------------
end Behavioral;
----------------------------------------------------------------------------------
