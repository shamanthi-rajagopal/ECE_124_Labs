-- Members: Shamanthi Rajagopal and Maria Omer || Lab 4 || Section 204 || Group 6 ||

-- Import packages
library ieee;
use ieee.std_logic_1164.all;

-- Declaring holding register entity, which holds input values until logic gate conditions are met.

entity holding_register is port (

			clk					: in std_logic; -- Clock input bit
			reset				: in std_logic;    -- Reset input bit
			register_clr		: in std_logic; -- Register clear input bit
			din					: in std_logic; -- Data input bit
			dout				: out std_logic    -- Data output bit
  );
 end holding_register;
 
 -- Define the circuit logic for holding register
 
 architecture circuit of holding_register is

	Signal sreg				: std_logic; -- signal to hold the register values
	Signal input_logic	: std_logic; -- signal to hold/evaluate input logic


BEGIN

-- Does input logic and applies to input_logic signal
	input_logic <= (sreg OR din) AND (NOT (reset or register_clr));
 
-- Syncing thr holding register based on the changes of the clk entity
	sync_system: process(clk)
	
		BEGIN
			
			-- If clock is on rising edge -> applies output for signal and output of holding register
			if(rising_edge(clk)) then 
				
				-- Applies input_logic value to the register signal and output for holding register
					sreg <= input_logic;
					dout <= input_logic;
			
			end if;		
		end process;
end;