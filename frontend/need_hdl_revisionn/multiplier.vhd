
library IEEE;						
use IEEE.std_logic_1164.all;
--use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
USE ieee.Numeric_STD.all;

library work;
use work.my_package.all;

entity multiplier  is
	port (
		clk, rst		: in std_logic;
		start			: in std_logic;
		A, B			: in std_logic_vector(23 downto 0);		
		Result			: out std_logic_vector(47 downto 0);
		done			: out std_logic
	);
		
end multiplier;

architecture structural of multiplier is  
        
    
    signal cont : integer range 0 to 23;
    signal mul : std_logic_vector(47 downto 0);	
    --signal mul_1 : std_logic_vector(47 downto 0);	
    signal aux : std_logic_vector(47 downto 0);		--recebe o valor do resultado da soma para realizar a soma novamente
    signal res : std_logic_vector(47 downto 0);		--armazena o resultado da soma
    --signal start_cond : std_logic;
    type state_type is (s0, s1, s2, s3);		--maquina de estados com 4 possiveis estados
    signal state : state_type;

begin


	add48: entity work.adder48(Structure)		-- soma do resultado da and com o resultado anterior
		port map(
			Cin     =>'0',
			X     => aux,
			Y	=> mul,
			S	=> res
		);


	process(state, clk, rst, A, B, cont, start)
	begin
		if (rst = '1') then			-- inicializa o circuito
			cont <= 0;
			aux <= (others=>'0');
			mul <= (others=>'0');
--			res <= (others=>'0'); -- LLO
			done <= '0';
			state <= s0;
		elsif clk'event and clk = '1' then
		case state is 
			when s0 =>
				if (start = '1') then	-- inicializa a multiplicação
					cont <= 0;
					aux <= (others=>'0');
					mul <= (others=>'0');
					done <= '0';
					state <= s1;	-- passa para o proximo estado
				else 
					state <= s0;
				end if;
			when s1 =>
				if B(cont) = '1' then	-- realiza uma lógica and de um bit de B com o valor de a e extende para 48 bits e passa para o proximo estado
					mul <= "000000000000000000000000" & A;
				else
					mul <= "000000000000000000000000" & "000000000000000000000000";
				end if;
				state <= s2;
			when s2 =>
				mul <= std_logic_vector(unsigned(mul) sll cont);	--é feito um deslocamento para esquerda do resultado em um tamanho igual ao bit da entrada B que foi pego e passa para o proximo estado
				state <= s3;	
			
			when s3 =>							--verifica se foram feitos todos os bits de B, no caso 23, indicando o fim da multiplicação e indo para o estado inicial, caso contrario  
				if cont = 23 then					--busca-se o proximo bit de B e atualiza o resultado para que seja somado novamente e volta para o estado S1
					done <= '1';
					state <= s0;
				else
					cont <= cont + 1;
					aux <= res;
					state <= s1;
				end if;			
		end case;
		end if;
	end process;
	
	Result <= res;			--o resultado final sempre recebe o valor do resultado da soma sendo realmente finalizado apos o done = '1'

end structural;






