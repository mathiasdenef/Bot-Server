#RequireAdmin
#include "GwAu3/_GwAu3.au3"

#include <GuiEdit.au3>

#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <MsgBoxConstants.au3>

Opt("GUIOnEventMode", 1)
#Region ### START Koda GUI section ### Form=
$Form = GUICreate("Keiran Runner", 503, 783, -1, -1)
$LogBox = GUICtrlCreateEdit("", 30, 617, 430, 142, BitOR($GUI_SS_DEFAULT_EDIT,$ES_READONLY))
GUICtrlSetData(-1, "")
$ButtonStart = GUICtrlCreateButton("Start", 30, 576, 430, 30)
$GroupActions = GUICtrlCreateGroup("Actions", 260, 20, 200, 160)
$CheckboxGraphics = GUICtrlCreateCheckbox("Disable Graphics", 275, 44, 120, 17)
$ButtonTrade = GUICtrlCreateButton("Trade", 275, 68, 170, 25)
$ButtonDebug1 = GUICtrlCreateButton("Debug 1", 275, 100, 170, 25)
$ButtonDebug2 = GUICtrlCreateButton("Debug 2", 275, 132, 170, 25)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$GroupTimes = GUICtrlCreateGroup("Times", 30, 350, 200, 209)
$Label5 = GUICtrlCreateLabel("Total Time:", 44, 390, 70, 17)
$Label6 = GUICtrlCreateLabel("Last:", 44, 454, 27, 17)
$Label7 = GUICtrlCreateLabel("Average:", 44, 486, 47, 17)
$Label8 = GUICtrlCreateLabel("Best:", 44, 518, 28, 17)
$Label17 = GUICtrlCreateLabel("Run Time:", 44, 422, 53, 17)
$LabelTotalTime = GUICtrlCreateLabel("00:00:00", 124, 390, 80, 17)
$LabelLast = GUICtrlCreateLabel("00:00", 124, 454, 80, 17)
$LabelAverage = GUICtrlCreateLabel("00:00", 124, 486, 80, 17)
$LabelBest = GUICtrlCreateLabel("00:00", 124, 518, 80, 17)
$LabelRunTime = GUICtrlCreateLabel("00:00:00", 124, 422, 80, 17)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$GroupInfo = GUICtrlCreateGroup("Info", 260, 350, 200, 209)
$Label1 = GUICtrlCreateLabel("Succes Runs:", 274, 390, 76, 17)
$Label2 = GUICtrlCreateLabel("Fail Runs:", 274, 422, 51, 17)
$Label3 = GUICtrlCreateLabel("War Supplies:", 274, 454, 70, 17)
$Label4 = GUICtrlCreateLabel("Ectos:", 274, 486, 63, 17)
$LabelSuccesRuns = GUICtrlCreateLabel("-", 354, 390, 80, 17)
$LabelFailRuns = GUICtrlCreateLabel("-", 354, 422, 80, 17)
$LabelWarSupplies = GUICtrlCreateLabel("-", 354, 454, 80, 17)
$LabelEctos = GUICtrlCreateLabel("-", 346, 486, 80, 17)
$Label9 = GUICtrlCreateLabel("Gold:", 274, 518, 63, 17)
$LabelGold = GUICtrlCreateLabel("-", 354, 518, 80, 17)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$GroupStatus = GUICtrlCreateGroup("Bot Status", 30, 20, 200, 60)
$LabelStatusTitle = GUICtrlCreateLabel("Status:", 45, 44, 45, 17)
$LabelBotStatus = GUICtrlCreateLabel("Idle", 92, 44, 120, 17)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$GroupTCP = GUICtrlCreateGroup("TCP", 30, 200, 200, 130)
$ButtonConnectTCP = GUICtrlCreateButton("Connect", 45, 224, 170, 25)
$ButtonResetTCP = GUICtrlCreateButton("Reset", 45, 256, 170, 25)
$ButtonSomethingTCP = GUICtrlCreateButton("Something", 45, 288, 170, 25)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$LogBoxTCP = GUICtrlCreateEdit("", 260, 200, 200, 130, BitOR($GUI_SS_DEFAULT_EDIT,$ES_READONLY))
GUICtrlSetData(-1, "")
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

;~ Global $fLog = FileOpen("Keiran - Runner " & $CharName & ".log", 1) ;Log file
Global $CharacterName = $CmdLine[0] > 0 ? $CmdLine[1] : "Math Winning Games"
$g_s_MainCharName = $CharacterName
Global $WithStartup = $CmdLine[0] > 1 And $CmdLine[2] = "true"

Global $sServerIP = "127.0.0.1" ; vervang door jouw server IP
Global $iPort = 5055
Global $iSocket = -1
Global $lastPingReceived = 0

Global $gwpid = -1

Global $Sec = -1 ;Variable for Seconds ## Start at -1 to Update Time and Statistics once at Start
Global $Min = 0 ;Variable for Minutes
Global $Hour = 0 ;Variable for Hours
Global $Sec2 = 0 ;Variable for Seconds
Global $Min2 = 0 ;Variable for Minutes
Global $Hour2 = 0 ;Variable for Hours

Global $homMapId = 646
Global $eotnOutpostMapId = 642
Global $eotnOutpostWintersdayMapId = 821
Global $questMapId = 849

Global $mwaypoints[15][4] = [[9413, -7116, "1", 1250], [7526, -8410, "2", 1250], [4864, -8845, "3", 1250], [3438, -10528, "4", 1250], [2916, -11867, "5", 1250], [1749, -12765, "6", 1250], [266, -13059, "7", 1250], [-691, -12911, "8", 1250], [-2500, -11420, "9", 1250], [-4434, -12314, "10", 1250], [-6580, -9653, "11", 1250], [-10554, -8844, "12", 1250], [-12841, -8030, "13", 1250], [-15876, -8903, "14", 1250], [-17109, -8978, "Final Area 15", 1250]]

Global Enum $STATE_IDLE, $STATE_WAITCHARACTERSELECT, $STATE_ENTERQUEST, $STATE_RUNQUEST, $STATE_RESETQUEST, $STATE_HARDRESET, $STATE_BUYECTOS, $STATE_TRADE, $STATE_DISCONNECTED, $STATE_PAUSE, $STATE_ERROR
Global $BotState = $STATE_IDLE

