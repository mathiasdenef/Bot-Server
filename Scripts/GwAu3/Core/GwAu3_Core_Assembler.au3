#include-once

Global $g_a_Reg8[8][2] = [['al',0], ['cl',1], ['dl',2], ['bl',3], ['ah',4], ['ch',5], ['dh',6], ['bh',7]]
Global $g_a_Reg16[8][2] = [['ax',0], ['cx',1], ['dx',2], ['bx',3], ['sp',4], ['bp',5], ['si',6], ['di',7]]
Global $g_a_Reg32[8][2] = [['eax',0], ['ecx',1], ['edx',2], ['ebx',3], ['esp',4], ['ebp',5], ['esi',6], ['edi',7]]

Func _GetReg32Code($s_RegName)
    For $i = 0 To 7
        If $g_a_Reg32[$i][0] = $s_RegName Then
            Return $g_a_Reg32[$i][1]
        EndIf
    Next
    Return -1
EndFunc

Func _GetReg16Code($s_RegName)
    For $i = 0 To 7
        If $g_a_Reg16[$i][0] = $s_RegName Then
            Return $g_a_Reg16[$i][1]
        EndIf
    Next
    Return -1
EndFunc

Func _GetReg8Code($s_RegName)
    For $i = 0 To 7
        If $g_a_Reg8[$i][0] = $s_RegName Then
            Return $g_a_Reg8[$i][1]
        EndIf
    Next
    Return -1
EndFunc

Func _NormalizeHexValue($s_Value)
	$s_Value = StringRegExpReplace($s_Value, '^0x', '')
	$s_Value = StringRegExpReplace($s_Value, 'h$', '')
	Return $s_Value
EndFunc

Func _ParseValue($s_Value)
	Local $b_IsNegative = False
	Local $s_CleanValue = $s_Value

	If StringLeft($s_Value, 1) = "-" Then
		$b_IsNegative = True
		$s_CleanValue = StringMid($s_Value, 2)
	EndIf

	$s_CleanValue = _NormalizeHexValue($s_CleanValue)

	Local $i_Value = Dec($s_CleanValue)
	If $b_IsNegative Then
		$i_Value = -$i_Value
	EndIf

	Return $i_Value
EndFunc

