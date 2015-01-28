Library Ieee;
Use Ieee.Std_logic_1164.all;
Use Work.MIPS8B_Base.all;

Entity MIPS8B_DP_Control is
    Generic(N:            Natural := 8;
            SH_SIZE:      Natural := 3;
            RF_ADDR_SIZE: Natural := 3);
    Port(clock:          in  Std_Logic;
         Reset_n:        in  Std_Logic;
         IO_OK:          in  Std_Logic;
         eq_Flag:        in  Std_Logic;
         Opcode:         in  Std_Logic_Vector(4 downto 0);
         in_Bus:         in  Std_Logic_Vector(N-1 downto 0);
         -- Controle para o Registrer File.
         crt_RFile:      out Std_Logic;
         en_Raddress_RF: out Std_Logic;
         address_RF:     out Std_Logic_Vector(RF_ADDR_SIZE-1 downto 0);
         -- Controle para os registradores Intermediarios.
         en_R1A_ULA:     out Std_Logic;
         en_R1B_ULA:     out Std_Logic;
         en_R2_ULA:      out Std_Logic;
         en_Reg_SH:      out Std_Logic;
         -- Controle para os multiplexadores.
         crt_Mux_ULA:    out Std_Logic_Vector(1 downto 0);
         crt_Mux_Acc:    out Std_Logic;
         crt_Mux_RF:     out Std_Logic;
         -- Controle das unidades funcionais.
         crt_ULA:        out Std_Logic_Vector(2 downto 0);
         crt_SH:         out Std_Logic_Vector(1 downto 0);
         crt_Acc:        out Std_Logic_Vector(1 downto 0);
         -- Controle do PC.
         en_Out_PC:      out Std_Logic;
         load_PC:        out Std_Logic;
         inc_PC:         out Std_Logic;
         -- Controle para o sistema de IO.
         en_ROpcode:     out Std_Logic;
         en_RMem:        out Std_Logic;
         en_RMem_Inc:    out Std_Logic;
         en_RData_in:    out Std_Logic;
         en_RData_out:   out Std_Logic;
         crt_Mux_IO:     out Std_Logic;
         crt_MEM:        out MemoryOP;
         -- Valor do comprimento do shift.
         S_SH:           out Std_Logic_Vector(SH_SIZE-1 downto 0);
         -- Valor do campo imediato
         out_IMM:        out Std_Logic_Vector(N-1 downto 0));
End Entity MIPS8B_DP_Control;

Architecture behave of MIPS8B_DP_Control is

    -- Estado da máquina de controle.
    Signal DP_State, next_DP_State: DPSTD;

    -- Interpretação dos campos do ultimo byte da instrução.
    Alias op_ULA:  Std_Logic_Vector(2 downto 0) is in_Bus(2 downto 0);
    Alias op_SH:   Std_Logic_Vector(1 downto 0) is in_Bus(6 downto 5);
    Alias size_SH: Std_Logic_Vector(SH_SIZE-1 downto 0) is in_Bus(SH_SIZE-1 downto 0);

    -- Decodificação dos registradores a serem acessados.
    Alias Ra: Std_Logic_Vector(RF_ADDR_SIZE-1 downto 0) is in_Bus(7 downto 8-RF_ADDR_SIZE);
    Alias Rb: Std_Logic_Vector(RF_ADDR_SIZE-1 downto 0) is in_Bus(RF_ADDR_SIZE-1 downto 0);
    Alias Rd: Std_Logic_Vector(RF_ADDR_SIZE-1 downto 0) is in_Bus(2+RF_ADDR_SIZE downto 3);

