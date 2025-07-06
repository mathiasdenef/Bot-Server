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
$Form = GUICreate("Keiran Runner", 462, 597, -1, -1)
$LogBox = GUICtrlCreateEdit("", 19, 449, 426, 142, BitOR($ES_AUTOVSCROLL,$ES_AUTOHSCROLL,$ES_READONLY,$ES_WANTRETURN))
GUICtrlSetData(-1, "")
$ButtonStart = GUICtrlCreateButton("Start", 49, 408, 378, 30)
$LabelTotalTime = GUICtrlCreateLabel("00:00:00", 120, 224, 100, 17)
$LabelLast = GUICtrlCreateLabel("00:00", 120, 288, 100, 17)
$LabelAverage = GUICtrlCreateLabel("00:00", 120, 320, 100, 17)
$LabelBest = GUICtrlCreateLabel("00:00", 120, 352, 100, 17)
$LabelRunTime = GUICtrlCreateLabel("00:00:00", 120, 256, 100, 17)
$CheckboxGraphics = GUICtrlCreateCheckbox("Disable Graphics", 40, 24, 97, 17)
$CheckboxTest = GUICtrlCreateCheckbox("Test", 216, 24, 97, 17)
$Group1 = GUICtrlCreateGroup("Times", 26, 184, 193, 209)
$Label5 = GUICtrlCreateLabel("Total Time:", 40, 224, 70, 17)
$Label6 = GUICtrlCreateLabel("Last:", 40, 288, 27, 17)
$Label7 = GUICtrlCreateLabel("Average:", 40, 320, 47, 17)
$Label8 = GUICtrlCreateLabel("Best:", 40, 352, 28, 17)
$Label17 = GUICtrlCreateLabel("Run Time:", 40, 256, 53, 17)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Group2 = GUICtrlCreateGroup("Info", 258, 184, 193, 209)
$Label1 = GUICtrlCreateLabel("Succes Runs:", 272, 224, 76, 17)
$Label2 = GUICtrlCreateLabel("Fail Runs:", 272, 256, 51, 17)
$Label3 = GUICtrlCreateLabel("War Supplies:", 272, 288, 70, 17)
$Label4 = GUICtrlCreateLabel("Total Ecto's:", 272, 320, 63, 17)
$LabelSuccesRuns = GUICtrlCreateLabel("-", 352, 224, 50, 17)
$LabelFailRuns = GUICtrlCreateLabel("-", 352, 256, 50, 17)
$LabelWarSupplies = GUICtrlCreateLabel("-", 352, 288, 50, 17)
$LabelTotalEctos = GUICtrlCreateLabel("-", 352, 320, 50, 17)
$Label9 = GUICtrlCreateLabel("Total Gold:", 272, 352, 63, 17)
$LabeltotalGold = GUICtrlCreateLabel("-", 352, 352, 50, 17)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$ButtonResetSocket = GUICtrlCreateButton("Reset Socket", 25, 64, 194, 30)
$CheckboxTrade = GUICtrlCreateCheckbox("Trade", 352, 24, 97, 17)
$ButtonReduceMemory = GUICtrlCreateButton("Reduce Memory", 25, 128, 194, 30)
$LogBoxTCP = GUICtrlCreateEdit("", 256, 56, 193, 118, BitOR($ES_AUTOVSCROLL,$ES_AUTOHSCROLL,$ES_READONLY,$ES_WANTRETURN))
;~ $CharacterName = $CmdLine[1]
$CharacterName = "Math Winning Games"
GUICtrlSetData(-1, "")
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###
;~ Global $fLog = FileOpen("Keiran - Runner " & $CharName & ".log", 1) ;Log file
Global $BotActive = False
Global $gwpid = -1

Global $me = GwAu3_Agent_GetAgentInfo()

Global $Sec = -1 ;Variable for Seconds ## Start at -1 to Update Time and Statistics once at Start
Global $Min = 0 ;Variable for Minutes
Global $Hour = 0 ;Variable for Hours
Global $Sec2 = 0 ;Variable for Seconds
Global $Min2 = 0 ;Variable for Minutes
Global $Hour2 = 0 ;Variable for Hours
Global $isRunning = false
Global $runIsSuccessful = False

Global $totalruns = 0
Global $warsupplies = 0
Global $successruns = 0
Global $failruns = 0
Global $totalectos = 0

Global $runTime = TimerInit()
Global $AllRunTimes = -1
Global $BestRunTime = 0

Global $homMapId = 646
Global $eotnOutpostMapId = 642
Global $eotnOutpostWintersdayMapId = 821
Global $questMapId = 849

Global $rendering = True

Global $enemiesInRange
Global $alliesAll
;~ Global $target

Global $mwaypoints[15][4] = [[9413, -7116, "1", 1250], [7526, -8410, "2", 1250], [4864, -8845, "3", 1250], [3438, -10528, "4", 1250], [2916, -11867, "5", 1250], [1749, -12765, "6", 1250], [266, -13059, "7", 1250], [-691, -12911, "8", 1250], [-2500, -11420, "9", 1250], [-4434, -12314, "10", 1250], [-6580, -9653, "11", 1250], [-10554, -8844, "12", 1250], [-12841, -8030, "13", 1250], [-15876, -8903, "14", 1250], [-17109, -8978, "Final Area 15", 1250]]

