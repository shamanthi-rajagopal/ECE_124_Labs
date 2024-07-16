library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--- Lab session: 204, Team Number: 1, Group Number: 6.
--- Maria Omer
--- Shamanthi Rajagopal


--- variables/inputs/outputs declared in top file
entity LogicalStep_Lab2_top is port (
   clkin_50			: in	std_logic;
	pb_n				: in	std_logic_vector(3 downto 0);
 	sw   				: in  std_logic_vector(7 downto 0); -- The switch inputs
   leds				: out std_logic_vector(7 downto 0); -- for displaying the switch content
   seg7_data 		: out std_logic_vector(6 downto 0); -- 7-bit outputs to a 7-segment
	seg7_char1  	: out	std_logic;				    		-- seg7 digit1 selector
	seg7_char2  	: out	std_logic				    		-- seg7 digit2 selector
	
	--adder_out		: out std_logic_vector(3 downto 0);
	--carry_out		: out	std_logic
	
); 
end LogicalStep_Lab2_top;

architecture SimpleCircuit of LogicalStep_Lab2_top is

--- Component Section ---
------------------------------------------------------------------- 
component SevenSegment port (
		hex   		:  in  std_logic_vector(3 downto 0);   -- The 4 bit data to be displayed
		sevenseg 	:  out std_logic_vector(6 downto 0)    -- 7-bit outputs to a 7-segment
	
); 
end component;
	
component segment7_mux port (
		clk				: in std_logic := '0';
		DIN2				: in std_logic_vector(6 downto 0);
		DIN1				: in std_logic_vector(6 downto 0);
		DOUT				: out std_logic_vector(6 downto 0);
		DIG2				: out std_logic;
		DIG1				: out std_logic
		
   ); 
   end component;
	
--- to invert push buttons	
component PB_Inverters port (
		pb_n : in std_logic_vector(3 downto 0);
		pb   : out std_logic_vector(3 downto 0)
		
   ); 
   end component;

--- logic proccesing for 4 gates and LED switchs	
component Logic_processor port (
		logic_in0, logic_in1 : in std_logic_vector(3 downto 0);
		logic_select         : in std_logic_vector(1 downto 0);
		logic_out            : out std_logic_vector(3 downto 0)
	
   ); 
   end component;

--- Dasiy chained  full bit adder	
component full_adder_4bit port (
		Input_A      : in std_logic_vector(3 downto 0);
		Input_B      : in std_logic_vector(3 downto 0);
		Carry_In     : in std_logic;
		Sum          : out std_logic_vector(3  downto 0);
		Carry_Out    : out std_logic
   ); 
   end component;
	
	--- Add logic 2 to 1 mux here:

	
component two_to_one_mux port(
	logic_in0, logic_in1 : in std_logic_vector(3 downto 0);
	logic_select_mux         : in std_logic;
	logic_out            : out std_logic_vector(3 downto 0)

	
	);
   end component;
	
	
-- Create any signals, or temporary variables to be used
--  std_logic_vector is a signal which can be used for logic operations such as OR, AND, NOT, XOR


	signal hex_A		: std_logic_vector(3 downto 0); --- switch inputs from sw(3 to 0)
	signal hex_B		: std_logic_vector(3 downto 0); --- switch inputs from sw(4 to 7)
	

	signal seg7_A		: std_logic_vector(6 downto 0);
	signal seg7_B	: std_logic_vector(6 downto 0);
	
	signal pb		: std_logic_vector(3 downto 0); --- push buttons
	
	signal full_adder_4bit_hex_sum		: std_logic_vector(3 downto 0); --- full-adder-4-bit sum from daisy chain 
	signal Carry_out_out		: std_logic;   									  --- full-adder-4-bit carry-out from daisy chain
	
	signal concat : std_logic_vector(3 downto 0);  --- concatenated signal with carry_out_out
	
	signal Operand_A : std_logic_vector(3 downto 0); --- output of 2-to-1 mux with Hex_A
	signal Operand_B : std_logic_vector(3 downto 0); --- output of 2-to-1 mux with Hex_B
	
-- Here the circuit begins
begin


 concat <= "000" & Carry_out_out; --- concatenate
 
 -- (We added this from manual)
 
 ---Initialize LED switches to hex_A and hex_B
 hex_A <= sw(3 downto 0);
 hex_B <= sw(7 downto 4);
 
 --(Component HOOKUP)
 
 --- DaisyChained full adder bit ---
 INST0:full_adder_4bit port map (hex_A, hex_B, '0',full_adder_4bit_hex_sum,Carry_out_out); --- take hex A & B as inputs for 4bit full adder and output the sum and carry out.
 
  --- SevenSeg Decoder---
 INST1: SevenSegment port map(Operand_A, seg7_A); --- takes output from 2-to-1 mux and applies with sevenseg decoder (FROM ALU)
 
  --- SevenSeg Decoder---
 INST2: SevenSegment port map(Operand_B, seg7_B); --- takes output from 2-to-1 mux and applies with sevenseg decoder (FROM ALU)
 
 --- Seg7_Mux---
 INST3: segment7_mux port map(clkin_50, seg7_A, seg7_B,seg7_data,seg7_char2,seg7_char1); --- seg7 multiplexer
 
 --- Push buttons ---
 INST4:PB_Inverters port map (pb_n, pb); --- apply inversion logic to input for push buttons
 
 --- Logic_processor ---
 INST5:Logic_processor port map (hex_B, hex_A, pb(1 downto 0), leds(3 downto 0));
 
 --- Two-to-One Mux ---
 INST6: two_to_one_mux port map (hex_B, concat, pb(2), Operand_B);                   --- add hex B and concatenated carry out into multiplexer for Operand_B output
 INST7: two_to_one_mux port map (hex_A, full_adder_4bit_hex_sum, pb(2), Operand_A);  --- add hex A and concatenated carry out into multiplexer for Operand_A output



end SimpleCircuit;


--- Notes for how the display will be on the BOARD:---

--- Left digit LED number display is hex_B and the right is for hex_A
---The LED under switches are for the 4 gates (AND, OR, XOR, XNOR) => Apart of the logic proccessor
---Push button 0 and pb 1 do the same output for the LEDS under switches, but the leds light up based on the gates from logic processor
---Push button 3 adds the 2 digits diplayed from Hex_B & Hex_A.
---LED number displays from (0-9, then A,b,c,d,E,F) (can display from 0 - 99, but also has letters corresponding to 10 - 15).
