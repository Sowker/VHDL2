library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity LFSRCore_tb is
-- Vide car c'est un testbench
end LFSRCore_tb;

architecture behavior of LFSRCore_tb is

    component LFSRCore
    Port (
        CLK    : in  std_logic;
        RESET  : in  std_logic;
        ENABLE : in  std_logic;
        RND    : out std_logic_vector(3 downto 0)
    );
    end component;

    signal CLK    : std_logic := '0';
    signal RESET  : std_logic := '0';
    signal ENABLE : std_logic := '0';
    signal RND    : std_logic_vector(3 downto 0);

    -- Horloge 100 MHz
    constant CLK_period : time := 10 ns;

begin

    uut: LFSRCore PORT MAP (
        CLK    => CLK,
        RESET  => RESET,
        ENABLE => ENABLE,
        RND    => RND
    );

    CLK_process :process
    begin
        CLK <= '0';
        wait for CLK_period/2;
        CLK <= '1';
        wait for CLK_period/2;
    end process;

    stim_proc: process
    begin		
        -- Initialisation
        RESET  <= '1';
        ENABLE <= '0';
        wait for 100 ns;	

        -- Fin du Reset
        RESET  <= '0';
        wait for 100 ns;

        -- Activation
        ENABLE <= '1';

        -- Le compteur va jusqu'à 99999, donc le LFSR met à jour sa valeur
        -- toutes les 2 millisecondes (500 Hz).
        -- On attend 40 ms pour s'assurer de voir la séquence complète boucler.
        wait for 40 ms;

        -- Test de désactivation
        ENABLE <= '0';
        wait for 5 ms;

        -- Arrêt de la simulation
        assert false report "Fin de la simulation" severity failure;
        wait;
    end process;

end behavior;