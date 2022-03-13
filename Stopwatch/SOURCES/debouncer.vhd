library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
----------------------------------------------------------------------------------
--verze 2 - reaguje "okamzite" na zmackunit tlacitka a "okamzite na pusteni"
-- zpozdeni je "jen" perioda vzorkovani 
entity debouncer is
    GENERIC(
      --doba skakani - ovlivnuje i jak rychle jde tlacitko znovu zmacknout
      --v tehle dobe je tlacitko "zablokovane"
      --az po teto periode jde znovu zmacknout
      DEB_PERIOD  : POSITIVE := 20 
    );
    Port ( btn_in : in STD_LOGIC;
           ce : in STD_LOGIC;
           clk : in STD_LOGIC;
           btn_out : out STD_LOGIC := '0'
           );
end debouncer;
----------------------------------------------------------------------------------
architecture Behavioral of debouncer is
----------------------------------------------------------------------------------
SIGNAL wait_cnt : POSITIVE := 1; --pocet period, ktere bude cekat nez tlacitko doskace
SIGNAL bouncing : BOOLEAN := FALSE; -- 1 = tlacitko skace
SIGNAL btn_in_last : STD_LOGIC := '0'; --minuly vzorek tlacitka
----------------------------------------------------------------------------------
begin
----------------------------------------------------------------------------------
  PROCESS (clk) BEGIN
    IF rising_edge(clk) THEN
      IF ce = '1' THEN
        -- detekce nabezne hrany       
        IF btn_in = '1' AND btn_in_last = '0' AND bouncing = FALSE THEN
          btn_out <= '1'; --vystup debounceru - preslo se do stavu 1
          bouncing <= TRUE; --zacne pocitat cas skakani
          btn_in_last <= '1'; --aktualizace minuleho stavu tlacitka
        END IF;
        --detekce sestupne hrany        
        IF btn_in = '0' AND btn_in_last = '1'  AND bouncing = FALSE THEN
          btn_out <= '0'; --vystup debounceru - preslo se do stavu 0
          bouncing <= TRUE; --zacne pocitat cas skakani
          btn_in_last <= '0'; --aktualizace minuleho stavu tlacitka
        END IF;
        --cekani na odezneni skakani
        IF bouncing = TRUE THEN
          wait_cnt <= wait_cnt + 1;
          IF wait_cnt = DEB_PERIOD THEN
            bouncing <= FALSE;
            wait_cnt <= 1; --"vynulovani" citace
          END IF;
        END IF;         
        
      END IF;
    END IF;
  END PROCESS;
----------------------------------------------------------------------------------
end Behavioral;
----------------------------------------------------------------------------------