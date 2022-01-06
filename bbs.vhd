library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

--numeros primos usados: 191 331
entity bbs is
    generic (
        p : integer := 191;
        q : integer := 331;
        seed: integer := 752137213213516
    );
    port (
        clk   : in std_logic;
        resultado: out integer        
    );
end entity bbs;

architecture rtl of bbs is
    constant n : integer := p*q;
    signal x_i_1 : integer:=n;
    signal x_i : integer;
begin
    process (clk)
    begin
        if rising_edge(clk) then
            x_i <= x_i_1*x_i_1 mod n;--algoritmo blum blum shub: x_i = x_i(anterior)^2 mod n,
            --n es multiplo de dos numeros enteros;
            x_i_1 <= x_i; 
        end if;
    end process;
    resultado <= x_i;

    

end architecture;