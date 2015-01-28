Library Ieee;
Use Ieee.Std_Logic_1164.all;


Entity Mips8B_DataPath is
    Generic(      N:      Natural := 8;
            RF_SIZE:      Natural := 8;
            SH_SIZE:      Natural := 3;
            RF_ADDR_SIZE: Natural := 3);
    Port(clock:           in  Std_Logic;
         -- Controle dos Registradores do Shift Register.
         en_Reg_SH:       in  Std_Logic;
         -- Controle para Shifter.
         crt_SH:          in Std_Logic_Vector(1 downto 0);
         S_SH:            in Std_Logic_Vector(SH_SIZE-1 downto 0);
         -- Controle dos Registradores da ULA.
         en_R1A_ULA:      in  Std_Logic;
         en_R1B_ULA:      in  Std_Logic;
         en_R2_ULA:       in  Std_Logic;
         -- Controle para ULA.
         crt_ULA:         in  Std_Logic_Vector(2 downto 0);
         crt_Mux_ULA:     in  Std_Logic_Vector(1 downto 0);
         -- Controle para Register File.
         crt_RFile:       in  Std_Logic;
         crt_Mux_RF:      in  Std_Logic;
         address_RF:      in  Std_Logic_Vector(RF_ADDR_SIZE-1 downto 0);
         en_Raddress_RF:  in  Std_logic;
         -- Controle para o Acumulador.
         crt_Acc:         in  Std_Logic_Vector(1 downto 0);
         crt_Mux_Acc:     in  Std_Logic;
         -- Entradas do Datapath.
         in_PC:           in  Std_Logic_Vector(N-3 downto 0);
         in_IMM:          in  Std_Logic_Vector(N-1 downto 0);
         -- Flag de Igualdade de Operandos.
         eq_Flag:         out Std_Logic;
         -- Saida do resultado do Acumulador.
         out_Acc:         out Std_Logic_Vector(N-1 downto 0));
End Entity Mips8B_DataPath;


Architecture behave of Mips8B_DataPath is

    Use Ieee.Numeric_Std.all;
    Use Work.MIPS8B_Base.all;

    type mem_type is Array(Natural Range <>) of Std_Logic_Vector(N-1 downto 0);


    -- Repesentacao do Register File
    Signal RFile_Mem:   mem_type(1 to RF_SIZE-1);
    Signal Raddress_RF: Std_Logic_Vector(RF_ADDR_SIZE-1 downto 0);
    Signal out_RF:      Std_Logic_Vector(N-1 downto 0);

    -- Representacao das saidas dos multiplexadores.
    Signal mux_R2A_ULA, mux_R2B_ULA: Std_Logic_Vector(N-1 downto 0);
    Signal mux_RF, mux_Acc:          Std_Logic_Vector(N-1 downto 0);

    -- Saida do Acumulador
    Signal int_out_Acc: Std_Logic_Vector(N-1 downto 0);

    -- Registradores para os operandos na ULA e no Shifter.
    Signal R1A_ULA, R1B_ULA: Std_Logic_Vector(N-1 downto 0);
    Signal R2A_ULA, R2B_ULA: Std_Logic_Vector(N-1 downto 0);
    Signal RCRT_ULA: Std_Logic_Vector(2 downto 0);
    Signal RD_SH:    Std_Logic_Vector(N-1 downto 0);
    Signal RS_SH:    Std_Logic_Vector(SH_SIZE-1 downto 0);
    Signal RCRT_SH:  Std_Logic_Vector(1 downto 0);

    -- Resulatdos da ULA e do Shifter.
    Signal res_ULA, res_SH: Std_Logic_Vector(N-1 downto 0);
    Signal Flags: Std_Logic_Vector(1 downto 0);

