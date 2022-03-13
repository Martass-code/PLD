----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
----------------------------------------------------------------------------------
ENTITY rp_top IS
  PORT (
    CLK             : IN  STD_LOGIC;
    BTN             : IN  STD_LOGIC_VECTOR (3 DOWNTO 0);
    SW              : IN  STD_LOGIC_VECTOR (3 DOWNTO 0);
    LED             : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
    DISP_SEG        : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
    DISP_DIG        : OUT STD_LOGIC_VECTOR (4 DOWNTO 0)
  );
END rp_top;
----------------------------------------------------------------------------------
ARCHITECTURE Structural OF rp_top IS
----------------------------------------------------------------------------------

  COMPONENT seg_disp_driver
  PORT (
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
  END COMPONENT;

  --------------------------------------------------------------------------------

  COMPONENT cnt_bin
  PORT (
    CLK                 : IN  STD_LOGIC;
    SRST                : IN  STD_LOGIC;
    CE                  : IN  STD_LOGIC;
    CNT_LOAD            : IN  STD_LOGIC;
    CNT_UP              : IN  STD_LOGIC;
    CNT                 : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
  );
  END COMPONENT;

  --------------------------------------------------------------------------------

  COMPONENT vio_0
  PORT (
    clk                 : IN  STD_LOGIC;
    probe_out0          : OUT STD_LOGIC_VECTOR ( 3 DOWNTO 0 );
    probe_out1          : OUT STD_LOGIC_VECTOR ( 3 DOWNTO 0 )
  );
  END COMPONENT;

  --------------------------------------------------------------------------------

  SIGNAL srst           : STD_LOGIC;
  SIGNAL ce             : STD_LOGIC;
  SIGNAL cnt_load       : STD_LOGIC;
  SIGNAL cnt_up         : STD_LOGIC;
  SIGNAL cnt            : STD_LOGIC_VECTOR (31 DOWNTO 0);

  SIGNAL dp             : STD_LOGIC_VECTOR ( 3 DOWNTO 0);

  SIGNAL sw_sig         : STD_LOGIC_VECTOR ( 3 DOWNTO 0 );
  SIGNAL btn_sig        : STD_LOGIC_VECTOR ( 3 DOWNTO 0 );


----------------------------------------------------------------------------------
BEGIN
----------------------------------------------------------------------------------

  --------------------------------------------------------------------------------
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
  PORT MAP (
    clk                 => CLK,
    --Connect the 16 most significant bits of the counter output to the 7-segment display driver
    dig_1_i             => cnt(31 DOWNTO 28), --knihovna prepocita bin na hex
    dig_2_i             => cnt(27 DOWNTO 24),
    dig_3_i             => cnt(23 DOWNTO 20),
    dig_4_i             => cnt(19 DOWNTO 16),
    dp_i                => dp,
    dots_i              => "000",
    disp_seg_o          => DISP_SEG,
    disp_dig_o          => DISP_DIG
  );

  --------------------------------------------------------------------------------
  -- Instantiate the binary counter

  cnt_bin_i : cnt_bin
  PORT MAP (
    CLK                 => CLK,
    SRST                => srst,
    CE                  => ce,
    CNT_LOAD            => cnt_load,
    CNT_UP              => cnt_up,
    CNT                 => cnt
  );

  --------------------------------------------------------------------------------
  -- Connect the upper byte of the counter to LEDs
  LED <= cnt(31 DOWNTO 25);

  --------------------------------------------------------------------------------
  -- Connecto control signals to switches and buttons

  srst      <= btn_sig(2);
  ce        <= sw_sig(2);
  cnt_load  <= btn_sig(1);
  cnt_up    <= sw_sig(3);

  --------------------------------------------------------------------------------
  -- Make the control signals visible on display (dots)

  dp(0) <= srst;
  dp(1) <= ce;
  dp(2) <= cnt_load;
  dp(3) <= cnt_up;

  --------------------------------------------------------------------------------
  -- Virtula buttons and switches (VIO controlled through JTAG ingerface from PC)

  vio_0_i : vio_0
  PORT MAP (
    clk                 => CLK,
    probe_out0          => sw_sig,
    probe_out1          => btn_sig
  );

----------------------------------------------------------------------------------
END Structural;
----------------------------------------------------------------------------------