Func _($a_s_ASM)
	Local $l_v_Buffer
	Local $l_s_OpCode

	Select
		Case StringLeft($a_s_ASM, 1) = ";"
            Return
		Case StringInStr($a_s_ASM, ' -> ')
			Local $l_s_Split = StringSplit($a_s_ASM, ' -> ', 1)
			$l_s_OpCode = StringReplace($l_s_Split[2], ' ', '')
			$g_i_ASMSize += 0.5 * StringLen($l_s_OpCode)
			$g_s_ASMCode &= $l_s_OpCode
		Case StringRight($a_s_ASM, 1) = ':'
			Memory_SetValue('Label_' & StringLeft($a_s_ASM, StringLen($a_s_ASM) - 1), $g_i_ASMSize)
		Case StringInStr($a_s_ASM, '/') > 0
			Memory_SetValue('Label_' & StringLeft($a_s_ASM, StringInStr($a_s_ASM, '/') - 1), $g_i_ASMSize)
			Local $l_i_Offset = StringRight($a_s_ASM, StringLen($a_s_ASM) - StringInStr($a_s_ASM, '/'))
			$g_i_ASMSize += $l_i_Offset
			$g_i_ASMCodeOffset+= $l_i_Offset
		Case StringLeft($a_s_ASM, 5) = 'nop x'
			$l_v_Buffer = Int(Number(StringTrimLeft($a_s_ASM, 5)))
			$g_i_ASMSize += $l_v_Buffer
			For $l_i_Idx = 1 To $l_v_Buffer
				$g_s_ASMCode &= '90'
			Next
		Case StringLeft($a_s_ASM, 3) = 'jb '
			$g_i_ASMSize += 2
			$g_s_ASMCode &= '72(' & StringRight($a_s_ASM, StringLen($a_s_ASM) - 3) & ')'
		Case StringLeft($a_s_ASM, 3) = 'je '
			$g_i_ASMSize += 2
			$g_s_ASMCode &= '74(' & StringRight($a_s_ASM, StringLen($a_s_ASM) - 3) & ')'
		Case StringLeft($a_s_ASM, 5) = 'ljmp '
			$g_i_ASMSize += 5
			$g_s_ASMCode &= 'E9{' & StringRight($a_s_ASM, StringLen($a_s_ASM) - 5) & '}'
		Case StringLeft($a_s_ASM, 5) = 'ljne '
			$g_i_ASMSize += 6
			$g_s_ASMCode &= '0F85{' & StringRight($a_s_ASM, StringLen($a_s_ASM) - 5) & '}'
		Case StringLeft($a_s_ASM, 4) = 'jmp ' And StringLen($a_s_ASM) > 7
			$g_i_ASMSize += 2
			$g_s_ASMCode &= 'EB(' & StringRight($a_s_ASM, StringLen($a_s_ASM) - 4) & ')'
		Case StringLeft($a_s_ASM, 4) = 'jae '
			$g_i_ASMSize += 2
			$g_s_ASMCode &= '73(' & StringRight($a_s_ASM, StringLen($a_s_ASM) - 4) & ')'
		Case StringLeft($a_s_ASM, 3) = 'jz '
			$g_i_ASMSize += 2
			$g_s_ASMCode &= '74(' & StringRight($a_s_ASM, StringLen($a_s_ASM) - 3) & ')'
		Case StringLeft($a_s_ASM, 4) = 'jnz '
			$g_i_ASMSize += 2
			$g_s_ASMCode &= '75(' & StringRight($a_s_ASM, StringLen($a_s_ASM) - 4) & ')'
		Case StringLeft($a_s_ASM, 4) = 'jbe '
			$g_i_ASMSize += 2
			$g_s_ASMCode &= '76(' & StringRight($a_s_ASM, StringLen($a_s_ASM) - 4) & ')'
		Case StringLeft($a_s_ASM, 3) = 'ja '
			$g_i_ASMSize += 2
			$g_s_ASMCode &= '77(' & StringRight($a_s_ASM, StringLen($a_s_ASM) - 3) & ')'
		Case StringLeft($a_s_ASM, 3) = 'jl '
			$g_i_ASMSize += 2
			$g_s_ASMCode &= '7C(' & StringRight($a_s_ASM, StringLen($a_s_ASM) - 3) & ')'
		Case StringLeft($a_s_ASM, 4) = 'jge '
			$g_i_ASMSize += 2
			$g_s_ASMCode &= '7D(' & StringRight($a_s_ASM, StringLen($a_s_ASM) - 4) & ')'
		Case StringLeft($a_s_ASM, 4) = 'jle '
			$g_i_ASMSize += 2
			$g_s_ASMCode &= '7E(' & StringRight($a_s_ASM, StringLen($a_s_ASM) - 4) & ')'

		Case StringRegExp($a_s_ASM, 'call dword[[][a-z,A-Z]{4,}[]]')
			$g_i_ASMSize += 6
			$g_s_ASMCode &= 'FF15[' & StringMid($a_s_ASM, 12, StringLen($a_s_ASM) - 12) & ']'
		Case StringLeft($a_s_ASM, 5) = 'call ' And StringLen($a_s_ASM) > 8
			$g_i_ASMSize += 5
			$g_s_ASMCode &= 'E8{' & StringMid($a_s_ASM, 6, StringLen($a_s_ASM) - 5) & '}'
		Case StringRegExp($a_s_ASM, 'fstp dword[[][a-z,A-Z]{4,}[]]')
			$g_i_ASMSize += 6
			$g_s_ASMCode &= 'D91D[' & StringMid($a_s_ASM, 12, StringLen($a_s_ASM) - 12) & ']'
		Case StringRegExp($a_s_ASM, 'retn [0-9A-Fa-f]+h')
			Local $l_i_Value = StringRegExpReplace($a_s_ASM, 'retn ([0-9A-Fa-f]+)h', '$1')
			$l_i_Value = Dec($l_i_Value)
			$g_i_ASMSize += 3
			$g_s_ASMCode &= 'C2' & Utils_SwapEndian(Hex($l_i_Value, 4))
		Case StringRegExp($a_s_ASM, 'retn 0x[0-9A-Fa-f]+')
			Local $l_i_Value = StringRegExpReplace($a_s_ASM, 'retn 0x([0-9A-Fa-f]+)', '$1')
			$l_i_Value = Dec($l_i_Value)
			$g_i_ASMSize += 3
			$g_s_ASMCode &= 'C2' & Utils_SwapEndian(Hex($l_i_Value, 4))
		Case StringRegExp($a_s_ASM, 'retn [-[:xdigit:]]{1,4}\z')
			Local $l_i_Value = StringMid($a_s_ASM, 6)
			$g_i_ASMSize += 3
			$g_s_ASMCode &= 'C2' & Utils_SwapEndian(Hex(Number($l_i_Value), 4))
		Case StringRegExp($a_s_ASM, 'cmp ebx,[a-z,A-Z]{4,}') And StringInStr($a_s_ASM, ',dword') = 0
			$g_i_ASMSize += 6
			$g_s_ASMCode &= '81FB[' & StringRight($a_s_ASM, StringLen($a_s_ASM) - 8) & ']'
		Case StringRegExp($a_s_ASM, 'cmp edx,[a-z,A-Z]{4,}') And StringInStr($a_s_ASM, ',dword') = 0
			$g_i_ASMSize += 6
			$g_s_ASMCode &= '81FA[' & StringRight($a_s_ASM, StringLen($a_s_ASM) - 8) & ']'
		Case StringRegExp($a_s_ASM, 'cmp eax,[0-9A-Fa-f]+\z')
			Local $l_i_Value = Dec(StringMid($a_s_ASM, 9))
			If $l_i_Value <= 0x7F Then
				$g_i_ASMSize += 3
				$g_s_ASMCode &= '83F8' & Hex($l_i_Value, 2)
			Else
				$g_i_ASMSize += 5
				$g_s_ASMCode &= '3D' & Utils_SwapEndian(Hex($l_i_Value, 8))
			EndIf
		Case StringRegExp($a_s_ASM, 'cmp eax,[-[:xdigit:]]{1,2}\z')
			Local $l_i_Value = StringMid($a_s_ASM, 9)
			If StringLen($l_i_Value) <= 2 Then
				$g_i_ASMSize += 3
				$g_s_ASMCode &= '83F8' & Hex(Number($l_i_Value), 2)
			Else
				$g_i_ASMSize += 5
				$g_s_ASMCode &= '3D' & Assembler_ASMNumber($l_i_Value)
			EndIf
		Case StringRegExp($a_s_ASM, 'cmp ebx,[-[:xdigit:]]{1,2}\z')
			Local $l_i_Value = StringMid($a_s_ASM, 9)
			$g_i_ASMSize += 3
			$g_s_ASMCode &= '83FB' & Hex(Number($l_i_Value), 2)
		Case StringRegExp($a_s_ASM, 'cmp ecx,[-[:xdigit:]]{1,2}\z')
			Local $l_i_Value = StringMid($a_s_ASM, 9)
			$g_i_ASMSize += 3
			$g_s_ASMCode &= '83F9' & Hex(Number($l_i_Value), 2)
		Case StringRegExp($a_s_ASM, 'cmp edx,[-[:xdigit:]]{1,2}\z')
			Local $l_i_Value = StringMid($a_s_ASM, 9)
			$g_i_ASMSize += 3
			$g_s_ASMCode &= '83FA' & Hex(Number($l_i_Value), 2)
		Case StringRegExp($a_s_ASM, 'cmp ebx,dword\[[a-z,A-Z]{4,}\]')
			$g_i_ASMSize += 6
			$g_s_ASMCode &= '3B1D[' & StringMid($a_s_ASM, 15, StringLen($a_s_ASM) - 15) & ']'
		Case StringRegExp($a_s_ASM, 'cmp dword[[][a-z,A-Z]{4,}[]],[-[:xdigit:]]')
			$l_v_Buffer = StringInStr($a_s_ASM, ',')
			$l_v_Buffer = Assembler_ASMNumber(StringMid($a_s_ASM, $l_v_Buffer + 1), True)
			If @extended Then
				$g_i_ASMSize += 7
				$g_s_ASMCode &= '833D[' & StringMid($a_s_ASM, 11, StringInStr($a_s_ASM, ',') - 12) & ']' & $l_v_Buffer
			Else
				$g_i_ASMSize += 10
				$g_s_ASMCode &= '813D[' & StringMid($a_s_ASM, 11, StringInStr($a_s_ASM, ',') - 12) & ']' & $l_v_Buffer
			EndIf
		Case StringRegExp($a_s_ASM, 'cmp ecx,[a-z,A-Z]{4,}') And StringInStr($a_s_ASM, ',dword') = 0
			$g_i_ASMSize += 6
			$g_s_ASMCode &= '81F9[' & StringRight($a_s_ASM, StringLen($a_s_ASM) - 8) & ']'
		Case StringRegExp($a_s_ASM, 'cmp eax,[a-z,A-Z]{4,}') And StringInStr($a_s_ASM, ',dword') = 0
			$g_i_ASMSize += 5
			$g_s_ASMCode &= '3D[' & StringRight($a_s_ASM, StringLen($a_s_ASM) - 8) & ']'
		Case StringRegExp($a_s_ASM, 'cmp ebx,[-[:xdigit:]]{1,8}\z')
			$l_v_Buffer = Assembler_ASMNumber(StringMid($a_s_ASM, 9), True)
			If @extended Then
				$g_i_ASMSize += 3
				$g_s_ASMCode &= '83FB' & $l_v_Buffer
			Else
				$g_i_ASMSize += 6
				$g_s_ASMCode &= '81FB' & $l_v_Buffer
			EndIf
		Case StringLeft($a_s_ASM, 8) = 'cmp ecx,' And StringLen($a_s_ASM) > 10
			Local $l_s_OpCode = '81F9' & StringMid($a_s_ASM, 9)
			$g_i_ASMSize += 0.5 * StringLen($l_s_OpCode)
			$g_s_ASMCode &= $l_s_OpCode
		Case StringRegExp($a_s_ASM, 'add esp,0x[0-9A-Fa-f]+')
			Local $l_i_Value = StringRegExpReplace($a_s_ASM, 'add esp,0x([0-9A-Fa-f]+)', '$1')
			$l_i_Value = Dec($l_i_Value)
			If $l_i_Value <= 0x7F Then
				$g_i_ASMSize += 3
				$g_s_ASMCode &= '83C4' & Hex($l_i_Value, 2)
			Else
				$g_i_ASMSize += 6
				$g_s_ASMCode &= '81C4' & Utils_SwapEndian(Hex($l_i_Value, 8))
			EndIf
		Case StringRegExp($a_s_ASM, 'add eax,[0-9A-Fa-f]+h')
			Local $l_i_Value = StringRegExpReplace($a_s_ASM, 'add eax,([0-9A-Fa-f]+)h', '$1')
			$l_i_Value = Dec($l_i_Value)
			If $l_i_Value <= 0x7F Then
				$g_i_ASMSize += 3
				$g_s_ASMCode &= '83C0' & Hex($l_i_Value, 2)
			Else
				$g_i_ASMSize += 5
				$g_s_ASMCode &= '05' & Utils_SwapEndian(Hex($l_i_Value, 8))
			EndIf
		Case StringRegExp($a_s_ASM, 'add ebx,[0-9A-Fa-f]+h')
			Local $l_i_Value = StringRegExpReplace($a_s_ASM, 'add ebx,([0-9A-Fa-f]+)h', '$1')
			$l_i_Value = Dec($l_i_Value)
			If $l_i_Value <= 0x7F Then
				$g_i_ASMSize += 3
				$g_s_ASMCode &= '83C3' & Hex($l_i_Value, 2)
			Else
				$g_i_ASMSize += 6
				$g_s_ASMCode &= '81C3' & Utils_SwapEndian(Hex($l_i_Value, 8))
			EndIf
		Case StringRegExp($a_s_ASM, 'add ebx,dword\[[a-zA-Z_][a-zA-Z0-9_]*\]')
		   Local $l_s_Label = StringRegExpReplace($a_s_ASM, 'add ebx,dword\[([a-zA-Z_][a-zA-Z0-9_]*)\]', '$1')
		   $g_i_ASMSize += 6
		   $g_s_ASMCode &= '031D[' & $l_s_Label & ']'
		Case StringRegExp($a_s_ASM, 'add eax,dword\[[a-zA-Z_][a-zA-Z0-9_]*\]')
		   Local $l_s_Label = StringRegExpReplace($a_s_ASM, 'add eax,dword\[([a-zA-Z_][a-zA-Z0-9_]*)\]', '$1')
		   $g_i_ASMSize += 5
		   $g_s_ASMCode &= '0305[' & $l_s_Label & ']'
		Case StringRegExp($a_s_ASM, 'add ecx,[0-9A-Fa-f]+h')
			Local $l_i_Value = StringRegExpReplace($a_s_ASM, 'add ecx,([0-9A-Fa-f]+)h', '$1')
			$l_i_Value = Dec($l_i_Value)
			If $l_i_Value <= 0x7F Then
				$g_i_ASMSize += 3
				$g_s_ASMCode &= '83C1' & Hex($l_i_Value, 2)
			Else
				$g_i_ASMSize += 6
				$g_s_ASMCode &= '81C1' & Utils_SwapEndian(Hex($l_i_Value, 8))
			EndIf
		Case StringRegExp($a_s_ASM, 'add edx,[0-9A-Fa-f]+h')
			Local $l_i_Value = StringRegExpReplace($a_s_ASM, 'add edx,([0-9A-Fa-f]+)h', '$1')
			$l_i_Value = Dec($l_i_Value)
			If $l_i_Value <= 0x7F Then
				$g_i_ASMSize += 3
				$g_s_ASMCode &= '83C2' & Hex($l_i_Value, 2)
			Else
				$g_i_ASMSize += 6
				$g_s_ASMCode &= '81C2' & Utils_SwapEndian(Hex($l_i_Value, 8))
			EndIf
		Case StringRegExp($a_s_ASM, 'add eax,[-[:xdigit:]]{1,8}\z')
			$l_v_Buffer = Assembler_ASMNumber(StringMid($a_s_ASM, 9), True)
			If @extended Then
				$g_i_ASMSize += 3
				$g_s_ASMCode &= '83C0' & $l_v_Buffer
			Else
				$g_i_ASMSize += 5
				$g_s_ASMCode &= '05' & $l_v_Buffer
			EndIf
		Case StringRegExp($a_s_ASM, 'add ebx,[-[:xdigit:]]{1,8}\z')
			$l_v_Buffer = Assembler_ASMNumber(StringMid($a_s_ASM, 9), True)
			If @extended Then
				$g_i_ASMSize += 3
				$g_s_ASMCode &= '83C3' & $l_v_Buffer
			Else
				$g_i_ASMSize += 6
				$g_s_ASMCode &= '81C3' & $l_v_Buffer
			EndIf
		Case StringRegExp($a_s_ASM, 'add ecx,[-[:xdigit:]]{1,8}\z')
			$l_v_Buffer = Assembler_ASMNumber(StringMid($a_s_ASM, 9), True)
			If @extended Then
				$g_i_ASMSize += 3
				$g_s_ASMCode &= '83C1' & $l_v_Buffer
			Else
				$g_i_ASMSize += 6
				$g_s_ASMCode &= '81C1' & $l_v_Buffer
			EndIf
		Case StringRegExp($a_s_ASM, 'add edx,[-[:xdigit:]]{1,8}\z')
			$l_v_Buffer = Assembler_ASMNumber(StringMid($a_s_ASM, 9), True)
			If @extended Then
				$g_i_ASMSize += 3
				$g_s_ASMCode &= '83C2' & $l_v_Buffer
			Else
				$g_i_ASMSize += 6
				$g_s_ASMCode &= '81C2' & $l_v_Buffer
			EndIf
		Case StringRegExp($a_s_ASM, 'add edi,[-[:xdigit:]]{1,8}\z')
			$l_v_Buffer = Assembler_ASMNumber(StringMid($a_s_ASM, 9), True)
			If @extended Then
				$g_i_ASMSize += 3
				$g_s_ASMCode &= '83C7' & $l_v_Buffer
			Else
				$g_i_ASMSize += 6
				$g_s_ASMCode &= '81C7' & $l_v_Buffer
			EndIf
		Case StringRegExp($a_s_ASM, 'add esi,[-[:xdigit:]]{1,8}\z')
			$l_v_Buffer = Assembler_ASMNumber(StringMid($a_s_ASM, 9), True)
			If @extended Then
				$g_i_ASMSize += 3
				$g_s_ASMCode &= '83C6' & $l_v_Buffer
			Else
				$g_i_ASMSize += 6
				$g_s_ASMCode &= '81C6' & $l_v_Buffer
			EndIf
		Case StringRegExp($a_s_ASM, 'add esp,[-[:xdigit:]]{1,8}\z')
			$l_v_Buffer = Assembler_ASMNumber(StringMid($a_s_ASM, 9), True)
			If @extended Then
				$g_i_ASMSize += 3
				$g_s_ASMCode &= '83C4' & $l_v_Buffer
			Else
				$g_i_ASMSize += 6
				$g_s_ASMCode &= '81C4' & $l_v_Buffer
			EndIf
		Case StringRegExp($a_s_ASM, 'add eax,[a-z,A-Z]{4,}') And StringInStr($a_s_ASM, ',dword') = 0
			$g_i_ASMSize += 5
			$g_s_ASMCode &= '05[' & StringRight($a_s_ASM, StringLen($a_s_ASM) - 8) & ']'
		Case StringRegExp($a_s_ASM, 'inc dword\[eax\+[0-9A-Fa-f]+h\]')
			Local $l_i_Offset = StringRegExpReplace($a_s_ASM, 'inc dword\[eax\+([0-9A-Fa-f]+)h\]', '$1')
			$l_i_Offset = Dec($l_i_Offset)
			If $l_i_Offset <= 0x7F Then
				$g_i_ASMSize += 3
				$g_s_ASMCode &= 'FF40' & Hex($l_i_Offset, 2)
			Else
				$g_i_ASMSize += 6
				$g_s_ASMCode &= 'FF80' & Utils_SwapEndian(Hex($l_i_Offset, 8))
			EndIf
		Case StringRegExp($a_s_ASM, 'inc dword\[esi\+0x[0-9A-Fa-f]+\]')
			Local $l_i_Offset = StringRegExpReplace($a_s_ASM, 'inc dword\[esi\+0x([0-9A-Fa-f]+)\]', '$1')
			$l_i_Offset = Dec($l_i_Offset)
			If $l_i_Offset <= 0x7F Then
				$g_i_ASMSize += 3
				$g_s_ASMCode &= 'FF46' & Hex($l_i_Offset, 2)
			Else
				$g_i_ASMSize += 6
				$g_s_ASMCode &= 'FF86' & Utils_SwapEndian(Hex($l_i_Offset, 8))
			EndIf
		Case StringRegExp($a_s_ASM, 'inc dword\[ebx\+[0-9A-Fa-f]+h\]')
			Local $l_i_Offset = StringRegExpReplace($a_s_ASM, 'inc dword\[ebx\+([0-9A-Fa-f]+)h\]', '$1')
			$l_i_Offset = Dec($l_i_Offset)
			If $l_i_Offset <= 0x7F Then
				$g_i_ASMSize += 3
				$g_s_ASMCode &= 'FF43' & Hex($l_i_Offset, 2)
			Else
				$g_i_ASMSize += 6
				$g_s_ASMCode &= 'FF83' & Utils_SwapEndian(Hex($l_i_Offset, 8))
			EndIf
		Case StringRegExp($a_s_ASM, 'inc dword\[ecx\+[0-9A-Fa-f]+h\]')
			Local $l_i_Offset = StringRegExpReplace($a_s_ASM, 'inc dword\[ecx\+([0-9A-Fa-f]+)h\]', '$1')
			$l_i_Offset = Dec($l_i_Offset)
			If $l_i_Offset <= 0x7F Then
				$g_i_ASMSize += 3
				$g_s_ASMCode &= 'FF41' & Hex($l_i_Offset, 2)
			Else
				$g_i_ASMSize += 6
				$g_s_ASMCode &= 'FF81' & Utils_SwapEndian(Hex($l_i_Offset, 8))
			EndIf
		Case StringRegExp($a_s_ASM, 'inc dword\[edx\+[0-9A-Fa-f]+h\]')
			Local $l_i_Offset = StringRegExpReplace($a_s_ASM, 'inc dword\[edx\+([0-9A-Fa-f]+)h\]', '$1')
			$l_i_Offset = Dec($l_i_Offset)
			If $l_i_Offset <= 0x7F Then
				$g_i_ASMSize += 3
				$g_s_ASMCode &= 'FF42' & Hex($l_i_Offset, 2)
			Else
				$g_i_ASMSize += 6
				$g_s_ASMCode &= 'FF82' & Utils_SwapEndian(Hex($l_i_Offset, 8))
			EndIf
		Case StringRegExp($a_s_ASM, 'inc dword\[esi\+[0-9A-Fa-f]+h\]')
			Local $l_i_Offset = StringRegExpReplace($a_s_ASM, 'inc dword\[esi\+([0-9A-Fa-f]+)h\]', '$1')
			$l_i_Offset = Dec($l_i_Offset)
			If $l_i_Offset <= 0x7F Then
				$g_i_ASMSize += 3
				$g_s_ASMCode &= 'FF46' & Hex($l_i_Offset, 2)
			Else
				$g_i_ASMSize += 6
				$g_s_ASMCode &= 'FF86' & Utils_SwapEndian(Hex($l_i_Offset, 8))
			EndIf
		Case StringRegExp($a_s_ASM, 'inc dword\[edi\+[0-9A-Fa-f]+h\]')
			Local $l_i_Offset = StringRegExpReplace($a_s_ASM, 'inc dword\[edi\+([0-9A-Fa-f]+)h\]', '$1')
			$l_i_Offset = Dec($l_i_Offset)
			If $l_i_Offset <= 0x7F Then
				$g_i_ASMSize += 3
				$g_s_ASMCode &= 'FF47' & Hex($l_i_Offset, 2)
			Else
				$g_i_ASMSize += 6
				$g_s_ASMCode &= 'FF87' & Utils_SwapEndian(Hex($l_i_Offset, 8))
			EndIf
		Case StringRegExp($a_s_ASM, 'inc dword\[ebp\+[0-9A-Fa-f]+h\]')
			Local $l_i_Offset = StringRegExpReplace($a_s_ASM, 'inc dword\[ebp\+([0-9A-Fa-f]+)h\]', '$1')
			$l_i_Offset = Dec($l_i_Offset)
			If $l_i_Offset <= 0x7F Then
				$g_i_ASMSize += 3
				$g_s_ASMCode &= 'FF45' & Hex($l_i_Offset, 2)
			Else
				$g_i_ASMSize += 6
				$g_s_ASMCode &= 'FF85' & Utils_SwapEndian(Hex($l_i_Offset, 8))
			EndIf
		Case StringRegExp($a_s_ASM, 'inc dword\[esp\+[0-9A-Fa-f]+h\]')
			Local $l_i_Offset = StringRegExpReplace($a_s_ASM, 'inc dword\[esp\+([0-9A-Fa-f]+)h\]', '$1')
			$l_i_Offset = Dec($l_i_Offset)
			If $l_i_Offset <= 0x7F Then
				$g_i_ASMSize += 4
				$g_s_ASMCode &= 'FF4424' & Hex($l_i_Offset, 2)
			Else
				$g_i_ASMSize += 7
				$g_s_ASMCode &= 'FF8424' & Utils_SwapEndian(Hex($l_i_Offset, 8))
			EndIf
		Case StringRegExp($a_s_ASM, 'inc dword\[esi\+[0-9A-Fa-f]+\]')
			Local $l_i_Offset = StringRegExpReplace($a_s_ASM, 'inc dword\[esi\+([0-9A-Fa-f]+)\]', '$1')
			$l_i_Offset = Dec($l_i_Offset)
			If $l_i_Offset <= 0x7F Then
				$g_i_ASMSize += 3
				$g_s_ASMCode &= 'FF46' & Hex($l_i_Offset, 2)
			Else
				$g_i_ASMSize += 6
				$g_s_ASMCode &= 'FF86' & Utils_SwapEndian(Hex($l_i_Offset, 8))
			EndIf
		Case StringRegExp($a_s_ASM, 'inc dword\[[a-zA-Z_][a-zA-Z0-9_]*\]')
			Local $l_s_Label = StringRegExpReplace($a_s_ASM, 'inc dword\[([a-zA-Z_][a-zA-Z0-9_]*)\]', '$1')
			$g_i_ASMSize += 6
			$g_s_ASMCode &= 'FF05[' & $l_s_Label & ']'
		Case StringRegExp($a_s_ASM, 'dec dword\[[a-zA-Z_][a-zA-Z0-9_]*\]')
			Local $l_s_Label = StringRegExpReplace($a_s_ASM, 'dec dword\[([a-zA-Z_][a-zA-Z0-9_]*)\]', '$1')
			$g_i_ASMSize += 6
			$g_s_ASMCode &= 'FF0D[' & $l_s_Label & ']'
		Case StringRegExp($a_s_ASM, 'and ebx,[-[:xdigit:]]{1,8}\z')
			Local $l_i_Value = StringMid($a_s_ASM, 9)
			If StringLen($l_i_Value) <= 2 And Dec($l_i_Value) <= 0x7F Then
				$g_i_ASMSize += 3
				$g_s_ASMCode &= '83E3' & Hex(Dec($l_i_Value), 2)
			Else
				$g_i_ASMSize += 6
				$g_s_ASMCode &= '81E3' & Assembler_ASMNumber($l_i_Value)
			EndIf
		Case StringRegExp($a_s_ASM, 'and edx,[-[:xdigit:]]{1,8}\z')
			Local $l_i_Value = StringMid($a_s_ASM, 9)
			If StringLen($l_i_Value) <= 2 And Dec($l_i_Value) <= 0x7F Then
				$g_i_ASMSize += 3
				$g_s_ASMCode &= '83E2' & Hex(Dec($l_i_Value), 2)
			Else
				$g_i_ASMSize += 6
				$g_s_ASMCode &= '81E2' & Assembler_ASMNumber($l_i_Value)
			EndIf
		Case StringRegExp($a_s_ASM, 'and ecx,[-[:xdigit:]]{1,8}\z')
			Local $l_i_Value = StringMid($a_s_ASM, 9)
			$g_i_ASMSize += 6
			$g_s_ASMCode &= '81E1' & Assembler_ASMNumber($l_i_Value)
		Case StringRegExp($a_s_ASM, 'and eax,[-[:xdigit:]]{1,8}\z')
			Local $l_i_Value = StringMid($a_s_ASM, 9)
			$g_i_ASMSize += 5
			$g_s_ASMCode &= '25' & Assembler_ASMNumber($l_i_Value)
		Case StringRegExp($a_s_ASM, 'or eax,[-[:xdigit:]]{1,8}\z')
			Local $l_i_Value = StringMid($a_s_ASM, 8)
			$g_i_ASMSize += 5
			$g_s_ASMCode &= '0D' & Assembler_ASMNumber($l_i_Value)
		Case StringRegExp($a_s_ASM, 'push dword\[eax\+[0-9A-Fa-f]+\]')
            Local $l_i_Offset = StringRegExpReplace($a_s_ASM, 'push dword\[eax\+([0-9A-Fa-f]+)\]', '$1')
            $l_i_Offset = Dec($l_i_Offset)
            If $l_i_Offset <= 0x7F Then
                $g_i_ASMSize += 3
                $g_s_ASMCode &= 'FF70' & Hex($l_i_Offset, 2)
            Else
                $g_i_ASMSize += 6
                $g_s_ASMCode &= 'FFB0' & Utils_SwapEndian(Hex($l_i_Offset, 8))
            EndIf
		Case StringRegExp($a_s_ASM, 'push dword[[][a-z,A-Z]{4,}[]]')
			$g_i_ASMSize += 6
			$g_s_ASMCode &= 'FF35[' & StringMid($a_s_ASM, 12, StringLen($a_s_ASM) - 12) & ']'
		Case StringRegExp($a_s_ASM, 'push [a-z,A-Z]{4,}\z')
			$g_i_ASMSize += 5
			$g_s_ASMCode &= '68[' & StringMid($a_s_ASM, 6, StringLen($a_s_ASM) - 5) & ']'
		Case StringRegExp($a_s_ASM, 'push [-[:xdigit:]]{1,8}\z')
			$l_v_Buffer = Assembler_ASMNumber(StringMid($a_s_ASM, 6), True)
			If @extended Then
				$g_i_ASMSize += 2
				$g_s_ASMCode &= '6A' & $l_v_Buffer
			Else
				$g_i_ASMSize += 5
				$g_s_ASMCode &= '68' & $l_v_Buffer
			EndIf
		Case StringRegExp($a_s_ASM, 'lea eax,dword[[]ecx[*]8[+][a-z,A-Z]{4,}[]]')
			$g_i_ASMSize += 7
			$g_s_ASMCode &= '8D04CD[' & StringMid($a_s_ASM, 21, StringLen($a_s_ASM) - 21) & ']'
		Case StringRegExp($a_s_ASM, 'lea edi,dword\[edx\+[a-z,A-Z]{4,}\]')
			$g_i_ASMSize += 7
			$g_s_ASMCode &= '8D3C15[' & StringMid($a_s_ASM, 19, StringLen($a_s_ASM) - 19) & ']'
		Case StringRegExp($a_s_ASM, 'lea eax,dword[[]edx[*]4[+][a-z,A-Z]{4,}[]]')
			$g_i_ASMSize += 7
			$g_s_ASMCode &= '8D0495[' & StringMid($a_s_ASM, 21, StringLen($a_s_ASM) - 21) & ']'
		Case StringRegExp($a_s_ASM, 'mov eax,dword\[esp\+[0-9A-Fa-f]+h?\]')
			Local $l_i_Offset = StringRegExpReplace($a_s_ASM, 'mov eax,dword\[esp\+([0-9A-Fa-f]+)h?\]', '$1')
			$l_i_Offset = StringReplace($l_i_Offset, "h", "")
			$l_i_Offset = Dec($l_i_Offset)
			If $l_i_Offset <= 0x7F Then
				$g_i_ASMSize += 4
				$g_s_ASMCode &= '8B4424' & Hex($l_i_Offset, 2)
			Else
				$g_i_ASMSize += 7
				$g_s_ASMCode &= '8B8424' & Utils_SwapEndian(Hex($l_i_Offset, 8))
			EndIf
		Case StringRegExp($a_s_ASM, 'mov ebx,dword\[esp\+[0-9A-Fa-f]+h?\]')
			Local $l_i_Offset = StringRegExpReplace($a_s_ASM, 'mov ebx,dword\[esp\+([0-9A-Fa-f]+)h?\]', '$1')
			$l_i_Offset = StringReplace($l_i_Offset, "h", "")
			$l_i_Offset = Dec($l_i_Offset)
			If $l_i_Offset <= 0x7F Then
				$g_i_ASMSize += 4
				$g_s_ASMCode &= '8B5C24' & Hex($l_i_Offset, 2)
			Else
				$g_i_ASMSize += 7
				$g_s_ASMCode &= '8B9C24' & Utils_SwapEndian(Hex($l_i_Offset, 8))
			EndIf
		Case StringRegExp($a_s_ASM, 'mov ecx,dword\[esp\+[0-9A-Fa-f]+h?\]')
			Local $l_i_Offset = StringRegExpReplace($a_s_ASM, 'mov ecx,dword\[esp\+([0-9A-Fa-f]+)h?\]', '$1')
			$l_i_Offset = StringReplace($l_i_Offset, "h", "")
			$l_i_Offset = Dec($l_i_Offset)
			If $l_i_Offset <= 0x7F Then
				$g_i_ASMSize += 4
				$g_s_ASMCode &= '8B4C24' & Hex($l_i_Offset, 2)
			Else
				$g_i_ASMSize += 7
				$g_s_ASMCode &= '8B8C24' & Utils_SwapEndian(Hex($l_i_Offset, 8))
			EndIf
		Case StringRegExp($a_s_ASM, 'mov edx,dword\[esp\+[0-9A-Fa-f]+h?\]')
			Local $l_i_Offset = StringRegExpReplace($a_s_ASM, 'mov edx,dword\[esp\+([0-9A-Fa-f]+)h?\]', '$1')
			$l_i_Offset = StringReplace($l_i_Offset, "h", "")
			$l_i_Offset = Dec($l_i_Offset)
			If $l_i_Offset <= 0x7F Then
				$g_i_ASMSize += 4
				$g_s_ASMCode &= '8B5424' & Hex($l_i_Offset, 2)
			Else
				$g_i_ASMSize += 7
				$g_s_ASMCode &= '8B9424' & Utils_SwapEndian(Hex($l_i_Offset, 8))
			EndIf
		Case StringRegExp($a_s_ASM, 'mov esi,dword\[esp\+[0-9A-Fa-f]+h?\]')
			Local $l_i_Offset = StringRegExpReplace($a_s_ASM, 'mov esi,dword\[esp\+([0-9A-Fa-f]+)h?\]', '$1')
			$l_i_Offset = StringReplace($l_i_Offset, "h", "")
			$l_i_Offset = Dec($l_i_Offset)
			If $l_i_Offset <= 0x7F Then
				$g_i_ASMSize += 4
				$g_s_ASMCode &= '8B7424' & Hex($l_i_Offset, 2)
			Else
				$g_i_ASMSize += 7
				$g_s_ASMCode &= '8BB424' & Utils_SwapEndian(Hex($l_i_Offset, 8))
			EndIf
		Case StringRegExp($a_s_ASM, 'mov edi,dword\[esp\+[0-9A-Fa-f]+h?\]')
			Local $l_i_Offset = StringRegExpReplace($a_s_ASM, 'mov edi,dword\[esp\+([0-9A-Fa-f]+)h?\]', '$1')
			$l_i_Offset = StringReplace($l_i_Offset, "h", "")
			$l_i_Offset = Dec($l_i_Offset)
			If $l_i_Offset <= 0x7F Then
				$g_i_ASMSize += 4
				$g_s_ASMCode &= '8B7C24' & Hex($l_i_Offset, 2)
			Else
				$g_i_ASMSize += 7
				$g_s_ASMCode &= '8BBC24' & Utils_SwapEndian(Hex($l_i_Offset, 8))
			EndIf
		Case StringRegExp($a_s_ASM, 'mov ebp,dword\[esp\+[0-9A-Fa-f]+h?\]')
			Local $l_i_Offset = StringRegExpReplace($a_s_ASM, 'mov ebp,dword\[esp\+([0-9A-Fa-f]+)h?\]', '$1')
			$l_i_Offset = StringReplace($l_i_Offset, "h", "")
			$l_i_Offset = Dec($l_i_Offset)
			If $l_i_Offset <= 0x7F Then
				$g_i_ASMSize += 4
				$g_s_ASMCode &= '8B6C24' & Hex($l_i_Offset, 2)
			Else
				$g_i_ASMSize += 7
				$g_s_ASMCode &= '8BAC24' & Utils_SwapEndian(Hex($l_i_Offset, 8))
			EndIf
		Case StringRegExp($a_s_ASM, 'mov dword\[eax\],0x[0-9A-Fa-f]+\z')
			Local $l_i_Value = StringMid($a_s_ASM, 15)
			$l_i_Value = StringReplace($l_i_Value, "0x", "")
			$g_i_ASMSize += 6
			$g_s_ASMCode &= 'C700' & Utils_SwapEndian(Hex(Dec("0x" & $l_i_Value), 8))
		Case StringLeft($a_s_ASM, 17) = 'mov edx,dword[esi]'
			$g_i_ASMSize += 2
			$g_s_ASMCode &= '8B16'
		Case StringLeft($a_s_ASM, 17) = 'mov edx,dword[edi]'
			$g_i_ASMSize += 2
			$g_s_ASMCode &= '8B17'
		Case StringLeft($a_s_ASM, 17) = 'mov eax,dword[esi]'
			$g_i_ASMSize += 2
			$g_s_ASMCode &= '8B06'
		Case StringLeft($a_s_ASM, 17) = 'mov eax,dword[edi]'
			$g_i_ASMSize += 2
			$g_s_ASMCode &= '8B07'
		Case StringLeft($a_s_ASM, 17) = 'mov ecx,dword[esi]'
			$g_i_ASMSize += 2
			$g_s_ASMCode &= '8B0E'
		Case StringLeft($a_s_ASM, 17) = 'mov ecx,dword[edi]'
			$g_i_ASMSize += 2
			$g_s_ASMCode &= '8B0F'
		Case StringLeft($a_s_ASM, 17) = 'mov ebx,dword[esi]'
			$g_i_ASMSize += 2
			$g_s_ASMCode &= '8B1E'
		Case StringLeft($a_s_ASM, 17) = 'mov ebx,dword[edi]'
			$g_i_ASMSize += 2
			$g_s_ASMCode &= '8B1F'
		Case StringRegExp($a_s_ASM, 'mov dword\[eax\+[0-9A-Fa-f]+\],esi')
			Local $l_i_Offset = StringRegExpReplace($a_s_ASM, 'mov dword\[eax\+([0-9A-Fa-f]+)\],esi', '$1')
			$l_i_Offset = Dec($l_i_Offset)
			If $l_i_Offset <= 0x7F Then
				$g_i_ASMSize += 3
				$g_s_ASMCode &= '8970' & Hex($l_i_Offset, 2)
			Else
				$g_i_ASMSize += 6
				$g_s_ASMCode &= '89B0' & Utils_SwapEndian(Hex($l_i_Offset, 8))
			EndIf
		Case StringRegExp($a_s_ASM, 'mov eax,dword[[][a-z,A-Z]{4,}[]]')
			$g_i_ASMSize += 5
			$g_s_ASMCode &= 'A1[' & StringMid($a_s_ASM, 15, StringLen($a_s_ASM) - 15) & ']'
		Case StringRegExp($a_s_ASM, 'mov ebx,dword[[][a-z,A-Z]{4,}[]]')
			$g_i_ASMSize += 6
			$g_s_ASMCode &= '8B1D[' & StringMid($a_s_ASM, 15, StringLen($a_s_ASM) - 15) & ']'
		Case StringRegExp($a_s_ASM, 'mov ecx,dword[[][a-z,A-Z]{4,}[]]')
			$g_i_ASMSize += 6
			$g_s_ASMCode &= '8B0D[' & StringMid($a_s_ASM, 15, StringLen($a_s_ASM) - 15) & ']'
		Case StringRegExp($a_s_ASM, 'mov edx,dword[[][a-z,A-Z]{4,}[]]')
			$g_i_ASMSize += 6
			$g_s_ASMCode &= '8B15[' & StringMid($a_s_ASM, 15, StringLen($a_s_ASM) - 15) & ']'
		Case StringRegExp($a_s_ASM, 'mov esi,dword[[][a-z,A-Z]{4,}[]]')
			$g_i_ASMSize += 6
			$g_s_ASMCode &= '8B35[' & StringMid($a_s_ASM, 15, StringLen($a_s_ASM) - 15) & ']'
		Case StringRegExp($a_s_ASM, 'mov edi,dword[[][a-z,A-Z]{4,}[]]')
			$g_i_ASMSize += 6
			$g_s_ASMCode &= '8B3D[' & StringMid($a_s_ASM, 15, StringLen($a_s_ASM) - 15) & ']'
		Case StringRegExp($a_s_ASM, 'mov eax,[a-z,A-Z]{4,}') And StringInStr($a_s_ASM, ',dword') = 0
			$g_i_ASMSize += 5
			$g_s_ASMCode &= 'B8[' & StringRight($a_s_ASM, StringLen($a_s_ASM) - 8) & ']'
		Case StringRegExp($a_s_ASM, 'mov ebx,[a-z,A-Z]{4,}') And StringInStr($a_s_ASM, ',dword') = 0
			$g_i_ASMSize += 5
			$g_s_ASMCode &= 'BB[' & StringRight($a_s_ASM, StringLen($a_s_ASM) - 8) & ']'
		Case StringRegExp($a_s_ASM, 'mov ecx,[a-z,A-Z]{4,}') And StringInStr($a_s_ASM, ',dword') = 0
			$g_i_ASMSize += 5
			$g_s_ASMCode &= 'B9[' & StringRight($a_s_ASM, StringLen($a_s_ASM) - 8) & ']'
		Case StringRegExp($a_s_ASM, 'mov esi,[a-z,A-Z]{4,}') And StringInStr($a_s_ASM, ',dword') = 0
			$g_i_ASMSize += 5
			$g_s_ASMCode &= 'BE[' & StringRight($a_s_ASM, StringLen($a_s_ASM) - 8) & ']'
		Case StringRegExp($a_s_ASM, 'mov edi,[a-z,A-Z]{4,}') And StringInStr($a_s_ASM, ',dword') = 0
			$g_i_ASMSize += 5
			$g_s_ASMCode &= 'BF[' & StringRight($a_s_ASM, StringLen($a_s_ASM) - 8) & ']'
		Case StringRegExp($a_s_ASM, 'mov edx,[a-z,A-Z]{4,}') And StringInStr($a_s_ASM, ',dword') = 0
			$g_i_ASMSize += 5
			$g_s_ASMCode &= 'BA[' & StringRight($a_s_ASM, StringLen($a_s_ASM) - 8) & ']'
		Case StringRegExp($a_s_ASM, 'mov dword[[][a-z,A-Z]{4,}[]],ecx')
			$g_i_ASMSize += 6
			$g_s_ASMCode &= '890D[' & StringMid($a_s_ASM, 11, StringLen($a_s_ASM) - 15) & ']'
		Case StringRegExp($a_s_ASM, 'mov dword[[][a-z,A-Z]{4,}[]],edx')
			$g_i_ASMSize += 6
			$g_s_ASMCode &= '8915[' & StringMid($a_s_ASM, 11, StringLen($a_s_ASM) - 15) & ']'
		Case StringRegExp($a_s_ASM, 'mov dword[[][a-z,A-Z]{4,}[]],eax')
			$g_i_ASMSize += 5
			$g_s_ASMCode &= 'A3[' & StringMid($a_s_ASM, 11, StringLen($a_s_ASM) - 15) & ']'
		Case StringRegExp($a_s_ASM, 'mov eax,dword[[]ecx[*]4[+][a-z,A-Z]{4,}[]]')
			$g_i_ASMSize += 7
			$g_s_ASMCode &= '8B048D[' & StringMid($a_s_ASM, 21, StringLen($a_s_ASM) - 21) & ']'
		Case StringRegExp($a_s_ASM, 'mov ecx,dword[[]ecx[*]4[+][a-z,A-Z]{4,}[]]')
			$g_i_ASMSize += 7
			$g_s_ASMCode &= '8B0C8D[' & StringMid($a_s_ASM, 21, StringLen($a_s_ASM) - 21) & ']'
		Case StringRegExp($a_s_ASM, 'mov dword\[[a-z,A-Z]{4,}\],[-[:xdigit:]]{1,8}\z')
			$l_v_Buffer = StringInStr($a_s_ASM, ',')
			$g_i_ASMSize += 10
			$g_s_ASMCode &= 'C705[' & StringMid($a_s_ASM, 11, $l_v_Buffer - 12) & ']' & Assembler_ASMNumber(StringMid($a_s_ASM, $l_v_Buffer + 1))
		Case StringRegExp($a_s_ASM, 'mov eax,[-[:xdigit:]]{1,8}\z')
			$g_i_ASMSize += 5
			$g_s_ASMCode &= 'B8' & Assembler_ASMNumber(StringMid($a_s_ASM, 9))
		Case StringRegExp($a_s_ASM, 'mov ebx,[-[:xdigit:]]{1,8}\z')
			$g_i_ASMSize += 5
			$g_s_ASMCode &= 'BB' & Assembler_ASMNumber(StringMid($a_s_ASM, 9))
		Case StringRegExp($a_s_ASM, 'mov ecx,[-[:xdigit:]]{1,8}\z')
			$g_i_ASMSize += 5
			$g_s_ASMCode &= 'B9' & Assembler_ASMNumber(StringMid($a_s_ASM, 9))
		Case StringRegExp($a_s_ASM, 'mov edx,[-[:xdigit:]]{1,8}\z')
			$g_i_ASMSize += 5
			$g_s_ASMCode &= 'BA' & Assembler_ASMNumber(StringMid($a_s_ASM, 9))
		Case StringRegExp($a_s_ASM, 'mov ecx,dword\[eax\+[0-9A-Fa-f]+\]')
			Local $l_i_Offset = StringRegExpReplace($a_s_ASM, 'mov ecx,dword\[eax\+([0-9A-Fa-f]+)\]', '$1')
			$l_i_Offset = Dec($l_i_Offset)
			If $l_i_Offset <= 0x7F Then
				$g_i_ASMSize += 3
				$g_s_ASMCode &= '8B48' & Hex($l_i_Offset, 2)
			Else
				$g_i_ASMSize += 6
				$g_s_ASMCode &= '8B88' & Utils_SwapEndian(Hex($l_i_Offset, 8))
			EndIf
		Case StringRegExp($a_s_ASM, 'mov edx,dword\[eax\+[0-9A-Fa-f]+\]')
			Local $l_i_Offset = StringRegExpReplace($a_s_ASM, 'mov edx,dword\[eax\+([0-9A-Fa-f]+)\]', '$1')
			$l_i_Offset = Dec($l_i_Offset)
			If $l_i_Offset <= 0x7F Then
				$g_i_ASMSize += 3
				$g_s_ASMCode &= '8B50' & Hex($l_i_Offset, 2)
			Else
				$g_i_ASMSize += 6
				$g_s_ASMCode &= '8B90' & Utils_SwapEndian(Hex($l_i_Offset, 8))
			EndIf
		Case StringRegExp($a_s_ASM, 'mov esi,dword\[ebp\+[0-9A-Fa-f]+\]')
			Local $l_i_Offset = StringRegExpReplace($a_s_ASM, 'mov esi,dword\[ebp\+([0-9A-Fa-f]+)\]', '$1')
			$l_i_Offset = Dec($l_i_Offset)
			If $l_i_Offset <= 0x7F Then
				$g_i_ASMSize += 3
				$g_s_ASMCode &= '8B75' & Hex($l_i_Offset, 2)
			Else
				$g_i_ASMSize += 6
				$g_s_ASMCode &= '8BB5' & Utils_SwapEndian(Hex($l_i_Offset, 8))
			EndIf
		Case StringRegExp($a_s_ASM, 'mov edi,dword\[ebp\+[0-9A-Fa-f]+\]')
			Local $l_i_Offset = StringRegExpReplace($a_s_ASM, 'mov edi,dword\[ebp\+([0-9A-Fa-f]+)\]', '$1')
			$l_i_Offset = Dec($l_i_Offset)
			If $l_i_Offset <= 0x7F Then
				$g_i_ASMSize += 3
				$g_s_ASMCode &= '8B7D' & Hex($l_i_Offset, 2)
			Else
				$g_i_ASMSize += 6
				$g_s_ASMCode &= '8BBD' & Utils_SwapEndian(Hex($l_i_Offset, 8))
			EndIf
		Case StringRegExp($a_s_ASM, 'mov ebx,dword\[ebp\+[0-9A-Fa-f]+\]')
			Local $l_i_Offset = StringRegExpReplace($a_s_ASM, 'mov ebx,dword\[ebp\+([0-9A-Fa-f]+)\]', '$1')
			$l_i_Offset = Dec($l_i_Offset)
			If $l_i_Offset <= 0x7F Then
				$g_i_ASMSize += 3
				$g_s_ASMCode &= '8B5D' & Hex($l_i_Offset, 2)
			Else
				$g_i_ASMSize += 6
				$g_s_ASMCode &= '8B9D' & Utils_SwapEndian(Hex($l_i_Offset, 8))
			EndIf
		Case StringRegExp($a_s_ASM, 'mov edx,dword\[ebp\+[0-9A-Fa-f]+\]')
			Local $l_i_Offset = StringRegExpReplace($a_s_ASM, 'mov edx,dword\[ebp\+([0-9A-Fa-f]+)\]', '$1')
			$l_i_Offset = Dec($l_i_Offset)
			If $l_i_Offset <= 0x7F Then
				$g_i_ASMSize += 3
				$g_s_ASMCode &= '8B55' & Hex($l_i_Offset, 2)
			Else
				$g_i_ASMSize += 6
				$g_s_ASMCode &= '8B95' & Utils_SwapEndian(Hex($l_i_Offset, 8))
			EndIf
		Case StringRegExp($a_s_ASM, 'mov dword\[eax\+[0-9A-Fa-f]+\],0')
			Local $l_i_Offset = StringRegExpReplace($a_s_ASM, 'mov dword\[eax\+([0-9A-Fa-f]+)\],0', '$1')
			$l_i_Offset = Dec($l_i_Offset)
			If $l_i_Offset <= 0x7F Then
				$g_i_ASMSize += 7
				$g_s_ASMCode &= 'C740' & Hex($l_i_Offset, 2) & '00000000'
			Else
				$g_i_ASMSize += 10
				$g_s_ASMCode &= 'C780' & Utils_SwapEndian(Hex($l_i_Offset, 8)) & '00000000'
			EndIf
		Case StringRegExp($a_s_ASM, 'mov dword\[ebx\+[0-9A-Fa-f]+\],0')
			Local $l_i_Offset = StringRegExpReplace($a_s_ASM, 'mov dword\[ebx\+([0-9A-Fa-f]+)\],0', '$1')
			$l_i_Offset = Dec($l_i_Offset)
			If $l_i_Offset <= 0x7F Then
				$g_i_ASMSize += 7
				$g_s_ASMCode &= 'C743' & Hex($l_i_Offset, 2) & '00000000'
			Else
				$g_i_ASMSize += 10
				$g_s_ASMCode &= 'C783' & Utils_SwapEndian(Hex($l_i_Offset, 8)) & '00000000'
			EndIf
		Case StringRegExp($a_s_ASM, 'mov dword\[ecx\+[0-9A-Fa-f]+\],0')
			Local $l_i_Offset = StringRegExpReplace($a_s_ASM, 'mov dword\[ecx\+([0-9A-Fa-f]+)\],0', '$1')
			$l_i_Offset = Dec($l_i_Offset)
			If $l_i_Offset <= 0x7F Then
				$g_i_ASMSize += 7
				$g_s_ASMCode &= 'C741' & Hex($l_i_Offset, 2) & '00000000'
			Else
				$g_i_ASMSize += 10
				$g_s_ASMCode &= 'C781' & Utils_SwapEndian(Hex($l_i_Offset, 8)) & '00000000'
			EndIf
		Case StringRegExp($a_s_ASM, 'mov dword\[edx\+[0-9A-Fa-f]+\],0')
			Local $l_i_Offset = StringRegExpReplace($a_s_ASM, 'mov dword\[edx\+([0-9A-Fa-f]+)\],0', '$1')
			$l_i_Offset = Dec($l_i_Offset)
			If $l_i_Offset <= 0x7F Then
				$g_i_ASMSize += 7
				$g_s_ASMCode &= 'C742' & Hex($l_i_Offset, 2) & '00000000'
			Else
				$g_i_ASMSize += 10
				$g_s_ASMCode &= 'C782' & Utils_SwapEndian(Hex($l_i_Offset, 8)) & '00000000'
			EndIf
		Case StringRegExp($a_s_ASM, 'mov dword\[eax\],[-[:xdigit:]]{1,8}\z')
			Local $l_i_Value = StringMid($a_s_ASM, 15)
			$g_i_ASMSize += 6
			$g_s_ASMCode &= 'C700' & Assembler_ASMNumber($l_i_Value)
		Case StringRegExp($a_s_ASM, 'mov dword\[ebx\],[-[:xdigit:]]{1,8}\z')
			Local $l_i_Value = StringMid($a_s_ASM, 15)
			$g_i_ASMSize += 6
			$g_s_ASMCode &= 'C703' & Assembler_ASMNumber($l_i_Value)
		Case StringRegExp($a_s_ASM, 'mov dword\[ecx\],[-[:xdigit:]]{1,8}\z')
			Local $l_i_Value = StringMid($a_s_ASM, 15)
			$g_i_ASMSize += 6
			$g_s_ASMCode &= 'C701' & Assembler_ASMNumber($l_i_Value)
		Case StringRegExp($a_s_ASM, 'mov dword\[edx\],[-[:xdigit:]]{1,8}\z')
			Local $l_i_Value = StringMid($a_s_ASM, 15)
			$g_i_ASMSize += 6
			$g_s_ASMCode &= 'C702' & Assembler_ASMNumber($l_i_Value)
		Case StringRegExp($a_s_ASM, 'mov dword\[eax\],[0-9]\z')
			Local $l_i_Value = StringMid($a_s_ASM, 15)
			$g_i_ASMSize += 6
			$g_s_ASMCode &= 'C700' & Utils_SwapEndian(Hex(Number($l_i_Value), 8))
		Case StringRegExp($a_s_ASM, 'mov dword\[eax\],\d+\z')
			Local $l_i_Value = Number(StringMid($a_s_ASM, 15))
			If $l_i_Value <= 127 Then
				$g_i_ASMSize += 6
				$g_s_ASMCode &= 'C700' & Utils_SwapEndian(Hex($l_i_Value, 8))
			Else
				$g_i_ASMSize += 6
				$g_s_ASMCode &= 'C700' & Assembler_ASMNumber($l_i_Value)
			EndIf
		Case StringRegExp($a_s_ASM, 'mov dword\[eax\+[0-9A-Fa-f]+\],eax')
			Local $l_i_Offset = StringRegExpReplace($a_s_ASM, 'mov dword\[eax\+([0-9A-Fa-f]+)\],eax', '$1')
			$l_i_Offset = Dec($l_i_Offset)
			If $l_i_Offset <= 0x7F Then
				$g_i_ASMSize += 3
				$g_s_ASMCode &= '8940' & Hex($l_i_Offset, 2)
			Else
				$g_i_ASMSize += 6
				$g_s_ASMCode &= '8980' & Utils_SwapEndian(Hex($l_i_Offset, 8))
			EndIf
		Case StringRegExp($a_s_ASM, 'mov dword\[eax\+[0-9A-Fa-f]+\],ebx')
			Local $l_i_Offset = StringRegExpReplace($a_s_ASM, 'mov dword\[eax\+([0-9A-Fa-f]+)\],ebx', '$1')
			$l_i_Offset = Dec($l_i_Offset)
			If $l_i_Offset <= 0x7F Then
				$g_i_ASMSize += 3
				$g_s_ASMCode &= '8958' & Hex($l_i_Offset, 2)
			Else
				$g_i_ASMSize += 6
				$g_s_ASMCode &= '8998' & Utils_SwapEndian(Hex($l_i_Offset, 8))
			EndIf
		Case StringRegExp($a_s_ASM, 'mov dword\[eax\+[0-9A-Fa-f]+\],ecx')
			Local $l_i_Offset = StringRegExpReplace($a_s_ASM, 'mov dword\[eax\+([0-9A-Fa-f]+)\],ecx', '$1')
			$l_i_Offset = Dec($l_i_Offset)
			If $l_i_Offset <= 0x7F Then
				$g_i_ASMSize += 3
				$g_s_ASMCode &= '8948' & Hex($l_i_Offset, 2)
			Else
				$g_i_ASMSize += 6
				$g_s_ASMCode &= '8988' & Utils_SwapEndian(Hex($l_i_Offset, 8))
			EndIf
		Case StringRegExp($a_s_ASM, 'mov dword\[eax\+[0-9A-Fa-f]+\],edx')
			Local $l_i_Offset = StringRegExpReplace($a_s_ASM, 'mov dword\[eax\+([0-9A-Fa-f]+)\],edx', '$1')
			$l_i_Offset = Dec($l_i_Offset)
			If $l_i_Offset <= 0x7F Then
				$g_i_ASMSize += 3
				$g_s_ASMCode &= '8950' & Hex($l_i_Offset, 2)
			Else
				$g_i_ASMSize += 6
				$g_s_ASMCode &= '8990' & Utils_SwapEndian(Hex($l_i_Offset, 8))
			EndIf
		Case StringRegExp($a_s_ASM, 'mov dword\[eax\+[0-9A-Fa-f]+\],esi')
			Local $l_i_Offset = StringRegExpReplace($a_s_ASM, 'mov dword\[eax\+([0-9A-Fa-f]+)\],esi', '$1')
			$l_i_Offset = Dec($l_i_Offset)
			If $l_i_Offset <= 0x7F Then
				$g_i_ASMSize += 3
				$g_s_ASMCode &= '8970' & Hex($l_i_Offset, 2)
			Else
				$g_i_ASMSize += 6
				$g_s_ASMCode &= '89B0' & Utils_SwapEndian(Hex($l_i_Offset, 8))
			EndIf
		Case StringRegExp($a_s_ASM, 'mov dword\[eax\+[0-9A-Fa-f]+\],edi')
			Local $l_i_Offset = StringRegExpReplace($a_s_ASM, 'mov dword\[eax\+([0-9A-Fa-f]+)\],edi', '$1')
			$l_i_Offset = Dec($l_i_Offset)
			If $l_i_Offset <= 0x7F Then
				$g_i_ASMSize += 3
				$g_s_ASMCode &= '8978' & Hex($l_i_Offset, 2)
			Else
				$g_i_ASMSize += 6
				$g_s_ASMCode &= '89B8' & Utils_SwapEndian(Hex($l_i_Offset, 8))
			EndIf
		Case StringRegExp($a_s_ASM, 'mov dword\[eax\+[0-9A-Fa-f]+\],ebp')
			Local $l_i_Offset = StringRegExpReplace($a_s_ASM, 'mov dword\[eax\+([0-9A-Fa-f]+)\],ebp', '$1')
			$l_i_Offset = Dec($l_i_Offset)
			If $l_i_Offset <= 0x7F Then
				$g_i_ASMSize += 3
				$g_s_ASMCode &= '8968' & Hex($l_i_Offset, 2)
			Else
				$g_i_ASMSize += 6
				$g_s_ASMCode &= '89A8' & Utils_SwapEndian(Hex($l_i_Offset, 8))
			EndIf
		Case StringRegExp($a_s_ASM, 'mov dword\[eax\+[0-9A-Fa-f]+\],esp')
			Local $l_i_Offset = StringRegExpReplace($a_s_ASM, 'mov dword\[eax\+([0-9A-Fa-f]+)\],esp', '$1')
			$l_i_Offset = Dec($l_i_Offset)
			If $l_i_Offset <= 0x7F Then
				$g_i_ASMSize += 3
				$g_s_ASMCode &= '8960' & Hex($l_i_Offset, 2)
			Else
				$g_i_ASMSize += 6
				$g_s_ASMCode &= '89A0' & Utils_SwapEndian(Hex($l_i_Offset, 8))
			EndIf
		Case Else
			Local $l_s_OpCode
			Switch $a_s_ASM
				Case 'Flag_'
					$l_s_OpCode = '9090903434'
				Case 'clc'
					$l_s_OpCode = 'F8'
				Case 'retn'
					$l_s_OpCode = 'C3'
				Case 'retn 10'
					$l_s_OpCode = 'C21000'
				Case 'nop'
					$l_s_OpCode = '90'
				Case 'pushad'
					$l_s_OpCode = '60'
				Case 'popad'
					$l_s_OpCode = '61'
				Case 'pushfd'
					$l_s_OpCode = '9C'
				Case 'popfd'
					$l_s_OpCode = '9D'
				Case 'pushf'
					$l_s_OpCode = '9C'
				Case 'popf'
					$l_s_OpCode = '9D'
				Case 'push eax'
					$l_s_OpCode = '50'
				Case 'push ebx'
					$l_s_OpCode = '53'
				Case 'push ecx'
					$l_s_OpCode = '51'
				Case 'push edx'
					$l_s_OpCode = '52'
				Case 'push ebp'
					$l_s_OpCode = '55'
				Case 'push esi'
					$l_s_OpCode = '56'
				Case 'push edi'
					$l_s_OpCode = '57'
				Case 'push dword[ebp+8]'
					$l_s_OpCode = 'FF7508'
				Case 'fld st(0),dword[ebp+8]'
					$l_s_OpCode = 'D94508'
				Case 'repe movsb'
					$l_s_OpCode = 'F3A4'
				Case 'jmp ebx'
					$l_s_OpCode = 'FFE3'
				Case 'pop eax'
					$l_s_OpCode = '58'
				Case 'pop ebx'
					$l_s_OpCode = '5B'
				Case 'pop edx'
					$l_s_OpCode = '5A'
				Case 'pop ecx'
					$l_s_OpCode = '59'
				Case 'pop esi'
					$l_s_OpCode = '5E'
				Case 'pop ebp'
					$l_s_OpCode = '5D'
				Case 'pop edi'
					$l_s_OpCode = '5F'
				Case 'inc eax'
					$l_s_OpCode = '40'
				Case 'inc ecx'
					$l_s_OpCode = '41'
				Case 'inc ebx'
					$l_s_OpCode = '43'
				Case 'inc edx'
					$l_s_OpCode = '42'
				Case 'dec edx'
					$l_s_OpCode = '4A'
				Case 'test eax,eax'
					$l_s_OpCode = '85C0'
				Case 'test ebx,ebx'
					$l_s_OpCode = '85DB'
				Case 'test ecx,ecx'
					$l_s_OpCode = '85C9'
				Case 'test dx,dx'
					$l_s_OpCode = '6685D2'
				Case 'test al,al'
					$l_s_OpCode = '84C0'
				Case 'test esi,esi'
					$l_s_OpCode = '85F6'
				Case 'test al,1'
					$l_s_OpCode = 'A801'
				Case 'test edx,edx'
					$l_s_OpCode = '85D2'
				Case 'test ebx,40001'
					$l_s_OpCode = 'F7C301000400'
				Case 'test ebx,1'
					$l_s_OpCode = 'F7C301000000'
				Case 'test ebx,40000'
				   $l_s_OpCode = 'F7C300000400'
				Case 'test ebx,40001'
				   $l_s_OpCode = 'F7C301000400'
				Case 'test eax,1DA'
					$l_s_OpCode = 'A9DA010000'
				Case 'xor eax,eax'
					$l_s_OpCode = '33C0'
				Case 'xor ecx,ecx'
					$l_s_OpCode = '33C9'
				Case 'xor edx,edx'
					$l_s_OpCode = '33D2'
				Case 'xor ebx,ebx'
					$l_s_OpCode = '33DB'
				Case 'sub esp,8'
					$l_s_OpCode = '83EC08'
				Case 'sub esi,4'
					$l_s_OpCode = '83EE04'
				Case 'sub esp,14'
					$l_s_OpCode = '83EC14'
				Case 'sub eax,C'
					$l_s_OpCode = '83E80C'
				Case 'sub esp,16'
					$l_s_OpCode = '83EC10'
				Case 'sub esp,12'
					$l_s_OpCode = '83EC0C'
				Case 'lea eax,dword[eax+18]'
					$l_s_OpCode = '8D4018'
				Case 'lea ecx,dword[eax+4]'
					$l_s_OpCode = '8D4804'
				Case 'lea ecx,dword[eax+C]'
					$l_s_OpCode = '8D480C'
				Case 'lea eax,dword[eax+4]'
					$l_s_OpCode = '8D4004'
				Case 'lea edx,dword[eax]'
					$l_s_OpCode = '8D10'
				Case 'lea edx,dword[eax+4]'
					$l_s_OpCode = '8D5004'
				Case 'lea edx,dword[eax+8]'
					$l_s_OpCode = '8D5008'
				Case 'lea ecx,dword[eax+180]'
					$l_s_OpCode = '8D8880010000'
				Case 'lea edi,dword[edx+ebx]'
					$l_s_OpCode = '8D3C1A'
				Case 'lea edi,dword[edx+8]'
					$l_s_OpCode = '8D7A08'
				Case 'lea esi,dword[esi+ebx*4]'
					$l_s_OpCode = '8D349E'
				Case 'lea ecx,dword[ecx+ecx*2]'
					$l_s_OpCode = '8D0C49'
				Case 'lea ecx,dword[ebx+ecx*4]'
					$l_s_OpCode = '8D0C8B'
				Case 'lea ecx,dword[ecx+18]'
					$l_s_OpCode = '8D4918'
				Case 'lea ecx,dword[ebx+18]'
					$l_s_OpCode = '8D4B18'
				Case 'shl eax,4'
					$l_s_OpCode = 'C1E004'
				Case 'shl eax,8'
					$l_s_OpCode = 'C1E008'
				Case 'shl eax,6'
					$l_s_OpCode = 'C1E006'
				Case 'shl eax,7'
					$l_s_OpCode = 'C1E007'
				Case 'shl eax,9'
					$l_s_OpCode = 'C1E009'
				Case 'shl ebx,8'
					$l_s_OpCode = 'C1E308'
				Case 'shl edx,16'
					$l_s_OpCode = 'C1E210'
				Case 'shl ebx,16'
					$l_s_OpCode = 'C1E310'
				Case 'shl esi,8'
					$l_s_OpCode = 'C1E608'
				Case 'add ebx,ecx'
					$l_s_OpCode = '03D9'
				Case 'add esi,D'
					$l_s_OpCode = '83C60D'
				Case 'add esi,12'
					$l_s_OpCode = '83C612'
				Case 'add edi,8'
					$l_s_OpCode = '83C708'
				Case 'add eax,ebx'
					$l_s_OpCode = '03C3'
				Case 'add ecx,edx'
					$l_s_OpCode = '03CA'
				Case 'add eax,esi'
					$l_s_OpCode = '03C6'
				Case 'add esp,16'
					$l_s_OpCode = '83C410'
				Case 'add esp,12'
					$l_s_OpCode = '83C40C'
				Case 'or eax,esi'
					$l_s_OpCode = '0BC6'
				Case 'or eax,edi'
					$l_s_OpCode = '0BC7'
				Case 'or ecx,ebx'
					$l_s_OpCode = '0BCB'
				Case 'or eax,ebx'
					$l_s_OpCode = '0BC3'
				Case 'and ecx,0xFFFF'
					$l_s_OpCode = '81E1FFFF0000'
				Case 'and eax,0xFFFF'
					$l_s_OpCode = '25FFFF0000'
				Case 'and eax,0xF'
					$l_s_OpCode = '83E00F'
				Case 'and eax,0xFF'
					$l_s_OpCode = '25FF000000'
				Case 'and eax,0xFFFF'
					$l_s_OpCode = '25FFFF0000'
				Case 'and ebx,0xF'
					$l_s_OpCode = '83E30F'
				Case 'and ecx,0xF'
					$l_s_OpCode = '83E10F'
				Case 'and edx,0xF'
					$l_s_OpCode = '83E20F'
				Case 'imul ebx,ebx,7C'
					$l_s_OpCode = '6BDB7C'
				Case 'imul eax,eax,7C'
					$l_s_OpCode = '6BC07C'
				Case 'cmp ecx,4'
					$l_s_OpCode = '83F904'
				Case 'cmp ecx,32'
					$l_s_OpCode = '83F932'
				Case 'cmp ecx,3C'
					$l_s_OpCode = '83F93C'
				Case 'cmp eax,2'
					$l_s_OpCode = '83F802'
				Case 'cmp eax,0'
					$l_s_OpCode = '83F800'
				Case 'cmp eax,B'
					$l_s_OpCode = '83F80B'
				Case 'cmp eax,200'
					$l_s_OpCode = '3D00020000'
				Case 'cmp word[edx],0'
					$l_s_OpCode = '66833A00'
				Case 'cmp eax,ebx'
					$l_s_OpCode = '3BC3'
				Case 'cmp eax,ecx'
					$l_s_OpCode = '3BC1'
				Case 'cmp edx,esi'
					$l_s_OpCode = '3BD6'
				Case 'cmp ecx,1050000'
					$l_s_OpCode = '81F900000501'
				Case 'cmp eax,-1'
					$l_s_OpCode = '83F8FF'
				Case 'cmp al,ah'
					$l_s_OpCode = '3AC4'
				Case 'cmp eax,1'
					$l_s_OpCode = '83F801'
				Case 'cmp ebx,edi'
					$l_s_OpCode = '3BDF'
				Case 'cmp eax,dword[esi+9C]'
					$l_s_OpCode = '3B869C000000'
				Case 'cmp al,f'
					$l_s_OpCode = '3C0F'
				Case 'cmp ah,00'
					$l_s_OpCode = '80FC00'
				Case 'cmp bl,AA'
					$l_s_OpCode = '80FBAA'
				Case 'cmp bl,B9'
					$l_s_OpCode = '80FBB9'
				Case 'cmp al,BA'
					$l_s_OpCode = '3CBA'
				Case 'cmp ebx,esi'
					$l_s_OpCode = '3BDE'
				Case 'cmp eax,1DA'
					$l_s_OpCode = '3DDA010000'
				Case 'mov ebx,dword[eax]'
					$l_s_OpCode = '8B18'
				Case 'mov ebx,dword[ecx]'
					$l_s_OpCode = '8B19'
				Case 'mov ecx,dword[ebx+ecx]'
					$l_s_OpCode = '8B0C0B'
				Case 'mov dword[eax],0'
					$l_s_OpCode = 'C70000000000'
				Case 'mov edi,edx'
					$l_s_OpCode = '8BFA'
				Case 'mov ecx,esi'
					$l_s_OpCode = '8BCE'
				Case 'mov ecx,edi'
					$l_s_OpCode = '8BCF'
				Case 'mov ecx,esp'
					$l_s_OpCode = '8BCC'
				Case 'mov edx,eax'
					$l_s_OpCode = '8BD0'
				Case 'mov edx,ecx'
					$l_s_OpCode = '8BD1'
				Case 'mov ebp,esp'
					$l_s_OpCode = '8BEC'
				Case 'mov ecx,edx'
					$l_s_OpCode = '8BCA'
				Case 'mov eax,ecx'
					$l_s_OpCode = '8BC1'
				Case 'mov ecx,dword[ebp+8]'
					$l_s_OpCode = '8B4D08'
				Case 'mov ecx,dword[esp+1F4]'
					$l_s_OpCode = '8B8C24F4010000'
				Case 'mov ecx,dword[edi+4]'
					$l_s_OpCode = '8B4F04'
				Case 'mov ecx,dword[edi+8]'
					$l_s_OpCode = '8B4F08'
				Case 'mov eax,dword[edi+4]'
					$l_s_OpCode = '8B4704'
				Case 'mov dword[eax+4],ecx'
					$l_s_OpCode = '894804'
				Case 'mov dword[eax+8],ebx'
					$l_s_OpCode = '895808'
				Case 'mov dword[eax+8],ecx'
					$l_s_OpCode = '894808'
				Case 'mov dword[eax+C],ecx'
					$l_s_OpCode = '89480C'
				Case 'mov dword[esi+10],eax'
					$l_s_OpCode = '894610'
				Case 'mov ecx,dword[edi]'
					$l_s_OpCode = '8B0F'
				Case 'mov dword[eax],ecx'
					$l_s_OpCode = '8908'
				Case 'mov dword[eax],ebx'
					$l_s_OpCode = '8918'
				Case 'mov edx,dword[eax+4]'
					$l_s_OpCode = '8B5004'
				Case 'mov edx,dword[eax+8]'
					$l_s_OpCode = '8B5008'
				Case 'mov edx,dword[eax+c]'
					$l_s_OpCode = '8B500C'
				Case 'mov edx,dword[esi+1c]'
					$l_s_OpCode = '8B561C'
				Case 'mov ecx,dword[eax+4]'
					$l_s_OpCode = '8B4804'
				Case 'mov esi,dword[eax+4]'
					$l_s_OpCode = '8B7004'
				Case 'mov esp,dword[eax+4]'
					$l_s_OpCode = '8B6004'
				Case 'mov ecx,dword[eax+8]'
					$l_s_OpCode = '8B4808'
				Case 'mov eax,dword[eax+8]'
					$l_s_OpCode = '8B4008'
				Case 'mov eax,dword[eax+C]'
					$l_s_OpCode = '8B400C'
				Case 'mov ebx,dword[eax+4]'
					$l_s_OpCode = '8B5804'
				Case 'mov ebx,dword[eax+8]'
					$l_s_OpCode = '8B5808'
				Case 'mov ebx,dword[eax+C]'
					$l_s_OpCode = '8B580C'
				Case 'mov ebx,dword[ecx+148]'
					$l_s_OpCode = '8B9948010000'
				Case 'mov ecx,dword[ebx+13C]'
					$l_s_OpCode = '8B9B3C010000'
				Case 'mov ebx,dword[ebx+F0]'
					$l_s_OpCode = '8B9BF0000000'
				Case 'mov ecx,dword[eax+C]'
					$l_s_OpCode = '8B480C'
				Case 'mov ecx,dword[eax+10]'
					$l_s_OpCode = '8B4810'
				Case 'mov eax,dword[eax+4]'
					$l_s_OpCode = '8B4004'
				Case 'mov esp,ebp'
					$l_s_OpCode = '8BE5'
				Case 'mov edi,eax'
					$l_s_OpCode = '8BF8'
				Case 'mov dx,word[ecx]'
					$l_s_OpCode = '668B11'
				Case 'mov dx,word[edx]'
					$l_s_OpCode = '668B12'
				Case 'mov word[eax],dx'
					$l_s_OpCode = '668910'
				Case 'mov eax,dword[esi+8]'
					$l_s_OpCode = '8B4608'
				Case 'mov ecx,dword[eax]'
					$l_s_OpCode = '8B08'
				Case 'mov ebx,edi'
					$l_s_OpCode = '8BDF'
				Case 'mov ebx,eax'
					$l_s_OpCode = '8BD8'
				Case 'mov eax,edi'
					$l_s_OpCode = '8BC7'
				Case 'mov al,byte[ebx]'
					$l_s_OpCode = '8A03'
				Case 'mov eax,dword[ecx]'
					$l_s_OpCode = '8B01'
				Case 'mov ebx,dword[ecx+14]'
					$l_s_OpCode = '8B5914'
				Case 'mov eax,dword[ebx+c]'
					$l_s_OpCode = '8B430C'
				Case 'mov ecx,eax'
					$l_s_OpCode = '8BC8'
				Case 'mov al,byte[ecx]'
					$l_s_OpCode = '8A01'
				Case 'mov ebx,dword[edx]'
					$l_s_OpCode = '8B1A'
				Case 'mov ah,byte[edi]'
					$l_s_OpCode = '8A27'
				Case 'mov dword[edx],0'
					$l_s_OpCode = 'C70200000000'
				Case 'mov dword[ebx],ecx'
					$l_s_OpCode = '890B'
				Case 'mov edi,dword[edx+4]'
					$l_s_OpCode = '8B7A04'
				Case 'mov edi,dword[eax+4]'
					$l_s_OpCode = '8B7804'
				Case 'mov ecx,dword[E1D684]'
					$l_s_OpCode = '8B0D84D6E100'
				Case 'mov dword[edx-0x70],ecx'
					$l_s_OpCode = '894A90'
				Case 'mov ecx,dword[edx+0x1C]'
					$l_s_OpCode = '8B4A1C'
				Case 'mov dword[edx+0x54],ecx'
					$l_s_OpCode = '894A54'
				Case 'mov ecx,dword[edx+4]'
					$l_s_OpCode = '8B4A04'
				Case 'mov dword[edx-0x14],ecx'
					$l_s_OpCode = '894AEC'
				Case 'mov dword[edx],ebx'
					$l_s_OpCode = '891A'
				Case 'mov dword[edi],ecx'
					$l_s_OpCode = '890F'
				Case 'mov dword[edx],-1'
					$l_s_OpCode = 'C702FFFFFFFF'
				Case 'mov eax,dword[ebp+37c]'
					$l_s_OpCode = '8B857C030000'
				Case 'mov eax,dword[ebp+338]'
					$l_s_OpCode = '8B8538030000'
				Case 'mov ecx,dword[ebx+250]'
					$l_s_OpCode = '8B8B50020000'
				Case 'mov ecx,dword[ebx+194]'
					$l_s_OpCode = '8B8B94010000'
				Case 'mov ecx,dword[ebx+18]'
					$l_s_OpCode = '8B5918'
				Case 'mov ecx,dword[ebx+40]'
					$l_s_OpCode = '8B5940'
				Case 'mov ebx,dword[ecx+10]'
					$l_s_OpCode = '8B5910'
				Case 'mov ebx,dword[ecx+18]'
					$l_s_OpCode = '8B5918'
				Case 'mov ebx,dword[ecx+4c]'
					$l_s_OpCode = '8B594C'
				Case 'mov ecx,dword[ebx]'
					$l_s_OpCode = '8B0B'
				Case 'mov edx,esp'
					$l_s_OpCode = '8BD4'
				Case 'mov ecx,dword[ebx+170]'
					$l_s_OpCode = '8B8B70010000'
				Case 'mov ebx,dword[ecx+20]'
					$l_s_OpCode = '8B5920'
				Case 'mov ecx,dword[ecx]'
					$l_s_OpCode = '8B09'
				Case 'mov eax,dword[ecx+40]'
					$l_s_OpCode = '8B4140'
				Case 'mov ecx,dword[ecx+4]'
					$l_s_OpCode = '8B4904'
				Case 'mov ecx,dword[ecx+8]'
					$l_s_OpCode = '8B4908'
				Case 'mov ecx,dword[ecx+34]'
					$l_s_OpCode = '8B4934'
				Case 'mov ecx,dword[ecx+C]'
					$l_s_OpCode = '8B490C'
				Case 'mov ecx,dword[ecx+10]'
					$l_s_OpCode = '8B4910'
				Case 'mov ecx,dword[ecx+18]'
					$l_s_OpCode = '8B4918'
				Case 'mov ecx,dword[ecx+20]'
					$l_s_OpCode = '8B4920'
				Case 'mov ecx,dword[ecx+4c]'
					$l_s_OpCode = '8B494C'
				Case 'mov ecx,dword[ecx+50]'
					$l_s_OpCode = '8B4950'
				Case 'mov ecx,dword[ecx+148]'
					$l_s_OpCode = '8B8948010000'
				Case 'mov ecx,dword[ecx+170]'
					$l_s_OpCode = '8B8970010000'
				Case 'mov ecx,dword[ecx+194]'
					$l_s_OpCode = '8B8994010000'
				Case 'mov ecx,dword[ecx+250]'
					$l_s_OpCode = '8B8950020000'
				Case 'mov ecx,dword[ecx+134]'
					$l_s_OpCode = '8B8934010000'
				Case 'mov ecx,dword[ecx+13C]'
					$l_s_OpCode = '8B893C010000'
				Case 'mov al,byte[ecx+4f]'
					$l_s_OpCode = '8A414F'
				Case 'mov al,byte[ecx+3f]'
					$l_s_OpCode = '8A413F'
				Case 'mov esi,dword[esi]'
					$l_s_OpCode = '8B36'
				Case 'mov eax,dword[ebp+8]'
					$l_s_OpCode = '8B4508'
				Case 'mov eax,dword[ecx+8]'
					$l_s_OpCode = '8B4108'
				Case 'mov eax,[eax+2C]'
					$l_s_OpCode = '8B402C'
				Case 'mov eax,[eax+680]'
					$l_s_OpCode = '8B8080060000'
				Case 'mov esi,eax'
					$l_s_OpCode = '8BF0'
				Case 'mov edx,dword[ecx]'
					$l_s_OpCode = '8B11'
				Case 'mov dword[eax],edx'
					$l_s_OpCode = '8910'
				Case 'mov dword[eax],F'
					$l_s_OpCode = 'C7000F000000'
				Case 'mov ebx,[ebx+0]'
					$l_s_OpCode = '8B1B'
				Case 'mov ebx,[ebx+AC]'
					$l_s_OpCode = '8B9BAC000000'
				Case 'mov ebx,[ebx+C]'
					$l_s_OpCode = '8B5B0C'
				Case 'mov eax,dword[ebx+28]'
					$l_s_OpCode = '8B4328'
				Case 'mov eax,[eax]'
					$l_s_OpCode = '8B00'
				Case 'mov eax,[eax+4]'
					$l_s_OpCode = '8B4004'
				Case 'mov ebx,dword[ebp+C]'
					$l_s_OpCode = '8B5D0C'
				Case 'mov ecx,dword[ecx+edx]'
					$l_s_OpCode = '8B0C11'
				Case 'mov dword[eax],edi'
					$l_s_OpCode = '8938'
				Case 'mov [eax+8],ecx'
					$l_s_OpCode = '894808'
				Case 'mov [eax+C],ecx'
					$l_s_OpCode = '89480C'
				Case 'mov ebx,dword[ecx-C]'
					$l_s_OpCode = '8B59F4'
				Case 'mov [eax+C],ebx'
					$l_s_OpCode = '89580C'
				Case 'mov ecx,[eax+8]'
					$l_s_OpCode = '8B4808'
				Case 'mov ebx,dword[ebx+18]'
					$l_s_OpCode = '8B5B18'
				Case 'mov ecx,dword[ecx+0xF4]'
					$l_s_OpCode = '8B89F4000000'
				Case 'mov eax,edx'
					$l_s_OpCode = '8BC2'
				Case 'mov esi,edx'
					$l_s_OpCode = '8BF2'
				Case 'mov bl,byte[eax]'
					$l_s_OpCode = '8A18'
				Case 'mov bl,byte[ecx+5]'
					$l_s_OpCode = '8A5905'
				Case 'mov ebx,dword[ecx+1]'
					$l_s_OpCode = '8B5901'
				Case 'mov ebx,dword[ecx+6]'
					$l_s_OpCode = '8B5906'
				Case 'mov edi,dword[esi]'
					$l_s_OpCode = '8B3E'
				Case 'mov ecx,dword[eax+14]'
					$l_s_OpCode = '8B4814'
				Case 'mov edx,dword[eax+14]'
					$l_s_OpCode = '8B5014'
				Case 'mov edx,dword[eax+18]'
					$l_s_OpCode = '8B5018'
				Case 'mov edi,ecx'
					$l_s_OpCode = '8BF9'
				Case 'mov edi,ebx'
					$l_s_OpCode = '8BFB'
				Case 'mov esi,ecx'
					$l_s_OpCode = '8BF1'
				Case 'mov esi,ebx'
					$l_s_OpCode = '8BF3'
				Case 'mov edi,esi'
					$l_s_OpCode = '8BFE'
				Case 'mov ebx,ecx'
					$l_s_OpCode = '8BD9'
				Case 'mov eax,ebx'
					$l_s_OpCode = '8BC3'
				Case 'mov eax,esi'
					$l_s_OpCode = '8BC6'
				Case 'mov ecx,ebx'
					$l_s_OpCode = '8BCB'
				Case 'mov ebx,edx'
					$l_s_OpCode = '8BDA'
				Case 'mov esi,edx'
					$l_s_OpCode = '8BF2'
				Case 'mov ebx,esi'
					$l_s_OpCode = '8BDE'
				Case 'mov edx,ebx'
					$l_s_OpCode = '8BD3'
				Case 'mov edx,esi'
					$l_s_OpCode = '8BD6'
				Case 'mov edx,edi'
					$l_s_OpCode = '8BD7'
				Case 'mov ecx,edx'
					$l_s_OpCode = '8BCA'
				Case 'mov esi,edi'
					$l_s_OpCode = '8BF7'
				Case 'mov ebp,eax'
					$l_s_OpCode = '8BE8'
				Case 'mov ebp,ebx'
					$l_s_OpCode = '8BEB'
				Case 'mov ebp,ecx'
					$l_s_OpCode = '8BE9'
				Case 'mov ebp,edx'
					$l_s_OpCode = '8BEA'
				Case 'mov esp,eax'
					$l_s_OpCode = '8BE0'
				Case 'mov esp,ecx'
					$l_s_OpCode = '8BE1'
				Case 'mov esp,edx'
					$l_s_OpCode = '8BE2'
				Case 'mov esp,ebx'
					$l_s_OpCode = '8BE3'
				Case 'mov esi,dword[ebp+8]'
					$l_s_OpCode = '8B7508'
				Case 'mov esi,dword[ebp+C]'
					$l_s_OpCode = '8B750C'
				Case 'mov esi,dword[ebp+10]'
					$l_s_OpCode = '8B7510'
				Case 'mov edi,dword[ebp+8]'
					$l_s_OpCode = '8B7D08'
				Case 'mov edi,dword[ebp+C]'
					$l_s_OpCode = '8B7D0C'
				Case 'mov ebx,dword[ebp+8]'
					$l_s_OpCode = '8B5D08'
				Case 'mov edx,dword[ebp+8]'
					$l_s_OpCode = '8B5508'
				Case 'mov edx,dword[ebp+C]'
					$l_s_OpCode = '8B550C'
				Case 'mov dword[eax+C],0'
					$l_s_OpCode = 'C7400C00000000'
				Case 'mov dword[eax+4],edx'
					$l_s_OpCode = '895004'
				Case 'mov dword[eax+4],ebx'
					$l_s_OpCode = '895804'
				Case 'mov dword[eax+8],edx'
					$l_s_OpCode = '895008'
				Case 'mov dword[eax+C],edx'
					$l_s_OpCode = '89500C'
				Case 'mov dword[eax+C],0'
					$l_s_OpCode = 'C7400C00000000'
				Case 'mov dword[eax+C],1'
					$l_s_OpCode = 'C7400C01000000'
				Case 'mov edx,dword[ebp+C]'
					$l_s_OpCode = '8B550C'
				Case 'mov ebx,dword[ebp+10]'
					$l_s_OpCode = '8B5D10'
				Case 'mov edx,dword[ebp+10]'
					$l_s_OpCode = '8B5510'
				Case 'mov esi,ebp'
					$l_s_OpCode = '8BF5'
				Case 'mov ecx,dword[esi]'
					$l_s_OpCode = '8B0E'
				Case 'mov ecx,dword[ebp+C]'
					$l_s_OpCode = '8B4D0C'
				Case 'mov ecx,dword[ebp+10]'
					$l_s_OpCode = '8B4D10'
				Case 'mov edx,dword[esi]'
					$l_s_OpCode = '8B16'
				Case 'mov edx,dword[edi]'
					$l_s_OpCode = '8B17'
				Case 'mov eax,dword[esi]'
					$l_s_OpCode = '8B06'
				Case 'mov eax,dword[edi]'
					$l_s_OpCode = '8B07'
				Case 'mov ebx,dword[esi]'
					$l_s_OpCode = '8B1E'
				Case 'mov ebx,dword[edi]'
					$l_s_OpCode = '8B1F'
				Case 'mov eax,dword[eax]'
					$l_s_OpCode = '8B00'
				Case 'mov eax,dword[eax+18]'
					$l_s_OpCode = '8B4018'
				Case 'mov eax,dword[eax+44]'
					$l_s_OpCode = '8B4044'
				Case 'mov eax,dword[eax+198]'
					$l_s_OpCode = '8B8098010000'
				Case 'mov ebx,dword[ebx+10]'
					$l_s_OpCode = '8B5B10'
				Case 'mov ebx,dword[eax+10]'
					$l_s_OpCode = '8B5810'
				Case 'mov ebx,dword[eax+19C]'
					$l_s_OpCode = '8B989C010000'
				Case 'movzx ecx,di'
					$l_s_OpCode = '0FB7CF'
				Case 'movzx eax,di'
					$l_s_OpCode = '0FB7C7'
				Case 'movzx ecx,cx'
					$l_s_OpCode = '0FB7C9'
				; SellItem
				Case 'mov ecx,[eax]'
					$l_s_OpCode = '8B08'
				; Crafting
				Case 'lea edi,[eax+C]'
					$l_s_OpCode = '8D780C'
				;Collector Exchange
				Case 'lea ecx,[edx+4]'
					$l_s_OpCode = '8D4A04'
				Case 'lea eax,[edx+C]'
					$l_s_OpCode = '8D420C'
				Case 'mov ebx,[edx+8]'
					$l_s_OpCode = '8B5A08'
				Case 'lea ecx,[edx+ebx*4+C]'
					$l_s_OpCode = '8D4C9A0C'

				Case Else
					Log_Error('Could not assemble: ' & $a_s_ASM, 'ASM', $g_h_EditText)
					MsgBox(0x0, 'ASM', 'Could not assemble: ' & $a_s_ASM)
					Exit
			EndSwitch
			$g_i_ASMSize += 0.5 * StringLen($l_s_OpCode)
			$g_s_ASMCode &= $l_s_OpCode
	EndSelect
