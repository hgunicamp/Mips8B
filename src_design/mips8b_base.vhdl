-- Definicao de um pacote de tipos constantes que serao
-- utilizados com frequencia.

Library Ieee;
Use Ieee.Std_Logic_1164.all;

Package MIPS8B_Base is

    -- Interface entre o processador a Maquina IO.
    Type MemoryOP is (mcIDLE, mcREAD, mcWRITE);

    -- Estados da FSM de IO.
    Type IOSTD is (ioIDLE, ioREAD, ioWRITE, ioIO_OK);

    -- Estados da FSM do DataPath.
    Type DPSTD is (st_Reset,  Next_Instr,  Wait_B1,     Decod_B1,
                   Wait_B2,   Decod_Ra,    Decod_Rb,    Wait_B3,
                   Decod_Rd,  Wait_B4,     Decod_funct, Execute_funct,
                   Ignore_B3, Decod_Imm,   ADDimm,      Write_RMem,
                   IN_Data,   Write_RData, Out_Data,    Ignore_B2,
                   Ignore_B4, Write_PC,    Write_RF);

    -- Constantes para transacoes OCP
    -- Comandos Master -> Slave
    Constant ocpIDLE: Std_Logic_Vector(2 downto 0):="000"; -- Idle
    Constant   ocpWR: Std_Logic_Vector(2 downto 0):="001"; -- Write
    Constant   ocpRD: Std_Logic_Vector(2 downto 0):="010"; -- Read
    Constant ocpRDEx: Std_Logic_Vector(2 downto 0):="011"; -- ReadEX
    Constant ocpRSR1: Std_Logic_Vector(2 downto 0):="100"; -- Reserved
    Constant ocpRSR2: Std_Logic_Vector(2 downto 0):="101"; -- Reserved
    Constant ocpRSR3: Std_Logic_Vector(2 downto 0):="110"; -- Reserved
    Constant ocpBCST: Std_Logic_Vector(2 downto 0):="111"; -- Broadcast
    -- Respostas Slave -> Master
    Constant ocpNULL: Std_Logic_Vector(1 downto 0):="00"; -- No Response
    Constant  ocpDVA: Std_Logic_Vector(1 downto 0):="01"; -- Data Valid/Accept
    Constant ocpRSR4: Std_Logic_Vector(1 downto 0):="10"; -- Reserved
    Constant  ocpERR: Std_Logic_Vector(1 downto 0):="11"; -- Response Error
    -- Versao reduzida do OPC
    Constant ocpIDLE_little: Std_Logic_Vector(1 downto 0):="00"; -- Idle
    Constant   ocpWR_little: Std_Logic_Vector(1 downto 0):="01"; -- Write
    Constant   ocpRD_little: Std_Logic_Vector(1 downto 0):="10"; -- Read
    Constant ocpNULL_little: Std_Logic:='0'; -- No Response
    Constant  ocpDVA_little: Std_Logic:='1'; -- Data Valid/Accept

    -- Comandos da ULA.
    Constant ULA_ADD: Std_Logic_Vector(3 downto 0):= "0000";
    Constant ULA_SUB: Std_Logic_Vector(3 downto 0):= "0010";
    Constant ULA_AND: Std_Logic_Vector(3 downto 0):= "0100";
    Constant ULA_OR : Std_Logic_Vector(3 downto 0):= "0101";
    Constant ULA_SLT: Std_Logic_Vector(3 downto 0):= "1010";
    Constant ULA_BEQ: Std_Logic_Vector(3 downto 0):= "1000";

    -- Comandos para o Acumulador
    Constant  AccNop: Std_Logic_Vector(1 downto 0):="11";
    Constant  AccPar: Std_Logic_Vector(1 downto 0):="10";
    Constant AccFlag: Std_Logic_Vector(1 downto 0):="01";

    -- Constantes relativas a formacao da instrucao.
    -- Cosntantes para OpCode.
    Constant    OpR: Std_Logic_Vector(5 downto 0):= "000000";
    Constant   OpSH: Std_Logic_Vector(5 downto 0):= "010000";
    Constant OpADDI: Std_Logic_Vector(5 downto 0):= "001000";
    Constant  OpBEQ: Std_Logic_Vector(5 downto 0):= "000100";
    Constant    OpJ: Std_Logic_Vector(5 downto 0):= "000010";
    Constant   OpLB: Std_Logic_Vector(5 downto 0):= "100000";
    Constant   OpSB: Std_Logic_Vector(5 downto 0):= "101000";

    -- Constantes utilizadas pela maquina do DataPath para
    --decodificar a instrucao
    Constant    decodR: Std_Logic_Vector(4 downto 0):= "00000";
    Constant   decodSH: Std_Logic_Vector(4 downto 0):= "01000";
    Constant decodADDI: Std_Logic_Vector(4 downto 0):= "00100";
    Constant  decodBEQ: Std_Logic_Vector(4 downto 0):= "00010";
    Constant    decodJ: Std_Logic_Vector(4 downto 0):= "00001";
    Constant   decodLB: Std_Logic_Vector(4 downto 0):= "10000";
    Constant   decodSB: Std_Logic_Vector(4 downto 0):= "10100";

    -- Constantes para os registradores
    Constant R0: Std_Logic_Vector(2 downto 0):= "000";
    Constant R1: Std_Logic_Vector(2 downto 0):= "001";
    Constant R2: Std_Logic_Vector(2 downto 0):= "010";
    Constant R3: Std_Logic_Vector(2 downto 0):= "011";
    Constant R4: Std_Logic_Vector(2 downto 0):= "100";
    Constant R5: Std_Logic_Vector(2 downto 0):= "101";
    Constant R6: Std_Logic_Vector(2 downto 0):= "110";
    Constant R7: Std_Logic_Vector(2 downto 0):= "111";

    --Contantes para funct.
    Constant FunctADD: Std_Logic_Vector(5 downto 0):= "100000";
    Constant FunctSUB: Std_Logic_Vector(5 downto 0):= "100010";
    Constant FunctAND: Std_Logic_Vector(5 downto 0):= "100100";
    Constant  FunctOR: Std_Logic_Vector(5 downto 0):= "100101";
    Constant FunctSLT: Std_Logic_Vector(5 downto 0):= "101010";

    -- Constantes para operacao com ULA.
    Constant uADD: Std_Logic_Vector(2 downto 0) := "000";
    Constant uSUB: Std_Logic_Vector(2 downto 0) := "010";
    Constant uAND: Std_Logic_Vector(2 downto 0) := "100";
    Constant uOR : Std_Logic_Vector(2 downto 0) := "101";

    -- Constantes para operacao com Shift.
    Constant sLFT: Std_Logic_Vector(1 downto 0) := "00";
    Constant sRAR: Std_Logic_Vector(1 downto 0) := "11";
    Constant sRLL: Std_Logic_Vector(1 downto 0) := "10";

End Package MIPS8B_Base;

