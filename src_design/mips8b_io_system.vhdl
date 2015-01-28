Library Ieee;
Use Ieee.Std_Logic_1164.all;
Use Work.MIPS8B_Base.all;

Entity MIPS8B_IO_System is
    Generic(N: Natural := 8);
    Port(clock:        in  Std_Logic;
         Reset_n:      in  Std_Logic;
         -- Controle do endereço fornecido pelo sistema
         en_RMem:      in  Std_Logic;
         en_RMem_Inc:  in  Std_Logic;
         crt_Mux_IO:   in  Std_Logic;
         crt_MEM:      in  MemoryOP;
         -- Controle dos Dados de I/O.
         en_RData_in:  in  Std_Logic;
         en_RData_out: in  Std_Logic;
         -- Valores de endereço para transações de I/O.
         out_PC:       in  Std_Logic_Vector(N-3 downto 0);
         out_DPath:    in  Std_Logic_Vector(N-1 downto 0);
         in_Data:      in  Std_Logic_Vector(N-1 downto 0);
         -- Registradores para dados de I/O.
         RMem:         out Std_Logic_Vector(N-1 downto 0);
         RData_in:     out Std_Logic_Vector(N-1 downto 0);
         RData_out:    out Std_Logic_Vector(N-1 downto 0);
         -- Interface de controle.
         Cmd:          out Std_Logic_Vector(1 downto 0);
         CmdAccept:    in  Std_Logic;
         IO_OK:        out Std_Logic);
End Entity MIPS8B_IO_System;

Architecture behave of MIPS8B_IO_System is

    Use Ieee.Numeric_Std.all;

    -- Sinais para representação do estado.
    Signal IO_State, next_IO_State: IOSTD;

    -- Sinal para o próximo endereço a ser acessado.
    Signal int_RMem, next_RMem: Unsigned(N-1 downto 0);

Begin

    ---------------------------------------------------------------------------
    ---------------------------------------------------------------------------
    -- Lógica para o próximo estado.
    NEXT_IOS_COMB: Process(crt_MEM,CmdAccept,IO_State)
        Variable Temp_next_IO_State: IOSTD;
    Begin
        Temp_next_IO_State := IO_State;

        Case IO_State is
            When ioIDLE  =>
                If crt_MEM = mcREAD then
                    Temp_next_IO_State := ioREAD;
                ElsIf crt_MEM = mcWRITE then
                    Temp_next_IO_State := ioWRITE;
                End If;
            When ioREAD|ioWRITE =>
                If CmdAccept = ocpDVA_little then
                    Temp_next_IO_State := ioIO_OK;
                End If;
            When Others =>
                If crt_MEM = mcREAD then
                    Temp_next_IO_State := ioREAD;
                Else
                    Temp_next_IO_State := ioIDLE;
                End If;
        End Case;

	next_IO_State <= Temp_next_IO_State;

    End Process NEXT_IOS_COMB;

    ---------------------------------------------------------------------------
    NEXT_IOS_SYNC: Process

    Begin
        Wait Until clock'event and clock = '1';

	If Reset_n = '0' then
            IO_State <= ioIDLE;
        Else
            IO_State <= next_IO_State;
        End If;

    End Process NEXT_IOS_SYNC;

    ---------------------------------------------------------------------------
    DECOD_STATE: Process(IO_State)
        Variable Temp_Cmd:   Std_Logic_Vector(1 downto 0);
        Variable Temp_IO_OK: Std_Logic;
    Begin
        Temp_Cmd   := ocpIDLE_little;
        Temp_IO_OK := '0';

	Case IO_State is
            When ioREAD  => Temp_Cmd := ocpRD_little;
            When ioWRITE => Temp_Cmd := ocpWR_little;
            When ioIO_OK => Temp_IO_OK := '1';
            When Others =>
        End Case;

        Cmd   <= Temp_Cmd;
	IO_OK <= Temp_IO_OK;

    End Process DECOD_STATE;

    ---------------------------------------------------------------------------
    ---------------------------------------------------------------------------
    -- Lógica para o próximo endereço.
    RMem <= Std_Logic_Vector(int_RMem);

    NEXT_RMEM_COMB: Process(int_RMem,crt_Mux_IO,en_RMem,out_PC,out_DPath)
        Variable Temp_next_RMem: Unsigned(N-1 downto 0);
        Variable Temp_control: Unsigned(1 downto 0);
    Begin
	Temp_control   := crt_Mux_IO & en_RMem;

        Case Temp_control is
            When "01"   => Temp_next_RMem := Unsigned(out_PC & "00");
            When "11"   => Temp_next_RMem := Unsigned(out_DPath);
            When Others => Temp_next_RMem := int_RMem + 1;
        End Case;

        next_RMem <= Temp_next_RMem;

    End Process NEXT_RMEM_COMB;

    ---------------------------------------------------------------------------
    RCONTROL_SYNC: Process

    Begin
        Wait Until clock'event and clock = '1';

        If en_RMem = '1' or en_RMem_Inc = '1' then
            int_RMem <= next_RMem;
        End If;

	If en_RData_in = '1' and CmdAccept = '1' then
            RData_in <= in_Data;
        End If;

	If en_RData_out = '1' then
            RData_out <= out_DPath;
        End If;

    End Process RCONTROL_SYNC;

    ---------------------------------------------------------------------------

End Architecture behave;

Configuration MIPS8B_IO_System_behave_conf of MIPS8B_IO_System is
    For behave
    End For;
End Configuration MIPS8B_IO_System_behave_conf;

