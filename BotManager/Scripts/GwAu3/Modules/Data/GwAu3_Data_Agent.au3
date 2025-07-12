#include-once

Func Agent_ConvertID($a_i_ID)
	Select
		Case $a_i_ID = -2
			Return Agent_GetMyID()
		Case $a_i_ID = -1
			Return Agent_GetCurrentTarget()
		Case IsPtr($a_i_ID) <> 0
			Return Memory_Read($a_i_ID + 0x2C, 'long')
		Case IsDllStruct($a_i_ID) <> 0
			Return DllStructGetData($a_i_ID, 'ID')
		Case Else
			Return $a_i_ID
	EndSelect
EndFunc

Func Agent_GetAgentBase()
    Return $g_p_AgentBase
EndFunc

Func Agent_GetMaxAgents()
    Return Memory_Read($g_i_MaxAgents, 'dword')
EndFunc

Func Agent_GetMyID()
    Return Memory_Read($g_i_MyID, 'dword')
EndFunc

Func GetMyID()
	Local $l_a_Offset[5] = [0, 0x18, 0x2C, 0x680, 0x14]
	Local $l_p_Return = Memory_ReadPtr($g_p_BasePointer, $l_a_Offset)
	Return $l_p_Return[1]
EndFunc

Func Agent_GetCurrentTarget()
    Return Memory_Read($g_i_CurrentTarget, 'dword')
EndFunc

Func Agent_GetAgentCopyCount()
    Return Memory_Read($g_i_AgentCopyCount, 'dword')
EndFunc

Func Agent_GetAgentCopyBase()
    Return $g_p_AgentCopyBase
EndFunc

Func Agent_GetLastTarget()
    Return $g_iLastTargetID
EndFunc

Func Agent_GetAgentPtr($a_i_AgentID = -2)
	If IsPtr($a_i_AgentID) Then Return $a_i_AgentID
	Local $l_a_Offset[3] = [0, 4 * Agent_ConvertID($a_i_AgentID), 0]
	Local $l_p_Return = Memory_ReadPtr($g_p_AgentBase, $l_a_Offset)
	Return $l_p_Return[0]
EndFunc

