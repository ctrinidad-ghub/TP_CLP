library IEEE;
use IEEE.std_logic_1164.all;

entity button_synch_tb is
end;

architecture button_synch_tb_arq of button_synch_tb is

    component button_synch is
        port(
            clk         : in std_logic;
            rst         : in std_logic;
            but_in      : in std_logic;
            but_out     : out std_logic
        );
    end component;

    signal clk         : std_logic := '0';
    signal rst         : std_logic := '1';
    signal but_in      : std_logic := '0';
    signal but_out     : std_logic;
begin

	rst <= '1' after 10 ns, '0' after 1000 ns;
    clk <=  '1' after 500 ns when clk = '0' else
            '0' after 500 ns when clk = '1';

    but_in <= '0' after 10 ns, '1' after 4200 ns, '0' after 8500 ns, '1' after 12200 ns, '0' after 13200 ns;
	
    DUT : button_synch
        port map (
			clk => clk,
			rst => rst,
            but_in => but_in,
            but_out => but_out
        );

end;