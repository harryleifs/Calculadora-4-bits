LIBRARY IEEE;
USE ieee.std_logic_1164.all;

ENTITY calculadora IS
    PORT (
        
        SW      : IN  STD_LOGIC_VECTOR(9 DOWNTO 0); 
        KEY     : IN  STD_LOGIC_VECTOR(2 DOWNTO 0); 
		
        HEX0    : OUT STD_LOGIC_VECTOR(6 DOWNTO 0); 
        HEX1    : OUT STD_LOGIC_VECTOR(6 DOWNTO 0); 
        HEX2    : OUT STD_LOGIC_VECTOR(6 DOWNTO 0); 
        HEX3    : OUT STD_LOGIC_VECTOR(6 DOWNTO 0); 
        LEDG    : OUT STD_LOGIC_VECTOR(9 DOWNTO 0)  
    );
END calculadora;

ARCHITECTURE estructural OF calculadora IS 
    
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

    SIGNAL op_a, op_b       : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL sel_op           : STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL res_suma_resta   : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL res_mult         : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL res_suma_ext     : STD_LOGIC_VECTOR(7 DOWNTO 0); 
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

    
    op_a   <= SW(3 DOWNTO 0);
    op_b   <= SW(7 DOWNTO 4);
    sel_op <= SW(9 DOWNTO 8);
    modo_prioridad <= "10" WHEN KEY(2) = '0' ELSE  
                      "01" WHEN KEY(1) = '0' ELSE  
                      "00" WHEN KEY(0) = '0' ELSE  
                      "11";                        
    modo_hex_int <= '1' WHEN modo_prioridad = "00" ELSE '0';
						  
    inst_rango: detector_rango
        PORT MAP (
        a         => op_a,
        b         => op_b,
        modo_hex  => modo_hex_int,
        err_rango => bandera_error
    );
		
    inst_suma: sumador_restador_4b
        PORT MAP (
            a    => op_a,
            b    => op_b,
            op   => '0', 
            suma => res_suma_resta,
            cout => acarreo_out
        );
    res_suma_ext <= "000" & acarreo_out & res_suma_resta;

    inst_resta: sumador_restador_4b
        PORT MAP (
            a    => op_a,
            b    => op_b,
            op   => '1', 
            suma => res_resta_ext(3 DOWNTO 0),
            cout => OPEN
        );
    res_resta_ext(7 DOWNTO 4) <= "0000";

    inst_mult: multiplicador_4x4
        PORT MAP (
            a    => op_a,
            b    => op_b,
            prod => res_mult
        );
        
    
    res_div_ext <= (OTHERS => '0'); 
    inst_mux: mux_4x1
        PORT MAP (
            res_suma  => res_suma_ext,
            res_resta => res_resta_ext,
            res_mult  => res_mult,
            res_div   => res_div_ext,
            sel       => sel_op,
            salida    => resultado_bin
        );
		
    LEDG(7 DOWNTO 0) <= resultado_bin;
    LEDG(8)          <= '0';
    LEDG(9)          <= bandera_error;

    inst_bcd: conversor_bin_bcd
        PORT MAP (
            bin_in   => resultado_bin,
            bcd_unid => bcd_unidades,
            bcd_dec  => bcd_decenas
        );
    decod_operando_a: decod_7seg PORT MAP (bin_in => op_a, err => bandera_error, seg => HEX3);
    decod_operando_b: decod_7seg PORT MAP (bin_in => op_b, err => bandera_error, seg => HEX2);
    decod_res_dec:    decod_7seg PORT MAP (bin_in => bcd_decenas, err => bandera_error, seg => HEX1);
    decod_res_unid:   decod_7seg PORT MAP (bin_in => bcd_unidades, err => bandera_error, seg => HEX0);

END estructural;
