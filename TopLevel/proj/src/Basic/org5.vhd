library IEEE;
use IEEE.std_logic_1164.all;

entity org5 is

  port(i_in0          : in std_logic;
       i_in1          : in std_logic;
       i_in2          : in std_logic;
       i_in3          : in std_logic;
       i_in4          : in std_logic;
       o_out          : out std_logic);

end org5;

architecture dataflow of org5 is
begin

  o_out <= i_in0 or i_in1 or i_in2 or i_in3 or i_in4;
  
end dataflow;