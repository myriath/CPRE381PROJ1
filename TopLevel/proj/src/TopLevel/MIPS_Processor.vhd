-------------------------------------------------------------------------
-- Henry Duwe
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- MIPS_Processor.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a skeleton of a MIPS_Processor  
-- implementation.

-- 01/29/2019 by H3::Design created.
-------------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.all;

library work;
use work.MIPS_types.all;

entity MIPS_Processor is
  generic(N : integer := DATA_WIDTH);
  port(iCLK            : in std_logic;
       iRST            : in std_logic;
       iInstLd         : in std_logic;
       iInstAddr       : in std_logic_vector(N-1 downto 0);
       iInstExt        : in std_logic_vector(N-1 downto 0);
       oALUOut         : out std_logic_vector(N-1 downto 0)); -- TODO: Hook this up to the output of the ALU. It is important for synthesis that you have this output that can effectively be impacted by all other components so they are not optimized away.

end  MIPS_Processor;


architecture structure of MIPS_Processor is

  -- Required data memory signals
  signal s_DMemWr       : std_logic; -- TODO: use this signal as the final active high data memory write enable signal
  signal s_DMemAddr     : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the final data memory address input
  signal s_DMemData     : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the final data memory data input
  signal s_DMemOut      : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the data memory output
 
  -- Required register file signals 
  signal s_RegWr        : std_logic; -- TODO: use this signal as the final active high write enable input to the register file
  signal s_RegWrAddr    : std_logic_vector(4 downto 0); -- TODO: use this signal as the final destination register address input
  signal s_RegWrData    : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the final data memory data input

  -- Required instruction memory signals
  signal s_IMemAddr     : std_logic_vector(N-1 downto 0); -- Do not assign this signal, assign to s_NextInstAddr instead
  signal s_NextInstAddr : std_logic_vector(N-1 downto 0); -- TODO: use this signal as your intended final instruction memory address input.
  signal s_Inst         : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the instruction signal 

  -- Required halt signal -- for simulation
  signal s_Halt         : std_logic;  -- TODO: this signal indicates to the simulation that intended program execution has completed. (Opcode: 01 0100)

  -- Required overflow signal -- for overflow exception detection
  signal s_Ovfl         : std_logic;  -- TODO: this signal indicates an overflow exception would have been initiated

  component mem is
    generic(ADDR_WIDTH : integer;
            DATA_WIDTH : integer);
    port(
          clk          : in std_logic;
          addr         : in std_logic_vector((ADDR_WIDTH-1) downto 0);
          data         : in std_logic_vector((DATA_WIDTH-1) downto 0);
          we           : in std_logic := '1';
          q            : out std_logic_vector((DATA_WIDTH -1) downto 0));
    end component;

  -- TODO: You may add any additional signals or components your implementation 
  --       requires below this comment

  component pc is port(
	i_CLK		: in std_logic;
	i_RST		: in std_logic;
	i_PC		: in std_logic_vector(31 downto 0);
	i_INST		: in std_logic_vector(25 downto 0);
	i_REG31		: in std_logic_vector(31 downto 0);
	i_JR		: in std_logic;
	i_BRANCH	: in std_logic;
	i_JUMP		: in std_logic;
	i_IMMED		: in std_logic_vector(29 downto 0);
	o_PCP4		: out std_logic_vector(31 downto 0);
	o_NEXT		: out std_logic_vector(31 downto 0));
  end component;

  component ALU is generic(N : integer := 32); port(
	i_Contral	: in std_logic_vector(3 downto 0);
	i_A		: in std_logic_vector(N-1 downto 0);
	i_B		: in std_logic_vector(N-1 downto 0);
	o_Result	: out std_logic_vector(N-1 downto 0);
	o_Zero		: out std_logic;
	o_OverFlow	: out std_logic);
  end component;

  component control is port(
	i_INST		: in std_logic_vector(31 downto 0);
	i_ZERO		: in std_logic;
	i_OVFL		: in std_logic;
	RegDst		: out std_logic;
	Jump		: out std_logic;
	Branch		: out std_logic;
	Reg31		: out std_logic;
	MemRead		: out std_logic;
	MemtoReg	: out std_logic;
	ALUOp		: out std_logic_vector(3 downto 0);
	MemWrite	: out std_logic;
	ALUSrc		: out std_logic;
	RegWrite	: out std_logic;
	SignExtend	: out std_logic;
	Shift		: out std_logic;
	o_JR		: out std_logic;
	Overflow	: out std_logic;
	SLT		: out std_logic;
	MOVN		: out std_logic;
	REPL		: out std_logic;
	Halt		: out std_logic);
  end component;

  component regfile is port(
	i_CLK		: in std_logic;
	i_RST		: in std_logic;
	i_WEN		: in std_logic;
	i_WADDR		: in std_logic_vector(4 downto 0);
	i_WDATA		: in std_logic_vector(31 downto 0);
	i_RADDR0	: in std_logic_vector(4 downto 0);
	i_RADDR1	: in std_logic_vector(4 downto 0);
	o_RDATA0	: out std_logic_vector(31 downto 0);
	o_RDATA1	: out std_logic_vector(31 downto 0));
  end component;

  signal s_zero, s_Overflow, s_TRegWr		: std_logic;
  signal s_control	: std_logic_vector(16 downto 0);
  signal s_extend, s_regread0, s_alua, s_alub, s_alures, s_aluormem, s_pcplus4	: std_logic_vector(31 downto 0);

