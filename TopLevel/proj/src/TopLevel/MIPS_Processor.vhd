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
use IEEE.numeric_std.all;

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

  component Foward is
	port(	i_A	: in std_logic_vector(4 downto 0);
		i_B	: in std_logic_vector(4 downto 0);
		i_MemD	: in std_logic_vector(4 downto 0);
		i_MemW	: in std_logic;
		i_WbD	: in std_logic_vector(4 downto 0);
		i_WbW	: in std_logic;
		o_A	: out std_logic_vector(1 downto 0);
		o_B	: out std_logic_vector(1 downto 0));
  end component;

  component controlhazards is port(
	clk		: in std_logic;
	rst		: in std_logic;
	opcode		: in std_logic_vector(5 downto 0);
	funct		: in std_logic_vector(5 downto 0);
	flush		: out std_logic);
  end component;

  component dffgSpecial is port(
	i_CLK		: in std_logic;
	i_RST		: in std_logic;
	i_WE		: in std_logic;
	i_D		: in std_logic_vector(31 downto 0);
	o_Q		: out std_logic_vector(31 downto 0));
  end component;

  component n_dff is generic(N : integer := 32); port(
	clk		: in std_logic;
	rst		: in std_logic;
	w_en		: in std_logic;
	d		: in std_logic_vector(N-1 downto 0);
	q		: out std_logic_vector(N-1 downto 0));
  end component;

  component flush_reg is generic(N : integer := 32); port(
	clk		: in std_logic;
	rst		: in std_logic;
	w_en		: in std_logic;
	stall		: in std_logic;
	flush		: in std_logic;
	d		: in std_logic_vector(N-1 downto 0);
	q		: out std_logic_vector(N-1 downto 0));
  end component;

  component ALU is generic(N : integer := 32); port(
	i_Contral	: in std_logic_vector(3 downto 0);
	i_A		: in std_logic_vector(N-1 downto 0);
	i_B		: in std_logic_vector(N-1 downto 0);
	o_Z		: out std_logic;
	o_Result	: out std_logic_vector(N-1 downto 0);
	o_OverFlow	: out std_logic);
  end component;

  component control is port(
	i_INST		: in std_logic_vector(31 downto 0);
	i_OVFL		: in std_logic;
	RegDst		: out std_logic;
	Jump		: out std_logic;
	BranchP		: out std_logic;
	BranchN		: out std_logic;
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

  component dffg is port(
	i_CLK		: in std_logic;
	i_RST		: in std_logic;
	i_WE		: in std_logic;
	i_D		: in std_logic;
	o_Q		: out std_logic);
  end component;

  signal s_equal, s_zero	: std_logic;
  signal s_Overflow		: std_logic;
  signal s_control, s_C2, s_C3, s_C4	: std_logic_vector(20 downto 0);
  signal s_extend, s_EXTEND2, s_regread0, s_regread1, s_alua, s_alub, s_aluat, s_alubt, s_alures, s_aluresultdirect, s_aluormem, s_ALUORMEM2, s_INST2, s_INST3, s_INST4, s_INST5, s_REGA2, s_REGA3, s_REGA4, s_REGB2, s_ALUOUT, s_ALUOUT2, s_DMEMIN, s_DMEMIN2, s_DMEMOUT2	: std_logic_vector(31 downto 0);

  -- PC
  signal s_pcint, s_pcint2, s_bImmed	: integer;
  signal s_BRANCH2, s_pcplus4, s_PCP40, s_PCP43, s_PCP42, s_PCP41, s_pcNext, s_jAddr, s_bAddr	: std_logic_vector(31 downto 0);

  signal s_flush, s_flush1, s_flush2, s_branching		: std_logic;
  signal s_SHAMT2, s_EX_dest, s_DEST2, s_DEST3		: std_logic_vector(4 downto 0);
  signal s_FowardA, s_FowardB	: std_logic_vector(1 downto 0);
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
	port map(	i_INST		=> s_INST2,
			i_OVFL		=> s_Overflow,
			RegDst		=> s_control(0),
			Jump		=> s_control(1),
			BranchP		=> s_control(2),
			BranchN		=> s_control(20),
			Reg31		=> s_control(3),
			MemRead		=> s_control(4),
			MemtoReg	=> s_control(5),
			ALUOp		=> s_control(9 downto 6),
			MemWrite	=> s_control(17),
			ALUSrc		=> s_control(10),
			RegWrite	=> s_control(18),
			SignExtend	=> s_control(11),
			Shift		=> s_control(12),
			o_JR		=> s_control(13),
			Overflow	=> s_Ovfl,
			SLT		=> s_control(14),
			MOVN		=> s_control(15),
			REPL		=> s_control(16),
			Halt		=> s_control(19));
-- TODO: Implementing fowarding 

  s_EX_dest	<= "11111" when (s_C2(3) = '1') else
		   s_INST3(20 downto 16) when (s_C2(0) = '0') else
		   s_INST3(15 downto 11);
	
 Fowarding: Foward
	port map(	i_A	=> s_INST3(25 downto 21),
			i_B	=> s_INST3(20 downto 16),
			i_MemD	=> s_DEST2,
			i_MemW	=> s_C3(18),
			i_WbD	=> s_DEST3,
			i_WbW	=> s_C4(18),
			o_A	=> s_FowardA,
			o_B	=> s_FowardB);

 ControlHazard: controlhazards
	port map(	clk	=> iCLK,
			rst	=> iRST,
			opcode	=> s_INST2(31 downto 26),
			funct	=> s_INST2(5 downto 0),
			flush	=> s_flush);
  s_flush1	<= '1' when s_flush = '1' or s_flush2 = '1' else '0';
  s_flush2	<= '1' when s_branching = '1' else '0';

  -- TODO: Ensure that s_Ovfl is connected to the overflow output of your ALU
  s_alua		<= s_aluat when (s_C2(12) = '0') else "000" & x"000000" & s_SHAMT2;
	s_aluat <= s_REGA2 when(s_FowardA = "00")else s_aluormem when(s_FowardA = "01") else s_RegWrData;

	s_alubt <= s_REGB2 when(s_FowardB = "00") else s_aluormem  when(s_FowardB = "01") else s_RegWrData;

  MathUnit: ALU
	port map(	i_Contral	=> s_C2(9 downto 6),
			i_A		=> s_alua,
			i_B		=> s_alub,
			o_Z		=> s_zero,
			o_Result	=> s_aluresultdirect,
			o_OverFlow	=> s_Overflow);
  s_DMemAddr		<= s_ALUOUT(N-1 downto 0);
  s_aluormem		<= s_DMemOut when (s_C3(5) = '1') else s_ALUOUT;
  oALUOut		<= s_aluresultdirect;

  -- TODO: Implement the rest of your processor below this comment! 

  s_alures		<= x"00000001" when s_C2(14) = '1' and s_aluresultdirect(31) = '1' else
			   x"00000000" when s_C2(14) = '1' and s_aluresultdirect(31) = '0' else
			   s_REGA4 when s_C2(15) = '1' and not (s_DMEMIN2 = x"00000000") else
			   s_aluresultdirect when s_C2(3) = '0' else
			   s_PCP41;

  s_RegWrData		<= s_ALUORMEM2;

  s_RegWrAddr		<= s_DEST3;

  Registers: regfile
	port map(	i_CLK		=> iCLK,
			i_RST		=> iRST,
			i_WEN		=> s_RegWr,
			i_WADDR		=> s_RegWrAddr,
			i_WDATA		=> s_RegWrData,
			i_RADDR0	=> s_INST2(25 downto 21),
			i_RADDR1	=> s_INST2(20 downto 16),
			o_RDATA0	=> s_regread0,
			o_RDATA1	=> s_regread1);

  s_extend		<= x"ffff" & s_INST2(15 downto 0) when (s_INST2(15) = '1' and s_control(11) = '1') else
			   x"0000" & s_INST2(15 downto 0);
  s_alub		<= x"000000" & s_INST3(23 downto 16) when (s_C2(16) = '1') else
			   s_alubt when (s_C2(10) = '0') else
			   s_EXTEND2;

  s_pcint		<= to_integer(unsigned(s_IMemAddr) + 4);
  s_pcint2		<= to_integer(unsigned(s_PCP40));
  s_bImmed		<= to_integer(unsigned(s_extend(29 downto 0) & "00"));
  s_pcplus4		<= std_logic_vector(to_signed(s_pcint, 32));
  s_jAddr		<= s_PCP40(31 downto 28) & s_INST2(25 downto 0) & "00";
  s_bAddr		<= std_logic_vector(to_signed(s_pcint2 + s_bImmed, 32));
  s_equal		<= '1' when s_regread0 = s_regread1 else '0';

  s_pcNext		<= s_BRANCH2  when (s_branching = '1') else
			   s_regread0 when (s_control(13) = '1') else
			   s_jAddr    when (s_control(1)  = '1') else
			   s_pcplus4;

  s_branching		<= '1' when (s_C2(2) = '1' and s_zero = '1') or (s_C2(20) = '1' and s_zero = '0') else '0';

  PCP40: flush_reg
	generic map(	N		=> 32)
	port map(	clk		=> iCLK,
			rst		=> iRST,
			w_en		=> '1',
			stall		=> '0',
			flush		=> s_flush1,
			d		=> s_pcplus4,
			q		=> s_PCP40);

  PCP41: flush_reg
	generic map(	N		=> 32)
	port map(	clk		=> iCLK,
			rst		=> iRST,
			w_en		=> '1',
			stall		=> '0',
			flush		=> s_flush2,
			d		=> s_PCP40,
			q		=> s_PCP41);

  PCP42: n_dff
	generic map(	N		=> 32)
	port map(	clk		=> iCLK,
			rst		=> iRST,
			w_en		=> '1',
			d		=> s_PCP41,
			q		=> s_PCP42);

  PCP43: n_dff
	generic map(	N		=> 32)
	port map(	clk		=> iCLK,
			rst		=> iRST,
			w_en		=> '1',
			d		=> s_PCP42,
			q		=> s_PCP43);

  BRANCH2: n_dff
	generic map(	N		=> 32)
	port map(	clk		=> iCLK,
			rst		=> iRST,
			w_en		=> '1',
			d		=> s_bAddr,
			q		=> s_BRANCH2);

------ PIPELINING CONTROL BITS ------
  PC: dffgSpecial
	port map(	i_CLK		=> iCLK,
			i_RST		=> iRST,
			i_WE		=> '1',
			i_D		=> s_pcNext,
			o_Q		=> s_NextInstAddr);

------ PIPELINING CONTROL BITS ------
  C2: flush_reg
	generic map(	N		=> s_control'length)
	port map(	clk		=> iCLK,
			rst		=> iRST,
			w_en		=> '1',
			stall		=> '0',
			flush		=> s_flush2,
			d		=> s_control,
			q		=> s_C2);

  C3: n_dff
	generic map(	N		=> s_control'length)
	port map(	clk		=> iCLK,
			rst		=> iRST,
			w_en		=> '1',
			d		=> s_C2,
			q		=> s_C3);

  C4: n_dff
	generic map(	N		=> s_control'length)
	port map(	clk		=> iCLK,
			rst		=> iRST,
			w_en		=> '1',
			d		=> s_C3,
			q		=> s_C4);

  INST2: flush_reg
	generic map(	N		=> 32)
	port map(	clk		=> iCLK,
			rst		=> iRST,
			w_en		=> '1',
			stall		=> '0',
			flush		=> s_flush1,
			d		=> s_Inst,
			q		=> s_INST2);

  INST3: flush_reg
	generic map(	N		=> 32)
	port map(	clk		=> iCLK,
			rst		=> iRST,
			w_en		=> '1',
			stall		=> '0',
			flush		=> s_flush2,
			d		=> s_INST2,
			q		=> s_INST3);

  INST4: n_dff
	generic map(	N		=> 32)
	port map(	clk		=> iCLK,
			rst		=> iRST,
			w_en		=> '1',
			d		=> s_INST3,
			q		=> s_INST4);

  INST5: n_dff
	generic map(	N		=> 32)
	port map(	clk		=> iCLK,
			rst		=> iRST,
			w_en		=> '1',
			d		=> s_INST4,
			q		=> s_INST5);

  DEST2: n_dff
	generic map(	N		=> 5)
	port map(	clk		=> iCLK,
			rst		=> iRST,
			w_en		=> '1',
			d		=> s_EX_dest,
			q		=> s_DEST2);

  DEST3: n_dff
	generic map(	N		=> 5)
	port map(	clk		=> iCLK,
			rst		=> iRST,
			w_en		=> '1',
			d		=> s_DEST2,
			q		=> s_DEST3);

  REGA2: flush_reg
	generic map(	N		=> 32)
	port map(	clk		=> iCLK,
			rst		=> iRST,
			w_en		=> '1',
			stall		=> '0',
			flush		=> s_flush2,
			d		=> s_regread0,
			q		=> s_REGA2);

  REGA3: n_dff
	generic map(	N		=> 32)
	port map(	clk		=> iCLK,
			rst		=> iRST,
			w_en		=> '1',
			d		=> s_REGA2,
			q		=> s_REGA3);

  REGA4: n_dff
	generic map(	N		=> 32)
	port map(	clk		=> iCLK,
			rst		=> iRST,
			w_en		=> '1',
			d		=> s_REGA3,
			q		=> s_REGA4);

  REGB2: flush_reg
	generic map(	N		=> 32)
	port map(	clk		=> iCLK,
			rst		=> iRST,
			w_en		=> '1',
			stall		=> '0',
			flush		=> s_flush2,
			d		=> s_regread1,
			q		=> s_REGB2);

  EXTEND2: flush_reg
	generic map(	N		=> 32)
	port map(	clk		=> iCLK,
			rst		=> iRST,
			w_en		=> '1',
			stall		=> '0',
			flush		=> s_flush2,
			d		=> s_extend,
			q		=> s_EXTEND2);

  SHAMT2: flush_reg
	generic map(	N		=> 5)
	port map(	clk		=> iCLK,
			rst		=> iRST,
			w_en		=> '1',
			stall		=> '0',
			flush		=> s_flush2,
			d		=> s_INST2(10 downto 6),
			q		=> s_SHAMT2);

  ALUOUT: n_dff
	generic map(	N		=> 32)
	port map(	clk		=> iCLK,
			rst		=> iRST,
			w_en		=> '1',
			d		=> s_alures,
			q		=> s_ALUOUT);

  ALUOUT2: n_dff
	generic map(	N		=> 32)
	port map(	clk		=> iCLK,
			rst		=> iRST,
			w_en		=> '1',
			d		=> s_ALUOUT,
			q		=> s_ALUOUT2);

  ALUORMEM2: n_dff
	generic map(	N		=> 32)
	port map(	clk		=> iCLK,
			rst		=> iRST,
			w_en		=> '1',
			d		=> s_aluormem,
			q		=> s_ALUORMEM2);

  DMEMIN: n_dff
	generic map(	N		=> 32)
	port map(	clk		=> iCLK,
			rst		=> iRST,
			w_en		=> '1',
			d		=> s_alubt,
			q		=> s_DMEMIN);

  DMEMIN2: n_dff
	generic map(	N		=> 32)
	port map(	clk		=> iCLK,
			rst		=> iRST,
			w_en		=> '1',
			d		=> s_DMEMIN,
			q		=> s_DMEMIN2);

  DMEMOUT: n_dff
	generic map(	N		=> 32)
	port map(	clk		=> iCLK,
			rst		=> iRST,
			w_en		=> '1',
			d		=> s_DMemOut,
			q		=> s_DMEMOUT2);

  s_DMemData <= s_DMEMIN;
  s_DMemWr <=	s_C3(17);
  s_RegWr  <= 	'0' when (s_C4(15) = '1' and (s_ALUOUT2 = x"00000000")) else 
		s_C4(18);
  s_Halt   <= 	s_C4(19);

end structure;

