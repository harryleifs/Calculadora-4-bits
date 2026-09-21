LIBRARY IEEE;
USE ieee.std_logic_1164.all;

ENTITY calculadora IS
    PORT (
        -- Entradas de la Terasic DE0
        SW      : IN  STD_LOGIC_VECTOR(9 DOWNTO 0); -- SW[3..0]=A, SW[7..4]=B, SW[9..8]=Operación
        KEY     : IN  STD_LOGIC_VECTOR(2 DOWNTO 0); -- BUTTON2..0 (Modos, activos en bajo)
        
        -- Salidas de la Terasic DE0
        HEX0    : OUT STD_LOGIC_VECTOR(6 DOWNTO 0); -- Display Unidades de resultado
        HEX1    : OUT STD_LOGIC_VECTOR(6 DOWNTO 0); -- Display Decenas de resultado / Signo
        HEX2    : OUT STD_LOGIC_VECTOR(6 DOWNTO 0); -- Display Operando B
        HEX3    : OUT STD_LOGIC_VECTOR(6 DOWNTO 0); -- Display Operando A
        LEDG    : OUT STD_LOGIC_VECTOR(9 DOWNTO 0)  -- LEDs de estado y resultado binario
    );
END calculadora;

ARCHITECTURE estructural OF calculadora IS

    -- 1. Declaración de Componentes 
    
    COMPONENT sumador_restador_4b
        PORT (
            a, b : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
            op   : IN STD_LOGIC;
            suma : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
            cout : OUT STD_LOGIC
        );
    END COMPONENT;

    COMPONENT multiplicador_4x4
        PORT (
            a, b : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
            prod : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT mux_4x1
        PORT (
            res_suma, res_resta, res_mult, res_div : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
            sel    : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
            salida : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT detector_rango
        PORT (
            a, b      : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
            modo_hex  : IN STD_LOGIC;
            err_rango : OUT STD_LOGIC
        );
    END COMPONENT;

    COMPONENT conversor_bin_bcd
        PORT (
            bin_in   : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
            bcd_unid : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
            bcd_dec  : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT decod_7seg
        port (
            bin_in : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
            err    : IN STD_LOGIC;
            seg    : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
        );
    END COMPONENT;

    -- 2. Señales Internas 
    SIGNAL op_a, op_b       : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL sel_op           : STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL res_suma_resta   : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL res_mult         : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL res_suma_ext     : STD_LOGIC_VECTOR(7 DOWNTO 0); -- Extendidos a 8 bits para el MUX
    SIGNAL res_resta_ext    : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL res_div_ext      : STD_LOGIC_VECTOR(7 DOWNTO 0);
    
    SIGNAL resultado_bin    : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL bcd_unidades     : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL bcd_decenas      : STD_LOGIC_VECTOR(3 DOWNTO 0);
    
    SIGNAL modo_prioridad   : STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL bandera_error    : STD_LOGIC;
    SIGNAL acarreo_out      : STD_LOGIC;
	 SIGNAL modo_hex_int : STD_LOGIC;
    
BEGIN

    --Asignación de entradas de los interruptores
    op_a   <= SW(3 DOWNTO 0);
    op_b   <= SW(7 DOWNTO 4);
    sel_op <= SW(9 DOWNTO 8);

    -- Codificador de Prioridad para los modos
    modo_prioridad <= "10" WHEN KEY(2) = '0' ELSE  -- Prueba de display
                      "01" WHEN KEY(1) = '0' ELSE  -- Comparador
                      "00" WHEN KEY(0) = '0' ELSE  -- Hexadecimal
                      "11";                        -- BCD Normal (por defecto)
    modo_hex_int <= '1' WHEN modo_prioridad = "00" ELSE '0';
    -- Instanciación del Detector de Rango
    inst_rango: detector_rango
        PORT MAP (
        a         => op_a,
        b         => op_b,
        modo_hex  => modo_hex_int,
        err_rango => bandera_error
    );

    -- Instanciación Aritmética Concurrente
    -- Suma
    inst_suma: sumador_restador_4b
        PORT MAP (
            a    => op_a,
            b    => op_b,
            op   => '0', -- Suma
            suma => res_suma_resta,
            cout => acarreo_out
        );
    res_suma_ext <= "000" & acarreo_out & res_suma_resta; -- Extensión de bit de acarreo

    -- Resta (Requiere lógica adicional para el complemento a 2 y signo, simplificado aquí)
    inst_resta: sumador_restador_4b
        PORT MAP (
            a    => op_a,
            b    => op_b,
            op   => '1', -- Resta
            suma => res_resta_ext(3 DOWNTO 0),
            cout => OPEN
        );
    res_resta_ext(7 DOWNTO 4) <= "0000";

    -- Multiplicación
    inst_mult: multiplicador_4x4
        PORT MAP (
            a    => op_a,
            b    => op_b,
            prod => res_mult
        );
        
    -- Asignar división a 0 (Demostración opcional)
    res_div_ext <= (OTHERS => '0'); 

    -- Instanciación MUX de Operaciones
    inst_mux: mux_4x1
        PORT MAP (
            res_suma  => res_suma_ext,
            res_resta => res_resta_ext,
            res_mult  => res_mult,
            res_div   => res_div_ext,
            sel       => sel_op,
            salida    => resultado_bin
        );

    -- Banderas de estado a LEDs verdes
    LEDG(7 DOWNTO 0) <= resultado_bin;
    LEDG(8)          <= '0'; -- Bit de signo (Requiere lógica adicional de la resta)
    LEDG(9)          <= bandera_error;

    -- Conversor Binario a BCD
    inst_bcd: conversor_bin_bcd
        PORT MAP (
            bin_in   => resultado_bin,
            bcd_unid => bcd_unidades,
            bcd_dec  => bcd_decenas
        );

    -- Multiplexor de visualización (Simplificado, asume modo BCD normal)
    -- En un diseño completo, este MUX seleccionaría entre bcd_unidades, resultado_bin (en modo Hex) o valores de prueba.

    -- Decodificadores de 7 Segmentos
    decod_operando_a: decod_7seg PORT MAP (bin_in => op_a, err => bandera_error, seg => HEX3);
    decod_operando_b: decod_7seg PORT MAP (bin_in => op_b, err => bandera_error, seg => HEX2);
    decod_res_dec:    decod_7seg PORT MAP (bin_in => bcd_decenas, err => bandera_error, seg => HEX1);
    decod_res_unid:   decod_7seg PORT MAP (bin_in => bcd_unidades, err => bandera_error, seg => HEX0);

END estructural;