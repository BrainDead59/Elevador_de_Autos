library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity MotorPasos is
	port(paso: in std_logic;
			ud: in std_logic;
			fh: in std_logic_vector(1 downto 0);
			mot: out std_logic_vector(3 downto 0));
end MotorPasos;

architecture behavioral of MotorPasos is
	type estado is(sm0,sm1,sm2,sm3,sm4,sm5,sm6,sm7,sm8,sm9,sm10);
	signal pres_s:estado;
	signal next_s:estado;
	signal motor: std_logic_vector(3 downto 0);

begin
	process (paso)
	begin
		if paso'event and paso='1' then
			pres_s <= next_s;
		end if;
	end process;
	
	process (pres_s,ud,fh)
	begin
		case(pres_s) is
			when sm0 =>
				next_s<=sm1;
			when sm1 => -- estado 1
				if fh="00" then
					if ud='1' then
						next_s <= sm3;
					else
						next_s <=sm7;
					end if;
				elsif fh="01" then
					if ud='1' then
						next_s <= sm2;
					else
						next_s <=sm8;
					end if;
				elsif fh="10" then
					if ud='1' then
						next_s <= sm2;
					else
						next_s <=sm8;
					end if;
				elsif fh="11" then
					if ud='1' then
						next_s <= sm9;
					else
						next_s <=sm4;
					end if;
				else
					next_s<=sm1;
				end if;
			when sm2 =>
				if fh="00" then
					if ud='1' then
						next_s <= sm1;
					else
						next_s <=sm7;
					end if;
				elsif fh="01" then
					if ud='1' then
						next_s <= sm4;
					else
						next_s <=sm8;
					end if;
				elsif fh="10" then
					if ud='1' then
						next_s <= sm3;
					else
						next_s <=sm1;
					end if;
				elsif fh="11" then
					if ud='1' then
						next_s <= sm9;
					else
						next_s <=sm4;
					end if;
				else
					next_s<=sm2;
				end if;
			when sm3 =>
				if fh="00" then
					if ud='1' then
						next_s <= sm5;
					else
						next_s <=sm1;
					end if;
				elsif fh="01" then
					if ud='1' then
						next_s <= sm2;
					else
						next_s <=sm8;
					end if;
				elsif fh="10" then
					if ud='1' then
						next_s <= sm4;
					else
						next_s <=sm2;
					end if;
				elsif fh="11" then
					if ud='1' then
						next_s <= sm9;
					else
						next_s <=sm4;
					end if;
				else
					next_s<=sm3;
				end if;
			when sm4 =>
				if fh="00" then
					if ud='1' then
						next_s <= sm1;
					else
						next_s <=sm7;
					end if;
				elsif fh="01" then
					if ud='1' then
						next_s <= sm6;
					else
						next_s <=sm2;
					end if;
				elsif fh="10" then
					if ud='1' then
						next_s <= sm5;
					else
						next_s <=sm3;
					end if;
				elsif fh="11" then
					if ud='1' then
						next_s <= sm9;
					else
						next_s <=sm10;
					end if;
				else
					next_s<=sm4;
				end if;
			when sm5 =>
				if fh="00" then
					if ud='1' then
						next_s <= sm7;
					else
						next_s <=sm3;
					end if;
				elsif fh="01" then
					if ud='1' then
						next_s <= sm2;
					else
						next_s <=sm8;
					end if;
				elsif fh="10" then
					if ud='1' then
						next_s <= sm6;
					else
						next_s <=sm4;
					end if;
				elsif fh="11" then
					if ud='1' then
						next_s <= sm9;
					else
						next_s <=sm4;
					end if;
				else
					next_s<=sm3;
				end if;
			when sm6 =>
				if fh="00" then
					if ud='1' then
						next_s <= sm1;
					else
						next_s <=sm7;
					end if;
				elsif fh="01" then
					if ud='1' then
						next_s <= sm8;
					else
						next_s <=sm4;
					end if;
				elsif fh="10" then
					if ud='1' then
						next_s <= sm7;
					else
						next_s <=sm5;
					end if;
				elsif fh="11" then
					if ud='1' then
						next_s <= sm9;
					else
						next_s <=sm4;
					end if;
				else
					next_s<=sm7;
				end if;
			when sm7 =>
				if fh="00" then
					if ud='1' then
						next_s <= sm1;
					else
						next_s <=sm5;
					end if;
				elsif fh="01" then
					if ud='1' then
						next_s <= sm2;
					else
						next_s <=sm8;
					end if;
				elsif fh="10" then
					if ud='1' then
						next_s <= sm8;
					else
						next_s <=sm6;
					end if;
				elsif fh="11" then
					if ud='1' then
						next_s <= sm9;
					else
						next_s <=sm4;
					end if;
				else
					next_s<=sm7;
				end if;
			when sm8 =>
				if fh="00" then
					if ud='1' then
						next_s <= sm1;
					else
						next_s <=sm7;
					end if;
				elsif fh="01" then
					if ud='1' then
						next_s <= sm2;
					else
						next_s <=sm6;
					end if;
				elsif fh="10" then
					if ud='1' then
						next_s <= sm1;
					else
						next_s <=sm7;
					end if;
				elsif fh="11" then
					if ud='1' then
						next_s <= sm10;
					else
						next_s <=sm9;
					end if;
				else
					next_s<=sm8;
				end if;
			when sm9 =>
				if fh="00" then
					if ud='1' then
						next_s <= sm1;
					else
						next_s <=sm7;
					end if;
				elsif fh="01" then
					if ud='1' then
						next_s <= sm2;
					else
						next_s <=sm8;
					end if;
				elsif fh="10" then
					if ud='1' then
						next_s <= sm1;
					else
						next_s <=sm8;
					end if;
				elsif fh="11" then
					if ud='1' then
						next_s <= sm8;
					else
						next_s <=sm4;
					end if;
				else
					next_s<=sm9;
				end if;
			when sm10 =>
				if fh="00" then
					if ud='1' then
						next_s <= sm1;
					else
						next_s <=sm7;
					end if;
				elsif fh="01" then
					if ud='1' then
						next_s <= sm2;
					else
						next_s <=sm8;
					end if;
				elsif fh="10" then
					if ud='1' then
						next_s <= sm1;
					else
						next_s <=sm8;
					end if;
				elsif fh="11" then
					if ud='1' then
						next_s <= sm4;
					else
						next_s <=sm8;
					end if;
				else
					next_s<=sm10;
				end if;
			when others => next_s<=sm0;
		end case;
	end process;
	
	process(pres_s)
	begin
		case pres_s is
			when sm0 => motor <= "0000";
			when sm1 => motor <= "1000";
			when sm2 => motor <= "1100";
			when sm3 => motor <= "0100";
			when sm4 => motor <= "0110";
			when sm5 => motor <= "0010";--7-5-3-1
			when sm6 => motor <= "0011";
			when sm7 => motor <= "0001";
			when sm8 => motor <= "1001";
			when sm9 => motor <= "1010";
			when sm10 => motor <= "0101";
			when others => motor <= "0000";
		end case;
	end process;
	
	mot<=motor;

end behavioral;