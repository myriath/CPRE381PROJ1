library IEEE;
use IEEE.std_logic_1164.all;

entity tb_dmem is
  generic(gCLK_HPER   : time := 50 ns);
end tb_dmem;

architecture behavior of tb_dmem is
  
  -- Calculate the clock period as twice the half-period
  constant cCLK_PER  : time := gCLK_HPER * 2;


  component mem
    generic(
	DATA_WIDTH	: integer := 32;
	ADDR_WIDTH	: natural := 10);
    port(clk        : in std_logic;     -- Clock input
	 addr	    : in std_logic_vector(ADDR_WIDTH-1 downto 0);
	 data	    : in std_logic_vector(DATA_WIDTH-1 downto 0);
         we         : in std_logic;     -- Write enable input
         q          : out std_logic_vector(DATA_WIDTH-1 downto 0));   -- Data value output
  end component;

  type datarray is array (0 to 10) of std_logic_vector(31 downto 0);
  -- Temporary signals to connect to the dff component.
  signal s_CLK, s_WE  : std_logic;
  signal s_DATA, s_Q : std_logic_vector(31 downto 0);
  signal s_ADDR	: std_logic_vector(9 downto 0);
  signal s_DATARRAY : datarray;

begin

  dmem: mem 
  port map(clk => s_CLK, 
	   addr=> s_ADDR,
	   data=> s_DATA,
           we  => s_WE,
           q   => s_Q);

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
	s_WE	<= '0';
	wait for gCLK_HPER / 2;

--
	s_DATARRAY(0) <= s_Q;
	s_ADDR 	<= "0000000000";
	s_DATA 	<= x"00000000";
	s_WE	<= '0';
	s_DATARRAY(0) <= s_Q;
	wait for cCLK_PER;

--
	s_DATARRAY(1) <= s_Q;
	s_ADDR 	<= "0000000001";
	s_DATA 	<= x"00000000";
	s_WE	<= '0';
	s_DATARRAY(1) <= s_Q;
	wait for cCLK_PER;

--
	s_DATARRAY(2) <= s_Q;
	s_ADDR 	<= "0000000010";
	s_DATA 	<= x"00000000";
	s_WE	<= '0';
	s_DATARRAY(2) <= s_Q;
	wait for cCLK_PER;

--
	s_DATARRAY(3) <= s_Q;
	s_ADDR 	<= "0000000011";
	s_DATA 	<= x"00000000";
	s_WE	<= '0';
	s_DATARRAY(3) <= s_Q;
	wait for cCLK_PER;

--
	s_DATARRAY(4) <= s_Q;
	s_ADDR 	<= "0000000100";
	s_DATA 	<= x"00000000";
	s_WE	<= '0';
	s_DATARRAY(4) <= s_Q;
	wait for cCLK_PER;

--
	s_DATARRAY(5) <= s_Q;
	s_ADDR 	<= "0000000101";
	s_DATA 	<= x"00000000";
	s_WE	<= '0';
	s_DATARRAY(5) <= s_Q;
	wait for cCLK_PER;

--
	s_DATARRAY(6) <= s_Q;
	s_ADDR 	<= "0000000110";
	s_DATA 	<= x"00000000";
	s_WE	<= '0';
	s_DATARRAY(6) <= s_Q;
	wait for cCLK_PER;

--
	s_DATARRAY(7) <= s_Q;
	s_ADDR 	<= "0000000111";
	s_DATA 	<= x"00000000";
	s_WE	<= '0';
	s_DATARRAY(7) <= s_Q;
	wait for cCLK_PER;

--
	s_DATARRAY(8) <= s_Q;
	s_ADDR 	<= "0000001000";
	s_DATA 	<= x"00000000";
	s_WE	<= '0';
	s_DATARRAY(8) <= s_Q;
	wait for cCLK_PER;

--
	s_DATARRAY(9) <= s_Q;
	s_ADDR 	<= "0000001001";
	s_DATA 	<= x"00000000";
	s_WE	<= '0';
	s_DATARRAY(9) <= s_Q;
	wait for cCLK_PER;

	s_DATARRAY(10) <= s_Q;
	wait for cCLK_PER;
--
	s_ADDR 	<= "0011011101";
	s_DATA 	<= s_DATARRAY(1);
	s_WE	<= '1';
	wait for cCLK_PER;

--
	s_ADDR 	<= "0011011110";
	s_DATA 	<= s_DATARRAY(2);
	s_WE	<= '1';
	wait for cCLK_PER;

--
	s_ADDR 	<= "0011011111";
	s_DATA 	<= s_DATARRAY(3);
	s_WE	<= '1';
	wait for cCLK_PER;

--
	s_ADDR 	<= "0011100000";
	s_DATA 	<= s_DATARRAY(4);
	s_WE	<= '1';
	wait for cCLK_PER;

--
	s_ADDR 	<= "0011100001";
	s_DATA 	<= s_DATARRAY(5);
	s_WE	<= '1';
	wait for cCLK_PER;

--
	s_ADDR 	<= "0011100010";
	s_DATA 	<= s_DATARRAY(6);
	s_WE	<= '1';
	wait for cCLK_PER;

--
	s_ADDR 	<= "0011100011";
	s_DATA 	<= s_DATARRAY(7);
	s_WE	<= '1';
	wait for cCLK_PER;

--
	s_ADDR 	<= "0011100100";
	s_DATA 	<= s_DATARRAY(8);
	s_WE	<= '1';
	wait for cCLK_PER;

--
	s_ADDR 	<= "0011100101";
	s_DATA 	<= s_DATARRAY(9);
	s_WE	<= '1';
	wait for cCLK_PER;

--
	s_ADDR 	<= "0011100110";
	s_DATA 	<= s_DATARRAY(10);
	s_WE	<= '1';
	wait for cCLK_PER;

--
	s_ADDR 	<= "0011011101";
	s_DATA 	<= x"00000000";
	s_WE	<= '0';
	wait for cCLK_PER;

--
	s_ADDR 	<= "0011011110";
	s_DATA 	<= x"00000000";
	s_WE	<= '0';
	wait for cCLK_PER;

--
	s_ADDR 	<= "0011011111";
	s_DATA 	<= x"00000000";
	s_WE	<= '0';
	wait for cCLK_PER;

--
	s_ADDR 	<= "0011100000";
	s_DATA 	<= x"00000000";
	s_WE	<= '0';
	wait for cCLK_PER;

--
	s_ADDR 	<= "0011100001";
	s_DATA 	<= x"00000000";
	s_WE	<= '0';
	wait for cCLK_PER;

--
	s_ADDR 	<= "0011100010";
	s_DATA 	<= x"00000000";
	s_WE	<= '0';
	wait for cCLK_PER;

--
	s_ADDR 	<= "0011100011";
	s_DATA 	<= x"00000000";
	s_WE	<= '0';
	wait for cCLK_PER;

--
	s_ADDR 	<= "0011100100";
	s_DATA 	<= x"00000000";
	s_WE	<= '0';
	wait for cCLK_PER;

--
	s_ADDR 	<= "0011100101";
	s_DATA 	<= x"00000000";
	s_WE	<= '0';
	wait for cCLK_PER;

--
	s_ADDR 	<= "0011100110";
	s_DATA 	<= x"00000000";
	s_WE	<= '0';
	wait for cCLK_PER;

    wait;
  end process;
  
end behavior;
