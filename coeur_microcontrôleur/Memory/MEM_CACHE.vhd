library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity MEM_SEL_OUT_MUX is 
    Port (
        CLK         : in  std_logic;
        RESET       : in  std_logic; 
        SEL_OUT     : in  std_logic_vector (1 downto 0);
        S           : in  std_logic_vector (7 downto 0); 
        MEM_CACHE_1 : in  std_logic_vector (7 downto 0);
        MEM_CACHE_2 : in  std_logic_vector (7 downto 0);
        RES_OUT     : out std_logic_vector (7 downto 0)
    );
end MEM_SEL_OUT_MUX;

architecture Behavioral of MEM_SEL_OUT_MUX is 

    signal reg_SEL_OUT : std_logic_vector(1 downto 0) := "00";
begin

    process (CLK, RESET)
    begin
        if RESET = '1' then
            reg_SEL_OUT <= "00";
            RES_OUT     <= (others => '0');
        elsif rising_edge(CLK) then
            reg_SEL_OUT <= SEL_OUT;
            
            if SEL_OUT = "00" then
                RES_OUT <= (others => '0');
            elsif SEL_OUT = "01" then
                RES_OUT <= MEM_CACHE_1;
            elsif SEL_OUT = "10" then
                RES_OUT <= MEM_CACHE_2;
            elsif SEL_OUT = "11" then
                RES_OUT <= S;
            end if;
        end if;
    end process;

end Behavioral;