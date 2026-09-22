LIBRARY IEEE;
USE ieee.std_logic_1164.all;

ENTITY full_adder IS
    PORT (
        a, b, cin : IN STD_LOGIC;
        s, cout   : OUT STD_LOGIC
    );
END full_adder;

ARCHITECTURE combinacional OF full_adder IS
BEGIN
    s <= a XOR b XOR cin;
    cout <= (a AND b) OR (cin AND (a XOR b));
END combinacional; 
