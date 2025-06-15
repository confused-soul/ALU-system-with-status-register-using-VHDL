library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ALUwithSR is
    port(
        clock : in  std_logic;
        value : inout std_logic_vector(7 downto 0);
        la    : in  std_logic;  -- Load A register
        ea    : in  std_logic;  -- Enable A register
        lb    : in  std_logic;  -- Load B register
        eb    : in  std_logic;  -- Enable B register
        ealu  : in  std_logic;  -- Enable ALU
        lsr   : in  std_logic;  -- Load Status Register
        esr   : in  std_logic;  -- Enable Status Register
        sel   : in  std_logic_vector(2 downto 0)
    );
end ALUwithSR;

architecture Behavioral of ALUwithSR is
    -- Internal signals
    signal alu_result : std_logic_vector(7 downto 0);
    signal sr_value   : std_logic_vector(7 downto 0);
    signal controls   : std_logic_vector(6 downto 0);
    
    -- Register connections
    signal ain, aout  : std_logic_vector(7 downto 0);
    signal bin, bout  : std_logic_vector(7 downto 0);
    signal srin, srout: std_logic_vector(7 downto 0);
    
    -- ALU connections
    signal aluin1     : std_logic_vector(7 downto 0);
    signal aluin2     : std_logic_vector(7 downto 0);
    signal aluout     : std_logic_vector(7 downto 0);
    signal alusrout   : std_logic_vector(7 downto 0);

    -- Component declarations
    component reg is
        Port ( 
            x     : in  STD_LOGIC_VECTOR(7 downto 0);
            y     : out STD_LOGIC_VECTOR(7 downto 0);
            E     : in  STD_LOGIC;
            L     : in  STD_LOGIC;
            clock : in  STD_LOGIC
        );
    end component;

    component ALU is
        Port ( 
            clock  : in  STD_LOGIC;
            e      : in  STD_LOGIC;
            inp1   : in  STD_LOGIC_VECTOR(7 downto 0);
            inp2   : in  STD_LOGIC_VECTOR(7 downto 0);
            sel    : in  STD_LOGIC_VECTOR(2 downto 0);
            result : out STD_LOGIC_VECTOR(7 downto 0);
            sr     : out STD_LOGIC_VECTOR(7 downto 0)
        );
    end component;

begin
    -- Component instantiations
    a_reg : reg port map(
        x     => ain,
        y     => aout,
        E     => ea,
        L     => la,
        clock => clock
    );

    b_reg : reg port map(
        x     => bin,
        y     => bout,
        E     => eb,
        L     => lb,
        clock => clock
    );

    sr_reg : reg port map(
        x     => srin,
        y     => srout,
        E     => esr,
        L     => lsr,
        clock => clock
    );

    alu_block : alu port map(
        clock  => clock,
        e      => ealu,
        inp1   => aluin1,
        inp2   => aluin2,
        sel    => sel,
        result => aluout,
        sr     => alusrout
    );

    -- Control signal concatenation (combinational)
    controls <= esr & lsr & ealu & eb & lb & ea & la;

    -- Data path logic (combinational)
    process(controls, value, aout, bout, srout, alu_result, aluout, alusrout)
    begin
        -- Default assignments to prevent latches
        ain <= value;
        bin <= value;
        aluin1 <= aout;
        aluin2 <= bout;
        srin <= sr_value;
        value <= (others => 'Z');  -- High impedance state by default

        -- Control-based assignments
        case controls is
            when "0101100" =>  -- ALU operation
                ain <= alu_result;
            
            when "0100000" =>  -- Read from A register
                value <= aout;
            
            when "0001000" =>  -- Read from B register
                value <= bout;
            
            when "0000001" =>  -- Read from Status register
                value <= srout;
            
            when others =>
                value <= (others => 'Z');
        end case;

        -- ALU result and status updates
        alu_result <= aluout;
        sr_value <= alusrout;
    end process;

end Behavioral;