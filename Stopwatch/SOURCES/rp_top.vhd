----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
----------------------------------------------------------------------------------
ENTITY rp_top IS
  PORT(
    clk             : IN  STD_LOGIC;
    btn_i           : IN  STD_LOGIC_VECTOR (3 DOWNTO 0);
    sw_i            : IN  STD_LOGIC_VECTOR (3 DOWNTO 0);
    led_o           : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
    disp_seg_o      : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
    disp_dig_o      : OUT STD_LOGIC_VECTOR (4 DOWNTO 0)
  );
END rp_top;
----------------------------------------------------------------------------------
ARCHITECTURE Structural OF rp_top IS
----------------------------------------------------------------------------------

  COMPONENT seg_disp_driver
  PORT(
    clk             : IN  STD_LOGIC;
    dig_1_i         : IN  STD_LOGIC_VECTOR (3 DOWNTO 0);
    dig_2_i         : IN  STD_LOGIC_VECTOR (3 DOWNTO 0);
    dig_3_i         : IN  STD_LOGIC_VECTOR (3 DOWNTO 0);
    dig_4_i         : IN  STD_LOGIC_VECTOR (3 DOWNTO 0);
    dp_i            : IN  STD_LOGIC_VECTOR (3 DOWNTO 0);        -- [DP4 DP3 DP2 DP1]
    dots_i          : IN  STD_LOGIC_VECTOR (2 DOWNTO 0);        -- [L3 L2 L1]
    disp_seg_o      : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
    disp_dig_o      : OUT STD_LOGIC_VECTOR (4 DOWNTO 0)
  );
  END COMPONENT seg_disp_driver;

  ------------------------------------------------------------------------------

  SIGNAL cnt_0              : STD_LOGIC_VECTOR( 3 DOWNTO 0);
  SIGNAL cnt_1              : STD_LOGIC_VECTOR( 3 DOWNTO 0);
  SIGNAL cnt_2              : STD_LOGIC_VECTOR( 3 DOWNTO 0);
  SIGNAL cnt_3              : STD_LOGIC_VECTOR( 3 DOWNTO 0);
  
  ------------------------------------------------------------------------------
  -- clock enable generator
  COMPONENT ce_gen 
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
  END COMPONENT ce_gen;  
  ------------------------------------------------------------------------------
  
  SIGNAL ce_100hz : STD_LOGIC := '0';

  ------------------------------------------------------------------------------
  -- button input module
  COMPONENT btn_in 
    GENERIC(
      DEB_PERIOD  : POSITIVE := 20
    );
    Port ( clk : in STD_LOGIC;
           ce : in STD_LOGIC;
           btn : in STD_LOGIC;
           btn_debounced : out STD_LOGIC;
           btn_edge_pos : out STD_LOGIC;
           btn_edge_neg : out STD_LOGIC;
           btn_edge_any : out STD_LOGIC
           );
  END COMPONENT btn_in;
  ------------------------------------------------------------------------------
  
  ------------------------------------------------------------------------------
  -- stopwatch module (4-decade BCD counter)
  COMPONENT stopwatch 
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
  END COMPONENT stopwatch;  
  ------------------------------------------------------------------------------
  
  ------------------------------------------------------------------------------
  -- stopwatch control FSM
  
  ------------------------------------------------------------------------------  
----------------------------------------------------------------------------------
BEGIN
----------------------------------------------------------------------------------

  --------------------------------------------------------------------------------
  -- display driver
  --
  --       DIG 1       DIG 2       DIG 3       DIG 4
  --                                       L3
  --       -----       -----       -----   o   -----
  --      |     |     |     |  L1 |     |     |     |
  --      |     |     |     |  o  |     |     |     |
  --       -----       -----       -----       -----
  --      |     |     |     |  o  |     |     |     |
  --      |     |     |     |  L2 |     |     |     |
  --       -----  o    -----  o    -----  o    -----  o
  --             DP1         DP2         DP3         DP4
  --
  --------------------------------------------------------------------------------

  seg_disp_driver_i : seg_disp_driver
  PORT MAP(
    clk                 => clk,
    dig_1_i             => cnt_3,
    dig_2_i             => cnt_2,
    dig_3_i             => cnt_1,
    dig_4_i             => cnt_0,
    dp_i                => "0000",
    dots_i              => "011",
    disp_seg_o          => disp_seg_o,
    disp_dig_o          => disp_dig_o
  );

  --------------------------------------------------------------------------------
  -- clock enable generator
  ce_gen_i : ce_gen
  GENERIC MAP(
    DIV_FACT => 500000
  )
  PORT MAP(
    CLK => clk,
    SRST => '0',
    CE_IN => '1',
    CE_OUT => ce_100hz 
  );  
  
  
  --------------------------------------------------------------------------------
  -- button input module
  gen_btn_in : FOR i IN 0 TO 3 GENERATE
    btn_in_inst : btn_in
    GENERIC MAP(
      DEB_PERIOD => 20
      )
      PORT MAP(
        clk => clk,          
        ce => ce_100Hz,             
        btn => btn(i),           
        btn_debounced => btn_debounced(i), 
        btn_edge_pos => btn_edge_pos(i),  
        btn_edge_neg => btn_edge_neg(i),  
        btn_edge_any => btn_edge_any(i)          		  		   
 	   );
  END GENERATE gen_btn_in;


  --------------------------------------------------------------------------------
  -- stopwatch module (4-decade BCD counter)
  stopwatch_i : stopwatch 
      Port ( CLK 
             CE_100HZ <= ce_100hz, 
             CNT_ENABLE <= , 
             DISP_ENABLE <= ,
             CNT_RESET <= ,
             CNT_0 <= cnt_0,
             CNT_1 <= cnt_1,
             CNT_2 <= cnt_2,
             CNT_3 <= cnt_3
             );
  END COMPONENT stopwatch;  


  --------------------------------------------------------------------------------
  -- stopwatch control FSM
  


----------------------------------------------------------------------------------
END Structural;
----------------------------------------------------------------------------------
