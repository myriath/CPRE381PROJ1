library IEEE;
use IEEE.std_logic_1164.all;

entity andg6 is

  port(i_in0          : in std_logic;
       i_in1          : in std_logic;
       i_in2          : in std_logic;
       i_in3          : in std_logic;
       i_in4          : in std_logic;
       i_in5          : in std_logic;
       o_out          : out std_logic);

end andg6;

architecture dataflow of andg6 is
begin

  o_out <= i_in0 and i_in1 and i_in2 and i_in3 and i_in4 and i_in5;
  
end dataflow;