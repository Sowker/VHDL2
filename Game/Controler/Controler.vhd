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
    type stateGame is (IDLE, WAIT_START_RELEASE, NEW_ROUND, RND, WAIT_RESPONSE, CHECK_HIT, WAIT_RELEASE, END_GAME);
    signal state : stateGame := IDLE;

    signal my_reset : std_logic := '1';
    signal round_reset : std_logic := '0';
    signal my_timeout : std_logic := '0';
    signal my_enable_logigame : std_logic := '0';
    signal my_enable_lfsr : std_logic := '0';
    signal my_start_timer : std_logic := '0';
    signal my_cur_lsfr : std_logic_vector (3 downto 0) := "1011";

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

    component LogiGameCore is
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
    signal my_game_over : std_logic;

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

    myComponentInputHandler : InputHandler port map (
        CLK => CLK,
        RESET => round_reset,
        TIMEOUT => my_timeout,
        LED_COLOR => my_led,
        BTN_R => BTN(2),
        BTN_G => BTN(1),
        BTN_B => BTN(0),
        VALID_HIT => my_valid_hit
    );

    myComponentLFSR : LFSRCore port map (
        CLK => my_finalclk,
        RESET => my_reset,
        ENABLE => my_enable_lfsr, 
        RND => my_rnd
    );

    myComponentDiviseurCore : DiviseurCore port map (
        CLK => CLK,
        RESET => my_reset,
        FINALCLK => my_finalclk
    );

    myComponentLogiGame : LogiGameCore port map (
        CLK => CLK,
        RESET => my_reset,         
        ENABLE => my_enable_logigame, 
        VALID_HIT => my_valid_hit,
        SCORE => my_score,
        GAME_OVER => my_game_over
    );

    myComponentMinuteurCore : MinuteurCore port map (
        RESET => my_reset,
        START => my_start_timer,
        SW_LEVEL => SW,
        CLK => CLK,
        S => my_s
    );

    Game_proc : process(CLK)
    begin
        if rising_edge(CLK) then
            
            -- DEFAULT PULSES
            my_enable_lfsr <= '0';
            my_enable_logigame <= '0';
            my_start_timer <= '0';
            round_reset <= '0';

            if state = IDLE then
                my_reset <= '1'; 
                round_reset <= '1';
                my_led <= "000";
                my_timeout <= '0';
                
                if BTN(3) = '1' then
                    state <= WAIT_START_RELEASE; 
                end if;

            elsif state = WAIT_START_RELEASE then
                my_reset <= '0';
                
                if BTN(3) = '0' then 
                    state <= NEW_ROUND;
                end if;

            elsif state = NEW_ROUND then
                my_enable_lfsr <= '1';
                state <= RND;

            elsif state = RND then
                if my_rnd /= my_cur_lsfr then
                    my_cur_lsfr <= my_rnd;

                    if to_integer(unsigned(my_rnd)) mod 3 = 0 then
                        my_led <= "001"; -- Blue
                    elsif to_integer(unsigned(my_rnd)) mod 3 = 1 then
                        my_led <= "010"; -- Green   
                    elsif to_integer(unsigned(my_rnd)) mod 3 = 2 then 
                        my_led <= "100"; -- Red    
                    end if;

                    my_start_timer <= '1';
                    round_reset <= '1';
                    state <= WAIT_RESPONSE;
                else
                    my_enable_lfsr <= '1';
                end if;

            elsif state = WAIT_RESPONSE then
                
                my_start_timer <= '1'; 
                
                if my_game_over = '1' then 
                    state <= END_GAME;
                elsif my_s = '1' then 
                    my_timeout <= '1';
                    my_enable_logigame <= '1'; 
                    state <= END_GAME; 
                
                elsif BTN(2) = '1' or BTN(1) = '1' or BTN(0) = '1' then 
                    state <= CHECK_HIT;
                end if;

            elsif state = CHECK_HIT then
                my_enable_logigame <= '1'; 
                
                if my_valid_hit = '1' then
                    state <= WAIT_RELEASE; 
                else
                    state <= END_GAME; 
                end if;

            elsif state = WAIT_RELEASE then
                round_reset <= '1';
                my_led <= "000";
                
               
                if BTN(2) = '0' and BTN(1) = '0' and BTN(0) = '0' then
                    state <= NEW_ROUND;
                end if;

            elsif state = END_GAME then
                my_led <= "000"; 
                
                if BTN(3) = '1' then
                    state <= IDLE; -
                end if;
            end if;
        end if;
    end process;

    -- Wiring outputs
    LED<= my_score;
    LED_B <= my_led(0);
    LED_G <= my_led(1);
    LED_R <= my_led(2);

end ControlerCore_Arch;
