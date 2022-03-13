---------------------------------------------------------------
-- deklarace pouzitych knihoven a slov 
library IEEE;
use IEEE.std_logic_1164.all; --definice STD_LOGIC_VECTOR a STD_LOGIC
use IEEE.numeric_std.all; --standartni sloha pro implementaci aritmet operaci 
---------------------------------------------------------------
-- definice jak bude blok vypadat zvenci
ENTITY simple_adder IS
  PORT( --port - piny co jdou vena a dovnitr
    --VZDY! veskere vstup vystup budou STD_LOGIC_VECTOR nebo STD_LOGIC 
    --       smer signalu (defaoulne vstupni)   definice rozmeru 4 (konvence nejmene vyznamny bit je 0)
    A        : IN  STD_LOGIC_VECTOR( 3 DOWNTO 0);
    B        : IN  STD_LOGIC_VECTOR( 3 DOWNTO 0);
    Y        : OUT STD_LOGIC_VECTOR( 3 DOWNTO 0);
    C        : OUT STD_LOGIC;
    Z        : OUT STD_LOGIC --posledni signal v PORT mape - nedava se ; !!
  );
END ENTITY simple_adder;
---------------------------------------------------------------
-- popis bloku uvnitr
-- Behavioral jen jmeno, nema na nic vliv 
-- OF a co popisuje  (jeden soubor bude popisovat ENTITU tak ARCHITECTURU
ARCHITECTURE Behavioral OF simple_adder IS
-- 1.cast - deklaracni (declarative part of architecture)
  --draty pro funkcnost designu (jen propojuji vnitrek)

  SIGNAL y_sig    : STD_LOGIC_VECTOR(4 DOWNTO 0); --definice signalu
 
BEGIN
-- 2.cast - funkce designu (architecture statement)
  --popisuji funkcnost designu
  
  --vysledek se vlozi do y_sig
  -- pridanim "00000" se zvetsi o 1 bit pro preteceni (C - carry bit)
  --vysledek bude mit takovou velikost jako nejvetsi ze vsech operandu !
  y_sig <= STD_LOGIC_VECTOR( UNSIGNED'("00000") + UNSIGNED(A) + UNSIGNED(B) ); --pretypovani (scitat jde jen UNSIGNED) ! pak zpatky pretyp na vektor
  
  --vyuziti jen 4 bitu
  Y <= y_sig( 3 DOWNTO 0); -- "0000"; (pro zacatek trvale 0000 - pak se upravuje) chytak- do vektoru uvozovky "" !!
  
  --vycucnuti jen carry bitu
  --nemusim pretypovavat - uz je typu STD_LOGIC
  C <= y_sig(4); -- '0'; (pro zacatek trvale 0 - pak se upravuje)
  
  --nebo lze udelat to same nahore pres if y > 15 then c je 1
  
  --Z <= '1' WHEN Y = "0000" ELSE '0';
  Z <= '1' WHEN (y_sig(3 DOWNTO 0) = "0000" ) ELSE '0'; 


END ARCHITECTURE Behavioral;
---------------------------------------------------------------