#Region Agent Related
Func Agent_GetAgentInfo($a_i_AgentID = -2, $a_s_Info = "")
    Local $l_p_AgentPtr = Agent_GetAgentPtr($a_i_AgentID)
    If $l_p_AgentPtr = 0 Or $a_s_Info = "" Then Return 0

    Switch $a_s_Info
        Case "vtable"
            Return Memory_Read($l_p_AgentPtr, "ptr")
        Case "h0004"
            Return Memory_Read($l_p_AgentPtr + 0x4, "dword")
        Case "h0008"
            Return Memory_Read($l_p_AgentPtr + 0x8, "dword")
        Case "h000C"
            Return Memory_Read($l_p_AgentPtr + 0xC, "dword")
        Case "h0010"
            Return Memory_Read($l_p_AgentPtr + 0x10, "dword")
        Case "Timer"
            Return Memory_Read($l_p_AgentPtr + 0x14, "dword")
        Case "Timer2"
            Return Memory_Read($l_p_AgentPtr + 0x18, "dword")
        Case "h0018"
            Return Memory_Read($l_p_AgentPtr + 0x1C, "dword[4]")
        Case "ID"
            Return Memory_Read($l_p_AgentPtr + 0x2C, "long")
        Case "Z"
            Return Memory_Read($l_p_AgentPtr + 0x30, "float")
        Case "Width1"
            Return Memory_Read($l_p_AgentPtr + 0x34, "float")
        Case "Height1"
            Return Memory_Read($l_p_AgentPtr + 0x38, "float")
        Case "Width2"
            Return Memory_Read($l_p_AgentPtr + 0x3C, "float")
        Case "Height2"
            Return Memory_Read($l_p_AgentPtr + 0x40, "float")
        Case "Width3"
            Return Memory_Read($l_p_AgentPtr + 0x44, "float")
        Case "Height3"
            Return Memory_Read($l_p_AgentPtr + 0x48, "float")
        Case "Rotation"
            Return Memory_Read($l_p_AgentPtr + 0x4C, "float")
        Case "RotationCos"
            Return Memory_Read($l_p_AgentPtr + 0x50, "float")
        Case "RotationSin"
            Return Memory_Read($l_p_AgentPtr + 0x54, "float")
        Case "NameProperties"
            Return Memory_Read($l_p_AgentPtr + 0x58, "dword")
        Case "Ground"
            Return Memory_Read($l_p_AgentPtr + 0x5C, "dword")
        Case "h0060"
            Return Memory_Read($l_p_AgentPtr + 0x60, "dword")
        Case "TerrainNormalX"
            Return Memory_Read($l_p_AgentPtr + 0x64, "float")
        Case "TerrainNormalY"
            Return Memory_Read($l_p_AgentPtr + 0x68, "float")
        Case "TerrainNormalZ"
            Return Memory_Read($l_p_AgentPtr + 0x6C, "dword")
        Case "h0070"
            Return Memory_Read($l_p_AgentPtr + 0x70, "byte[4]")
        Case "X"
            Return Memory_Read($l_p_AgentPtr + 0x74, "float")
        Case "Y"
            Return Memory_Read($l_p_AgentPtr + 0x78, "float")
        Case "Plane"
            Return Memory_Read($l_p_AgentPtr + 0x7C, "dword")
        Case "h0080"
            Return Memory_Read($l_p_AgentPtr + 0x80, "byte[4]")
        Case "NameTagX"
            Return Memory_Read($l_p_AgentPtr + 0x84, "float")
        Case "NameTagY"
            Return Memory_Read($l_p_AgentPtr + 0x88, "float")
        Case "NameTagZ"
            Return Memory_Read($l_p_AgentPtr + 0x8C, "float")
        Case "VisualEffects"
            Return Memory_Read($l_p_AgentPtr + 0x90, "short")
        Case "h0092"
            Return Memory_Read($l_p_AgentPtr + 0x92, "short")
        Case "h0094"
            Return Memory_Read($l_p_AgentPtr + 0x94, "dword[2]")


        Case "Type"
            Return Memory_Read($l_p_AgentPtr + 0x9C, "long")
		Case "IsItemType"
			Return Memory_Read($l_p_AgentPtr + 0x9C, "long") = 0x400
		Case "IsGadgetType"
			Return Memory_Read($l_p_AgentPtr + 0x9C, "long") = 0x200
		Case "IsLivingType"
			Return Memory_Read($l_p_AgentPtr + 0x9C, "long") = 0xDB


        Case "MoveX"
            Return Memory_Read($l_p_AgentPtr + 0xA0, "float")
        Case "MoveY"
            Return Memory_Read($l_p_AgentPtr + 0xA4, "float")
        Case "h00A8"
            Return Memory_Read($l_p_AgentPtr + 0xA8, "dword")
        Case "RotationCos2"
            Return Memory_Read($l_p_AgentPtr + 0xAC, "float")
        Case "RotationSin2"
            Return Memory_Read($l_p_AgentPtr + 0xB0, "float")
        Case "h00B4"
            Return Memory_Read($l_p_AgentPtr + 0xB4, "dword[4]")

        Case "Owner"
            Return Memory_Read($l_p_AgentPtr + 0xC4, "long")
		Case "CanPickUp"
			If Memory_Read($l_p_AgentPtr + 0x9C, "long") = 0x400 Then
				If Memory_Read($l_p_AgentPtr + 0xC4, "long") = 0 Or Memory_Read($l_p_AgentPtr + 0xC4, "long") = GetMyID() Then Return True
			EndIf
			Return False

        Case "ItemID"
            Return Memory_Read($l_p_AgentPtr + 0xC8, "dword")
        Case "ExtraType"
            Return Memory_Read($l_p_AgentPtr + 0xCC, "dword")
        Case "GadgetID"
            Return Memory_Read($l_p_AgentPtr + 0xD0, "dword")
        Case "h00D4"
            Return Memory_Read($l_p_AgentPtr + 0xD4, "dword[3]")
        Case "AnimationType"
            Return Memory_Read($l_p_AgentPtr + 0xE0, "float")
        Case "h00E4"
            Return Memory_Read($l_p_AgentPtr + 0xE4, "dword[2]")
        Case "AttackSpeed"
            Return Memory_Read($l_p_AgentPtr + 0xEC, "float")
        Case "AttackSpeedModifier"
            Return Memory_Read($l_p_AgentPtr + 0xF0, "float")
        Case "PlayerNumber"
            Return Memory_Read($l_p_AgentPtr + 0xF4, "short")
        Case "AgentModelType"
            Return Memory_Read($l_p_AgentPtr + 0xF6, "short")
		Case "TransmogNpcId"
            Return Memory_Read($l_p_AgentPtr + 0xF8, "dword")
        Case "Equipment"
            Return Memory_Read($l_p_AgentPtr + 0xFC, "ptr")
        Case "h0100"
            Return Memory_Read($l_p_AgentPtr + 0x100, "dword")
        Case "Tags"
            Return Memory_Read(Memory_Read($l_p_AgentPtr + 0x104, "ptr"), "short")
        Case "h0108"
            Return Memory_Read($l_p_AgentPtr + 0x108, "short")
        Case "Primary"
            Return Memory_Read($l_p_AgentPtr + 0x10A, "byte")
        Case "Secondary"
            Return Memory_Read($l_p_AgentPtr + 0x10B, "byte")
        Case "Level"
            Return Memory_Read($l_p_AgentPtr + 0x10C, "byte")
        Case "Team"
            Return Memory_Read($l_p_AgentPtr + 0x10D, "byte")
        Case "h010E"
            Return Memory_Read($l_p_AgentPtr + 0x10E, "byte[2]")
        Case "h0110"
            Return Memory_Read($l_p_AgentPtr + 0x110, "dword")
        Case "EnergyRegen"
            Return Memory_Read($l_p_AgentPtr + 0x114, "float")
        Case "Overcast"
            Return Memory_Read($l_p_AgentPtr + 0x118, "float")
        Case "EnergyPercent"
            Return Memory_Read($l_p_AgentPtr + 0x11C, "float")
        Case "MaxEnergy"
            Return Memory_Read($l_p_AgentPtr + 0x120, "dword")
		Case "CurrentEnergy"
			Return Memory_Read($l_p_AgentPtr + 0x11C, "float") * Memory_Read($l_p_AgentPtr + 0x120, "dword")
        Case "h0124"
            Return Memory_Read($l_p_AgentPtr + 0x124, "dword")
        Case "HPPips"
            Return Memory_Read($l_p_AgentPtr + 0x128, "float")
        Case "h012C"
            Return Memory_Read($l_p_AgentPtr + 0x12C, "dword")
        Case "HP"
            Return Memory_Read($l_p_AgentPtr + 0x130, "float")
        Case "MaxHP"
            Return Memory_Read($l_p_AgentPtr + 0x134, "dword")
		Case "CurrentHP"
			Return Memory_Read($l_p_AgentPtr + 0x130, "float") * Memory_Read($l_p_AgentPtr + 0x134, "dword")

        Case "Effects"
            Return Memory_Read($l_p_AgentPtr + 0x138, "dword")
		Case "EffectCount"
            Local $l_i_AgentID = Agent_ConvertID($a_i_AgentID)
            Local $l_a_Offset[4] = [0, 0x18, 0x2C, 0x508]
            Local $l_p_AgentEffectsBase = Memory_ReadPtr($g_p_BasePointer, $l_a_Offset)
            Local $l_a_Offset[4] = [0, 0x18, 0x2C, 0x510]
            Local $l_i_AgentEffectsCount = Memory_ReadPtr($g_p_BasePointer, $l_a_Offset)

            If $l_p_AgentEffectsBase[1] = 0 Or $l_i_AgentEffectsCount[1] <= 0 Then Return 0

            For $i = 0 To $l_i_AgentEffectsCount[1] - 1
                Local $l_p_AgentEffects = $l_p_AgentEffectsBase[1] + ($i * 0x24)
                Local $l_i_CurrentAgentID = Memory_Read($l_p_AgentEffects, "dword")

                If $l_i_CurrentAgentID = $l_i_AgentID Then
                    Local $l_p_EffectArray = $l_p_AgentEffects + 0x14
                    Return Memory_Read($l_p_EffectArray + 0x8, "long")
                EndIf
            Next
            Return 0
        Case "BuffCount"
            Local $l_i_AgentID = Agent_ConvertID($a_i_AgentID)
            Local $l_a_Offset[4] = [0, 0x18, 0x2C, 0x508]
            Local $l_p_AgentEffectsBase = Memory_ReadPtr($g_p_BasePointer, $l_a_Offset)
            Local $l_a_Offset[4] = [0, 0x18, 0x2C, 0x510]
            Local $l_i_AgentEffectsCount = Memory_ReadPtr($g_p_BasePointer, $l_a_Offset)

            If $l_p_AgentEffectsBase[1] = 0 Or $l_i_AgentEffectsCount[1] <= 0 Then Return 0

            For $i = 0 To $l_i_AgentEffectsCount[1] - 1
                Local $l_p_AgentEffects = $l_p_AgentEffectsBase[1] + ($i * 0x24)
                Local $l_i_CurrentAgentID = Memory_Read($l_p_AgentEffects, "dword")

                If $l_i_CurrentAgentID = $l_i_AgentID Then
                    Local $l_p_BuffArray = $l_p_AgentEffects + 0x4
                    Return Memory_Read($l_p_BuffArray + 0x8, "long")
                EndIf
            Next

            Return 0


		Case "IsBleeding"
			Return BitAND(Memory_Read($l_p_AgentPtr + 0x138, "dword"), 0x0001) > 0
		Case "IsConditioned"
			Return BitAND(Memory_Read($l_p_AgentPtr + 0x138, "dword"), 0x0002) > 0
		Case "IsCrippled"
			Return BitAND(Memory_Read($l_p_AgentPtr + 0x138, "dword"), 0x000A) = 0xA
		Case "IsDead"
			Return BitAND(Memory_Read($l_p_AgentPtr + 0x138, "dword"), 0x0010) > 0
		Case "IsDeepWounded"
			Return BitAND(Memory_Read($l_p_AgentPtr + 0x138, "dword"), 0x0020) > 0
		Case "IsPoisoned"
			Return BitAND(Memory_Read($l_p_AgentPtr + 0x138, "dword"), 0x0040) > 0
		Case "IsEnchanted"
			Return BitAND(Memory_Read($l_p_AgentPtr + 0x138, "dword"), 0x0080) > 0
		Case "IsDegenHexed"
			Return BitAND(Memory_Read($l_p_AgentPtr + 0x138, "dword"), 0x0400) > 0
		Case "IsHexed"
			Return BitAND(Memory_Read($l_p_AgentPtr + 0x138, "dword"), 0x0800) > 0
		Case "IsWeaponSpelled"
			Return BitAND(Memory_Read($l_p_AgentPtr + 0x138, "dword"), 0x8000) > 0

        Case "h013C"
            Return Memory_Read($l_p_AgentPtr + 0x13C, "dword")
        Case "Hex"
            Return Memory_Read($l_p_AgentPtr + 0x140, "byte")
        Case "h0141"
            Return Memory_Read($l_p_AgentPtr + 0x141, "byte[19]")

        Case "ModelState"
            Return Memory_Read($l_p_AgentPtr + 0x154, "dword")
		Case "IsKnockedDown"
			Return Memory_Read($l_p_AgentPtr + 0x154, "dword") = 0x450
		Case "IsMoving"
			If Memory_Read($l_p_AgentPtr + 0xA0, "float") <> 0 Or Memory_Read($l_p_AgentPtr + 0xA4, "float") <> 0 Then Return True
			If Memory_Read($l_p_AgentPtr + 0x154, "dword") = 12 Or Memory_Read($l_p_AgentPtr + 0x154, "dword") = 76 Or Memory_Read($l_p_AgentPtr + 0x154, "dword") = 204 Then Return True
			Return False
		Case "IsAttacking"
			If Memory_Read($l_p_AgentPtr + 0x154, "dword") = 0x60 Or Memory_Read($l_p_AgentPtr + 0x154, "dword") = 0x440 Or Memory_Read($l_p_AgentPtr + 0x154, "dword") = 0x460 Then Return True
			Return False
		Case "IsCasting"
			If Memory_Read($l_p_AgentPtr + 0x1B4, "short") <> 0 Then Return True
			If Memory_Read($l_p_AgentPtr + 0x154, "dword") = 0x41 Or Memory_Read($l_p_AgentPtr + 0x154, "dword") = 0x245 Then Return True
			Return False
		Case "IsIdle"
			If Memory_Read($l_p_AgentPtr + 0x154, "dword") = 68 Or Memory_Read($l_p_AgentPtr + 0x154, "dword") = 64 Or Memory_Read($l_p_AgentPtr + 0x154, "dword") = 100 Then Return True
			Return False

        Case "TypeMap"
            Return Memory_Read($l_p_AgentPtr + 0x158, "dword")
		Case "InCombatStance"
			Return BitAND(Memory_Read($l_p_AgentPtr + 0x158, "dword"), 0x000001) > 0
		Case "HasQuest"
			Return BitAND(Memory_Read($l_p_AgentPtr + 0x158, "dword"), 0x000002) > 0
		Case "IsDeadByTypeMap"
			Return BitAND(Memory_Read($l_p_AgentPtr + 0x158, "dword"), 0x000008) > 0
		Case "IsFemale"
			Return BitAND(Memory_Read($l_p_AgentPtr + 0x158, "dword"), 0x000200) > 0
		Case "HasBossGlow"
			Return BitAND(Memory_Read($l_p_AgentPtr + 0x158, "dword"), 0x000400) > 0
		Case "IsHidingCap"
			Return BitAND(Memory_Read($l_p_AgentPtr + 0x158, "dword"), 0x001000) > 0
		Case "CanBeViewedInPartyWindow"
			Return BitAND(Memory_Read($l_p_AgentPtr + 0x158, "dword"), 0x20000) > 0
		Case "IsSpawned"
			Return BitAND(Memory_Read($l_p_AgentPtr + 0x158, "dword"), 0x040000) > 0
		Case "IsBeingObserved"
			Return BitAND(Memory_Read($l_p_AgentPtr + 0x158, "dword"), 0x400000) > 0

        Case "h015C"
            Return Memory_Read($l_p_AgentPtr + 0x15C, "dword[4]")
        Case "InSpiritRange"
            Return Memory_Read($l_p_AgentPtr + 0x16C, "dword")


		Case "VisibleEffectsPtr"
			Return $l_p_AgentPtr + 0x174
		Case "VisibleEffectsPrevLink"
			Return Memory_Read($l_p_AgentPtr + 0x174, "ptr")
		Case "VisibleEffectsNextNode"
			Local $l_p_Next = Memory_Read($l_p_AgentPtr + 0x178, "ptr")
			Return BitAND($l_p_Next, 0xFFFFFFFE)
		Case "VisibleEffectCount"
			Return VisibleEffect_Count($a_i_AgentID)
		Case "HasVisibleEffects"
			Return VisibleEffect_Count($a_i_AgentID) > 0

        Case "h017C"
            Return Memory_Read($l_p_AgentPtr + 0x17C, "dword")

        Case "LoginNumber"
            Return Memory_Read($l_p_AgentPtr + 0x180, "dword")
		Case "IsPlayer"
			Return Memory_Read($l_p_AgentPtr + 0x180, "dword") <> 0
		Case "IsNPC"
			Return Memory_Read($l_p_AgentPtr + 0x180, "dword") = 0

        Case "AnimationSpeed"
            Return Memory_Read($l_p_AgentPtr + 0x184, "float")
        Case "AnimationCode"
            Return Memory_Read($l_p_AgentPtr + 0x188, "dword")
        Case "AnimationId"
            Return Memory_Read($l_p_AgentPtr + 0x18C, "dword")
        Case "h0190"
            Return Memory_Read($l_p_AgentPtr + 0x190, "byte[32]")
        Case "LastStrike"
            Return Memory_Read($l_p_AgentPtr + 0x1B0, "byte")
        Case "Allegiance"
            Return Memory_Read($l_p_AgentPtr + 0x1B1, "byte")
        Case "WeaponType"
            Return Memory_Read($l_p_AgentPtr + 0x1B2, "short")
        Case "Skill"
            Return Memory_Read($l_p_AgentPtr + 0x1B4, "short")
        Case "h01B6"
            Return Memory_Read($l_p_AgentPtr + 0x1B6, "short")
        Case "WeaponItemType"
            Return Memory_Read($l_p_AgentPtr + 0x1B8, "byte")
        Case "OffhandItemType"
            Return Memory_Read($l_p_AgentPtr + 0x1B9, "byte")
        Case "WeaponItemId"
            Return Memory_Read($l_p_AgentPtr + 0x1BA, "short")
        Case "OffhandItemId"
            Return Memory_Read($l_p_AgentPtr + 0x1BC, "short")

		Case "Name"
			Return 0 ;in progress
		Case Else
			Return 0
	EndSwitch

    Return 0
