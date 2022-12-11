library IEEE;
use IEEE.std_logic_1164.all;

entity Foward is 
	port(	i_A	: in std_logic_vector(4 downto 0);
		i_B	: in std_logic_vector(4 downto 0);
		i_MemD	: in std_logic_vector(4 downto 0);
		i_MemW	: in std_logic;
		i_WbD	: in std_logic_vector(4 downto 0);
		i_WbW	: in std_logic;
		o_A	: out std_logic_vector(1 downto 0);
		o_B	: out std_logic_vector(1 downto 0));
end Foward;

architecture behavioral of Foward is

begin

o_A 	<= "00" when (i_A = "00000") else
	   "01" when (i_A = i_MemD and i_MemW = '1') else
	   "10" when (i_A = i_WbD and i_WbW = '1') else "00";

o_B 	<= "00" when (i_B = "00000") else 
      	   "01" when (i_B = i_MemD and i_MemW = '1') else
      	   "10" when (i_B = i_WbD and i_WbW = '1') else "00";
	

end behavioral;
