LIBRARY IEEE;
USE ieee.std_logic_1164.all;

ENTITY mux_4x1 IS
    PORT (
        res_suma, res_resta, res_mult, res_div : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        sel    : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        salida : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
    );
END mux_4x1;

ARCHITECTURE combinacional OF mux_4x1 IS
BEGIN
    salida <= res_suma  WHEN sel = "00" ELSE
              res_resta WHEN sel = "01" ELSE
              res_mult  WHEN sel = "10" ELSE
              res_div;
END combinacional;