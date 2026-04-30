library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ALUBuffer is 
    Port (
        CLK         : in  std_logic;
        RESET       : in  std_logic;
        -- Entrées et CE pour les Buffers A et B
        CE_Buf_A    : in  std_logic;
        Buf_A_in    : in  std_logic_vector(3 downto 0);
        CE_Buf_B    : in  std_logic;
        Buf_B_in    : in  std_logic_vector(3 downto 0);
        -- Entrées pour les retenues
        SR_IN_L     : in  std_logic;
        SR_IN_R     : in  std_logic;
        -- Sorties allant vers le cœur de l'ALU
        Buf_A_out   : out std_logic_vector(3 downto 0);
        Buf_B_out   : out std_logic_vector(3 downto 0);
        MEM_SR_IN_L : out std_logic;
        MEM_SR_IN_R : out std_logic
    );
end ALUBuffer;

architecture Behavioral of ALUBuffer is
    signal reg_A    : std_logic_vector(3 downto 0) := "0000";
    signal reg_B    : std_logic_vector(3 downto 0) := "0000";
    signal reg_SR_L : std_logic := '0';
    signal reg_SR_R : std_logic := '0';
begin
    
    process(CLK, RESET)
    begin

        if RESET = '1' then
            reg_A    <= "0000";
            reg_B    <= "0000";
            reg_SR_L <= '0';
            reg_SR_R <= '0';
            
    
        elsif rising_edge(CLK) then
            
            if CE_Buf_A = '1' then
                reg_A <= Buf_A_in;
            end if;
            
            if CE_Buf_B = '1' then
                reg_B <= Buf_B_in;
            end if;

            reg_SR_L <= SR_IN_L;
            reg_SR_R <= SR_IN_R;
            
        end if;
    end process;

    Buf_A_out   <= reg_A;
    Buf_B_out   <= reg_B;
    MEM_SR_IN_L <= reg_SR_L;
    MEM_SR_IN_R <= reg_SR_R;

end Behavioral;