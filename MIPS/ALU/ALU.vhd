-------------------------------------------------------------------------
-- Joseph Zambreno
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- xorg2.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of a 2-input XOR 
-- gate.
--
--
-- NOTES:
-- 8/19/16 by JAZ::Design created.
-- 1/16/19 by H3::Changed name to avoid name conflict with Quartus 
--         primitives.
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity ALU is

  port(i_Contrlol   : in std_logic_vector(4-1 downto 0);
       i_A          : in std_logic_vector(N-1 downto 0);
       i_B          : in std_logic_vector(N-1 downto 0);
       o_Result          : out std_logic_vector(N-1 downto 0);
       o_Zero          : out std_logic
       o_OverFlow          : out std_logic);

end ALU;

architecture mixed of ALU is

component addsub is 
 	port(	i_A	: in std_logic_vector(31 downto 0);
		i_B	: in std_logic_vector(31 downto 0);
		i_ADDSUB: in std_logic;
		o_S	: out std_logic_vector(31 downto 0);
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

signal s_And	: std_logic_vector(N-1 downto 0);
signal s_org	: std_logic_vector(N-1 downto 0);
signal s_xorg	: std_logic_vector(N-1 downto 0);
signal s_AddSub	: std_logic_vector(N-1 downto 0);
signal s_ADDSUBC:  std_logic;

begin



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


end mixed;
