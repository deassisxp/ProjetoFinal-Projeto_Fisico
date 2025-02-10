library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library work;
use work.my_package.all;

entity multiplier32FP is
    port (
        clk         : in  std_logic;
        rst_n       : in  std_logic;
        a_i, b_i    : in  std_logic_vector(31 downto 0);
        start_i     : in  std_logic;
        done_o      : out std_logic;
        product_o   : out std_logic_vector(31 downto 0);
        nan_o       : out std_logic;
        infinit_o   : out std_logic;
        overflow_o  : out std_logic;
        underflow_o : out std_logic
    );
end multiplier32FP;

architecture behavioral of multiplier32FP is
    signal rst : std_logic;
    signal start_init, end_mul : std_logic;
begin
    rst <= not rst_n; -- Reset ativo alto

    control: entity work.control_path
        port map(
            clk => clk,
            rst => rst,
            end_mul => end_mul,
            start => start_i,
            done => done_o,
            start_init => start_init
        );

    data: entity work.data_path
        port map(
            clk => clk,
            rst => rst,
            x => a_i,
            y => b_i,
            start_init => start_init,
            done => end_mul,
            z => product_o,
            nan_o => nan_o,
            infinit_o => infinit_o,
            overflow_o => overflow_o,
            underflow_o => underflow_o
        );
end behavioral;