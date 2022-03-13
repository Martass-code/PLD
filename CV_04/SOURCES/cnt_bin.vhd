----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
----------------------------------------------------------------------------------
ENTITY cnt_bin IS
  PORT (
    CLK             : IN  STD_LOGIC;
    SRST            : IN  STD_LOGIC;
    CE              : IN  STD_LOGIC;
    CNT_LOAD        : IN  STD_LOGIC;
    CNT_UP          : IN  STD_LOGIC;
    CNT             : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
  );
END cnt_bin;
----------------------------------------------------------------------------------
ARCHITECTURE Behavioral OF cnt_bin IS
----------------------------------------------------------------------------------

  SIGNAL cnt_sig    : UNSIGNED (CNT'RANGE) := (OTHERS => '0');

----------------------------------------------------------------------------------
BEGIN
----------------------------------------------------------------------------------

  PROCESS (CLK) BEGIN
    IF rising_edge(CLK) THEN
      IF SRST = '1' THEN                    -- synchronous reset
        cnt_sig <= (OTHERS => '0');
      ELSE
        IF CNT_LOAD = '1' THEN              -- synchronous load
          cnt_sig <= X"55555555";
        ELSE
          IF CE = '1' THEN                  -- clock enable
            IF CNT_UP = '1' THEN
              cnt_sig <= cnt_sig + 1;
            ELSE
              cnt_sig <= cnt_sig - 1;
            END IF;
          END IF;
        END IF;
      END IF;
    END IF;
  END PROCESS;

  CNT <= STD_LOGIC_VECTOR(cnt_sig);

----------------------------------------------------------------------------------
END ARCHITECTURE;
----------------------------------------------------------------------------------
