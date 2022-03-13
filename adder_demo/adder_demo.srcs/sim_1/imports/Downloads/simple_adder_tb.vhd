--testbench (to co testuje vytvoreny blocek)
  --jakoby pripojeni generatoru pulzu a osciloskopu
-- dobre pro testy - slozite, ale urychl cas
-- ve firmach nebo nejakych editorech lze automatizovat skriptama
---------------------------------------------------------------
library IEEE; 
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all; -- pro funkci to unsigned
---------------------------------------------------------------
--obecne nema zde ENTITA zadne vsutpy a vystupy
-- pripona _tb (test bench)
ENTITY simple_adder_tb IS --to se vklada v EDA do policka Top entity
END ENTITY simple_adder_tb;
---------------------------------------------------------------
ARCHITECTURE Behavioral OF simple_adder_tb IS --zkopirovat, jen pridat _tb
  
  --rika tesbenci ze ta soucastka existuje (predstavit)
  --tato cast jde zkopirovat z prava (prepsat na COMPONENT)
  COMPONENT simple_adder
  PORT(
    A        : IN  STD_LOGIC_VECTOR( 3 DOWNTO 0);
    B        : IN  STD_LOGIC_VECTOR( 3 DOWNTO 0);
    Y        : OUT STD_LOGIC_VECTOR( 3 DOWNTO 0);
    C        : OUT STD_LOGIC;
    Z        : OUT STD_LOGIC
  );
  END COMPONENT simple_adder;
  
  --posilaci/monitorovaci signaly jsou stejneho rozmeru (ze ma treba 4 zily)
  
  --Inputs
  SIGNAL a_sig    : STD_LOGIC_VECTOR( 3 DOWNTO 0);
  SIGNAL b_sig    : STD_LOGIC_VECTOR( 3 DOWNTO 0);
  --Outputs
  SIGNAL y_sig    : STD_LOGIC_VECTOR( 3 DOWNTO 0);
  SIGNAL c_sig    : STD_LOGIC;
  SIGNAL z_sig    : STD_LOGIC;
---------------------------------------------------------------
BEGIN --zde uz pak lze instanciovat (vkladat) - klidne nekolikrat
---------------------------------------------------------------
  --jako rezistor v Altiu - kazda soucasta se musi nejak pojmenovat stejnym jmenem + _i  nebo UUT (Unite Under Test)
  simple_adder_i : simple_adder
  PORT MAP( --popis propojeni komponenty (popis schematu) 
  -- zkpirovat a ponechat jen nazvy portu (jde pres dreznim ALT a vyber)!
               --pripojene vodice kam se budou posilat/monitorovat signaly
               --pojmenovat stejne 
    --vlevo se nic nemeni - jen v PRAVO!           
    A        => a_sig,
    B        => b_sig,
    Y        => y_sig,
    C        => c_sig,
    Z        => z_sig --tady carka NENI!
  );

-- pro buzeni tech signalu --sekvencne
-- kazdy definovany proces ve VHDL NARAZ spusti (klidne 20)
  PROCESS    
  BEGIN     
     --pro test vsech moznosti --pak ale neprochazet RUCNE -napsani kodu ze je to funkcni
    FOR i IN 0 TO 15 LOOP -- od 0 do 15 --celkem 16
      FOR j IN 0 TO 15 LOOP
        --nastaveni vsupnich signalu
        a_sig <= STD_LOGIC_VECTOR(TO_UNSIGNED(i, 4)); --integer na unsigned --prevadene cislo a pocet bitu --pak na STD_LOGIC_VECTOR
        b_sig <= STD_LOGIC_VECTOR(TO_UNSIGNED(j, 4));
        WAIT FOR 10 ns;       
      END LOOP;
    END LOOP;         
      
    WAIT; -- kdyz tu je wait tak se provede jen JEDNOU
  END PROCESS; -- kdyz neni WAIT, tak jakmile proces skonci tak ZNOVA ZACNE ! (nekonecna smycka)
  
  
  PROCESS -- tady muze byt sensitivity list -ale pak by tam nesmelo byt wait
    --VARIABLE v_y_ref  : STD_LOGIC_VECTOR(y_sig'RANGE);
    VARIABLE v_y_ref  : STD_LOGIC_VECTOR(4 DOWNTO 0);
    VARIABLE v_c_ref  : STD_LOGIC;
    VARIABLE v_z_ref  : STD_LOGIC;
  
  BEGIN
    WAIT ON a_sig, b_sig; --az kdyz se zmeni a a b tak postoupi
    WAIT FOR 1 ns;
    
    --kontrola jestli soucet Y je spravne
    v_y_ref := STD_LOGIC_VECTOR("00000" + UNSIGNED(a_sig) + UNSIGNED(b_sig));
    
    ASSERT (y_sig = v_y_ref(3 DOWNTO 0)) REPORT 
        "chyba vystupu Y, ocekavana hodnota y=" --pokud zavorka neplati
        & INTEGER'image(TO_INTEGER(UNSIGNED(v_y_ref(3 DOWNTO 0)))) &
        " , skutecna hodnota y = " & INTEGER'image(TO_INTEGER(UNSIGNED(y_sig))) & --&LF& pro psani na dalsi radek
        " a = " & INTEGER'image(TO_INTEGER(UNSIGNED(a_sig))) &
        " b = " & INTEGER'image(TO_INTEGER(UNSIGNED(b_sig)))        
    SEVERITY ERROR;

    --kontrola jestli C je spravne
    IF (UNSIGNED'("00000") + UNSIGNED(a_sig) + UNSIGNED(b_sig)) > 15  THEN --nejdrive se pricte vicebitove cislo (aby to nepreteklo)
      v_c_ref := '1';
    ELSE
      v_c_ref := '0';
    END IF;          
    
    ASSERT (v_c_ref = c_sig) REPORT 
      "chyba vystupu C, ocekavana hodnota C=" & STD_LOGIC'image(v_c_ref) &
      " Ocekavana hodnota C = " & STD_LOGIC'image(c_sig) & 
      " a = " & INTEGER'image(TO_INTEGER(UNSIGNED(a_sig))) &
      " b = " & INTEGER'image(TO_INTEGER(UNSIGNED(b_sig))) 
    SEVERITY ERROR;     
        
    --kontrola jestli Z je spravne 
    IF (UNSIGNED(a_sig) + UNSIGNED(b_sig) = UNSIGNED'("0000")) THEN 
      v_z_ref := '1'; 
    ELSE 
      v_z_ref := '0'; 
    END IF;
            
    ASSERT (v_z_ref = z_sig) REPORT  
        "chyba vystupu Z, ocekavana hodnota Z=" & STD_LOGIC'image(v_z_ref) &  
        " Ocekavana hodnota Z = " & STD_LOGIC'image(z_sig) & 
        " a = " & INTEGER'image(TO_INTEGER(UNSIGNED(a_sig))) &
        " b = " & INTEGER'image(TO_INTEGER(UNSIGNED(b_sig)))          
    SEVERITY ERROR;
      
  END PROCESS;


END ARCHITECTURE Behavioral;
---------------------------------------------------------------
