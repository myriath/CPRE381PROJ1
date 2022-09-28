library IEEE;
use IEEE.std_logic_1164.all;

entity signextender is
	port(	i_DATA	: in std_logic_vector(15 downto 0);
		i_SIGN	: in std_logic;
		o_DATA	: out std_logic_vector(31 downto 0));
end signextender;

architecture mixed of signextender is
begin
	o_DATA <=	(x"ffff" & i_DATA) when (i_SIGN = '1' and i_DATA(15) = '1') else
			x"0000" & i_DATA;
end mixed;	
