library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_MISC.ALL;

entity ALU is

    Port ( clock: in STD_LOGIC;
           e : in STD_LOGIC;
           inp1 : in STD_LOGIC_VECTOR (7 downto 0);
           inp2 : in STD_LOGIC_VECTOR (7 downto 0);
           sel : in STD_LOGIC_VECTOR (2 downto 0);
           result : out STD_LOGIC_VECTOR (7 downto 0);
           sr : out STD_LOGIC_VECTOR (7 downto 0));
end ALU;

architecture Behavioral of ALU is

begin
process(clock)
variable temp: std_logic_vector(7 downto 0);
variable o,c,ac,p,s,z: std_logic;
begin
o:='0';
c:='0';
ac:='0';
p:='0';
s:='0';
z:='0';

if(clock = '1' and clock'event)then
if(e = '1')then

case sel is

when "000" => temp := signed(inp1) + signed(inp2);
if(inp1(7)= inp2(7) and temp(7)/=inp1(7))then
o:= '1';
end if;

when "001" => temp := signed(inp1) - signed(inp2);
if(inp1(7)/=inp2(7) and temp(7)/=inp1(7))then
o:= '1';
end if;

when "010" => temp := signed(inp1) + 1;
if(temp(7)/=inp1(7))then
o:= '1';
end if;

when "011" => temp := signed(inp1) - 1;
if(temp(7)/=inp1(7) and inp1(7)='0')then
o:= '1';
end if;

when "100" => temp := inp1 and inp2;

when "101" => temp := inp1 or inp2;

when "110" => temp := inp1 xor inp2;

when "111" => temp := not inp1 ;

when others => temp := "XXXXXXXX";

end case;

else temp := "XXXXXXXX";
end if;

if(temp="00000000")then
z:='1';
end if;

p:= xor_reduce(temp);

if(sel< "100")then
if(((inp1(7) and inp2(7)) or (inp1(7) and not temp(7)) or (not temp(7) and inp2(7))) = '1') then 
c:= '1';
end if;
if(((inp1(3) and inp2(3)) or (inp1(3) and not temp(3)) or (not temp(3) and inp2(3))) = '1') then 
ac:= '1';
end if;
s:=temp(7);
end if;

end if;

sr <= c & ac & p & s & z & o & '0' & '0';
result <= temp;

end process;
end Behavioral;
