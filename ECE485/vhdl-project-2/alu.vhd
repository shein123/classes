library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity alu8 is
port(
		clk : in std_logic;
		s	: in std_logic;
		ov, zero	: out std_logic;
		a,b : in signed(7 downto 0);
		op  : in unsigned(2 downto 0);
		y	: out signed(7 downto 0)

		);
end alu8;

architecture Behavioral of alu8 is

signal temp9: signed(8 downto 0);
signal temp: signed(7 downto 0);

begin
process(clk)
begin
	if(rising_edge(clk)) then
		case op is 
			when "000" =>
				temp <= a AND b;
			when "001" =>
				if s = '1' then
					temp <= NOT a;
				else 
					temp <= NOT b;
				end if;
			when "010" =>
				temp9 <= (a(7)& a) + (b(7) & b);
				if temp9(8) /= temp9(7) then
					ov <= '1'; --overflow!
				else
					ov <= '0';
				end if;
				--unsigned on temp so resize doesn't save the sign
				temp <= signed(resize(unsigned(temp9), temp'length)); 
			when "011" =>
				if(a < b) then
					temp <= "11111111";
				else
					temp <= "00000000";
				end if;
			when "100" =>
				temp9 <= (a(7)& a) - (b(7) & b);
				if temp9(8) /= temp9(7) then
					ov <= '1'; --underflow!
				else ov <= '0';
				end if;
				--unsigned on temp so resize doesn't save the sign
				temp <= signed(resize(unsigned(temp9), y'length));
			when "101" =>
				temp <= a XOR b;
			when "110" =>
				if s = '1' then
					temp <= SHIFT_LEFT(a,1);
				else 
					temp <= SHIFT_LEFT(b,1);
				end if;
			when "111" =>
				if s = '1' then
					temp <= SHIFT_RIGHT(a,1);
				else 
					temp <= SHIFT_RIGHT(b,1);
				end if;
			when others =>
				NULL; --default case
		end case;
		if temp = "00000000" then
			zero <= '1';
		else
			zero <= '0';
		end if;
		y <= temp;
	end if;
end process;

end Behavioral;
