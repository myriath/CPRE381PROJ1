library IEEE;
use IEEE.std_logic_1164.all;

entity tb_control is
  generic(gCLK_HPER   : time := 50 ns);
end tb_control;

architecture behavior of tb_control is
  
  -- Calculate the clock period as twice the half-period
  constant cCLK_PER  : time := gCLK_HPER * 2;


  component control
    port(	i_OP	: in std_logic_vector(5 downto 0);
		i_FUNCT	: in std_logic_vector(5 downto 0);
		i_ZERO	: in std_logic;
		RegDst	: out std_logic;
		Jump	: out std_logic;
		Branch	: out std_logic;
		Reg31	: out std_logic;
		MemRead	: out std_logic;
		MemtoReg: out std_logic;
		ALUOp	: out std_logic_vector(3 downto 0);
		MemWrite: out std_logic;
		ALUSrc	: out std_logic;
		RegWrite: out std_logic;
		SignExtend: out std_logic;
		Shift	: out std_logic;
		Halt	: out std_logic);
  end component;

  -- Temporary signals to connect to the dff component.
  signal s_CLK, s_RST : std_logic;
  signal s_Halt, s_SignExtend, s_Shift, s_ZERO, s_RegDst, s_Jump, s_Branch, s_Reg31, s_MemRead, s_MemtoReg, s_MemWrite, s_ALUSrc, s_RegWrite : std_logic;
  signal s_OP, s_FUNCT : std_logic_vector(5 downto 0);
  signal s_ALUOp : std_logic_vector(3 downto 0);

begin

  DUT: control 
  port map(	i_OP	=> s_OP,
		i_FUNCT	=> s_FUNCT,
		i_ZERO	=> s_ZERO,
		RegDst	=> s_RegDst,
		Jump	=> s_Jump,
		Branch	=> s_Branch,
		Reg31	=> s_Reg31,
		MemRead	=> s_MemRead,
		MemtoReg=> s_MemtoReg,
		ALUOp	=> s_ALUOp,
		MemWrite=> s_MemWrite,
		ALUSrc	=> s_ALUSrc,
		RegWrite=> s_RegWrite,
		SignExtend=>s_SignExtend,
		Shift	=> s_Shift,
		Halt	=> s_Halt);

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

-- add
	s_OP		<= "000000";
	s_FUNCT		<= "100000";
	s_ZERO		<= '0';
	wait for cCLK_PER;

-- addi
	s_OP		<= "001000";
	s_FUNCT		<= "000000";
	wait for cCLK_PER;
    
-- addiu
	s_OP		<= "001001";
	s_FUNCT		<= "000000";
	wait for cCLK_PER;
    
-- addu
	s_OP		<= "000000";
	s_FUNCT		<= "100001";
	wait for cCLK_PER;
    
-- and
	s_OP		<= "000000";
	s_FUNCT		<= "100100";
	wait for cCLK_PER;
    
-- andi
	s_OP		<= "001100";
	s_FUNCT		<= "000000";
	wait for cCLK_PER;
    
-- lui
	s_OP		<= "001111";
	s_FUNCT		<= "000000";
	wait for cCLK_PER;
    
-- lw
	s_OP		<= "100011";
	s_FUNCT		<= "000000";
	wait for cCLK_PER;
    
-- nor
	s_OP		<= "000000";
	s_FUNCT		<= "100111";
	wait for cCLK_PER;
    
-- xor
	s_OP		<= "000000";
	s_FUNCT		<= "100110";
	wait for cCLK_PER;
    
-- xori
	s_OP		<= "001110";
	s_FUNCT		<= "000000";
	wait for cCLK_PER;
    
-- or
	s_OP		<= "000000";
	s_FUNCT		<= "100101";
	wait for cCLK_PER;
    
-- ori
	s_OP		<= "001101";
	s_FUNCT		<= "000000";
	wait for cCLK_PER;
    
-- slt
	s_OP		<= "000000";
	s_FUNCT		<= "101010";
	wait for cCLK_PER;
    
-- slti
	s_OP		<= "001010";
	s_FUNCT		<= "000000";
	wait for cCLK_PER;
    
-- sll
	s_OP		<= "000000";
	s_FUNCT		<= "000000";
	wait for cCLK_PER;
    
-- srl
	s_OP		<= "000000";
	s_FUNCT		<= "000010";
	wait for cCLK_PER;
    
-- sra
	s_OP		<= "000000";
	s_FUNCT		<= "000011";
	wait for cCLK_PER;
    
-- sw
	s_OP		<= "101011";
	s_FUNCT		<= "000000";
	wait for cCLK_PER;
    
-- sub
	s_OP		<= "000000";
	s_FUNCT		<= "100010";
	wait for cCLK_PER;
    
-- beq
	s_OP		<= "000100";
	s_FUNCT		<= "000000";
	s_ZERO		<= '0';
	wait for cCLK_PER;
    
-- bne
	s_OP		<= "000101";
	s_FUNCT		<= "000000";
	s_ZERO		<= '0';
	wait for cCLK_PER;
    
-- beq
	s_OP		<= "000100";
	s_FUNCT		<= "000000";
	s_ZERO		<= '1';
	wait for cCLK_PER;
    
-- bne
	s_OP		<= "000101";
	s_FUNCT		<= "000000";
	s_ZERO		<= '1';
	wait for cCLK_PER;
    
-- j
	s_OP		<= "000010";
	s_FUNCT		<= "000000";
	s_ZERO		<= '0';
	wait for cCLK_PER;
    
-- jal
	s_OP		<= "000011";
	s_FUNCT		<= "000000";
	wait for cCLK_PER;
    
-- jr
	s_OP		<= "000000";
	s_FUNCT		<= "001000";
	wait for cCLK_PER;
    
-- repl.qb
	s_OP		<= "011111";
	s_FUNCT		<= "010010";
	wait for cCLK_PER;
    
-- movn
	s_OP		<= "000000";
	s_FUNCT		<= "001011";
	wait for cCLK_PER;
    
-- halt
	s_OP		<= "010100";
	s_FUNCT		<= "000000";
	wait for cCLK_PER;

-- RESET
    s_RST <= '1';
    wait;
  end process;
  
end behavior;
