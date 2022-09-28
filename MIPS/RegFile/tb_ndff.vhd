library IEEE;
use IEEE.std_logic_1164.all;

entity tb_ndff is
  generic(gCLK_HPER   : time := 50 ns);
end tb_ndff;

architecture behavior of tb_ndff is
  
  -- Calculate the clock period as twice the half-period
  constant cCLK_PER  : time := gCLK_HPER * 2;


  component n_dff
    generic(N	: integer := 32);
    port(clk        : in std_logic;     -- Clock input
         rst        : in std_logic;     -- Reset input
         w_en         : in std_logic;     -- Write enable input
         d          : in std_logic_vector(N-1 downto 0);     -- Data value input
         q          : out std_logic_vector(N-1 downto 0));   -- Data value output
  end component;

  -- Temporary signals to connect to the dff component.
  signal s_CLK, s_RST, s_WE  : std_logic;
  signal s_D, s_Q : std_logic_vector(31 downto 0);

begin

  DUT: n_dff 
  port map(clk => s_CLK, 
           rst => s_RST,
           w_en  => s_WE,
           d   => s_D,
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
    -- Reset the FF
    s_RST <= '1';
    s_WE  <= '0';
    s_D   <= "00000000000000000000000000000000";
    wait for cCLK_PER / 4;

    -- Store '1'
    s_RST <= '0';
    s_WE  <= '1';
    s_D   <= "11111111111111111111111111111111";
    wait for cCLK_PER;  

    -- Keep '1'
    s_RST <= '0';
    s_WE  <= '0';
    s_D   <= "00000000000000000000000000000000";
    wait for cCLK_PER;  

    -- Store '0'    
    s_RST <= '0';
    s_WE  <= '1';
    s_D   <= x"00000000";
    wait for cCLK_PER;  

    -- Keep '0'
    s_RST <= '0';
    s_WE  <= '0';
    s_D   <= x"00000000";
    wait for cCLK_PER;  

    wait;
  end process;
  
end behavior;
