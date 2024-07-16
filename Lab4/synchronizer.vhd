-- Members: Shamanthi Rajagopal and Maria Omer || Lab 4 || Section 204 || Group 6 ||

-- Import packages
library ieee;
use ieee.std_logic_1164.all;

-- Declaring synchronizer entity, which takes in asynchronously inputed values through buttons and synchronizes outputs with the clock.
entity synchronizer is
    port (
        clk     : in std_logic; -- clock input
        reset   : in std_logic; -- reset input
        din     : in std_logic; -- data input bit 
        dout    : out std_logic -- dara output bit
    );
end synchronizer;

architecture circuit of synchronizer is
    signal sreg : std_logic_vector(1 downto 0) := "00";
    signal temp : std_logic;

begin

    -- Process to synchronize input din to the clock domain
    sync_process : process (clk)
	 
    begin
		
	-- If clock is on rising edge, then following logic will be excecuted
		if rising_edge(clk) then
			
		-- if reset is set to '1' (is active) then assign '00' to reset register logic
        if reset = '1' then
            sreg <= "00";  
        
		  else --if reset is not '1' (not active), the shift register applies following logic
            
            sreg(1) <= sreg(0); 				-- Shift first register to 2nd
				sreg(0) <= din; 					-- Takes data inputs and assigns value to the first register
        
		  end if;  
	 end if;  
	 end process sync_process;

    -- Assign the synchroniezd output
    dout <= sreg(1);

end circuit;
