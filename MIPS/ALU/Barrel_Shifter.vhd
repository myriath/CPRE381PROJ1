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

entity Barrel_Shifter is
generic(N	: integer	:= 32);
  port(i_Value           : in std_logic_vector(N-1 downto 0);
       i_shift_amount    : in std_logic_vector(N-1 downto 0);
       o_F               : out std_logic_vector(N-1 downto 0));

end Barrel_Shifter;

architecture mixed of Barrel_Shifter is

signal s_Barrel_Shifter	: std_logic_vector(N-1 downto 0);

begin

  G_FirstPart: for i in to_integer(UNSIGNED(i_shift_amount)) to N-1 generate

	s_Barrel_Shifter(i) <= i_Value(i-to_integer(UNSIGNED(i_shift_amount)));

  end generate G_FirstPart;


   G_SecontPart: for i in 0 to to_integer(UNSIGNED(i_shift_amount))-1 generate

	s_Barrel_Shifter(i) <= i_Value(N - i);

  end generate G_FirstPart;

o_F <= s_Barrel_Shifter;

end mixed;
