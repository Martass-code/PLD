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
    --deklarativni cast (zatim prazdna)
    VARIABLE y_ref  : UNSIGNED(3 DOWNTO 0); --promenna v ramci procesu (pro kontrolu)    
    VARIABLE c_ref  : STD_LOGIC;
    VARIABLE z_ref  : STD_LOGIC;
    VARIABLE cnt_err : INTEGER := 0;
  BEGIN
    --vykonna cast
    
     --abych mohl pouzivat integer - je to prirozenejsi
     --z integeru na STD_LOGIC_VECTOR
     --ale nejdrin integer na unsigned (a pak na STD_LOGIC_VECTOR?)
    --a_sig <= TO_UNSIGNED(15, 4); --2 parametry -prevadene cislo a pocet bitu
     --lepe (misto cisla 4)by to melo byt s atributem a_sig'LENGHT
     
     --pro test vsech moznosti --pak ale neprochazet RUCNE -napsani kodu ze je to funkcni
    FOR i IN 0 TO 15 LOOP -- od 0 do 15 --celkem 16
      FOR j IN 0 TO 15 LOOP
        --nastaveni vsupnich signalu
        a_sig <= STD_LOGIC_VECTOR(TO_UNSIGNED(i, 4)); --integer na unsigned --prevadene cislo a pocet bitu --pak na STD_LOGIC_VECTOR
        b_sig <= STD_LOGIC_VECTOR(TO_UNSIGNED(j, 4));
        WAIT FOR 10 ns;
        
        --ted kontrola jestli soucet Y je spravne
        y_ref := UNSIGNED(a_sig) + UNSIGNED(b_sig); --signaly a porty maji sipku a promenne maji dvojtecku
        IF NOT (y_ref = UNSIGNED(y_sig)) THEN --kontrola se skutecnym
          --vypise chybu pri chybe                         - rozdeleni radku pomoci &
          REPORT " Chyba pri souctu! Skutecna hodnota Y = " & INTEGER'image(TO_INTEGER(UNSIGNED(y_sig))) & --vector na string jako integer
          " Ocekavana hodnota Y = " & INTEGER'image(TO_INTEGER(UNSIGNED(y_ref))) & --&LF& pro psani na dalsi radek
          " a = " & INTEGER'image(TO_INTEGER(UNSIGNED(a_sig))) &
          " b = " & INTEGER'image(TO_INTEGER(UNSIGNED(b_sig))) 
          SEVERITY ERROR; --uroven zavaznosti (celkem 4 - NOTE, WARNING, ERROR, FAILURE -tohle zastavi)
          
          cnt_err := cnt_err + 1;
        END IF;
        
        --kontrola jestli C je spravne
        IF (UNSIGNED'("00000") + UNSIGNED(a_sig) + UNSIGNED(b_sig)) > 15  THEN --nejdrive se pricte vicebitove cislo (aby to nepreteklo)
          c_ref := '1';
        ELSE
          c_ref := '0';
        END IF;          
        
        IF NOT (c_ref = c_sig) THEN
          REPORT "Chyba pri souctu! Skutecna hodnota C = " & STD_LOGIC'image(c_sig) &
          " Ocekavana hodnota C = " & STD_LOGIC'image(c_ref) & --&LF& pro psani na dalsi radek
          " a = " & INTEGER'image(TO_INTEGER(UNSIGNED(a_sig))) &
          " b = " & INTEGER'image(TO_INTEGER(UNSIGNED(b_sig))) 
          SEVERITY ERROR; 
          
          cnt_err := cnt_err + 1;
        END IF;
        
        --kontrola jestli Z je spravne 
        --z_ref := '1' WHEN STD_LOGIC_VECTOR(UNSIGNED(a_sig) + UNSIGNED(b_sig)) = "0000" ELSE '0';
        --z_ref := '1' WHEN UNSIGNED(a_sig) + UNSIGNED(b_sig) = UNSIGNED'("0000") ELSE '0'; 
        IF (UNSIGNED(a_sig) + UNSIGNED(b_sig) = UNSIGNED'("0000")) THEN 
          z_ref := '1'; 
        ELSE 
          z_ref := '0'; 
        END IF;
                
        IF NOT (z_ref = z_sig) THEN
          REPORT "Chyba v bitu Z! Skutecna hodnota Z = " & STD_LOGIC'image(z_sig) &  
          " Ocekavana hodnota Z = " & STD_LOGIC'image(z_ref) & --&LF& pro psani na dalsi radek
          " a = " & INTEGER'image(TO_INTEGER(UNSIGNED(a_sig))) &
          " b = " & INTEGER'image(TO_INTEGER(UNSIGNED(b_sig)))          
          SEVERITY ERROR; 
          
          cnt_err := cnt_err + 1;
        END IF;

      END LOOP;
    END LOOP;
    
    --simulace probehla, celkovy souhrn
    IF (cnt_err = 0) THEN
      REPORT LF & --odradkovani
             "================================================================" & LF &
             "Simulace probehla bez chyb!" & LF &
             "================================================================" & LF
             SEVERITY NOTE;
    ELSE
      REPORT LF &
             "================================================================" & LF &
             "Simulace s poctem chyb " & INTEGER'IMAGE(cnt_err) & LF &
             "================================================================" & LF
      		 SEVERITY ERROR;
    END IF;
         
        

    WAIT; -- kdyz tu je wait tak se provede jen JEDNOU
  END PROCESS; -- kdyz neni WAIT, tak jakmile proces skonci tak ZNOVA ZACNE ! (nekonecna smycka)
  
  


END ARCHITECTURE Behavioral;
---------------------------------------------------------------
