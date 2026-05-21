library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ALUSELROUTE is 
    Port (
        -- Inputs
        SEL_ROUTE   : in  std_logic_vector(3 downto 0);
        A           : in  std_logic_vector(3 downto 0);
        B           : in  std_logic_vector(3 downto 0);
        S           : in  std_logic_vector(7 downto 0);
        s_Mem_1_out : in  std_logic_vector(7 downto 0);
        s_Mem_2_out : in  std_logic_vector(7 downto 0);

        -- Outputs
        CE_Buf_A    : out std_logic;
        CE_Buf_B    : out std_logic;
        CE_Mem_1    : out std_logic;
        CE_Mem_2    : out std_logic;
        
        Buf_A_in    : out std_logic_vector(3 downto 0);
        Buf_B_in    : out std_logic_vector(3 downto 0);
        Mem_1_In    : out std_logic_vector(7 downto 0);
        Mem_2_In    : out std_logic_vector(7 downto 0)
    );
end ALUSELROUTE;

architecture Behavioral of ALUSELROUTE is
begin
    process(SEL_ROUTE, A, B, S, s_Mem_1_out, s_Mem_2_out)
    begin
        case SEL_ROUTE is
            when "0000" =>
                CE_Buf_A <= '1'; 
                CE_Buf_B <= '0';
                CE_Mem_1 <= '0'; 
                CE_Mem_2 <= '0';
                Buf_A_in <= A;
                Buf_B_in <= (others=>'0');
                Mem_1_In <= (others=>'0');
                Mem_2_In <= (others=>'0');

            when "0001" =>
                CE_Buf_A <= '0'; 
                CE_Buf_B <= '1';
                CE_Mem_1 <= '0'; 
                CE_Mem_2 <= '0';
                Buf_A_in <= (others=>'0');
                Buf_B_in <= B;
                Mem_1_In <= (others=>'0');
                Mem_2_In <= (others=>'0');

            when "0010" =>
                CE_Buf_A <= '1'; 
                CE_Buf_B <= '0';
                CE_Mem_1 <= '0'; 
                CE_Mem_2 <= '0';
                Buf_A_in <= S(3 downto 0);
                Buf_B_in <= (others=>'0');
                Mem_1_In <= (others=>'0');
                Mem_2_In <= (others=>'0');

            when "0011" =>
                CE_Buf_A <= '1'; 
                CE_Buf_B <= '0';
                CE_Mem_1 <= '0'; 
                CE_Mem_2 <= '0';
                Buf_A_in <= S(7 downto 4);
                Buf_B_in <= (others=>'0');
                Mem_1_In <= (others=>'0');
                Mem_2_In <= (others=>'0');

            when "0100" =>
                CE_Buf_A <= '0'; 
                CE_Buf_B <= '1';
                CE_Mem_1 <= '0'; 
                CE_Mem_2 <= '0';
                Buf_A_in <= (others=>'0');
                Buf_B_in <= S(3 downto 0);
                Mem_1_In <= (others=>'0');
                Mem_2_In <= (others=>'0');

            when "0101" =>
                CE_Buf_A <= '0'; 
                CE_Buf_B <= '1';
                CE_Mem_1 <= '0'; 
                CE_Mem_2 <= '0';
                Buf_A_in <= (others=>'0');
                Buf_B_in <= S(7 downto 4);
                Mem_1_In <= (others=>'0');
                Mem_2_In <= (others=>'0');

            when "0110" =>
                CE_Buf_A <= '0'; 
                CE_Buf_B <= '0';
                CE_Mem_1 <= '1'; 
                CE_Mem_2 <= '0';
                Buf_A_in <= (others=>'0');
                Buf_B_in <= (others=>'0');
                Mem_1_In <= S;
                Mem_2_In <= (others=>'0');

            when "0111" =>
                CE_Buf_A <= '0'; 
                CE_Buf_B <= '0';
                CE_Mem_1 <= '0'; 
                CE_Mem_2 <= '1';
                Buf_A_in <= (others=>'0');
                Buf_B_in <= (others=>'0');
                Mem_1_In <= (others=>'0');
                Mem_2_In <= S;

            when "1000" =>
                CE_Buf_A <= '1'; 
                CE_Buf_B <= '0';
                CE_Mem_1 <= '0'; 
                CE_Mem_2 <= '0';
                Buf_A_in <= s_Mem_1_out(3 downto 0);
                Buf_B_in <= (others=>'0');
                Mem_1_In <= (others=>'0');
                Mem_2_In <= (others=>'0');

            when "1001" =>
                CE_Buf_A <= '1'; 
                CE_Buf_B <= '0';
                CE_Mem_1 <= '0'; 
                CE_Mem_2 <= '0';
                Buf_A_in <= s_Mem_1_out(7 downto 4);
                Buf_B_in <= (others=>'0');
                Mem_1_In <= (others=>'0');
                Mem_2_In <= (others=>'0');

            when "1010" =>
                CE_Buf_A <= '0'; 
                CE_Buf_B <= '1';
                CE_Mem_1 <= '0'; 
                CE_Mem_2 <= '0';
                Buf_A_in <= (others=>'0');
                Buf_B_in <= s_Mem_1_out(3 downto 0);
                Mem_1_In <= (others=>'0');
                Mem_2_In <= (others=>'0');

            when "1011" =>
                CE_Buf_A <= '0'; 
                CE_Buf_B <= '1';
                CE_Mem_1 <= '0'; 
                CE_Mem_2 <= '0';
                Buf_A_in <= (others=>'0');
                Buf_B_in <= s_Mem_1_out(7 downto 4);
                Mem_1_In <= (others=>'0');
                Mem_2_In <= (others=>'0');

            when "1100" =>
                CE_Buf_A <= '1'; 
                CE_Buf_B <= '0';
                CE_Mem_1 <= '0'; 
                CE_Mem_2 <= '0';
                Buf_A_in <= s_Mem_2_out(3 downto 0);
                Buf_B_in <= (others=>'0');
                Mem_1_In <= (others=>'0');
                Mem_2_In <= (others=>'0');

            when "1101" =>
                CE_Buf_A <= '1'; 
                CE_Buf_B <= '0';
                CE_Mem_1 <= '0'; 
                CE_Mem_2 <= '0';
                Buf_A_in <= s_Mem_2_out(7 downto 4);
                Buf_B_in <= (others=>'0');
                Mem_1_In <= (others=>'0');
                Mem_2_In <= (others=>'0');

            when "1110" =>
                CE_Buf_A <= '0'; 
                CE_Buf_B <= '1';
                CE_Mem_1 <= '0'; 
                CE_Mem_2 <= '0';
                Buf_A_in <= (others=>'0');
                Buf_B_in <= s_Mem_2_out(3 downto 0);
                Mem_1_In <= (others=>'0');
                Mem_2_In <= (others=>'0');

            when "1111" =>
                CE_Buf_A <= '0'; 
                CE_Buf_B <= '1';
                CE_Mem_1 <= '0'; 
                CE_Mem_2 <= '0';
                Buf_A_in <= (others=>'0');
                Buf_B_in <= s_Mem_2_out(7 downto 4);
                Mem_1_In <= (others=>'0');
                Mem_2_In <= (others=>'0');

            when others =>
                CE_Buf_A <= '0'; 
                CE_Buf_B <= '0';
                CE_Mem_1 <= '0'; 
                CE_Mem_2 <= '0';
                Buf_A_in <= (others=>'0');
                Buf_B_in <= (others=>'0');
                Mem_1_In <= (others=>'0');
                Mem_2_In <= (others=>'0');
        end case;
    end process;
end Behavioral;