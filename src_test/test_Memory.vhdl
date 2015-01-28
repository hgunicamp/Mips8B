-- Teste geral para a estrutura do Processador Mips8B

Library Ieee;
Use Ieee.Std_Logic_1164.all;
Use Ieee.Numeric_Std.all;

Entity test_Memory is
End Entity test_Memory;

Architecture test_general of test_Memory is

    Component Mips8B_Core is
	Port(Reset_n:    In  Std_Logic;
	     Clock:      In  Std_Logic;
	     MAddr:      Out Std_Logic_Vector(7 downto 0);
	      MCmd:      Out Std_Logic_Vector(1 downto 0);
	     MData:      Out Std_Logic_Vector(7 downto 0);
	     SData:      In  Std_Logic_Vector(7 downto 0);
	     SCmdAccept: In Std_Logic);
    End Component Mips8B_Core;

    Component memory_test is
        Port(Clock_Mem:  In  Std_Logic;
             MAddr:      In  Std_Logic_Vector(7 downto 0);
             MCmd:       In  Std_Logic_Vector(1 downto 0);
             MData:      In  Std_Logic_Vector(7 downto 0);
             SData:      Out Std_Logic_Vector(7 downto 0);
             SCmdAccept: Out Std_Logic);
    End Component memory_test;

    Signal Reset_n:    Std_Logic;
    Signal Clock:      Std_Logic := '0';
    Signal Clock_Mem:  Std_Logic := '0';
    Signal MAddr:      Std_Logic_Vector(7 downto 0);
    Signal  MCmd:      Std_Logic_Vector(1 downto 0);
    Signal MData:      Std_Logic_Vector(7 downto 0);
    Signal SData:      Std_Logic_Vector(7 downto 0);
    Signal SCmdAccept: Std_Logic;

Begin

    Reset_n <= '1', '0' after 20 ns, '1' after 40 ns;
    Clock <= not Clock after 10 ns;
    Clock_Mem <= not Clock_Mem after 15 ns;

    DUV: Mips8B_Core
	Port Map(   Reset_n =>  Reset_n,     
		      Clock =>  Clock,     
		      MAddr =>  MAddr,     
		       MCmd =>   MCmd,     
		      MData =>  MData,     
		      SData =>  SData,     
		 SCmdAccept =>  SCmdAccept);

    MEM: memory_test
	Port Map( Clock_Mem =>  Clock_Mem,     
		      MAddr =>  MAddr,     
		       MCmd =>   MCmd,     
		      MData =>  MData,     
		      SData =>  SData,     
		 SCmdAccept =>  SCmdAccept);

End Architecture test_general;

Configuration general_test of test_Memory is

    For test_general

	For DUV: Mips8B_Core Use Configuration Work.Mips8B_Core_struct_conf;
	End For;

	For MEM: memory_test Use Entity Work.memory_test(behave);
	End For;

    End For;

End Configuration general_test;

