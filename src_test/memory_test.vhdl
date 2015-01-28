-- Teste geral para a estrutura do Processador Mips8B

Library Ieee;
Use Ieee.Std_Logic_1164.all;
Use Ieee.Numeric_Std.all;

Entity memory_test is
Port(Clock_Mem:  In  Std_Logic;
     MAddr:      In  Std_Logic_Vector(7 downto 0);
     MCmd:       In  Std_Logic_Vector(1 downto 0);
     MData:      In  Std_Logic_Vector(7 downto 0);
     SData:      Out Std_Logic_Vector(7 downto 0);
     SCmdAccept: Out Std_Logic);
End Entity memory_test;

Architecture behave of memory_test is

    Type Memory_Array is Array(Natural Range <>) of Std_Logic_Vector(7 downto 0);

    Use Work.MIPS8B_Base.ocpIDLE_little;
    Use Work.MIPS8B_Base.ocpWR_little;
    Use Work.MIPS8B_Base.ocpRD_little;
    Use Work.MIPS8B_Base.ocpNULL_little;
    Use Work.MIPS8B_Base.ocpDVA_little;

Begin

    Memory: Process
	Variable int_SCmdAccept: Std_Logic;
	Variable address: Unsigned(7 downto 0);
	Variable mem_int: Memory_Array(0 to 255) := (
                "00100000", "00000001", "00000000", "11001000",
                "00100000", "00000010", "00000000", "10001001",
                "00100000", "00000011", "00000000", "11001101",
                "10100000", "00100010", "00000000", "00000000",
                "00100000", "00100001", "00000000", "00000001",
                "00100000", "01000010", "00000000", "11101111",
                "00010000", "01100001", "00000000", "00000010",
                "00010000", "00000000", "00000000", "11111100",
                "00000000", "00000000", "00001000", "00100101",
                "00100000", "00000110", "00000000", "11001000",
                "00100000", "11000111", "00000000", "00000001",
                "00100000", "00000101", "00000000", "11001101",
                "00010000", "10100111", "00000000", "00001011",
                "10000000", "11000011", "00000000", "00000000",
                "10000000", "11100100", "00000000", "00000000",
                "00000000", "10000011", "00010000", "00101010",
                "00010000", "01000000", "00000000", "00000100",
                "00100000", "00100001", "00000000", "00000001",
                "10100000", "11000100", "00000000", "00000000",
                "10100000", "11100011", "00000000", "00000000",
                "00000000", "11100000", "00110000", "00100000",
                "00100000", "11100111", "00000000", "00000001",
                "00010000", "00000000", "00000000", "11110110",
                "00010000", "00000001", "00000000", "00000010",
                "00010000", "00000000", "00000000", "11110000",
                "00100000", "00000011", "00000000", "11001101",
                "00100000", "00000001", "00000000", "11001000",
                "10000000", "00100010", "00000000", "00000000",
                "10100000", "00100010", "00000000", "00000000",
                "00100000", "00100001", "00000000", "00000001",
                "00010000", "01100001", "00000000", "11111100",
                "00010000", "00000000", "00000000", "11111100",

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

	End Case;

	SCmdAccept <= int_SCmdAccept;

    End Process Memory;


End Architecture behave;

Configuration general_test of memory_test is
	For behave
	End For;
End Configuration general_test;

