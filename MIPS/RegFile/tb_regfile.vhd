library IEEE;
use IEEE.std_logic_1164.all;

entity tb_regfile is
  generic(gCLK_HPER   : time := 50 ns);
end tb_regfile;

architecture behavior of tb_regfile is
  
  -- Calculate the clock period as twice the half-period
  constant cCLK_PER  : time := gCLK_HPER * 2;


  component regfile
    port(	i_CLK	: in std_logic;
		i_RST	: in std_logic;
		i_RADDR0	: in std_logic_vector(4 downto 0);
		i_RADDR1	: in std_logic_vector(4 downto 0);
		i_WADDR	: in std_logic_vector(4 downto 0);
		i_WEN	: in std_logic;
		i_WDATA	: in std_logic_vector(31 downto 0);
		o_RDATA0	: out std_logic_vector(31 downto 0);
		o_RDATA1	: out std_logic_vector(31 downto 0));
  end component;

  -- Temporary signals to connect to the dff component.
  signal s_CLK, s_RST, s_WE  : std_logic;
  signal s_WADDR : std_logic_vector(4 downto 0);
  signal s_RADDR0, s_RADDR1 : std_logic_vector(4 downto 0);
  signal s_WDATA : std_logic_vector(31 downto 0);
  signal s_RDATA0, s_RDATA1 : std_logic_vector(31 downto 0);

begin

  DUT: regfile 
  port map(	i_CLK	=> s_CLK,
		i_RST	=> s_RST,
		i_RADDR0	=> s_RADDR0,
		i_RADDR1	=> s_RADDR1,
		i_WADDR	=> s_WADDR,
		i_WEN	=> s_WE,
		i_WDATA	=> s_WDATA,
		o_RDATA0	=> s_RDATA0,
		o_RDATA1	=> s_RDATA1);

  -- This process sets the clock value (low for gCLK_HPER, then high
  -- for gCLK_HPER). Absent a "wait" command, processes restart 
  -- at the beginning once they have reached the final statement.
  P_CLK: process
  begin
    s_CLK <= '0';
    wait for gCLK_HPER;
    s_CLK <= '1';
    wait for gCLK_HPER;
  end process;
  
  -- Testbench process  
  P_TB: process
  begin
    s_RST <= '1';
    wait for gCLK_HPER / 2;
    s_RST <= '0';
-- ATTEMPT STORE IN $0
    s_WDATA <= x"fadd3186";
    s_WE <= '1';
    s_WADDR <= "00000";
    s_RADDR0 <= "00000";
    wait for cCLK_PER;
    
-- STORE FADD3186 -> 0a;
    s_WDATA <= x"fadd3186";
    s_WE <= '1';
    s_WADDR <= "01010";
    s_RADDR0 <= "00000";
    wait for cCLK_PER;
    
-- READ 0a
    s_WDATA <= x"00000000";
    s_WE <= '0';
    s_WADDR <= "00000";
    s_RADDR0 <= "01010";
    wait for cCLK_PER;

-- STORE "0123ABCD" -> 12 
    s_WDATA <= x"0123abcd";
    s_WE <= '1';
    s_WADDR <= "10010";
    s_RADDR0 <= "00000";
    wait for cCLK_PER; 

-- READ 0a (should be fadd3186)
    s_WDATA <= x"00000000";
    s_WE <= '0';
    s_WADDR <= "00000";
    s_RADDR0 <= "01010";
    wait for cCLK_PER; 

-- READ 12 (should be 0123abcd)
    s_WDATA <= x"00000000";
    s_WE <= '0';
    s_WADDR <= "00000";
    s_RADDR0 <= "10010";
    wait for cCLK_PER; 

-- RESET
    s_RST <= '1';
    wait;
  end process;
  
end behavior;
