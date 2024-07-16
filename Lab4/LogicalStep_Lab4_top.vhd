-- Members: Shamanthi Rajagopal and Maria Omer || Lab 4 || Section 204 || Group 6 ||
-- Import packages
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY LogicalStep_Lab4_top IS
   PORT
	(
    clkin_50	    : in	std_logic;							-- The 50 MHz FPGA Clockinput
	rst_n			: in	std_logic;							-- The RESET input (ACTIVE LOW)
	pb_n			: in	std_logic_vector(3 downto 0); -- The push-button inputs (ACTIVE LOW)
 	sw   			: in  	std_logic_vector(7 downto 0); -- The switch inputs
    leds			: out 	std_logic_vector(7 downto 0);	-- for displaying the the lab4 project details
	-------------------------------------------------------------
	-- you can add temporary output ports here if you need to debug your design 
	-- or to add internal signals for your simulations
	-------------------------------------------------------------
	
   seg7_data 	: out 	std_logic_vector(6 downto 0); -- 7-bit outputs to a 7-segment
	seg7_char1  : out	std_logic;							-- seg7 digi selectors
	seg7_char2  : out	std_logic;							-- seg7 digi selectors
	--SIMMULATION VARIABLES
	sim_sm_clk, sim_blink_signal, sim_ns_green, sim_ns_amber, sim_ns_red, sim_ew_green, sim_ew_amber, sim_ew_red : out std_logic
	);
END LogicalStep_Lab4_top;

-- defines circuit logic for the big overall circuit
ARCHITECTURE SimpleCircuit OF LogicalStep_Lab4_top IS
   component segment7_mux port (
             clk        	: in  	std_logic := '0';
			 DIN2 			: in  	std_logic_vector(6 downto 0);	--bits 6 to 0 represent segments G,F,E,D,C,B,A
			 DIN1 			: in  	std_logic_vector(6 downto 0); --bits 6 to 0 represent segments G,F,E,D,C,B,A
			 DOUT			: out	std_logic_vector(6 downto 0);
			 DIG2			: out	std_logic;
			 DIG1			: out	std_logic
   );
   end component;

-- defines clock generator component
   component clock_generator port (
			sim_mode			: in boolean;
			reset				: in std_logic;
            clkin      		    : in  std_logic;
			sm_clken			: out	std_logic;
			blink		  		: out std_logic
  );
   end component;

-- defimnes pb_filters component
    component pb_filters port (
			clkin				: in std_logic;
			rst_n				: in std_logic;
			rst_n_filtered	    : out std_logic;
			pb_n				: in  std_logic_vector (3 downto 0);
			pb_n_filtered	    : out	std_logic_vector(3 downto 0)							 
 );
   end component;

-- defines pb_inverters component
	component pb_inverters port (
			rst_n				: in  std_logic;
			rst				    : out	std_logic;							 
			pb_n_filtered	    : in  std_logic_vector (3 downto 0);
			pb					: out	std_logic_vector(3 downto 0)							 
  );
   end component;

-- defines synchronizer component
	component synchronizer port(
			clk					: in std_logic;
			reset					: in std_logic;
			din					: in std_logic;
			dout					: out std_logic
  );
   end component; 

-- defines holding register component
	component holding_register port (
			clk					: in std_logic;
			reset					: in std_logic;
			register_clr		: in std_logic;
			din					: in std_logic;
			dout					: out std_logic
  );
  end component;			
  
 -- Define state machine
 component State_Machine Port(
			 clk_input, reset, sm_clk, blink_signal, ns_request, ew_request		: in std_logic;
			 ns_green, ns_amber, ns_red, ew_green, ew_amber, ew_red					: out std_logic;
			 ns_crossing, ew_crossing															: out std_logic;
			 fourbit_state_num																: out std_logic_vector(3 downto 0); 
			 ns_clear, ew_clear																	: out std_logic 
 );
 end component; 
  
-- defined signals used for instances  
----------------------------------------------------------------------------------------------------
	CONSTANT	sim_mode								: boolean := TRUE;  -- set to FALSE for LogicalStep board downloads -- set to TRUE for SIMULATIONS
	
	SIGNAL rst, rst_n_filtered, synch_rst			    					: std_logic; 							  -- signal for reset values
	SIGNAL sm_clk, blink_signal								 					: std_logic; 							  -- signal blinking and enables
	SIGNAL pb_n_filtered, pb								 					:	 std_logic_vector(3 downto 0);  -- signal for holding button values
	
	SIGNAL ew_request, ns_request			  			    					: std_logic;							  -- signal for crossing request
	SIGNAL ew_green, ew_amber, ew_red, ns_green, ns_amber, ns_red  : std_logic; 							  -- signal for traffic light values
	SIGNAL ew_crossing, ns_crossing					    					: std_logic;							  -- signal for active crossing values
	SIGNAL ew_lights, ns_lights								 				: std_logic_vector(6 downto 0);    -- signal for concatenated traffic light values
	SIGNAL ew_clear, ns_clear								 					: std_logic; 							  -- signal for clear values
	SIGNAL ew_out, ns_out		    					: std_logic;	                                      -- signal for traffic light output
	
	
BEGIN
----------------------------------------------------------------------------------------------------
-- FOR WAVE FORMS --


INST0: pb_filters		   port map (clkin_50, rst_n, rst_n_filtered, pb_n, pb_n_filtered);
INST1: pb_inverters		port map (rst_n_filtered, rst, pb_n_filtered, pb);
INST2: clock_generator 	port map (sim_mode, synch_rst, clkin_50, sm_clk, blink_signal); -- generates the clock signal


INST3: synchronizer     port map (clkin_50,synch_rst, rst, synch_rst);	-- the synchronizer is also reset by synch_rst.
INST4: synchronizer     port map (clkin_50,synch_rst, pb(1), ew_request);	-- sychronizer


INST5: holding_register port map (clkin_50, synch_rst, ew_clear, ew_request, ew_out);
leds(3) <= ew_out;

INST6: synchronizer     port map (clkin_50,synch_rst, pb(0), ns_request);	-- sychronizer
INST7: holding_register port map (clkin_50, synch_rst, ns_clear, ns_request, ns_out);
leds(1) <= ns_out;

INST8: State_Machine    port map (clkin_50, synch_rst, sm_clk, blink_signal, ns_out, ew_out, ns_green, ns_amber, ns_red, ew_green, ew_amber, ew_red, ns_crossing, ew_crossing, leds(7 downto 4), ns_clear, ew_clear);

leds(0) <= ns_crossing;
leds(2) <= ew_crossing;

ns_lights(6 downto 0) <= ns_amber & "00" & ns_green & "00" & ns_red;
ew_lights(6 downto 0) <= ew_amber & "00" & ew_green & "00" & ew_red;

INST9: segment7_mux port map (clkin_50, ns_lights, ew_lights, seg7_data, seg7_char2, seg7_char1);

-- Variables for simmulation

sim_sm_clk <= sm_clk;
sim_blink_signal <= blink_signal;
sim_ns_green <= ns_green; 
sim_ns_amber <= ns_amber;
sim_ns_red <= ns_red;
sim_ew_green <= ew_green;
sim_ew_amber <= ew_amber;
sim_ew_red <= ew_red;





END SimpleCircuit;
