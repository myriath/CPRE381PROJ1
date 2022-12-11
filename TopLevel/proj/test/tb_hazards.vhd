library IEEE;
use IEEE.std_logic_1164.all;

entity tb_controlhazards is
  generic(gCLK_HPER   : time := 50 ns);
end tb_controlhazards;

architecture behavior of tb_controlhazards is
  
  -- Calculate the clock period as twice the half-period
  constant cCLK_PER  : time := gCLK_HPER * 2;

  component controlhazards
    port(	clk	: in std_logic;
		rst	: in std_logic;
		opcode	: in std_logic_vector(5 downto 0);
		funct	: in std_logic_vector(5 downto 0);
		flush	: out std_logic;
		stall	: out std_logic);
  end component;

  -- Temporary signals to connect to the dff component.
  signal s_CLK, s_RST : std_logic;
  signal s_flush, s_stall	: std_logic;
  signal s_OP, s_FUNCT : std_logic_vector(5 downto 0);

begin

  DUT: controlhazards 
  port map(	clk	=> s_CLK,
		rst	=> s_RST,
		opcode	=> s_OP,
		funct	=> s_FUNCT,
		flush	=> s_flush,
		stall	=> s_stall);

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

-- BEQ
	s_OP		<= "000100";
	s_FUNCT		<= "000000";
	wait for cCLK_PER;

-- BNE
	s_OP		<= "000101";
	s_FUNCT		<= "000000";
	wait for cCLK_PER;

-- J
	s_OP		<= "000010";
	s_FUNCT		<= "000000";
	wait for cCLK_PER;

-- JAL
	s_OP		<= "000011";
	s_FUNCT		<= "000000";
	wait for cCLK_PER;

-- JR
	s_OP		<= "000000";
	s_FUNCT		<= "001000";
	wait for cCLK_PER * 5;

-- RESET
    s_RST <= '1';
    wait;
  end process;
  
end behavior;
