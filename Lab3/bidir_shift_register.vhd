library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

Entity bidir_shift_register is port
  (
       CLK          : in std_logic := '0';
		 RESET        : in std_logic := '0';
		 CLK_EN       : in std_logic := '0';
		 LEFT0_RIGHT1 : in std_logic :='0';
		 REG_BITS     : out std_logic_vector (7 downto 0)
	);
	end Entity;
	
	ARCHITECTURE one OF bidir_shift_register IS
	
	Signal sreg      : std_logic_vector (7 downto 0);
	
BEGIN

process (CLK) is 
begin 
   if (rising_edge(CLK)) then
	
	   if(RESET = '1') then
		     sreg <= "00000000";
			  
	   elsif (CLK_EN = '1') then 
		
		   if (LEFT0_Right1 = '1') then
			
			  sreg (7 downto 0) <= '1' & sreg(7 downto 1); -- right-shift of bits
			  
			else 
			
			  sreg (7 downto 0) <= sreg(6 downto 0) & '0'; -- left-shift of bits
			  
			end if;
			
	   end if;
		
	end if;
	
	REG_BITS <= sreg;
	
end process;

END one;