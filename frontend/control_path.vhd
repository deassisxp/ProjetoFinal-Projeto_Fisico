library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library work;
use work.my_package.all;

entity control_path is
    port (
        clk         : in  std_logic;
        rst         : in  std_logic;
        end_mul     : in  std_logic;
        start       : in  std_logic;
        done        : out std_logic;
        start_init  : out std_logic
    );
end control_path;

architecture behavioral of control_path is
    type state_machine is (s0, s1, s2, s3);
    signal currentState : state_machine;
begin
    process(clk, rst)
    begin
        if rst = '1' then
            currentState <= s0;
        elsif rising_edge(clk) then
            case currentState is
                when s0 =>
                    if start = '1' then
                        currentState <= s1;
                    end if;
                when s1 =>
                    currentState <= s2;
                when s2 =>
                    if end_mul = '1' then
                        currentState <= s3;
                    end if;
                when s3 =>
                    currentState <= s0;
            end case;
        end if;
    end process;

    done <= '1' when currentState = s3 else '0';
    start_init <= '1' when currentState = s1 else '0';
end behavioral;