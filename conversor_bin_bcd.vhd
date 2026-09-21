LIBRARY IEEE;
USE ieee.std_logic_1164.all;

ENTITY conversor_bin_bcd IS
    PORT (
        bin_in   : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        bcd_unid : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        bcd_dec  : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
    );
END conversor_bin_bcd;

ARCHITECTURE estructural OF conversor_bin_bcd IS
    COMPONENT sumar_3
        PORT (ent : IN STD_LOGIC_VECTOR(3 DOWNTO 0); sal : OUT STD_LOGIC_VECTOR(3 DOWNTO 0));
    END COMPONENT;
    
    SIGNAL c1, c2, c3, c4, c5 : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL d1, d2 : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL ent_u1, ent_u2, ent_u3, ent_u4, ent_u5 : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL ent_d1, ent_d2 : STD_LOGIC_VECTOR(3 DOWNTO 0);

BEGIN
    ent_u1 <= '0' & bin_in(7 DOWNTO 5);
    ent_u2 <= c1(2 DOWNTO 0) & bin_in(4);
    ent_u3 <= c2(2 DOWNTO 0) & bin_in(3);
    ent_u4 <= c3(2 DOWNTO 0) & bin_in(2);
    ent_u5 <= c4(2 DOWNTO 0) & bin_in(1);

    ent_d1 <= '0' & c1(3) & c2(3) & c3(3);
    ent_d2 <= d1(2 DOWNTO 0) & c4(3);

    U1: sumar_3 PORT MAP (ent => ent_u1, sal => c1);
    U2: sumar_3 PORT MAP (ent => ent_u2, sal => c2);
    U3: sumar_3 PORT MAP (ent => ent_u3, sal => c3);
    U4: sumar_3 PORT MAP (ent => ent_u4, sal => c4);
    U5: sumar_3 PORT MAP (ent => ent_u5, sal => c5);

    D_1: sumar_3 PORT MAP (ent => ent_d1, sal => d1);
    D_2: sumar_3 PORT MAP (ent => ent_d2, sal => d2);
    
    bcd_unid <= c5(2 DOWNTO 0) & bin_in(0);
    bcd_dec  <= d2(2 DOWNTO 0) & c5(3);
    
END estructural;