Global $serverSocket = Null
Global $goTrade
Global $bTradeItemsAndEctos
Global $heartBeatTimer

Global Enum $STATE_IDLE, $STATE_INITIALIZE, $STATE_ENTERQUEST, $STATE_RUNQUEST, $STATE_RESETQUEST, $STATE_HARDRESET, $STATE_BUY, $STATE_TRADE, $STATE_DISCONNECTED, $STATE_PAUSE, $STATE_ERROR, $STATE_UPDATESTATS
Global $BotState = $STATE_IDLE

GUICtrlSetOnEvent($ButtonStart, "EventHandler")
GUICtrlSetOnEvent($ButtonReduceMemory, "EventHandler")
GUICtrlSetOnEvent($CheckboxGraphics, "EventHandler")
GUICtrlSetOnEvent($CheckboxTrade, "EventHandler")
GUICtrlSetOnEvent($ButtonResetSocket, "EventHandler")
GUISetOnEvent($gui_event_close, "EventHandler")

While 1
	If $BotState <> $STATE_IDLE Then
		HandleBotState()
	EndIf
	Sleep(250)
WEnd

Func EventHandler()
	Switch (@GUI_CtrlId)
		Case $ButtonStart
			$BotState = $STATE_INITIALIZE
		Case $ButtonResetSocket
			Out("stopped bot")
			$BotState = $STATE_ERROR
		Case $CheckboxGraphics
			clearmemory()
			togglerendering()
		Case $ButtonReduceMemory
			GetNearestEnemyInRange(1100)
			Out(GetNearestEnemyInRange(1100))
		Case $CheckboxTest
			clearmemory()
		Case $CheckboxTrade
			$bTradeItemsAndEctos = Not $bTradeItemsAndEctos ;flip boolean
		Case $gui_event_close
			Exit
	EndSwitch
EndFunc

Func HandleBotState()
	Switch $BotState
		Case $STATE_INITIALIZE
			Step_Initialize()
		Case $STATE_ENTERQUEST
			If Step_EnterQuest() Then
				$BotState = $STATE_RUNQUEST
			Else 
				$BotState = $STATE_RESETQUEST
			EndIf
			Sleep(2000)
		Case $STATE_RUNQUEST
			If Step_RunQuest() Then
				$BotState = $STATE_ENTERQUEST
			Else
				$BotState = $STATE_RESETQUEST
				Return
			EndIf
		Case $STATE_RESETQUEST
			If Step_ResetQuest() Then
				$BotState = $STATE_ENTERQUEST
			Else
				$BotState = $STATE_HARDRESET
			EndIf
		Case $STATE_HARDRESET
			If Step_HardReset() Then
				$BotState = $STATE_ENTERQUEST
			Else
				$BotState = $STATE_ERROR
			EndIf
		Case $STATE_UPDATESTATS
			Out("Step: UpdateStatistics")
			UpdateStatistics()
			$BotState = $STATE_INITIALIZE

		Case $STATE_ERROR
			Out("Error: Bot encountered an error and is now in error state.")
			Sleep(60000)
	EndSwitch
EndFunc

Func Step_Initialize()
	Out("--Executing step: Initialize--")
	Out("Start Initialize")
	GUICtrlSetData($ButtonStart, "Initializing...")
	GUICtrlSetState($ButtonStart, $gui_disable)
	If GwAu3_Core_Initialize($CharacterName, True) = 0 Then
		MsgBox(0, "Error", "Could not Find a Guild Wars client with a Character named '"&$CharacterName&"'")
		_Exit()
	EndIf
	Out("Done Initialize")
	WinSetTitle($Form, "", "Keiran - " & $CharacterName)
	GUICtrlSetData($ButtonStart, "Bot Started")
	$BotState = $STATE_ENTERQUEST
EndFunc

Func Step_EnterQuest()
	Out("--Executing step: EnterQuest--")

	If Not IsAlive() Then
		Out("Step_EnterQuest(): Player is dead")
		GwAu3_Map_ReturnToOutpost()
		GwAu3_Map_WaitMapLoading()
		GwAu3_Other_PingSleep(3000)
		Return False
	EndIf
	If Not EnsureAtHom() Then Return False
	If Not GoToScryingPool() Then Return False
	If Not TriggerQuestDialog() Then Return False

	Return True
EndFunc

Func Step_RunQuest()
	Out("--Executing step: RunQuest--")
	GwAu3_Map_WaitMapLoading()
	Sleep(2000)
	If GwAu3_Map_GetMapID() <> $questMapId Then
		Out("Trying to start quest in wrong map")
		Return False
	EndIf
	out("Started quest")
	MoveTo(11828, -4815, False) ; Move to the quest start point
	If Not WaitAndFight(1550, 50000) Then
		$runIsSuccessful = False
		return False
	EndIf
	If NOT RunWaypoints() Then
		$runIsSuccessful = False
		Return False
	EndIf
	If NOT WaitAndFight(1550, 50000) Then
		$runIsSuccessful = False
		return False
	EndIf
	
	If Not WaitForAutoReturnToHom() Then
		$runIsSuccessful = False
		Return False
	EndIf

	Local $elapsedMs = TimerDiff($runTime)
	Local $mins = Int($elapsedMs / 60000)
	Local $secs = Int(Mod($elapsedMs, 60000) / 1000)
	Out("Finished a cycle in " & $mins & ":" & StringFormat("%02d", $secs) & " minutes.")

	Return True