EndFunc

Func Assembler_CompleteASMCode()
	Local $l_b_InExpression = False
	Local $l_s_Expression
	Local $l_s_TempASM = $g_s_ASMCode
	Local $l_i_CurrentOffset = Dec(Hex($g_p_ASMMemory)) + $g_i_ASMCodeOffset
	Local $l_s_Token
	For $l_i_Idx = 1 To $g_amx2_Labels[0][0]
		If StringLeft($g_amx2_Labels[$l_i_Idx][0], 6) = 'Label_' Then
			$g_amx2_Labels[$l_i_Idx][0] = StringTrimLeft($g_amx2_Labels[$l_i_Idx][0], 6)
			$g_amx2_Labels[$l_i_Idx][1] = $g_p_ASMMemory + $g_amx2_Labels[$l_i_Idx][1]
		EndIf
	Next
	$g_s_ASMCode = ''
	For $l_i_Idx = 1 To StringLen($l_s_TempASM)
		$l_s_Token = StringMid($l_s_TempASM, $l_i_Idx, 1)
		Switch $l_s_Token
			Case '(', '[', '{'
				$l_b_InExpression = True
			Case ')'
				$g_s_ASMCode &= Hex(Memory_GetLabelInfo($l_s_Expression) - Int($l_i_CurrentOffset) - 1, 2)
				$l_i_CurrentOffset += 1
				$l_b_InExpression = False
				$l_s_Expression = ''
			Case ']'
				$g_s_ASMCode &= Utils_SwapEndian(Hex(Memory_GetLabelInfo($l_s_Expression), 8))
				$l_i_CurrentOffset += 4
				$l_b_InExpression = False
				$l_s_Expression = ''
			Case '}'
				$g_s_ASMCode &= Utils_SwapEndian(Hex(Memory_GetLabelInfo($l_s_Expression) - Int($l_i_CurrentOffset) - 4, 8))
				$l_i_CurrentOffset += 4
				$l_b_InExpression = False
				$l_s_Expression = ''
			Case Else
				If $l_b_InExpression Then
					$l_s_Expression &= $l_s_Token
				Else
					$g_s_ASMCode &= $l_s_Token
					$l_i_CurrentOffset += 0.5
				EndIf
		EndSwitch
	Next
