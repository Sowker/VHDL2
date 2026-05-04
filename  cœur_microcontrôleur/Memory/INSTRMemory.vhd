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
        0 => "0000" & "0000" & "00", -- Etape 1 : A dans Buf A
        1 => "0001" & "0000" & "00", -- Etape 2 : B dans Buf B
        2 => "0110" & "1011" & "00", -- Etape 3 : S = Buf_A * Buf_B, save Cache 1
        3 => "0000" & "0000" & "01", -- Etape 4 : Affichage Cache 1 sur RES_OUT
        -- === AUTOMATE 2 : (A + B) XNOR A ===
        4 => "0000" & "0000" & "00", -- Etape 1 : A dans Buf A
        5 => "0001" & "0000" & "00", -- Etape 2 : B dans Buf B
        6 => "0110" & "1000" & "00", -- Etape 3 : S = Buf_A + Buf_B, save Cache 1
        7 => "0000" & "" & "00", -- Etape 4 : Affichage Cache 1 sur RES_OUT
        
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