EndFunc

Func Agent_GetAgentEquimentInfo($a_i_AgentID = -2, $a_s_Info = "")
	Local $l_p_AgentPtr = Agent_GetAgentInfo($a_i_AgentID, "Equipment")
    If $l_p_AgentPtr = 0 Or $a_s_Info = "" Then Return 0
    Switch $a_s_Info
        Case "vtable"
            Return Memory_Read($l_p_AgentPtr, "dword")
		Case "h0004"
			Return Memory_Read($l_p_AgentPtr + 0x4, "dword")
		Case "h0008"
			Return Memory_Read($l_p_AgentPtr + 0x8, "dword")
		Case "h000C"
			Return Memory_Read($l_p_AgentPtr + 0xC, "dword")
		Case "LeftHandData"
			Return Memory_Read($l_p_AgentPtr + 0x10, "Ptr")
		Case "RightHandData"
			Return Memory_Read($l_p_AgentPtr + 0x14, "Ptr")
		Case "h0018"
			Return Memory_Read($l_p_AgentPtr + 0x18, "dword")
		Case "ShieldData"
			Return Memory_Read($l_p_AgentPtr + 0x1C, "Ptr")


		Case "Weapon_ModelFileID"
			Return Memory_Read($l_p_AgentPtr + 0x24, "dword")
		Case "Weapon_Type"
			Return Memory_Read($l_p_AgentPtr + 0x28, "byte")
		Case "Weapon_Dye1"
			Return Memory_Read($l_p_AgentPtr + 0x29, "byte")
		Case "Weapon_Dye2"
			Return Memory_Read($l_p_AgentPtr + 0x2A, "byte")
		Case "Weapon_Dye3"
			Return Memory_Read($l_p_AgentPtr + 0x2B, "byte")
		Case "Weapon_Value"
			Return Memory_Read($l_p_AgentPtr + 0x2C, "dword")
		Case "Weapon_Interaction"
			Return Memory_Read($l_p_AgentPtr + 0x30, "dword")


		Case "Offhand_ModelFileID"
			Return Memory_Read($l_p_AgentPtr + 0x34, "dword")
		Case "Offhand_Type"
			Return Memory_Read($l_p_AgentPtr + 0x38, "byte")
		Case "Offhand_Dye1"
			Return Memory_Read($l_p_AgentPtr + 0x39, "byte")
		Case "Offhand_Dye2"
			Return Memory_Read($l_p_AgentPtr + 0x3A, "byte")
		Case "Offhand_Dye3"
			Return Memory_Read($l_p_AgentPtr + 0x3B, "byte")
		Case "Offhand_Value"
			Return Memory_Read($l_p_AgentPtr + 0x3C, "dword")
		Case "Offhand_Interaction"
			Return Memory_Read($l_p_AgentPtr + 0x40, "dword")

		Case "Chest_ModelFileID"
			Return Memory_Read($l_p_AgentPtr + 0x44, "dword")
		Case "Chest_Type"
			Return Memory_Read($l_p_AgentPtr + 0x48, "byte")
		Case "Chest_Dye1"
			Return Memory_Read($l_p_AgentPtr + 0x49, "byte")
		Case "Chest_Dye2"
			Return Memory_Read($l_p_AgentPtr + 0x4A, "byte")
		Case "Chest_Dye3"
			Return Memory_Read($l_p_AgentPtr + 0x4B, "byte")
		Case "Chest_Value"
			Return Memory_Read($l_p_AgentPtr + 0x4C, "dword")
		Case "Chest_Interaction"
			Return Memory_Read($l_p_AgentPtr + 0x50, "dword")

		Case "Leg_ModelFileID"
			Return Memory_Read($l_p_AgentPtr + 0x54, "dword")
		Case "Leg_Type"
			Return Memory_Read($l_p_AgentPtr + 0x58, "byte")
		Case "Leg_Dye1"
			Return Memory_Read($l_p_AgentPtr + 0x59, "byte")
		Case "Leg_Dye2"
			Return Memory_Read($l_p_AgentPtr + 0x5A, "byte")
		Case "Leg_Dye3"
			Return Memory_Read($l_p_AgentPtr + 0x5B, "byte")
		Case "Leg_Value"
			Return Memory_Read($l_p_AgentPtr + 0x5C, "dword")
		Case "Leg_Interaction"
			Return Memory_Read($l_p_AgentPtr + 0x60, "dword")

		Case "Head_ModelFileID"
			Return Memory_Read($l_p_AgentPtr + 0x64, "dword")
		Case "Head_Type"
			Return Memory_Read($l_p_AgentPtr + 0x68, "byte")
		Case "Head_Dye1"
			Return Memory_Read($l_p_AgentPtr + 0x69, "byte")
		Case "Head_Dye2"
			Return Memory_Read($l_p_AgentPtr + 0x6A, "byte")
		Case "Head_Dye3"
			Return Memory_Read($l_p_AgentPtr + 0x6B, "byte")
		Case "Head_Value"
			Return Memory_Read($l_p_AgentPtr + 0x6C, "dword")
		Case "Head_Interaction"
			Return Memory_Read($l_p_AgentPtr + 0x70, "dword")

		Case "Feet_ModelFileID"
			Return Memory_Read($l_p_AgentPtr + 0x74, "dword")
		Case "Feet_Type"
			Return Memory_Read($l_p_AgentPtr + 0x78, "byte")
		Case "Feet_Dye1"
			Return Memory_Read($l_p_AgentPtr + 0x79, "byte")
		Case "Feet_Dye2"
			Return Memory_Read($l_p_AgentPtr + 0x7A, "byte")
		Case "Feet_Dye3"
			Return Memory_Read($l_p_AgentPtr + 0x7B, "byte")
		Case "Feet_Value"
			Return Memory_Read($l_p_AgentPtr + 0x7C, "dword")
		Case "Feet_Interaction"
			Return Memory_Read($l_p_AgentPtr + 0x80, "dword")

		Case "Hands_ModelFileID"
			Return Memory_Read($l_p_AgentPtr + 0x84, "dword")
		Case "Hands_Type"
			Return Memory_Read($l_p_AgentPtr + 0x88, "byte")
		Case "Hands_Dye1"
			Return Memory_Read($l_p_AgentPtr + 0x89, "byte")
		Case "Hands_Dye2"
			Return Memory_Read($l_p_AgentPtr + 0x8A, "byte")
		Case "Hands_Dye3"
			Return Memory_Read($l_p_AgentPtr + 0x8B, "byte")
		Case "Hands_Value"
			Return Memory_Read($l_p_AgentPtr + 0x8C, "dword")
		Case "Hands_Interaction"
			Return Memory_Read($l_p_AgentPtr + 0x90, "dword")

		Case "CostumeBody_ModelFileID"
			Return Memory_Read($l_p_AgentPtr + 0x94, "dword")
		Case "CostumeBody_Type"
			Return Memory_Read($l_p_AgentPtr + 0x98, "byte")
		Case "CostumeBody_Dye1"
			Return Memory_Read($l_p_AgentPtr + 0x99, "byte")
		Case "CostumeBody_Dye2"
			Return Memory_Read($l_p_AgentPtr + 0x9A, "byte")
		Case "CostumeBody_Dye3"
			Return Memory_Read($l_p_AgentPtr + 0x9B, "byte")
		Case "CostumeBody_Value"
			Return Memory_Read($l_p_AgentPtr + 0x9C, "dword")
		Case "CostumeBody_Interaction"
			Return Memory_Read($l_p_AgentPtr + 0xA0, "dword")

		Case "CostumeHead_ModelFileID"
			Return Memory_Read($l_p_AgentPtr + 0xA4, "dword")
		Case "CostumeHead_Type"
			Return Memory_Read($l_p_AgentPtr + 0xA8, "byte")
		Case "CostumeHead_Dye1"
			Return Memory_Read($l_p_AgentPtr + 0xA9, "byte")
		Case "CostumeHead_Dye2"
			Return Memory_Read($l_p_AgentPtr + 0xAA, "byte")
		Case "CostumeHead_Dye3"
			Return Memory_Read($l_p_AgentPtr + 0xAB, "byte")
		Case "CostumeHead_Value"
			Return Memory_Read($l_p_AgentPtr + 0xAC, "dword")
		Case "CostumeHead_Interaction"
			Return Memory_Read($l_p_AgentPtr + 0xB0, "dword")

		Case "ItemID_Weapon"
			Return Memory_Read($l_p_AgentPtr + 0xB4, "dword")
		Case "ItemID_Offhand"
			Return Memory_Read($l_p_AgentPtr + 0xB8, "dword")
		Case "ItemID_Chest"
			Return Memory_Read($l_p_AgentPtr + 0xBC, "dword")
		Case "ItemID_Legs"
			Return Memory_Read($l_p_AgentPtr + 0xC0, "dword")
		Case "ItemID_Head"
			Return Memory_Read($l_p_AgentPtr + 0xC4, "dword")
		Case "ItemID_Feet"
			Return Memory_Read($l_p_AgentPtr + 0xC8, "dword")
		Case "ItemID_Hands"
			Return Memory_Read($l_p_AgentPtr + 0xCC, "dword")
		Case "ItemID_CostumeBody"
			Return Memory_Read($l_p_AgentPtr + 0xD0, "dword")
		Case "ItemID_CostumeHead"
			Return Memory_Read($l_p_AgentPtr + 0xD4, "dword")
	EndSwitch
	Return 0
