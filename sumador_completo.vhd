LIBRARY IEEE;
USE ieee.std_logic_1164.all;

ENTITY sumador_completo IS
    PORT (
        a, b, cin : IN STD_LOGIC;
        s, cout   : OUT STD_LOGIC
    );
END sumador_completo;

ARCHITECTURE combinacional OF sumador_completo IS
BEGIN
    s <= a XOR b XOR cin;
    cout <= (a AND b) OR (cin AND (a XOR b));
END combinacional;