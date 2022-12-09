library IEEE;
use IEEE.std_logic_1164.all;

entity tb_Foward is
  generic(gCLK_HPER   : time := 50 ns);
end tb_Foward;

architecture behavior of tb_Foward is
  
  -- Calculate the clock period as twice the half-period
  constant cCLK_PER  : time := gCLK_HPER * 2;


  component Foward is
	port(	i_RS	: in std_logic_vector(4 downto 0);
		i_RT	: in std_logic_vector(4 downto 0);
		i_ExMem	: in std_logic_vector(4 downto 0);
		i_ExALU	: in std_logic_vector(4 downto 0);
		o_RS	: out std_logic_vector(1 downto 0);
		o_RT	: out std_logic_vector(1 downto 0));
 end component;

  -- Temporary signals to connect to the dff component.
  signal s_CLK, s_RST : std_logic;
  signal s_FowardA, s_FowardB : std_logic_vector(1 downto 0);
  signal s_RS, s_RT, s_ExMem, s_ExALU : std_logic_vector(4 downto 0);


begin

  DUT: Foward 
		port map(  
		i_RS	=> s_RS,
		i_RT	=> s_RT,
		i_ExMem	=> s_ExMem,
		i_ExALU	=> s_ExALU,
		o_RS	=> s_FowardA,			
		o_RT    => s_FowardB );

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

-- iF s_ExMem And s_ExALU = 0
	s_RS		<= "00011";
	s_RT		<= "11000";
	s_ExMem		<= "00000";
	s_ExALU		<= "00000";
	wait for cCLK_PER;

-- iF s_ExMem = s_RS
	s_RS		<= "00011";
	s_RT		<= "11000";
	s_ExMem		<= "00011";
	s_ExALU		<= "00000";
	wait for cCLK_PER;

-- iF s_ExMem = s_RT
	s_RS		<= "00001";
	s_RT		<= "00011";
	s_ExMem		<= "00011";
	s_ExALU		<= "00000";
	wait for cCLK_PER;

-- iF s_ExMem = s_RT and = s_RS
	s_RS		<= "00011";
	s_RT		<= "00011";
	s_ExMem		<= "00011";
	s_ExALU		<= "00000";
	wait for cCLK_PER;

-- iF s_ExALU = s_RS
	s_RS		<= "00011";
	s_RT		<= "11000";
	s_ExMem		<= "00000";
	s_ExALU		<= "00011";
	wait for cCLK_PER;

-- iF s_ExALU = s_RT
	s_RS		<= "00001";
	s_RT		<= "00011";
	s_ExMem		<= "00000";
	s_ExALU		<= "00011";
	wait for cCLK_PER;

-- iF s_ExALU = s_RT and = s_RS
	s_RS		<= "00011";
	s_RT		<= "00011";
	s_ExMem		<= "00000";
	s_ExALU		<= "00011";
	wait for cCLK_PER;

-- iF s_ExALU = s_RT = s_RS and = s_ExMem
	s_RS		<= "00011";
	s_RT		<= "00011";
	s_ExMem		<= "00011";
	s_ExALU		<= "00011";
	wait for cCLK_PER;
  end process;
  
end behavior;
