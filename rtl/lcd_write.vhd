---------------------------------------------------------------------
--
-- FileName: lcd_write.vhd
-- 
---------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity lcd_write is
    generic (
        FREQ : integer := 1 --system clock frequency in MHz
    );
    port (
        clk         : in std_logic;                    --system clock
        rst         : in std_logic;                    --reset
        cmd         : in std_logic;                    --cmd = 1, data = 0
        new_data    : in std_logic;                    --new data_in valid
        data_in     : in std_logic_vector(7 downto 0); --data_in
        busy        : out std_logic;                   --block busy
        rw, rs, en  : out std_logic;                   --read/write, setup/data, and enable for lcd
        data_out    : out std_logic_vector(7 downto 0)
    );
end;

architecture lcd_write_arq of lcd_write is
    constant LCD_EN_PULSE_WAIT_US : integer := 25 * FREQ; -- 25us

    --state machine
    type state_t is (IDLE, SEND_CMD, SEND_DATA, WAIT_EN);
    signal state, next_state : state_t;

    signal clk_count      : integer; --event counter for timing
    signal next_clk_count : integer; --event counter for timing
    signal next_data_out  : std_logic_vector(7 downto 0);
    signal next_busy      : std_logic;

    begin
        registros: process(clk, rst)
        begin
            if rst = '1' then
                state <= IDLE;
                clk_count <= 0;
                busy <= '0';
                rs <= '0';
                rw <= '0';
                en <= '0';
                data_out <= "00000000";
            elsif rising_edge(clk) then
                state <= next_state;
                clk_count <= next_clk_count;
                busy <= next_busy;
                case state is
                    when IDLE =>
                        data_out <= next_data_out;
                        rs <= '0';
                        rw <= '0';
                        en <= '0';
                    when SEND_CMD =>
                        rs <= '0';
                        rw <= '0';
                        en <= '1';
                    when SEND_DATA =>
                        rs <= '1';
                        rw <= '0';
                        en <= '1';
                    when WAIT_EN =>
                end case;
            end if;
        end process;

        process(state, new_data, data_in, cmd, clk_count)
        begin
            next_data_out <= "00000000";
            next_clk_count <= 0;
            next_busy <= '0';

            case state is
                when IDLE =>
                    if (new_data = '1') then
                        next_data_out <= data_in;
                        next_busy  <= '1';
                        if cmd = '1' then
                            next_state <= SEND_CMD;
                        else
                            next_state <= SEND_DATA;
                        end if;
                    end if;
                when SEND_CMD =>
                    next_state <= WAIT_EN;
                    next_busy  <= '1';
                when SEND_DATA =>
                    next_state <= WAIT_EN;
                    next_busy  <= '1';
                when WAIT_EN =>
                    next_busy  <= '1';
                    if(clk_count < (LCD_EN_PULSE_WAIT_US)) then
                        next_clk_count <= clk_count + 1;
                    else
                        next_clk_count <= 0;
                        next_state <= IDLE;
                        next_busy  <= '0';
                    end if;
            end case;
        end process;
end;