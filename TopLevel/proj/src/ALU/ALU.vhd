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
  port(i_Contral   : in std_logic_vector(4-1 downto 0);
       i_A          : in std_logic_vector(N-1 downto 0);
       i_B          : in std_logic_vector(N-1 downto 0);
       o_Z	    : out std_logic;
       o_Result        : out std_logic_vector(N-1 downto 0);
       o_OverFlow      : out std_logic);

end ALU;

architecture mixed of ALU is

component addsub is 
 	port(	i_A	: in std_logic_vector(N-1 downto 0);
		i_B	: in std_logic_vector(N-1 downto 0);
		i_ADDSUB: in std_logic;
		o_S	: out std_logic_vector(N-1 downto 0);
		o_C	: out std_logic_vector(N-1 downto 0));
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

component Norg is
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
       i_shift_amount    : in std_logic_vector(4 downto 0);
       i_Contral 	 : in std_logic_vector(1 downto 0); -- when 1 will fill it with the sign and when 0 it will be filled with 0
       o_F               : out std_logic_vector(N-1 downto 0));

end component;

signal s_And	                   : std_logic_vector(N-1 downto 0);
signal s_org	                   : std_logic_vector(N-1 downto 0);
signal s_xorg	                   : std_logic_vector(N-1 downto 0);
signal s_AddSub	                   : std_logic_vector(N-1 downto 0);
signal s_Barrel_Shifter            : std_logic_vector(N-1 downto 0);
signal s_repl_qb                   : std_logic_vector(N-1 downto 0);
signal s_Nor                       : std_logic_vector(N-1 downto 0);
signal s_ADDSUBC                   :  std_logic;
signal s_Barrel_Shifter_Control    :  std_logic_vector(1 downto 0);
signal s_Zero                      :  std_logic;
signal s_Carry                     :  std_logic_vector(N-1 downto 0);
signal s_OverFlow                  :  std_logic;



begin

-- Determains if it is addition or subtracion
with i_Contral select
	s_Barrel_Shifter_Control <= "00" when "0101", -- addition
		    "10" when "0110",-- Right shift arimithic
		    "11" when others;

-- Determains if it is addition or subtracion
with i_Contral select
	s_ADDSUBC <= '0' when "0011", -- addition
		    '1' when "0100", -- subtraction
		    '0' when others;
		   

g_Barrel_Shifter: Barrel_Shifter port map(
		i_Value	=> i_B,
		i_shift_amount	=> i_A(4 downto 0),
	        i_Contral     => s_Barrel_Shifter_Control,
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

g_Nor2_N: for i in 0 to N-1 generate
	Nor2i: Norg port map(
		i_A	=>  i_A(i),
		i_B	=>  i_B(i),
		o_F	=> s_Nor(i));
end generate g_Nor2_N;

g_addsub: addsub port map(
		i_A	=> i_A,
		i_B	=> i_B,
		i_ADDSUB => s_ADDSUBC,
		o_S	=> s_AddSub,
		o_C	=> s_Carry);

o_Z	<= '1' when i_A = i_B else '0';

OverflowXor: xorg2
    port MAP(i_A             => s_Carry(N-1),
             i_B               => s_Carry(N-2),
             o_F               => s_OverFlow);

  G_repl_qb: for i in 0 to (N/8)-1 generate

	s_repl_qb(((i+1)*8)-1 downto i*8) <= i_B(7 downto 0);

  end generate G_repl_qb;

with i_Contral select
	o_Result <= s_And when "0000",
		    s_org when "0001",
		    s_xorg when "0010",
		    s_AddSub when "0011", -- addintion
		    s_AddSub when "0100", -- subtraction
		    s_Barrel_Shifter when "0101", -- left shift
		    s_Barrel_Shifter when "0110", -- Right shift
		    s_Barrel_Shifter when "0111",-- Right shift arimithic
                    s_repl_qb when "1000",-- repl.qb
                    s_Nor when "1001",-- Nor
		    i_B(15 downto 0) & x"0000" when "1010",-- lowed upper immidiate
		    i_A when "1011",
                      x"00000000" when others;

o_OverFlow <= s_OverFlow when (i_Contral = "0011" or i_Contral = "0100") else '0';

end mixed;
