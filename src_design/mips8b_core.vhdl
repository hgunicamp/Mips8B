Library Ieee;
Use Ieee.Std_Logic_1164.all;

Entity Mips8B_Core is
    Port(Reset_n:    in  Std_Logic;
	 Clock:      in  Std_Logic;
	 MAddr:      out Std_Logic_Vector(7 downto 0);
    	  MCmd:      out Std_Logic_Vector(1 downto 0);
	 MData:      out Std_Logic_Vector(7 downto 0);
	 SData:      in  Std_Logic_Vector(7 downto 0);
	 SCmdAccept: in  Std_Logic);
End Entity Mips8B_Core;

Architecture struct of Mips8B_Core is

    -- Interfaces dos componentes internos.
    Use Work.MIPS8B_Components.all;

    -- Importando biblioteca de tipos básicos.
    Use Work.MIPS8B_Base.all;

    -- Conexões para o PC.
    Signal en_Out_PC:  Std_Logic;
    Signal load_PC:    Std_Logic;
    Signal inc_PC:     Std_Logic;
    Signal out_PC:     Std_Logic_Vector(5 downto 0);
    Signal address_PC: Std_Logic_Vector(5 downto 0);

    -- Interface para o sistema de I/O.
    -- Controle do endereço fornecido pelo sistema
    Signal en_RMem:       Std_Logic;
    Signal en_RMem_Inc:   Std_Logic;
    Signal crt_Mux_IO:    Std_Logic;
    Signal crt_MEM:       MemoryOP;
    -- Controle dos Dados de I/O.
    Signal en_RData_in:   Std_Logic;
    Signal en_RData_out:  Std_Logic;
    -- Registradores para dados de I/O.
    Signal RData_in:      Std_Logic_Vector(7 downto 0);

    -- Interface para o controlador principal.
    Signal IO_OK:           Std_Logic;
    Signal eq_Flag:         Std_Logic;
    Signal en_ROpcode:      Std_Logic;
    Signal Opcode:          Std_Logic_Vector(4 downto 0);
    -- Controle para o Registrer File.
    Signal crt_RFile:       Std_Logic;
    Signal en_Raddress_RF:  Std_Logic;
    Signal address_RF:      Std_Logic_Vector(2 downto 0);
    -- Controle para os registradores Intermediarios.
    Signal en_R1A_ULA:      Std_Logic;
    Signal en_R1B_ULA:      Std_Logic;
    Signal en_R2_ULA:       Std_Logic;
    Signal en_Reg_SH:       Std_Logic;
    -- Controle para os multiplexadores.
    Signal crt_Mux_ULA:     Std_Logic_Vector(1 downto 0);
    Signal crt_Mux_Acc:     Std_Logic;
    Signal crt_Mux_RF:      Std_Logic;
    -- Controle das unidades funcionais.
    Signal crt_ULA:         Std_Logic_Vector(2 downto 0);
    Signal crt_SH:          Std_Logic_Vector(1 downto 0);
    Signal crt_Acc:         Std_Logic_Vector(1 downto 0);
    -- Valor do comprimento do shift.
    Signal S_SH:            Std_Logic_Vector(2 downto 0);
    -- Valor do campo imediato
    Signal out_IMM:         Std_Logic_Vector(7 downto 0);

    -- Saida do resultado do Acumulador.
    Signal out_Acc:          Std_Logic_Vector(7 downto 0);