EndFunc

;~ Func old_Assembler_ASMNumber($a_v_Number, $a_b_Small = False)
;~ 	If $a_v_Number >= 0 Then
;~ 		$a_v_Number = Dec($a_v_Number)
;~ 	EndIf
;~ 	If $a_b_Small And $a_v_Number <= 127 And $a_v_Number >= -128 Then
;~ 		Return SetExtended(1, Hex($a_v_Number, 2))
;~ 	Else
;~ 		Return SetExtended(0, Utils_SwapEndian(Hex($a_v_Number, 8)))
;~ 	EndIf
;~ EndFunc

Func Assembler_ASMNumber($a_v_Number, $a_b_Small = False)
    Local $l_i_Value

    If IsNumber($a_v_Number) Then
        $l_i_Value = $a_v_Number
    Else
        $l_i_Value = _ParseValue($a_v_Number)
    EndIf

    If $a_b_Small And $l_i_Value <= 127 And $l_i_Value >= -128 Then
        If $l_i_Value < 0 Then
            Return SetExtended(1, Hex(256 + $l_i_Value, 2))
        Else
            Return SetExtended(1, Hex($l_i_Value, 2))
        EndIf
    Else
        If $l_i_Value < 0 Then
            Return SetExtended(0, Utils_SwapEndian(Hex(0x100000000 + $l_i_Value, 8)))
        Else
            Return SetExtended(0, Utils_SwapEndian(Hex($l_i_Value, 8)))
        EndIf
    EndIf
