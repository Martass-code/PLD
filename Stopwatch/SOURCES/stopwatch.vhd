library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
----------------------------------------------------------------------------------
-- 4 bitovy BCD citac 
entity stopwatch is
    Port ( CLK : in STD_LOGIC;
           CE_100HZ : in STD_LOGIC;
           CNT_ENABLE : in STD_LOGIC;
           DISP_ENABLE : in STD_LOGIC;
           CNT_RESET : in STD_LOGIC;
           CNT_0 : out STD_LOGIC_VECTOR (3 downto 0) := (OTHERS => '0');
           CNT_1 : out STD_LOGIC_VECTOR (3 downto 0) := (OTHERS => '0');
           CNT_2 : out STD_LOGIC_VECTOR (3 downto 0) := (OTHERS => '0');
           CNT_3 : out STD_LOGIC_VECTOR (3 downto 0) := (OTHERS => '0')
           );
end stopwatch;
----------------------------------------------------------------------------------
architecture Behavioral of stopwatch is
----------------------------------------------------------------------------------
  --aktualni vystup BCD
  SIGNAL cnt_0_reg  : UNSIGNED(3 DOWNTO 0) := (OTHERS => '0');
  SIGNAL cnt_1_reg  : UNSIGNED(3 DOWNTO 0) := (OTHERS => '0');
  SIGNAL cnt_2_reg  : UNSIGNED(3 DOWNTO 0) := (OTHERS => '0');
  SIGNAL cnt_3_reg  : UNSIGNED(3 DOWNTO 0) := (OTHERS => '0');
  --pripraveny dalsi vystup na BCD
  SIGNAL cnt_0_next  :  UNSIGNED(3 DOWNTO 0) := (OTHERS => '0');
  SIGNAL cnt_1_next  :  UNSIGNED(3 DOWNTO 0) := (OTHERS => '0');
  SIGNAL cnt_2_next  :  UNSIGNED(3 DOWNTO 0) := (OTHERS => '0');
  SIGNAL cnt_3_next  :  UNSIGNED(3 DOWNTO 0) := (OTHERS => '0');

----------------------------------------------------------------------------------
begin
----------------------------------------------------------------------------------
BCD_counter_REG: PROCESS (clk) --vystupni registr
BEGIN
  IF rising_edge(clk) THEN
      
    --vynulovani citace -synchronni reset 
    --mozna next state?
    IF cnt_reset = '1' THEN 
      cnt_0_reg <= (OTHERS => '0');
      cnt_1_reg <= (OTHERS => '0');
      cnt_2_reg <= (OTHERS => '0');
      cnt_3_reg <= (OTHERS => '0');
    ELSE
      cnt_0_reg <= cnt_0_next; --s hranou prepne next na reg vystup
      cnt_1_reg <= cnt_1_next;
      cnt_2_reg <= cnt_2_next;
      cnt_3_reg <= cnt_3_next;
    END IF;
    
   --kdyz 0 tak zastavi cas na displeji (LAP mode) 
    IF (disp_enable = '1') THEN
      --ze signalu na vystup   
      CNT_0 <= STD_LOGIC_VECTOR(cnt_0_reg);
      CNT_1 <= STD_LOGIC_VECTOR(cnt_1_reg);
      CNT_2 <= STD_LOGIC_VECTOR(cnt_2_reg);
      CNT_3 <= STD_LOGIC_VECTOR(cnt_3_reg);
    END IF;   
    
  END IF;
END PROCESS BCD_counter_REG;

BCD_counter_comb: PROCESS (cnt_0_reg, cnt_1_reg, cnt_2_reg, cnt_3_reg, CNT_ENABLE, CE_100HZ)
BEGIN
  cnt_0_next <= cnt_0_reg; --zamezeni latch
  cnt_1_next <= cnt_1_reg; --zamezeni latch
  cnt_2_next <= cnt_2_reg; --zamezeni latch
  cnt_3_next <= cnt_3_reg; --zamezeni latch  
  
  -- CNT_ENABLE - 1=START 0=STOP 
  IF (CE_100HZ = '1') AND (CNT_ENABLE = '1') THEN 
    --pro 0.misto na dipleji
    IF cnt_0_reg = X"9" THEN --citani do 9 - pak se vynuluje
      cnt_0_next <= (OTHERS => '0');
    ELSE
      cnt_0_next <= cnt_0_reg + 1; --kdyz je mensi nez 9 tak inkrementuj
    END IF;
    --pro 1.misto na dipleji
    IF cnt_0_reg = X"9" THEN --citani do 9 - pak se vynuluje
      IF cnt_1_reg = X"9" THEN --citani do 9 - pak se vynuluje
        cnt_1_next <= (OTHERS => '0');
      ELSE
        cnt_1_next <= cnt_1_reg + 1; --kdyz je mensi nez 9 tak inkrementuj
      END IF;      
    END IF;   
    --pro 2.misto na dipleji
    IF cnt_0_reg = X"9" THEN --citani do 9 - pak se vynuluje   
      IF cnt_1_reg = X"9" THEN --citani do 9 - pak se vynuluje
        IF cnt_2_reg = X"9" THEN --citani do 9 - pak se vynuluje
          cnt_2_next <= (OTHERS => '0');
        ELSE
          cnt_2_next <= cnt_2_reg + 1; --kdyz je mensi nez 9 tak inkrementuj
        END IF;            
      END IF;  
    END IF;   
    --pro 3.misto na dipleji
    IF cnt_0_reg = X"9" THEN --citani do 9 - pak se vynuluje   
      IF cnt_1_reg = X"9" THEN --citani do 9 - pak se vynuluje
        IF cnt_2_reg = X"9" THEN --citani do 9 - pak se vynuluje
          IF cnt_3_reg = X"5" THEN --citani do 5 - pak se vynuluje       
            cnt_3_next <= (OTHERS => '0');
          ELSE
            cnt_3_next <= cnt_3_reg + 1; --kdyz je mensi nez 5 tak inkrementuj
          END IF;   
        END IF;            
      END IF;  
    END IF;     

  END IF;  
  
END PROCESS BCD_counter_comb;



----------------------------------------------------------------------------------
end Behavioral;
----------------------------------------------------------------------------------
