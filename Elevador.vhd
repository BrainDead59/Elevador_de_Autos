library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.std_logic_unsigned.all;

entity Elevador is
	port(clk: in std_logic;
		  controlServo: out std_logic;	  
		  mot: out std_logic_vector(3 downto 0);
		  botonB: in std_logic;
		  botonS: in std_logic;
		  sensor_disp: out std_logic;
		  sensor_eco: in std_logic;
		  letrero1: out std_logic_vector(6 downto 0);
		  letrero2: out std_logic_vector(6 downto 0);
		  inicio: in std_logic);
end Elevador;

architecture Behavioral of Elevador is
	component DivisorServomotor is
		port(clk: in std_logic;
			  div_clk: out std_logic);
	end component;
	
	component PWMServomotor is 
		port(reloj: in std_logic;
			  d: in std_logic_vector(15 downto 0);
			  s: out std_logic);
	end component;
	
	Component MotorPasos is
	Port(paso: in std_logic;
		  ud: in std_logic;
		  fh: in std_logic_vector(1 downto 0);
		  mot: out std_logic_vector(3 downto 0));
	end Component;
	
	component Sensor is
		port(clk: std_logic;
			  sensor_disp: out std_logic;
			  sensor_eco: in std_logic;
			  digitou: out unsigned(3 downto 0);
			  digitod: out unsigned(3 downto 0);
			  digitoc: out unsigned(3 downto 0);
			  binarioS: out unsigned(9 downto 0);
			  inicio: in std_logic);
	end component;
	
	--Señales Servomotor
	signal reloj: std_logic;
	signal ancho: std_logic_vector(15 downto 0):=X"0CCC";
	
	--Señales Motor
	signal paso: std_logic:='0';
	signal direccion: std_logic;
	signal clks: std_logic;
	signal div: std_logic_vector(17 downto 0);
	
	--Señales sensor
	signal digitou: unsigned(3 downto 0);
	signal digitod: unsigned(3 downto 0);
	signal digitoc: unsigned(3 downto 0);
	signal distancia: unsigned(9 downto 0);
	
	signal boton1 : std_logic_vector(2 downto 0); --subir
   signal boton2 : std_logic_vector(2 downto 0); --bajar
	
	signal botones : std_logic_vector(1 downto 0):="00";
	 
	signal Subiendo: std_logic:='0';
	
	-- Estados implementados
	type estado is(PB,P1,P2,P3,Subiendo1,Subiendo2,Subiendo3,Bajando1,Bajando2,Bajando3);
	signal estado_pres: estado:=PB;
	signal estado_sig: estado;