EndFunc

Func Agent_GetAgentArray($a_i_Type = 0)
    Local $l_i_MaxAgents = Agent_GetMaxAgents()
    If $l_i_MaxAgents <= 0 Then Return

	Local $l_a_AgentArray[$l_i_MaxAgents + 1]
    Local $l_p_Pointer, $l_i_Count = 0
    Local $l_p_AgentBase = Memory_Read($g_p_AgentBase)
    Local $l_p_AgentPtrBuffer = DllStructCreate("ptr[" & $l_i_MaxAgents & "]")

    DllCall($g_h_Kernel32, "bool", "ReadProcessMemory", "handle", $g_h_GWProcess, "ptr", $l_p_AgentBase, "struct*", $l_p_AgentPtrBuffer, "ulong_ptr", 4 * $l_i_MaxAgents, "ulong_ptr*", 0)

    For $i = 1 To $l_i_MaxAgents
        $l_p_Pointer = DllStructGetData($l_p_AgentPtrBuffer, 1, $i)
        If $l_p_Pointer = 0 Then ContinueLoop

        If $a_i_Type <> 0 Then
            If Agent_GetAgentInfo($l_p_Pointer, "Type") <> $a_i_Type Then ContinueLoop
        EndIf

        $l_i_Count += 1
        $l_a_AgentArray[$l_i_Count] = $l_p_Pointer
    Next

    $l_a_AgentArray[0] = $l_i_Count
    ReDim $l_a_AgentArray[$l_i_Count + 1]

    Return $l_a_AgentArray
