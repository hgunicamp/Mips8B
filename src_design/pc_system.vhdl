Library Ieee;
Use Ieee.Std_logic_1164.all;

Entity PC_System is
    Generic(N:   Natural := 8);
    Port(clock:      in  Std_Logic;
         Reset_n:    in  Std_Logic;
         en_Out_PC:  in  Std_Logic;
         load_PC:    in  Std_Logic;
         inc_PC:     in  Std_Logic;
         in_PC:      in  Std_Logic_Vector(N-3 downto 0);
         out_PC:     out Std_Logic_Vector(N-3 downto 0);
         address_PC: out Std_Logic_Vector(N-3 downto 0));
End Entity PC_System;

Architecture behave of PC_System is

    -- Usando Biblioteca Aritmetica.
    Use Ieee.Numeric_Std.all;

    Signal PC_Value, next_PC_Value: Unsigned(N-3 downto 0);

Begin

    -- Endereco a ser acessado.
    address_PC <= Std_Logic_Vector(PC_Value);

    -- Processos para atualização do PC
    UPDATE_PC_COMB: Process(PC_Value,in_PC,load_PC)

    Begin
        If load_PC = '1' then
            next_PC_Value <= Unsigned(in_PC);
	Else 
            next_PC_Value <= PC_Value + 1;
        End If;

    End Process UPDATE_PC_COMB;

    UPDATE_PC_SYNC: Process

    Begin
        Wait Until clock'event and clock = '1';

	If Reset_n = '0' then
            PC_Value <= (Others => '0');
        ElsIf load_PC = '1' or inc_PC = '1' then
            PC_Value <= next_PC_Value;
        End If;

    End Process UPDATE_PC_SYNC;
	
    
    OUT_PC_VALUE: Process(en_Out_PC,PC_Value)

    Begin
        If en_Out_PC = '1' then
            out_PC <= Std_Logic_Vector(PC_Value);
        Else
            out_PC <= (Others => '0');
        End If;

    End Process OUT_PC_VALUE;

End Architecture behave;

Configuration PC_System_behave of PC_System is
    For behave
    End For;
End Configuration PC_System_behave;

