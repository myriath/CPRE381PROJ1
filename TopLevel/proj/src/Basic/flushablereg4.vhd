library IEEE;
use IEEE.std_logic_1164.all;

package flushpkg is
	type flusharray is array (0 to 4) of std_logic_vector(31 downto 0);
end package flushpkg;

library IEEE;
use IEEE.std_logic_1164.all;
use work.flushpkg.all;

entity flush_reg_seq is
	generic(N: integer := 32);
	port(	clk	: in std_logic;
		rst	: in std_logic;
		w_en	: in std_logic;
		stall	: in std_logic_vector(3 downto 0);
		flush	: in std_logic_vector(3 downto 0);
		d	: in std_logic_vector(N-1 downto 0);
		q	: out std_logic_vector(N-1 downto 0));
end flush_reg_seq;

architecture structural of flush_reg_seq is	
	component flush_reg is generic(N : integer := 32); port(
		clk	: in std_logic;
		rst	: in std_logic;
		w_en	: in std_logic;
		stall	: in std_logic;
		flush	: in std_logic;
		d	: in std_logic_vector(N-1 downto 0);
		q	: out std_logic_vector(N-1 downto 0));
	end component;

signal data	: flusharray;

begin

data(0)	<= d;
q	<= data(4);

GENERATED: for i in 0 to 3 generate
NREG: flush_reg port map(
	clk	=> clk,
	rst	=> rst,
	w_en	=> w_en,
	stall	=> stall(i),
	flush	=> flush(i),
	d	=> data(i),
	q	=> data(i+1));
end generate;

end structural;