EndFunc

;~ Func Agent_GetAgentArray()
;~     Local $l_a_AgentArray = Memory_ReadArray($mAgentBase, 0x8)
;~     Return $l_a_AgentArray
;~ EndFunc
#EndRegion Agent Related

Func Agent_GetDistance($a_i_Agent1ID, $a_i_Agent2ID = 0)
    If $a_i_Agent2ID = 0 Then $a_i_Agent2ID = Agent_GetMyID()

    Local $l_f_X1 = Agent_GetAgentInfo($a_i_Agent1ID, "X")
    Local $l_f_Y1 = Agent_GetAgentInfo($a_i_Agent1ID, "Y")
    Local $l_f_X2 = Agent_GetAgentInfo($a_i_Agent2ID, "X")
    Local $l_f_Y2 = Agent_GetAgentInfo($a_i_Agent2ID, "Y")

    Return Sqrt(($l_f_X1 - $l_f_X2)^2 + ($l_f_Y1 - $l_f_Y2)^2)
EndFunc

#Region Effect Related
Func Agent_GetAgentEffectArrayInfo($a_i_AgentID = -2, $a_s_Info = "")
    Local $l_p_Pointer = World_GetWorldInfo("AgentEffectsArray")
    Local $l_i_Size = World_GetWorldInfo("AgentEffectsArraySize")
    Local $l_p_AgentPtr = 0

    For $i = 0 To $l_i_Size
        Local $l_p_AgentEffects = $l_p_Pointer + ($i * 0x24)
        If Memory_Read($l_p_AgentEffects, "dword") = Agent_ConvertID($a_i_AgentID) Then
            $l_p_AgentPtr = $l_p_AgentEffects
            ExitLoop
        EndIf
    Next

    If $l_p_AgentPtr = 0 Or $a_s_Info = "" Then Return 0

    Switch $a_s_Info
        Case "AgentID"
            Return Memory_Read($l_p_AgentPtr, "dword")
        Case "BuffArray"
            Return Memory_Read($l_p_AgentPtr + 0x4, "ptr")
        Case "BuffArraySize"
            Return Memory_Read($l_p_AgentPtr + 0x4 + 0x8, "long")
        Case "EffectArray"
            Return Memory_Read($l_p_AgentPtr + 0x14, "ptr")
        Case "EffectArraySize"
            Return Memory_Read($l_p_AgentPtr + 0x14 + 0x8, "long")
        Case Else
            Return 0
    EndSwitch
