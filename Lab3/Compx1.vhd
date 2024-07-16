library ieee;
use ieee.std_logic_1164.all;

--- Lab session: 204, Team Number: 1, Group Number: 6.
--- Maria Omer
--- Shamanthi Rajagopal


--- used variables/inputs/outputs
entity Compx1 is port (
	input_A 			: in std_logic;
	input_B 			: in std_logic;
	A_greater      : out std_logic;
	equal          : out std_logic;
	B_greater      : out std_logic
);

end Compx1;

architecture comp_logic of Compx1 is 

begin 

	A_greater <= input_A AND NOT (input_B);  
	equal <= NOT (input_A XOR input_B);
	B_greater <= NOT (input_A) AND (input_B);  
    

end comp_logic;
	