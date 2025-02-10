-----------------------------------------------------------------------------
-- README
-----------------------------------------------------------------------------
-- This is the data path of the main HDL file of a 32 floating point multiplier
-----------------------------------------------------------------------------
-- Revisions:
-- Date       | Author     | Description
-----------------------------------------------------------------------------
-- 2024/09/06 | Leonardo  | Created (not functional at this date)
--			  | 		  |
-----------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;


library work;
use work.my_package.all; 

entity data_path is
	generic
		(
		WIDTH			: integer :=  8;
		WIDTH_SIGND		: integer := 23
		);
    port (clk 		: in  std_logic;
          rst 		: in  std_logic;
          x 		: in  std_logic_vector (31 downto 0);
          y 		: in  std_logic_vector (31 downto 0);
          start_init 	: in  std_logic;
          done 		: out std_logic;
          z 		: out std_logic_vector (31 downto 0);
	  nan_o		: out std_logic;
	  infinit_o	: out std_logic;
	  overflow_o	: out std_logic;
	  underflow_o	: out std_logic
		);
end data_path;

architecture behavioral of data_path is

	signal x_mantissa 		: std_logic_vector (WIDTH_SIGND-1 downto 0); -- sinal criado para indicar a mantissa da entrada x
	signal x_exponent 		: std_logic_vector (WIDTH-1 downto 0); -- sinal criado para indicar o expoente da entrada x
	signal x_sign 			: std_logic; -- sinal criado para indicar o sinal da entrada x
	------------------
	signal y_mantissa 		: std_logic_vector (WIDTH_SIGND-1 downto 0); -- sinal criado para indicar a mantissa da entrada y
	signal y_exponent 		: std_logic_vector (WIDTH-1 downto 0); -- sinal criado para indicar o expoente da entrada y
	signal y_sign 			: std_logic; --sinal criado para indicar o sinal da entrada y
	------------------
	signal z_mantissa 		: std_logic_vector (WIDTH_SIGND-1 downto 0); -- sinal criado para indicar a mantissa da saida z
	signal z_exponent 		: std_logic_vector (WIDTH-1 downto 0); -- sinal criado para indicar o expoente da saida z
	signal z_sign 			: std_logic; --sinal criado para indicar o sinal da saida z
	------------------
	signal result_mult 		: std_logic_vector (47 downto 0); -- armazena o resultado da multiplicação das mantissas das entradas
	signal exponent_sum_1 		: std_logic_vector (WIDTH downto 0); -- armazena o resultado da primeira soma do expoente
	signal exponent_sum_2 		: std_logic_vector (WIDTH downto 0); -- armazena o resultado da segunda soma do expoente
	signal exponent_sum 		: std_logic_vector (WIDTH downto 0); -- armazena o resultado final da soma dos expoentes
	signal end_mult 		: std_logic; -- sinal indica o fim da multiplicação das mantissas
	signal c_in 			: std_logic; -- c_in será um sinal fixo em 0 para o carry de entradas dos somadores
	------------------
	signal aux1 			: std_logic_vector (WIDTH_SIGND downto 0); 		-- auxiliary sign for code organization purpose
	signal aux2 			: std_logic_vector (WIDTH_SIGND downto 0); 		-- auxiliary sign for code organization purpose
	signal aux3 			: std_logic_vector (WIDTH downto 0); 			-- auxiliary sign for code organization purpose
	signal aux4 			: std_logic_vector (WIDTH downto 0); 			-- auxiliary sign for code organization purpose
	signal aux5 			: std_logic_vector (WIDTH downto 0); 			-- auxiliary sign for code organization purpose
	signal aux6 			: std_logic_vector (WIDTH_SIGND-1 downto 0);	-- auxiliary sign for code organization purpose
	signal aux7 			: std_logic_vector (WIDTH_SIGND-1 downto 0); 	-- auxiliary sign for code organization purpose	
	------------------
	signal mantissa1 		: std_logic_vector (WIDTH_SIGND-1 downto 0); 	-- armazena o resultado normalizado que poderá ser a mantissa de saida z
	signal mantissa2 		: std_logic_vector (WIDTH_SIGND-1 downto 0); 	-- armazena o resultado normalizado que poderá ser a mantissa de saida z
	------------------
	signal nan_s			: std_logic; -- drives the output nan_o in case the multiplier receives a number "that is not a number" and ends the multiplication by "done" output
	signal infinit_s		: std_logic; -- drives the output infinit_o

	signal zero_operand_s	: std_logic; -- indicates an operand equal to zero, ending the multiplication

	begin -- begin architecture
	
	
	
	


	


--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------		  

