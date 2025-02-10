LIBRARY ieee ;
USE ieee.std_logic_1164.all ;

library work;
use work.my_package.all; 

ENTITY adder23 IS
	PORT (Cin : IN STD_LOGIC ;
		X, Y : IN STD_LOGIC_VECTOR(22 DOWNTO 0) ;
		S : OUT STD_LOGIC_VECTOR(22 DOWNTO 0) ) ;
END adder23 ;

ARCHITECTURE Structure OF adder23 IS
SIGNAL C : STD_LOGIC_VECTOR(1 TO 23) ;
BEGIN
	stage0: fulladd PORT MAP ( Cin, X(0), Y(0), S(0), C(1) ) ;  --inseri-se 23 somadores completos de um bit em serie para formar um somador de 23 bits
	stage1: fulladd PORT MAP ( C(1), X(1), Y(1), S(1), C(2) ) ;
	stage2: fulladd PORT MAP ( C(2), X(2), Y(2), S(2), C(3) ) ;
	stage3: fulladd PORT MAP ( C(3), X(3), Y(3), S(3), C(4) ) ;
	stage4: fulladd PORT MAP ( C(4), X(4), Y(4), S(4), C(5) ) ;
	stage5: fulladd PORT MAP ( C(5), X(5), Y(5), S(5), C(6) ) ;
	stage6: fulladd PORT MAP ( C(6), X(6), Y(6), S(6), C(7) ) ;
	stage7: fulladd PORT MAP ( C(7), X(7), Y(7), S(7), C(8) ) ;
	stage8: fulladd PORT MAP ( C(8), X(8), Y(8), S(8), C(9) ) ;
	stage9: fulladd PORT MAP ( C(9), X(9), Y(9), S(9), C(10) ) ;
	stage10: fulladd PORT MAP ( C(10), X(10), Y(10), S(10), C(11) ) ;
	stage11: fulladd PORT MAP ( C(11), X(11), Y(11), S(11), C(12) ) ;
	stage12: fulladd PORT MAP ( C(12), X(12), Y(12), S(12), C(13) ) ;
	stage13: fulladd PORT MAP ( C(13), X(13), Y(13), S(13), C(14) ) ;
	stage14: fulladd PORT MAP ( C(14), X(14), Y(14), S(14), C(15) ) ;
	stage15: fulladd PORT MAP ( C(15), X(15), Y(15), S(15), C(16) ) ;
	stage16: fulladd PORT MAP ( C(16), X(16), Y(16), S(16), C(17) ) ;
	stage17: fulladd PORT MAP ( C(17), X(17), Y(17), S(17), C(18) ) ;
	stage18: fulladd PORT MAP ( C(18), X(18), Y(18), S(18), C(19) ) ;
	stage19: fulladd PORT MAP ( C(19), X(19), Y(19), S(19), C(20) ) ;
	stage20: fulladd PORT MAP ( C(20), X(20), Y(20), S(20), C(21) ) ;
	stage21: fulladd PORT MAP ( C(21), X(21), Y(21), S(21), C(22) ) ;
	stage22: fulladd PORT MAP ( C(22), X(22), Y(22), S(22), C(23) ) ;
END Structure ;