EndFunc

Func Step_ResetQuest()
	Local $antiBugTimer = TimerInit()

	Out("--Executing step: ResetQuest--")
	
	Do
		Out("Attempting to reset")
		GwAu3_Chat_SendChat("resign", '/')
		GwAu3_Other_PingSleep(2500)
		GwAu3_Map_ReturnToOutpost()
		GwAu3_Map_WaitMapLoading()
		GwAu3_Other_PingSleep(3000)
	Until GwAu3_Map_GetMapID() = $homMapId or GwAu3_Map_GetMapID() = $eotnOutpostMapId or TimerDiff($antiBugTimer) > 30000
	If TimerDiff($antiBugTimer) > 30000 Then
		Out("ResetQuest FAILED: Timeout after 30s - could not return to HoM or EotN.")
		Return False
	EndIf
	If GwAu3_Map_GetMapID() = $homMapId Then
		Out("Reset complete: returned to HoM. Incrementing fail run counter.")
		$failruns += 1
	EndIf
	If GwAu3_Map_GetMapID() = $eotnOutpostMapId Then
		Out("Reset complete: returned to EotN outpost.")
	EndIf
	Return True
EndFunc

Func Step_HardReset()
	Out("--Executing step: HardReset--")
	GwAu3_Map_TravelTo($eotnOutpostMapId)
	GwAu3_Map_WaitMapLoading()
	GwAu3_Other_PingSleep(2000)
	If GwAu3_Map_GetMapID() <> $eotnOutpostMapId Then
		Out("HardReset failed: Not in EotN outpost after reset.")
		Return False
	EndIf

	Return True
EndFunc

Func EnsureAtHom()
	Local $retry = 0
	Local $maxRetries = 5
	Do
		If GwAu3_Map_GetMapID() <> $eotnOutpostMapId AND GwAu3_Map_GetMapID() <> $homMapId Then
			Out("Traveling To EotN")
			GwAu3_Map_TravelTo($eotnOutpostMapId)
			GwAu3_Map_WaitMapLoading()
			GwAu3_Other_PingSleep(2000)
		EndIf
		If GwAu3_Map_GetMapID() = $eotnOutpostMapId Then
			Out("Entering HoM")
			If Not EnterHom() Then Return False
		EndIf
		$retry += 1
	Until GwAu3_Map_GetMapID() = $homMapId Or $retry >= $maxRetries

	If GwAu3_Map_GetMapID() <> $homMapId Then
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

	GwAu3_Other_PingSleep(2000)

	Return True
EndFunc

Func TriggerQuestDialog()
	Local $retry = 0
	Local $maxRetries = 5

	Do
		Out("Triggering Quest Dialog, attempt " & ($retry + 1) & " of " & $maxRetries)
		GwAu3_Other_PingSleep(1000)
		GwAu3_Item_SwitchWeaponSet(3)
		GwAu3_Other_PingSleep(1500)
		GwAu3_Ui_Dialog(1598)
		GwAu3_Other_PingSleep(3000)
		$retry += 1
	Until GwAu3_Map_GetMapID() = $questMapId Or $retry >= $maxRetries
	If GwAu3_Map_GetMapID() <> $questMapId Then
		Out("TriggerQuestDialog() failed: Reached max retries (" & $maxRetries & ") without entering quest map (MapID: " & GwAu3_Map_GetMapID() & ", Expected: " & $questMapId & ").")
		Return False
	EndIf

	Return True
EndFunc

Func EnterHom()
	Local $bugTimer = TimerInit()

	If GwAu3_Map_GetMapID() <> $eotnOutpostMapId Then
		Out("EnterHom() failed: Not in EotN outpost.")
		Return False
	EndIf
	Do
		MoveTo(-3477, 4245, False, 40)
		MoveTo(-4060, 4675, False, 50)
		MoveTo(-4779, 5209, False, 0)
		GwAu3_Map_WaitMapLoading()
		GwAu3_Other_PingSleep(2000)
	Until GwAu3_Map_GetMapID() = $homMapId Or TimerDiff($bugTimer) > 30000

	If GwAu3_Map_GetMapID() <> $homMapId Then
		Out("EnterHom() failed: Timeout after 30s without entering HoM.")
		Return False
	EndIf
	Return True
EndFunc

Func main()
	;~ clearmemory()
	;~ TradeItemsAndEctos()
	;~ CheckSocket()
	;~ BuyEctosIfEnoughMoney()
	StartQuest()
	;~ DoQuest()
	;~ WaitForReset()
	;~ UpdateStatistics()
	;~ main()
EndFunc