Global $g_bRenderingEnabled = True

Global $g_iTotalRuns = 0
Global $g_iSuccessRuns = 0
Global $g_iFailRuns = 0
Global $g_iEctos = 0
Global $g_iEctosBought = 0
Global $g_iWarSupplies = 0
Global $g_iGold = 0
Global $g_tBotTotalTime = 0
Global $g_tBotRunTime = 0
Global $g_fLastRunTime = 0
Global $g_fBestRunTime = 0
Global $g_fAverageRunTime = 0

GUICtrlSetOnEvent($ButtonStart, "EventHandler")
GUICtrlSetOnEvent($ButtonDebug1, "EventHandler")
GUICtrlSetOnEvent($ButtonDebug2, "EventHandler")

;~ GUICtrlSetOnEvent($ButtonReduceMemory, "EventHandler")
GUICtrlSetOnEvent($CheckboxGraphics, "EventHandler")
;~ GUICtrlSetOnEvent($ButtonResetSocket, "EventHandler")
GUISetOnEvent($gui_event_close, "EventHandler")

; Try to establish a connection and send IDENTIFY
Func Tcp_Connect()
    $iSocket = TCPConnect($sServerIP, $iPort)
    If $iSocket = -1 Then Return False

    Return TCPSend($iSocket, "IDENTIFY|" & $g_s_MainCharName)
EndFunc

; Close socket safely
Func Tcp_Disconnect()
    If $iSocket <> -1 Then
        TCPCloseSocket($iSocket)
        $iSocket = -1
    EndIf
EndFunc

; Only checks and connects if socket is down – does NOT receive anything
Func Tcp_Heartbeat()
    If $iSocket = -1 Then
        Out("No connection, attempting reconnect...")
        If Tcp_Connect() Then
            Out("Connected to server.")
			$lastPingReceived = TimerInit()
        EndIf
	Else
        If TimerDiff($lastPingReceived) > 10000 Then
            Out("Server unresponsive. Closing socket.")
            TCPCloseSocket($iSocket)
            $iSocket = -1
        EndIf
    EndIf
EndFunc

; Reads and handles all available messages
Func Tcp_ProcessMessages()
    If $iSocket = -1 Then Return

    Local $sData = TCPRecv($iSocket, 1024)
    While $sData <> "" And @error = 0
        Local $sMsg = StringStripWS($sData, 3)
        Switch $sMsg
            Case "PING"
				$lastPingReceived = TimerInit()
                SendMessage("PONG")
            Case "STOP"
                Out("Received STOP")
            Case Else
                Out("Unknown message: " & $sMsg)
        EndSwitch

        $sData = TCPRecv($iSocket, 1024)
    WEnd
EndFunc

Func SendMessage($sMessage)
    If $iSocket = -1 Then
        Out("Cannot send message: not connected to server.")
        Return False
    EndIf

    Local $iResult = TCPSend($iSocket, $sMessage & @LF)
    If $iResult = 0 Then
        Out("Failed to send message. @error = " & @error)
        Return False
    EndIf

    Return True
EndFunc

If $WithStartup Then
	Do
		Sleep(500)
	Until IsString(Scanner_GetLoggedCharNames()) And Scanner_GetLoggedCharNames() <> ""

	Initialize()
EndIf

TCPStartup()

While 1
	If $BotState <> $STATE_IDLE Then
		HandleBotState()
	EndIf
	Sleep(250)
WEnd

;~ TCPShutdown()

Func EventHandler()
	Switch (@GUI_CtrlId)
		Case $ButtonStart
			Initialize()
		Case $CheckboxGraphics
			Ui_ToggleRendering_()
		Case $ButtonDebug1
			;~ If Core_Initialize("Math Winning Games", True) Then
			;~ 	Out("Core_Initialize successful")
			;~ Else
			;~ 	Out("Core_Initialize failed")
			;~ EndIf
			Local $json = '{"type":"identify","bot":"Bob Danaerys"}'
			Local $jsonBytes = BinaryToString($json, 4)
			Local $length = StringLen($jsonBytes)
		Case $ButtonDebug2
			Out("PreGame_FrameID: " & PreGame_FrameID())
			Out("PreGame_ChosenCharacterIndex: " & PreGame_ChosenCharacterIndex())
			Out("PreGame_ChosenCharacter: " & PreGame_ChosenCharacter())
			Out("PreGame_Index2: " & PreGame_Index2())
			Out("PreGame_LoginCharacterArray: " & PreGame_LoginCharacterArray())
			Out("PreGame_CharName 0: " & PreGame_CharName(0))
			Out("Scanner_ScanForCharname(): " & Scanner_ScanForCharname())
			Out("Scanner_GetLoggedCharNames(): " & Scanner_GetLoggedCharNames())
			;~ SetBotState($STATE_DISCONNECTED)
		Case $gui_event_close
			Exit
	EndSwitch
EndFunc

Func HandleBotState()
	If Map_GetInstanceInfo("IsLoading") And Agent_GetAgentPtr(-2) = 0 Then
		SetBotState($STATE_DISCONNECTED)
	EndIf

	If ShouldBuyEctos() And $BotState <> $STATE_BUYECTOS Then
		SetBotState($STATE_BUYECTOS)
	EndIf

	Switch $BotState
		Case $STATE_WAITCHARACTERSELECT
			If Step_WaitCharacterSelect() Then
				SetBotState($STATE_ENTERQUEST)
			Else
				SetBotState($STATE_ERROR)
			EndIf
		Case $STATE_ENTERQUEST
			If Step_EnterQuest() Then
				SetBotState($STATE_RUNQUEST)
			Else 
				SetBotState($STATE_RESETQUEST)
			EndIf
			Sleep(2000)
		Case $STATE_RUNQUEST
			If Step_RunQuest() Then
				SetBotState($STATE_ENTERQUEST)
			Else
				SetBotState($STATE_RESETQUEST)
			EndIf
		Case $STATE_RESETQUEST
			If Step_ResetQuest() Then
				SetBotState($STATE_ENTERQUEST)
			Else
				SetBotState($STATE_HARDRESET)
			EndIf
		Case $STATE_HARDRESET
			If Step_HardReset() Then
				SetBotState($STATE_ENTERQUEST)
			Else
				SetBotState($STATE_ERROR)
			EndIf
		Case $STATE_BUYECTOS
			If Step_BuyEctos() Then
				SetBotState($STATE_ENTERQUEST)
			Else
				SetBotState($STATE_ERROR)
			EndIf
		Case $STATE_DISCONNECTED
			Out("yuppp")
			If Step_Disconnected() Then
				SetBotState($STATE_ENTERQUEST)
			Else
				SetBotState($STATE_ERROR)
			EndIf
		Case $STATE_ERROR
			Out("Error: Bot encountered an error and is now in error state.")
			Sleep(60000)
	EndSwitch
