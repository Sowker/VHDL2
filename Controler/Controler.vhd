library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ControlerCore is 
    Port (
        CLK : in std_logic;
        BTN : in std_logic_vector (3 downto 0);
        SW  : in std_logic_vector (3 downto 2);
        LED : out std_logic_vector (3 downto 0);
        LED_R : out std_logic; 
        LED_G : out std_logic;
        LED_B : out std_logic
    );
end ControlerCore;

architecture ControlerCore_Arch of ControlerCore is
    type stateGame is (IDLE, NEW_ROUND, RND, WAIT_RESPONSE, END_GAME);
    signal state : stateGame := IDLE;

    signal my_reset : std_logic := '1';
    signal my_timeout : std_logic := '0'; 
    signal my_enable_logigame : std_logic := '0';
    signal my_enable_lfsr : std_logic := '0';
    signal my_start_timer : std_logic := '0';
    signal my_cur_lsfr : std_logic_vector := "1011";

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

    component LFSRCore is
        Port (
            CLK    : in  std_logic;
            RESET  : in  std_logic;
            ENABLE : in  std_logic;
            RND    : out std_logic_vector (3 downto 0)
        );
    end component;
    signal my_rnd : std_logic_vector (3 downto 0) := "1011";

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
    signal my_score : std_logic_vector (3 downto 0) := "0000";
    signal my_game_over : std_logic := '1';

    component MinuteurCore is
        Port (
            RESET : in std_logic;
            START : in std_logic;
            SW_LEVEL : in std_logic_vector (3 downto 2);
            CLK : in std_logic;
            S : out std_logic 
        );
    end component;
    signal my_s : std_logic := '0';


begin

    myComponentInputHandler : InputHandler
    port map (
        CLK => CLK,
        RESET => my_reset,
        TIMEOUT => my_timeout,
        LED_COLOR => my_led,
        BTN_R => BTN(2),
        BTN_G => BTN(1),
        BTN_B => BTN(0),
        VALID_HIT => my_valid_hit
    );

    myComponentLFSR : LFSRCore
    port map (
        CLK => my_finalclk,
        RESET => my_reset,
        ENABLE => my_enable_lfsr, 
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
        RESET => my_reset,         
        ENABLE => my_enable_logigame, 
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
        if rising_edge(CLK) then
            if state = IDLE then
                my_led <= "000";
                LED(3) <= '1';
                LED(2 downto 0) <= "000";
                if BTN(3) = '1' then
                    state <= NEW_ROUND;
                end if;

            elsif state = NEW_ROUND then
                -- génère la séquence pseudo aléatoire
                my_reset <= '0';
                my_enable_lfsr <= '1';
                state <= RND;
                

            elsif state = RND then

                if my_rnd != my_cur_lsfr then

                    if to_integer(unsigned(my_rnd)) mod 3 = 0 then
                        my_led <= "001"; -- Blue
                    elsif to_integer(unsigned(my_rnd)) mod 3 = 1 then
                        my_led <= "010"; -- Green   
                    elsif to_integer(unsigned(my_rnd)) mod 3 = 2 then 
                        my_led <= "100"; -- Red    
                    end if;

                    state <= NEW_ROUND
                    my_enable_lfsr <= '0';
                end if;


            elsif state = NEW_ROUND then
                -- game loop
                my_enable_logigame <= '1';
                my_start_timer <= '1';
                my_timeout <= '0'; 

                if my_s = '0' then
                    if my_reset = '1' then
                        my_reset <= '0';
                    end if;

                    if my_valid_hit = '1' then
                        -- continue the game
                        my_timeout <= '0'; 
                        LED(3 downto 0) <= my_score;
                        my_reset <= '1';
                        state <= NEW_ROUND;
                    end if;
                end if;

                if my_s = '1' then
                    -- stop the game because the user did not press the button fast enough
                    my_timeout <= '1'; 
                    state <= END_GAME;
                end if;

                if my_game_over = '1' then
                    my_enable_logigame <= '0';
                    state <= END_GAME;
                end if;

            elsif state = END_GAME then
                -- need to press start to reset the game
                LED(3) <= '1';
                if BTN(3) = '1' then
                    state <= IDLE;
                end if;
            end if;
        end if;
    end process;


    LED_B <= my_led(0);
    LED_G <= my_led(1);
    LED_R <= my_led(2);

end ControlerCore_Arch;