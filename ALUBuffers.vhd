library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
entity ALUSELROUTE is
    generic (
        N : integer := 4

    );
    port (
        CLK : in std_logic;
        RESET : in std_logic;
        SR_IN_L : in std_logic_vector (4 - 1 downto 0);
        SR_IN_R : in std_logic_vector (4 - 1 downto 0);
        A_IN : in std_logic_vector (4 - 1 downto 0);
        B_IN : in std_logic_vector (4 - 1 downto 0);
        SEL_ROUTE : in std_logic_vector(4 - 1 downto 0);
        S : in std_logic_vector(8 - 1 downto 0);

        Buffer_A : out std_logic_vector(3 downto 0);
        Buffer_B : out std_logic_vector(3 downto 0);
        MEM_CACHE_1 : out std_logic_vector(7 downto 0);
        MEM_CACHE_2 : out std_logic_vector(7 downto 0)
    );
end ALUSELROUTE;

architecture ALUSELROUTE_arch of ALUSELROUTE is
    signal reg_Buffer_A : std_logic_vector(3 downto 0) := (others => '0');
    signal reg_Buffer_B : std_logic_vector(3 downto 0) := (others => '0');
    signal reg_MEM_CACHE_1 : std_logic_vector(7 downto 0) := (others => '0');
    signal reg_MEM_CACHE_2 : std_logic_vector(7 downto 0) := (others => '0');
begin
    MyALUSELROUTEProc : process(CLK,RESET);
    begin
        if RESET = '1' then
            reg_Buffer_A <= (others => 0);
            reg_Buffer_B <= (others => 0);
            reg_MEM_CACHE_1 <= (others => 0);
            reg_MEM_CACHE_2 <= (others => 0);
        elsif rising_edge(CLK) then
            case SEL_ROUTE is
                when "0000" =>
                    reg_Buffer_A <= A_IN;
                when "0001" =>
                    reg_Buffer_B <= B_IN;
                when "0010" =>
                    reg_Buffer_A <= S(3 downto 0);
                when "0011" =>
                    reg_Buffer_A <= S(7 downto 4);
                when "0100" =>
                    reg_Buffer_B <= S(3 downto 0);
                when "0101" =>
                    reg_Buffer_B <= S(7 downto 4);
                when "0110" =>
                    reg_MEM_CACHE_1 <= S;
                when "0111" =>
                    reg_MEM_CACHE_2 <= S;
                when "1000" =>
                    reg_Buffer_A <= reg_MEM_CACHE_1(3 downto 0);
                when "1001" =>
                    reg_Buffer_A <= reg_MEM_CACHE_1(7 downto 4);
                when "1010" =>
                    reg_Buffer_B <= reg_MEM_CACHE_1(3 downto 0);
                when "1011" =>
                    reg_Buffer_B <= reg_MEM_CACHE_1(7 downto 4);
                when "1100" =>
                    reg_Buffer_A <= reg_MEM_CACHE_2(3 downto 0);
                when "1101" =>
                    reg_Buffer_A <= reg_MEM_CACHE_2(7 downto 4);
                when "1110" =>
                    reg_Buffer_B <= reg_MEM_CACHE_2(3 downto 0);
                when "1111" =>
                    reg_Buffer_B <= reg_MEM_CACHE_2(7 downto 4);
                when others =>
                    null;
            end case;
        end if;
    end process MyALUSELROUTEProc;
    Buffer_A<=reg_Buffer_A;
    Buffer_B<=reg_Buffer_B;
    MEM_CACHE_1<=reg_MEM_CACHE_1;
    MEM_CACHE_2<=reg_MEM_CACHE_2;
    

end ALUSELROUTE_arch;