begin --Instancias de los modulos usados
	U1: DivisorServomotor port map(clk,reloj);
	U2: PWMServomotor port map(reloj,ancho,controlServo);
	U3: MotorPasos port map (paso,direccion,"01", mot);
	U4: Sensor port map(clk, sensor_disp, sensor_eco, digitou, digitod, digitoc, distancia, '1');
	
	--Proceso del divisor para el motor a pasos.
	DivisorMotor:process(clk)
	begin 
		if clk'event and clk='1' then
			div <=div+1;
		end if;
	end process;
	clks<=div(17);
	
	--Reloj para los estados del modelos conceptual
	process(clks)
	begin
		if clks'event and clks='1' then
			estado_pres <= estado_sig;
		end if;
	end process;
	
	--comprobacion de cual boton se aprieta.
	process(boton1,boton2,botonS,botonB)
	begin
		if clks'event and clks='1' then
			boton1 <= boton1(boton1'left-1 downto 0) & botonS;
         boton2 <= boton2(boton2'left-1 downto 0) & botonB;
			
			if boton1(boton1'left downto boton1'left-1) = "01" then -- Button1 rising
				botones<="01";
         elsif boton2(boton2'left downto boton2'left-1) = "01" then -- Button2 rising
				botones<="10";
			else
				botones<="00";	
         end if;
		end if;
	end process;
	
	--Comprobacion de la distancia que indica el sensor para saber cual es el estado actual y cual sera el siguiente
	process (estado_pres,estado_sig,distancia,botones)
	begin
		case(estado_pres) is
		
			when PB =>
				if botones="01" and distancia="00101" then
					estado_sig<=Subiendo1;
				else
					estado_sig<=PB;
				end if;
				
			when Subiendo1 =>
					if distancia<="01010" then
						estado_sig<=Subiendo1;
					else
						estado_sig<=P1;
					end if;
					
			when P1 =>
				if distancia >="01010" and distancia<"01100" and botones="01" then
					estado_sig<=Subiendo2;
				elsif distancia >="01010" and distancia<"01100" and botones="10" then
					estado_sig<=Bajando1;
				else
					estado_sig<=P1;
				end if;
			
			when Subiendo2 =>
					if distancia<"01111" then
						estado_sig<=Subiendo2;
					else
						estado_sig<=P2;
					end if;
			
			when Bajando1 =>
					if distancia>"00101" then
						estado_sig<=Bajando1;
					else
						estado_sig<=PB;
					end if;	
			
			when P2 =>
				if distancia >="01110" and distancia <"10001" and botones="01" then
					estado_sig<=Subiendo3;
				elsif distancia >="01110" and distancia <"10001" and botones="10" then
					estado_sig<=Bajando2;
				else
					estado_sig<=P2;
				end if;	
			
			when Subiendo3 =>
					if distancia<"10100" then
						estado_sig<=Subiendo3;
					else
						estado_sig<=P3;
					end if;
			
			when Bajando2 =>
					if distancia>"01010" then
						estado_sig<=Bajando2;
					else
						estado_sig<=P1;
					end if;	
			
			when P3 =>
				if distancia >="10011" and distancia <"10110" and botones="10" then
					estado_sig<=Bajando3;
				else
					estado_sig<=P3;
				end if;	
				
			when Bajando3 =>
					if distancia>"01110" then
						estado_sig<=Bajando3;
					else
						estado_sig<=P2;
					end if;	
				
			when others=>
			
		end case;
	end process;
	
	--Asignacion de los valores para las instancias del, motor, servomotor, sensor y displays
	process(estado_pres,paso,clks,direccion)
	begin
		case estado_pres is
				
			when Subiendo1  => 
				letrero1<="1111001";--1
				letrero2<="0010010";--S
				direccion <= '0';
				paso <= clks;
				ancho<=x"0fff";
			
			when Subiendo2 => 
				letrero1<="0100100";--2
				letrero2<="0010010";--S
				direccion <= '0';
				paso <= clks;
				ancho<=x"0fff";
			
			when Subiendo3 => 
				letrero1<="0110000";--3
				letrero2<="0010010";--S
				direccion <= '0';
				paso <= clks;
				ancho<=x"0fff";
			
			when Bajando1 =>
				letrero1<="1111001";-- B
				letrero2<="0000000";-- 1
				direccion <= '1';
				paso <= clks;
				ancho<=x"0fff";
				
			when Bajando2 =>
				letrero1<="0100100";-- B
				letrero2<="0000000";-- 2
				direccion <= '1';
				paso <= clks;
				ancho<=x"0fff";
				
			when Bajando3 =>
				letrero1<="0110000";-- B
				letrero2<="0000000";-- 3
				direccion <= '1';
				paso <= clks;
				ancho<=x"0fff";
				
			when PB => 
				letrero1<="0000000";-- B
				letrero2<="0001100";-- P
				paso <= '0';
				ancho<=x"1998";
				
			when P1 =>
				letrero1<="1111001";--1
				letrero2<="0001100";--P
				paso <= '0';
				ancho<=x"1998";
				
			when P2 =>
				letrero1<="0100100";--2
				letrero2<="0001100";--P
				paso <= '0';
				ancho<=x"1998";
				
			when P3 =>
				letrero1<="0110000";--3
				letrero2<="0001100";--P
				paso <= '0';
				ancho<=x"1998";
			
			when others => 
				letrero1<="0000000";--1111001
				letrero2<="0000000";--0000000
				paso <= '0';
		end case;
	end process;
	
end Behavioral;