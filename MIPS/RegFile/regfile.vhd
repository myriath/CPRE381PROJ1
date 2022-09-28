library IEEE;
use IEEE.std_logic_1164.all;
use work.muxpkg.all;

entity regfile is
	port(	i_CLK	: in std_logic;
		i_RST	: in std_logic;	
		i_RADDR0	: in std_logic_vector(4 downto 0);
		i_RADDR1	: in std_logic_vector(4 downto 0);
		i_WADDR	: in std_logic_vector(4 downto 0);
		i_WEN	: in std_logic;
		i_WDATA : in std_logic_vector(31 downto 0);
		o_RDATA0	: out std_logic_vector(31 downto 0);
		o_RDATA1	: out std_logic_vector(31 downto 0));
end regfile;

architecture mixed of regfile is
	signal s_READLINES	: muxarray := (others => x"00000000");
	signal s_WRITELINES	: std_logic_vector(31 downto 0);
	component n_dff is 
		generic(N: integer := 32);
		port(
		clk	: in std_logic;
		rst	: in std_logic;
		w_en	: in std_logic;
		d	: in std_logic_vector(N-1 downto 0);
		q	: out std_logic_vector(N-1 downto 0));
	end component;
	component decoder5x32 is port(
		i_SEL	: in std_logic_vector(4 downto 0);
		i_D	: in std_logic;
		o_O	: out std_logic_vector(31 downto 0));
	end component;
	component mux32t1 is port(
		i_SEL	: in std_logic_vector(4 downto 0);
		i_D	: in muxarray;
		o_O	: out std_logic_vector(31 downto 0));
	end component;
begin
	REGS: for i in 0 to 30 generate
	REGI: n_dff port map(
		clk	=> i_CLK,
		rst	=> i_RST,
		w_en	=> s_WRITELINES(i+1),
		d	=> i_WDATA,
		q	=> s_READLINES(i+1));
	end generate REGS;
	
	DECODER: decoder5x32 port map(
		i_SEL	=> i_WADDR,
		i_D	=> i_WEN,
		o_O	=> s_WRITELINES);	
	
	MUX0: mux32t1 port map(
		i_SEL	=> i_RADDR0,
		i_D	=> s_READLINES,
		o_O	=> o_RDATA0);
	
	MUX1: mux32t1 port map(
		i_SEL	=> i_RADDR1,
		i_D	=> s_READLINES,
		o_O	=> o_RDATA1);

	--o_RDATA <= 	x"00000000" when i_RADDR = "00000" else
	--		s_READLINES(0) when i_RADDR = "00001" else
	--		s_READLINES(1) when i_RADDR = "00010" else
	--		s_READLINES(2) when i_RADDR = "00011" else
	--		s_READLINES(3) when i_RADDR = "00100" else
	--		s_READLINES(4) when i_RADDR = "00101" else
	--		s_READLINES(5) when i_RADDR = "00110" else
	--		s_READLINES(6) when i_RADDR = "00111" else
	--		s_READLINES(7) when i_RADDR = "01000" else
	--		s_READLINES(8) when i_RADDR = "01001" else
	--		s_READLINES(9) when i_RADDR = "01010" else
	--		s_READLINES(10) when i_RADDR = "01011" else
	--		s_READLINES(11) when i_RADDR = "01100" else
	--		s_READLINES(12) when i_RADDR = "01101" else
	--		s_READLINES(13) when i_RADDR = "01110" else
	--		s_READLINES(14) when i_RADDR = "01111" else
	--		s_READLINES(15) when i_RADDR = "10000" else
	--		s_READLINES(16) when i_RADDR = "10001" else
	--		s_READLINES(17) when i_RADDR = "10010" else
	--		s_READLINES(18) when i_RADDR = "10011" else
	--		s_READLINES(19) when i_RADDR = "10100" else
	--		s_READLINES(20) when i_RADDR = "10101" else
	--		s_READLINES(21) when i_RADDR = "10110" else
	--		s_READLINES(22) when i_RADDR = "10111" else
	--		s_READLINES(23) when i_RADDR = "11000" else
	--		s_READLINES(24) when i_RADDR = "11001" else
	--		s_READLINES(25) when i_RADDR = "11010" else
	--		s_READLINES(26) when i_RADDR = "11011" else
	--		s_READLINES(27) when i_RADDR = "11100" else
	--		s_READLINES(28) when i_RADDR = "11101" else
	--		s_READLINES(29) when i_RADDR = "11110" else
	--		s_READLINES(30) when i_RADDR = "11111";
end mixed;	
