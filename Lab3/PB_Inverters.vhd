library ieee;
use ieee.std_logic_1164.all;


--- Lab session: 204, Team Number: 1, Group Number: 6.
--- Maria Omer
--- Shamanthi Rajagopal

--- variables/inputs/outputs
entity PB_Inverters is
port (
	pb_n : in std_logic_vector(3 downto 0);
	pb   : out std_logic_vector(3 downto 0)
);

end PB_Inverters;

architecture gates of PB_Inverters is 

begin 

--- applies not to input of push button

pb <= not (pb_n);

	
end gates;
	