EndFunc

Func Initialize()
	Out("Initializing..")
	GUICtrlSetData($ButtonStart, "Initializing...")
	GUICtrlSetState($ButtonStart, $gui_disable)
	If Core_Initialize($CharacterName, True) = 0 Then
		MsgBox(0, "Error", "Could not Find a Guild Wars client with a Character named '"&$CharacterName&"'")
		_Exit()
	EndIf
	Out("Done Initialize")
	WinSetTitle($Form, "", "Keiran - " & $CharacterName)
	GUICtrlSetData($ButtonStart, "Bot Started")
	$g_tBotTotalTime = TimerInit()
	AdlibRegister("UpdateTimersUI", 1000)
	UpdateStatsUI()
	TCPStartup()
	AdlibRegister("Tcp_Heartbeat", 2000)
	AdlibRegister("Tcp_ProcessMessages", 200)
	If (PreGame_FrameID() <> 0) Then ; If frameID <> 0, im still in characterSelect
		SetBotState($STATE_WAITCHARACTERSELECT) 
	Else
		;~ Friend_SetOfflineStatus()
		SetBotState($STATE_ENTERQUEST)
	EndIf
EndFunc

Func Step_WaitCharacterSelect() 
	Out("--Executing step: WaitCharacterSelect--")
	ControlSend(Core_GetGuildWarsWindow(), "", "", "{Enter}")
	If Not WaitMapLoading() Then Return False
	Sleep(2000)
	;~ Friend_SetOfflineStatus()
	Return True
EndFunc

Func Step_EnterQuest()
	Out("--Executing step: EnterQuest--")
	
	UpdateStatsUI()
	WaitMapLoading()
	Other_PingSleep(3000)
	If Not IsAlive() And Agent_GetAgentInfo(-2, "MaxHP") <> 0 Then ;Apparently HP is 0 when returning to outpost after resign, so maxHP checking aswell, its 0 if "still loading"
		Out("Step_EnterQuest(): Player is dead")
		Map_ReturnToOutpost()
		WaitMapLoading()
		Other_PingSleep(3000)
		Return False
	EndIf
	If Not EnsureAtHom() Then Return False
	If Not GoToScryingPool() Then Return False
	If Not TriggerQuestDialog() Then Return False

	$g_tBotRunTime = TimerInit()

	Return True
EndFunc

Func Step_RunQuest()
	Local $bSuccess = True

	Out("--Executing step: RunQuest--")
	WaitMapLoading()
	Sleep(2000)
	If Map_GetMapID() <> $questMapId Then
		Out("Trying to start quest in wrong map")
		Return False
	EndIf
	out("Started quest")
	MoveTo(11828, -4815, False) ; Move to the quest start point
	If Not WaitAndFight(1550, 50000)  Then $bSuccess = False
	If NOT RunWaypoints() Then $bSuccess = False
	If NOT WaitAndFight(1550, 50000) Then $bSuccess = False
	If Not WaitForAutoReturnToHom() Then $bSuccess = False

	If $bSuccess Then
		$g_iSuccessRuns += 1
		Out("Finished a run: " & FormatMsToTimeString(TimerDiff($g_tBotRunTime)))
		UpdateRunTimes()
		Ui_PurgeHook_()
	Else
		$g_iFailRuns += 1
	EndIf
		$g_iTotalRuns += 1
	Return $bSuccess
EndFunc

Func Step_ResetQuest()
	Local $antiBugTimer = TimerInit()

	Out("--Executing step: ResetQuest--")
	
	Do
		Out("Attempting to reset")
		Chat_SendChat("resign", '/')
		Other_PingSleep(2500)
		Map_ReturnToOutpost()
		WaitMapLoading()
		Other_PingSleep(3000)
	Until Map_GetMapID() = $homMapId or Map_GetMapID() = $eotnOutpostMapId or TimerDiff($antiBugTimer) > 30000
	If TimerDiff($antiBugTimer) > 30000 Then
		Out("ResetQuest FAILED: Timeout after 30s - could not return to HoM or EotN.")
		Return False
	EndIf
	If Map_GetMapID() = $homMapId Then
		Out("Reset complete: returned to HoM. Incrementing fail run counter.")
	EndIf
	If Map_GetMapID() = $eotnOutpostMapId Then
		Out("Reset complete: returned to EotN outpost.")
	EndIf
	Return True
EndFunc

Func Step_HardReset()
	Out("--Executing step: HardReset--")
	Map_TravelTo($eotnOutpostMapId)
	WaitMapLoading()
	Other_PingSleep(2000)
	If Map_GetMapID() <> $eotnOutpostMapId Then
		Out("HardReset failed: Not in EotN outpost after reset.")
		Return False
	EndIf

	Return True
EndFunc

Func Step_BuyEctos()
	Out("--Executing step: BuyEctos--")

	If Not ShouldBuyEctos() Then
		Out("Step_BuyEctos(): Skipped - Not enough gold.")
		Return True
	EndIf

	If Map_GetMapID() <> 178 Then
		Out("Traveling to Guild Hall...")
		Map_TravelGH()
		WaitMapLoading()
		Other_PingSleep(2000)
	EndIf
	If Not BuyEctosFromTrader() Then
		Out("Step_BuyEctos(): Failed to buy ectos.")
		Return False
	EndIf

	Return True
EndFunc

Func Step_Disconnected()
	Out("--Executing step: Disconnected--")
	If Not TryToReconnect() Then Return False

	Return True
EndFunc