EndFunc

Func Agent_GetAgentEffectInfo($a_i_AgentID = -2, $a_i_SkillID = 0, $a_s_Info = "")
    Local $l_p_EffectArray = Agent_GetAgentEffectArrayInfo($a_i_AgentID, "EffectArray")
    Local $l_i_EffectCount = Agent_GetAgentEffectArrayInfo($a_i_AgentID, "EffectArraySize")

    If $l_p_EffectArray = 0 Or $l_i_EffectCount = 0 Then Return 0

    Local $l_p_EffectPtr = 0
    For $j = 0 To $l_i_EffectCount - 1
        Local $l_p_CurrentPtr = $l_p_EffectArray + ($j * 0x18)
        Local $l_i_CurrentSkillID = Memory_Read($l_p_CurrentPtr, "long")

        If $l_i_CurrentSkillID = $a_i_SkillID Then
            $l_p_EffectPtr = $l_p_CurrentPtr
            ExitLoop
        EndIf
    Next

    If $l_p_EffectPtr = 0 Then Return 0
    If $a_s_Info = "" Then Return $l_p_EffectPtr

    Switch $a_s_Info
;~         Case "SkillID"
;~             Return Memory_Read($l_p_EffectPtr, "long")
        Case "AttributeLevel"
            Return Memory_Read($l_p_EffectPtr + 0x4, "dword")
        Case "EffectID"
            Return Memory_Read($l_p_EffectPtr + 0x8, "long")
        Case "CasterID" ; maintained enchantment
            Return Memory_Read($l_p_EffectPtr + 0xC, "dword")
        Case "Duration"
            Return Memory_Read($l_p_EffectPtr + 0x10, "float")
        Case "Timestamp"
            Return Memory_Read($l_p_EffectPtr + 0x14, "dword")
		Case "TimeElapsed"
			Local $l_i_Timestamp = Memory_Read($l_p_EffectPtr + 0x14, "dword")
			Return BitAND(Skill_GetSkillTimer() - $l_i_Timestamp, 0xFFFFFFFF)
		Case "TimeRemaining"
			Local $l_i_Timestamp = Memory_Read($l_p_EffectPtr + 0x14, "dword")
			Local $l_i_Duration = Memory_Read($l_p_EffectPtr + 0x10, "float")
			Return $l_i_Duration * 1000 - BitAND(Skill_GetSkillTimer() - $l_i_Timestamp, 0xFFFFFFFF)
        Case "HasEffect"
            Return True
        Case Else
            Return 0
    EndSwitch
EndFunc

Func Agent_GetAgentBuffInfo($a_i_AgentID = -2, $a_i_SkillID = 0, $a_s_Info = "")
    Local $l_p_BuffArray = Agent_GetAgentEffectArrayInfo($a_i_AgentID, "BuffArray")
    Local $l_i_BuffCount = Agent_GetAgentEffectArrayInfo($a_i_AgentID, "BuffArraySize")

    If $l_p_BuffArray = 0 Or $l_i_BuffCount = 0 Then Return 0

    Local $l_p_BuffPtr = 0
    For $j = 0 To $l_i_BuffCount - 1
        Local $l_p_CurrentPtr = $l_p_BuffArray + ($j * 0x10)
        Local $l_i_CurrentSkillID = Memory_Read($l_p_CurrentPtr, "long")

        If $l_i_CurrentSkillID = $a_i_SkillID Then
            $l_p_BuffPtr = $l_p_CurrentPtr
            ExitLoop
        EndIf
    Next

    If $l_p_BuffPtr = 0 Then Return 0
    If $a_s_Info = "" Then Return $l_p_BuffPtr

    Switch $a_s_Info
;~         Case "SkillID"
;~             Return Memory_Read($l_p_BuffPtr, "long")
        Case "h0004"
            Return Memory_Read($l_p_BuffPtr + 0x4, "dword")
        Case "BuffID"
            Return Memory_Read($l_p_BuffPtr + 0x8, "long")
        Case "TargetAgentID"
            Return Memory_Read($l_p_BuffPtr + 0xC, "dword")
        Case "HasBuff"
            Return True
        Case Else
            Return 0
    EndSwitch
EndFunc
#EndRegion

#Region Related NPC Info
;~ TIPS: $a_i_ModelFileID = Player number of an npc
Func Agent_GetNpcInfo($a_i_ModelFileID = 0, $a_s_Info = "")
	Local $l_p_Pointer = World_GetWorldInfo("NpcArray")
	Local $l_i_Size = World_GetWorldInfo("NpcArraySize")
	Local $l_p_AgentPtr = 0

	For $i = 0 To $l_i_Size
        Local $l_p_AgentEffects = $l_p_Pointer + ($i * 0x30)
        If Memory_Read($l_p_AgentEffects, "dword") = $a_i_ModelFileID Then
            $l_p_AgentPtr = $l_p_AgentEffects
            ExitLoop
        EndIf
    Next

	If $l_p_AgentPtr = 0 Then Return 0

	Switch $a_s_Info
		Case "ModelFileID"
            Return Memory_Read($l_p_AgentPtr, "dword")
        Case "Scale"
            Return Memory_Read($l_p_AgentPtr + 0x8, "dword")
		Case "Sex"
            Return Memory_Read($l_p_AgentPtr + 0xC, "dword")
		Case "NpcFlags"
            Return Memory_Read($l_p_AgentPtr + 0x10, "dword")
		Case "Primary"
            Return Memory_Read($l_p_AgentPtr + 0x14, "dword")
		Case "DefaultLevel", "Level"
            Return Memory_Read($l_p_AgentPtr + 0x1C, "byte")
		Case "IsHenchman"
			Local $flags = Memory_Read($l_p_AgentPtr + 0x10, "dword")
            Return BitAND($flags, 0x10) <> 0
		Case "IsHero"
			Local $flags = Memory_Read($l_p_AgentPtr + 0x10, "dword")
            Return BitAND($flags, 0x20) <> 0
		Case "IsSpirit"
			Local $flags = Memory_Read($l_p_AgentPtr + 0x10, "dword")
            Return BitAND($flags, 0x4000) <> 0
		Case "IsMinion"
			Local $flags = Memory_Read($l_p_AgentPtr + 0x10, "dword")
            Return BitAND($flags, 0x100) <> 0
		Case "IsPet"
			Local $flags = Memory_Read($l_p_AgentPtr + 0x10, "dword")
            Return BitAND($flags, 0xD) <> 0
        Case Else
            Return 0
    EndSwitch
