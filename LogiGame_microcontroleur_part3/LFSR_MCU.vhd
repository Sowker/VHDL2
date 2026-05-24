library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity LFSR_MCU is 
    Port (
        CLK    : in  std_logic;
        RESET  : in  std_logic;
        ENABLE : in  std_logic;
        RND    : out std_logic_vector (3 downto 0)
    );
end LFSR_MCU;

architecture Behavioral of LFSR_MCU is

    component Top_Level is
        Port (
            CLK         : in  std_logic;
            RESET       : in  std_logic;
            A_IN        : in  std_logic_vector(3 downto 0);
            B_IN        : in  std_logic_vector(3 downto 0);
            BTN_1       : in  std_logic;
            BTN_2       : in  std_logic;
            BTN_3       : in  std_logic;
            SR_OUT_L    : out std_logic;
            SR_OUT_R    : out std_logic;
            RES_OUT     : out std_logic_vector(7 downto 0);
            DONE        : out std_logic 
        );
    end component;

    
    signal current_lfsr : std_logic_vector(3 downto 0) := "1011";
    
    
    signal mcu_res_out  : std_logic_vector(7 downto 0);
    signal mcu_done     : std_logic;
    signal trigger_mcu  : std_logic := '0';
    signal prev_enable  : std_logic := '0';

begin

    Process_LFSR : process(CLK)
    begin
        if rising_edge(CLK) then
            if RESET = '1' then
                current_lfsr <= "1011";
                prev_enable <= '0';
                trigger_mcu <= '0';
            else
                prev_enable <= ENABLE;
                if ENABLE = '1' and prev_enable = '0' then
                    trigger_mcu <= '1'; 
                else
                    trigger_mcu <= '0'; 
                end if;

                if mcu_done = '1' then
                    current_lfsr <= mcu_res_out(3 downto 0);
                end if;
            end if;
        end if;
    end process;

    Inst_MCU: Top_Level port map (
        CLK      => CLK,
        RESET    => RESET,
        A_IN     => current_lfsr, 
        B_IN     => "0000",       
        BTN_1    => trigger_mcu,  
        BTN_2    => '0',
        BTN_3    => '0',
        RES_OUT  => mcu_res_out,  
        DONE     => mcu_done
    );

    RND <= current_lfsr;

end Behavioral;