Func DoQuest()
	$runTime = TimerInit()
	$isRunning = true
	$ltime = TimerInit()
	out("Running The Quest")
	moveto(11828, -4815)
	out("Wait here")
	If GwAu3_Map_GetMapID() <> $questMapId Then
		Out("Trying to start quest in wrong map")
		main()
	EndIf
	If NOT WaitAndFight(1550, 50000) Then
		$runIsSuccessful = False
		return False
	EndIf
	If NOT RunWaypoints() Then
		$runIsSuccessful = False
		Return False
	EndIf
	If NOT WaitAndFight(1550, 50000) Then
		$runIsSuccessful = False
		return False
	EndIf
	out("Finished a cycle in " & Round(TimerDiff($ltime) / 60000) & " minutes.")
	$runIsSuccessful = True
EndFunc

Func WaitForAutoReturnToHom()
	Local $tResetWait = TimerInit()
	Out("Waiting to return to HoM...")

	Do
		Sleep(100)
	Until GwAu3_Map_GetMapID() = $homMapId Or getisdead(-2) Or TimerDiff($tResetWait) > 30000

	If GwAu3_Map_GetMapID() = $homMapId Then
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

Func WaitForReset()
	$antiBugTimer = TimerInit()
	Do
		Sleep(100)
	Until GwAu3_Map_GetMapID() = $homMapId OR getisdead(-2) OR TimerDiff($antiBugTimer) > 90000
	If TimerDiff($antiBugTimer) > 90000 Then
		out("Stuck in mission")
		resign()
		Sleep(500+getping())
		returntooutpost()
		$failruns = $failruns + 1
		waitmaploading($homMapId)
	EndIf
	If getisdead(-2) Then
		out("Died when WaitForReset()")
		resign()
		Sleep(500+getping())
		returntooutpost()
		waitmaploading($homMapId)
	EndIf
EndFunc

Func UpdateStatistics()
	If $runIsSuccessful = True Then
		StopRunTime()
		UpdateTimers()
		$totalruns = $totalruns + 1
		$successruns = $successruns + 1
		FindWarSupplies()
		Sleep(5000)
	Else
		StopRunTime()
		$failruns = $failruns + 1
		Sleep(3000)
		returntooutpost()
		sleep(2000)
		waitmaploading($homMapId)
	EndIf
	GUICtrlSetData($LabelWarSupplies, $warsupplies / 250)
	GUICtrlSetData($LabelSuccesRuns, $successruns)
	GUICtrlSetData($LabelFailRuns, $failruns)
	GUICtrlSetData($LabelTotalEctos, $totalectos)
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
	Local $iblocked = 0

	If $s <> "" Then out($s)
	GwAu3_Map_Move($x, $y, 50)
	Do
		GwAu3_Item_SwitchWeaponSet(2)
		Survive()
		Sleep(50)
		If GwAu3_Agent_GetAgentInfo(-2, "MoveX") = 0 And GwAu3_Agent_GetAgentInfo(-2, "MoveY") = 0 And Not GwAu3_Agent_GetAgentInfo(-2, "IsKnockedDown") And Not GwAu3_Agent_GetAgentInfo(-2, "IsCasting") Then
			$iblocked += 1
			GwAu3_Map_Move(GwAu3_Agent_GetAgentInfo(-2, "X"), GwAu3_Agent_GetAgentInfo(-2, "Y"), 600)
			Sleep(350)
			GwAu3_Map_Move($x, $y, 0)
			Out("Blocked and trying to get free - attempt: " & $iblocked)
		EndIf
		;~ If GetInstanceType() == 2 Then disconnected()
	Until ComputeDistance(GwAu3_Agent_GetAgentInfo(-2, "X"), GwAu3_Agent_GetAgentInfo(-2, "Y"), $x, $y) < 250 or $iblocked > 20 or GwAu3_Agent_GetAgentInfo(-2, "HP") <= 0
	If $iBlocked > 20 Then
		Out("MoveAndSurvive() failed: Too many block attempts.")
		Return False
	EndIf
	If GwAu3_Agent_GetAgentInfo(-2, "HP") <= 0 Then
		Out("MoveAndSurvive() failed: Agent is dead.")
		Return False
	EndIf
	Return True
EndFunc

Func Survive()
	If GwAu3_Agent_GetAgentInfo(-2, "HP") < 0.8 Or GwAu3_Agent_GetAgentInfo(-2, "IsHexed") Then
		If CanUseSkill(6, 2) Then
			GwAu3_Skill_UseSkill(6, -2)
			Return True
		EndIf
	EndIf
	if GwAu3_Agent_GetAgentEffectInfo(-2, 481, "HasEffect") Then ; Cripple
		Local $target = GwAu3_Agent_TargetNearestEnemy(1100)
		If $target = 0 Then
			Out("Survive() failed: No target found for Cripple.")
			Return False
		EndIf
		If CanUseSkill(5, 3) Then
			GwAu3_Item_SwitchWeaponSet(0)
			GwAu3_Skill_UseSkill(5, $target)
			GwAu3_Item_SwitchWeaponSet(2)
		EndIf
	EndIf
	Local $enemiesInRange = GetEnemiesInRange(1300)
	For $target = 1 To $enemiesInRange[0]
		;check for bull's strike, water trident and melandru's shot
		If GwAu3_Agent_GetAgentInfo($target, "skill") = 332 OR GwAu3_Agent_GetAgentInfo($target, "skill") = 237 OR GwAu3_Agent_GetAgentInfo($target, "skill") = 853 Then
			Out("Survive() found a bull's strike, water trident or melandru's shot. Cancelling action.")
			GwAu3_Agent_CancelAction()
			sleep(250)
		EndIf
	Next
	Return False
