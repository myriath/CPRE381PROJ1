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
begin
	REGS: for i in 0 to 30 generate
	REGI: n_dff port map(
		clk	=> i_CLK,
		rst	=> i_RST,
		w_en	=> s_WRITELINES(i+1),
		d	=> i_WDATA,
		q	=> s_READLINES(i+1));
	end generate REGS;
	
	s_WRITELINES <=	x"00000000" when i_WEN = '0' else
			x"00000001" when i_WADDR = "00000" else
			x"00000002" when i_WADDR = "00001" else
			x"00000004" when i_WADDR = "00010" else
			x"00000008" when i_WADDR = "00011" else
			x"00000010" when i_WADDR = "00100" else
			x"00000020" when i_WADDR = "00101" else
			x"00000040" when i_WADDR = "00110" else
			x"00000080" when i_WADDR = "00111" else
			x"00000100" when i_WADDR = "01000" else
			x"00000200" when i_WADDR = "01001" else
			x"00000400" when i_WADDR = "01010" else
			x"00000800" when i_WADDR = "01011" else
			x"00001000" when i_WADDR = "01100" else
			x"00002000" when i_WADDR = "01101" else
			x"00004000" when i_WADDR = "01110" else
			x"00008000" when i_WADDR = "01111" else
			x"00010000" when i_WADDR = "10000" else
			x"00020000" when i_WADDR = "10001" else
			x"00040000" when i_WADDR = "10010" else
			x"00080000" when i_WADDR = "10011" else
			x"00100000" when i_WADDR = "10100" else
			x"00200000" when i_WADDR = "10101" else
			x"00400000" when i_WADDR = "10110" else
			x"00800000" when i_WADDR = "10111" else
			x"01000000" when i_WADDR = "11000" else
			x"02000000" when i_WADDR = "11001" else
			x"04000000" when i_WADDR = "11010" else
			x"08000000" when i_WADDR = "11011" else
			x"10000000" when i_WADDR = "11100" else
			x"20000000" when i_WADDR = "11101" else
			x"40000000" when i_WADDR = "11110" else
			x"80000000" when i_WADDR = "11111";
	
	o_RDATA0 <= 	i_WDATA when i_RADDR0 = i_WADDR and i_WEN = '1' else
			x"00000000" when i_RADDR0 = "00000" else
			s_READLINES(1) when i_RADDR0 = "00001" else
			s_READLINES(2) when i_RADDR0 = "00010" else
			s_READLINES(3) when i_RADDR0 = "00011" else
			s_READLINES(4) when i_RADDR0 = "00100" else
			s_READLINES(5) when i_RADDR0 = "00101" else
			s_READLINES(6) when i_RADDR0 = "00110" else
			s_READLINES(7) when i_RADDR0 = "00111" else
			s_READLINES(8) when i_RADDR0 = "01000" else
			s_READLINES(9) when i_RADDR0 = "01001" else
			s_READLINES(10) when i_RADDR0 = "01010" else
			s_READLINES(11) when i_RADDR0 = "01011" else
			s_READLINES(12) when i_RADDR0 = "01100" else
			s_READLINES(13) when i_RADDR0 = "01101" else
			s_READLINES(14) when i_RADDR0 = "01110" else
			s_READLINES(15) when i_RADDR0 = "01111" else
			s_READLINES(16) when i_RADDR0 = "10000" else
			s_READLINES(17) when i_RADDR0 = "10001" else
			s_READLINES(18) when i_RADDR0 = "10010" else
			s_READLINES(19) when i_RADDR0 = "10011" else
			s_READLINES(20) when i_RADDR0 = "10100" else
			s_READLINES(21) when i_RADDR0 = "10101" else
			s_READLINES(22) when i_RADDR0 = "10110" else
			s_READLINES(23) when i_RADDR0 = "10111" else
			s_READLINES(24) when i_RADDR0 = "11000" else
			s_READLINES(25) when i_RADDR0 = "11001" else
			s_READLINES(26) when i_RADDR0 = "11010" else
			s_READLINES(27) when i_RADDR0 = "11011" else
			s_READLINES(28) when i_RADDR0 = "11100" else
			s_READLINES(29) when i_RADDR0 = "11101" else
			s_READLINES(30) when i_RADDR0 = "11110" else
			s_READLINES(31) when i_RADDR0 = "11111";

	o_RDATA1 <= 	i_WDATA when i_RADDR1 = i_WADDR and i_WEN = '1' else
			x"00000000" when i_RADDR1 = "00000" else
			s_READLINES(1) when i_RADDR1 = "00001" else
			s_READLINES(2) when i_RADDR1 = "00010" else
			s_READLINES(3) when i_RADDR1 = "00011" else
			s_READLINES(4) when i_RADDR1 = "00100" else
			s_READLINES(5) when i_RADDR1 = "00101" else
			s_READLINES(6) when i_RADDR1 = "00110" else
			s_READLINES(7) when i_RADDR1 = "00111" else
			s_READLINES(8) when i_RADDR1 = "01000" else
			s_READLINES(9) when i_RADDR1 = "01001" else
			s_READLINES(10) when i_RADDR1 = "01010" else
			s_READLINES(11) when i_RADDR1 = "01011" else
			s_READLINES(12) when i_RADDR1 = "01100" else
			s_READLINES(13) when i_RADDR1 = "01101" else
			s_READLINES(14) when i_RADDR1 = "01110" else
			s_READLINES(15) when i_RADDR1 = "01111" else
			s_READLINES(16) when i_RADDR1 = "10000" else
			s_READLINES(17) when i_RADDR1 = "10001" else
			s_READLINES(18) when i_RADDR1 = "10010" else
			s_READLINES(19) when i_RADDR1 = "10011" else
			s_READLINES(20) when i_RADDR1 = "10100" else
			s_READLINES(21) when i_RADDR1 = "10101" else
			s_READLINES(22) when i_RADDR1 = "10110" else
			s_READLINES(23) when i_RADDR1 = "10111" else
			s_READLINES(24) when i_RADDR1 = "11000" else
			s_READLINES(25) when i_RADDR1 = "11001" else
			s_READLINES(26) when i_RADDR1 = "11010" else
			s_READLINES(27) when i_RADDR1 = "11011" else
			s_READLINES(28) when i_RADDR1 = "11100" else
			s_READLINES(29) when i_RADDR1 = "11101" else
			s_READLINES(30) when i_RADDR1 = "11110" else
			s_READLINES(31) when i_RADDR1 = "11111";

end mixed;	
