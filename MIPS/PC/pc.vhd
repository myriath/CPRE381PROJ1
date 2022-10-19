library IEEE;
use IEEE.std_logic_1164.all;

entity pc is 
	port(	i_PC	: in std_logic_vector(31 downto 0);
		i_INST	: in std_logic_vector(25 downto 0);
		i_BRANCH: in std_logic;
		i_JUMP	: in std_logic;
		i_IMMED	: in std_logic_vector(29 downto 0);
		o_NEXT	: out std_logic_vector(31 downto 0);
);
end pc;

architecture behavioral of pc is

signal pcPlus4	: std_logic_vector(31 downto 0);
signal jAddr	: std_logic_vector(31 downto 0);
signal s_BranchMux	: std_logic_vector(31 downto 0);
signal s_BranchAdder	: std_logic_vector(31 downto 0);

begin;

pcPlus4 	<= std_logic_vector(to_unsigned(to_integer(unsigned(i_PC)) + 4);
jAddr	 	<= pcPlus4(31 downto 28) + i_INST + "00";
s_BranchMux	<= pcPlus4 when (i_BRANCH = '0') else std_logic_vector(to_unsigned(pcPlus4) + to_unsigned(i_IMMED + "00"))(31 downto 0);
o_NEXT		<= jAddr when (i_JUMP = '1') else s_BranchMux;

end behavioral;