EndFunc

Func CanUseSkill($askillslot, $aenergy = 0, $asoftcounter = 10)
	if GwAu3_Agent_GetAgentInfo(-2, "IsCasting") Then return False
	if GwAu3_Agent_GetAgentInfo(-2, "CurrentEnergy") < $aenergy Then Return False
	if Not GwAu3_Skill_GetSkillbarInfo($askillslot, "IsRecharged") Then return False
	; check for blind
	$hasBlind = GwAu3_Agent_GetAgentEffectInfo(-2, 479, "HasEffect")
	if $hasBlind AND $askillslot <> 5 AND $askillslot <> 6 Then Return False

	Return True
EndFunc

Func UpdateEnemiesInRange($range)
	Dim $enemiesInRange[1] = [0]
	For $i = 1 To getmaxagents()
		$lagent = getagentbyid($i)
		If DllStructGetData($lagent, "Type") <> 219 Then ContinueLoop
		If DllStructGetData($lagent, "HP") <= 0 Then ContinueLoop
		If DllStructGetData($lagent, "Allegiance") <> 3 Then ContinueLoop
		$distance = getdistance($lagent, -2)
		If $distance <= $range Then
			$enemiesInRange[0] += 1
			ReDim $enemiesInRange[$enemiesInRange[0] + 1]
			$enemiesInRange[$enemiesInRange[0]] = $lagent
		EndIf
	Next
EndFunc

Func GetTarget($aEnemiesInRange)
	$target = 0
	For $i = 1 to 12
		For $j = 1 To $aEnemiesInRange[0]
			$agent = $aEnemiesInRange[$j]
			$agentPlayerNumber = GwAu3_Agent_GetAgentInfo($agent, "PlayerNumber")
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
	Out("Fighting...")
	Local $ndeadlock = TimerInit()

	Do
		If GwAu3_Agent_GetAgentInfo(-2, "HP") <= 0 Then
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

	GwAu3_Other_PingSleep(1000)
	Return True
EndFunc

Func CastEngine($target)
	Local $ldeadlock = TimerInit()
	If Cast($target) Then
		Do
			Sleep(50)
		Until TimerDiff($ldeadlock) > GwAu3_Other_GetPing() + 150
		Return True
	Else
		sleep(300)
	EndIf
EndFunc

Func Cast($target)
	If GwAu3_Agent_GetAgentInfo(-2, "HP") < 0.7 Then
		If CanUseSkill(6, 2) Then
			GwAu3_Skill_UseSkill(6, -2)
			Return True
		EndIf
	EndIf
	If GwAu3_Agent_GetAgentInfo(-2, "IsKnockedDown") Then
		Return False
	EndIf
	If GwAu3_Agent_GetAgentInfo(-2, "IsConditioned") Then
		If CanUseSkill(5, 3) Then
			GwAu3_Skill_UseSkill(5, $target)
			Return True
		EndIf
	EndIf
	; Wait for Miku's hex when she's in range
	If CanUseSkill(1, 2) Then
		$miku = GetAgentById(3) ;Miku
		
		If $miku <> 0 And GwAu3_Agent_GetDistance($miku, -2) <= 1100 Then
			Local $aEnemiesInRange = GetEnemiesInRange(1300)
			For $i = 1 To $aEnemiesInRange[0]
				If GwAu3_Agent_GetAgentInfo($aEnemiesInRange[$i], "IsHexed") Then
					GwAu3_Skill_UseSkill(1, $aEnemiesInRange[$i])
					Return True
				EndIf
			Next
		Else
			GwAu3_Skill_UseSkill(1, $target)
			Return True
		EndIf
	EndIf
	If CanUseSkill(3, 1) Then
		GwAu3_Skill_UseSkill(3, $target)
		Return True
	EndIf
	If CanUseSkill(4, 1) Then
		GwAu3_Skill_UseSkill(4, $target)
		Return True
	EndIf
	If CanUseSkill(2, 2) Then
		GwAu3_Skill_UseSkill(2, $target)
		Return True
	EndIf
	Return False
EndFunc

Func WaitAndFight($adist, $iideadlock)
	Local $target, $ldistance
	Local $tStart = TimerInit()
	Out("WaitAndFight(): Waiting for enemies...")

	Do
		$target = GwAu3_Agent_TargetNearestEnemy()
		$ldistance = GwAu3_Agent_GetDistance($target, -2)

		If $ldistance < $adist Then
			GwAu3_Item_SwitchWeaponSet(0)
			If Not Fight(1300) Then Return False
			GwAu3_Item_SwitchWeaponSet(2)
			Out("WaitAndFight(): Enemy encountered and fight finished.")
			Return True
		EndIf

		If GwAu3_Agent_GetAgentInfo(-2, "HP") <= 0 Then
			Out("WaitAndFight(): Player died during wait.")
			Return False
		EndIf

		Sleep(300)
	Until TimerDiff($tStart) > $iideadlock

	Out("WaitAndFight(): Timeout after " & ($iideadlock / 1000) & " seconds.")
	Return False
