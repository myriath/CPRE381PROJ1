library IEEE;
use IEEE.std_logic_1164.all;

entity tb_datapath is
  generic(gCLK_HPER   : time := 50 ns);
end tb_datapath;

architecture behavior of tb_datapath is
  
  -- Calculate the clock period as twice the half-period
  constant cCLK_PER  : time := gCLK_HPER * 2;


  component datapath
    port(	i_CLK	: in std_logic;
		i_RST	: in std_logic;
		i_EN	: in std_logic;
		i_VALUE	: in std_logic_vector(31 downto 0);
		i_DST	: in std_logic_vector(4 downto 0);
		i_SRC0	: in std_logic_vector(4 downto 0);
		i_SRC1	: in std_logic_vector(4 downto 0);
		i_ADDSUB: in std_logic;
		i_SRCSEL: in std_logic);
  end component;

  -- Temporary signals to connect to the dff component.
  signal s_CLK, s_RST, s_EN, s_ADDSUB, s_SRCSEL  : std_logic;
  signal s_DST : std_logic_vector(4 downto 0);
  signal s_SRC0 : std_logic_vector(4 downto 0);
  signal s_SRC1 : std_logic_vector(4 downto 0);
  signal s_VALUE : std_logic_vector(31 downto 0);

begin

  DUT: datapath 
  port map(	i_CLK	=> s_CLK,
		i_RST	=> s_RST,
		i_EN	=> s_EN,
		i_VALUE	=> s_VALUE,
		i_DST	=> s_DST,
		i_SRC0	=> s_SRC0,
		i_SRC1	=> s_SRC1,
		i_ADDSUB=> s_ADDSUB,
		i_SRCSEL=> s_SRCSEL);

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
    s_EN <= '1';

-- addi	$1,	$0,	1
	s_VALUE		<= x"00000001";
	s_DST		<= "00001";
	s_SRC0		<= "00000";
	s_SRC1		<= "00000";
	s_ADDSUB	<= '0';
	s_SRCSEL	<= '1';
	wait for cCLK_PER;
    
-- addi $2,	$0,	2
	s_VALUE		<= x"00000002";
	s_DST		<= "00010";
	s_SRC0		<= "00000";
	s_SRC1		<= "00000";
	s_ADDSUB	<= '0';
	s_SRCSEL	<= '1';
	wait for cCLK_PER;
    
-- addi $3,	$0, 	3
	s_VALUE		<= x"00000003";
	s_DST		<= "00011";
	s_SRC0		<= "00000";
	s_SRC1		<= "00000";
	s_ADDSUB	<= '0';
	s_SRCSEL	<= '1';
	wait for cCLK_PER;
    
-- addi $4,	$0, 	4
	s_VALUE		<= x"00000004";
	s_DST		<= "00100";
	s_SRC0		<= "00000";
	s_SRC1		<= "00000";
	s_ADDSUB	<= '0';
	s_SRCSEL	<= '1';
	wait for cCLK_PER;
    
-- addi $5,	$0, 	5
	s_VALUE		<= x"00000005";
	s_DST		<= "00101";
	s_SRC0		<= "00000";
	s_SRC1		<= "00000";
	s_ADDSUB	<= '0';
	s_SRCSEL	<= '1';
	wait for cCLK_PER;
    
-- addi $6,	$0, 	6
	s_VALUE		<= x"00000006";
	s_DST		<= "00110";
	s_SRC0		<= "00000";
	s_SRC1		<= "00000";
	s_ADDSUB	<= '0';
	s_SRCSEL	<= '1';
	wait for cCLK_PER;
    
-- addi $7,	$0, 	7
	s_VALUE		<= x"00000007";
	s_DST		<= "00111";
	s_SRC0		<= "00000";
	s_SRC1		<= "00000";
	s_ADDSUB	<= '0';
	s_SRCSEL	<= '1';
	wait for cCLK_PER;
    
-- addi $8,	$0, 	8
	s_VALUE		<= x"00000008";
	s_DST		<= "01000";
	s_SRC0		<= "00000";
	s_SRC1		<= "00000";
	s_ADDSUB	<= '0';
	s_SRCSEL	<= '1';
	wait for cCLK_PER;
    
