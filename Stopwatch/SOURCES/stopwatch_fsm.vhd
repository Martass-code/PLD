library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
----------------------------------------------------------------------------------
entity stopwatch_fsm is
    Port ( btn_SS : in STD_LOGIC;
           btn_LC : in STD_LOGIC;
           cnt_enable : out STD_LOGIC;
           disp_enable : out STD_LOGIC;
           cnt_reset : out STD_LOGIC);
end stopwatch_fsm;
----------------------------------------------------------------------------------
architecture Behavioral of stopwatch_fsm is
----------------------------------------------------------------------------------
  --stavovy automat
  TYPE t_state_stopwatch IS (st_idle, st_run, st_lap, st_refresh, st_stop);
  SIGNAL pres_st  : t_state_stopwatch := st_idle;
  SIGNAL next_st  : t_state_stopwatch;
----------------------------------------------------------------------------------
begin
----------------------------------------------------------------------------------
  --blok next state logic
  next_state_logic : PROCESS(btn_SS, btn_LC, pres_st) BEGIN
    CASE pres_st IS
      WHEN st_idle => IF btn_s = '1' THEN next_st <= st_run;
                      ELSE IF .. 
    END CASE;  
  END PROCESS next_state_logic;
  
  --registr next_st na pres_st
  PROCESS(clk) BEGIN
    pres_st <= next_st;
  END BEGIN;

  --blok out logic --tady asi zapisovat do next (sig)
  out_logic : PROCESS (pres_st) BEGIN
    CASE pres_st IS 
      WHEN st_idle    => cnt_reset <= '1'; cnt_enable <= '0'; disp_enable <= '1';   
      WHEN st_run     => cnt_reset <= '0'; cnt_enable <= '1'; disp_enable <= '1';   
      WHEN st_lap     => cnt_reset <= '0'; cnt_enable <= '1'; disp_enable <= '0';   
      WHEN st_refresh => cnt_reset <= '0'; cnt_enable <= '1'; disp_enable <= '1';   
      WHEN st_stop    => cnt_reset <= '0'; cnt_enable <= '0'; disp_enable <= '1';         
    END CASE;
  END PROCESS out_logic;
  
  --regist out_comb na out_reg
  --ze signalu na vystup c clk
  -- z next na reg
  
  --    IF cnt_reset = '1' THEN 
  --    cnt_0_reg <= (OTHERS => '0');
  --    cnt_1_reg <= (OTHERS => '0');
  --    cnt_2_reg <= (OTHERS => '0');
  --    cnt_3_reg <= (OTHERS => '0');
  --  ELSE
  --    cnt_0_reg <= cnt_0_next; --s hranou prepne next na reg vystup
  --    cnt_1_reg <= cnt_1_next;
  --    cnt_2_reg <= cnt_2_next;
  --    cnt_3_reg <= cnt_3_next;
  --  END IF;
    
----------------------------------------------------------------------------------
end Behavioral;
----------------------------------------------------------------------------------