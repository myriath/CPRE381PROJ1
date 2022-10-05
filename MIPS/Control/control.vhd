library IEEE;
use IEEE.std_logic_1164.all;

entity control is 
	port(	i_OP	: in std_logic_vector(5 downto 0);
		RegDst	: out std_logic;
		Jump	: out std_logic;
		Branch	: out std_logic;
		MemRead	: out std_logic;
		MemtoReg	: out std_logic;
		ALUOp	: out std_logic_vector(3 downto 0);
		MemWrite	: out std_logic;
		ALUSrc	: out std_logic;
		RegWrite	: out std_logic;
);
end control;

architecture structure of AddSub is

component FullAdder is
	generic(N	: integer	:= 32);
	port(	i_A	: in std_logic_vector(N-1 downto 0);
		i_B	: in std_logic_vector(N-1 downto 0);
		i_C	: in std_logic;
		o_S	: out std_logic_vector(N-1 downto 0);
		o_C	: out std_logic);
end component;

component xorg2 is
	port(	i_A	: in std_logic;
		i_B	: in std_logic;
		o_F	: out std_logic);
end component;

signal s_B	: std_logic_vector(31 downto 0);

begin

g_FullAdder: FullAdder port map(
		i_A	=> i_A,
		i_B	=> s_B,
		i_C	=> i_ADDSUB,
		o_S	=> o_S,
		o_C	=> o_C);

g_B: for i in 0 to 31 generate
	xori: xorg2 port map (
		i_A	=> i_ADDSUB,
		i_B	=> i_B(i),
		o_F	=> s_B(i));
end generate;

end structure;
