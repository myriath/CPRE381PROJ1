library IEEE;
use IEEE.std_logic_1164.all;

entity FullAdder is 
	generic(N	: integer	:= 16);
	port(	i_A	: in std_logic_vector(N-1 downto 0);
		i_B	: in std_logic_vector(N-1 downto 0);
		i_C	: in std_logic;
		o_S	: out std_logic_vector(N-1 downto 0);
		o_C	: out std_logic_vector(N-1 downto 0));
end FullAdder;

architecture structure of FullAdder is

component xorg2 is
	port(	i_A	: in std_logic;
		i_B	: in std_logic;
		o_F	: out std_logic);
end component;

component org2 is
	port(	i_A	: in std_logic;
		i_B	: in std_logic;
		o_F	: out std_logic);
end component;

component andg2 is
	port(	i_A	: in std_logic;
		i_B	: in std_logic;
		o_F	: out std_logic);
end component;

signal s_AxB	: std_logic_vector(N-1 downto 0);
signal s_AaB	: std_logic_vector(N-1 downto 0);
signal s_AxBaC	: std_logic_vector(N-1 downto 0);
signal s_C	: std_logic_vector(N downto 0);

begin

s_C(0)	<= i_C;
o_C	<= s_C(N downto 1);

g_AxB: for i in 0 to N-1 generate
	xori: xorg2 port map(
		i_A	=> i_A(i),
		i_B	=> i_B(i),
		o_F	=> s_AxB(i));
end generate g_AxB;

g_AxBxC: for i in 0 to N-1 generate
	xori: xorg2 port map(
		i_A	=> s_AxB(i),
		i_B	=> s_C(i),
		o_F	=> o_S(i));
end generate g_AxBxC;

g_AaB:	for i in 0 to N-1 generate
	andi: andg2 port map(
		i_A	=> i_A(i),
		i_B	=> i_B(i),
		o_F	=> s_AaB(i));
end generate g_AaB;

g_AxBaC: for i in 0 to N-1 generate
	andi: andg2 port map(
		i_A	=> s_AxB(i),
		i_B	=> s_C(i),
		o_F	=> s_AxBaC(i));
end generate g_AxBaC;

g_oC: for i in 0 to N-1 generate
	ori: org2 port map(
		i_A	=> s_AaB(i),
		i_B	=> s_AxBaC(i),
		o_F	=> s_C(i+1));
end generate g_oC;

end structure;
