library IEEE;
use IEEE.std_logic_1164.all;

entity tb_datapath2 is
  generic(gCLK_HPER   : time := 50 ns);
end tb_datapath2;

architecture behavior of tb_datapath2 is
  
  -- Calculate the clock period as twice the half-period
  constant cCLK_PER  : time := gCLK_HPER * 2;


  component datapath2
    port(	i_CLK	: in std_logic;
		i_RST	: in std_logic;
		i_RW	: in std_logic;
		i_MW	: in std_logic;
		i_IMMED	: in std_logic_vector(15 downto 0);
		i_DST	: in std_logic_vector(4 downto 0);
		i_SRC0	: in std_logic_vector(4 downto 0);
		i_SRC1	: in std_logic_vector(4 downto 0);
		i_ADDSUB: in std_logic;
		i_SRCSEL: in std_logic;
		i_WSEL	: in std_logic;
		i_SIGN	: in std_logic);
  end component;

  -- Temporary signals to connect to the dff component.
  signal s_CLK, s_RST, s_RW, s_MW, s_ADDSUB, s_SRCSEL, s_WSEL, s_SIGN  : std_logic;
  signal s_DST : std_logic_vector(4 downto 0);
  signal s_SRC0 : std_logic_vector(4 downto 0);
  signal s_SRC1 : std_logic_vector(4 downto 0);
  signal s_IMMED : std_logic_vector(15 downto 0);

begin

  DUT: datapath2 
  port map(	i_CLK	=> s_CLK,
		i_RST	=> s_RST,
		i_RW	=> s_RW,
		i_MW	=> s_MW,
		i_IMMED	=> s_IMMED,
		i_DST	=> s_DST,
		i_SRC0	=> s_SRC0,
		i_SRC1	=> s_SRC1,
		i_ADDSUB=> s_ADDSUB,
		i_SRCSEL=> s_SRCSEL,
		i_WSEL	=> s_WSEL,
		i_SIGN	=> s_SIGN);

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
    s_SIGN <= '0';

-- addi	$25,	$0,	0
	s_IMMED		<= x"0000";
	s_DST		<= "11001";
	s_SRC0		<= "00000";
	s_SRC1		<= "00000";
	s_ADDSUB	<= '0';
	s_SRCSEL	<= '1';
	s_WSEL		<= '0';
	s_RW		<= '1';
	s_MW		<= '0';
	wait for cCLK_PER;
    
-- addi	$26,	$0,	256
	s_IMMED		<= x"0040";
	s_DST		<= "11010";
	s_SRC0		<= "00000";
	s_SRC1		<= "00000";
	s_ADDSUB	<= '0';
	s_SRCSEL	<= '1';
	s_WSEL		<= '0';
	s_RW		<= '1';
	s_MW		<= '0';
	wait for cCLK_PER;

-- lw	$1,	0($25)
	s_IMMED		<= x"0000";
	s_DST		<= "00001";
	s_SRC0		<= "11001";
	s_SRC1		<= "00000";
	s_ADDSUB	<= '0';
	s_SRCSEL	<= '0';
	s_WSEL		<= '1';
	s_RW		<= '1';
	s_MW		<= '0';
	wait for cCLK_PER;
    
-- lw	$2,	4($25)
	s_IMMED		<= x"0001";
	s_DST		<= "00010";
	s_SRC0		<= "11001";
	s_SRC1		<= "00000";
	s_ADDSUB	<= '0';
	s_SRCSEL	<= '0';
	s_WSEL		<= '1';
	s_RW		<= '1';
	s_MW		<= '0';
	wait for cCLK_PER;
    
-- add	$1,	$1,	$2
	s_IMMED		<= x"0000";
	s_DST		<= "00001";
	s_SRC0		<= "00001";
	s_SRC1		<= "00010";
	s_ADDSUB	<= '0';
	s_SRCSEL	<= '0';
	s_WSEL		<= '0';
	s_RW		<= '1';
	s_MW		<= '0';
	wait for cCLK_PER;
    
-- sw	$1,	0($26)
	s_IMMED		<= x"0000";
	s_DST		<= "00000";
	s_SRC0		<= "11010";
	s_SRC1		<= "00001";
	s_ADDSUB	<= '0';
	s_SRCSEL	<= '1';
	s_WSEL		<= '0';
	s_RW		<= '0';
	s_MW		<= '1';
	wait for cCLK_PER;
    
-- lw	$2,	8($25)
	s_IMMED		<= x"0002";
	s_DST		<= "00010";
	s_SRC0		<= "11001";
	s_SRC1		<= "00000";
	s_ADDSUB	<= '0';
	s_SRCSEL	<= '0';
	s_WSEL		<= '1';
	s_RW		<= '1';
	s_MW		<= '0';
	wait for cCLK_PER;
    
-- add	$1,	$1,	$2
	s_IMMED		<= x"0000";
	s_DST		<= "00001";
	s_SRC0		<= "00001";
	s_SRC1		<= "00010";
	s_ADDSUB	<= '0';
	s_SRCSEL	<= '0';
	s_WSEL		<= '0';
	s_RW		<= '1';
	s_MW		<= '0';
	wait for cCLK_PER;
    
-- sw	$1,	4($26)
	s_IMMED		<= x"0001";
	s_DST		<= "00000";
	s_SRC0		<= "11010";
	s_SRC1		<= "00001";
	s_ADDSUB	<= '0';
	s_SRCSEL	<= '1';
	s_WSEL		<= '0';
	s_RW		<= '0';
	s_MW		<= '1';
	wait for cCLK_PER;
    
