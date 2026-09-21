LIBRARY IEEE;
USE ieee.std_logic_1164.all;

ENTITY tb_calculadora IS
END tb_calculadora;

ARCHITECTURE sim OF tb_calculadora IS
    -- 1. Declaración exacta de tu top-level
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

    -- 2. Señales internas para simular los pines
    SIGNAL tb_SW   : STD_LOGIC_VECTOR(9 DOWNTO 0) := (OTHERS => '0');
    SIGNAL tb_KEY  : STD_LOGIC_VECTOR(2 DOWNTO 0) := "111"; -- 111 = Modo BCD normal
    SIGNAL tb_HEX0 : STD_LOGIC_VECTOR(6 DOWNTO 0);
    SIGNAL tb_HEX1 : STD_LOGIC_VECTOR(6 DOWNTO 0);
    SIGNAL tb_HEX2 : STD_LOGIC_VECTOR(6 DOWNTO 0);
    SIGNAL tb_HEX3 : STD_LOGIC_VECTOR(6 DOWNTO 0);
    SIGNAL tb_LEDG : STD_LOGIC_VECTOR(9 DOWNTO 0);

BEGIN
    -- 3. Instanciación
    uut: calculadora PORT MAP (
        SW   => tb_SW,
        KEY  => tb_KEY,
        HEX0 => tb_HEX0,
        HEX1 => tb_HEX1,
        HEX2 => tb_HEX2,
        HEX3 => tb_HEX3,
        LEDG => tb_LEDG
    );

    -- 4. Inyección de estímulos
    stim_proc: PROCESS
    BEGIN
        -- Mantener modo BCD por defecto
        tb_KEY <= "111";

        -- PRUEBA 1: Suma (Operación "00")
        -- A = 3 ("0011"), B = 2 ("0010")
        -- SW(9..8)="00", SW(7..4)="0010", SW(3..0)="0011" -> SW="0000100011"
        tb_SW <= "0000100011";
        WAIT FOR 50 ns;

        -- PRUEBA 2: Resta (Operación "01")
        -- A = 6 ("0110"), B = 2 ("0010")
        -- SW(9..8)="01", SW(7..4)="0010", SW(3..0)="0110" -> SW="0100100110"
        tb_SW <= "0100100110";
        WAIT FOR 50 ns;

        -- PRUEBA 3: Multiplicación (Operación "10")
        -- A = 3 ("0011"), B = 3 ("0011")
        -- SW(9..8)="10", SW(7..4)="0011", SW(3..0)="0011" -> SW="1000110011"
        tb_SW <= "1000110011";
        WAIT FOR 50 ns;

        WAIT;
    END PROCESS;
END sim;