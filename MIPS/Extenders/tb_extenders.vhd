library IEEE;
use IEEE.std_logic_1164.all;

entity tb_extenders is
  generic(gCLK_HPER   : time := 50 ns);
end tb_extenders;

architecture behavior of tb_extenders is
  
  -- Calculate the clock period as twice the half-period
  constant cCLK_PER  : time := gCLK_HPER * 2;

  component zeroextender
    port(	i_DATA	: in std_logic_vector(15 downto 0);
		o_DATA	: out std_logic_vector(31 downto 0));
  end component;

  component signextender
    port(	i_DATA	: in std_logic_vector(15 downto 0);
		i_SIGN	: in std_logic;
		o_DATA	: out std_logic_vector(31 downto 0));
  end component;

  -- Temporary signals to connect to the dff component.
  signal s_CLK, s_RST, s_SIGN  : std_logic;
  signal s_DATAIN : std_logic_vector(15 downto 0);
  signal s_DATAOUT0, s_DATAOUT1 : std_logic_vector(31 downto 0);

begin

  SEXT: signextender port map(
	i_DATA => s_DATAIN,
	i_SIGN => s_SIGN,
	o_DATA => s_DATAOUT0);

  ZEXT: zeroextender port map(
	i_DATA => s_DATAIN,
	o_DATA => s_DATAOUT1);

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

-- RANDOM EXTENDED DATA (UNSIGNED)
	s_DATAIN <= x"42ab";
	s_SIGN	 <= '0';
	wait for cCLK_PER;

-- RANDOM EXTENDED DATA (UNSIGNED, >8000)
	s_DATAIN <= x"86d3";
	s_SIGN	 <= '0';
	wait for cCLK_PER;

-- RANDOM EXTENDED DATA (SIGNED)
	s_DATAIN <= x"7c39";
	s_SIGN	 <= '1';
	wait for cCLK_PER;

-- RANDOM EXTENDED DATA (SIGNED, >8000)
	s_DATAIN <= x"a3b8";
	s_SIGN	 <= '1';
	wait for cCLK_PER;

-- RANDOM EXTENDED DATA (SIGNED, >8000)
	s_DATAIN <= x"f3b8";
	s_SIGN	 <= '1';
	wait for cCLK_PER;
-- RESET
    s_RST <= '1';
    wait;
  end process;
  
end behavior;
