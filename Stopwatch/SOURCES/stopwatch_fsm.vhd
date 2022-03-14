library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
----------------------------------------------------------------------------------
entity stopwatch_fsm is
    Port ( clk : in STD_LOGIC;
           btn_SS : in STD_LOGIC;
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
  
  --pro vystupni registr
  SIGNAL cnt_reset_next : STD_LOGIC := '0'; 
  SIGNAL cnt_enable_next : STD_LOGIC := '0'; 
  SIGNAL disp_enable_next : STD_LOGIC := '0';
----------------------------------------------------------------------------------
begin
----------------------------------------------------------------------------------
  --blok next state logic
  next_state_logic : PROCESS(btn_SS, btn_LC, pres_st) BEGIN
    CASE pres_st IS
      WHEN st_idle => IF btn_SS = '1' THEN next_st <= st_run;
                      ELSE next_st <= st_idle; 
                      END IF;
      WHEN st_run => IF btn_SS = '1' THEN next_st <= st_stop; 
                     ELSIF btn_SS = '0' AND btn_LC = '1' THEN next_st <= st_lap;
                     ELSE next_st <= st_run;
                     END IF;
      WHEN st_lap => IF btn_SS = '1' THEN next_st <= st_run; 
                     ELSIF btn_SS = '0' AND btn_LC = '1' THEN next_st <= st_refresh;
                     ELSE next_st <= st_lap; 
                     END IF;                   
      WHEN st_refresh => next_st <= st_lap;
      WHEN st_stop =>IF btn_SS = '1' THEN next_st <= st_run; 
                     ELSIF btn_SS = '0' AND btn_LC = '1' THEN next_st <= st_idle;
                     ELSE next_st <= st_stop; END IF;                                              
    END CASE;  
  END PROCESS next_state_logic;
  
  --registr next_st na pres_st
  PROCESS(clk) BEGIN
    IF rising_edge(clk) THEN
      pres_st <= next_st;
    END IF;    
  END PROCESS;

  --blok out logic --tady asi zapisovat do next (sig)
  out_logic : PROCESS (pres_st) BEGIN
    CASE pres_st IS 
      WHEN st_idle    => cnt_reset_next <= '1'; cnt_enable_next <= '0'; disp_enable_next <= '1';   
      WHEN st_run     => cnt_reset_next <= '0'; cnt_enable_next <= '1'; disp_enable_next <= '1';   
      WHEN st_lap     => cnt_reset_next <= '0'; cnt_enable_next <= '1'; disp_enable_next <= '0';   
      WHEN st_refresh => cnt_reset_next <= '0'; cnt_enable_next <= '1'; disp_enable_next <= '1';   
      WHEN st_stop    => cnt_reset_next <= '0'; cnt_enable_next <= '0'; disp_enable_next <= '1';         
    END CASE;
  END PROCESS out_logic;
  
  --regist out_comb na out_reg
  PROCESS(clk) BEGIN
    IF rising_edge(clk) THEN
      cnt_reset <= cnt_reset_next;
      cnt_enable <= cnt_enable_next;
      disp_enable <= disp_enable_next;
    END IF;
  END PROCESS;

    
----------------------------------------------------------------------------------
end Behavioral;
----------------------------------------------------------------------------------