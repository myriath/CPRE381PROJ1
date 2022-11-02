library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity pc is 
	port(	i_CLK	: in std_logic;
		i_RST	: in std_logic;
		i_PC	: in std_logic_vector(31 downto 0);
		i_INST	: in std_logic_vector(25 downto 0);
		i_REG31	: in std_logic_vector(31 downto 0);
		i_JR	: in std_logic;
		i_BRANCH: in std_logic;
		i_JUMP	: in std_logic;
		i_IMMED	: in std_logic_vector(29 downto 0);
		o_PCP4	: out std_logic_vector(31 downto 0);
		o_NEXT	: out std_logic_vector(31 downto 0)
);
end pc;

architecture behavioral of pc is

component dffgSpecial is
port(
	i_CLK	: in std_logic;
	i_RST	: in std_logic;
	i_WE	: in std_logic;
	i_D	: in std_logic_vector(31 downto 0);
	o_Q	: out std_logic_vector(31 downto 0));
end component;

signal pcPlus4	: std_logic_vector(31 downto 0);
signal pcNext	: std_logic_vector(31 downto 0);
signal jAddr	: std_logic_vector(31 downto 0);
signal s_BranchMux	: std_logic_vector(31 downto 0);

signal s_pc	: std_logic_vector(31 downto 0);
signal s_pcint	: integer;
signal s_immed	: integer;

begin

PCReg: dffgSpecial port map(
	i_CLK	=> i_CLK,
	i_RST	=> i_RST,
	i_WE	=> '1',
	i_D	=> pcNext,
	o_Q	=> s_pc);

s_pcint		<= to_integer(unsigned(i_PC) + 4);
s_immed		<= to_integer(unsigned(i_IMMED & "00"));
pcPlus4 	<= std_logic_vector(to_signed(s_pcint, i_PC'length));
jAddr	 	<= pcPlus4(31 downto 28) & i_INST & "00";
s_BranchMux	<= pcPlus4 when (i_BRANCH = '0') else std_logic_vector(to_signed(s_pcint + s_immed, i_PC'length));
o_PCP4		<= pcPlus4;
pcNext		<= i_REG31 when (i_JR = '1') else jAddr when (i_JUMP = '1') else s_BranchMux(31 downto 0);
o_NEXT		<= s_pc;

end behavioral;
