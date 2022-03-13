library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.NUMERIC_STD.ALL;
----------------------------------------------------------------------------------
ENTITY ce_gen IS
  GENERIC (
    --konstanta nastavitelna pri instanci
    DIV_FACT  : POSITIVE := 2  --clock division factor
  );
  PORT (
    clk       : IN  STD_LOGIC;  --clock signal
    srst  : IN STD_LOGIC;  --synchronous reset
    ce_in  : IN STD_LOGIC;  --input clock enable
    ce_out     : OUT STD_LOGIC  --clock enable output
  );
END ce_gen;
----------------------------------------------------------------------------------
ARCHITECTURE Behavioral OF ce_gen IS
----------------------------------------------------------------------------------

  SIGNAL cnt_div  : UNSIGNED(31 DOWNTO 0) := (OTHERS => '0'); --asi by slo upravovat podle velikosti DIV_FACT
  SIGNAL clk_EN  : STD_LOGIC := '0';

----------------------------------------------------------------------------------
BEGIN
----------------------------------------------------------------------------------

  clk_EN_gen: PROCESS(clk) BEGIN
    IF rising_edge(clk) THEN
      IF srst = '1' THEN --aktivovany reset
        clk_EN <= '0'; 
        cnt_div <= (OTHERS => '0'); --vynulovani citace
      ELSIF ce_in = '1' THEN  --povolene hodiny
        IF cnt_div = (DIV_FACT -1) THEN -- -1 aby sedela perioda clk_EN
          clk_EN <= '1'; --vygeneruje pulz o aktivni urovni 1 cyklus hodinovy
          cnt_div <= (OTHERS => '0');
        ELSE
          cnt_div <= cnt_div + 1;
          clk_EN <= '0';
        END IF;      
      END IF;
    END IF;
  END PROCESS clk_EN_gen;

  ce_out <= clk_EN;

----------------------------------------------------------------------------------
END Behavioral;
----------------------------------------------------------------------------------