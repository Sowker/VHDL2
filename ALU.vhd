library IEEE:
use IEE.STD_LOGIC_1164.ALL;

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

    signal my_S ; std_logic_vector (8 downto 0);

begin
    MyALUCore_Proc : process (Sel_FCT, SR_IN_L, SR_IN_R, A_IN, B_IN, CLK, RESET)
    begin
        if rising_edge(CLK) then 
            if Sel_FCT = "0000" then
                SR_OUT_L <= '0';
                SR_OUT_R <= '0';
                S <= "0000";

            elsif Sel_FCT = "0001" then
                SR_OUT_L <= '0';
                SR_OUT_R <= '0';
                S <= A;
            
            elsif Sel_FCT = "0010" then
                SR_OUT_L <= '0';
                SR_OUT_R <= '0';
                S <= not(A);

            elsif Sel_FCT = "0011" then
                SR_OUT_L <= '0';
                SR_OUT_R <= '0';
                S <= B;
            
            elsif Sel_FCT = "0100" then
                SR_OUT_L <= '0';
                SR_OUT_R <= '0';
                S <= not(B);
            
            elsif Sel_FCT = "0101" then
                SR_OUT_L <= '0';
                SR_OUT_R <= '0';
                S <= A AND B;
            
            elsif Sel_FCT = "0110" then
                SR_OUT_L <= '0';
                SR_OUT_R <= '0';
                S <= A OR B;
            
            elsif Sel_FCT = "0111" then
                SR_OUT_L <= '0';
                SR_OUT_R <= '0';
                S <= A XOR B;

            elsif Sel_FCT = "1000" then
                S <= unsigned(A) + unsigned(B) + unsigned(SR_IN_R);
            
            elsif Sel_FCT = "1001" then
                S <= unsigned(A) + unsigned(B);

            elsif Sel_FCT = "1010" then
                S <= unsigned(A) - unsigned(B);
            
            elsif Sel_FCT = "1011" then
                S <= unsigned(A) * unsigned(B);

            elsif Sel_FCT = "1100" then
                S <= "0000" & SR_IN_L & A(3 downto 1);
                SR_OUT_R <= A(0);
            
            elsif Sel_FCT = "1101" then
                S <= "0000" & A(2 downto 0) + SR_IN_R;
                SR <= A(3);

            elsif Sel_FCT = "1110" then
                S <= "0000" & SR_IN_L & B(3 downto 1);
                SR_OUT_R <= B(0);
            
            elsif Sel_FCT = "1111" then
                S <= "0000" & B(2 downto 0) + SR_IN_R;
                SR <= B(3);
            end if;
        end if;

    end process;

end ALUCore_Arch;