begin

  -- TODO: This is required to be your final input to your instruction memory. This provides a feasible method to externally load the memory module which means that the synthesis tool must assume it knows nothing about the values stored in the instruction memory. If this is not included, much, if not all of the design is optimized out because the synthesis tool will believe the memory to be all zeros.
  with iInstLd select
    s_IMemAddr <= s_NextInstAddr when '0',
      iInstAddr when others;

  IMem: mem
    generic map(ADDR_WIDTH => ADDR_WIDTH,
                DATA_WIDTH => N)
    port map(clk  => iCLK,
             addr => s_IMemAddr(11 downto 2),
             data => iInstExt,
             we   => iInstLd,
             q    => s_Inst);

  DMem: mem
    generic map(ADDR_WIDTH => ADDR_WIDTH,
                DATA_WIDTH => N)
    port map(clk  => iCLK,
             addr => s_DMemAddr(11 downto 2),
             data => s_DMemData,
             we   => s_DMemWr,
             q    => s_DMemOut);

  -- TODO: Ensure that s_Halt is connected to an output control signal produced from decoding the Halt instruction (Opcode: 01 0100)
  ControlUnit: control
	port map(	i_INST		=> s_Inst,
			i_ZERO		=> s_zero,
			i_OVFL		=> s_Overflow,
			RegDst		=> s_control(0),
			Jump		=> s_control(1),
			Branch		=> s_control(2),
			Reg31		=> s_control(3),
			MemRead		=> s_control(4),
			MemtoReg	=> s_control(5),
			ALUOp		=> s_control(9 downto 6),
			MemWrite	=> s_DMemWr,
			ALUSrc		=> s_control(10),
			RegWrite	=> s_TRegWr,
			SignExtend	=> s_control(11),
			Shift		=> s_control(12),
			o_JR		=> s_control(13),
			Overflow	=> s_Ovfl,
			SLT		=> s_control(14),
			MOVN		=> s_control(15),
			REPL		=> s_control(16),
			Halt		=> s_Halt);

  -- TODO: Ensure that s_Ovfl is connected to the overflow output of your ALU
  s_alua		<= s_regread0 when (s_control(12) = '0') else "000" & x"000000" & s_Inst(10 downto 6);
  MathUnit: ALU
	port map(	i_Contral	=> s_control(9 downto 6),
			i_A		=> s_alua,
			i_B		=> s_alub,
			o_Result	=> s_alures,
			o_Zero		=> s_zero,
			o_OverFlow	=> s_Overflow);
  s_DMemAddr		<= s_alures(N-1 downto 0);
  s_aluormem		<= s_DMemOut when (s_control(5) = '1') else s_alures;
  oALUOut		<= s_alures;

  -- TODO: Implement the rest of your processor below this comment! 

  s_RegWrData		<= x"00000001" when (s_control(14) = '1' and s_alures(31) = '1') else x"00000000" when (s_control(14) = '1' and s_alures(31) = '0') else s_regread0 when (s_control(15) = '1' and not (s_DMemData = x"00000000")) else s_aluormem when (s_control(3) = '0') else s_pcplus4;
  s_RegWrAddr		<= "11111" when (s_control(3) = '1') else s_Inst(20 downto 16) when (s_control(0) = '0') else s_Inst(15 downto 11);
  Registers: regfile
	port map(	i_CLK		=> iCLK,
			i_RST		=> iRST,
			i_WEN		=> s_RegWr,
			i_WADDR		=> s_RegWrAddr,
			i_WDATA		=> s_RegWrData,
			i_RADDR0	=> s_Inst(25 downto 21),
			i_RADDR1	=> s_Inst(20 downto 16),
			o_RDATA0	=> s_regread0,
			o_RDATA1	=> s_DMemData);

  s_RegWr		<= '0' when (s_control(15) = '1' and (s_DMemData = x"00000000")) else s_TRegWr;
  s_extend		<= x"ffff" & s_Inst(15 downto 0) when (s_Inst(15) = '1' and s_control(11) = '1') else
			   x"0000" & s_Inst(15 downto 0);
  s_alub		<= x"000000" & s_Inst(23 downto 16) when (s_control(16) = '1') else
			   s_DMemData when (s_control(10) = '0') else
			   s_extend;



  ProgramCounter: pc
	port map(	i_CLK		=> iCLK,
			i_RST		=> iRST,
			i_PC		=> s_IMemAddr,
			i_INST		=> s_Inst(25 downto 0),
			i_REG31		=> s_regread0,
			i_JR		=> s_control(13),
			i_BRANCH	=> s_control(2),
			i_JUMP		=> s_control(1),
			i_IMMED		=> s_extend(29 downto 0),
			o_PCP4		=> s_pcplus4,
			o_NEXT		=> s_NextInstAddr);

end structure;

