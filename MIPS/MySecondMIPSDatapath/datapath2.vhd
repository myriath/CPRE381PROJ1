library IEEE;
use IEEE.std_logic_1164.all;
use work.muxpkg.all;

entity datapath2 is
	port(	i_CLK	: in std_logic;
		i_RST	: in std_logic;	
		i_RW	: in std_logic;
		i_MW	: in std_logic;
		i_IMMED	: in std_logic_vector(15 downto 0);
		i_DST	: in std_logic_vector(4 downto 0);
		i_SRC0	: in std_logic_vector(4 downto 0);
		i_SRC1	: in std_logic_vector(4 downto 0);
		i_ADDSUB: in std_logic;
		i_SRCSEL: in std_logic;
		i_WSEL	: in std_logic;
		i_SIGN	: in std_logic);
end datapath2;

architecture mixed of datapath2 is
	signal s_RAMREAD: std_logic_vector(31 downto 0);
	signal s_REGWRITE: std_logic_vector(31 downto 0);
	signal s_EXTEND	: std_logic_vector(31 downto 0);
	signal s_ALURESADDR	: std_logic_vector(9 downto 0);

	signal s_ALURES	: std_logic_vector(31 downto 0);
	signal s_ALUA	: std_logic_vector(31 downto 0);
	signal s_ALUB	: std_logic_vector(31 downto 0);
	signal s_REGREAD1	: std_logic_vector(31 downto 0);
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

	component mem is 
	generic(
		DATA_WIDTH	: natural := 32;
		ADDR_WIDTH	: natural := 10);
	port(
		clk	: in std_logic;
		addr	: in std_logic_vector(ADDR_WIDTH-1 downto 0);
		data	: in std_logic_vector(DATA_WIDTH-1 downto 0);
		we	: in std_logic;
		q	: out std_logic_vector(DATA_WIDTH-1 downto 0));
	end component;

	component signextender is port(
		i_DATA	: in std_logic_vector(15 downto 0);
		i_SIGN	: in std_logic;
		o_DATA	: out std_logic_vector(31 downto 0));
	end component;
begin
	s_ALUB <= s_EXTEND when (i_SRCSEL = '1' or i_WSEL = '1') else s_REGREAD1;
	s_REGWRITE <= s_ALURES when (i_WSEL = '0') else s_RAMREAD;
	s_ALURESADDR <= s_ALURES(9 downto 0);

	FILEREG: regfile port map(
		i_CLK	=> i_CLK,
		i_RST	=> i_RST,
		i_WEN	=> i_RW,
		i_WADDR	=> i_DST,
		i_WDATA	=> s_REGWRITE,
		i_RADDR0=> i_SRC0,
		i_RADDR1=> i_SRC1,
		o_RDATA0=> s_ALUA,
		o_RDATA1=> s_REGREAD1);

	ALU: addsub port map(
		i_A	=> s_ALUA,
		i_B	=> s_ALUB,
		i_ADDSUB=> i_ADDSUB,
		o_S	=> s_ALURES,
		o_C	=> s_CARRY);

	RAM: mem port map(
		clk	=> i_CLK,
		addr	=> s_ALURESADDR,
		data	=> s_REGREAD1,
		we	=> i_MW,
		q	=> s_RAMREAD);

	EXT: signextender port map(
		i_DATA	=> i_IMMED,
		i_SIGN	=> i_SIGN,
		o_DATA	=> s_EXTEND);
end mixed;	