EndFunc

#EndRegion

#Region Related Player Info
Func Agent_GetPlayerInfo($a_i_AgentID = 0, $a_s_Info = "")
    Local $l_p_Pointer = World_GetWorldInfo("PlayerArray")
    Local $l_i_Size = World_GetWorldInfo("PlayerArraySize")
    Local $l_p_AgentPtr = 0

    For $i = 1 To $l_i_Size - 1
        Local $l_p_AgentEffects = $l_p_Pointer + ($i * 0x4C)
        If Memory_Read($l_p_AgentEffects, "dword") = Agent_ConvertID($a_i_AgentID) Then
            $l_p_AgentPtr = $l_p_AgentEffects
            ExitLoop
        EndIf
    Next

    If $l_p_AgentPtr = 0 Then Return 0

    Switch $a_s_Info
        Case "AgentID"
            Return Memory_Read($l_p_AgentPtr, "dword")
        Case "AppearanceBitmap"
            Return Memory_Read($l_p_AgentPtr + 0x10, "dword")
        Case "Flags"
            Return Memory_Read($l_p_AgentPtr + 0x14, "dword")
        Case "Primary"
            Return Memory_Read($l_p_AgentPtr + 0x18, "dword")
        Case "Secondary"
            Return Memory_Read($l_p_AgentPtr + 0x1C, "dword")
        Case "Name"
;~             Return Memory_Read($l_p_AgentPtr + 0x24, "wchar[20]")
            Local $lName = Memory_Read($l_p_AgentPtr + 0x24, "ptr")
            Return Memory_Read($lName, "wchar[20]")
        Case "PartLeaderPlayerNumber"
            Return Memory_Read($l_p_AgentPtr + 0x2C, "dword")
        Case "ActiveTitle"
            Return Memory_Read($l_p_AgentPtr + 0x30, "dword")
        Case "PlayerNumber"
            Return Memory_Read($l_p_AgentPtr + 0x34, "dword")
        Case "PartySize"
            Return Memory_Read($l_p_AgentPtr + 0x38, "dword")
        Case Else
            Return 0
    EndSwitch
EndFunc

Func Agent_GetPlayerLogInfo($a_s_Info = "")
    Local $l_p_Pointer = World_GetWorldInfo("PlayerArray")
    If $l_p_Pointer = 0 Then Return 0

    Switch $a_s_Info
        Case "LastPlayerHeroAdded"
            Return Memory_Read($l_p_Pointer + 0x2C, "dword")
        Case "LastPartyHenchmenCount"
            Local $l_i_HenchmenCount = Memory_Read($l_p_Pointer + 0x38, "dword")
            $l_i_HenchmenCount = $l_i_HenchmenCount - ($l_i_HenchmenCount <> 0)
        Case "LastPlayerOut"
            Local $lLogPtr = Memory_Read($l_p_Pointer + 0x3C, "ptr")
            If $lLogPtr = 0 Then Return 0
            Local $lZoneCnt = Memory_Read($l_p_Pointer + 0x44, "dword")
            Return Memory_Read($lLogPtr + (($lZoneCnt - 1) * 0x4))
        Case "LogCapacity"
            Return Memory_Read($l_p_Pointer + 0x40, "dword")
        Case "ZoneCount"
            Return Memory_Read($l_p_Pointer + 0x44, "dword")
        Case Else
            Return 0
    EndSwitch
EndFunc
#EndRegion Related Player Info

Func Agent_GetBestTarget($a_i_Range = 1320)
    Local $l_i_BestTarget, $l_f_Distance, $l_f_LowestSum = 100000000
    Local $l_ai_AgentArray = Agent_GetAgentArray(0xDB)
    For $l_i_Idx = 1 To $l_ai_AgentArray[0]
        Local $l_f_SumDistances = 0
        If Agent_GetAgentInfo($l_ai_AgentArray[$l_i_Idx], 'Allegiance') <> 3 Then ContinueLoop
        If Agent_GetAgentInfo($l_ai_AgentArray[$l_i_Idx], 'HP') <= 0 Then ContinueLoop
        If Agent_GetAgentInfo($l_ai_AgentArray[$l_i_Idx], 'ID') = Agent_GetMyID() Then ContinueLoop
        If Agent_GetDistance($l_ai_AgentArray[$l_i_Idx]) > $a_i_Range Then ContinueLoop
        For $l_i_SubIdx = 1 To $l_ai_AgentArray[0]
            If Agent_GetAgentInfo($l_ai_AgentArray[$l_i_SubIdx], 'Allegiance') <> 3 Then ContinueLoop
            If Agent_GetAgentInfo($l_ai_AgentArray[$l_i_SubIdx], 'HP') <= 0 Then ContinueLoop
            If Agent_GetAgentInfo($l_ai_AgentArray[$l_i_SubIdx], 'ID') = Agent_GetMyID() Then ContinueLoop
            If Agent_GetDistance($l_ai_AgentArray[$l_i_SubIdx]) > $a_i_Range Then ContinueLoop
            $l_f_Distance = Agent_GetDistance($l_ai_AgentArray[$l_i_Idx], $l_ai_AgentArray[$l_i_SubIdx])
            $l_f_SumDistances += $l_f_Distance
        Next
        If $l_f_SumDistances < $l_f_LowestSum Then
            $l_f_LowestSum = $l_f_SumDistances
            $l_i_BestTarget = $l_ai_AgentArray[$l_i_Idx]
        EndIf
    Next
    Return $l_i_BestTarget
EndFunc   ;==>GetBestTarget

#Region Visible Effect
Func Agent_CountVisibleEffects($a_i_AgentID = -2)
    Return VisibleEffect_Count($a_i_AgentID)
EndFunc

Func Agent_GetAllVisibleEffects($a_i_AgentID = -2)
    Local $l_a_FullEffects = VisibleEffect_GetAll($a_i_AgentID)
    Local $l_a_IDs[$l_a_FullEffects[0][0] + 1]
    $l_a_IDs[0] = $l_a_FullEffects[0][0]

    For $i = 1 To $l_a_IDs[0]
        $l_a_IDs[$i] = $l_a_FullEffects[$i][2]
    Next

    Return $l_a_IDs
EndFunc

Func Agent_HasVisibleEffect($a_i_AgentID = -2, $a_i_EffectID = 0)
    Local $l_a_Result = VisibleEffect_FindByID($a_i_AgentID, $a_i_EffectID)
    Return $l_a_Result[0]
