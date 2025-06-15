
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity reg is
    Port ( x : in STD_LOGIC_VECTOR (7 downto 0);
           y : out STD_LOGIC_VECTOR (7 downto 0);
           E : in STD_LOGIC;
           L: in STD_LOGIC;
           clock : in STD_LOGIC);
end reg;

architecture Behavioral of reg is

begin
process(clock)
variable temp : std_logic_vector(7 downto 0);
begin
if( clock = '1' and clock'event)then
if(L = '1')then
temp := x;
elsif(E = '1')then
y <= temp;
else
y <= "XXXXXXXX";
end if;
end if;
end process;
end Behavioral;
