LIBRARY IEEE;
USE ieee.std_logic_1164.all;

ENTITY sumador_restador_4b IS
    PORT (
        a    : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
        b    : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
        op   : IN  STD_LOGIC;
        suma : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        cout : OUT STD_LOGIC
    );
END sumador_restador_4b;

ARCHITECTURE estructural OF sumador_restador_4b IS
    COMPONENT sumador_completo
        PORT (
            a, b, cin : IN STD_LOGIC;
            s, cout   : OUT STD_LOGIC
        );
    END COMPONENT;

    SIGNAL bx : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL c  : STD_LOGIC_VECTOR(4 DOWNTO 0);
BEGIN
    -- Compuertas XOR para invertir 'b' si op='1' (resta)
    bx(0) <= b(0) XOR op;
    bx(1) <= b(1) XOR op;
    bx(2) <= b(2) XOR op;
    bx(3) <= b(3) XOR op;

    c(0) <= op; -- El acarreo inicial es 1 para suma en complemento a 2

    -- Instanciación de los 4 sumadores completos
    fa0: sumador_completo PORT MAP (a(0), bx(0), c(0), suma(0), c(1));
    fa1: sumador_completo PORT MAP (a(1), bx(1), c(1), suma(1), c(2));
    fa2: sumador_completo PORT MAP (a(2), bx(2), c(2), suma(2), c(3));
    fa3: sumador_completo PORT MAP (a(3), bx(3), c(3), suma(3), c(4));

    cout <= c(4);
END estructural;