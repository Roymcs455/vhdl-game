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
        enabled :   out std_logic;
        frame   :   out std_logic
    );
    end component;

    signal x_pos : integer range 0 to 640;
    signal y_pos : integer range 0 to 480; 
    signal enabled: std_logic;
    signal clock25: std_logic := '0';
    signal frame:   std_logic;
    
    signal bird_y_pos : integer range 0 to 480:=320;
    signal bird_y_vel : integer range -100 to 100:=-10;
    constant bird_y_applied: integer :=-20;
    constant bird_y_acc: integer := 1;

begin
    imagen: image_generator
        port map (
            clk   => clock25,
            v_sync => v_sync,
            h_sync => h_sync,
            x_pos => x_pos,
            y_pos => y_pos,
            enabled => enabled,
            frame => frame
        );
    bird_update_process:process (clk)
    variable bird_update: integer range 0 to 50_000_000;
    begin
        if rising_edge(clk) then
            clock25 <= not clock25;
            if bird_update < 3_000_000 then
                bird_update := bird_update+1;
            else
                if bird_y_pos < 480 then
                    bird_y_pos <= bird_y_pos+bird_y_vel;
                    if button ='0' then
                        bird_y_vel <= bird_y_applied;
                    else
                        if bird_y_vel < 10 then
                            bird_y_vel <= bird_y_vel+bird_y_acc;
                        else
                            bird_y_vel <= bird_y_vel;
                        end if;
                    end if;
                elsif bird_y_pos <= 0 then
                    bird_y_pos <= 0;
                else
                    bird_y_pos <= 479;
                end if;
                bird_update:=0;                
            end if;

        end if;
    end process;
    process (clk)
    begin
        if rising_edge(clk) then
            if enabled = '1' then
                rgb_out <= X"000";
                if x_pos>=16 and x_pos <32 then
                    rgb_out<=X"000";
                    if y_pos>=bird_y_pos and y_pos<bird_y_pos+16 then
                        rgb_out<=X"FF0";
                    end if;
                end if;               
            else
                rgb_out<= X"000";
            end if;
        end if;
    end process;
    
    
end architecture;