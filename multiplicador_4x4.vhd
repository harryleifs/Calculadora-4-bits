LIBRARY IEEE;
USE ieee.std_logic_1164.all;

ENTITY multiplicador_4x4 IS
    PORT (
        a, b : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
        prod : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
    );
END multiplicador_4x4;

ARCHITECTURE estructural OF multiplicador_4x4 IS
    COMPONENT sumador_restador_4b
        PORT (a, b : IN STD_LOGIC_VECTOR(3 DOWNTO 0); op : IN STD_LOGIC; suma : OUT STD_LOGIC_VECTOR(3 DOWNTO 0); cout : OUT STD_LOGIC);
    END COMPONENT;

    SIGNAL p0, p1, p2, p3 : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL s1, s2, s3     : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL c1, c2, c3     : STD_LOGIC;
    SIGNAL a1, a2, a3     : STD_LOGIC_VECTOR(3 DOWNTO 0);
begin
    
    p0 <= (a(3) AND b(0)) & (a(2) AND b(0)) & (a(1) AND b(0)) & (a(0) AND b(0));
    p1 <= (a(3) AND b(1)) & (a(2) AND b(1)) & (a(1) AND b(1)) & (a(0) AND b(1));
    p2 <= (a(3) AND b(2)) & (a(2) AND b(2)) & (a(1) AND b(2)) & (a(0) AND b(2));
    p3 <= (a(3) AND b(3)) & (a(2) AND b(3)) & (a(1) AND b(3)) & (a(0) AND b(3));
    prod(0) <= p0(0);

    a1 <= '0' & p0(3 DOWNTO 1);
    sum1: sumador_restador_4b PORT MAP (a => a1, b => p1, op => '0', suma => s1, cout => c1);
    prod(1) <= s1(0);

    a2 <= c1 & s1(3 DOWNTO 1);
    sum2: sumador_restador_4b PORT MAP (a => a2, b => p2, op => '0', suma => s2, cout => c2);
    prod(2) <= s2(0);

    a3 <= c2 & s2(3 DOWNTO 1);
    sum3: sumador_restador_4b PORT MAP (a => a3, b => p3, op => '0', suma => s3, cout => c3);
    prod(6 DOWNTO 3) <= s3;
    prod(7)          <= c3;
END estructural;
