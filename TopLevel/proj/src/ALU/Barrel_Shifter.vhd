-------------------------------------------------------------------------
-- Simon Aguilar
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- ALU.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of a Barrel Shifter                                                 
-- 
--
--
-- NOTES:
-- 10/17/2022 
-- 
--         
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Barrel_Shifter is
generic(N	: integer	:= 32);
  port(i_Value           : in std_logic_vector(N-1 downto 0);
       i_shift_amount    : in std_logic_vector(4 downto 0);
       i_Contral 	 : in std_logic_vector(1 downto 0); -- 00 sll 10 srl 11 sra
       o_F               : out std_logic_vector(N-1 downto 0));

end Barrel_Shifter;

architecture mixed of Barrel_Shifter is

signal s_sll, s_srl, s_sra	: std_logic_vector(N-1 downto 0);
signal s_Barrel_Shifter	: std_logic_vector(N-1 downto 0);
signal s_ones	: std_logic_vector(N-1 downto 0);
signal s_zeros	: std_logic_vector(N-1 downto 0);
signal s_shamt	: integer := 0;

signal temp	: std_logic_vector(N downto 0);

begin

-- does the initial shift
--  G_FirstPart: for i in to_integer(signed(i_shift_amount)) to N-1 generate

--	s_Barrel_Shifter(i) <= i_Value(i-to_integer(signed(i_shift_amount)));

--  end generate G_FirstPart;

-- fills in the leftover
--   G_SecontPart: for i in 0 to to_integer(signed(i_shift_amount))-1 generate

--	with i_Contral select

--	s_Barrel_Shifter(i) <= i_Value(N-1) when '1',
--				'0' when others;

--  end generate G_SecontPart;

s_sll <=i_Value when i_shift_amount = "00000" else
	i_Value(N-2 downto 0) & '0' when i_shift_amount = "00001" else 
	i_Value(N-3 downto 0) & "00" when i_shift_amount = "00010" else 
	i_Value(N-4 downto 0) & "000" when i_shift_amount = "00011" else 
	i_Value(N-5 downto 0) & x"0" when i_shift_amount = "00100" else 
	i_Value(N-6 downto 0) & x"0" & '0' when i_shift_amount = "00101" else 
	i_Value(N-7 downto 0) & x"0" & "00" when i_shift_amount = "00110" else 
	i_Value(N-8 downto 0) & x"0" & "000" when i_shift_amount = "00111" else 
	i_Value(N-9 downto 0) & x"00" when i_shift_amount = "01000" else 
	i_Value(N-10 downto 0) & x"00" & '0' when i_shift_amount = "01001" else 
	i_Value(N-11 downto 0) & x"00" & "00" when i_shift_amount = "01010" else 
	i_Value(N-12 downto 0) & x"00" & "000" when i_shift_amount = "01011" else 
	i_Value(N-13 downto 0) & x"000" when i_shift_amount = "01100" else 
	i_Value(N-14 downto 0) & x"000" & '0' when i_shift_amount = "01101" else 
	i_Value(N-15 downto 0) & x"000" & "00" when i_shift_amount = "01110" else 
	i_Value(N-16 downto 0) & x"000" & "000" when i_shift_amount = "01111" else 
	i_Value(N-17 downto 0) & x"0000" when i_shift_amount = "10000" else 
	i_Value(N-18 downto 0) & x"0000" & '0' when i_shift_amount = "10001" else 
	i_Value(N-19 downto 0) & x"0000" & "00" when i_shift_amount = "10010" else 
	i_Value(N-20 downto 0) & x"0000" & "000" when i_shift_amount = "10011" else 
	i_Value(N-21 downto 0) & x"00000" when i_shift_amount = "10100" else 
	i_Value(N-22 downto 0) & x"00000" & '0' when i_shift_amount = "10101" else 
	i_Value(N-23 downto 0) & x"00000" & "00" when i_shift_amount = "10110" else 
	i_Value(N-24 downto 0) & x"00000" & "000" when i_shift_amount = "10111" else 
	i_Value(N-25 downto 0) & x"000000" when i_shift_amount = "11000" else 
	i_Value(N-26 downto 0) & x"000000" & '0' when i_shift_amount = "11001" else 
	i_Value(N-27 downto 0) & x"000000" & "00" when i_shift_amount = "11010" else 
	i_Value(N-28 downto 0) & x"000000" & "000" when i_shift_amount = "11011" else 
	i_Value(N-29 downto 0) & x"0000000" when i_shift_amount = "11100" else 
	i_Value(N-30 downto 0) & x"0000000" & '0' when i_shift_amount = "11101" else 
	i_Value(N-31 downto 0) & x"0000000" & "00" when i_shift_amount = "11110" else 
	i_Value(N-32 downto 0) & x"0000000" & "000" when i_shift_amount = "11111"; 