Func EnsureAtHom()
	Local $retry = 0
	Local $maxRetries = 5
	Do
		If Map_GetMapID() <> $eotnOutpostMapId AND Map_GetMapID() <> $homMapId Then
			Out("Traveling To EotN")
			Map_TravelTo($eotnOutpostMapId)
			WaitMapLoading()
			Other_PingSleep(2000)
		EndIf
		If Map_GetMapID() = $eotnOutpostMapId Then
			Out("Entering HoM")
			If Not EnterHom() Then Return False
		EndIf
		$retry += 1
	Until Map_GetMapID() = $homMapId Or $retry >= $maxRetries

	If Map_GetMapID() <> $homMapId Then
		Out("EnsureAtHom() failed: Max retries (" & $maxRetries & ") reached without reaching HoM.")
		Return False
	EndIf
	Return True
EndFunc

Func GoToScryingPool()
	Out("Going To Scrying Pool")

	Local $target = GetAgentByPlayerNumber(5908)
	If $target = 0 Then
		Out("GoToScryingPool() failed: Could not find agent.")
		Return False
	EndIf

	If Not MoveToNPC($target, False) Then 
		Out("GoToScryingPool() failed: Could not go to NPC.")
		Return False
	EndIf

	Other_PingSleep(2000)

	Return True
EndFunc

Func TriggerQuestDialog()
	Local $retry = 0
	Local $maxRetries = 5

	Do
		Out("Triggering Quest Dialog, attempt " & ($retry + 1) & " of " & $maxRetries)
		Other_PingSleep(1000)
		Item_SwitchWeaponSet(3)
		Other_PingSleep(1500)
		Ui_Dialog(1598)
		Other_PingSleep(3000)
		$retry += 1
	Until Map_GetMapID() = $questMapId Or $retry >= $maxRetries
	If Map_GetMapID() <> $questMapId Then
		Out("TriggerQuestDialog() failed: Reached max retries (" & $maxRetries & ") without entering quest map (MapID: " & Map_GetMapID() & ", Expected: " & $questMapId & ").")
		Return False
	EndIf

	Return True
EndFunc

Func EnterHom()
	Local $bugTimer = TimerInit()

	If Map_GetMapID() <> $eotnOutpostMapId Then
		Out("EnterHom() failed: Not in EotN outpost.")
		Return False
	EndIf
	Do
		MoveTo(-3477, 4245, False, 40)
		MoveTo(-4060, 4675, False, 50)
		MoveTo(-4779, 5209, False, 0)
		WaitMapLoading()
		Other_PingSleep(2000)
	Until Map_GetMapID() = $homMapId Or TimerDiff($bugTimer) > 30000

	If Map_GetMapID() <> $homMapId Then
		Out("EnterHom() failed: Timeout after 30s without entering HoM.")
		Return False
	EndIf
	Return True
EndFunc

Func WaitForAutoReturnToHom()
	Local $tResetWait = TimerInit()
	Out("Waiting to return to HoM...")

	Do
		Survive()
		Sleep(100)
	Until Map_GetMapID() = $homMapId Or Not IsAlive() Or TimerDiff($tResetWait) > 30000

	WaitMapLoading()
	Other_PingSleep(2000) ; Give some time for the map to load

	If Map_GetMapID() = $homMapId Then
		Out("Returned to HoM successfully.")
		Return True
	EndIf
	If Not IsAlive() Then
		Out("WaitForAutoReturnToHom(): Player died")
		Return False
	Else
		Out("WaitForAutoReturnToHom(): Timeout (stuck in mission)")
		Return False
	EndIf
EndFunc

Func ShouldBuyEctos()
	Local $lgold = Item_GetInventoryInfo("GoldCharacter")
	Return $lgold >= 90000
EndFunc

Func BuyEctosFromTrader()
	Local $EctoID = 930
	Local $iBoughtCount = 0

	Out("Buying ectos from trader...")

	MoveTo(-853, 4501)
	Sleep(2000)

	Local $agent = GetAgentByPlayerNumber(205)
	If $agent = 0 Then
		Out("BuyEctosFromTrader(): Could not find Rare Material Trader.")
		Return False
	EndIf

	Agent_GoNPC($agent)
	Sleep(2000)

	Local $currentGold, $newGold
	Do
		$currentGold = Item_GetInventoryInfo("GoldCharacter")
		Merchant_BuyItem($EctoID, 1, True)
		Sleep(300)
		$newGold = Item_GetInventoryInfo("GoldCharacter")

		If $newGold < $currentGold Then
			$iBoughtCount += 1
		EndIf
	Until $newGold = $currentGold

	Out("Done buying ectos. Total bought this run: " & $iBoughtCount)
	Return True
EndFunc

Func RunWaypoints()
	Local $lx, $ly, $lmsg, $lrange
	For $i = 0 To 14
		$lx = $mwaypoints[$i][0]
		$ly = $mwaypoints[$i][1]
		$lmsg = $mwaypoints[$i][2]
		$lrange = $mwaypoints[$i][3]
		If IsString($lx) Then
			If Not Call($lx, $ly, $lmsg) Then return False
		Else
			If Not MoveAndSurvive($lx, $ly, $lmsg) Then Return False
		EndIf
	Next
	Return True
EndFunc

Func MoveAndSurvive($x, $y, $s = "")
	Local $tDisconnected = TimerInit()
	Local $iblocked = 0

	If $s <> "" Then out($s)
	Map_Move($x, $y, 50)
	Item_SwitchWeaponSet(0)
	Do
		If CheckForDisconnect($tDisconnected) Then
			SetBotState($STATE_DISCONNECTED)
			Return False
		EndIf
		Survive()
		Sleep(50)
		If Agent_GetAgentInfo(-2, "MoveX") = 0 And Agent_GetAgentInfo(-2, "MoveY") = 0 And Not Agent_GetAgentInfo(-2, "IsKnockedDown") And Not Agent_GetAgentInfo(-2, "IsCasting") Then
			$iblocked += 1
			Map_Move(Agent_GetAgentInfo(-2, "X"), Agent_GetAgentInfo(-2, "Y"), 600)
			Sleep(350)
			Map_Move($x, $y, 0)
			Out("Blocked and trying to get free - attempt: " & $iblocked)
		EndIf
		;~ If GetInstanceType() == 2 Then disconnected()
	Until ComputeDistance(Agent_GetAgentInfo(-2, "X"), Agent_GetAgentInfo(-2, "Y"), $x, $y) < 250 or $iblocked > 20 or Agent_GetAgentInfo(-2, "HP") <= 0
	If $iBlocked > 20 Then
		Out("MoveAndSurvive() failed: Too many block attempts.")
		Return False
	EndIf
	If Agent_GetAgentInfo(-2, "HP") <= 0 Then
		Out("MoveAndSurvive() failed: Agent is dead.")
		Return False
	EndIf
	Return True
