library IEEE;
use IEEE.std_logic_1164.all;

entity flush_reg is
	generic(N: integer := 32);
	port(	clk	: in std_logic;
		rst	: in std_logic;
		w_en	: in std_logic;
		stall	: in std_logic;
		flush	: in std_logic;
		d	: in std_logic_vector(N-1 downto 0);
		q	: out std_logic_vector(N-1 downto 0));
end flush_reg;

architecture structural of flush_reg is	
	component n_dff is generic(N : integer := N); port(
		clk	: in std_logic;
		rst	: in std_logic;
		w_en	: in std_logic;
		d	: in std_logic_vector(N-1 downto 0);
		q	: out std_logic_vector(N-1 downto 0));
	end component;

signal s_en	: std_logic;
signal s_d	: std_logic_vector(N-1 downto 0);
signal s_zero	: std_logic_vector(31 downto 0);

begin

s_en	<= '1' when w_en = '1' and stall = '0' else '0';
s_d	<= d when flush = '0' else s_zero(N-1 downto 0);
s_zero	<= x"00000000";

NREG: n_dff port map(
	clk	=> clk,
	rst	=> rst,
	w_en	=> s_en,
	d	=> s_d,
	q	=> q);

end structural;
