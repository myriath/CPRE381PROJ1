library IEEE;
use IEEE.std_logic_1164.all;

entity n_dff is
	generic(N: integer := 32);
	port(	clk	: in std_logic;
		rst	: in std_logic;
		w_en	: in std_logic;
		d	: in std_logic_vector(N-1 downto 0);
		
		q	: out std_logic_vector(N-1 downto 0));
end n_dff;

architecture structural of n_dff is	
	component dffg is port(
		i_CLK	: in std_logic;
		i_RST	: in std_logic;
		i_WE	: in std_logic;
		i_D	: in std_logic;
		o_Q	: out std_logic);
	end component;

begin

	G_NDFF: for i in 0 to N-1 generate
	DFFI: dffg port map(
		i_CLK	=> clk,
		i_RST	=> rst,
		i_WE	=> w_en,
		i_D	=> d(i),
		o_Q	=> q(i));
	end generate G_NDFF;

end structural;