EndFunc

Func Survive()
	If Agent_GetAgentInfo(-2, "HP") < 0.8 Or Agent_GetAgentInfo(-2, "IsHexed") Then
		If CanUseSkill(6, 2) Then
			Skill_UseSkill(6, -2)
			Return True
		EndIf
	EndIf
	if Agent_GetAgentEffectInfo(-2, 481, "HasEffect") Then ; Cripple
		Local $target = Agent_TargetNearestEnemy(1100)
		If $target <> 0 And CanUseSkill(5, 3) Then
			Item_SwitchWeaponSet(2)
			Skill_UseSkill(5, $target)
			Sleep(760)
			Item_SwitchWeaponSet(0)
		EndIf
	EndIf
	Local $enemiesInRange = GetEnemiesInRange(1300)
	
	For $target = 1 To $enemiesInRange[0]
		;check for bull's strike, water trident and melandru's shot
		If Agent_GetAgentInfo($target, "skill") = 332 OR Agent_GetAgentInfo($target, "skill") = 237 OR Agent_GetAgentInfo($target, "skill") = 853 Then
			Out("Survive() found a bull's strike, water trident or melandru's shot. Cancelling action.")
			Agent_CancelAction()
			sleep(250)
		EndIf
	Next
	Return False
EndFunc

Func CanUseSkill($askillslot, $aenergy = 0, $asoftcounter = 10)
	if Agent_GetAgentInfo(-2, "IsCasting") Then return False
	if Agent_GetAgentInfo(-2, "CurrentEnergy") < $aenergy Then Return False
	if Not Skill_GetSkillbarInfo($askillslot, "IsRecharged") Then return False
	; check for blind
	$hasBlind = Agent_GetAgentEffectInfo(-2, 479, "HasEffect")
	if $hasBlind AND $askillslot <> 5 AND $askillslot <> 6 Then Return False

	Return True
EndFunc

Func GetTarget($aEnemiesInRange)
	$target = 0
	For $i = 1 to 12
		For $j = 1 To $aEnemiesInRange[0]
			$agent = $aEnemiesInRange[$j]
			$agentPlayerNumber = Agent_GetAgentInfo($agent, "PlayerNumber")
			Switch $i
				Case 1
					If $agentPlayerNumber = 8114 OR $agentPlayerNumber = 8115 Then ;peacekeeper
						Return $agent
					EndIf
				Case 2
					If $agentPlayerNumber >= 8203 AND $agentPlayerNumber <= 8210 Then ;monk
						Return $agent
					EndIf
				Case 3
					If $agentPlayerNumber >= 8195 AND $agentPlayerNumber <= 8202 Then ;ele
						Return $agent
					EndIf
				Case 4
					If $agentPlayerNumber >= 8232 AND $agentPlayerNumber <=  8237 Then ;rit
						Return $agent
					EndIf
				Case 5
					If $agentPlayerNumber >= 8181 AND $agentPlayerNumber <= 8186 Then ;mes
						Return $agent
					EndIf
				Case 6
					If $agentPlayerNumber >= 8187 AND $agentPlayerNumber <= 8194 Then ;necro
						Return $agent
					EndIf
				Case 7
					If $agentPlayerNumber >= 8176 AND $agentPlayerNumber <= 8180 Then ;sin
						Return $agent
					EndIf
				Case 8
					If $agentPlayerNumber >= 8219 AND $agentPlayerNumber <= 8226 Then ;ranger
						Return $agent
					EndIf
				Case 9
					If $agentPlayerNumber >= 8228 AND $agentPlayerNumber <= 8231 Then ;dervish
						Return $agent
					EndIf
				Case 10
					If $agentPlayerNumber >= 8211 AND $agentPlayerNumber <= 8218 Then ;warr
						Return $agent
					EndIf
				Case 11
					If $agentPlayerNumber >= 8238 AND $agentPlayerNumber <= 8241 Then ;para
						Return $agent
					EndIf
				Case Else
					Return $agent
			EndSwitch
		Next
	Next
EndFunc

Func Fight($arange)
	Local $tDisconnected = TimerInit()
	Out("Fighting...")
	Local $ndeadlock = TimerInit()

	Do
		If CheckForDisconnect($tDisconnected) Then
			SetBotState($STATE_DISCONNECTED)
			Return False
		EndIf

		If Agent_GetAgentInfo(-2, "HP") <= 0 Then
			Out("Fight() aborted: player is dead.")
			Return False
		EndIf

		If TimerDiff($ndeadlock) > 120000 Then
			Out("Fight() failed: 2-minute timeout reached.")
			Return False
		EndIf

		Local $aEnemiesInRange = GetEnemiesInRange($arange)
		If $aEnemiesInRange[0] = 0 Then ExitLoop

		Local $target = GetTarget($aEnemiesInRange)
		If $target <> 0 Then
			CastEngine($target)
		EndIf

		Sleep(300)
	Until False

	Other_PingSleep(1000)
	Return True
EndFunc

Func CastEngine($target)
	Local $ldeadlock = TimerInit()
	If Cast($target) Then
		Do
			Sleep(50)
		Until TimerDiff($ldeadlock) > Other_GetPing() + 150
		Return True
	Else
		sleep(300)
	EndIf
EndFunc

Func Cast($target)
	If Agent_GetAgentInfo(-2, "HP") < 0.7 Then
		If CanUseSkill(6, 2) Then
			Skill_UseSkill(6, -2)
			Return True
		EndIf
	EndIf
	If Agent_GetAgentInfo(-2, "IsKnockedDown") Then
		Return False
	EndIf
	If Agent_GetAgentInfo(-2, "IsConditioned") Then
		If CanUseSkill(5, 3) Then
			Skill_UseSkill(5, $target)
			Return True
		EndIf
	EndIf
	; Wait for Miku's hex when she's in range
	If CanUseSkill(1, 2) Then
		$miku = GetAgentById(3) ;Miku
		
		If $miku <> 0 And Agent_GetDistance($miku, -2) <= 1100 Then
			Local $aEnemiesInRange = GetEnemiesInRange(1300)
			For $i = 1 To $aEnemiesInRange[0]
				If Agent_GetAgentInfo($aEnemiesInRange[$i], "IsHexed") Then
					Skill_UseSkill(1, $aEnemiesInRange[$i])
					Return True
				EndIf
			Next
		Else
			Skill_UseSkill(1, $target)
			Return True
		EndIf
	EndIf
	If CanUseSkill(3, 1) Then
		Skill_UseSkill(3, $target)
		Return True
	EndIf
	If CanUseSkill(4, 1) Then
		Skill_UseSkill(4, $target)
		Return True
	EndIf
	If CanUseSkill(2, 2) Then
		Skill_UseSkill(2, $target)
		Return True
	EndIf
	Return False
