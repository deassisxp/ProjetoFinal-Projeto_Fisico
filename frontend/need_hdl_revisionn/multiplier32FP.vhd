-----------------------------------------------------------------------------
-- README
-----------------------------------------------------------------------------
-- This is the main HDL file of a 32 floating point multiplier
-----------------------------------------------------------------------------
-- Revisions:
-- Date       | Author     | Description
-----------------------------------------------------------------------------
-- 2024/09/06 | Leonardo  | Created (not functional at this date)
--			  | 		  |
-----------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library work;
use work.my_package.all; 

entity multiplier32FP is
	generic
	(
		WIDTH		: integer :=  32
	);
	port 
		(
		clk		: in  std_logic;
	        rst_n		: in  std_logic; -- it is not an active low reset at all
    	    	a_i		: in  std_logic_vector (WIDTH-1 downto 0);
        	b_i		: in  std_logic_vector (WIDTH-1 downto 0);
          	start_i		: in  std_logic;
          	done_o		: out std_logic;
          	product_o	: out std_logic_vector (WIDTH-1 downto 0);
		nan_o		: out std_logic;
		infinit_o	: out std_logic;
		overflow_o	: out std_logic;
		underflow_o	: out std_logic
		);
end multiplier32FP;


architecture behavioral of multiplier32FP is

	signal start_init: std_logic; 
	signal done_control: std_logic;

begin
	
	control: entity work.control_path 
				port map
					(
					clk			=> clk, 
					rst			=> rst_n, -- it is not an active low reset at all
					end_mul			=> done_control,
					start			=> start_i,
					done			=> done_o,
					start_init		=> start_init
					);

	data_path: entity work.data_path
				port map
					(
					clk			=> clk,
					rst			=> rst_n, -- it is not an active low reset at all
					x			=> a_i,
					y			=> b_i,
					start_init		=> start_init,
					done			=> done_control,
					z			=> product_o,
					nan_o			=> nan_o,
					infinit_o		=> infinit_o,
					overflow_o		=> overflow_o,
				  	underflow_o		=> underflow_o
					);


end behavioral;















