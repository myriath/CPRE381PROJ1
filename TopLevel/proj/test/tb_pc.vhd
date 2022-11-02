library IEEE;
use IEEE.std_logic_1164.all;

entity tb_pc is
  generic(gCLK_HPER   : time := 50 ns);
end tb_pc;

architecture behavior of tb_pc is
  
  -- Calculate the clock period as twice the half-period
  constant cCLK_PER  : time := gCLK_HPER * 2;


  component pc
    port(	i_CLK	: in std_logic;
		i_RST	: in std_logic;
		i_PC	: in std_logic_vector(31 downto 0);
		i_INST	: in std_logic_vector(25 downto 0);
		i_REG31	: in std_logic_vector(31 downto 0);
		i_JR	: in std_logic;
		i_BRANCH: in std_logic;
		i_JUMP	: in std_logic;
		i_IMMED	: in std_logic_vector(29 downto 0);
		o_PCP4	: out std_logic_vector(31 downto 0);
		o_NEXT	: out std_logic_vector(31 downto 0));
  end component;

  -- Temporary signals to connect to the dff component.
  signal s_CLK, s_RST, s_JUMP, s_BRANCH, s_JR : std_logic;
  signal s_PC, s_NEXT, s_REG31 : std_logic_vector(31 downto 0);
  signal s_INST : std_logic_vector(25 downto 0);
  signal s_IMMED : std_logic_vector(29 downto 0);

begin

  DUT: pc 
  port map(	i_CLK	=> s_CLK,
		i_RST	=> s_RST,
		i_PC	=> s_PC,
		i_INST	=> s_INST,
		i_REG31 => s_REG31,
		i_JR	=> s_JR,
		i_BRANCH	=> s_BRANCH,
		i_JUMP	=> s_JUMP,
		i_IMMED	=> s_IMMED,
		o_NEXT	=> s_NEXT);

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

-- NO JUMP, NO BRANCH PC=ffff00ab
	s_PC		<= x"ffff00ab";
	s_INST		<= "00" & x"000000";
	s_REG31		<= x"00000000";
	s_JR		<= '0';
	s_BRANCH	<= '0';
	s_JUMP		<= '0';
	s_IMMED		<= "00" & x"0000000";
	wait for cCLK_PER;

-- NO JUMP, NO BRANCH PC=1234abcf
	s_PC		<= x"1234abcf";
	s_INST		<= "00" & x"000000";
	s_REG31		<= x"00000000";
	s_JR		<= '0';
	s_BRANCH	<= '0';
	s_JUMP		<= '0';
	s_IMMED		<= "00" & x"0000000";
	wait for cCLK_PER;

-- JUMP, NO BRANCH PC=ffff00ab
	s_PC		<= x"ffff00ab";
	s_INST		<= "11" & x"123456";
	s_REG31		<= x"00000000";
	s_JR		<= '0';
	s_BRANCH	<= '0';
	s_JUMP		<= '1';
	s_IMMED		<= "00" & x"0000000";
	wait for cCLK_PER;

-- NO JUMP, BRANCH PC=ffff00ab
	s_PC		<= x"ffff00ab";
	s_INST		<= "00" & x"000000";
	s_REG31		<= x"00000000";
	s_JR		<= '0';
	s_BRANCH	<= '1';
	s_JUMP		<= '0';
	s_IMMED		<= "00" & x"abcdef1";
	wait for cCLK_PER;

-- JUMP, BRANCH PC=ffff00ab
	s_PC		<= x"ffff00ab";
	s_INST		<= "11" & x"123456";
	s_REG31		<= x"00000000";
	s_JR		<= '0';
	s_BRANCH	<= '1';
	s_JUMP		<= '1';
	s_IMMED		<= "00" & x"abcdef1";
	wait for cCLK_PER;

-- JR
	s_PC		<= x"ffff00ab";
	s_INST		<= "11" & x"123456";
	s_REG31		<= x"11112222";
	s_JR		<= '1';
	s_BRANCH	<= '0';
	s_JUMP		<= '0';
	s_IMMED		<= "00" & x"abcdef1";
	wait for cCLK_PER;

-- RESET
    s_RST <= '1';
    wait;
  end process;
  
end behavior;