EndFunc

Func WaitAndFight($adist, $iideadlock)
	Local $tDisconnected = TimerInit()
	Local $target, $ldistance
	Local $tStart = TimerInit()
	Out("WaitAndFight(): Waiting for enemies...")

	Do
		If CheckForDisconnect($tDisconnected) Then
			SetBotState($STATE_DISCONNECTED)
			Return False
		EndIf

		$target = Agent_TargetNearestEnemy()
		$ldistance = Agent_GetDistance($target, -2)

		If $ldistance < $adist Then
			Item_SwitchWeaponSet(2)
			If Not Fight(1300) Then Return False
			Item_SwitchWeaponSet(0)
			Out("WaitAndFight(): Enemy encountered and fight finished.")
			Return True
		EndIf

		If Agent_GetAgentInfo(-2, "HP") <= 0 Then
			Out("WaitAndFight(): Player died during wait.")
			Return False
		EndIf

		Sleep(300)
	Until TimerDiff($tStart) > $iideadlock

	Out("WaitAndFight(): Timeout after " & ($iideadlock / 1000) & " seconds.")
	Return False
EndFunc

Func SetBotState($newState)
	If $BotState = $STATE_DISCONNECTED Then
		If $newState = $STATE_ENTERQUEST Then
			If Agent_GetAgentPtr(-2) = 0 Or Map_GetInstanceInfo("IsLoading") Then Return
		ElseIf $newState <> $STATE_ERROR Then
			Return
		EndIf
	EndIf

	$BotState = $newState
	UpdateBotStatusLabel($newState)
	SendMessage("STATE|" & $newState)
EndFunc

Func UpdateBotStatusLabel($state)
	Local $sText = ""

	Switch $state
		Case $STATE_IDLE
			$sText = "Idle"
		Case $STATE_ENTERQUEST
			$sText = "Entering Quest"
		Case $STATE_RUNQUEST
			$sText = "Running Quest"
		Case $STATE_RESETQUEST
			$sText = "Resetting Quest"
		Case $STATE_HARDRESET
			$sText = "Hard Reset"
		Case $STATE_BUYECTOS
			$sText = "Buying Ectos"
		Case $STATE_TRADE
			$sText = "Trading"
		Case $STATE_DISCONNECTED
			$sText = "Disconnected"
		Case $STATE_PAUSE
			$sText = "Paused"
		Case $STATE_ERROR
			$sText = "Error"
		Case Else
			$sText = "Unknown"
	EndSwitch

	GUICtrlSetData($LabelBotStatus, $sText)
EndFunc

Func UpdateStatsUI()
    $g_iWarSupplies = CountItemInInventory(35121) ; War Supplies
    $g_iEctos = CountItemInInventory(930)         ; Ectos
    $g_iGold = Item_GetInventoryInfo("GoldCharacter")

    GUICtrlSetData($LabelWarSupplies, $g_iWarSupplies & " (" & Round($g_iWarSupplies / 250, 2) & ")")
    GUICtrlSetData($LabelEctos, $g_iEctos & " (" & Round($g_iEctos / 250, 2) & ")")
    GUICtrlSetData($LabelGold, $g_iGold)
    GUICtrlSetData($LabelSuccesRuns, $g_iSuccessRuns)
    GUICtrlSetData($LabelFailRuns, $g_iFailRuns)
EndFunc

Func UpdateTimersUI()
    GUICtrlSetData($LabelTotalTime, FormatMsToTimeString(TimerDiff($g_tBotTotalTime)))
    If $g_tBotRunTime <> 0 Then
		GUICtrlSetData($LabelRunTime, FormatMsToTimeString(TimerDiff($g_tBotRunTime)))
	EndIf
	If $g_fLastRunTime <> 0 Then
		GUICtrlSetData($LabelLast, FormatMsToTimeString($g_fLastRunTime))
	EndIf
	If $g_fAverageRunTime <> 0 Then
		GUICtrlSetData($LabelAverage, FormatMsToTimeString($g_fAverageRunTime))
	EndIf
	If $g_fBestRunTime <> 0 Then
		GUICtrlSetData($LabelBest, FormatMsToTimeString($g_fBestRunTime))
	EndIf
EndFunc

Func UpdateRunTimes()
	If $g_tBotRunTime = 0 Then Return

	$g_fLastRunTime = TimerDiff($g_tBotRunTime)

	If $g_fBestRunTime = 0 Or $g_fLastRunTime < $g_fBestRunTime Then
		$g_fBestRunTime = $g_fLastRunTime
	EndIf

	If $g_iSuccessRuns > 1 Then
		$g_fAverageRunTime = (($g_fAverageRunTime * ($g_iSuccessRuns - 1)) + $g_fLastRunTime) / $g_iSuccessRuns
	Else
		$g_fAverageRunTime = $g_fLastRunTime
	EndIf
EndFunc

Func CountItemInInventory($iTargetModelID)
	Local $iBagItems, $pItem, $iModelID, $iQuantity, $iTotalQuantity

	For $iBag = 1 To 4
		Local $aItems = Item_GetBagItemArray($iBag)
		If Not IsArray($aItems) Then ContinueLoop

		$iBagItems = $aItems[0]
		For $iSlot = 1 To $iBagItems
			$pItem = Item_GetItemBySlot($iBag, $iSlot)
			If $pItem = 0 Then ContinueLoop
			$iModelID = Item_GetItemInfoByPtr($pItem, "ModelID")
			If $iModelID = $iTargetModelID Then
				$iQuantity = Item_GetItemInfoByPtr($pItem, "Quantity")
				$iTotalQuantity += $iQuantity
			EndIf
		Next
	Next

	Return $iTotalQuantity
