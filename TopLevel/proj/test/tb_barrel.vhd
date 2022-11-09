library IEEE;
use IEEE.std_logic_1164.all;

entity tb_barrel is
  generic(gCLK_HPER   : time := 50 ns);
end tb_barrel;

architecture behavior of tb_barrel is
  
  -- Calculate the clock period as twice the half-period
  constant cCLK_PER  : time := gCLK_HPER * 2;

  component Barrel_Shifter
    generic(	N		: integer := 32);
    port(	i_Value		: in std_logic_vector(N-1 downto 0);
		i_shift_amount	: in std_logic_vector(4 downto 0);
		i_Contral	: in std_logic_vector(1 downto 0);
		o_F		: out std_logic_vector(N-1 downto 0));
  end component;

  -- Temporary signals to connect to the dff component.
  signal s_CLK, s_RST : std_logic;
  signal s_Value, s_F : std_logic_vector(31 downto 0);
  signal s_shamt : std_logic_vector(4 downto 0);
  signal s_control : std_logic_vector(1 downto 0);

begin

  DUT: Barrel_Shifter
  port map (	i_Value => s_Value,
		i_shift_amount => s_shamt,
		i_Contral => s_control,
		o_F => s_F);
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

--
	s_Value <= x"00001234";
	s_shamt <= "00010";
	s_control <= "00";
	wait for cCLK_PER;

--
	s_Value <= x"00001234";
	s_shamt <= "00100";
	s_control <= "00";
	wait for cCLK_PER;

--
	s_Value <= x"00012340";
	s_shamt <= "00010";
	s_control <= "10";
	wait for cCLK_PER;

--
	s_Value <= x"fff12340";
	s_shamt <= "00100";
	s_control <= "10";
	wait for cCLK_PER;

--
	s_Value <= x"00001234";
	s_shamt <= "00100";
	s_control <= "11";
	wait for cCLK_PER;

--
	s_Value <= x"ffff1234";
	s_shamt <= "00100";
	s_control <= "11";
	wait for cCLK_PER;

-- RESET
    s_RST <= '1';
    wait;
  end process;
  
end behavior;
