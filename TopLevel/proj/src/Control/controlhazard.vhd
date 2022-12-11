library IEEE;
use IEEE.std_logic_1164.all;

entity controlhazards is 
	port(	clk	: in std_logic;
		rst	: in std_logic;
		opcode	: in std_logic_vector(5 downto 0);
		funct	: in std_logic_vector(5 downto 0);
		flush	: out std_logic);
end controlhazards;

architecture behavioral of controlhazards is

component andg6 is port(
	i_in0	: in std_logic;
	i_in1	: in std_logic;
	i_in2	: in std_logic;
	i_in3	: in std_logic;
	i_in4	: in std_logic;
	i_in5	: in std_logic;
	o_out	: out std_logic);
end component;

component org5 is port(
	i_in0	: in std_logic;
	i_in1	: in std_logic;
	i_in2	: in std_logic;
	i_in3	: in std_logic;
	i_in4	: in std_logic;
	o_out	: out std_logic);
end component;

component tffg is port(
	i_CLK	: in std_logic;
	i_RST	: in std_logic;
	i_WE	: in std_logic;
	i_T	: in std_logic;
	o_Q	: out std_logic);
end component;

component notg is port(
	i_in	: in std_logic;
	o_out	: out std_logic);
end component;

signal notopcode, notfunct	: std_logic_vector(5 downto 0);
signal andout	: std_logic_vector(4 downto 0);
signal andout4t	: std_logic;

begin

NOTG0: for i in 0 to 5 generate
NOTI0: notg port map(
	i_in	=> opcode(i),
	o_out	=> notopcode(i));
end generate NOTG0;

NOTG1: for i in 0 to 5 generate
NOTI1: notg port map(
	i_in	=> funct(i),
	o_out	=> notfunct(i));
end generate NOTG1;

-- J
AND2: andg6 port map(
	i_in0	=> notopcode(5),
	i_in1	=> notopcode(4),
	i_in2	=> notopcode(3),
	i_in3	=> notopcode(2),
	i_in4	=> opcode(1),
	i_in5	=> notopcode(0),
	o_out	=> andout(2));

-- JAL
AND3: andg6 port map(
	i_in0	=> notopcode(5),
	i_in1	=> notopcode(4),
	i_in2	=> notopcode(3),
	i_in3	=> notopcode(2),
	i_in4	=> opcode(1),
	i_in5	=> opcode(0),
	o_out	=> andout(3));

-- JR
AND4: andg6 port map(
	i_in0	=> notfunct(5),
	i_in1	=> notfunct(4),
	i_in2	=> funct(3),
	i_in3	=> notfunct(2),
	i_in4	=> notfunct(1),
	i_in5	=> notfunct(0),
	o_out	=> andout4t);

andout(4)	<= '1' when andout4t = '1' and opcode = "000000" else '0';

ORG: org5 port map(
	i_in0	=> '0',
	i_in1	=> '0',
	i_in2	=> andout(2),
	i_in3	=> andout(3),
	i_in4	=> andout(4),
	o_out	=> flush);

end behavioral;

