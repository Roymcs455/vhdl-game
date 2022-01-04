library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity Game is
    port (
        clk   : in std_logic;
        --vga drive
        v_sync  :   out std_logic;
        h_sync  :   out std_logic;
        rgb_out   :   out std_logic_vector(11 downto 0);
        button: in std_logic;
        button2: in std_logic
    );      
end entity Game;

architecture behavioral of Game is
    component image_generator is
    port (
        clk   : in std_logic;
        v_sync  :   out std_logic;
        h_sync  :   out std_logic;
        x_pos   :   out integer;
        y_pos   :   out integer;
        enabled :   out std_logic
    );
    end component;

    signal x_pos : integer range 0 to 640;
    signal y_pos : integer range 0 to 480; 
    signal enabled: std_logic;
    signal clock25: std_logic := '0';
    
begin
    imagen: image_generator
        port map (
            clk   => clock25,
            v_sync => v_sync,
            h_sync => h_sync,
            x_pos => x_pos,
            y_pos => y_pos,
            enabled => enabled        
        );
    process (clk)
    begin
        if rising_edge(clk) then
            clock25 <= not clock25;
        end if;
    end process;
    process (clk)
    begin
        if rising_edge(clk) then
            if enabled = '1' then
                rgb_out <= X"000";
                if y_pos mod 20 < 10 then
                    if x_pos mod 20 < 10 then
                        rgb_out <=X"000";
                    else
                        rgb_out <=X"FFF";
                    end if;
                else
                    if x_pos mod 20 < 10 then
                        rgb_out <=X"FFF";
                    else
                        rgb_out <=X"000";
                    end if;
                end if;                
            else
                rgb_out<= X"000";
            end if;
        end if;
    end process;
end architecture;