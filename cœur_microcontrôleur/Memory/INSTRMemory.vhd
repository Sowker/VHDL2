library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity INSTRMemory is
    Port (
        CLK         : in  std_logic;
        RESET       : in  std_logic;
        
        SEL_ROUTE   : out std_logic_vector(3 downto 0);
        SEL_FCT     : out std_logic_vector(3 downto 0);
        SEL_OUT     : out std_logic_vector(1 downto 0)
    );
end INSTRMemory;

architecture Behavioral of INSTRMemory is

    type rom_type is array (0 to 127) of std_logic_vector(9 downto 0);
    -- Format d'une ligne : "SEL_ROUTE" & "SEL_FCT" & "SEL_OUT"
    constant instructions_rom : rom_type := (
        -- === AUTOMATE 1 : Multiplication (A * B) === 
        0 => "0000" & "0000" & "00", -- Etape 1 : Charger l'entrée A_IN dans Buffer_A 
        1 => "0001" & "0000" & "00", -- Etape 2 : Charger l'entrée B_IN dans Buffer_B 
        2 => "0110" & "1011" & "00", -- Etape 3 : S = Buffer_A * Buffer_B -> Stocker dans MEM_CACHE_1 [cite
        3 => "0000" & "0000" & "01", -- Etape 4 : Affichage final : RES_OUT = MEM_CACHE_1 

        -- === AUTOMATE 2 : (A + B) XNOR A === 
        -- Note : L'UAL ne possède pas de fonction XNOR. On calcule (A XOR B) puis NOT.
        4 => "0000" & "0000" & "00", -- Charger A_IN dans Buffer_A
        5 => "0001" & "0000" & "00", -- Charger B_IN dans Buffer_B
        6 => "0110" & "1001" & "00", -- S = A + B (sans retenue) -> Stocker dans MEM_CACHE_1 
        7 => "1010" & "0000" & "00", -- Charger MEM_CACHE_1 (le résultat de A+B) dans Buffer_B 
        8 => "0111" & "0111" & "00", -- S = Buffer_A (A) XOR Buffer_B (A+B) -> Stocker dans MEM_CACHE_2 
        9 => "1100" & "0000" & "00", -- Charger MEM_CACHE_2 (le résultat du XOR) dans Buffer_A 
        10=> "0110" & "0010" & "00", -- S = NOT Buffer_A -> Stocker dans MEM_CACHE_1 (Résultat final XNOR) 
        11=> "0000" & "0000" & "01", -- Affichage final : RES_OUT = MEM_CACHE_1 

        -- === AUTOMATE 3 : (A0 AND B1) OR (A1 AND B0) === 
        -- Note : On utilise des décalages pour aligner les bits avant les opérations logiques.
        12=> "0000" & "0000" & "00", -- Charger A_IN dans Buffer_A
        13=> "0001" & "0000" & "00", -- Charger B_IN dans Buffer_B
        14=> "0111" & "1110" & "00", -- S = B décalé à droite -> MEM_CACHE_2 (le bit 0 devient B1)
        15=> "1110" & "0000" & "00", -- Charger MEM_CACHE_2 dans Buffer_B
        16=> "0110" & "0101" & "00", -- S = A AND (B>>1) -> MEM_CACHE_1 (le bit 0 est A0.B1) 
        17=> "0111" & "1100" & "00", -- S = A décalé à droite -> MEM_CACHE_2 (le bit 0 devient A1)
        18=> "1100" & "0000" & "00", -- Charger MEM_CACHE_2 dans Buffer_A
        19=> "0001" & "0000" & "00", -- Recharger B original dans Buffer_B
        20=> "0111" & "0101" & "00", -- S = (A>>1) AND B -> MEM_CACHE_2 (le bit 0 est A1.B0) 
        21=> "1000" & "0000" & "00", -- Charger MEM_CACHE_1 (A0.B1) dans Buffer_A
        22=> "1110" & "0000" & "00", -- Charger MEM_CACHE_2 (A1.B0) dans Buffer_B
        23=> "0110" & "0110" & "00", -- S = Buffer_A OR Buffer_B -> Stocker dans MEM_CACHE_1
        24=> "0000" & "0000" & "01", -- Affichage final : RES_OUT = MEM_CACHE_1 (le bit 0 est le résultat)

        -- Reste de la mémoire initialisée à 0
        others => "0000000000" 
    );

    signal pc : integer range 0 to 127 := 0;

begin

    process(CLK, RESET)
    begin
        if RESET = '1' then
            pc <= 0;
        elsif falling_edge(CLK) then
            if pc < 127 then
                pc <= pc + 1;
            else
                pc <= 0;
            end if;
        end if;
    end process;

    
    SEL_ROUTE <= instructions_rom(pc)(9 downto 6);
    SEL_FCT   <= instructions_rom(pc)(5 downto 2);
    SEL_OUT   <= instructions_rom(pc)(1 downto 0);

end Behavioral;
