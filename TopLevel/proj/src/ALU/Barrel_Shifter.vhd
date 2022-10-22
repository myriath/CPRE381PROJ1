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

g_ones: for i in 0 to N-1 generate
	s_ones(i) <= '1';
end generate g_ones;

g_zeros: for i in 0 to N-1 generate
	s_zeros(i) <= '0';
end generate g_zeros;

s_shamt <= to_integer(unsigned(i_shift_amount));
temp <=	i_Value(31-s_shamt downto 0) & s_zeros(s_shamt downto 0) when (i_Contral = "00") else
	s_zeros(s_shamt downto 0) & i_Value(31 downto s_shamt)   when (i_Contral = "10" or (i_Contral = "11" and i_Value(31) = '0')) else
	s_ones(s_shamt downto 0) & i_Value(31 downto s_shamt);
o_F  <= temp(32 downto 1) when (i_Contral = "00") else
	temp(31 downto 0);

end mixed;
