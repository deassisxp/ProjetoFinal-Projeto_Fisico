library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

library work;
use work.my_package.all;

entity data_path is
    generic(
        WIDTH       : integer := 8;
        WIDTH_SIGND : integer := 23
    );
    port (
        clk         : in  std_logic;
        rst         : in  std_logic;
        x, y        : in  std_logic_vector(31 downto 0);
        start_init  : in  std_logic;
        done        : out std_logic;
        z           : out std_logic_vector(31 downto 0);
        nan_o       : out std_logic;
        infinit_o   : out std_logic;
        overflow_o  : out std_logic;
        underflow_o : out std_logic
    );
end data_path;

architecture behavioral of data_path is
    signal x_mantissa, y_mantissa : std_logic_vector(22 downto 0);
    signal x_exponent, y_exponent : std_logic_vector(7 downto 0);
    signal x_sign, y_sign : std_logic;
    signal z_mantissa : std_logic_vector(22 downto 0);
    signal z_exponent : std_logic_vector(7 downto 0);
    signal z_sign : std_logic;
    signal result_mult : std_logic_vector(47 downto 0);
    signal exponent_sum : std_logic_vector(8 downto 0);
    signal end_mult, nan_s, infinit_s, zero_operand_s : std_logic;
begin
    -- Decodificação das entradas
    x_mantissa <= x(22 downto 0);
    x_exponent <= x(30 downto 23);
    x_sign <= x(31);
    y_mantissa <= y(22 downto 0);
    y_exponent <= y(30 downto 23);
    y_sign <= y(31);

    -- Lógica principal
    process(clk, rst)
        variable exp_sum : integer;
    begin
        if rst = '1' then
            z_mantissa <= (others => '0');
            z_exponent <= (others => '0');
            z_sign <= '0';
            nan_s <= '0';
            infinit_s <= '0';
            zero_operand_s <= '0';
        elsif rising_edge(clk) then
            if start_init = '1' then
                -- Verificação de exceções
                if (x(30 downto 23) = "11111111" and x(22 downto 0) /= 0) or 
                   (y(30 downto 23) = "11111111" and y(22 downto 0) /= 0) then
                    nan_s <= '1';
                elsif (x(30 downto 23) = "11111111" or y(30 downto 23) = "11111111") then
                    infinit_s <= '1';
                elsif (x(30 downto 23) = "00000000" or y(30 downto 23) = "00000000") then
                    zero_operand_s <= '1';
                end if;
            elsif end_mult = '1' then
                -- Normalização e arredondamento
                if result_mult(47) = '1' then
                    z_mantissa <= result_mult(46 downto 24);
                    exp_sum := to_integer(unsigned(exponent_sum)) + 1;
                else
                    z_mantissa <= result_mult(45 downto 23);
                    exp_sum := to_integer(unsigned(exponent_sum));
                end if;

                -- Round to nearest even
                if result_mult(23) = '1' then
                    if (result_mult(22 downto 0) /= 0) then
                        z_mantissa <= std_logic_vector(unsigned(z_mantissa) + 1);
                    end if;
                end if;

                -- Tratamento de overflow/underflow
                if exp_sum > 255 then
                    overflow_o <= '1';
                    z_exponent <= (others => '1');
                    z_mantissa <= (others => '0');
                elsif exp_sum < 0 then
                    underflow_o <= '1';
                    z_exponent <= (others => '0');
                    z_mantissa <= (others => '0');
                else
                    z_exponent <= std_logic_vector(to_unsigned(exp_sum, 8));
                end if;

                z_sign <= x_sign xor y_sign;
            end if;
        end if;
    end process;

    -- Saídas
    z(31) <= z_sign;
    z(30 downto 23) <= z_exponent;
    z(22 downto 0) <= z_mantissa;
    nan_o <= nan_s;
    infinit_o <= infinit_s;
    done <= end_mult or nan_s or infinit_s or zero_operand_s;
end behavioral;