
-- Members: Shamanthi Rajagopal and Maria Omer || Lab 4 || Section 204 || Group 6 ||
-- Import packages
library ieee;
use ieee.std_logic_1164.all;


entity PB_inverters is port (
	rst_n				: in	std_logic;   						 -- input reset bits
	rst				: out std_logic;							 -- output reset bit (inverted bit)
 	pb_n_filtered	: in  std_logic_vector (3 downto 0); -- input 4 bit button as vector
	pb					: out	std_logic_vector(3 downto 0)	 -- output 4 bits based on inverted buttons that correspond to it					 
	); 
end PB_inverters;

architecture ckt of PB_inverters is -- defines logic for inverter circuit

begin
rst <= NOT(rst_n);        -- inverts reset
pb <= NOT(pb_n_filtered); -- inverts filtered buttons


end ckt;