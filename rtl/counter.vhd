---------------------------------------------------------------------
--
-- FileName: counter.vhd
-- 
---------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity counter is
    generic (
        DATA_WIDTH  : integer := 8;
        FREQ        : integer := 1 --system clock frequency in MHz
    );
    port(
        clk         : in std_logic;
        rst         : in std_logic;
        en          : in std_logic;
        load        : in std_logic;
        load_data   : in std_logic_vector(7 downto 0);
        ready       : out std_logic
    );
end;

architecture counter_arq of counter is
    signal count_i: unsigned(7 downto 0);
begin
    process(clk, rst)
    begin
        if rst = '1' then
            count_i <= (others => '1');
        elsif rising_edge(clk) then
            if load = '1' then 
                count_i <= unsigned(load_data) * to_unsigned(FREQ,8);
            elsif (en = '1' and count_i > 0) then 
                count_i <= count_i - 1;
            end if;
        end if;
    end process;

    ready <= '1' when count_i = 0 else -- check this comparasion
             '0';
end;