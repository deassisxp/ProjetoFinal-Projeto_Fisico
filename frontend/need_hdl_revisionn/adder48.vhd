LIBRARY ieee ;
USE ieee.std_logic_1164.all ;

library work;
use work.my_package.all; 

ENTITY adder48 IS
	PORT (Cin : IN STD_LOGIC ;
		X, Y : IN STD_LOGIC_VECTOR(47 DOWNTO 0) ;
		S : OUT STD_LOGIC_VECTOR(47 DOWNTO 0) ) ;
END adder48 ;

ARCHITECTURE Structure OF adder48 IS
SIGNAL C : STD_LOGIC_VECTOR(1 TO 48) ;
BEGIN
	stage0: fulladd PORT MAP ( Cin, X(0), Y(0), S(0), C(1) ) ; 	-- Insere-se 48 somadores completos de 1 bit para formar um somador de 48 bits
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
	stage23: fulladd PORT MAP ( C(23), X(23), Y(23), S(23), C(24) ) ;
	stage24: fulladd PORT MAP ( C(24), X(24), Y(24), S(24), C(25) ) ;
	stage25: fulladd PORT MAP ( C(25), X(25), Y(25), S(25), C(26) ) ;
	stage26: fulladd PORT MAP ( C(26), X(26), Y(26), S(26), C(27) ) ;
	stage27: fulladd PORT MAP ( C(27), X(27), Y(27), S(27), C(28) ) ;
	stage28: fulladd PORT MAP ( C(28), X(28), Y(28), S(28), C(29) ) ;
	stage29: fulladd PORT MAP ( C(29), X(29), Y(29), S(29), C(30) ) ;
	stage30: fulladd PORT MAP ( C(30), X(30), Y(30), S(30), C(31) ) ;
	stage31: fulladd PORT MAP ( C(31), X(31), Y(31), S(31), C(32) ) ;
	stage32: fulladd PORT MAP ( C(32), X(32), Y(32), S(32), C(33) ) ;
	stage33: fulladd PORT MAP ( C(33), X(33), Y(33), S(33), C(34) ) ;
	stage34: fulladd PORT MAP ( C(34), X(34), Y(34), S(34), C(35) ) ;
	stage35: fulladd PORT MAP ( C(35), X(35), Y(35), S(35), C(36) ) ;
	stage36: fulladd PORT MAP ( C(36), X(36), Y(36), S(36), C(37) ) ;
	stage37: fulladd PORT MAP ( C(37), X(37), Y(37), S(37), C(38) ) ;
	stage38: fulladd PORT MAP ( C(38), X(38), Y(38), S(38), C(39) ) ;
	stage39: fulladd PORT MAP ( C(39), X(39), Y(39), S(39), C(40) ) ;
	stage40: fulladd PORT MAP ( C(40), X(40), Y(40), S(40), C(41) ) ;
	stage41: fulladd PORT MAP ( C(41), X(41), Y(41), S(41), C(42) ) ;
	stage42: fulladd PORT MAP ( C(42), X(42), Y(42), S(42), C(43) ) ;
	stage43: fulladd PORT MAP ( C(43), X(43), Y(43), S(43), C(44) ) ;
	stage44: fulladd PORT MAP ( C(44), X(44), Y(44), S(44), C(45) ) ;
	stage45: fulladd PORT MAP ( C(45), X(45), Y(45), S(45), C(46) ) ;
	stage46: fulladd PORT MAP ( C(46), X(46), Y(46), S(46), C(47) ) ;
	stage47: fulladd PORT MAP ( C(47), X(47), Y(47), S(47), C(48) ) ;
END Structure ;
