library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_ControlerCore is
-- Empty entity for testbench
end tb_ControlerCore;

architecture behavior of tb_ControlerCore is 

    component ControlerCore
    Port (
        CLK   : in std_logic;
        BTN   : in std_logic_vector (3 downto 0);
        SW    : in std_logic_vector (3 downto 2);
        LED   : out std_logic_vector (3 downto 0);
        LED_R : out std_logic; 
        LED_G : out std_logic;
        LED_B : out std_logic
    );
    end component;

    -- Inputs
    signal clk : std_logic := '0';
    signal btn : std_logic_vector(3 downto 0) := "0000";
    signal sw  : std_logic_vector(3 downto 2) := "00";

    -- Outputs
    signal led   : std_logic_vector(3 downto 0);
    signal led_r : std_logic;
    signal led_g : std_logic;
    signal led_b : std_logic;

    -- Timings
    constant clk_period : time := 10 ns;
    constant human_reaction : time := 50 us; 

begin

    uut: ControlerCore port map (
        CLK => clk, 
        BTN => btn, 
        SW => sw,
        LED => led, 
        LED_R => led_r, 
        LED_G => led_g, 
        LED_B => led_b
    );

    -- Clock generation process (100MHz)
    clk_process :process
    begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;

    -- Stimulus process
    stim_proc: process
    begin		
        -- Initialize System
        sw <= "00"; 
        wait for 100 ns;	

        -- ==========================================
        -- GAME 1: START
        -- ==========================================
        btn(3) <= '1';
        wait for clk_period * 2;
        btn(3) <= '0';

        -- WIN 3 ROUNDS
        for i in 1 to 3 loop
            while (led_r = '0' and led_g = '0' and led_b = '0') loop
                wait for clk_period;
            end loop;
            
            wait for human_reaction;
            
            if led_r = '1' then
                btn(2) <= '1'; 
            elsif led_g = '1' then
                btn(1) <= '1'; 
            elsif led_b = '1' then
                btn(0) <= '1'; 
            end if;
            
            while (led_r = '1' or led_g = '1' or led_b = '1') loop
                wait for clk_period;
            end loop;
            
            btn(2 downto 0) <= "000";
            wait for clk_period * 5;
        end loop;

        -- LOSE ROUND 4 INTENTIONALLY
        while (led_r = '0' and led_g = '0' and led_b = '0') loop
            wait for clk_period;
        end loop;
        
        wait for human_reaction; -- Human freezes!
        
        while led(3) = '0' loop  -- Wait for Game Over
            wait for clk_period;
        end loop;

        -- Observe the Game Over state for 150us before retrying
        wait for 150 us;

        -- ==========================================
        -- GAME 2: RETRY
        -- ==========================================
        
        -- Press Start Button again to reset and retry
        btn(3) <= '1';
        wait for clk_period * 2;
        btn(3) <= '0';

        -- WIN 2 ROUNDS TO PROVE IT RESET
        for i in 1 to 2 loop
            while (led_r = '0' and led_g = '0' and led_b = '0') loop
                wait for clk_period;
            end loop;
            
            wait for human_reaction;
            
            if led_r = '1' then
                btn(2) <= '1'; 
            elsif led_g = '1' then
                btn(1) <= '1'; 
            elsif led_b = '1' then
                btn(0) <= '1'; 
            end if;
            
            while (led_r = '1' or led_g = '1' or led_b = '1') loop
                wait for clk_period;
            end loop;
            
            btn(2 downto 0) <= "000";
            wait for clk_period * 5;
        end loop;
        
    end process;

end behavior;