Opt("WinTitleMatchMode", 3)
Opt("TrayIconDebug",1)

#RequireAdmin
#include <GWA2.au3>
#include <MsgBoxConstants.au3>

;MADE BY SOME SEXY BEAST NAMED 4D 1,
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; SETUP HERE ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Global $AmountofAccs = 1;Amount of accounts you want to set

Global $GWCA = False ; IF you are running a GWCA bot, will inject Graphics.dll in same folder as script.

Global $GWMLPath = $CmdLine[1] ; Path to Guild Wars Multi Launch
Global $GWPath = $CmdLine[2] ;Array of Paths to your Gw.exe's
Global $Email = $CmdLine[3]
Global $Password = $CmdLine[4]
Global $Character = $CmdLine[5]
Global $MinimizeClient = $CmdLine[6]


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



Global $CurPID,$CurBotPID,$Path,$CurHwnd

For $i = 0 To $AmountofAccs - 1

#Region Declarations
Local $mKernelHandle
Local $mGWProcHandle
Local $mGWHwnd
Local $mMemory
Local $mLabels[1][2]
Local $mBase = 0x00DE0000
Local $mASMString, $mASMSize, $mASMCodeOffset


Local $mQueueCounter, $mQueueSize, $mQueueBase
Local $mTargetLogBase
Local $mStringLogBase
Local $mSkillBase
Local $mEnsureEnglish
Local $mMyID, $mCurrentTarget
Local $mAgentBase
Local $mBasePointer
Local $mRegion, $mLanguage
Local $mPing
Local $mCharname
Local $mMapID
Local $mMaxAgents
Local $mMapLoading
Local $mMapIsLoaded
Local $mLoggedIn
Local $mStringHandlerPtr
Local $mWriteChatSender
Local $mTraderQuoteID, $mTraderCostID, $mTraderCostValue
Local $mSkillTimer
Local $mBuildNumber
Local $mZoomStill, $mZoomMoving
Local $mDisableRendering
Local $mAgentCopyCount
Local $mAgentCopyBase

Local $mUseStringLog
Local $mUseEventSystem
#EndRegion Declarations

#Region CommandStructs
Local $mLogin = DllStructCreate('ptr;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword')
Local $mLoginPtr = DllStructGetPtr($mLogin)
#EndRegion CommandStructs

$Path = StringFormat('"%s" "%s" -windowed -email %s -password %s -character "%s"',$GWMLPath,$GWPath,$Email,$Password,$Character)
Run($Path)
$hWnd = WinWaitActive("[CLASS:ArenaNet_Dx_Window_Class]")
$CurPID = WinGetProcess("Guild Wars")

$CurHwnd = InitMemory($CurPID)

Do
	Sleep(100)
Until ScanForCharname() <> ""

Sleep(1000)
ControlSend($CurHwnd,"","","{ENTER}")
Sleep(1000)

Do
	Sleep(100)
Until GetAgentExists(-2)

MemoryClose()

Sleep(100)

If $GWCA Then _InjectDll($CurPID,"Graphics.dll")

If $MinimizeClient = "True" Then 
	WinSetState($hWnd, "", @SW_MINIMIZE)
EndIf

Next

#region Boring Shit

Func _InjectDll($ProcessId, $DllPath)
	If $ProcessId == 0 Then Return SetError(1, "", False)
	If Not (FileExists($DllPath)) Then Return SetError(2, "", False)
	If Not (StringRight($DllPath, 4) == ".dll") Then Return SetError(3, "", False)

	$Kernel32 = DllOpen("kernel32.dll")
	If @error Then Return SetError(4, "", False)

	$DLL_Path = DllStructCreate("char[255]")
	DllCall($Kernel32, "DWORD", "GetFullPathNameA", "str", $DllPath, "DWORD", 255, "ptr", DllStructGetPtr($DLL_Path), "int", 0)
	If @error Then Return SetError(5, "", False)

	$hProcess = DllCall($Kernel32, "DWORD", "OpenProcess", "DWORD", 0x1F0FFF, "int", 0, "DWORD", $ProcessId)
	If @error Then Return SetError(6, "", False)

	$hModule = DllCall($Kernel32, "DWORD", "GetModuleHandleA", "str", "kernel32.dll")
	If @error Then Return SetError(7, "", False)

	$lpStartAddress = DllCall($Kernel32, "DWORD", "GetProcAddress", "DWORD", $hModule[0], "str", "LoadLibraryA")
	If @error Then Return SetError(8, "", False)

	$lpParameter = DllCall($Kernel32, "DWORD", "VirtualAllocEx", "int", $hProcess[0], "int", 0, "ULONG_PTR", DllStructGetSize($DLL_Path), "DWORD", 0x3000, "int", 4)
	If @error Then Return SetError(9, "", False)

	DllCall("kernel32.dll", "BOOL", "WriteProcessMemory", "int", $hProcess[0], "DWORD", $lpParameter[0], "str", DllStructGetData($DLL_Path, 1), "ULONG_PTR", DllStructGetSize($DLL_Path), "int", 0)
	If @error Then Return SetError(10, "", False)

	$hThread = DllCall($Kernel32, "int", "CreateRemoteThread", "DWORD", $hProcess[0], "int", 0, "int", 0, "DWORD", $lpStartAddress[0], "DWORD", $lpParameter[0], "int", 0, "int", 0)
	If @error Then Return SetError(11, "", False)

	DllCall($Kernel32, "BOOL", "CloseHandle", "DWORD", $hProcess[0])
	DllClose($Kernel32)

	Return SetError(0, "", True)
EndFunc

#Region Memory

Func InitMemory($aGW)
		Local $lWinList

		$lWinList = WinList()

		For $i = 1 To $lWinList[0][0]
			$mGWHwnd = $lWinList[$i][1]
			If WinGetProcess($mGWHwnd) = $aGW Then
				MemoryOpen($aGW)
				ScanForCharname()
				ExitLoop
			EndIf
		Next

	If $mGWProcHandle = 0 Then Return 0

	Scan()

	$mBasePointer = MemoryRead(GetScannedAddress('ScanBasePointer', 8))
	SetValue('BasePointer', '0x' & Hex($mBasePointer, 8))
	$mAgentBase = GetScannedAddress('ScanAgentBase', -15) + 0x1E
	$mAgentBase = $mAgentBase + MemoryRead($mAgentBase) + 4
	$mAgentBase += 0x13
	$mAgentBase = MemoryRead($mAgentBase)
	SetValue('AgentBase', '0x' & Hex($mAgentBase, 8))
	$mMaxAgents = $mAgentBase + 8
	SetValue('MaxAgents', '0x' & Hex($mMaxAgents, 8))
	$mMyID = MemoryRead(GetScannedAddress('ScanMyID', -3))
	SetValue('MyID', '0x' & Hex($mMyID, 8))
	$mMapLoading = $mAgentBase - 240
	$mCurrentTarget = $mAgentBase - 1280
	SetValue('PacketLocation', '0x' & Hex(MemoryRead(GetScannedAddress('ScanBaseOffset', 11)), 8))
	Return $mGWHwnd
EndFunc

#EndRegion