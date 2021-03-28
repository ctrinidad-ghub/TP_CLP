---------------------------------------------------------------------
--
-- FileName: rst_synch.vhd
-- 
---------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

entity rst_synch is
    port(
        clk         : in std_logic;
        ext_rst     : in std_logic;
        pll_locked  : in std_logic;
        int_rst     : out std_logic
    );
end;

architecture rst_synch_arq of rst_synch is
    signal synch_1     : std_logic;
    signal synch_2     : std_logic;
begin
    process(clk, ext_rst)
    begin
        if ext_rst = '1' then
            synch_1 <= '1';
            synch_2 <= '1';
        elsif rising_edge(clk) then
            if pll_locked = '1' then 
                synch_2 <= synch_1;
                synch_1 <= '0';
            end if;
        end if;
    end process;
    int_rst <= synch_2;
end;