library IEEE;
use IEEE.std_logic_1164.all;

entity control is 
	port(	i_OP	: in std_logic_vector(5 downto 0);
		i_FUNCT	: in std_logic_vector(5 downto 0);
		i_ZERO	: in std_logic;
		i_OVFL	: in std_logic;
		RegDst	: out std_logic;
		Jump	: out std_logic;
		Branch	: out std_logic;
		Reg31	: out std_logic;
		MemRead	: out std_logic;	
		MemtoReg	: out std_logic;	
		ALUOp	: out std_logic_vector(3 downto 0);
		MemWrite	: out std_logic;	
		ALUSrc	: out std_logic;
		RegWrite	: out std_logic;
		SignExtend	: out std_logic;
		Shift		: out std_logic;
		o_JR		: out std_logic;
		Overflow	: out std_logic;
		SLT		: out std_logic;
		MOVN		: out std_logic;
		Halt	: out std_logic
);
end control;

architecture behavioral of control is

signal top2	: std_logic_vector(1 downto 0);
signal top4	: std_logic_vector(3 downto 0);
signal bot3	: std_logic_vector(2 downto 0);
signal top5	: std_logic_vector(4 downto 0);
signal noOp	: std_logic;
signal jr	: std_logic;
signal MemReadS	: std_logic;

begin

top2	 <= i_OP(5 downto 4);
top4	 <= i_OP(5 downto 2);
bot3 	 <= i_OP(2 downto 0);
top5	 <= i_OP(5 downto 1);
noOp 	 <= '1' when i_OP = "000000" else '0';
jr 	 <= '1' when noOp = '1' and i_FUNCT = "001000" else '0';
MemReadS <= '1' when (i_OP = "100011") else '0';

RegDst	 <= '1' when (noOp = '1' or (i_OP = "011111" and i_FUNCT = "010010")) else '0';
Jump	 <= '1' when (top5 = "00001" or (noOp = '1' and jr = '1')) else '0';
Branch	 <= '1' when ((i_OP = "000100" and i_ZERO = '1') or (i_OP = "000101" and i_ZERO = '0')) else '0';
Reg31	 <= '1' when (i_OP = "000011") else '0';
MemRead	 <= MemReadS;
MemtoReg <= MemReadS;
ALUOp	 <= 	x"0" when ((noOp = '1' and i_FUNCT = "100100") or i_OP = "001100") else
		x"1" when ((noOp = '1' and i_FUNCT = "100101") or i_OP = "001101") else
		x"2" when ((noOp = '1' and i_FUNCT = "100110") or i_OP = "001110") else
		x"3" when ((noOp = '1' and (i_FUNCT = "100000" or i_FUNCT = "100001" or i_FUNCT = "001011")) or top5 = "00100" or i_OP = "100011" or i_OP = "101011") else
		x"4" when ((noOp = '1' and (i_FUNCT = "100010" or i_FUNCT = "101010" or i_FUNCT = "100011")) or top5 = "00010" or i_OP = "001010") else
		x"5" when (noOp = '1' and i_FUNCT = "000000") else
		x"6" when (noOp = '1' and i_FUNCT = "000010") else
		x"7" when (noOp = '1' and i_FUNCT = "000011") else
		x"8" when (i_OP = "011111" and i_FUNCT = "010010") else
		x"9" when (noOp = '1' and i_FUNCT = "100111") else
		x"a" when (i_OP = "001111") else
--		x"b" when () else
--		x"c" when () else
--		x"d" when () else
--		x"e" when () else
--		x"f" when () else 
		x"0";
MemWrite <= '1' when (i_OP = "101011") else '0';
ALUSrc	 <= '1' when (top5 = "00001" or top5 = "00100" or i_OP = "001010" or top4 = "0011" or (noOp = '1' and jr = '1') or (top2 = "10" and bot3 = "011")) else '0';
RegWrite <= '1' when not (i_OP = "101011" or top5 = "00010" or i_OP = "000010" or (noOp = '1' and jr = '1')) else '0'; 
SignExtend <= '1' when (top5 = "00010" or top5 = "00100" or (top2 = "10" and bot3 = "011") or i_OP = "001010") else '0';
Shift	 <= '1' when (noOp = '1' and (i_FUNCT = "000000" or i_FUNCT(5 downto 1) = "00001")) else '0';
o_JR	 <= '1' when (jr = '1') else '0';
Overflow <= '1' when (i_OVFL = '1' and ((noOp = '1' and (i_FUNCT = "100000" or i_FUNCT = "100010")) or i_OP = "001000")) else '0';
SLT	 <= '1' when (i_OP = "001010" or (noOp = '1' and i_FUNCT = "101010")) else '0';
MOVN	 <= '1' when (noOp = '1' and i_FUNCT = "001011") else '0';
Halt	 <= '1' when (i_OP = "010100") else '0';

end behavioral;
