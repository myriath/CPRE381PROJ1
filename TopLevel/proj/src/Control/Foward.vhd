library IEEE;
use IEEE.std_logic_1164.all;

entity Foward is 
	port(	i_RS	: in std_logic_vector(5 downto 0);
		i_RT	: in std_logic_vector(5 downto 0);
		i_ExMem	: in std_logic_vector(5 downto 0);
		i_ExALU	: in std_logic_vector(5 downto 0);
		o_RS	: out std_logic_vector(1 downto 0);
		o_RT	: out std_logic_vector(1 downto 0);
);
end Foward;

architecture behavioral of Foward is

signal RS	: std_logic_vector(1 downto 0);
signal RT	: std_logic_vector(1 downto 0);



begin

Rs <= '0' when(i_ExALU = 0 and i_ExMem = 0) else
      '1' when(i_RS = i_ExALU) else
      '2' when(i_RS = i_ExMem) else '0';


RT <= '0' when(i_ExALU = 0 and i_ExMem = 0) else 
      '1' when(i_RT = i_ExALU) else
      '2' when(i_RT = i_ExMem) else '0';

o_RS <= Rs;
o_RT <= RT;

end behavioral;
