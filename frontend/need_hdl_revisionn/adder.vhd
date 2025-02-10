LIBRARY ieee ;
USE ieee.std_logic_1164.all ;

library work;
use work.my_package.all; 

ENTITY adder IS
	PORT (Cin : IN STD_LOGIC ;
		X, Y : IN STD_LOGIC_VECTOR(8 DOWNTO 0) ;
		S : OUT STD_LOGIC_VECTOR(8 DOWNTO 0) ) ;
END adder ;

ARCHITECTURE Structure OF adder IS
SIGNAL C : STD_LOGIC_VECTOR(1 TO 9) ;
BEGIN
	stage0: fulladd PORT MAP ( Cin, X(0), Y(0), S(0), C(1) ) ;	--Insere-se 8 somadores completos de 1 bits para formar um somador de 9 bits
	stage1: fulladd PORT MAP ( C(1), X(1), Y(1), S(1), C(2) ) ;
	stage2: fulladd PORT MAP ( C(2), X(2), Y(2), S(2), C(3) ) ;
	stage3: fulladd PORT MAP ( C(3), X(3), Y(3), S(3), C(4) ) ;
	stage4: fulladd PORT MAP ( C(4), X(4), Y(4), S(4), C(5) ) ;
	stage5: fulladd PORT MAP ( C(5), X(5), Y(5), S(5), C(6) ) ;
	stage6: fulladd PORT MAP ( C(6), X(6), Y(6), S(6), C(7) ) ;
	stage7: fulladd PORT MAP ( C(7), X(7), Y(7), S(7), C(8) ) ;
	stage8: fulladd PORT MAP ( C(8), X(8), Y(8), S(8), C(9) ) ;
END Structure ;
