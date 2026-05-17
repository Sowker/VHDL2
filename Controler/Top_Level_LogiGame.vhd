library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Top_Level_LogiGame is
    Port (
        CLK100MHZ : in  std_logic;                          -- Horloge système 100 MHz
        btn       : in  std_logic_vector(3 downto 0);        -- btn(0)=Start, btn(1)=Rouge, btn(2)=Vert, btn(3)=Bleu
        sw        : in  std_logic_vector(2 downto 0);        -- Sélection du niveau de difficulté
        led       : out std_logic_vector(3 downto 0);        -- Affichage du score (4 bits)
        led3_r    : out std_logic;                           -- Stimulus RGB - Rouge
        led3_g    : out std_logic;                           -- Stimulus RGB - Vert
        led3_b    : out std_logic                            -- Stimulus RGB - Bleu
    );
end Top_Level_LogiGame;

architecture Structural of Top_Level_LogiGame is

    -- =========================================================
    -- Déclaration du composant de contrôle du jeu
    -- =========================================================
    component LogiGame
        Port (
            clk         : in  std_logic;
            reset       : in  std_logic;                     -- Souvent lié à btn(0) ou géré en interne
            buttons     : in  std_logic_vector(3 downto 0);
            difficulty  : in  std_logic_vector(2 downto 0);
            score       : out std_logic_vector(3 downto 0);
            stimulus_r  : out std_logic;
            stimulus_g  : out std_logic;
            stimulus_b  : out std_logic
        );
    end component;

    -- Signaux internes si des adaptations de logique ou de synchronisation sont nécessaires
    signal sig_reset : std_logic;

begin

    -- Le bouton 0 sert à la fois de bouton de contrôle 'Start' pour lancer la partie
    -- et peut être utilisé comme réinitialisation (Reset) pour l'initialisation des blocs.
    sig_reset <= btn(0);

    -- =========================================================
    -- Instanciation et Câblage du Cœur du Jeu
    -- =========================================================
    Inst_LogiGame: LogiGame port map (
        clk         => CLK100MHZ,
        reset       => sig_reset,
        buttons     => btn,
        difficulty  => sw,
        score       => led,
        stimulus_r  => led3_r,
        stimulus_g  => led3_g,
        stimulus_b  => led3_b
    );

end Structural;
