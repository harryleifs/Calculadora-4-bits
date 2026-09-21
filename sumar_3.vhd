LIBRARY IEEE;
USE ieee.std_logic_1164.all;

ENTITY sumar_3 IS
    PORT (
        ent : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        sal : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
    );
end sumar_3;

ARCHITECTURE combinacional OF sumar_3 IS
BEGIN
    PROCESS(ent)
    BEGIN
        CASE ent IS
            WHEN "0101" => sal <= "1000"; 
            WHEN "0110" => sal <= "1001"; 
            WHEN "0111" => sal <= "1010"; 
            WHEN "1000" => sal <= "1011"; 
            WHEN "1001" => sal <= "1100"; 
            WHEN OTHERS => sal <= ent;    
        END CASE;
    END PROCESS;
END combinacional;
