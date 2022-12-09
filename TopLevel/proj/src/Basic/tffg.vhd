-------------------------------------------------------------------------
-- Evan Pasero
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- tffg.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of an edge-triggered
-- flip-flop with parallel access and reset.
--
--
-- NOTES:
-- 8/19/16 by JAZ::Design created.
-- 11/25/19 by H3:Changed name to avoid name conflict with Quartus
--          primitives.
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity tffg is

  port(i_CLK        : in std_logic;     -- Clock input
       i_RST        : in std_logic;     -- Reset input
       i_WE         : in std_logic;     -- Write enable input
       i_T          : in std_logic;     -- Data value input
       o_Q          : out std_logic);   -- Data value output

end tffg;

architecture structure of tffg is

component dffg
  port(i_CLK        : in std_logic;     -- Clock input
       i_RST        : in std_logic;     -- Reset input
       i_WE         : in std_logic;     -- Write enable input
       i_D          : in std_logic;     -- Data value input
       o_Q          : out std_logic);   -- Data value output
end component;

component xorg2
  port(i_A          : in std_logic;
       i_B          : in std_logic;
       o_F          : out std_logic);
end component;

signal in_D, out_Q  : std_logic;


begin

o_Q <= out_Q;

xorg_in: xorg2
	port map(
	i_A => out_Q,
	i_B => i_T,
	o_F => in_D);

flip_flop: dffg
	port map( i_CLK => i_CLK, 
	i_RST => i_RST,
	i_WE  => i_WE,
	i_D   => i_T,
	o_Q   => out_Q);


end structure;