-- step 1: add the biased exponents and subtracts the bias from the sum to get the new biased exponent

	c_in <= '0';				-- c_in recebe sempre o valor 0
	aux3 <= ('0' & x_exponent);	-- aux3 receberá sempre o valor de 0 concatenado com o expoente do x
	aux4 <= ('0' & y_exponent);	-- aux4 receberá sempre o valor de 0 concatenado com o expoente do y

	add8_1: entity work.adder(Structure)	--realiza a soma dos expoentes das entradas x e y e salva no sinal exponent_sum_1
        port map
			(
            Cin		=> c_in, -- = 0
            X   	=> aux3,
            Y		=> aux4,
	    S		=> exponent_sum_1 -- (WIDTH downto 0)
			);
		  
-- subtracts 127 from previous result in order to normalize it
	add8_2: entity work.adder(Structure)	-- subtrai-se 127 do resultado da soma anterior para normalizar o resultado 
        port map
			(
            Cin    	=> c_in, -- = 0
            X    	=> exponent_sum_1,-- x exponent + y exponent
            Y		=> "110000001",   -- (WIDTH downto 0) "-127"
	    S		=> exponent_sum_2 -- normalized exponent (WIDTH downto 0)
        	);


--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------

-- step 2: multiply the significands

	aux1 <= ('1' & x_mantissa);			-- aux1 receberá sempre o valor de 1 (hidden bit) concatenado com a mantissa do x
	aux2 <= ('1' & y_mantissa);			-- aux2 receberá sempre o valor de 1 (hidden bit) concatenado com a mantissa do y

	mult: entity work.multiplier(structural) 	-- realiza a multiplicação das mantissas x e y 
							-- quando o sinal do controle de "start_init" for 1, salvando o 
							-- resultado em "result_mult" e o sinal de pronto em "end_mult"
        port map
			(
            clk 	    	=> clk,
            rst 	    	=> rst,
            start	    	=> start_init,
	    A			=> aux1, 		-- 24 bits (23 plus the hidden bit)
	    B			=> aux2, 		-- 24 bits (23 plus the hidden bit)
	    Result		=> result_mult,		-- 48 bits
	    done		=> end_mult
			);


--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------

-- step 3: normalize the product if necessary, shifting it right and incrementing the exponent
	
	process(clk, end_mult, rst, start_init, x_exponent, y_exponent, result_mult, exponent_sum)		
	begin
		if rst = '1' then						--reseta o circuito
			z_exponent <= (others => '0');
			z_mantissa <= (others => '0');
			z_sign <= '0';
			nan_s <= '0';
			nan_o <= '0';
			infinit_o <= '0';
			overflow_o <= '0';
			underflow_o <= '0';
			zero_operand_s <= '0';
		elsif clk'event and clk = '1' then

			
			if (start_init = '1') then --quando o controle indicar que pode começar a multiplicação, os registradores de mantissa, expoente e sinal das entradas são armazenados

				--------------------------
				-- some input is not a number (NaN)
				--------------------------
				if (x(30 downto 23)=255 and x(22 downto 0)/=0) or (y(30 downto 23)=255 and y(22 downto 0)/=0) then	
					nan_s <= '1';
					nan_o <= '1';
					z_exponent <= (others => '0');
					z_mantissa <= (others => '0');
					z_sign <= '0';
					--
					infinit_o <= '0';
					infinit_s <= '0';
					overflow_o <= '0';
					underflow_o <= '0';
					zero_operand_s <= '0';
					--
				--------------------------
				-- some input is infinity	(inf*x or x*inf)
				--------------------------
				elsif (x(30 downto 23)=255 or y(30 downto 23)=255) then 
					z_exponent <= (others => '1');
					z_mantissa <= (others => '1');
					z_sign <= x_sign xor y_sign;
					infinit_o <= '1';
					infinit_s <= '1';
					--
					nan_s <= '0';
					nan_o <= '0';
					overflow_o <= '0';
					underflow_o <= '0';
					zero_operand_s <= '0';
					--
				--------------------------
				-- some input is ZERO	(0*x or x*0)
				--------------------------
				elsif (x(30 downto 23)=0 or y(30 downto 23)=0) then
					z_exponent <= (others => '0');
					z_mantissa <= (others => '0');
					z_sign <= '0';
					zero_operand_s <= '1';
					--
					nan_s <= '0';
					nan_o <= '0';
					overflow_o <= '0';
					underflow_o <= '0';
					infinit_o <= '0';
					infinit_s <= '0';
					--
				--------------------------
				-- regular multuplication
				--------------------------

				else --(start_init = '1') then
					x_mantissa <= x(22 downto 0);
					x_exponent <= x(30 downto 23);
					x_sign <= x(31);
					y_mantissa <= y(22 downto 0);
					y_exponent <= y(30 downto 23);
					y_sign <= y(31);
					nan_s <= '0';
					nan_o <= '0';
					infinit_o <= '0';
					infinit_s <= '0';
					overflow_o <= '0';
					underflow_o <= '0';
					zero_operand_s <= '0';
				end if;

			
			elsif (end_mult = '1') and nan_s='0' then				--quando occorer o fim da multiplicação
				--------------------------
				-- analysis of the MSB of the multiplication
				--------------------------
					if (result_mult(47)='1') then 			-- the MSB indicates which fraction (mantissa) will be used in the final result. o ultimo bit do resultado da multiplicação indica qual tipo de normalização que deve ser 
