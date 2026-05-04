library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ControlerCore is 
    Port (
        CLK : in std_logic;
        BTN : in std_logic_vector (3 downto 0);
        SW : in std_logic_vector (3 downto 2);
        LED : out std_logic_vector (3 downto 0);
        LED_R : out std_logic; 
        LED_G : out std_logic;
        LED_B : out std_logic
    );
end ControlerCore;

architecture ControlerCore_Arch of ControlerCore is
    -- IDLE : 00
    -- NEW_ROUND : 01
    -- WAIT_RESPONSE : 10
    -- END_GAME : 11
    signal state : std_logic_vector (1 downto 0) := "00";

    signal my_reset : std_logic := '1';
    signal my_timout : std_logic := '0';
    signal my_enable_logigame : std_logic := '0';
    signal my_enable_lfsr : std_logic := '0';
    signal my_start_timer : std_logic := '0';

    signal my_led : std_logic_vector (2 downto 0) := "000";

    -- Declaration of the components
    component InputHandler is
        Port (
        CLK : in std_logic;
        RESET : in std_logic;
        TIMEOUT : in std_logic;
        LED_COLOR : in std_logic_vector (2 downto 0);
        BTN_R : in std_logic;
        BTN_G : in std_logic;
        BTN_B : in std_logic;
        VALID_HIT : out std_logic
    );
    end component;
    signal my_valid_hit : std_logic;

    component LFSR is
        Port (
        CLK    : in  std_logic;
        RESET  : in  std_logic;
        ENABLE : in  std_logic;
        RND    : out std_logic_vector (3 downto 0)
    );
    end component;
    signal my_rnd : std_logic_vector (3 downto 0);

    component DiviseurCore is
        Port (
        CLK : in  std_logic;
        RESET : in  std_logic;
        FINALCLK : out std_logic   
    );
    end component;
    signal my_finalclk : std_logic;

    component LogiGame is
        Port (
        CLK : in std_logic;
        RESET : in std_logic;
        ENABLE : in std_logic;
        VALID_HIT : in std_logic;
        SCORE : out std_logic_vector (3 downto 0);
        GAME_OVER : out std_logic
    );
    end component;
    signal my_score : std_logic_vector (3 downto 0);
    signal my_game_over : std_logic;

    component MinuteurCore is
        Port (
        RESET : in std_logic;
        START : in std_logic;
        SW_LEVEL : in std_logic_vector (3 downto 2);
        CLK : in std_logic;
        S : out std_logic -- booléan passe à '1' lorsque le délai programmé est atteint
    );
    end component;
    signal my_s : std_logic;


begin

    myComponentInputHandler : InputHandler
    port map (
        CLK => CLK,
        RESET => my_reset,
        TIMEOUT => my_timeout,
        LED, => LED_COLOR,
        BTN_R, => BTN(2),
        BTN_G => BTN(1),
        BTN_B => BTN(0),
        VALID_HIT => my_valid_hit

    );

    myComponentLFSR : LFSR
    port map (
        CLK => my_finalclk,
        RESET => my_reset,
        ENABLE => my_enable,
        RND => my_rnd
    );

    myComponentDiviseurCore : DiviseurCore
    port map (
        CLK => CLK,
        RESET => my_reset,
        FINALCLK => my_finalclk
    );

    myComponentLogiGame : LogiGame
    port map (
        CLK => CLK,
        RESET, => my_reset,
        ENABLE => my_enable,
        VALID_HIT => my_valid_hit,
        SCORE => my_score,
        GAME_OVER => my_game_over
    );

    myComponentMinuteurCore : MinuteurCore
    port map (
        RESET => my_reset,
        START => my_start_timer,
        SW_LEVEL => SW,
        CLK => CLK,
        S => my_s
    );

    Game_proc : process(CLK)
    begin
        if rising_edge(CLK)then
            if state = "00" then
                my_led <= "000";
                LED(3) <= '1';
                if BTN(3) = '1' then
                    state <= "01";
                end if;

            elsif state = "01" then
                -- génère la séquence pseudo aléatoire
                my_reset <= '0';
                my_enable_lfsr <= '1';
                if my_rnd /= "1010" then
                    if my_rnd = "001" then
                        my_led <= "001"; --color blue
                    elsif my_rnd = "010" then
                        my_led <= "010"; --color green
                    elsif my_rdn = "100" then
                        my_led <= "100" then
                    end if;

                    state <= "10";
                    my_enable_lfsr <= '0';
                end if;

            elsif state = "10" then
                -- game loop
                my_enable_logigame <= '1';
                my_start_timer <= '1';
                my_time_out <= '0';

                if my_s = '0' then
                    if my_reset = '1' then
                        my_reset <= '0';
                    end if;

                    if my_valid_hit = '1' then
                        -- continue the game
                        my_time_out <= '0';
                        LED(2 downto 0) <= my_score;
                        my_reset <= '1';
                    end if;
                end if;

                if my_s = '1' then
                    -- stop the game because the user did not press the button fast enough
                    my_time_out <= '1'
                    state <= "11";
                    end if;
                end if;
            

                if my_game_over ='1' then
                    my_enable_logigame <=' 0';
                    state <= "11";
                end if;

            elsif state = "11" then
                -- need to press start to reset the game
                LED(3) <= '1';
                if BTN(3) = '1'then
                    state <= "00";
            end if;
        end if;

        LED_B <= my_led(0);
        LED_G <= my_led(1);
        LED_R <= my_led(2);

    end process;

end ControlerCore_Arch;