EndFunc

Func Out($aString)
	;~ FileWriteLine($fLog, @HOUR & ":" & @MIN & " - " & $aString)
	ConsoleWrite(@HOUR & ":" & @MIN & " - " & $aString & @CRLF)
	GUICtrlSetData($LogBox, GUICtrlRead($LogBox) & @HOUR & ":" & @MIN & " - " & $aString & @CRLF)
	_GUICtrlEdit_Scroll($LogBox, 4)
EndFunc   ;==>Out

Func FormatMsToTimeString($iMilliseconds)
	Local $iSec = Int(Mod($iMilliseconds / 1000, 60))
	Local $iMin = Int(Mod($iMilliseconds / 60000, 60))
	Local $iHourTotal = Int($iMilliseconds / 3600000)
	Local $iDays = Int($iHourTotal / 24)
	Local $iHour = Mod($iHourTotal, 24)

	If $iDays > 0 Then
		Return StringFormat("%dd %02d:%02d:%02d", $iDays, $iHour, $iMin, $iSec)
	Else
		Return StringFormat("%02d:%02d:%02d", $iHour, $iMin, $iSec)
	EndIf
EndFunc

Func OutAllAgentProperties($agentPtr)
    Local $properties[] = [ _
        "vtable", "h0004", "h0008", "h000C", "h0010", "Timer", "Timer2", "h0018", "ID", "Z", _
        "Width1", "Height1", "Width2", "Height2", "Width3", "Height3", "Rotation", "RotationCos", "RotationSin", _
        "NameProperties", "Ground", "h0060", "TerrainNormalX", "TerrainNormalY", "TerrainNormalZ", "h0070", "X", "Y", "Plane", "h0080", _
        "NameTagX", "NameTagY", "NameTagZ", "VisualEffects", "h0092", "h0094", "Type", "IsItemType", "IsGadgetType", "IsLivingType", _
        "MoveX", "MoveY", "h00A8", "RotationCos2", "RotationSin2", "h00B4", "Owner", "CanPickUp", "ItemID", "ExtraType", "GadgetID", _
        "h00D4", "AnimationType", "h00E4", "AttackSpeed", "AttackSpeedModifier", "PlayerNumber", "AgentModelType", "TransmogNpcId", _
        "Equipment", "h0100", "Tags", "h0108", "Primary", "Secondary", "Level", "Team", "h010E", "h0110", "EnergyRegen", "Overcast", _
        "EnergyPercent", "MaxEnergy", "CurrentEnergy", "h0124", "HPPips", "h012C", "HP", "MaxHP", "CurrentHP", "Effects", "EffectCount", _
        "BuffCount", "IsBleeding", "IsConditioned", "IsCrippled", "IsDead", "IsDeepWounded", "IsPoisoned", "IsEnchanted", "IsDegenHexed", _
        "IsHexed", "IsWeaponSpelled", "h013C", "Hex", "h0141", "ModelState", "IsKnockedDown", "IsMoving", "IsAttacking", "IsCasting", _
        "IsIdle", "TypeMap", "InCombatStance", "HasQuest", "IsDeadByTypeMap", "IsFemale", "HasBossGlow", "IsHidingCap", _
        "CanBeViewedInPartyWindow", "IsSpawned", "IsBeingObserved", "h015C", "InSpiritRange", "VisibleEffectsPtr", "VisibleEffectsPrevLink", _
        "VisibleEffectsNextNode", "VisibleEffectCount", "HasVisibleEffects", "h017C", "LoginNumber", "IsPlayer", "IsNPC", "AnimationSpeed", _
        "AnimationCode", "AnimationId", "h0190", "LastStrike", "Allegiance", "WeaponType", "Skill", "h01B6", "WeaponItemType", _
        "OffhandItemType", "WeaponItemId", "OffhandItemId", "Name" _
    ]
    For $i = 0 To UBound($properties) - 1
        Local $val = Agent_GetAgentInfo($agentPtr, $properties[$i])
        Out($properties[$i] & " = " & $val)
    Next
EndFunc

Func MoveToNPC($target, $block = True)
	Local $tDisconnected = TimerInit()
	Local $lMapLoading = Map_GetInstanceInfo("IsLoading"), $lMapLoadingOld
	Local $lBlocked = 0

	Agent_GoNPC($target)

	Do
		Sleep(100)

		If CheckForDisconnect($tDisconnected) Then
			SetBotState($STATE_DISCONNECTED)
			Return False
		EndIf

		If Agent_GetAgentInfo(-2, "HP") <= 0 Then
			Out("MoveToNPC() aborted: player is dead.")
			Agent_CancelAction()
			Return False
		EndIf

		$lMapLoadingOld = $lMapLoading
		$lMapLoading = Map_GetInstanceInfo("IsLoading")
		If $lMapLoading <> $lMapLoadingOld Then
			Out("MoveToNPC() interrupted: map loading detected.")
			Agent_CancelAction()
			Return False
		EndIf

		If $block = True Then
			If Agent_GetAgentInfo(-2, "MoveX") == 0 And Agent_GetAgentInfo(-2, "MoveY") == 0 Then
				$lBlocked += 1
				Out("blocked"& $lBlocked)
				Map_Move(Agent_GetAgentInfo(-2, "X"), Agent_GetAgentInfo(-2, "Y"), 100)
				Other_PingSleep(50)
				Agent_GoNPC($target)
			EndIf

			If $lBlocked > 14 Then
				Out("MoveToNPC() failed: stuck trying to reach NPC.")
				Return False
			EndIf
		Else
			Agent_GoNPC($target)
		EndIf
		
	Until Agent_GetDistance(-2, $target) < 150

	Return True
EndFunc

