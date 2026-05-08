----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/18/2025 02:50:18 PM
-- Design Name: 
-- Module Name: ALU - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ALU is
    Port ( i_A : in STD_LOGIC_VECTOR (7 downto 0);
           i_B : in STD_LOGIC_VECTOR (7 downto 0);
           i_op : in STD_LOGIC_VECTOR (2 downto 0);
           o_result : out STD_LOGIC_VECTOR (7 downto 0);
           o_flags : out STD_LOGIC_VECTOR (3 downto 0));
end ALU;

architecture Behavioral of ALU is
    
    signal w_A : unsigned(7 downto 0);
    signal w_B : unsigned(7 downto 0);   
    signal w_result : unsigned(7 downto 0);
    signal w_carry : unsigned(8 downto 0);
    signal w_flags : std_logic_vector(3 downto 0);
    
begin

    w_A <= unsigned(i_A);
    w_B <= unsigned(i_B);
    
    process(i_op, w_A, w_B) begin
        case i_op is
            when "000" => -- add
                w_result <= w_A + w_B;
                w_carry <= ('0' & w_A) + ('0' & w_B);
            when "001" => -- subtract
                w_result <= w_A + (not w_B) + 1;
                w_carry <= ('0' & w_A) + ('0' & (not w_B) + 1);
            when "010" => -- and
                w_result <= w_A and w_B;
                w_carry <= (others => '0');
            when "011" => -- or
                w_result <= w_A or w_B;
                w_carry <= (others => '0');
            when others =>
                w_result <= (others => '0');
                w_carry <= (others => '0');
        end case;
    end process;
    
    -- Concurrent statements
    o_result <= std_logic_vector(w_result);
    
    w_flags(3) <= w_result(7);
    w_flags(2) <= '1' when w_result = x"00" else '0';
    w_flags(1) <= w_carry(8);
    w_flags(0) <= (w_A(7) and w_B(7) and (not w_result(7))) or ((not w_A(7)) and (not w_B(7)) and w_result(7)) when (i_op = "000") else
                  (w_A(7) and (not w_B(7)) and (not w_result(7))) or ((not w_A(7)) and w_B(7) and w_result(7)) when (i_op = "001") else '0';
    
    o_flags <= w_flags;
    
    
end Behavioral;
