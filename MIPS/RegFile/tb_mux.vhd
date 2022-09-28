library IEEE;
use IEEE.std_logic_1164.all;
use work.muxpkg.all;

entity tb_mux is
  generic(gCLK_HPER   : time := 50 ns);
end tb_mux;

architecture behavior of tb_mux is
  
  -- Calculate the clock period as twice the half-period
  constant cCLK_PER  : time := gCLK_HPER * 2;


  component mux32t1
    port(i_SEL        : in std_logic_vector(4 downto 0);     -- Clock input
	 i_D	      : in muxarray;
         o_O          : out std_logic_vector(31 downto 0));   -- Data value output
  end component;

  -- Temporary signals to connect to the dff component.
  signal s_CLK, s_RST, s_WE  : std_logic;
  signal s_O : std_logic_vector(31 downto 0);
  signal s_SEL : std_logic_vector(4 downto 0);
  signal s_D : muxarray := (0 => x"fadd3186", 1 => x"afdf1235", 2 => x"852ff210", others => x"00000000");

begin

  DUT: mux32t1 
  port map(i_SEL => s_SEL, 
	   i_D	 => s_D,
           o_O   => s_O);

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
    s_SEL  <= '0' & x"0";
    wait for cCLK_PER;

    s_SEL  <= '0' & x"1";
    wait for cCLK_PER;  

    s_SEL  <= '0' & x"2";
    wait for cCLK_PER;  

    s_SEL  <= '0' & x"3";
    wait for cCLK_PER;  

    s_SEL  <= '0' & x"4";
    wait for cCLK_PER;  

    s_SEL  <= '0' & x"5";
    wait for cCLK_PER;  

    s_SEL  <= '0' & x"6";
    wait for cCLK_PER;  

    s_SEL  <= '0' & x"7";
    wait for cCLK_PER;  

    s_SEL  <= '0' & x"8";
    wait for cCLK_PER;  

    s_SEL  <= '0' & x"9";
    wait for cCLK_PER;  

    s_SEL  <= '0' & x"a";
    wait for cCLK_PER;  

    s_SEL  <= '0' & x"b";
    wait for cCLK_PER;  

    s_SEL  <= '0' & x"c";
    wait for cCLK_PER;  

    s_SEL  <= '0' & x"d";
    wait for cCLK_PER;  

    s_SEL  <= '0' & x"e";
    wait for cCLK_PER;  

    s_SEL  <= '0' & x"f";
    wait for cCLK_PER;  

    s_SEL  <= '1' & x"0";
    wait for cCLK_PER;  

    s_SEL  <= '1' & x"1";
    wait for cCLK_PER; 

    s_SEL  <= '1' & x"2";
    wait for cCLK_PER;  

    s_SEL  <= '1' & x"3";
    wait for cCLK_PER;  

    s_SEL  <= '1' & x"4";
    wait for cCLK_PER;  

    s_SEL  <= '1' & x"5";
    wait for cCLK_PER;  

    s_SEL  <= '1' & x"6";
    wait for cCLK_PER;  

    s_SEL  <= '1' & x"7";
    wait for cCLK_PER;  

    s_SEL  <= '1' & x"8";
    wait for cCLK_PER;  

    s_SEL  <= '1' & x"9";
    wait for cCLK_PER;  

    s_SEL  <= '1' & x"a";
    wait for cCLK_PER;  

    s_SEL  <= '1' & x"b";
    wait for cCLK_PER;  

    s_SEL  <= '1' & x"c";
    wait for cCLK_PER;  

    s_SEL  <= '1' & x"d";
    wait for cCLK_PER;  

    s_SEL  <= '1' & x"e";
    wait for cCLK_PER;  

    s_SEL  <= '1' & x"f";
    wait for cCLK_PER;  

    wait;
  end process;
  
end behavior;
