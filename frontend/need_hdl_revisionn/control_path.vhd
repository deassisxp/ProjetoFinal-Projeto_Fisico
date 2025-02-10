-----------------------------------------------------------------------------
-- README
-----------------------------------------------------------------------------
-- This is the control of the main HDL file of a 32 floating point multiplier
-----------------------------------------------------------------------------
-- Revisions:
-- Date       | Author     | Description
-----------------------------------------------------------------------------
-- 2024/09/06 | Leonardo  | Created (not functional at this date)
--			  | 		  |
-----------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.ALL;

entity control_path is
    port (clk 			: in  std_logic;
          rst 			: in  std_logic;
          end_mul 		: in  std_logic;
          start 		: in  std_logic;
	  done 			: out std_logic;
          start_init 		: out std_logic);
end control_path;


architecture behavioral of control_path is

	type state_machine is (s0, s1, s2, s3); -- Máquina de estados com 4 possiveis estados
	signal currentState : state_machine;
    
	begin

	process(clk, rst, currentState, start, end_mul) -- processo verificando algumas condições muda o estado da maquina de estados
	begin

		if rst = '1' then
			currentState <= S0;	
		elsif clk'event and clk = '1' then
			case currentState is
				when S0 =>
					if start = '1' then
						currentState <= S1;
					else
						currentState <= S0;
					end if;
				when S1 =>
					currentState <= S2;
				when S2 =>
					if end_mul = '1' then
						currentState <= S3;
					else
						currentState <= S2;
					end if;
				when others => -- when not S0, not S1 or not S2 ;)
					currentState <= S0;
				end case;
		end if;
	end process;
	
	done <= '1' when currentState = S3 else '0';			-- sempre que o estado for o ultimo(S3) o sinal de done será 1 indicando que a multiplicação de ponto flutuante terminou
	start_init  <= '1' when currentState = S1 else '0';		-- sempre que o estado for o segundo(S1) o sinal de start_init será 1 indicando que o Data_path poderá começar a realizar suas tarefas
	

end behavioral;

