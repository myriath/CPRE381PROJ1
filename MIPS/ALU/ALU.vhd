-------------------------------------------------------------------------
-- Simon Aguilar
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- ALU.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of a ALU                                                 
-- 
--
--
-- NOTES:
-- 10/12/2022 
-- 
--         
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity ALU is
generic(N	: integer	:= 32);
  port(i_Contrlol   : in std_logic_vector(4-1 downto 0);
       i_A          : in std_logic_vector(N-1 downto 0);
       i_B          : in std_logic_vector(N-1 downto 0);
       o_Result          : out std_logic_vector(N-1 downto 0);
       o_Zero          : out std_logic
       o_OverFlow          : out std_logic);

end ALU;

architecture mixed of ALU is

component addsub is 
 	port(	i_A	: in std_logic_vector(N-1 downto 0);
		i_B	: in std_logic_vector(N-1 downto 0);
		i_ADDSUB: in std_logic;
		o_S	: out std_logic_vector(N-1 downto 0);
		o_C	: out std_logic);
end component;

component xorg2 is
	port(	i_A	: in std_logic;
		i_B	: in std_logic;
		o_F	: out std_logic);
end component;

component org2 is
	port(	i_A	: in std_logic;
		i_B	: in std_logic;
		o_F	: out std_logic);
end component;

component andg2 is
	port(	i_A	: in std_logic;
		i_B	: in std_logic;
		o_F	: out std_logic);
end component;

component Barrel_Shifter is

  port(i_Value           : in std_logic_vector(N-1 downto 0);
       i_shift_amount    : in std_logic_vector(N-1 downto 0);
       o_F               : out std_logic_vector(N-1 downto 0));

end component;

signal s_And	: std_logic_vector(N-1 downto 0);
signal s_org	: std_logic_vector(N-1 downto 0);
signal s_xorg	: std_logic_vector(N-1 downto 0);
signal s_AddSub	: std_logic_vector(N-1 downto 0);
signal s_Barrel_Shifter : std_logic_vector(N-1 downto 0);
signal s_ADDSUBC:  std_logic;

begin

-- Determains if it is addition or subtracion
with i_Contral select
	s_ADDSUBC <= 0 when "0011", -- addition
		    1 when "0100"; -- subtraction
		   

g_Barrel_Shifter: Barrel_Shifter port map(
		i_Value	=> i_A,
		i_shift_amount	=> i_B,
	
		o_F => s_Barrel_Shifter);

g_Andg_N: for i in 0 to N-1 generate
	andi: andg2 port map(
		i_A	=>  i_A(i),
		i_B	=>  i_B(i),
		o_F	=> s_And(i));
end generate g_Andg_N;
  
g_Org_N: for i in 0 to N-1 generate
	orgi: org2 port map(
		i_A	=>  i_A(i),
		i_B	=>  i_B(i),
		o_F	=> s_org(i));
end generate g_Org_N;

g_Xorg_N: for i in 0 to N-1 generate
	xorgi: xorg2 port map(
		i_A	=>  i_A(i),
		i_B	=>  i_B(i),
		o_F	=> s_xorg(i));
end generate g_Xorg_N;

g_addsub: addsub port map(
		i_A	=> i_A,
		i_B	=> i_B,
		i_ADDSUB => s_ADDSUBC,
		o_S	=> s_AddSub,
		o_C	=> o_Zero);

OverflowXor: xorg2
    port MAP(i_A             => o_Zero,
             i_B               => s_AddSub(N-1),
             o_F               => o_OverFlow);


with i_Contral select
	o_Result <= s_And when "0000",
		    s_org when "0001",
		    s_xorg when "0010",
		    s_AddSub when "0011", -- addintion
		    s_AddSub when "0100", -- subtraction
		    s_Barrel_Shifter when "0101";

end mixed;
