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
        frame   :   out std_logic
    );      
end entity image_generator;

architecture behavioral of image_generator is
    constant h_max : integer := h_pulse+h_fp+h_bp+h_display-1;--799
    constant v_max : integer := v_pulse+v_fp+v_bp+v_display-1;--520
    signal h_count : integer range 0 to h_max :=0;
    signal v_count : integer range 0 to v_max :=0;
    signal clock25: std_logic := '0';
begin
    process (clk)
    begin
        if rising_edge(clk) then
            frame <= '0';
            if h_count < h_max then
                h_count <= h_count +1;
            else
                h_count <= 0;
                if v_count < v_max then
                    v_count <= v_count+1;
                else
                    v_count <= 0;
                    frame<='1';
                end if;
            end if;
        end if;
    end process;
    h_synchronization: process (clk)
    begin
        if rising_edge(clk) then
            if (h_count< h_display+h_fp) or (h_count >h_display+h_fp+h_pulse) then
                h_sync <= '0';
            else
                h_sync <= '1';
            end if;
        end if;
    end process;
    v_synchronization: process (clk)
    begin
        if rising_edge(clk) then
            if (v_count< v_display+v_fp) or (v_count >v_display+v_fp+v_pulse) then
                v_sync <= '0';
            else
                v_sync <= '1';
            end if;
        end if;
    end process;
    process (clk)
    begin
        if rising_edge(clk) then
            if v_count < v_display and h_count < h_display then
                enabled <= '1';
            else
                enabled <= '0';
            end if;
        end if;
    end process;
    process (clk)
    begin
        if rising_edge(clk) then
            if v_count < v_display then
                y_pos <= v_count;
            end if;
            if h_count < h_display then
                x_pos <= h_count;
            end if;
        end if;
    end process;
    
end architecture;