-- lw	$2,	12($25)
	s_IMMED		<= x"0003";
	s_DST		<= "00010";
	s_SRC0		<= "11001";
	s_SRC1		<= "00000";
	s_ADDSUB	<= '0';
	s_SRCSEL	<= '0';
	s_WSEL		<= '1';
	s_RW		<= '1';
	s_MW		<= '0';
	wait for cCLK_PER;
    
-- add	$1,	$1,	$2
	s_IMMED		<= x"0000";
	s_DST		<= "00001";
	s_SRC0		<= "00001";
	s_SRC1		<= "00010";
	s_ADDSUB	<= '0';
	s_SRCSEL	<= '0';
	s_WSEL		<= '0';
	s_RW		<= '1';
	s_MW		<= '0';
	wait for cCLK_PER;
    
-- sw	$1,	8($26)
	s_IMMED		<= x"0002";
	s_DST		<= "00000";
	s_SRC0		<= "11010";
	s_SRC1		<= "00001";
	s_ADDSUB	<= '0';
	s_SRCSEL	<= '1';
	s_WSEL		<= '0';
	s_RW		<= '0';
	s_MW		<= '1';
	wait for cCLK_PER;
    
-- lw	$2,	16($25)
	s_IMMED		<= x"0004";
	s_DST		<= "00010";
	s_SRC0		<= "11001";
	s_SRC1		<= "00000";
	s_ADDSUB	<= '0';
	s_SRCSEL	<= '0';
	s_WSEL		<= '1';
	s_RW		<= '1';
	s_MW		<= '0';
	wait for cCLK_PER;
    
-- add	$1,	$1,	$2
	s_IMMED		<= x"0000";
	s_DST		<= "00001";
	s_SRC0		<= "00001";
	s_SRC1		<= "00010";
	s_ADDSUB	<= '0';
	s_SRCSEL	<= '0';
	s_WSEL		<= '0';
	s_RW		<= '1';
	s_MW		<= '0';
	wait for cCLK_PER;
    
-- sw	$1,	12($26)
	s_IMMED		<= x"0003";
	s_DST		<= "00000";
	s_SRC0		<= "11010";
	s_SRC1		<= "00001";
	s_ADDSUB	<= '0';
	s_SRCSEL	<= '1';
	s_WSEL		<= '0';
	s_RW		<= '0';
	s_MW		<= '1';
	wait for cCLK_PER;
    
-- lw	$2,	20($25)
	s_IMMED		<= x"0005";
	s_DST		<= "00010";
	s_SRC0		<= "11001";
	s_SRC1		<= "00000";
	s_ADDSUB	<= '0';
	s_SRCSEL	<= '0';
	s_WSEL		<= '1';
	s_RW		<= '1';
	s_MW		<= '0';
	wait for cCLK_PER;
    
-- add	$1,	$1,	$2
	s_IMMED		<= x"0000";
	s_DST		<= "00001";
	s_SRC0		<= "00001";
	s_SRC1		<= "00010";
	s_ADDSUB	<= '0';
	s_SRCSEL	<= '0';
	s_WSEL		<= '0';
	s_RW		<= '1';
	s_MW		<= '0';
	wait for cCLK_PER;
    
-- sw	$1,	16($26)
	s_IMMED		<= x"0004";
	s_DST		<= "00000";
	s_SRC0		<= "11010";
	s_SRC1		<= "00001";
	s_ADDSUB	<= '0';
	s_SRCSEL	<= '1';
	s_WSEL		<= '0';
	s_RW		<= '0';
	s_MW		<= '1';
	wait for cCLK_PER;
    
-- lw	$2,	24($25)
	s_IMMED		<= x"0006";
	s_DST		<= "00010";
	s_SRC0		<= "11001";
	s_SRC1		<= "00000";
	s_ADDSUB	<= '0';
	s_SRCSEL	<= '0';
	s_WSEL		<= '1';
	s_RW		<= '1';
	s_MW		<= '0';
	wait for cCLK_PER;
    
-- add	$1,	$1,	$2
	s_IMMED		<= x"0000";
	s_DST		<= "00001";
	s_SRC0		<= "00001";
	s_SRC1		<= "00010";
	s_ADDSUB	<= '0';
	s_SRCSEL	<= '0';
	s_WSEL		<= '0';
	s_RW		<= '1';
	s_MW		<= '0';
	wait for cCLK_PER;
    
-- addi	$27,	$0,	512
	s_IMMED		<= x"0080";
	s_DST		<= "11011";
	s_SRC0		<= "00000";
	s_SRC1		<= "00000";
	s_ADDSUB	<= '0';
	s_SRCSEL	<= '1';
	s_WSEL		<= '0';
	s_RW		<= '1';
	s_MW		<= '0';
	wait for cCLK_PER;
    
-- sw	$1,	-4($27)
	s_SIGN		<= '1';
	s_IMMED		<= x"ffff";
	s_DST		<= "00000";
	s_SRC0		<= "11011";
	s_SRC1		<= "00001";
	s_ADDSUB	<= '0';
	s_SRCSEL	<= '1';
	s_WSEL		<= '0';
	s_RW		<= '0';
	s_MW		<= '1';
	wait for cCLK_PER;
    
-- RESET
    s_RST <= '1';
    s_SIGN <= '0';
    wait;
  end process;
  
end behavior;
