-- Teste geral para a estrutura do Processador Mips8B

Library Ieee;
Use Ieee.Std_Logic_1164.all;
Use Ieee.Numeric_Std.all;

Entity test_processor is
End Entity test_processor;

Architecture test_general of test_processor is

    Component Mips8B is
	Port(Reset_n:    In  Std_Logic;
	     Clock:      In  Std_Logic;
	     MAddr:      Out Std_Logic_Vector(7 downto 0);
	      MCmd:      Out Std_Logic_Vector(1 downto 0);
	     MData:      Out Std_Logic_Vector(7 downto 0);
	     SData:      In  Std_Logic_Vector(7 downto 0);
	     SCmdAccept: In Std_Logic);
    End Component Mips8B;

    Type Memory_Array is Array(Natural Range <>) of Std_Logic_Vector(7 downto 0);

    Use Work.MIPS8B_Base.ocpIDLE_little;
    Use Work.MIPS8B_Base.ocpWR_little;
    Use Work.MIPS8B_Base.ocpRD_little;
    Use Work.MIPS8B_Base.ocpNULL_little;
    Use Work.MIPS8B_Base.ocpDVA_little;

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

    Memory: Process
	Variable int_SCmdAccept: Std_Logic;
	Variable address: Unsigned(7 downto 0);
	Variable mem_int: Memory_Array(0 to 255) := (
                "00100000", "00000001", "00000000", "10000000",
                "00100000", "00000010", "00000000", "10000000",
                "00100000", "00000011", "00000000", "01111111",
                "00100000", "00000100", "00000000", "01111111",
                "00100000", "00000101", "00000000", "01111110",
                "00100000", "00000110", "00000000", "10000001",
                "00100000", "00000111", "00000000", "00000000",
                "00010000", "01000001", "00000000", "00000010",
                "00100000", "00000100", "00000000", "01001101",
                "00010000", "10000011", "00000000", "00000010",
                "00100000", "00000011", "00000000", "01001101",
                "00010000", "00000111", "00000000", "00000010",
                "00100000", "00000010", "00000000", "01001101",
                "00010000", "11000110", "00000000", "00000010",
                "00100000", "00000010", "00000000", "01001101",
                "00010000", "11000001", "00000000", "00001000",
                "00010000", "11100001", "00000000", "00000111",
                "00010000", "00100011", "00000000", "00000110",
                "00010000", "10100100", "00000000", "00000101",
                "00010000", "11000010", "00000000", "00000100",
                "00010000", "00000001", "00000000", "00000011",
                "00010000", "00000011", "00000000", "00000010",
                "00010000", "00000000", "00000000", "00000010",
                "00100000", "00000001", "00000000", "01001101",
                "00010000", "01100011", "00000000", "00000100",
                "00010000", "11100111", "00000000", "00000100",
                "00010000", "11000110", "00000000", "00000100",
                "00100000", "00000111", "00000000", "01001101",
                "00010000", "10100101", "00000000", "11111101",
                "00010000", "01000010", "00000000", "11111101",
                "00010000", "00000000", "00000000", "00000001",
                "00010000", "00100001", "00000000", "00000001",
                "00010000", "01000010", "00000000", "00000001",
                "00010000", "01100011", "00000000", "00000001",
                "00010000", "10000100", "00000000", "00000001",
                "00010000", "10100101", "00000000", "00000001",
                "00010000", "11000110", "00000000", "00000001",
                "00010000", "11100111", "00000000", "00000001",

    		Others => "00000000");
    Begin

	Wait Until Clock_Mem'Event and Clock_Mem='1';

	Case MCmd is

	    When ocpWR_little =>

		If int_SCmdAccept = ocpNULL_little then

		    int_SCmdAccept := ocpDVA_little;

		    address := Unsigned(MAddr);

		    mem_int(to_integer(address)) := MData;

		Else
		    int_SCmdAccept := ocpNULL_little;
		End If;

		SData <= "ZZZZZZZZ";

	    When ocpRD_little =>

		If int_SCmdAccept = ocpNULL_little then

		    int_SCmdAccept := ocpDVA_little;
		    address := Unsigned(MAddr);

		    SData <= mem_int(to_integer(address));

		Else
		    int_SCmdAccept := ocpNULL_little;
		End If;
		
	    When Others =>
		int_SCmdAccept := ocpNULL_little;
		SData <= "ZZZZZZZZ";

	End Case;

	SCmdAccept <= int_SCmdAccept;

    End Process Memory;

    DUV: Mips8B
	Port Map(   Reset_n =>  Reset_n,     
		      Clock =>  Clock,     
		      MAddr =>  MAddr,     
		       MCmd =>   MCmd,     
		      MData =>  MData,     
		      SData =>  SData,     
		 SCmdAccept =>  SCmdAccept);

End Architecture test_general;

Configuration general_test of test_processor is

    For test_general

	For DUV: Mips8B Use Configuration Work.Mips8B_struct_conf;
	End For;

    End For;

End Configuration general_test;

