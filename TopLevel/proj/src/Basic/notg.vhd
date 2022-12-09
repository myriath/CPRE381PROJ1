library IEEE;
use IEEE.std_logic_1164.all;

entity notg is

  port(i_in          : in std_logic;
       o_out          : out std_logic);

end notg;

architecture dataflow of notg is
begin

  o_out <= not i_in;
  
end dataflow;