Begin

    -- Saida do Acumulador para fora do Datapath
    out_Acc <= int_out_Acc;

    -- Flag de Igualdade.
    eq_Flag <= Flags(1);

    ---------------------------------------------------------------------------
    -- Controle dos multiplexadores.
    With crt_Mux_ULA(1) select
        mux_R2A_ULA <= R1A_ULA       when '0',
                       "00" & in_PC  when others;       

    With crt_Mux_ULA(0) select
        mux_R2B_ULA <= R1B_ULA when '0',
                       in_IMM when others;       

    With crt_Mux_Acc select
        mux_Acc <= res_ULA when '0',
                   res_SH  when others;       

    With crt_Mux_RF select
        mux_RF <= int_out_Acc when '0',
                  in_IMM      when others;       

    ---------------------------------------------------------------------------
    -- Representalcao do Register File.
    RFILE_PROCESS: Process(clock,crt_RFile,Raddress_RF,RFile_Mem,mux_RF)

    Begin
        If clock'event and clock ='1' then
            If Raddress_RF /= R0 and crt_RFile = '1' then
                RFile_Mem(to_integer(to_01(Unsigned(Raddress_RF),'1'))) <= mux_RF;
            End If;
        End If;

        If Raddress_RF /= R0  then
            out_RF <= RFile_Mem(to_integer(to_01(Unsigned(Raddress_RF),'1')));
        Else
            out_RF <= (Others => '0');
        End If;

    End Process RFILE_PROCESS;

    ---------------------------------------------------------------------------
    -- Processo responsavel pela controle dos registradores intermediarios.
    MIPS8B_Regs: Process

    Begin
        Wait Until clock'Event and clock = '1';

	If en_Raddress_RF = '1' then
           Raddress_RF <= address_RF;
        End If;

        If en_R1A_ULA = '1' then
            R1A_ULA <= out_RF;
        End If;

        If en_R1B_ULA = '1' then
            R1B_ULA <= out_RF;
        End If;

        If en_R2_ULA = '1' then
            R2A_ULA  <= mux_R2A_ULA;
            R2B_ULA  <= mux_R2B_ULA;
            RCRT_ULA <= crt_ULA;
        End If;

        If en_Reg_SH = '1' then
            RD_SH   <= R1A_ULA;
            RS_SH   <= S_SH;
            RCRT_SH <= crt_SH;
        End If;

    End Process MIPS8B_Regs;

    ---------------------------------------------------------------------------
    -- Processo responsavel pelas operacoes logicas e aritmeticas
    MIPS8B_ULA: Process(R2A_ULA,R2B_ULA,RCRT_ULA,R1A_ULA,R1B_ULA)
        Variable TempA, TempB, TempResult: Signed(N downto 0);
    Begin
        -- Copiando as entradas para execucao das operacoes aritmeticas
        TempA := Signed(R2A_ULA(N-1) & R2A_ULA);
        TempB := Signed(R2B_ULA(N-1) & R2B_ULA);

    -- Realizando a operacao aritimetica
    Case RCRT_ULA is
        When uSUB =>
            TempResult := TempA - TempB;
        When uAND =>
            TempResult := TempA and TempB;
        When uOR =>
            TempResult := TempA or TempB;
        When Others =>
            TempResult := TempA + TempB;
    End Case;

    -- Levando os resultados para Saida
    res_ULA <= Std_Logic_Vector(TempResult(N-1 downto 0));

    -- Flag para resultado negativo.
    Flags(0) <= TempResult(N);

    -- Flag para igualdade.
    If R1A_ULA = R1B_ULA then
        Flags(1) <= '1';
    Else
        Flags(1) <= '0';
    End If;

    End Process MIPS8B_ULA;

    ---------------------------------------------------------------------------
    -- Processo responsavel pelas operacoes de Shifter
    MIPS8B_SHIFTER: Process(RD_SH,RS_SH,RCRT_SH)

    Begin
       Case RCRT_SH is
           When   sRAR =>
               res_SH <= Std_Logic_Vector(SHIFT_RIGHT(Signed(RD_SH),to_integer(Unsigned(RS_SH))));
           When   sRLL =>
               res_SH <= Std_Logic_Vector(SHIFT_RIGHT(Unsigned(RD_SH),to_integer(Unsigned(RS_SH))));
           When Others =>
               res_SH <= Std_Logic_Vector(SHIFT_LEFT(Signed(RD_SH),to_integer(Unsigned(RS_SH))));
       End Case;

    End Process MIPS8B_SHIFTER;

    ---------------------------------------------------------------------------
    -- Processo responsavel pelas operacoes no Acumulador
    Acc: Process
        Variable Temp: Std_Logic_Vector(N-1 downto 0);
    Begin

        Wait Until clock'Event and clock = '1';

        Case crt_Acc is
            When AccPar =>
                int_out_Acc <= mux_Acc;

            When AccFlag =>
                Temp := (Others => '0');
                If Flags ="01" then    -- Comparacao resultou em Menor
                    Temp(0) := '1';
                End If;
                int_out_Acc <= Temp;

            When Others =>

        End Case;

    End Process Acc;

End Architecture behave;

Configuration Mips8B_DataPath_behave_conf of Mips8B_DataPath is
    For behave
    End For;
End Configuration Mips8B_DataPath_behave_conf;

