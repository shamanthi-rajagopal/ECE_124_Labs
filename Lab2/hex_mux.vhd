library ieee;
use ieee.std_logic_1164.all;

--- Lab session: 204, Team Number: 1, Group Number: 6.
--- Maria Omer
--- Shamanthi Rajagopal


--- used variables/inputs/outputs
entity hex_mux is
port (
	hex_num3,hex_num2,hex_num1,hex_num0 : in std_logic_vector(3 downto 0);
	mux_select                          : in std_logic_vector(1 downto 0);
	hex_out                             : out std_logic_vector(3 downto 0) -- hex output
);

end hex_mux;

architecture mux_logic of hex_mux is 

begin 

-- for the multiplexing of four hex input busses
--- logic for hex_mux
with mux_select(1 downto 0) select
hex_out <= hex_num0 when "00",
			  hex_num1 when "01",
			  hex_num2 when "10",
			  hex_num0 when "11";
			  
--- when mux_select is 00, the hex_out will be the hex_num0, when mux_select is 01, the hex_out will be the hex_num1,
--- when mux_select is 10, the hex_out will be the hex_num2, when mux_select is 11, the hex_out will be the hex_num3,  
	
end mux_logic;
	