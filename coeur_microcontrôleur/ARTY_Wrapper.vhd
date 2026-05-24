library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ARTY_Wrapper is
    Port (
        CLK100MHZ : in std_logic;
        sw        : in std_logic_vector(3 downto 0);
        btn       : in std_logic_vector(3 downto 0);
        
        -- Les 4 LEDs vertes standard de l'ARTY (LD4 à LD7)
        led       : out std_logic_vector(3 downto 0);
        
        -- Les 4 LEDs RGB de l'ARTY (LD0 à LD3)
        led0_r, led0_g, led0_b : out std_logic;
        led1_r, led1_g, led1_b : out std_logic;
        led2_r, led2_g, led2_b : out std_logic;
        led3_r, led3_g, led3_b : out std_logic
    );
end ARTY_Wrapper;

architecture Structural of ARTY_Wrapper is

    component Top_Level
        Port (
            CLK         : in  std_logic;
            RESET       : in  std_logic;
            A_IN        : in  std_logic_vector(3 downto 0);
            B_IN        : in  std_logic_vector(3 downto 0);
            BTN_1       : in  std_logic;
            BTN_2       : in  std_logic;
            BTN_3       : in  std_logic;
            RES_OUT     : out std_logic_vector(7 downto 0);
            DONE        : out std_logic;
            SR_OUT_L    : out std_logic;
            SR_OUT_R    : out std_logic
        );
    end component;

    signal sig_res_out  : std_logic_vector(7 downto 0);
    signal sig_done     : std_logic;
    signal sig_sr_out_l : std_logic;
    signal sig_sr_out_r : std_logic;

begin

    -- Instanciation de ton cœur de microcontrôleur
    Mon_Processeur: Top_Level port map (
        CLK      => CLK100MHZ,
        RESET    => btn(0),  -- btn(0) est le Reset Global
        A_IN     => sw,      -- A = Swt(3..0)
        B_IN     => sw,      -- B = Swt(3..0) (Comme demandé: A = B = Swt)
        BTN_1    => btn(1),  -- Lancement Automate 1
        BTN_2    => btn(2),  -- Lancement Automate 2
        BTN_3    => btn(3),  -- Lancement Automate 3
        RES_OUT  => sig_res_out,
        DONE     => sig_done,
        SR_OUT_L => sig_sr_out_l,
        SR_OUT_R => sig_sr_out_r
    );

    -- ==========================================
    -- MAPPAGE DES SORTIES SUR LA CARTE ARTY
    -- ==========================================

    -- Les 8 bits du résultat (Moitié sur les LEDs vertes, Moitié sur les LEDs rouges)
    led(0) <= sig_res_out(0);
    led(1) <= sig_res_out(1);
    led(2) <= sig_res_out(2);
    led(3) <= sig_res_out(3);
    
    led0_r <= sig_res_out(4);
    led1_r <= sig_res_out(5);
    led2_r <= sig_res_out(6);
    led3_r <= sig_res_out(7);

    -- Extinction totale de la couleur verte des LEDs RGB
    led0_g <= '0'; led1_g <= '0'; led2_g <= '0'; led3_g <= '0';

    -- Allumage de la couleur BLEUE selon les états (Comme demandé)
    led0_b <= sig_sr_out_l; -- 5ème LED avec du bleu (LD0_B)
    led1_b <= sig_sr_out_r; -- 6ème LED avec du bleu (LD1_B)
    led2_b <= '0';          -- 7ème LED inutilisée
    led3_b <= sig_done;     -- 8ème LED avec du bleu pour le DONE (LD3_B)

end Structural;