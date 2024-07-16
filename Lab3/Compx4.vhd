library ieee;
use ieee.std_logic_1164.all;

--- Lab session: 204, Team Number: 1, Group Number: 6.
--- Maria Omer
--- Shamanthi Rajagopal


--- used variables/inputs/outputs
entity Compx4 is port (
	input_X 			: in std_logic_vector(3 downto 0);
	input_Y 			: in std_logic_vector(3 downto 0);
	X_greater      : out std_logic;
	XY_equal       : out std_logic;
	Y_greater      : out std_logic
);

end Compx4;


architecture Comp4_logic of Compx4 is 

	component Compx1 port (
			input_A 			: in std_logic;
			input_B 			: in std_logic;
			A_greater      : out std_logic;
			equal          : out std_logic;
			B_greater      : out std_logic
			);
		
   end component;                 
	
	signal A_greater : std_logic_vector(3 downto 0);
	signal equal : std_logic_vector(3 downto 0);
	signal B_greater : std_logic_vector(3 downto 0);

begin

    	INST1: Compx1 port map (input_X(0), input_Y(0), A_greater(0), equal(0), B_greater(0));
    	INST2: Compx1 port map (input_X(1), input_Y(1), A_greater(1), equal(1), B_greater(1));
    	INST3: Compx1 port map (input_X(2), input_Y(2), A_greater(2), equal(2), B_greater(2));
    	INST4: Compx1 port map (input_X(3), input_Y(3), A_greater(3), equal(3), B_greater(3));

		X_greater <= ((A_greater(3)) OR (equal(3) AND A_greater(2)) OR (equal(3) AND equal(2) AND A_greater(1)) OR (equal(3) AND equal(2) AND equal(1) AND A_greater(0)));
		Y_greater <= ((B_greater(3)) OR (equal(3) AND B_greater(2)) OR (equal(3) AND equal(2) AND B_greater(1)) OR (equal(3) AND equal(2) AND equal(1) AND B_greater(0)));
		XY_equal <= equal(3) AND equal(2) AND equal(1) AND equal(0) ;

end Comp4_logic;
	