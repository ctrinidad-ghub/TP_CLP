library IEEE;
use IEEE.std_logic_1164.all;

entity lcd_controller_tb is
end;

architecture lcd_controller_tb_arq of lcd_controller_tb is

	component lcd_controller is
        generic (
            MODE_8_BITS  : std_logic := '1';
            FREQ         : integer := 1
        );
        port (
            clk         : in std_logic;
            rst         : in std_logic;
            new_data    : in std_logic;
            data_in     : in std_logic_vector(7 downto 0);
            new_goto    : in std_logic;
            column      : in std_logic_vector(4 downto 0);
            row         : in std_logic_vector(1 downto 0);
            busy        : out std_logic;
            rw, rs, en  : out std_logic;
            data_out    : out std_logic_vector(7 downto 0)
        );
	end component;


	component rst_synch is
        port(
            clk         : in std_logic;
            ext_rst     : in std_logic;
            pll_locked  : in std_logic;
            int_rst     : out std_logic
        );
    end component;

    signal clk         : std_logic := '0';
    signal rst, ext_rst: std_logic := '1';
    signal pll_locked  : std_logic := '0';
    signal new_data    : std_logic;
    signal data_in     : std_logic_vector(7 downto 0);
    signal busy        : std_logic;
    signal rw, rs, en  : std_logic;
    signal data_out    : std_logic_vector(7 downto 0);
    signal ena         : std_logic := '0';
    signal new_goto    : std_logic := '0';
    signal column      : std_logic_vector(4 downto 0);
    signal row         : std_logic_vector(1 downto 0);
begin

	ext_rst <= '1' after 10 ns, '0' after 200 ns;
    pll_locked <= '0' after 10 ns, '1' after 1000 ns;
    clk <=  '1' after 500 ns when clk = '0' else
            '0' after 500 ns when clk = '1';
            -- not clk after 10 ns;
    ena <= '0' after 10 ns, '1' after 50 ns;
	
    -- cursor positioning
    new_goto <= '0' after 0 ns, '1' after 53000 us, '0' after 53001 us;
    column <= "00010";
    row <= "11";

    u_rst : rst_synch
        port map (
			clk => clk,
			ext_rst => ext_rst,
            pll_locked => pll_locked,
            int_rst => rst
        );

    DUT: lcd_controller
        generic map (
            MODE_8_BITS => '0',
            FREQ => 1           -- clk = 1Mhz
        )
		port map (
			clk => clk,
			rst => rst,
            new_data => new_data,
            data_in => data_in,
            new_goto => new_goto,
            column => column,
            row  => row,
            busy => busy,
            rw => rw,
            rs => rs,
            en => en,
            data_out => data_out
		);

    process(clk)
        variable char : integer range 0 to 12 := 0;
    begin
        if rst = '1' then
            new_data <= '0';
            data_in <= "00000000";
        elsif rising_edge(clk) then
            if (busy = '0' and new_data = '0' and ena = '1') then
                new_data <= '1';
                if (char < 12) then
                    char := char + 1;
                end if;

                case char is
                    when 1 => data_in <= "00110001";
                    when 2 => data_in <= "00110010";
                    when 3 => data_in <= "00110011";
                    when 4 => data_in <= "00110100";
                    when 5 => data_in <= "00110101";
                    when 6 => data_in <= "00110110";
                    when 7 => data_in <= "00110111";
                    when 8 => data_in <= "00111000";
                    when 9 => data_in <= "00111001";
                    when 10 => data_in<= "01000001";
                    when 11 => data_in<= "01000010";
                    when others => new_data <= '0';
                end case;
            else
                new_data <= '0';
            end if;
        end if;
    end process;
end;