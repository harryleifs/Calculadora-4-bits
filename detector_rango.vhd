LIBRARY IEEE;
USE ieee.std_logic_1164.all;
ENTITY detector_rango IS
    PORT (
        a, b      : IN STD_LOGIC_VECTOR(3 downto 0);
        modo_hex  : IN STD_LOGIC;
        err_rango : OUT STD_LOGIC
    );
END detector_rango;

ARCHITECTURE combinacional OF detector_rango IS
    SIGNAL err_a, err_b : STD_LOGIC;
BEGIN
    err_a <= '1' WHEN a > "1001" ELSE '0';
    err_b <= '1' WHEN b > "1001" ELSE '0';
    err_rango <= (err_a or err_b) and (not modo_hex);
END combinacional;