EndFunc

Func FindWarSupplies()
	Local $litem
	Local $QuantityWS
	$warsupplies = 0
	For $i = 1 To 16
		For $j = 1 To DllStructGetData(getbag($i), "Slots")
			$litem = getitembyslot($i, $j)
			Switch DllStructGetData($litem, "ModelID")
				Case 35121
					$QuantityWS = DllStructGetData($litem, "Quantity")
					$warsupplies += $QuantityWS
			EndSwitch
		Next
	Next
EndFunc

Func TradeItemsToAgent($lAgent)
	TradePlayer($lAgent)
	Sleep(2000)
	; check bag for the right items and offer them
	Local $counter = 0
	For $i = 1 To 4
		For $j = 1 To DllStructGetData(getbag($i), "Slots")
			If $counter = 7 Then ExitLoop
			$litem = getitembyslot($i, $j)
			Switch DllStructGetData($litem, "ModelID")
				Case 35121 ;war supplies
					$QuantityWS = DllStructGetData($litem, "Quantity")
					if $QuantityWS = 250 Then
						OfferItem(DllStructGetData($litem, "Id"), $QuantityWS)
						$counter += 1
						sleep(300)
					EndIf
				Case 930 ;ecto
					$QuantityEcto = DllStructGetData($litem, "Quantity")
					OfferItem(DllStructGetData($litem, "Id"), $QuantityEcto)
					$counter += 1
					sleep(300)
			EndSwitch
		Next
	Next
	sleep(500)
	SubmitOffer()
	sleep(500)
	AcceptTrade()
	sleep(1000)
EndFunc

Func GetAllAllies()
	Dim $alliesAll[1] = [0]
	For $i = 11 To getmaxagents()
		$lagent = getagentbyid($i)
		If DllStructGetData($lagent, "Type") <> 219 Then ContinueLoop
		If DllStructGetData($lagent, "HP") <= 0 Then ContinueLoop
		If DllStructGetData($lagent, "Allegiance") <> 1 Then ContinueLoop
		$alliesAll[0] += 1
		ReDim $alliesAll[$alliesAll[0] + 1]
		$alliesAll[$alliesAll[0]] = $lagent
	Next
	If $alliesAll[0] = 1 Then Return False
EndFunc

Func CheckForWarSuppliesAndEctos()
	For $i = 1 To 4
		For $j = 1 To DllStructGetData(getbag($i), "Slots")
			$litem = getitembyslot($i, $j)
			Switch DllStructGetData($litem, "ModelID")
				Case 35121 ;war supplies
					$QuantityWS = DllStructGetData($litem, "Quantity")
					if $QuantityWS = 250 Then
						Return True
					EndIf
				Case 930 ;ecto
					$QuantityEcto = DllStructGetData($litem, "Quantity")
					if $QuantityEcto >= 1 Then
						Return True
					EndIf
			EndSwitch
		Next
	Next
	Return False
EndFunc

Func UpdateTimers()
	$LastRunTime = TimerDiff($runTime)
	$StringLastRunTime = StringFormat("%02u:%02u", $LastRunTime/1000/60, Mod($LastRunTime/1000,60))
;~ 	If $LastRunTime > $WorstRunTime Then $WorstRunTime = $LastRunTime
;~ 	$StringWorstRunTime = StringFormat("%02u:%02u", $WorstRunTime/1000/60, Mod($WorstRunTime/1000,60))
	If $totalruns = 0 Then $BestRunTime = $LastRunTime
	If $LastRunTime < $BestRunTime Then $BestRunTime = $LastRunTime
	$StringBestRunTime = StringFormat("%02u:%02u", $BestRunTime/1000/60, Mod($BestRunTime/1000,60))
	;calculating average time
	;unbound arrays are not possible, so make long string and then split on "|"
	If $AllRunTimes <> -1 Then $AllRunTimes = $AllRunTimes & "|" & $LastRunTime
	If $AllRunTimes = -1 Then $AllRunTimes = $LastRunTime
	$ArrayAllRunTimes = StringSplit($AllRunTimes, "|",  $STR_NOCOUNT)
	$numberArray = UBound($ArrayAllRunTimes)
	Local $AllTimesTogether = 0
	For $i = 0 to $numberArray -1
		$AllTimesTogether = $AllTimesTogether + $ArrayAllRunTimes[$i]
	Next
	$AverageRunTime = $AllTimesTogether / $numberArray
	$StringAverageRunTime = StringFormat("%02u:%02u", $AverageRunTime/1000/60, Mod($AverageRunTime/1000,60))

	GUICtrlSetData($LabelLast, $StringLastRunTime)
;~ 	GUICtrlSetData($lblWorstRunTime, "Worst: " & $StringWorstRunTime)
	GUICtrlSetData($LabelAverage, $StringAverageRunTime)
	GUICtrlSetData($LabelBest, $StringBestRunTime)
EndFunc