-- addi $9,	$0, 	9
	s_VALUE		<= x"00000009";
	s_DST		<= "01001";
	s_SRC0		<= "00000";
	s_SRC1		<= "00000";
	s_ADDSUB	<= '0';
	s_SRCSEL	<= '1';
	wait for cCLK_PER;
    
-- addi $10,	$0,	10
	s_VALUE		<= x"0000000a";
	s_DST		<= "01010";
	s_SRC0		<= "00000";
	s_SRC1		<= "00000";
	s_ADDSUB	<= '0';
	s_SRCSEL	<= '1';
	wait for cCLK_PER;
    
-- add	$11,	$1,	$2
	s_VALUE		<= x"00000000";
	s_DST		<= "01011";
	s_SRC0		<= "00001";
	s_SRC1		<= "00010";
	s_ADDSUB	<= '0';
	s_SRCSEL	<= '0';
	wait for cCLK_PER;
    
-- sub	$12,	$11,	$3
	s_VALUE		<= x"00000000";
	s_DST		<= "01100";
	s_SRC0		<= "01011";
	s_SRC1		<= "00011";
	s_ADDSUB	<= '1';
	s_SRCSEL	<= '0';
	wait for cCLK_PER;
    
-- add	$13,	$12,	$4
	s_VALUE		<= x"00000000";
	s_DST		<= "01101";
	s_SRC0		<= "01100";
	s_SRC1		<= "00100";
	s_ADDSUB	<= '0';
	s_SRCSEL	<= '0';
	wait for cCLK_PER;
    
-- sub	$14,	$13,	$5
	s_VALUE		<= x"00000000";
	s_DST		<= "01110";
	s_SRC0		<= "01101";
	s_SRC1		<= "00101";
	s_ADDSUB	<= '1';
	s_SRCSEL	<= '0';
	wait for cCLK_PER;
    
-- add	$15,	$14,	$6
	s_VALUE		<= x"00000000";
	s_DST		<= "01111";
	s_SRC0		<= "01110";
	s_SRC1		<= "00110";
	s_ADDSUB	<= '0';
	s_SRCSEL	<= '0';
	wait for cCLK_PER;
    
-- sub	$16,	$15,	$7
	s_VALUE		<= x"00000000";
	s_DST		<= "10000";
	s_SRC0		<= "01111";
	s_SRC1		<= "00111";
	s_ADDSUB	<= '1';
	s_SRCSEL	<= '0';
	wait for cCLK_PER;

-- add	$17,	$16,	$8
	s_VALUE		<= x"00000000";
	s_DST		<= "10001";
	s_SRC0		<= "10000";
	s_SRC1		<= "01000";
	s_ADDSUB	<= '0';
	s_SRCSEL	<= '0';
	wait for cCLK_PER;
    
-- sub	$18,	$17,	$9
	s_VALUE		<= x"00000000";
	s_DST		<= "10010";
	s_SRC0		<= "10001";
	s_SRC1		<= "01001";
	s_ADDSUB	<= '1';
	s_SRCSEL	<= '0';
	wait for cCLK_PER;
    
-- add	$19,	$18,	$10
	s_VALUE		<= x"00000000";
	s_DST		<= "10011";
	s_SRC0		<= "10010";
	s_SRC1		<= "01010";
	s_ADDSUB	<= '0';
	s_SRCSEL	<= '0';
	wait for cCLK_PER;
    
-- addi	$20,	$0,	-35
	s_VALUE		<= x"ffffffdd";
	s_DST		<= "10100";
	s_SRC0		<= "00000";
	s_SRC1		<= "00000";
	s_ADDSUB	<= '0';
	s_SRCSEL	<= '1';
	wait for cCLK_PER;
    
-- add	$21,	$19,	$20
	s_VALUE		<= x"00000000";
	s_DST		<= "10101";
	s_SRC0		<= "10011";
	s_SRC1		<= "10100";
	s_ADDSUB	<= '0';
	s_SRCSEL	<= '0';
	wait for cCLK_PER;
    
-- RESET
    s_RST <= '1';
    wait;
  end process;
  
end behavior;