EndFunc

Func Assembler_CreateScanProcedure($a_p_GwBase)
    _('ScanProc:')
    _('pushad')
    _('mov ecx,' & Hex($a_p_GwBase, 8))
    _('mov esi,ScanProc')
    _('ScanLoop:')
    _('inc ecx')
    _('mov al,byte[ecx]')
    _('mov edx,' & $g_amx2_Patterns[1][0])

    _('ScanInnerLoop:')
    _('mov ebx,dword[edx]')
    _('cmp ebx,-1')
    _('jnz ScanContinue')
    _('add edx,50')
    _('cmp edx,esi')
    _('jnz ScanInnerLoop')
    _('cmp ecx,' & Utils_SwapEndian(Hex($a_p_GwBase + 5238784, 8)))
    _('jnz ScanLoop')
    _('jmp ScanExit')

    _('ScanContinue:')
    _('lea edi,dword[edx+ebx]')
    _('add edi,C')
    _('mov ah,byte[edi]')
    _('cmp al,ah')
    _('jz ScanMatched')
    _('cmp ah,00')
    _('jz ScanMatched')
    _('mov dword[edx],0')
    _('add edx,50')
    _('cmp edx,esi')
    _('jnz ScanInnerLoop')
    _('cmp ecx,' & Utils_SwapEndian(Hex($a_p_GwBase + 5238784, 8)))
    _('jnz ScanLoop')
    _('jmp ScanExit')

    _('ScanMatched:')
    _('inc ebx')
    _('mov edi,dword[edx+4]')
    _('cmp ebx,edi')
    _('jz ScanFound')
    _('mov dword[edx],ebx')
    _('add edx,50')
    _('cmp edx,esi')
    _('jnz ScanInnerLoop')
    _('cmp ecx,' & Utils_SwapEndian(Hex($a_p_GwBase + 5238784, 8)))
    _('jnz ScanLoop')
    _('jmp ScanExit')

    _('ScanFound:')
    _('lea edi,dword[edx+8]')
    _('mov dword[edi],ecx')
    _('mov dword[edx],-1')
    _('add edx,50')
    _('cmp edx,esi')
    _('jnz ScanInnerLoop')
    _('cmp ecx,' & Utils_SwapEndian(Hex($a_p_GwBase + 5238784, 8)))
    _('jnz ScanLoop')

    _('ScanExit:')
    _('popad')
    _('retn')