Func TimerUpdater()
	$Sec += 1
	If $Sec = 60 Then
		$Min += 1
		$Sec = $Sec - 60
	EndIf

	If $Min = 60 Then
		$Hour += 1
		$Min = $Min - 60
	EndIf

	If $Sec < 10 Then
		$L_Sec = "0" & $Sec
	Else
		$L_Sec = $Sec
	EndIf

	If $Min < 10 Then
		$L_Min = "0" & $Min
	Else
		$L_Min = $Min
	EndIf

	If $Hour < 10 Then
		$L_Hour = "0" & $Hour
	Else
		$L_Hour = $Hour
	EndIf

	If $isRunning Then
			$Sec2 += 1
		If $Sec2 = 60 Then
			$Min2 += 1
			$Sec2 = $Sec2 - 60
		EndIf

		If $Min2 = 60 Then
			$Hour2 += 1
			$Min2 = $Min2 - 60
		EndIf

		If $Sec2 < 10 Then
			$L_Sec2 = "0" & $Sec2
		Else
			$L_Sec2 = $Sec2
		EndIf

		If $Min2 < 10 Then
			$L_Min2 = "0" & $Min2
		Else
			$L_Min2 = $Min2
		EndIf

		If $Hour2 < 10 Then
			$L_Hour2 = "0" & $Hour2
		Else
			$L_Hour2 = $Hour2
		EndIf
		GUICtrlSetData($LabelRunTime, $L_Hour2 & ":" & $L_Min2 & ":" & $L_Sec2)
	EndIf
	GUICtrlSetData($LabelTotalTime, $L_Hour & ":" & $L_Min & ":" & $L_Sec)
EndFunc   ;==>TimerUpdater

Func BuyEctosIfEnoughMoney()
	$lgold = getgoldcharacter()
	If $lgold > 90000 Then
		If GwAu3_Map_GetMapID() <> 178 Then
			Out("Travel to GH")
			TravelGH()
			Sleep(1000)
		EndIf
   		BuyEctos()
	EndIf
EndFunc

Func BuyEctos()
	Local $EctoID = 930
	Out("Buying ectos")
	;~ DepositGold()
	;~ Sleep(2000)
	moveto(-853, 4501)
	$MerchantEcto = GetNearestNPCToCoords(-1044, 4601)
	ChangeTarget($MerchantEcto)
	Sleep(1000)
	GoToNPC($MerchantEcto)
	TraderRequest($EctoID)
	Sleep(500 + 3 * GetPing())
	For $I = 1 To 15
		TraderRequest($EctoID)
		Sleep(500 + 3 * GetPing())
		TraderBuy()
		$totalectos += 1
	Next
EndFunc

Func StopRunTime()
	Global $isRunning = false
	Global $Sec2 = 0 ;Variable for Seconds
	Global $Min2 = 0 ;Variable for Minutes
	Global $Hour2 = 0 ;Variable for Hours
EndFunc

Func Out($aString)
	;~ FileWriteLine($fLog, @HOUR & ":" & @MIN & " - " & $aString)
	ConsoleWrite(@HOUR & ":" & @MIN & " - " & $aString & @CRLF)
	GUICtrlSetData($LogBox, GUICtrlRead($LogBox) & @HOUR & ":" & @MIN & " - " & $aString & @CRLF)
	_GUICtrlEdit_Scroll($LogBox, 4)
EndFunc   ;==>Out

Func _reducememory()
	If $gwpid <> -1 Then
		Local $ai_handle = DllCall("kernel32.dll", "int", "OpenProcess", "int", 2035711, "int", False, "int", $gwpid)
		Local $ai_return = DllCall("psapi.dll", "int", "EmptyWorkingSet", "long", $ai_handle[0])
		DllCall("kernel32.dll", "int", "CloseHandle", "int", $ai_handle[0])
	Else
		Local $ai_return = DllCall("psapi.dll", "int", "EmptyWorkingSet", "long", -1)
	EndIf
	Return $ai_return[0]
EndFunc

#Region Memory

Func OutDllStruct($struct, $fieldCount)
    For $i = 1 To $fieldCount
        Out("Field " & $i & ": " & DllStructGetData($struct, $i) & @CRLF)
    Next
EndFunc

Func OutDllStructArray($structArray)
    Local $count = $structArray[0]
    For $i = 1 To $count
		$ptr = $structArray[$i]

		$field1 = GwAu3_Agent_GetAgentInfo($ptr, "AgentModelType")
		$field2 = GwAu3_Agent_GetAgentInfo($ptr, "PlayerNumber")
		Out("Agent #" & $i & ": veld1=" & $field1 & ", veld2=" & $field2)
        ;~ Out("Struct #" & $i)
        ;~ Out("Field" & ": " & DllStructGetData($structArray[$i], "ID"))
        Out("--------------------")
    Next
EndFunc

#EndRegion

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
        Local $val = GwAu3_Agent_GetAgentInfo($agentPtr, $properties[$i])
        Out($properties[$i] & " = " & $val)
    Next
EndFunc

