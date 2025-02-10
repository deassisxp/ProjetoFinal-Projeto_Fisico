
library IEEE;						
use IEEE.std_logic_1164.all;
--use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
USE ieee.Numeric_STD.all;

library work;
use work.my_package.all;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity multiplier is
    port (
        clk, rst    : in std_logic;
        start       : in std_logic;
        A, B        : in std_logic_vector(23 downto 0);     
        Result      : out std_logic_vector(47 downto 0);
        done        : out std_logic
    );
end multiplier;

architecture structural of multiplier is
    type state_type is (s0, s1, s2, s3);
    signal state : state_type;
    signal cont : integer range 0 to 23;
    signal mul, aux, res : std_logic_vector(47 downto 0);
begin
    add48: entity work.adder48(Structure)
        port map(Cin => '0', X => aux, Y => mul, S => res);

    process(clk, rst)
    begin
        if rst = '0' then
            cont <= 0;
            aux <= (others => '0');
            mul <= (others => '0');
            done <= '0';
            state <= s0;
        elsif rising_edge(clk) then
            case state is
                when s0 =>
                    if start = '1' then
                        state <= s1;
                        aux <= (others => '0');
                        mul <= (others => '0');
                        cont <= 0;
                    end if;
                when s1 =>
                    mul <= (others => '0');
                    if B(cont) = '1' then
                        mul(23 downto 0) <= A;
                    end if;
                    state <= s2;
                when s2 =>
                    mul <= std_logic_vector(shift_left(unsigned(mul), cont));
                    state <= s3;
                when s3 =>
                    if cont = 23 then
                        done <= '1';
                        state <= s0;
                    else
                        aux <= res;
                        cont <= cont + 1;
                        state <= s1;
                    end if;
            end case;
        end if;
    end process;
    Result <= res;
end structural;