EndFunc

Func VisibleEffect_Count($a_i_AgentID = -2)
    Local $l_p_AgentPtr = Agent_GetAgentPtr($a_i_AgentID)
    If $l_p_AgentPtr = 0 Then Return 0

    If Agent_GetAgentInfo($l_p_AgentPtr, "Type") <> 0xDB Then Return 0

    Local $l_p_TList = $l_p_AgentPtr + 0x170
    Local $l_a_Iterator = Utils_TList_CreateIterator($l_p_TList)

    Local $l_i_Count = 0
    Local $l_p_Current = Utils_TList_Iterator_Current($l_a_Iterator)

    While $l_p_Current <> 0
        $l_i_Count += 1
        If Not Utils_TList_Iterator_Next($l_a_Iterator) Then ExitLoop
        $l_p_Current = Utils_TList_Iterator_Current($l_a_Iterator)
    WEnd

    Return $l_i_Count
EndFunc

Func VisibleEffect_GetAll($a_i_AgentID = -2)
    Local $l_a_Effects[101][4]
    $l_a_Effects[0][0] = 0

    Local $l_p_AgentPtr = Agent_GetAgentPtr($a_i_AgentID)
    If $l_p_AgentPtr = 0 Then Return $l_a_Effects

    If Agent_GetAgentInfo($l_p_AgentPtr, "Type") <> 0xDB Then Return $l_a_Effects

    Local $l_p_TList = $l_p_AgentPtr + 0x170
    Local $l_a_Iterator = Utils_TList_CreateIterator($l_p_TList)

    Local $l_i_Count = 0
    Local $l_p_Current = Utils_TList_Iterator_Current($l_a_Iterator)

    While $l_p_Current <> 0 And $l_i_Count < 100
        $l_i_Count += 1

        $l_a_Effects[$l_i_Count][0] = $l_p_Current
        $l_a_Effects[$l_i_Count][1] = Memory_Read($l_p_Current, "dword") ; unk
        $l_a_Effects[$l_i_Count][2] = Memory_Read($l_p_Current + 0x4, "dword") ; id
        $l_a_Effects[$l_i_Count][3] = Memory_Read($l_p_Current + 0x8, "dword") ; has_ended

        If Not Utils_TList_Iterator_Next($l_a_Iterator) Then ExitLoop
        $l_p_Current = Utils_TList_Iterator_Current($l_a_Iterator)
    WEnd

    $l_a_Effects[0][0] = $l_i_Count
    ReDim $l_a_Effects[$l_i_Count + 1][4]

    Return $l_a_Effects
EndFunc

Func VisibleEffect_FindByID($a_i_AgentID = -2, $a_i_EffectID = 0)
    Local $l_a_Result[4] = [False, 0, 0, 0]

    Local $l_p_AgentPtr = Agent_GetAgentPtr($a_i_AgentID)
    If $l_p_AgentPtr = 0 Then Return $l_a_Result

    If Agent_GetAgentInfo($l_p_AgentPtr, "Type") <> 0xDB Then Return $l_a_Result

    Local $l_p_TList = $l_p_AgentPtr + 0x170
    Local $l_a_Iterator = Utils_TList_CreateIterator($l_p_TList)

    Local $l_p_Current = Utils_TList_Iterator_Current($l_a_Iterator)

    While $l_p_Current <> 0
        Local $l_i_ID = Memory_Read($l_p_Current + 0x4, "dword")

        If $l_i_ID = $a_i_EffectID Then
            $l_a_Result[0] = True
            $l_a_Result[1] = $l_p_Current
            $l_a_Result[2] = Memory_Read($l_p_Current, "dword") ; unk
            $l_a_Result[3] = Memory_Read($l_p_Current + 0x8, "dword") ; has_ended
            Return $l_a_Result
        EndIf

        If Not Utils_TList_Iterator_Next($l_a_Iterator) Then ExitLoop
        $l_p_Current = Utils_TList_Iterator_Current($l_a_Iterator)
    WEnd

    Return $l_a_Result
EndFunc
#EndRegion

Func GetAgents($aAgentID = -2, $aRange = 1320, $aType = 0, $aReturnMode = 0, $aCustomFilter = "")
    ; Variables for tracking
    Local $lCount = 0
    Local $lClosestAgent = 0
    Local $lClosestDistance = 999999
    Local $lFarthestAgent = 0
    Local $lFarthestDistance = 0

    ; Get the coordinates of the reference agent
    Local $lRefID = Agent_ConvertID($aAgentID)
    Local $lRefX = Agent_GetAgentInfo($aAgentID, "X")
    Local $lRefY = Agent_GetAgentInfo($aAgentID, "Y")

    ; Get the agent array based on the type
    Local $lAgentArray
    If $aType > 0 Then
        $lAgentArray = Agent_GetAgentArray($aType)
    Else
        $lAgentArray = Agent_GetAgentArray()
    EndIf

    ; If no agents found, return 0
    If Not IsArray($lAgentArray) Or $lAgentArray[0] = 0 Then
        Return 0
    EndIf

    ; Process each agent
    For $i = 1 To $lAgentArray[0]
        Local $lAgentPtr = $lAgentArray[$i]
        Local $lAgentID = Agent_GetAgentInfo($lAgentPtr, "ID")

        ; Ignore the reference agent
        If $lAgentID = $lRefID Then ContinueLoop

        ; Calculate the distance to the reference agent (not the player)
        Local $lAgentX = Agent_GetAgentInfo($lAgentPtr, "X")
        Local $lAgentY = Agent_GetAgentInfo($lAgentPtr, "Y")
        Local $lDistance = Sqrt(($lAgentX - $lRefX) ^ 2 + ($lAgentY - $lRefY) ^ 2)

        ; Ignore if outside the reference agent's range
        If $lDistance > $aRange Then ContinueLoop

        ; Apply the custom filter
		If $aCustomFilter <> "" Then
            Local $lResult = Call($aCustomFilter, $lAgentPtr)
            If Not $lResult Then ContinueLoop
        EndIf

        ; Increment the counter
        $lCount += 1

        ; Update the closest agent
        If $lDistance < $lClosestDistance Then
            $lClosestDistance = $lDistance
            $lClosestAgent = $lAgentPtr
        EndIf

        ; Update the farthest agent
        If $lDistance > $lFarthestDistance Then
            $lFarthestDistance = $lDistance
            $lFarthestAgent = $lAgentPtr
        EndIf
    Next

    ; Return the result based on the mode
    Switch $aReturnMode
        Case 0 ; Number of agents
            Return $lCount
        Case 1 ; Closest Agent
            Return $lClosestAgent
        Case 2 ; Farthest Agent
            Return $lFarthestAgent
        Case 3 ; Closest Distance
            Return $lClosestDistance
    EndSwitch
EndFunc