Func MoveTo($x, $y, $antiBlock = True, $range = 150, $random = 50)
	Local $tDisconnected = TimerInit()
	Local $lBlocked = 0
	Local $lMapLoading = Map_GetInstanceInfo("IsLoading"), $lMapLoadingOld

	Local $targetX = $x + Random(-$random, $random)
	Local $targetY = $y + Random(-$random, $random)

	Map_Move($targetX, $targetY, 0)

	Do
		Sleep(100)

		If CheckForDisconnect($tDisconnected) Then
			SetBotState($STATE_DISCONNECTED)
			Return False
		EndIf

		Local $myX = Agent_GetAgentInfo(-2, "X")
		Local $myY = Agent_GetAgentInfo(-2, "Y")

		$lMapLoadingOld = $lMapLoading
		$lMapLoading = Map_GetInstanceInfo("IsLoading")
		If $lMapLoading <> $lMapLoadingOld Then
			Agent_CancelAction()

			Return 
		EndIf

		If Agent_GetAgentInfo(-2, "HP") <= 0 Then
			Out("MoveTo() aborted: player is dead.")
			Return
		EndIf
		If $antiBlock = True Then
			If Not Map_GetInstanceInfo("IsLoading") And Agent_GetAgentInfo(-2, "MoveX") = 0 And Agent_GetAgentInfo(-2, "MoveY") = 0 Then
				$lBlocked += 1
				If $lBlocked > 14 Then
					Out("MoveTo() failed: stuck trying to move.")
					Return False
				EndIf
				Sleep(250)
				$targetX = $x + Random(-$random, $random)
				$targetY = $y + Random(-$random, $random)
				Out("Blocked at " & $myX & ", " & $myY & ". Trying to move to " & $targetX & ", " & $targetY)
				Map_Move($targetX, $targetY, 0)
			EndIf
		Else
			Map_Move($targetX, $targetY, 0)
		EndIf
		
	Until ComputeDistance($myX, $myY, $targetX, $targetY) < $range

	Return True
EndFunc

Func GetAgentByPlayerNumber($playerNumber)
	$agentPtrsArray = Agent_GetAgentArray()
    Local $count = $agentPtrsArray[0]
    For $i = 1 To $count
        Local $ptr = $agentPtrsArray[$i]
        Local $curPlayerNumber = Agent_GetAgentInfo($ptr, "PlayerNumber")
        If $curPlayerNumber = $playerNumber Then
            Return $ptr
        EndIf
    Next
	Out("Agent with PlayerNumber " & $playerNumber & " not found.")
    Return 0
EndFunc

Func GetAgentById($agentId)
	$agentPtrsArray = Agent_GetAgentArray()
    Local $count = $agentPtrsArray[0]
    For $i = 1 To $count
        Local $ptr = $agentPtrsArray[$i]
        Local $cur = Agent_GetAgentInfo($ptr, "ID")
        If $cur = $agentId Then
            Return $ptr
        EndIf
    Next
    Return 0
EndFunc

;~ Description: Returns the distance between two coordinate pairs.
Func ComputeDistance($aX1, $aY1, $aX2, $aY2)
	Return Sqrt(($aX1 - $aX2) ^ 2 + ($aY1 - $aY2) ^ 2)
EndFunc   ;==>ComputeDistance

Func GetEnemiesInRange($range)
	Local $agentsInRange[1] = [0]
	Local $agentPtrsArray = Agent_GetAgentArray()
	
	If Not IsArray($agentPtrsArray) Or UBound($agentPtrsArray) < 1 Then Return $agentsInRange
	Local $count = $agentPtrsArray[0]

	For $i = 1 To $count
		Local $agentPtr = $agentPtrsArray[$i]
		If $agentPtr = 0 Then ContinueLoop
		If Agent_GetAgentInfo($agentPtr, "HP") <= 0 Then ContinueLoop
		If Agent_GetAgentInfo($agentPtr, "Allegiance") <> 3 Then ContinueLoop ;
		If Agent_GetDistance($agentPtr, -2) <= $range Then
			$agentsInRange[0] += 1
			ReDim $agentsInRange[$agentsInRange[0] + 1]
			$agentsInRange[$agentsInRange[0]] = $agentPtr
		EndIf
	Next

	Return $agentsInRange
EndFunc

Func IsAlive()
	Return Agent_GetAgentInfo(-2, "HP") > 0
EndFunc

Func TryToReconnect()
	Local $maxRetries = 3
	Local $retry = 0
	Local $reconnected = False

	Out("Disconnected detected. Attempting to reconnect...")

	While $retry < $maxRetries And Not $reconnected
		Out("Reconnect attempt #" & ($retry + 1))
		ControlSend(Core_GetGuildWarsWindow(), "", "", "{Enter}")

		Local $tStart = TimerInit()
		Do
			Sleep(200)
			$reconnected = Map_GetInstanceInfo("IsLoading") = False And Agent_GetAgentPtr(-2) <> 0
		Until $reconnected Or TimerDiff($tStart) > 60000

		If Not $reconnected Then
			Out("Reconnect attempt #" & ($retry + 1) & " failed.")
			$retry += 1
		EndIf
	WEnd

	If $reconnected Then
		Out("Reconnected successfully.")
		Sleep(5000)
		Return True
	Else
		Out("All reconnect attempts failed. Exiting bot.")
		$BotState = $STATE_ERROR
	EndIf
EndFunc

Func CheckForDisconnect(ByRef $tRef, $timeout = 30000)
	If Map_GetInstanceInfo("IsLoading") And Agent_GetAgentPtr(-2) = 0 Then
		If TimerDiff($tRef) > $timeout Then
			SetBotState($STATE_DISCONNECTED)
			Return True
		EndIf
	Else
		$tRef = TimerInit()
	EndIf
	Return False
EndFunc

Func WaitMapLoading($a_i_MapID = -1, $a_i_InstanceType = -1, $iTimeoutMs = 10000)
	Local $tStart = TimerInit()

	Do
		Sleep(250)

		If Game_GetGameInfo("IsCinematic") Then
			Cinematic_SkipCinematic()
			Sleep(1000)
		EndIf

		If TimerDiff($tStart) > $iTimeoutMs Then
			SetBotState($STATE_DISCONNECTED)
			Return False
		EndIf

	Until Agent_GetAgentPtr(-2) <> 0 And Agent_GetMaxAgents() <> 0 And World_GetWorldInfo("SkillbarArray") <> 0 And Party_GetPartyContextPtr() <> 0 _
		And ($a_i_InstanceType = -1 Or Map_GetInstanceInfo("Type") = $a_i_InstanceType) _
		And ($a_i_MapID = -1 Or Map_GetCharacterInfo("MapID") = $a_i_MapID) _
		And Not Game_GetGameInfo("IsCinematic")

	Return True
EndFunc