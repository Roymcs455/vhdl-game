library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity final is
    port (
        clk   : in std_logic;
        --vga drive
        v_sync  :   out std_logic;
        h_sync  :   out std_logic;
        rgb_out   :   out std_logic_vector(11 downto 0);
        button: in std_logic;
        button2: in std_logic
    );      
end entity final;

architecture behavioral of final is
    component image_generator is
    port (
        clk   : in std_logic;
        v_sync  :   out std_logic;
        h_sync  :   out std_logic;
        x_pos   :   out integer;
        y_pos   :   out integer;
        enabled :   out std_logic;
        rgb_out :   out std_logic_vector(11 downto 0)
    );
    end component;

    signal x_pos : integer range 0 to 640;
    signal y_pos : integer range 0 to 480; 
    signal video_enabled: std_logic;
    signal clock25: std_logic := '0';
    
begin
    imagen: image_generator
        port map (
            clk   => clock25,
            v_sync => v_sync,
            h_sync => h_sync,
            x_pos => x_pos,
            y_pos => y_pos,
            enabled => video_enabled,
            rgb_out => rgb_out         
        );
    process (clk)
    begin
        if rising_edge(clk) then
            clock25 <= not clock25;
        end if;
    end process;
end architecture;