EndFunc

Func Assembler_ModifyMemory()
	$g_i_ASMSize = 0
	$g_i_ASMCodeOffset= 0
	$g_s_ASMCode = ''
	Assembler_CreateData()
	Assembler_CreateMain()
	Assembler_CreateRenderingMod()
	Assembler_CreateCommands()
	Assembler_CreateSkillCommands()
	Assembler_CreateFriendCommands()
	Assembler_CreateAttributeCommands()
	Assembler_CreateTrader()
	Assembler_CreateSellItemCommand()
	Assembler_CreateBuyItemCommand()
	Assembler_CreateRequestQuoteCommand()
	Assembler_CreateRequestQuoteSellCommand()
	Assembler_CreateTraderBuyCommand()
	Assembler_CreateTraderSellCommand()
	Assembler_CreateCraftItemCommand()
	Assembler_CreateCollectorExchangeCommand()
	Assembler_CreateSalvageCommand()
	Assembler_CreateAgentCommands()
	Assembler_CreateMapCommands()
	Assembler_CreateUICommands()
	If IsDeclared("g_b_Assembler") Then Extend_Assembler()
	$g_p_ASMMemory = Memory_Read(Memory_Read($g_p_GWBaseAddress), 'ptr')

	Switch $g_p_ASMMemory
		Case 0
			$g_p_ASMMemory = DllCall($g_h_Kernel32, 'ptr', 'VirtualAllocEx', 'handle', $g_h_GWProcess, 'ptr', 0, 'ulong_ptr', $g_i_ASMSize, 'dword', 0x1000, 'dword', 64)
			$g_p_ASMMemory = $g_p_ASMMemory[0]
			Memory_Write(Memory_Read($g_p_GWBaseAddress), $g_p_ASMMemory)
			Assembler_CompleteASMCode()
			Memory_WriteBinary($g_s_ASMCode, $g_p_ASMMemory + $g_i_ASMCodeOffset)
			$g_p_SecondInjection = $g_p_ASMMemory + $g_i_ASMCodeOffset
			Memory_Write(Memory_GetValue('QueuePtr'), Memory_GetValue('QueueBase'))
			If IsDeclared("g_b_Write") Then Extend_Write()
		Case Else
			Assembler_CompleteASMCode()
	EndSwitch
	Memory_WriteDetour('MainStart', 'MainProc')
	Memory_WriteDetour('TraderStart', 'TraderProc')
	Memory_WriteDetour('RenderingMod', 'RenderingModProc')