Begin

    ---------------------------------------------------------------------------
    -- Processo para registrar o opcode da instrução corrente.
    OPCode_PROC: Process

    Begin
        Wait Until Clock'event and Clock = '1';

	If en_ROpcode = '1' then
            Opcode <= RData_in(7 downto 3);
        End If;

    End Process OPCode_PROC;

    ---------------------------------------------------------------------------
    -- Instância de PC.
    PC_Unity: PC_System
        Generic Map(N   => 8)
        Port Map(clock      => Clock,
                 Reset_n    => Reset_n,
                 en_Out_PC  => en_Out_PC,
                 load_PC    => load_PC,
                 inc_PC     => inc_PC,
                 in_PC      => out_Acc(5 downto 0),
                 out_PC     => out_PC,
                 address_PC => address_PC);

    ---------------------------------------------------------------------------
    -- Instância do sistema de I/O.
    IO_System: MIPS8B_IO_System
        Generic Map(N => 8)
        Port Map(clock        => Clock,
                 Reset_n      => Reset_n,
                 -- Controle do endereço fornecido pelo sistema
                 en_RMem      => en_RMem,
                 en_RMem_Inc  => en_RMem_Inc,
                 crt_Mux_IO   => crt_Mux_IO,
                 crt_MEM      => crt_MEM,
                 -- Controle dos Dados de I/O.
                 en_RData_in  => en_RData_in,
                 en_RData_out => en_RData_out,
                 -- Valores de endereço para transações de I/O.
                 out_PC       => address_PC,
                 out_DPath    => out_Acc,
                 in_Data      => SData,
                 -- Registradores para dados de I/O.
                 RMem         => MAddr,
                 RData_in     => RData_in,
                 RData_out    => MData,
                 -- Interface de controle.
                 Cmd          => MCmd,
                 CmdAccept    => SCmdAccept,
                 IO_OK        => IO_OK);

    ---------------------------------------------------------------------------
    -- Instância do controlador principal.
    Main_Control: MIPS8B_DP_Control
        Generic Map(N            => 8,
                    SH_SIZE      => 3,
                    RF_ADDR_SIZE => 3)
        Port Map(clock          => Clock,
                 Reset_n        => Reset_n,
                 IO_OK          => IO_OK,
                 eq_Flag        => eq_Flag,
                 Opcode         => Opcode,
                 in_Bus         => RData_in,
                 -- Controle para o Registrer File.
                 crt_RFile      => crt_RFile,
                 en_Raddress_RF => en_Raddress_RF,
                 address_RF     => address_RF,
                 -- Controle para os registradores Intermediarios.
                 en_R1A_ULA     => en_R1A_ULA,
                 en_R1B_ULA     => en_R1B_ULA,
                 en_R2_ULA      => en_R2_ULA,
                 en_Reg_SH      => en_Reg_SH,
                 -- Controle para os multiplexadores.
                 crt_Mux_ULA    => crt_Mux_ULA,
                 crt_Mux_Acc    => crt_Mux_Acc,
                 crt_Mux_RF     => crt_Mux_RF,
                 -- Controle das unidades funcionais.
                 crt_ULA        => crt_ULA,
                 crt_SH         => crt_SH,
                 crt_Acc        => crt_Acc,
                 -- Controle do PC.
                 en_Out_PC      => en_Out_PC,
                 load_PC        => load_PC,
                 inc_PC         => inc_PC,
                 -- Controle para o sistema de IO.
                 en_ROpcode     => en_ROpcode,
                 en_RMem        => en_RMem,
                 en_RMem_Inc    => en_RMem_Inc,
                 en_RData_in    => en_RData_in,
                 en_RData_out   => en_RData_out,
                 crt_Mux_IO     => crt_Mux_IO,
                 crt_MEM        => crt_MEM,
                 -- Valor do comprimento do shift.
                 S_SH           => S_SH,
                 -- Valor do campo imediato
                 out_IMM        => out_IMM);

    ---------------------------------------------------------------------------
    -- Instância do Datapath.
    DPATH: Mips8B_DataPath
        Generic Map(      N      => 8,
                    RF_SIZE      => 8,
                    SH_SIZE      => 3,
                    RF_ADDR_SIZE => 3)
        Port Map(clock           => Clock,
                 -- Controle dos Registradores do Shift Register.
                 en_Reg_SH       => en_Reg_SH,
                 -- Controle para Shifter.
                 crt_SH          => crt_SH,
                 S_SH            => S_SH,
                 -- Controle dos Registradores da ULA.
                 en_R1A_ULA      => en_R1A_ULA,
                 en_R1B_ULA      => en_R1B_ULA,
                 en_R2_ULA       => en_R2_ULA,
                 -- Controle para ULA.
                 crt_ULA         => crt_ULA,
                 crt_Mux_ULA     => crt_Mux_ULA,
                 -- Controle para Register File.
                 crt_RFile       => crt_RFile,
                 crt_Mux_RF      => crt_Mux_RF,
                 address_RF      => address_RF,
                 en_Raddress_RF  => en_Raddress_RF,
                 -- Controle para o Acumulador.
                 crt_Acc         => crt_Acc,
                 crt_Mux_Acc     => crt_Mux_Acc,
                 -- Entradas do Datapath.
                 in_PC           => out_PC,
                 in_IMM          => out_IMM,
                 -- Flag de Igualdade de Operandos.
                 eq_Flag         => eq_Flag,
                 -- Saida do resultado do Acumulador.
                 out_Acc         => out_Acc);

End Architecture struct;

Configuration Mips8B_Core_struct_conf of Mips8B_Core is
    For struct

        For PC_Unity: PC_System Use Entity Work.PC_System(behave);
        End For;

        For IO_System: MIPS8B_IO_System Use Entity Work.MIPS8B_IO_System(behave);
        End For;

        For Main_Control: MIPS8B_DP_Control Use Entity Work.MIPS8B_DP_Control(behave);
        End For;

        For DPATH: Mips8B_DataPath Use Entity Work.Mips8B_DataPath(behave);
        End For;

    End For;
End Configuration Mips8B_Core_struct_conf;