--						z_mantissa <= mantissa1;			--feita atribuindo o valor da matissa z com uma das duas somas feitas anteriormente (Round to Nearest Even)
						z_mantissa <= result_mult(46 downto 24); -- (Round to Zero)
					else
--						z_mantissa <= mantissa2;			-- (Round to Nearest Even)
						z_mantissa <= result_mult(45 downto 23); -- (Round to Zero)
					end if;



				--------------------------
				-- analysis of the exponent
				--------------------------
					if (exponent_sum(8)='1') then 	--o ultimo bit da soma indica se ocorreu overflow, underflow ou o resultado esta correto
						if (exponent_sum(7)='0') then 			-- overflow
							z_exponent <= (others => '1');
							z_mantissa <= (others => '1');
							z_sign <= x_sign xor y_sign;
							overflow_o <= '1';
						else 									-- underflow
							z_exponent <= (others => '0');
							z_mantissa <= (others => '0');
							z_sign <= '0';
							underflow_o <= '1';
						end if;
					elsif (exponent_sum(WIDTH-1 downto 0)=255) and (mantissa1(WIDTH_SIGND-1 downto 0)/=0 or mantissa2(WIDTH_SIGND-1 downto 0)/=0) then
					-- this above "if" clause is true when the calculated result is NaN, which in turn was considered as an overflow
							z_exponent <= (others => '1');
							z_mantissa <= (others => '1');
							z_sign <= x_sign xor y_sign;
							overflow_o <= '1';
					else								  		 --o resultado dos 8 bits menos significativos são colocados como expoente de z
						z_exponent <= exponent_sum(7 downto 0);
						z_sign <= x_sign xor y_sign;						-- o sinal da saida z é calculado
					end if;

				--------------------------
				-- analysis of the exponent and significand
				--------------------------



				end if;
			--end if;
		--end if;
		end if; -- if "rst"
	end process;

--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------
	
	aux5 <= ("00000000" & result_mult(47));	-- aux5 recebe os 9 ultimos bits do resultado da multiplicação e faz um deslocamento lógico de 8 bits para a direita
											-- why?

	add8_3: entity work.adder(Structure)	--ocorreu uma soma do resultado de expoent_sum_2 com o ultimo bit do resultado da multiplicação e salva na expoent_sum que será o expoente de saida
		port map
			(
			Cin     => c_in, -- = 0
			X     	=> exponent_sum_2,		-- new biased exponent computed in step 1
			Y		=> aux5,
			S		=> exponent_sum			-- final exponent
			);

--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------
-- TODO: perhaps we could use only one adder circuit to compute the rounding of the fraction

	aux6 <= "0000000000000000000000" & result_mult(23);	--aux6 concatena 22 bits zeros com o bit 23 do resultado da multiplicação					
	add23_4: entity work.adder23(Structure)			--occore uma soma para a arredondamento da mantissa este resultado podendo ou nao ser escolhido porteriormente
		port map
			(
			Cin     => c_in, -- = 0
			X     	=> result_mult(46 downto 24),
			Y		=> aux6,
			S		=> mantissa1
			);

	aux7 <= "0000000000000000000000" & result_mult(22);	--aux7 concatena 22 bits zeros com o bit 22 do resultado da multiplicação
	add23_5: entity work.adder23(Structure)			--occore uma soma para a arredondamento da mantissa este resultado podendo ou nao ser escolhido porteriormente
		port map
			(
			Cin     => c_in, -- = 0
			X     	=> result_mult(45 downto 23),
			Y		=> aux7,
			S		=> mantissa2
			);
	
--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------

	z(22 downto 0) <= z_mantissa;		-- a saida z recebe sempre os valores de expoente, mantissa e sinals
	z(30 downto 23) <= z_exponent;
	z(31) <= z_sign;

	done <= end_mult or nan_s or infinit_s or zero_operand_s; --done é modificado junto ao estado da multiplicação or if a "not a number" is detected at some input

end behavioral;

