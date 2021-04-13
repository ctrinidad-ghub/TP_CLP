	component issp_char is
		port (
			source : out std_logic_vector(7 downto 0)   -- source
		);
	end component issp_char;

	u0 : component issp_char
		port map (
			source => CONNECTED_TO_source  -- sources.source
		);