EndFunc

Func Assembler_CreateData()
    _('QueueCounter/4')
    _('TraderQuoteID/4')
    _('TraderCostID/4')
    _('TraderCostValue/4')
    _('DisableRendering/4')
	_('AgentCopyCount/4')

	If IsDeclared("g_b_AssemblerData") Then Extend_AssemblerData()

    _('QueueBase/' & 256 * Memory_GetValue('QueueSize'))
    _('AgentCopyBase/' & 0x1C0 * 256)
EndFunc

Func Assembler_CreateMain()
    _('MainProc:')
    _('pushad')
    _('push eax')
    _('push ebx')

    _('mov eax,dword[BasePointer]')
    _('test eax,eax')
    _('jz RegularFlow')
    _('mov eax,dword[eax]')
    _('test eax,eax')
    _('jz RegularFlow')
    _('mov eax,dword[eax+18]')
    _('test eax,eax')
    _('jz RegularFlow')
    _('mov eax,dword[eax+44]')
    _('test eax,eax')
    _('jz RegularFlow')
    _('mov ebx,dword[eax+19C]')
    _('test ebx,ebx')
    _('jz RegularFlow')
    _('mov eax,dword[eax+198]')
    _('cmp eax,0')
    _('je HandleCase')
    _('mov ebx,eax')
    _('imul ebx,ebx,7C')
    _('add ebx,dword[Environment]')
    _('test ebx,ebx')
    _('jz RegularFlow')
    _('mov ebx,dword[ebx+10]')
    _('test ebx,40001')
    _('jz RegularFlow')

    _('HandleCase:')
    _('pop ebx')
    _('pop eax')
    _('mov eax,dword[QueueCounter]')
    _('mov ecx,eax')
    _('shl eax,8')
    _('add eax,QueueBase')
    _('mov ebx,dword[eax]')
    _('test ebx,ebx')
    _('jz MainExit')
    _('mov dword[eax],0')
    _('mov eax,ecx')
    _('inc eax')
    _('cmp eax,QueueSize')
    _('jnz SubSkipReset')
    _('xor eax,eax')
    _('SubSkipReset:')
    _('mov dword[QueueCounter],eax')
    _('jmp MainExit')

    _('RegularFlow:')
    _('pop ebx')
    _('pop eax')
    _('mov eax,dword[QueueCounter]')
    _('mov ecx,eax')
    _('shl eax,8')
    _('add eax,QueueBase')
    _('mov ebx,dword[eax]')
    _('test ebx,ebx')
    _('jz MainExit')
    _('push ecx')
    _('mov dword[eax],0')
    _('jmp ebx')

    _('CommandReturn:')
    _('pop eax')
    _('inc eax')
    _('cmp eax,QueueSize')
    _('jnz MainSkipReset')
    _('xor eax,eax')
    _('MainSkipReset:')
    _('mov dword[QueueCounter],eax')

    _('MainExit:')
    _('popad')
    _('mov ebp,esp')
    _('fld st(0),dword[ebp+8]')
    _('ljmp MainReturn')
