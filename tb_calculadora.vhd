LIBRARY IEEE;
USE ieee.std_logic_1164.all;

ENTITY tb_calculadora IS
END tb_calculadora;

ARCHITECTURE sim OF tb_calculadora IS
    
    COMPONENT calculadora
        PORT (
            SW   : IN  STD_LOGIC_VECTOR(9 DOWNTO 0);
            KEY  : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
            HEX0 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
            HEX1 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
            HEX2 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
            HEX3 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
            LEDG : OUT STD_LOGIC_VECTOR(9 DOWNTO 0)
        );
    END COMPONENT;
    
    SIGNAL tb_SW   : STD_LOGIC_VECTOR(9 DOWNTO 0) := (OTHERS => '0');
    SIGNAL tb_KEY  : STD_LOGIC_VECTOR(2 DOWNTO 0) := "111"; 
    SIGNAL tb_HEX0 : STD_LOGIC_VECTOR(6 DOWNTO 0);
    SIGNAL tb_HEX1 : STD_LOGIC_VECTOR(6 DOWNTO 0);
    SIGNAL tb_HEX2 : STD_LOGIC_VECTOR(6 DOWNTO 0);
    SIGNAL tb_HEX3 : STD_LOGIC_VECTOR(6 DOWNTO 0);
    SIGNAL tb_LEDG : STD_LOGIC_VECTOR(9 DOWNTO 0);

BEGIN
    
    uut: calculadora PORT MAP (
        SW   => tb_SW,
        KEY  => tb_KEY,
        HEX0 => tb_HEX0,
        HEX1 => tb_HEX1,
        HEX2 => tb_HEX2,
        HEX3 => tb_HEX3,
        LEDG => tb_LEDG
    );
        
    stim_proc: PROCESS
    BEGIN
        tb_KEY <= "111";
        tb_SW <= "0000100011";
        WAIT FOR 50 ns;
        tb_SW <= "0100100110";
        WAIT FOR 50 ns;
        tb_SW <= "1000110011";
        WAIT FOR 50 ns;

        WAIT;
    END PROCESS;
END sim;