s_srl <=i_Value when i_shift_amount = "00000" else
	'0' & i_Value(N-1 downto 1) when i_shift_amount = "00001" else 
	"00" & i_Value(N-1 downto 2) when i_shift_amount = "00010" else 
	"000" & i_Value(N-1 downto 3) when i_shift_amount = "00011" else 
	x"0" & i_Value(N-1 downto 4) when i_shift_amount = "00100" else 
	x"0" & '0' & i_Value(N-1 downto 5) when i_shift_amount = "00101" else 
	x"0" & "00" & i_Value(N-1 downto 6) when i_shift_amount = "00110" else 
	x"0" & "000" & i_Value(N-1 downto 7) when i_shift_amount = "00111" else 
	x"00" & i_Value(N-1 downto 8) when i_shift_amount = "01000" else 
	x"00" & '0' & i_Value(N-1 downto 9) when i_shift_amount = "01001" else 
	x"00" & "00" & i_Value(N-1 downto 10) when i_shift_amount = "01010" else 
	x"00" & "000" & i_Value(N-1 downto 11) when i_shift_amount = "01011" else 
	x"000" & i_Value(N-1 downto 12) when i_shift_amount = "01100" else 
	x"000" & '0' & i_Value(N-1 downto 13) when i_shift_amount = "01101" else 
	x"000" & "00" & i_Value(N-1 downto 14) when i_shift_amount = "01110" else 
	x"000" & "000" & i_Value(N-1 downto 15) when i_shift_amount = "01111" else 
	x"0000" & i_Value(N-1 downto 16) when i_shift_amount = "10000" else 
	x"0000" & '0' & i_Value(N-1 downto 17) when i_shift_amount = "10001" else 
	x"0000" & "00" & i_Value(N-1 downto 18) when i_shift_amount = "10010" else 
	x"0000" & "000" & i_Value(N-1 downto 19) when i_shift_amount = "10011" else 
	x"00000" & i_Value(N-1 downto 20) when i_shift_amount = "10100" else 
	x"00000" & '0' & i_Value(N-1 downto 21) when i_shift_amount = "10101" else 
	x"00000" & "00" & i_Value(N-1 downto 22) when i_shift_amount = "10110" else 
	x"00000" & "000" & i_Value(N-1 downto 23) when i_shift_amount = "10111" else 
	x"000000" & i_Value(N-1 downto 24) when i_shift_amount = "11000" else 
	x"000000" & '0' & i_Value(N-1 downto 25) when i_shift_amount = "11001" else 
	x"000000" & "00" & i_Value(N-1 downto 26) when i_shift_amount = "11010" else 
	x"000000" & "000" & i_Value(N-1 downto 27) when i_shift_amount = "11011" else 
	x"0000000" & i_Value(N-1 downto 28) when i_shift_amount = "11100" else 
	x"0000000" & '0' & i_Value(N-1 downto 29) when i_shift_amount = "11101" else 
	x"0000000" & "00" & i_Value(N-1 downto 30) when i_shift_amount = "11110" else 
	x"0000000" & "000" & i_Value(N-1 downto 31) when i_shift_amount = "11111"; 

s_sra <=i_Value when i_shift_amount = "00000" else
	'1' & i_Value(N-1 downto 1) when i_shift_amount = "00001" else 
	"11" & i_Value(N-1 downto 2) when i_shift_amount = "00010" else 
	"111" & i_Value(N-1 downto 3) when i_shift_amount = "00011" else 
	x"f" & i_Value(N-1 downto 4) when i_shift_amount = "00100" else 
	x"f" & '1' & i_Value(N-1 downto 5) when i_shift_amount = "00101" else 
	x"f" & "11" & i_Value(N-1 downto 6) when i_shift_amount = "00110" else 
	x"f" & "111" & i_Value(N-1 downto 7) when i_shift_amount = "00111" else 
	x"ff" & i_Value(N-1 downto 8) when i_shift_amount = "01000" else 
	x"ff" & '1' & i_Value(N-1 downto 9) when i_shift_amount = "01001" else 
	x"ff" & "11" & i_Value(N-1 downto 10) when i_shift_amount = "01010" else 
	x"ff" & "111" & i_Value(N-1 downto 11) when i_shift_amount = "01011" else 
	x"fff" & i_Value(N-1 downto 12) when i_shift_amount = "01100" else 
	x"fff" & '1' & i_Value(N-1 downto 13) when i_shift_amount = "01101" else 
	x"fff" & "11" & i_Value(N-1 downto 14) when i_shift_amount = "01110" else 
	x"fff" & "111" & i_Value(N-1 downto 15) when i_shift_amount = "01111" else 
	x"ffff" & i_Value(N-1 downto 16) when i_shift_amount = "10000" else 
	x"ffff" & '1' & i_Value(N-1 downto 17) when i_shift_amount = "10001" else 
	x"ffff" & "11" & i_Value(N-1 downto 18) when i_shift_amount = "10010" else 
	x"ffff" & "111" & i_Value(N-1 downto 19) when i_shift_amount = "10011" else 
	x"fffff" & i_Value(N-1 downto 20) when i_shift_amount = "10100" else 
	x"fffff" & '1' & i_Value(N-1 downto 21) when i_shift_amount = "10101" else 
	x"fffff" & "11" & i_Value(N-1 downto 22) when i_shift_amount = "10110" else 
	x"fffff" & "111" & i_Value(N-1 downto 23) when i_shift_amount = "10111" else 
	x"ffffff" & i_Value(N-1 downto 24) when i_shift_amount = "11000" else 
	x"ffffff" & '1' & i_Value(N-1 downto 25) when i_shift_amount = "11001" else 
	x"ffffff" & "11" & i_Value(N-1 downto 26) when i_shift_amount = "11010" else 
	x"ffffff" & "111" & i_Value(N-1 downto 27) when i_shift_amount = "11011" else 
	x"fffffff" & i_Value(N-1 downto 28) when i_shift_amount = "11100" else 
	x"fffffff" & '1' & i_Value(N-1 downto 29) when i_shift_amount = "11101" else 
	x"fffffff" & "11" & i_Value(N-1 downto 30) when i_shift_amount = "11110" else 
	x"fffffff" & "111" & i_Value(N-1 downto 31) when i_shift_amount = "11111"; 

o_F <=	i_Value when i_shift_amount = "00000" else
	s_sll when i_Contral = "00" else
	s_srl when i_Contral = "10" or (i_Contral = "11" and i_Value(N-1) = '0') else
	s_sra when i_Contral = "11" and i_Value(N-1) = '1' else
	x"00000000";

end mixed;
