library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity Sensor is 
	port( clk : in std_logic;
			sensor_disp : out std_logic;
			sensor_eco : in std_logic;
			digitou : out unsigned(3 downto 0);
			digitod : out unsigned(3 downto 0);
			digitoc : out unsigned(3 downto 0);
			binarioS : out unsigned(9 downto 0);
			inicio : in std_logic);
end Sensor;

architecture behavioral of Sensor is
	signal cuenta : unsigned(16 downto 0) := (others => '0');
	signal centimetros : unsigned(15 downto 0) := (others => '0');
	signal centimetros_unid : unsigned(3 downto 0) := (others => '0');
	signal centimetros_dece : unsigned(3 downto 0) := (others => '0');
	signal centimetros_cent : unsigned(3 downto 0) := (others => '0');
	signal centimetros_bin : unsigned(9 downto 0) := (others => '0');
	signal eco_pasado : std_logic := '0';
	signal eco_sinc : std_logic := '0';
	signal eco_nsinc : std_logic := '0';
	signal espera : std_logic := '0';
	signal siete_seg_cuenta : unsigned(15 downto 0) := (others => '0');
	signal cuenta_bin : unsigned(8 downto 0) := (others => '0');
	
begin

	trigger : process(clk)
	begin
		if rising_edge(clk) and inicio = '1' then
			if espera = '0' then
				if cuenta = 500 then
					sensor_disp <= '0';
					espera <= '1';
					cuenta <= (others => '0');
				else
					sensor_disp <= '1';
					cuenta <= cuenta + 1;
				end if;
			elsif eco_pasado = '0' and eco_sinc = '1' then
				cuenta <= (others => '0');
				centimetros <= (others => '0');
				centimetros_unid <= (others => '0');
				centimetros_dece <= (others => '0');
				centimetros_cent <= (others => '0');
				centimetros_bin <= (others => '0');
			elsif eco_pasado = '1' and eco_sinc = '0' then
				digitou <= centimetros_unid;
				digitod <= centimetros_dece;
				digitoc <= centimetros_cent;
				binarioS <= centimetros_bin;
			elsif cuenta = 2900-1 then 
				if centimetros_unid = 9 then
					centimetros_unid <= (others => '0');
					centimetros_dece <= centimetros_dece + 1;
					if centimetros_dece = 9 then
						centimetros_dece <= (others => '0');
						centimetros_cent <= centimetros_cent + 1;
					end if;
				else
					centimetros_unid <= centimetros_unid + 1;
				end if;
				centimetros <= centimetros + 1;
				centimetros_bin <= centimetros_bin + 1;
				cuenta <= (others => '0');
				if centimetros = 3448 then
					espera <= '0';
				end if;
			else
				cuenta <= cuenta + 1;
			end if;
			eco_pasado <= eco_sinc;
			eco_sinc <= eco_nsinc;
			eco_nsinc <= sensor_eco;
		end if;
	end process;

	
end behavioral;