Begin

    -- Processos para definir o proximo estado do controle do Datapath
    DP_STATE_COMB: Process(DP_State,Opcode,IO_OK,eq_Flag)

    Begin
        Case DP_State is
            When st_Reset      => next_DP_State <= Next_Instr;
            When Next_Instr    => next_DP_State <= Wait_B1;
            When Decod_B1      => next_DP_State <= Wait_B2;
            When Decod_Ra      => next_DP_State <= Decod_Rb;
            When Decod_Rb      => next_DP_State <= Wait_B3;
            When Ignore_B2     => next_DP_State <= Wait_B3;
            When Ignore_B3     => next_DP_State <= Wait_B4;
            When Decod_Rd      => next_DP_State <= Wait_B4;
            When Decod_Funct   => next_DP_State <= Execute_funct;
            When Execute_funct => next_DP_State <= Write_RF;
            When Write_RData   => next_DP_State <= Out_Data;
    ---------------------------------------------------------------------------
            When Wait_B1 =>
                If IO_OK = '1' then
                    next_DP_State <= Decod_B1;
                Else
                    next_DP_State <= Wait_B1;
                End If;
    ---------------------------------------------------------------------------
            When Wait_B2 =>
                If IO_OK = '1' then
                    If Opcode(0) = '1' then
                        next_DP_State <= Ignore_B2;
                    Else
                        next_DP_State <= Decod_Ra;
                    End If;
                Else
                    next_DP_State <= Wait_B2;
                End If;
    ---------------------------------------------------------------------------
            When Wait_B3 =>
                If IO_OK = '1' then
                    If Opcode = "00000" then
                        next_DP_State <= Decod_Rd;
                    Else
                        next_DP_State <= Ignore_B3;
                    End If;
                Else
                    next_DP_State <= Wait_B3;
                End If;
    ---------------------------------------------------------------------------
            When Wait_B4 =>
                If IO_OK = '1' then
                    If Opcode = "00000" then
                        next_DP_State <= Decod_Funct;
                    ElsIf Opcode(1) = '1' and eq_Flag = '0' then
                        next_DP_State <= Ignore_B4;
                    Else
                        next_DP_State <= Decod_Imm;
                    End If;
                Else
                    next_DP_State <= Wait_B4;
                End If;
    ---------------------------------------------------------------------------
            When Decod_Imm =>
                If Opcode(3) = '1' then
                    next_DP_State <= Execute_funct;
                Else
                    next_DP_State <= ADDimm;
                End If;
    ---------------------------------------------------------------------------
            When ADDimm =>
                If Opcode(4) = '1' then
                    next_DP_State <= Write_RMem;
                ElsIf Opcode(2) = '1' then
                    next_DP_State <= Write_RF;
                Else
                    next_DP_State <= Write_PC;
                End If;
    ---------------------------------------------------------------------------
            When Write_RMem =>
                If Opcode(2) = '1' then
                    next_DP_State <= Write_RData;
                Else
                    next_DP_State <= IN_Data;
                End If;
    ---------------------------------------------------------------------------
            When IN_Data =>
                If IO_OK = '1' then
                    next_DP_State <= Write_RF;
                Else
                    next_DP_State <= IN_Data;
                End If;
    ---------------------------------------------------------------------------
            When Out_Data =>
                If IO_OK = '1' then
                    next_DP_State <= Next_Instr;
                Else
                    next_DP_State <= Out_Data;
                End If;
    ---------------------------------------------------------------------------
            When Others =>  next_DP_State <= Next_Instr;

        End Case;

    End Process DP_STATE_COMB;

    ---------------------------------------------------------------------------
    DP_STATE_SYNC: Process

    Begin
        Wait Until clock'event and clock = '1';

        If Reset_n = '0' then
            DP_State <= st_Reset;
        Else
            DP_State <= next_DP_State;
        End If;

    End Process DP_STATE_SYNC;

    ---------------------------------------------------------------------------
    ---------------------------------------------------------------------------
    -- Processos responsaveis pela decodificacao do estado da FSM em sinais de
    -- controle para o sistema de I/O.
    DP_STATE_DECOD_MEM: Process(DP_State,Opcode,eq_Flag)
        Variable Temp_en_RMem:      Std_Logic;
        Variable Temp_en_RMem_Inc:  Std_Logic;
        Variable Temp_en_ROpcode:   Std_Logic;
        Variable Temp_en_RData_in:  Std_Logic;
        Variable Temp_en_RData_out: Std_Logic;
        Variable Temp_crt_MEM:      MemoryOP;
    Begin
        Temp_en_RMem      := '0';
        Temp_en_RMem_Inc  := '0';
        Temp_en_ROpcode   := '0';
        Temp_en_RData_in  := '0';
        Temp_en_RData_out := '0';
        Temp_crt_MEM      := mcIDLE;

        Case DP_State is
            When Next_Instr =>
                Temp_en_RMem := '1';
                Temp_crt_MEM := mcREAD;
            When Wait_B1|IN_Data =>
                Temp_en_RData_in := '1';
            When Decod_B1 =>
                Temp_en_RMem_Inc := '1';
                Temp_en_ROpcode  := '1';
                Temp_crt_MEM     := mcREAD;
            When Wait_B2 =>
                If Opcode(0) = '0' then
                    Temp_en_RData_in := '1';
                End If;
            When Wait_B3 =>
                If Opcode = "00000" then
                    Temp_en_RData_in := '1';
                End If;
            When Wait_B4 =>
                If not(Opcode(1) = '1' and eq_Flag = '0') then
                    Temp_en_RData_in := '1';
                End If;
            When Decod_Rb|Ignore_B2|Decod_Rd|Ignore_B3 =>
                Temp_en_RMem_Inc := '1';
                Temp_crt_MEM     := mcREAD;
            When Write_RMem =>
                Temp_en_RMem := '1';
                If Opcode(2) = '0' then
                    Temp_crt_MEM := mcREAD;
                End If;
            When Write_RData =>
                Temp_en_RData_out := '1';
                Temp_crt_MEM := mcWRITE;
            When Others =>

        End Case;

        en_RMem      <= Temp_en_RMem;
        en_RMem_Inc  <= Temp_en_RMem_Inc;
        en_ROpcode   <= Temp_en_ROpcode;
        en_RData_in  <= Temp_en_RData_in;
        en_RData_out <= Temp_en_RData_out;
        crt_MEM      <= Temp_crt_MEM;

    End Process DP_STATE_DECOD_MEM;

    ---------------------------------------------------------------------------
    -- controle para PC.
    DP_STATE_DECOD_PC: Process(DP_State,IO_OK,Opcode)
        Variable Temp_load_PC:   Std_logic;
        Variable Temp_inc_PC:    Std_logic;
        Variable Temp_en_Out_PC: Std_logic;
    Begin
        Temp_load_PC   := '0';
        Temp_inc_PC    := '0';
        Temp_en_Out_PC := '0';

        Case DP_State is
            When Ignore_B4|Write_RF|Write_RData =>
                Temp_inc_PC    := '1';
            When Decod_Imm =>
                If Opcode(1) = '1' then 
                    Temp_en_Out_PC := '1';
                End If;
            When Write_PC =>
                Temp_load_PC   := '1';
            When Others =>
        End Case;

        load_PC   <= Temp_load_PC;
        inc_PC    <= Temp_inc_PC;
        en_Out_PC <= Temp_en_Out_PC;

    End Process DP_STATE_DECOD_PC;

    ---------------------------------------------------------------------------
    -- Register File.
    DP_STATE_DECOD_RF: Process(DP_State,in_Bus)
        Variable Temp_crt_RFile:      Std_Logic;
        Variable Temp_en_Raddress_RF: Std_Logic;
        Variable Temp_address_RF:     Std_Logic_Vector(RF_ADDR_SIZE-1 downto 0);
    Begin
        Temp_crt_RFile      := '0';
        Temp_en_Raddress_RF := '0';
        Temp_address_RF     := R0;

        Case DP_State is
            When Decod_Ra =>
                Temp_en_Raddress_RF := '1';
                Temp_address_RF     := Ra;
            When Decod_Rb =>
                Temp_en_Raddress_RF := '1';
                Temp_address_RF     := Rb;
            When Decod_Rd =>
                Temp_en_Raddress_RF := '1';
                Temp_address_RF     := Rd;
            When Write_RF =>
                Temp_crt_RFile := '1';
            When Others   =>
        End Case;

        crt_RFile      <= Temp_crt_RFile;
        en_Raddress_RF <= Temp_en_Raddress_RF;
        address_RF     <= Temp_address_RF;

    End Process DP_STATE_DECOD_RF;

    ---------------------------------------------------------------------------
    -- Shifter.
    DP_STATE_DECOD_SH: Process(DP_State,Opcode,in_Bus)
        Variable Temp_en_Reg_SH: Std_Logic;
        Variable Temp_crt_SH:    Std_Logic_Vector(1 downto 0);
        Variable Temp_S_SH:      Std_Logic_Vector(SH_SIZE-1 downto 0);
    Begin
        Temp_en_Reg_SH := '0';
        Temp_S_SH      := (Others => '0');
        Temp_crt_SH    := sLFT;

        If Opcode(3) = '1' and DP_State = Decod_Imm then
            Temp_en_Reg_SH := '1';
            Temp_S_SH      := size_SH;
            Temp_crt_SH    := op_SH;
        End If;

        en_Reg_SH <= Temp_en_Reg_SH;
        S_SH      <= Temp_S_SH;
        crt_SH    <= Temp_crt_SH;

    End Process DP_STATE_DECOD_SH;

    ---------------------------------------------------------------------------
    -- ULA.
    DP_STATE_DECOD_ULA: Process(DP_State,Opcode,in_Bus)
        Variable Temp_en_R2_ULA: Std_Logic;
        Variable Temp_crt_ULA:   Std_Logic_Vector(2 downto 0);
    Begin
        Temp_en_R2_ULA := '0';
        Temp_crt_ULA   := uADD;

        Case DP_State is
            When Decod_Funct =>              -- Instrução tipo R
                Temp_en_R2_ULA := '1';
                Temp_crt_ULA   := op_ULA;
            When Decod_Imm =>                -- instrução com imediato exceto SH
                If Opcode(3) = '0' then
                    Temp_en_R2_ULA := '1';
                End If;
            When ADDimm =>                   -- instrução SB
                If Opcode(4) = '1' and Opcode(2) = '1' then
                    Temp_en_R2_ULA := '1';
                End If;
            When Others =>
        End Case;

        en_R2_ULA <= Temp_en_R2_ULA;
        crt_ULA   <= Temp_crt_ULA;

    End Process DP_STATE_DECOD_ULA;

    ---------------------------------------------------------------------------
    -- Registradores temporários.
    DP_STATE_DECOD_Regs: Process(DP_State,Opcode)
        Variable Temp_en_R1A_ULA: Std_Logic;
        Variable Temp_en_R1B_ULA: Std_Logic;
    Begin
        Temp_en_R1A_ULA := '0';
        Temp_en_R1B_ULA := '0';

        If DP_State = Decod_Rb then
            Temp_en_R1A_ULA := '1';
        End If;

        If DP_State = Decod_Rd or (DP_State = Ignore_B3 and
           ( Opcode(1) = '1' or (Opcode(4) = '1' and Opcode(2) = '1') )) then
            Temp_en_R1B_ULA := '1';
        End If;

        en_R1A_ULA <= Temp_en_R1A_ULA;
        en_R1B_ULA <= Temp_en_R1B_ULA;

    End Process DP_STATE_DECOD_Regs;

    ---------------------------------------------------------------------------
    -- Controle dos multiplexadores.
    DP_STATE_DECOD_MUX: Process(DP_State,Opcode)
        Variable Temp_crt_Mux_ULA: Std_Logic_Vector(1 downto 0);
        Variable Temp_crt_Mux_Acc: Std_Logic;
        Variable Temp_crt_Mux_RF:  Std_Logic;
        Variable Temp_crt_Mux_IO:  Std_Logic;
    Begin
        Temp_crt_Mux_ULA := "00"; 
        Temp_crt_Mux_Acc := '0'; 
        Temp_crt_Mux_RF  := '0';  
        Temp_crt_Mux_IO  := '0';  

        Case DP_State is
            When Decod_Imm =>
                If Opcode(2) = '1' or Opcode(4) = '1' then    -- ADDI
                    Temp_crt_Mux_ULA := "01";
                ElsIf Opcode(1) = '1' or Opcode(0) = '1' then -- BEQ e J
                    Temp_crt_Mux_ULA := "11";
                End If;
            When ADDimm =>
                If Opcode(4) = '1' and Opcode(2) = '1' then    -- SB
                    Temp_crt_Mux_ULA := "10";
                End If;
            When Others =>
        End Case;

        If DP_State = Execute_funct and Opcode(3) = '1' then                      -- Shift
            Temp_crt_Mux_Acc := '1'; 
        End If;

        If Opcode(4) = '1' and DP_State = Write_RF then -- LB
            Temp_crt_Mux_RF := '1';  
        End If;

        If Opcode(4) = '1' and DP_State = Write_RMem then -- LB ou SB
            Temp_crt_Mux_IO := '1';  
        End If;

        crt_Mux_ULA <= Temp_crt_Mux_ULA; 
        crt_Mux_Acc <= Temp_crt_Mux_Acc; 
        crt_Mux_RF  <= Temp_crt_Mux_RF;  
        crt_Mux_IO  <= Temp_crt_Mux_IO;  

    End Process DP_STATE_DECOD_MUX;

    ---------------------------------------------------------------------------
    -- Controle do Acumulador.
    DP_STATE_DECOD_ACC: Process(DP_State,Opcode,in_Bus)
        Variable Temp_crt_Acc: Std_Logic_Vector(1 downto 0);
    Begin
        Temp_crt_Acc := AccNop;

        Case DP_State is
            When Execute_funct =>
                If in_Bus(3) = '1' and Opcode = "00000" then -- SLT
                    Temp_crt_Acc := AccFlag;
                Else
                    Temp_crt_Acc := AccPar;
                End If;
            When ADDimm =>
                Temp_crt_Acc := AccPar;
            When Write_RMem =>
                If Opcode(2) = '1'  then                     -- SB
                    Temp_crt_Acc := AccPar;
                End If;
            When Others =>
        End Case;

        crt_Acc <= Temp_crt_Acc;

    End Process DP_STATE_DECOD_ACC;

    ---------------------------------------------------------------------------
    -- Controle do Imediato.
    DP_STATE_DECOD_IMM: Process(DP_State,in_Bus,Opcode,IO_OK)
        Variable Temp_out_IMM: Std_Logic_Vector(N-1 downto 0);
    Begin
        Temp_out_IMM := (Others => '0');

        Case DP_State is
            When Decod_Imm =>
                Temp_out_IMM := in_Bus;
            When IN_Data =>
                If IO_OK = '1' then
                    Temp_out_IMM := in_Bus;
                End If;
            When Write_RF =>
                If Opcode(4) = '1' then
                    Temp_out_IMM := in_Bus;
                End If;
            When Others =>
        End Case;

        out_IMM <= Temp_out_IMM;

    End Process DP_STATE_DECOD_IMM;

End Architecture behave;

Configuration MIPS8B_DP_Control_behave_conf of MIPS8B_DP_Control is
    For behave
    End For;
End Configuration MIPS8B_DP_Control_behave_conf;

