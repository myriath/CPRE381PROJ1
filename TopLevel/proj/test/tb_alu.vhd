library IEEE;
use IEEE.std_logic_1164.all;

entity tb_alu is
  generic(gCLK_HPER   : time := 50 ns);
end tb_alu;

architecture behavior of tb_alu is
  
  -- Calculate the clock period as twice the half-period
  constant cCLK_PER  : time := gCLK_HPER * 2;


  component ALU
    generic(	N		: integer := 32);
    port(	i_Contral	: in std_logic_vector(3 downto 0);
		i_A		: in std_logic_vector(N-1 downto 0);
		i_B		: in std_logic_vector(N-1 downto 0);
		o_Result	: out std_logic_vector(N-1 downto 0);
		o_Zero		: out std_logic;
		o_OverFlow	: out std_logic);
  end component;

  -- Temporary signals to connect to the dff component.
  signal s_CLK, s_RST : std_logic;
  signal s_Zero, s_OverFlow : std_logic;
  signal s_A, s_B, s_Result : std_logic_vector(31 downto 0);
  signal s_ALUOp : std_logic_vector(3 downto 0);

begin

  DUT: ALU 
  port map(	i_Contral	=> s_ALUOp,
		i_A		=> s_A,
		i_B		=> s_B,
		o_Result	=> s_Result,
		o_Zero		=> s_Zero,
		o_OverFlow	=> s_OverFlow);

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

-- and
	s_ALUOp		<= x"0";
	s_A		<= x"12345678";
	s_B		<= x"abcdef12";
	wait for cCLK_PER;

-- or
	s_ALUOp		<= x"1";
	s_A		<= x"12345678";
	s_B		<= x"abcdef12";
	wait for cCLK_PER;

-- xor
	s_ALUOp		<= x"2";
	s_A		<= x"12345678";
	s_B		<= x"90abcdef";
	s_B		<= x"abcdef12";
	wait for cCLK_PER;

-- add
	s_ALUOp		<= x"3";
	s_A		<= x"12345678";
	s_B		<= x"abcdef12";
	wait for cCLK_PER;

-- sub
	s_ALUOp		<= x"4";
	s_A		<= x"12345678";
	s_B		<= x"abcdef12";
	wait for cCLK_PER;

-- sll
	s_ALUOp		<= x"5";
	s_A		<= x"12345678";
	s_B		<= x"abcdef12";
	wait for cCLK_PER;

-- srl
	s_ALUOp		<= x"6";
	s_A		<= x"12345678";
	s_B		<= x"abcdef12";
	wait for cCLK_PER;

-- sra
	s_ALUOp		<= x"7";
	s_A		<= x"12345678";
	s_B		<= x"abcdef12";
	wait for cCLK_PER;

-- sra (pad w 1)
	s_ALUOp		<= x"7";
	s_A		<= x"12345688";
	s_B		<= x"abcdef12";
	wait for cCLK_PER;

-- repl.qb
	s_ALUOp		<= x"8";
	s_A		<= x"12345678";
	s_B		<= x"abcdef12";
	wait for cCLK_PER;

-- nor
	s_ALUOp		<= x"9";
	s_A		<= x"12345678";
	s_B		<= x"abcdef12";
	wait for cCLK_PER;

-- lui
	s_ALUOp		<= x"a";
	s_A		<= x"12345678";
	s_B		<= x"abcdef12";
	wait for cCLK_PER;

-- 
	s_ALUOp		<= x"b";
	s_A		<= x"00000000";
	s_B		<= x"00000000";
	wait for cCLK_PER;

-- 
	s_ALUOp		<= x"c";
	s_A		<= x"00000000";
	s_B		<= x"00000000";
	wait for cCLK_PER;

-- 
	s_ALUOp		<= x"d";
	s_A		<= x"00000000";
	s_B		<= x"00000000";
	wait for cCLK_PER;

-- 
	s_ALUOp		<= x"e";
	s_A		<= x"00000000";
	s_B		<= x"00000000";
	wait for cCLK_PER;

-- 
	s_ALUOp		<= x"f";
	s_A		<= x"00000000";
	s_B		<= x"00000000";
	wait for cCLK_PER;

-- RESET
    s_RST <= '1';
    wait;
  end process;
  
end behavior;

