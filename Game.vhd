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
    
    component bbs is
        generic (
            p : integer := 191;
            q : integer := 331;
            seed: integer := 752137213213516
        );
        port (
            clk   : in std_logic;
            resultado : out integer
        );
    end component;

    signal rand_num : integer;
    signal x_pos : integer range 0 to 640;
    signal y_pos : integer range 0 to 480; 
    signal enabled: std_logic;
    signal clock25: std_logic := '0';
    signal frame:   std_logic;
    

    constant bird_x_pos: integer :=32;
    constant bird_width: integer :=16;
    signal bird_y_pos : integer range -100 to 520:=320;
    signal bird_y_vel : integer range -100 to 100:=-10;
    constant bird_y_applied: integer :=-10;
    constant bird_y_acc: integer := 1;

    constant brick_movement_speed : integer := 2;--2 pixeles por tick
    

    constant brick_1_2_x_vel : integer := 8;
    
    signal brick_1_2_x_pos: integer:=640;
    signal brick_1_2_width: integer:=48;
    signal brick_1_height:integer:=200;
    signal brick_2_height:integer:=160;

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

    num_gen: bbs port map (
        clk => clk,
        resultado => rand_num
    );
    
    bird_update_process:process (clk)
    variable bird_update: integer range 0 to 50_000_000;
    
    begin
        if rising_edge(clk) then
            
            clock25 <= not clock25;
            
            if bird_update < 2_500_000 then --cada tick sucede en 2500000 ciclos (50 ms)
                bird_update := bird_update+1;
            else
                if brick_1_2_x_pos>0 then
                    brick_1_2_x_pos<= brick_1_2_x_pos-brick_1_2_x_vel;
                else
                    brick_1_2_x_pos<= 639;
                    brick_1_height <= brick_1_height+((rand_num mod 256)-128);
                    brick_2_height <= brick_2_height-((rand_num mod 256)-128);
                    
                end if;

                if bird_y_pos < 480 and bird_y_pos >=0 then
                    bird_y_pos <= bird_y_pos+bird_y_vel;
                    if button ='0' then
                        bird_y_vel <= bird_y_applied;
                    else
                        if bird_y_vel < 20 then
                            bird_y_vel <= bird_y_vel+bird_y_acc;
                        else
                            bird_y_vel <= bird_y_vel;
                        end if;
                    end if;
                elsif bird_y_pos < 0 then
                    bird_y_pos <= 0;
                    bird_y_vel <= 0;
                else
                    bird_y_pos <= 479;
                end if;
                bird_update:=0;
                
            end if;

        end if;
    end process;
    drawing:process (clk)
    begin
        if rising_edge(clk) then
            if enabled = '1' then
                rgb_out <= X"000";
                if x_pos>=bird_x_pos and x_pos <bird_x_pos+bird_width then
                    rgb_out<=X"000";
                    if y_pos>=bird_y_pos and y_pos<bird_y_pos+16 then
                        rgb_out<=X"0FF";
                    end if;
                end if;
                if x_pos>brick_1_2_x_pos-brick_1_2_width and x_pos<brick_1_2_x_pos
                and (y_pos<brick_1_height or y_pos>480-brick_2_height)
                then
                    rgb_out<=X"00F";

                end if;     
            else
                rgb_out<= X"000";
            end if;
        end if;
    end process;
    
    
end architecture;