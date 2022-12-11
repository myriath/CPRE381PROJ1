library IEEE;
use IEEE.std_logic_1164.all;

entity tb_flushreg4 is
  generic(gCLK_HPER   : time := 50 ns);
end tb_flushreg4;

architecture behavior of tb_flushreg4 is
  
  -- Calculate the clock period as twice the half-period
  constant cCLK_PER  : time := gCLK_HPER * 2;

  component flush_reg_seq is
    generic(	N	: integer := 32);
    port(	clk	: in std_logic;
		rst	: in std_logic;
		w_en	: in std_logic;
		flush	: in std_logic_vector(3 downto 0);
		stall	: in std_logic_vector(3 downto 0);
		d	: in std_logic_vector(N-1 downto 0);
		q	: out std_logic_vector(N-1 downto 0));
  end component;

  -- Temporary signals to connect to the dff component.
  signal s_CLK, s_RST : std_logic;
  signal s_flush, s_stall	: std_logic_vector(3 downto 0);
  signal s_en	: std_logic;
  signal s_d, s_q	: std_logic_vector(31 downto 0);

begin

  DUT: flush_reg_seq
  port map(	clk	=> s_CLK,
		rst	=> s_RST,
		w_en	=> s_en,
		flush	=> s_flush,
		stall	=> s_stall,
		d	=> s_d,
		q	=> s_q);

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

-- 
	s_d	<= x"0000ffff";
	s_en	<= '1';
	s_stall	<= x"0";
	s_flush	<= x"0";
	wait for cCLK_PER;

-- 
	s_d	<= x"00000000";
	s_en	<= '1';
	s_stall	<= x"1";
	s_flush	<= x"0";
	wait for cCLK_PER;

-- 
	s_d	<= x"00000000";
	s_en	<= '1';
	s_stall	<= x"0";
	s_flush	<= x"0";
	wait for cCLK_PER;

-- 
	s_d	<= x"0000ffff";
	s_en	<= '1';
	s_stall	<= x"0";
	s_flush	<= x"0";
	wait for cCLK_PER;

-- 
	s_d	<= x"ffff0000";
	s_en	<= '1';
	s_stall	<= x"2";
	s_flush	<= x"0";
	wait for cCLK_PER;

-- 
	s_d	<= x"ffffffff";
	s_en	<= '1';
	s_stall	<= x"0";
	s_flush	<= x"1";
	wait for cCLK_PER;

-- 
	s_d	<= x"ffff0000";
	s_en	<= '1';
	s_stall	<= x"3";
	s_flush	<= x"4";
	wait for cCLK_PER;

-- 
	s_d	<= x"0000ffff";
	s_en	<= '0';
	s_stall	<= x"0";
	s_flush	<= x"0";
	wait for cCLK_PER;

-- RESET
    s_RST <= '1';
    wait;
  end process;
  
end behavior;
