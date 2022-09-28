library IEEE;
use IEEE.std_logic_1164.all;

package muxpkg is
	type muxarray is array (0 to 31) of std_logic_vector(31 downto 0);
end package muxpkg;

library IEEE;
use IEEE.std_logic_1164.all;
use work.muxpkg.all;

entity mux32t1 is
	port(	i_SEL	: in std_logic_vector(4 downto 0);
		i_D	: in muxarray;
		o_O	: out std_logic_vector(31 downto 0));
end mux32t1;

architecture dataflow of mux32t1 is
begin

o_O <=	i_D(0) when i_SEL = "00000" else
	i_D(1) when i_SEL = "00001" else
	i_D(2) when i_SEL = "00010" else
	i_D(3) when i_SEL = "00011" else
	i_D(4) when i_SEL = "00100" else
	i_D(5) when i_SEL = "00101" else
	i_D(6) when i_SEL = "00110" else
	i_D(7) when i_SEL = "00111" else
	i_D(8) when i_SEL = "01000" else
	i_D(9) when i_SEL = "01001" else
	i_D(10) when i_SEL = "01010" else
	i_D(11) when i_SEL = "01011" else
	i_D(12) when i_SEL = "01100" else
	i_D(13) when i_SEL = "01101" else
	i_D(14) when i_SEL = "01110" else
	i_D(15) when i_SEL = "01111" else
	i_D(16) when i_SEL = "10000" else
	i_D(17) when i_SEL = "10001" else
	i_D(18) when i_SEL = "10010" else
	i_D(19) when i_SEL = "10011" else
	i_D(20) when i_SEL = "10100" else
	i_D(21) when i_SEL = "10101" else
	i_D(22) when i_SEL = "10110" else
	i_D(23) when i_SEL = "10111" else
	i_D(24) when i_SEL = "11000" else
	i_D(25) when i_SEL = "11001" else
	i_D(26) when i_SEL = "11010" else
	i_D(27) when i_SEL = "11011" else
	i_D(28) when i_SEL = "11100" else
	i_D(29) when i_SEL = "11101" else
	i_D(30) when i_SEL = "11110" else
	i_D(31) when i_SEL = "11111";
end dataflow;
