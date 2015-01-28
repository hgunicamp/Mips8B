Library Ieee;
Use Ieee.Std_Logic_1164.all;
Use Work.MIPS8B_Base.all;

Package MIPS8B_Components is

    -- Inteface para o PC.
    Component PC_System is
        Generic(N:   Natural := 8);
        Port(clock:      in  Std_Logic;
             Reset_n:    in  Std_Logic;
             en_Out_PC:  in  Std_Logic;
             load_PC:    in  Std_Logic;
             inc_PC:     in  Std_Logic;
             in_PC:      in  Std_Logic_Vector(N-3 downto 0);
             out_PC:     out Std_Logic_Vector(N-3 downto 0);
             address_PC: out Std_Logic_Vector(N-3 downto 0));
    End Component;

    -- Interface para o sistema de I/O.
    Component MIPS8B_IO_System is
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
    End Component;

    -- Interface para o controlador principal.
    Component MIPS8B_DP_Control is
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
    End Component;

    -- Interface para o Datapath.
    Component Mips8B_DataPath is
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
    End Component;

End Package MIPS8B_Components;