EndFunc

Func Assembler_CreateTrader()
	_('TraderProc:')
	_('push eax')
	_('mov eax,dword[ebx+28] -> 8b 43 28')
	_('mov eax,[eax] -> 8b 00')
	_('mov dword[TraderCostID],eax')
	_('mov eax,dword[ebx+28] -> 8b 43 28')
	_('mov eax,[eax+4] -> 8b 40 04')
	_('mov dword[TraderCostValue],eax')
	_('pop eax')
	_('mov ebx,dword[ebp+C] -> 8B 5D 0C')
	_('mov esi,eax')
	_('push eax')
	_('mov eax,dword[TraderQuoteID]')
	_('inc eax')
	_('cmp eax,200')
	_('jnz TraderSkipReset')
	_('xor eax,eax')
	_('TraderSkipReset:')
	_('mov dword[TraderQuoteID],eax')
	_('pop eax')
	_('ljmp TraderReturn')
EndFunc

Func Assembler_CreateRenderingMod()
	_('RenderingModProc:')
	_('add esp,4')
	_('cmp dword[DisableRendering],1')
	_('ljmp RenderingModReturn')
EndFunc

Func Assembler_CreateCommands()
	_('CommandPacketSend:')
	_('lea edx,dword[eax+8]')
	_('push edx')
	_('mov ebx,dword[eax+4]')
	_('push ebx')
	_('mov eax,dword[PacketLocation]')
	_('push eax')
	_('call PacketSend')
	_('pop eax')
	_('pop ebx')
	_('pop edx')
	_('ljmp CommandReturn')

	_('CommandAction:')
	_('mov ecx,dword[ActionBase]')
	_('mov ecx,dword[ecx+c]')
	_('add ecx,A0')
	_('push 0')
	_('add eax,4')
	_('push eax')
	_('push dword[eax+4]')
	_('mov edx,0')
	_('call Action')
	_('ljmp CommandReturn')

	_('CommandSendChat:')
	_('lea edx,dword[eax+4]')
	_('push edx')
	_('mov ebx,11c')
	_('push ebx')
	_('mov eax,dword[PacketLocation]')
	_('push eax')
	_('call PacketSend')
	_('pop eax')
	_('pop ebx')
	_('pop edx')
	_('ljmp CommandReturn')
EndFunc

Func Assembler_CreateSkillCommands()
	_('CommandUseSkill:')
	_('mov ecx,dword[eax+10]')
	_('push ecx')
	_('mov ebx,dword[eax+C]')
	_('push ebx')
	_('mov edx,dword[eax+8]')
	_('push edx')
	_('mov ecx,dword[eax+4]')
	_('push ecx')
	_('call UseSkill')
	_('add esp,10')
	_('ljmp CommandReturn')

	_('CommandUseHeroSkill:')
    _('mov ecx,dword[eax+8]')
    _('push ecx')
    _('mov ecx,dword[eax+c]')
    _('push ecx')
    _('mov ecx,dword[eax+4]')
    _('push ecx')
    _('call UseHeroSkill')
    _('add esp,C')
    _('ljmp CommandReturn')
EndFunc

Func Assembler_CreateFriendCommands()
    _('CommandPlayerStatus:')
    _('mov eax,dword[eax+4]')
    _('push eax')
    _('call PlayerStatus')
    _('pop eax')
    _('ljmp CommandReturn')

    _('CommandAddFriend:')
    _('mov ecx,dword[eax+C]')
    _('push ecx')
    _('mov edx,dword[eax+8]')
    _('push edx')
    _('mov ecx,dword[eax+4]')
    _('push ecx')
    _('call AddFriend')
    _('add esp,C')
    _('ljmp CommandReturn')

    _('CommandRemoveFriend:')
    _('mov ecx,dword[eax+18]')
    _('push ecx')
    _('mov edx,dword[eax+14]')
    _('push edx')
    _('lea ecx,dword[eax+4]')
    _('push ecx')
    _('call RemoveFriend')
    _('add esp,C')
    _('ljmp CommandReturn')
EndFunc

Func Assembler_CreateAttributeCommands()
    _('CommandIncreaseAttribute:')
    _('mov edx,dword[eax+4]')
    _('push edx')
    _('mov ecx,dword[eax+8]')
    _('push ecx')
    _('call IncreaseAttribute')
    _('add esp,8')
    _('ljmp CommandReturn')

	_('CommandDecreaseAttribute:')
    _('mov edx,dword[eax+4]')
    _('push edx')
    _('mov ecx,dword[eax+8]')
    _('push ecx')
    _('call DecreaseAttribute')
    _('add esp,8')
    _('ljmp CommandReturn')
EndFunc

Func Assembler_CreateSellItemCommand()
    _('CommandSellItem:')
    _('push 0')
    _('push 0')
    _('push 0')
    _('push dword[eax+C]')
    _('add eax,4')
    _('mov ecx,[eax]')
    _('test ecx,ecx')
    _('jz SellItemAll')
    _('push eax')
    _('jmp SellItemContinue')
	_('SellItemAll:')
    _('push 0')
	_('SellItemContinue:')
    _('add eax,4')
    _('push eax')
    _('push 1')
    _('push 0')
    _('push B')
    _('call Transaction')
    _('add esp,24')
    _('ljmp CommandReturn')
EndFunc

Func Assembler_CreateBuyItemCommand()
    _('CommandBuyItem:')
    _('mov esi,eax')
    _('add esi,10')
    _('mov ecx,eax')
    _('add ecx,4')
    _('push ecx')
    _('mov edx,eax')
    _('add edx,8')
    _('push edx')
    _('push 1')
    _('push 0')
    _('push 0')
    _('push 0')
    _('push 0')
    _('mov eax,dword[eax+C]')
    _('push eax')
    _('push 1')
    _('call Transaction')
    _('add esp,24')
    _('ljmp CommandReturn')
EndFunc

Func Assembler_CreateCraftItemCommand()
	_('CommandCraftItem:')
	_('add eax,4')
	_('push eax')
	_('add eax,4')
	_('push eax')
	_('push 1')
	_('push 0')
	_('push 0')
	_('lea edi,[eax+C]')
	_('push edi')
	_('push dword[eax+8]')
	_('push dword[eax+4]')
	_('push 3')
	_('call Transaction')
	_('add esp,24')
	_('mov dword[TraderCostID],0')
	_('ljmp CommandReturn')
EndFunc

Func Assembler_CreateCollectorExchangeCommand()
	_('CommandCollectorExchange:')
	_('mov edx,eax')
	_('push 0')
	_('lea ecx,[edx+4]')
	_('push ecx')
	_('push 1')
	_('push 0')
	_('lea eax,[edx+C]')
	_('push eax')
	_('mov ebx,[edx+8]')
	_('lea ecx,[edx+ebx*4+C]')
	_('push ecx')
	_('push ebx')
	_('push 0')
	_('push 2')
	_('call Transaction')
	_('add esp,24')
	_('ljmp CommandReturn')
EndFunc

Func Assembler_CreateRequestQuoteCommand()
    _('CommandRequestQuote:')
    _('mov dword[TraderCostID],0')
    _('mov dword[TraderCostValue],0')
    _('mov esi,eax')
    _('add esi,4')
    _('push esi')
    _('push 1')
    _('push 0')
    _('push 0')
    _('push 0')
    _('push 0')
    _('push 0')
    _('push C')
    _('mov ecx,0')
    _('mov edx,2')
    _('call RequestQuote')
    _('add esp,20')
    _('ljmp CommandReturn')
EndFunc

Func Assembler_CreateRequestQuoteSellCommand()
    _('CommandRequestQuoteSell:')
    _('mov dword[TraderCostID],0')
    _('mov dword[TraderCostValue],0')
    _('push 0')
    _('push 0')
    _('push 0')
    _('add eax,4')
    _('push eax')
    _('push 1')
    _('push 0')
    _('push 0')
    _('push D')
    _('xor edx,edx')
    _('call RequestQuote')
    _('add esp,20')
    _('ljmp CommandReturn')
EndFunc

Func Assembler_CreateTraderBuyCommand()
    _('CommandTraderBuy:')
    _('push 0')
    _('push TraderCostID')
    _('push 1')
    _('push 0')
    _('push 0')
    _('push 0')
    _('push 0')
    _('mov edx,dword[TraderCostValue]')
    _('push edx')
    _('push C')
    _('mov ecx,C')
    _('call Transaction')
    _('add esp,24')
    _('mov dword[TraderCostID],0')
    _('mov dword[TraderCostValue],0')
    _('ljmp CommandReturn')
EndFunc

Func Assembler_CreateTraderSellCommand()
    _('CommandTraderSell:')
    _('push 0')
    _('push 0')
    _('push 0')
    _('push dword[TraderCostValue]')
    _('push 0')
    _('push TraderCostID')
    _('push 1')
    _('push 0')
    _('push D')
    _('mov ecx,d')
    _('xor edx,edx')
    _('call Transaction')
    _('add esp,24')
    _('mov dword[TraderCostID],0')
    _('mov dword[TraderCostValue],0')
    _('ljmp CommandReturn')
EndFunc

Func Assembler_CreateSalvageCommand()
    _('CommandSalvage:')
    _('push eax')
    _('push ecx')
    _('push ebx')
    _('mov ebx,SalvageGlobal')
    _('mov ecx,dword[eax+4]')
    _('mov dword[ebx],ecx')
    _('add ebx,4')
    _('mov ecx,dword[eax+8]')
    _('mov dword[ebx],ecx')
    _('mov ebx,dword[eax+4]')
    _('push ebx')
    _('mov ebx,dword[eax+8]')
    _('push ebx')
    _('mov ebx,dword[eax+c]')
    _('push ebx')
    _('call Salvage')
    _('add esp,C')
    _('pop ebx')
    _('pop ecx')
    _('pop eax')
    _('ljmp CommandReturn')
EndFunc

Func Assembler_CreateAgentCommands()
	_('CommandChangeTarget:')
	_('xor edx,edx')
	_('push edx')
	_('mov eax,dword[eax+4]')
	_('push eax')
	_('call ChangeTarget')
	_('add esp,8')
	_('ljmp CommandReturn')

	_('CommandMakeAgentArray:')
	_('mov eax,dword[eax+4]')
	_('xor ebx,ebx')
	_('xor edx,edx')
	_('mov edi,AgentCopyBase')
	_('AgentCopyLoopStart:')
	_('inc ebx')
	_('cmp ebx,dword[MaxAgents]')
	_('jge AgentCopyLoopExit')
	_('mov esi,dword[AgentBase]')
	_('lea esi,dword[esi+ebx*4]')
	_('mov esi,dword[esi]')
	_('test esi,esi')
	_('jz AgentCopyLoopStart')
	_('cmp eax,0')
	_('jz CopyAgent')
	_('cmp eax,dword[esi+9C]')
	_('jnz AgentCopyLoopStart')
	_('CopyAgent:')
	_('mov ecx,1C0')
	_('clc')
	_('repe movsb')
	_('inc edx')
	_('jmp AgentCopyLoopStart')
	_('AgentCopyLoopExit:')
	_('mov dword[AgentCopyCount],edx')
	_('ljmp CommandReturn')
EndFunc

Func Assembler_CreateMapCommands()
	_('CommandMove:')
	_('lea eax,dword[eax+4]')
	_('push eax')
	_('call Move')
	_('pop eax')
	_('ljmp CommandReturn')
EndFunc

Func Assembler_CreateUICommands()
	_('CommandEnterMission:')
	_('push dword[eax+4]')
	_('call EnterMission')
	_('add esp,4')
	_('ljmp CommandReturn')

	_('CommandSetDifficulty:')
	_('push dword[eax+4]')
	_('call SetDifficulty')
	_('add esp,4')
	_('ljmp CommandReturn')
EndFunc