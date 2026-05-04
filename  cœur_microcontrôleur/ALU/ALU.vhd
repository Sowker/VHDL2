library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ALUCore is 
    Port (
    CLK : in std_logic;
    RESET : in std_logic;
    Sel_FCT : in std_logic_vector (3 downto 0);
    SR_OUT_L : out std_logic;
    SR_OUT_R : out std_logic;
    SR_IN_L : in std_logic;
    SR_IN_R : in std_logic;
    A_IN : in std_logic_vector (3 downto 0);
    B_IN : in std_logic_vector (3 downto 0);
    S : out std_logic_vector (7 downto 0)

    );
end ALUCore;


architecture ALUCore_Arch of ALUCore is

begin
    MyALUCore_Proc : process (Sel_FCT, SR_IN_L, SR_IN_R, A_IN, B_IN, CLK, RESET)
    begin
        if RESET = '1' then
            SR_OUT_L <= '0';
            SR_OUT_R <= '0';
            S <= (others => '0');
            
        elsif rising_edge(CLK) then 
            if Sel_FCT = "0000" then
                SR_OUT_L <= '0';
                SR_OUT_R <= '0';
                S <= "00000000";

            elsif Sel_FCT = "0001" then
                SR_OUT_L <= '0';
                SR_OUT_R <= '0';
                S <= "0000"& A_IN;
            
            elsif Sel_FCT = "0010" then
                SR_OUT_L <= '0';
                SR_OUT_R <= '0';
                S <= "0000"& not(A_IN);

            elsif Sel_FCT = "0011" then
                SR_OUT_L <= '0';
                SR_OUT_R <= '0';
                S <= "0000"& B_IN;
            
            elsif Sel_FCT = "0100" then
                SR_OUT_L <= '0';
                SR_OUT_R <= '0';
                S <= "0000"& not(B_IN);
            
            elsif Sel_FCT = "0101" then
                SR_OUT_L <= '0';
                SR_OUT_R <= '0';
                S <= "0000"& (A_IN AND B_IN);
            
            elsif Sel_FCT = "0110" then
                SR_OUT_L <= '0';
                SR_OUT_R <= '0';
                S <= "0000"& (A_IN OR B_IN);
            
            elsif Sel_FCT = "0111" then
                SR_OUT_L <= '0';
                SR_OUT_R <= '0';
                S <= "0000"& (A_IN XOR B_IN);

            elsif Sel_FCT = "1000" then
                S <= "0000"& std_logic_vector(unsigned(A_IN) + unsigned(B_IN) + SR_IN_R);
            
            elsif Sel_FCT = "1001" then
                S <= "0000"& std_logic_vector(unsigned(A_IN) + unsigned(B_IN));

            elsif Sel_FCT = "1010" then
                S <= "0000"& std_logic_vector(unsigned(A_IN) - unsigned(B_IN));
            
            elsif Sel_FCT = "1011" then
                S <= std_logic_vector(unsigned(A_IN) * unsigned(B_IN));

            elsif Sel_FCT = "1100" then
                S <= "0000" & SR_IN_L & A_IN(3 downto 1);
                SR_OUT_R <= A_IN(0);
            
            elsif Sel_FCT = "1101" then
                S <= "0000" & A_IN(2 downto 0) & SR_IN_R;
                SR_OUT_L <= A_IN(3);

            elsif Sel_FCT = "1110" then
                S <= "0000" & SR_IN_L & B_IN(3 downto 1);
                SR_OUT_R <= B_IN(0);
            
            elsif Sel_FCT = "1111" then
                S <= "0000" & B_IN(2 downto 0) & SR_IN_R;
                SR_OUT_L <= B_IN(3);
            end if;
        end if;

    end process;

end ALUCore_Arch;