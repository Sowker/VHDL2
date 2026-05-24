library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Top_Level is
    Port (
        CLK         : in  std_logic;
        RESET       : in  std_logic;
        A_IN        : in  std_logic_vector(3 downto 0);
        B_IN        : in  std_logic_vector(3 downto 0);
        BTN_1       : in  std_logic;
        BTN_2       : in  std_logic;
        BTN_3       : in  std_logic;
        SR_OUT_L    : out std_logic;
        SR_OUT_R    : out std_logic;
        
        RES_OUT     : out std_logic_vector(7 downto 0);
        DONE        : out std_logic 
    );
end Top_Level;

architecture Structural of Top_Level is

    -- =========================================================
    -- 1. DÉCLARATION DES COMPOSANTS
    -- =========================================================
    
    component ALUCore
        Port (
            Sel_FCT  : in std_logic_vector (3 downto 0);
            SR_OUT_L : out std_logic;
            SR_OUT_R : out std_logic;
            SR_IN_L  : in std_logic;
            SR_IN_R  : in std_logic;
            A_IN     : in std_logic_vector (3 downto 0);
            B_IN     : in std_logic_vector (3 downto 0);
            S        : out std_logic_vector (7 downto 0)
        );
    end component;

    component ALUBuffer
        Port (
            CLK         : in  std_logic;
            RESET       : in  std_logic;
            CE_Buf_A    : in  std_logic;
            Buf_A_in    : in  std_logic_vector(3 downto 0);
            CE_Buf_B    : in  std_logic;
            Buf_B_in    : in  std_logic_vector(3 downto 0);
            CE_Mem_1    : in  std_logic;
            Mem_1_In    : in  std_logic_vector(7 downto 0);
            CE_Mem_2    : in  std_logic;
            Mem_2_In    : in  std_logic_vector(7 downto 0);
            SR_IN_L     : in  std_logic;
            SR_IN_R     : in  std_logic;
            Buf_A_out   : out std_logic_vector(3 downto 0);
            Buf_B_out   : out std_logic_vector(3 downto 0);
            Mem_1_out   : out std_logic_vector(7 downto 0);
            Mem_2_out   : out std_logic_vector(7 downto 0);
            MEM_SR_IN_L : out std_logic;
            MEM_SR_IN_R : out std_logic
        );
    end component;

    component ALUSELROUTE
        Port (
            SEL_ROUTE   : in  std_logic_vector(3 downto 0);
            A           : in  std_logic_vector(3 downto 0);
            B           : in  std_logic_vector(3 downto 0);
            S           : in  std_logic_vector(7 downto 0);
            s_Mem_1_out : in  std_logic_vector(7 downto 0);
            s_Mem_2_out : in  std_logic_vector(7 downto 0);
            CE_Buf_A    : out std_logic;
            CE_Buf_B    : out std_logic;
            CE_Mem_1    : out std_logic;
            CE_Mem_2    : out std_logic;
            Buf_A_in    : out std_logic_vector(3 downto 0);
            Buf_B_in    : out std_logic_vector(3 downto 0);
            Mem_1_In    : out std_logic_vector(7 downto 0);
            Mem_2_In    : out std_logic_vector(7 downto 0)
        );
    end component;

    component MEM_SEL_OUT_MUX
        Port (
            CLK         : in  std_logic;
            RESET       : in  std_logic;
            SEL_OUT     : in  std_logic_vector (1 downto 0);
            S           : in  std_logic_vector (7 downto 0);
            MEM_CACHE_1 : in  std_logic_vector (7 downto 0);
            MEM_CACHE_2 : in  std_logic_vector (7 downto 0);
            RES_OUT     : out std_logic_vector (7 downto 0)
        );
    end component;

    component INSTRMemory
        Port (
            CLK         : in  std_logic;
            RESET       : in  std_logic;
            BTN_1 : in std_logic;
            BTN_2 : in std_logic;
            BTN_3 : in std_logic;
            SEL_ROUTE   : out std_logic_vector(3 downto 0);
            SEL_FCT     : out std_logic_vector(3 downto 0);
            SEL_OUT     : out std_logic_vector(1 downto 0)
        );
    end component;

    -- =========================================================
    -- 2. DÉCLARATION DES SIGNAUX INTERNES (Les fils)
    -- =========================================================
    
    signal sig_S        : std_logic_vector(7 downto 0);
    signal sig_SR_OUT_L : std_logic;
    signal sig_SR_OUT_R : std_logic;
    signal sig_Buf_A_out   : std_logic_vector(3 downto 0);
    signal sig_Buf_B_out   : std_logic_vector(3 downto 0);
    signal sig_Mem_1_out   : std_logic_vector(7 downto 0);
    signal sig_Mem_2_out   : std_logic_vector(7 downto 0);
    signal sig_MEM_SR_IN_L : std_logic;
    signal sig_MEM_SR_IN_R : std_logic;
    signal sig_CE_Buf_A : std_logic;
    signal sig_CE_Buf_B : std_logic;
    signal sig_CE_Mem_1 : std_logic;
    signal sig_CE_Mem_2 : std_logic;
    signal sig_Buf_A_in : std_logic_vector(3 downto 0);
    signal sig_Buf_B_in : std_logic_vector(3 downto 0);
    signal sig_Mem_1_in : std_logic_vector(7 downto 0);
    signal sig_Mem_2_in : std_logic_vector(7 downto 0);

    signal sig_SEL_FCT   : std_logic_vector(3 downto 0);
    signal sig_SEL_ROUTE : std_logic_vector(3 downto 0);
    signal sig_SEL_OUT   : std_logic_vector(1 downto 0);

