
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_unsigned.all;		--Insere-se todos os componentes utilizados no circuito para que não haja a necessidade de declará-lo em cada código
use IEEE.STD_LOGIC_arith.all;

package my_package is
 
component Data_path is
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           x : in  STD_LOGIC_VECTOR(31 downto 0);
           y : in  STD_LOGIC_VECTOR(31 downto 0);
           start_init : in  STD_LOGIC;
           done : out  STD_LOGIC;
           z : out  STD_LOGIC_VECTOR(31 downto 0));
end component;



component Control_path is
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           end_mul : in  STD_LOGIC;
           start : in  STD_LOGIC;
	   done : out  STD_LOGIC;
           start_init : out  STD_LOGIC);
end component;


component multiplier  is
	port (
		clk, rst		: in std_logic;
		start			: in std_logic;
		A, B			: in std_logic_vector(23 downto 0);		
		Result			: out std_logic_vector(47 downto 0);
		done			: out std_logic
	);
		
end component;

component ControlPath  is
	port (
		clk, rst		: in std_logic;
		start, flagEnd	: in std_logic;
		wrACC           : out std_logic;
        wrCount         : out std_logic;
        decCount        : out std_logic;	
		done			: out std_logic	
	);
		
end component;

component DataPath  is
    generic (
        WIDTH       : integer := 24
    );
    port (
        clk, rst        : in std_logic;
        A, B            : in std_logic_vector(WIDTH-1 downto 0);
        wrACC           : in std_logic;
        wrCount         : in std_logic;
        decCount        : in std_logic;
	start		: in std_logic;
       
        Result          : out std_logic_vector((WIDTH*2)-1 downto 0);
        flagEnd         : out std_logic
    );
        
end component;



component RegisterNbits is
	generic (
		WIDTH		: integer := 24;
		INIT_VALUE	: integer := 0 
	);
	port (  
		clk	: in std_logic;
		rst	: in std_logic; 
		ce		: in std_logic;
		d 		: in  std_logic_vector (WIDTH-1 downto 0);
		q 		: out std_logic_vector (WIDTH-1 downto 0)
	);
end component;



component fulladd IS
	PORT ( Cin, x, y : IN STD_LOGIC ;
		s, Cout : OUT STD_LOGIC ) ;
END component ;


component adder IS
	PORT (Cin : IN STD_LOGIC ;
		X, Y : IN STD_LOGIC_VECTOR(8 DOWNTO 0) ;
		S : OUT STD_LOGIC_VECTOR(8 DOWNTO 0)) ;
END component;

component adder23 IS
	PORT (Cin : IN STD_LOGIC ;
		X, Y : IN STD_LOGIC_VECTOR(22 DOWNTO 0) ;
		S : OUT STD_LOGIC_VECTOR(22 DOWNTO 0) ) ;
END component ;

component adder48 IS
	PORT (Cin : IN STD_LOGIC ;
		X, Y : IN STD_LOGIC_VECTOR(47 DOWNTO 0) ;
		S : OUT STD_LOGIC_VECTOR(47 DOWNTO 0) ) ;
END component ;

end my_package;

