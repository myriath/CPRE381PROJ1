library IEEE;
use IEEE.std_logic_1164.all;
use work.muxpkg.all;

entity datapath is
	port(	i_CLK	: in std_logic;
		i_RST	: in std_logic;	
		i_EN	: in std_logic;
		i_VALUE	: in std_logic_vector(31 downto 0);
		i_DST	: in std_logic_vector(4 downto 0);
		i_SRC0	: in std_logic_vector(4 downto 0);
		i_SRC1	: in std_logic_vector(4 downto 0);
		i_ADDSUB: in std_logic;
		i_SRCSEL: in std_logic);
end datapath;

architecture mixed of datapath is
	signal s_ALURES	: std_logic_vector(31 downto 0);
	signal s_ALUA	: std_logic_vector(31 downto 0);
	signal s_ALUB	: std_logic_vector(31 downto 0);
	signal s_MUX0	: std_logic_vector(31 downto 0);
	signal s_CARRY	: std_logic;
	component regfile is port(
		i_CLK	: in std_logic;
		i_RST	: in std_logic;
		i_WEN	: in std_logic;
		i_WADDR	: in std_logic_vector(4 downto 0);
		i_WDATA	: in std_logic_vector(31 downto 0);
		i_RADDR0: in std_logic_vector(4 downto 0);
		i_RADDR1: in std_logic_vector(4 downto 0);
		o_RDATA0: out std_logic_vector(31 downto 0);
		o_RDATA1: out std_logic_vector(31 downto 0));
	end component;
	component addsub is port(
		i_A	: in std_logic_vector(31 downto 0);
		i_B	: in std_logic_vector(31 downto 0);
		i_ADDSUB: in std_logic;
		o_S	: out std_logic_vector(31 downto 0);
		o_C	: out std_logic);
	end component;
begin
	s_ALUB <= s_MUX0 when (i_SRCSEL = '0') else i_VALUE;

	FILEREG: regfile port map(
		i_CLK	=> i_CLK,
		i_RST	=> i_RST,
		i_WEN	=> i_EN,
		i_WADDR	=> i_DST,
		i_WDATA	=> s_ALURES,
		i_RADDR0=> i_SRC0,
		i_RADDR1=> i_SRC1,
		o_RDATA0=> s_ALUA,
		o_RDATA1=> s_MUX0);

	ALU: addsub port map(
		i_A	=> s_ALUA,
		i_B	=> s_ALUB,
		i_ADDSUB=> i_ADDSUB,
		o_S	=> s_ALURES,
		o_C	=> s_CARRY);
end mixed;	
