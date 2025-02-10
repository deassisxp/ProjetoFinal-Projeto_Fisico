-----------------------------------------------------------------------------
-- README
-----------------------------------------------------------------------------
-- This testbench reads a text file to verify the floating point multiplication
-- It reads 2 hexadecimal numbers with 32 bits each.
-- It computes the multiplication and compares with a third one number in the text file.
-----------------------------------------------------------------------------
-- Revisions:
-- Date       | Author     | Description
-----------------------------------------------------------------------------
-- 2024/05/14 | Leonardo  | Created (not functional at this date)
--			  | 		  |
-----------------------------------------------------------------------------


library IEEE;						
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.CONV_STD_LOGIC_VECTOR;
use ieee.std_logic_unsigned.all; 	-- CONV_INTEGER function
use std.textio.all;
use work.Util_package.all;
use ieee.std_logic_1164.all;

--library work;
--use work.my_package.all;

entity multiplier32FP_tb  is
end multiplier32FP_tb;


-- Instantiate the components and generates the stimuli.
architecture verification of multiplier32FP_tb is  

	--constant imageFileName	: string := "vetor.txt";	-- vector content to be loaded
	file imageFile : TEXT open READ_MODE is "sim/vetor.txt";

	--constant WIDTH	: integer := 8;


	-- Instantiates the component of the DUV
	component multiplier32FP is
		port (
			clk 		: in  std_logic;
			rst_n 		: in  std_logic; -- it is not an active low reset at all
			a_i		: in  std_logic_vector(31 downto 0);
			b_i		: in  std_logic_vector(31 downto 0);
			start_i 	: in  std_logic;
			done_o 		: out std_logic;
			product_o 	: out std_logic_vector(31 downto 0);
			nan_o		: out std_logic;
			infinit_o	: out std_logic;
			overflow_o	: out std_logic;
			underflow_o	: out std_logic

		);
	end component;
    



	--Inputs
	signal clk		: std_logic := '0';
	signal rst_n		: std_logic := '0'; -- it is not an active low reset at all
	signal a_i 		: std_logic_vector (31 downto 0) := (others => '0');
	signal b_i 		: std_logic_vector (31 downto 0) := (others => '0');
	signal golden_result	: std_logic_vector (31 downto 0) := (others => '0');
	signal start_i 		: std_logic := '0';
	

 	--Outputs
	signal done_o 		: std_logic;
	signal product_o	: std_logic_vector(31 downto 0);
	signal nan_o		: std_logic;
	signal infinit_o 	: std_logic;
	signal overflow_o 	: std_logic;
	signal underflow_o	: std_logic;


	-- Generates the stimuli.
	constant clk_half_period : time := 20 ns; -- period = 40 ns, f = 25 MHz

   
   
begin

	-- Instantiates the Design Under Verification: DUV
	DUV: multiplier32FP port map 
		(
		clk 		=> clk,
		rst_n 		=> rst_n,
		a_i		=> a_i,
		b_i		=> b_i,
		start_i 	=> start_i,
		done_o 		=> done_o,
		product_o	=> product_o,
		nan_o		=> nan_o,
		infinit_o	=> infinit_o,
	  	overflow_o	=> overflow_o,
	 	underflow_o	=> underflow_o	

        );

	rst_n <= '1', '0' after clk_half_period, '1' after 2*clk_half_period;
 	clk <= not clk after clk_half_period;	-- period = 2*clk_half_period, f = 1/(2*clk_half_period)


	process

	-- Variables below are related with reading text file
	--
	variable fileLine	: line;			-- Stores a read line from a text file
	variable str 		: string(1 to 8);	-- Stores an 32 characters string
	variable char		: character;		-- Stores a single character
	variable bool		: boolean;		-- 
	--

	-- Variables below are related with assertions
	variable counter_v	: integer:=1;
	variable counter_ok	: integer:=0;
	variable counter_fail	: integer:=0;


	begin

		while NOT (endfile(imageFile)) loop	-- Main loop to read the file
			report "Iniciando leitura do arquivo" severity note;
	   		start_i <= '0';
			-- Read a file line into 'fileLine'
			readline(imageFile, fileLine);	
----------------------------------------------------------------------------------
			-- Read the "A" operand and stores in 'str'
			for i in 1 to 8 loop
				read(fileLine, char, bool);
				str(i) := char;
			end loop;
			report "Valor de my_var: " & str severity note;
			-- Converts the string "A" 'str' to std_logic_vector
			a_i <= StringToStdLogicVector(str);
----------------------------------------------------------------------------------
			-- Read the 1 blank between A and B
			read(fileLine, char, bool);
----------------------------------------------------------------------------------
			-- Read the "B" operand and stores in 'str'
			for i in 1 to 8 loop
				read(fileLine, char, bool);
				str(i) := char;
			end loop;
----------------------------------------------------------------------------------
			-- Converts the string "B" 'str' to std_logic_vector
			b_i <= StringToStdLogicVector(str);

----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
			-- Read the 1 blank between "B" and "result"
			read(fileLine, char, bool);
			-- Read the Result for purpose comparisons operand and stores in 'str'
			for i in 1 to 8 loop
				read(fileLine, char, bool);
				str(i) := char;
			end loop;
			-- Converts the string "result" 'str' to std_logic_vector
			golden_result <= StringToStdLogicVector(str);

----------------------------------------------------------------------------------

	   		wait until  clk = '1';
	   		wait until  clk = '0';
	                	start_i <= '1';
			wait until 	clk = '0';
				        start_i <= '0';
--				        start_i <= '1'; -- lucas e vanessa: start_i precisa ficar em "1" todo o tempo...
			wait until 	done_o='1';	-- Suspend process

--------------------------------------------------------------------------------------------------------
			-- Shows in the command line if the "Result" is correct
			assert not (product_o = golden_result)  report "OK vector #: " & integer'image(counter_v) severity note;
				if product_o = golden_result then
					counter_ok := counter_ok + 1;
				elsif (product_o /= golden_result) then
					counter_fail := counter_fail + 1;
				end if;
			assert not (product_o /= golden_result) report "FAIL vector #: " & integer'image(counter_v) severity note;
			counter_v := counter_v + 1;	

				if counter_v = 31 then
					report "--------------------------------------------------------";
					report "--------------------------------------------------------";
					report "Number of vector(s) that PASS #: " & integer'image(counter_ok);
					report "Number of vector(s) that FAIL #: " & integer'image(counter_fail);
					report "--------------------------------------------------------";
					report "--------------------------------------------------------";
				end if;

--------------------------------------------------------------------------------------------------------

			end loop;




			wait ;	-- Suspend process  	

--	   		
	end process;


   	

end verification;


