library ieee;
use ieee.std_logic_1164.all;


--- Lab session: 204, Team Number: 1, Group Number: 6.
--- Maria Omer
--- Shamanthi Rajagopal

entity two_to_one_mux is
port (
	logic_in0, logic_in1 : in std_logic_vector(3 downto 0);
	logic_select_mux         : in std_logic;
	logic_out            : out std_logic_vector(3 downto 0)
);

end two_to_one_mux;

architecture LogicMux of two_to_one_mux is 

begin 

-- for the multiplexing of four hex input busses
with logic_select_mux select
logic_out <= logic_in0 when '0',
			    logic_in1 when '1';

--- When the select is 0, logic_in0 will be the output, when the select_n is 1, logic_in1 will be the output.
	
end LogicMux;
	