begin

    -- =========================================================
    -- 3. INSTANCIATIONS ET CÂBLAGE PHYSIQUE
    -- =========================================================

    Inst_INSTRMemory: INSTRMemory port map (
        CLK         => CLK,
        RESET       => RESET,
        BTN_1       => BTN_1,
        BTN_2       => BTN_2,
        BTN_3       => BTN_3,
        SEL_ROUTE   => sig_SEL_ROUTE,
        SEL_FCT     => sig_SEL_FCT,
        SEL_OUT     => sig_SEL_OUT
    );
    Inst_ALUCore: ALUCore port map (
        Sel_FCT  => sig_SEL_FCT,
        SR_OUT_L => sig_SR_OUT_L,
        SR_OUT_R => sig_SR_OUT_R,
        SR_IN_L  => sig_MEM_SR_IN_L,
        SR_IN_R  => sig_MEM_SR_IN_R,
        A_IN     => sig_Buf_A_out,
        B_IN     => sig_Buf_B_out,
        S        => sig_S
    );

    Inst_ALUBuffer: ALUBuffer port map (
        CLK         => CLK,
        RESET       => RESET,
        CE_Buf_A    => sig_CE_Buf_A,
        Buf_A_in    => sig_Buf_A_in,
        CE_Buf_B    => sig_CE_Buf_B,
        Buf_B_in    => sig_Buf_B_in,
        CE_Mem_1    => sig_CE_Mem_1,
        Mem_1_In    => sig_Mem_1_in,
        CE_Mem_2    => sig_CE_Mem_2,
        Mem_2_In    => sig_Mem_2_in,
        SR_IN_L     => sig_SR_OUT_L,
        SR_IN_R     => sig_SR_OUT_R,
        Buf_A_out   => sig_Buf_A_out,
        Buf_B_out   => sig_Buf_B_out,
        Mem_1_out   => sig_Mem_1_out,
        Mem_2_out   => sig_Mem_2_out,
        MEM_SR_IN_L => sig_MEM_SR_IN_L,
        MEM_SR_IN_R => sig_MEM_SR_IN_R
    );

    Inst_ALUSELROUTE: ALUSELROUTE port map (
        SEL_ROUTE   => sig_SEL_ROUTE,
        A           => A_IN,
        B           => B_IN,
        S           => sig_S,
        s_Mem_1_out => sig_Mem_1_out,
        s_Mem_2_out => sig_Mem_2_out,
        CE_Buf_A    => sig_CE_Buf_A,
        CE_Buf_B    => sig_CE_Buf_B,
        CE_Mem_1    => sig_CE_Mem_1,
        CE_Mem_2    => sig_CE_Mem_2,
        Buf_A_in    => sig_Buf_A_in,
        Buf_B_in    => sig_Buf_B_in,
        Mem_1_In    => sig_Mem_1_in,
        Mem_2_In    => sig_Mem_2_in
    );

    Inst_MEM_SEL_OUT_MUX: MEM_SEL_OUT_MUX port map (
        CLK         => CLK,
        RESET       => RESET,
        SEL_OUT     => sig_SEL_OUT,
        S           => sig_S,
        MEM_CACHE_1 => sig_Mem_1_out,
        MEM_CACHE_2 => sig_Mem_2_out,
        RES_OUT     => RES_OUT
    );
    DONE <= '1' when sig_SEL_OUT /= "00" else '0';
    SR_OUT_L <= sig_SR_OUT_L;
    SR_OUT_R <= sig_SR_OUT_R;

end Structural;