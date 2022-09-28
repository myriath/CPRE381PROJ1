library IEEE;
use IEEE.std_logic_1164.all;

entity zeroextender is
	port(	i_DATA	: in std_logic_vector(15 downto 0);
		o_DATA	: out std_logic_vector(31 downto 0));
end zeroextender;

architecture mixed of zeroextender is
begin
	o_DATA <= x"0000" & i_DATA;
end mixed;	
