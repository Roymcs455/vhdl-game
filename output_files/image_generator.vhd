library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity image_generator is
    generic (
        constant v_pulse : integer := 2;
        constant v_fp : integer := 10;
        constant v_bp : integer := 29;
        constant v_display : integer := 480;
        constant h_pulse : integer := 96;
        constant h_fp : integer := 16;
        constant h_bp : integer := 48;
        constant h_display : integer := 640
    );
    port (
        clk   : in std_logic;
        v_sync  :   out std_logic;
        h_sync  :   out std_logic;
        x_pos   :   out integer;
        y_pos   :   out integer;
        enabled :   out std_logic;
        rgb_out :   out std_logic_vector(11 downto 0)
    );      
end entity image_generator;

architecture behavioral of image_generator is
    constant h_max : integer := h_pulse+h_fp+h_bp+h_display-1;--799
    constant v_max : integer := v_pulse+v_fp+v_bp+v_display-1;--520
    signal h_count : integer range 0 to h_max :=0;
    signal v_count : integer range 0 to v_max := 0;
    signal h_pos:integer range 0 to h_display-1;
    signal v_pos:integer range 0 to v_display-1;
    
        

    signal clock25: std_logic := '0';
    
    
begin
    process (clk)
    begin
        if rising_edge(clk) then
            clock25 <= not clock25;
        end if;
    end process;
    process (clock25)
    begin
        if rising_edge(clock25) then
            if h_count = h_max then
                h_count <= 0;
                if v_count = v_max then
                    v_count <= 0;
                else
                    v_count <= v_count +1;
                end if;
            else
                h_count<=h_count+1;
            end if;
        end if;

    end process;
    horizontal_sync :process (clock25)
    begin
        if rising_edge(clock25) then
            if (h_count > (h_display+h_fp)) and (h_count < (h_display+h_fp+h_pulse-1)) then
                h_sync <= '1';
            else
                h_sync <= '0';
            end if;
        end if;
    end process horizontal_sync;
    vertical_sync :process (clock25)
    begin
        if rising_edge(clock25) then
            if v_count > (v_display+v_fp) and v_count < (v_display+v_fp+v_pulse-1) then
                v_sync <= '1';
            else
                v_sync <= '0';
            end if;
        end if;
    end process vertical_sync;
    process (clock25)
    begin
        if rising_edge(clock25) then
            if (h_count > 0 and h_count < 640) and
            (v_count > 0 and v_count < 480) then
                if v_count <160 then
                    rgb_out <= X"F00";
                elsif v_count < 320 then
                    rgb_out <= X"0F0";
                else
                    rgb_out <= X"00F";
                end if;
            else
                rgb_out <= X"000";
            end if;
        end if;
    end process;
end architecture;