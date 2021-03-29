---------------------------------------------------------------------
--
-- FileName: button_synch.vhd
-- 
---------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

entity button_synch is
    port(
        clk         : in std_logic;
        rst         : in std_logic;
        but_in      : in std_logic;
        but_out     : out std_logic
    );
end;

architecture button_synch_arq of button_synch is
    signal synch_1      : std_logic;
    signal synch_2      : std_logic;
    signal synch_2_prev : std_logic;
begin
    process(clk, rst)
    begin
        if rst = '1' then
            synch_1 <= '0';
            synch_2 <= '0';
            synch_2_prev <= '0';
            but_out <= '0';
        elsif rising_edge(clk) then
            synch_2 <= synch_1;
            synch_1 <= but_in;
            if synch_2_prev = '0' and synch_2 = '1' then
                but_out <= '1';
                synch_2_prev <= '1';
            else
                but_out <= '0';
            end if;
            if synch_2 = '0' then
                synch_2_prev <= '0';
            end if;
        end if;
    end process;
end;