	component issp_position is
		port (
			source : out std_logic_vector(6 downto 0)   -- source
		);
	end component issp_position;

	u0 : component issp_position
		port map (
			source => CONNECTED_TO_source  -- sources.source
		);