Func MoveToNPC($target, $block = True)
	Local $lMapLoading = GwAu3_Map_GetInstanceInfo("IsLoading"), $lMapLoadingOld
	Local $lBlocked = 0

	GwAu3_Agent_GoNPC($target)

	Do
		Sleep(100)
		If GwAu3_Agent_GetAgentInfo(-2, "HP") <= 0 Then
			Out("MoveToNPC() aborted: player is dead.")
			GwAu3_Agent_CancelAction()
			Return False
		EndIf

		$lMapLoadingOld = $lMapLoading
		$lMapLoading = GwAu3_Map_GetInstanceInfo("IsLoading")
		If $lMapLoading <> $lMapLoadingOld Then
			Out("MoveToNPC() interrupted: map loading detected.")
			GwAu3_Agent_CancelAction()
			Return False
		EndIf

		If $block = True Then
			If GwAu3_Agent_GetAgentInfo(-2, "MoveX") == 0 And GwAu3_Agent_GetAgentInfo(-2, "MoveY") == 0 Then
				$lBlocked += 1
				Out("blocked"& $lBlocked)
				GwAu3_Map_Move(GwAu3_Agent_GetAgentInfo(-2, "X"), GwAu3_Agent_GetAgentInfo(-2, "Y"), 100)
				GwAu3_Other_PingSleep(50)
				GwAu3_Agent_GoNPC($target)
			EndIf

			If $lBlocked > 14 Then
				Out("MoveToNPC() failed: stuck trying to reach NPC.")
				Return False
			EndIf
		EndIf
		
	Until GwAu3_Agent_GetDistance(-2, $target) < 150

	Return True
EndFunc

Func MoveTo($x, $y, $antiBlock = True, $range = 150, $random = 50)
	Local $lBlocked = 0
	Local $lMapLoading = GwAu3_Map_GetInstanceInfo("IsLoading"), $lMapLoadingOld

	Local $targetX = $x + Random(-$random, $random)
	Local $targetY = $y + Random(-$random, $random)

	GwAu3_Map_Move($targetX, $targetY, 0)

	Do
		Sleep(100)

		Local $myX = GwAu3_Agent_GetAgentInfo(-2, "X")
		Local $myY = GwAu3_Agent_GetAgentInfo(-2, "Y")

		$lMapLoadingOld = $lMapLoading
		$lMapLoading = GwAu3_Map_GetInstanceInfo("IsLoading")
		If $lMapLoading <> $lMapLoadingOld Then
			Return
		EndIf

		If GwAu3_Agent_GetAgentInfo(-2, "HP") <= 0 Then
			Out("MoveTo() aborted: player is dead.")
			Return
		EndIf
		If $antiBlock = True Then
			If Not GwAu3_Map_GetInstanceInfo("IsLoading") And GwAu3_Agent_GetAgentInfo(-2, "MoveX") = 0 And GwAu3_Agent_GetAgentInfo(-2, "MoveY") = 0 Then
				$lBlocked += 1
				If $lBlocked > 14 Then
					Out("MoveTo() failed: stuck trying to move.")
					Return False
				EndIf
				Sleep(250)
				$targetX = $x + Random(-$random, $random)
				$targetY = $y + Random(-$random, $random)
				Out("Blocked at " & $myX & ", " & $myY & ". Trying to move to " & $targetX & ", " & $targetY)
				GwAu3_Map_Move($targetX, $targetY, 0)
			EndIf
		EndIf
		
	Until ComputeDistance($myX, $myY, $targetX, $targetY) < $range

	Return True
EndFunc

Func GetAgentByPlayerNumber($playerNumber)
	$agentPtrsArray = GwAu3_Agent_GetAgentArray()
    Local $count = $agentPtrsArray[0]
    For $i = 1 To $count
        Local $ptr = $agentPtrsArray[$i]
        Local $curPlayerNumber = GwAu3_Agent_GetAgentInfo($ptr, "PlayerNumber")
        If $curPlayerNumber = $playerNumber Then
            Return $ptr
        EndIf
    Next
	Out("Agent with PlayerNumber " & $playerNumber & " not found.")
    Return 0
EndFunc

Func GetAgentById($agentId)
	$agentPtrsArray = GwAu3_Agent_GetAgentArray()
    Local $count = $agentPtrsArray[0]
    For $i = 1 To $count
        Local $ptr = $agentPtrsArray[$i]
        Local $cur = GwAu3_Agent_GetAgentInfo($ptr, "ID")
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
	Local $agentPtrsArray = GwAu3_Agent_GetAgentArray()
	Local $count = $agentPtrsArray[0]

	For $i = 1 To $count
		Local $agentPtr = $agentPtrsArray[$i]
		If $agentPtr = 0 Then ContinueLoop
		If GwAu3_Agent_GetAgentInfo($agentPtr, "HP") <= 0 Then ContinueLoop
		If GwAu3_Agent_GetAgentInfo($agentPtr, "Allegiance") <> 3 Then ContinueLoop ;
		If GwAu3_Agent_GetDistance($agentPtr, -2) <= $range Then
			$agentsInRange[0] += 1
			ReDim $agentsInRange[$agentsInRange[0] + 1]
			$agentsInRange[$agentsInRange[0]] = $agentPtr
		EndIf
	Next

	Return $agentsInRange
EndFunc

Func IsAlive()
	Return GwAu3_Agent_GetAgentInfo(-2, "HP") > 0
EndFunc
