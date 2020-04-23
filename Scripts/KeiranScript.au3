#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.0
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here

#include <GWA2.au3>
#include <trade_partner.au3>
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
$ButtonMaxMemory = GUICtrlCreateButton("Set Max Memory Usage", 25, 64, 194, 30)
$CheckboxTrade = GUICtrlCreateCheckbox("Trade", 352, 24, 97, 17)
$ButtonReduceMemory = GUICtrlCreateButton("Reduce Memory", 25, 128, 194, 30)
$LogBoxTCP = GUICtrlCreateEdit("", 256, 56, 193, 118, BitOR($ES_AUTOVSCROLL,$ES_AUTOHSCROLL,$ES_READONLY,$ES_WANTRETURN))
$CharacterName = $CmdLine[1]
GUICtrlSetData(-1, "")
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###
;~ Global $fLog = FileOpen("Keiran - Runner " & $CharName & ".log", 1) ;Log file
Global $boolrun = False
Global $gwpid = -1

Global $me = getagentbyid(-2)

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
Global $TradeAfterRun = False

Global $enemiesInRange
Global $alliesAll
Global $target
Global $isFighting = False

Global $mwaypoints[16][4] = [[9413, -7116, "1", 1250], [7526, -8410, "2", 1250], [4864, -8845, "3", 1250], [3438, -10528, "4", 1250], [2916, -11867, "5", 1250], [1749, -12765, "6", 1250], [266, -13059, "7", 1250], [-691, -12911, "8", 1250], [-2500, -11420, "9", 1250], [-4434, -12314, "10", 1250], [-6580, -9653, "11", 1250], [-10554, -8844, "12", 1250], [-12841, -8030, "13", 1250], [-15876, -8903, "Final Area 32", 1250], [-17109, -8978, "Final Area 33", 1250], ["WaitForEnemies", 1500, 25000, False]]

Global $serverSocket = Null
Global $goTrade
Global $tradeAgent



GUICtrlSetOnEvent($ButtonStart, "EventHandler")
GUICtrlSetOnEvent($CheckboxGraphics, "EventHandler")
GUICtrlSetOnEvent($CheckboxTrade, "EventHandler")
GUISetOnEvent($gui_event_close, "EventHandler")


Sleep(1000)
ControlClick("", "", "Start", "")



While 1
	If $boolrun Then
		GUICtrlSetData($LabelWarSupplies, $warsupplies / 250)
		GUICtrlSetData($LabelSuccesRuns, $successruns)
		GUICtrlSetData($LabelFailRuns, $failruns)
		GUICtrlSetData($LabelTotalEctos, $totalectos)
		main()
	EndIf
	If Not $boolrun Then
		AdlibUnRegister("TimerUpdater")
	EndIf
WEnd

Func EventHandler()
	Switch (@GUI_CtrlId)
		Case $ButtonStart
			GUICtrlSetData($ButtonStart, "Initializing...")
			GUICtrlSetState($ButtonStart, $gui_disable)
			If initialize($CharacterName, True, True, True) = False Then
				MsgBox(0, "Error", "Can't find a Guild Wars client with that character name.")
				Exit
			EndIf
			$boolrun = True
			$gwpid = ProcessExists("gw.exe")
			WinSetTitle($Form, "", "Keiran - " & $CharacterName)
			GUICtrlSetData($ButtonStart, "Bot Started")
			AdlibRegister("TimerUpdater", 1000)
			FindWarSupplies()
			setmaxmemory()
			SetPlayerStatus(0)
			AdlibRegister("ListenToServer")
			;~ AdlibRegister("SendStatsToServer",60000)
		Case $ButtonMaxMemory
			setmaxmemory()
		Case $CheckboxGraphics
			clearmemory() 
			togglerendering()
		Case $ButtonReduceMemory
			_reducememory()
		Case $CheckboxTest
			clearmemory()
		Case $CheckboxTrade
			If $TradeAfterRun = False Then
				$TradeAfterRun = True
			Else
				$TradeAfterRun = False
			EndIf
		Case $gui_event_close
			Exit
	EndSwitch
EndFunc

Func main()
	clearmemory()

	If $TradeAfterRun = True Then
		If getmapid() <> 642 Then
			travelto(642)
		EndIf
		;~ $agents = GetMaxAgents()
		;~ For $i = 1 To $agents
			;~ MsgBox(0, "test",DllStructGetData($agents[$i], "Name"))
			$lagent = GetNearestAgentToCoords(-2111, 955)
			if DllStructGetData($lagent, "Id") <> 0 Then
				$tradeAgent = $lagent
				While $TradeAfterRun = True and CheckForWarSuppliesAndEctosAndGold() = True
					WithdrawGold()
					TradeItemsToPartner()
					WithdrawGold()
					sleep(2000)
				WEnd
			EndIf
			$TradeAfterRun = False
			GUICtrlSetState($CheckboxTrade,$GUI_UNCHECKED)
			Out("Done trading, back to farming")
		;~ Next
	EndIf

	BuyEctosIfEnoughMoney()
	StartQuest()
	DoQuest() 
	WaitForReset()
	UpdateStatistics()
	;~ _purgehook()
	Main()
EndFunc

Func ListenToServer()
	If $serverSocket = Null Then
		StartTcp()
	EndIf
	$receivedData = TCPRecv($serverSocket, 10025)
	;~ MsgBox(0, "", $receivedData)
	;~ If @error Then
	;~ 	StartTcp()
	;~ EndIf

	If $receivedData = '' Then Return
	If $receivedData = 'Start Trading' Then 
		$TradeAfterRun = true
		Out("Trade after run")
		GUICtrlSetState($CheckboxTrade,$GUI_CHECKED)
	EndIf	
	If $receivedData = 'Stop Trading' Then 
		$TradeAfterRun = False
		Out("Stop trade after run")
		GUICtrlSetState($CheckboxTrade,$GUI_UNCHECKED)
	EndIf	
	If $receivedData = 'Stop process' Then 
		Out("Stopping client")
		ProcessClose($gwpid)
		Exit
	EndIf	
	If $receivedData = 'Close' Then 
		Exit
	EndIf
	If $receivedData = 'Stopped Server' Then 
		$serverSocket = null
	EndIf

	Out($receivedData)
EndFunc

Func SendStatsToServer()
	Local $stats = "Stats|War Supplies="+ $warsupplies +"|Success Runs=" + $successruns + "|Fail Runs=" + $fail
	TCPSend($serverSocket, $stats)

EndFunc

Func StartTcp()
	TCPStartup() ; Start the TCP service.

	; Assign Local variables the loopback IP Address and the Port.
	Local $sIPAddress = "127.0.0.1" ; This IP Address only works for testing on your own computer.
	Local $iPort = 11000 ; Port used for the connection.

	; Assign a Local variable the socket and connect to a Listening socket with the IP Address and Port specified.
	$serverSocket = TCPConnect($sIPAddress, $iPort)

	; If an error occurred display the error code and return False.
	If @error Then
		$serverSocket = null
		;~ ; The server is probably offline/port is not opened on the server.
		;~ Local $iError = @error
		;~ MsgBox(BitOR($MB_SYSTEMMODAL, $MB_ICONHAND), "", "Could not connect, Error code: " & $iError)
		;~ Return False
	Else
		Out("Connected to server")
		Sleep(1000)
		TCPSend($serverSocket, $characterName)
		Out("Sent to server")
	EndIf
EndFunc   ;==>StartTcp

Func StartQuest()
	If getMapId() = $eotnOutpostMapId Then
		EnterHom()
	EndIf
	If getMapId() = $homMapId Then
		EnterQuest()
	EndIf
EndFunc	

Func DoQuest() 
	$runTime = TimerInit()
	$isRunning = true
	$ltime = TimerInit()
	out("Running The Quest")
	moveto(11828, -4815)
	out("Wait here")
	If NOT waitforenemies(1550, 50000) Then
		$runIsSuccessful = False
		return False
	EndIf
	If NOT runwaypoints() Then
		$runIsSuccessful = False
		Return False
	EndIf
	out("Finished a cycle in " & Round(TimerDiff($ltime) / 60000) & " minutes.")
	$runIsSuccessful = True
EndFunc

Func WaitForReset()
	$antiBugTimer = TimerInit()
	Do
		Sleep(100)
	Until getmapid() = $homMapId OR getisdead(-2) OR TimerDiff($antiBugTimer) > 90000
	If TimerDiff($antiBugTimer) > 90000 Then
		out("Stuck in mission")
		resign()
		Sleep(500+getping())
		returntooutpost()
		$failruns = $failruns + 1
		waitmaploading($homMapId)
	EndIf
EndFunc

Func UpdateStatistics()
	If $runIsSuccessful = True Then
		StopRunTime()
		UpdateTimers()
		$totalruns = $totalruns + 1
		$successruns = $successruns + 1
		$warsupplies += 5
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

Func RunningQuest()
	$runTime = TimerInit()
	$isRunning = true
	Local $ltime
	$ltime = TimerInit()
	If getmapid() <> $questMapId Then
		Return False
	EndIf
	out("Running The Quest")
	moveto(11828, -4815)
	out("Wait here")
	waitforenemies(1550, 50000)
	
	If NOT runwaypoints() Then Return False
	out("Finished a cycle in " & Round(TimerDiff($ltime) / 60000) & " minutes.")
	$antiBugTimer = TimerInit()
	waitmaploading(646)
	Do
		Sleep(100)
	Until getmapid() = $homMapId OR getisdead(-2) OR TimerDiff($antiBugTimer) > 90000
	If TimerDiff($antiBugTimer) > 90000 Then
		out("Stuck in mission")
		resign()
		Sleep(500+getping())
		returntooutpost()
		$failruns = $failruns + 1
		waitmaploading($homMapId)
		main()
	EndIf
	rndsleep(5000)
	_purgehook()
	Return True
EndFunc

Func enterhom()
	out("Going To HoM")
	moveto(-3477, 4245, 40)
	moveto(-4060, 4675, 50)
	moveto(-4448, 4952, 30)
	move(-4779, 5209)
	waitmaploading($homMapId)
	rndsleep(6000)
EndFunc

Func EnterQuest()
	$HomTimeQuest = TimerInit()
	out("Entering Quest")
	Do
		$npc = getnearestnpctocoords(-6753, 6513)
		gotonpc($npc)
		rndsleep(1000)
		changeweaponset(4)
		rndsleep(1000)
		dialog(1586)
	Until waitmaploading($questMapId) Or TimerDiff($HomTimeQuest) > 25000
	If TimerDiff($HomTimeQuest) > 25000 Then
		out("Stuck in HoM")
		travelto($eotnOutpostMapId)
		waitmaploading($eotnOutpostMapId)
		Main()
	EndIf
	rndsleep(3000)
EndFunc

Func runwaypoints()
	Local $lx, $ly, $lmsg, $lrange
	For $i = 0 To 15
		$lx = $mwaypoints[$i][0]
		$ly = $mwaypoints[$i][1]
		$lmsg = $mwaypoints[$i][2]
		$lrange = $mwaypoints[$i][3]
		If IsString($lx) Then
			If NOT Call($lx, $ly, $lmsg, $lrange) Then return False
		Else
			If NOT RunAndSurvive($lx, $ly, $lmsg, $lrange) Then Return False
		EndIf
	Next
	Return True
EndFunc

Func RunAndSurvive($x, $y, $s = "", $z = 1250)
	$random = 50
	$iblocked = 0
	If $s <> "" Then out($s)
	move($x, $y, $random)
	$lme = getagentbyid(-2)
	$coordsx = DllStructGetData($lme, "X")
	$coordsy = DllStructGetData($lme, "Y")
	Do
		changeweaponset(1)
		Survive()
		UpdateEnemiesInRange(1350)
		$oldcoordsx = $coordsx
		$oldcoordsy = $coordsy
		$lme = getagentbyid(-2)
		$coordsx = DllStructGetData($lme, "X")
		$coordsy = DllStructGetData($lme, "Y")
		If $oldcoordsx = $coordsx AND $oldcoordsy = $coordsy Then
			$iblocked += 1
			move($coordsx, $coordsy, 600)
			rndsleep(350)
			move($x, $y, $random)
		EndIf
		If getisdead(-2) Then
			out("DEAD RunAndSurvive")
			out("------------")
			Return False
		EndIf
		rndsleep(100)
	Until computedistance($coordsx, $coordsy, $x, $y) < 250 OR $iblocked > 20
	If getisdead(-2) Then
		Return False
	EndIf
	Return True
EndFunc

Func Survive()
	If DllStructGetData(GetAgentById(-2), "HP") < 0.8 Or GetHasHex(GetAgentById(-2)) Then
		If CanUseSkill(6, 2) Then
			useskill(6, -2)
			Return True
		EndIf
	EndIf
	$meffects = geteffect()
	If NOT IsArray($meffects) Then Dim $meffects[1] = [0]
	$nearestenemy = getnearestenemytoagent(-2)
	For $i = 1 To $meffects[0]
		if DllStructGetData($meffects[$i], "SkillID") == 481 Then ; Cripple
			if getdistance(-2, $nearestenemy) > 1100 Then ExitLoop
			If CanUseSkill(5, 3) Then
				changeweaponset(3)
				useskill(5, $nearestenemy)
				changeweaponset(1)
			EndIf
		EndIf
	Next
	
	For $j = 1 To $enemiesInRange[0]
		;check for bull's strike, water trident and melandru's shot
		If DllStructGetData($enemiesInRange[$j], "skill") = 332 OR DllStructGetData($enemiesInRange[$j], "skill") = 237 OR DllStructGetData($enemiesInRange[$j], "skill") = 853 Then
			cancelaction()
			sleep(250)
		EndIf
	Next
	Return False
EndFunc

Func CanUseSkill($askillslot, $aenergy = 0, $asoftcounter = 10)
	if getiscasting(-2) Then return false
	if GetEnergy(getagentbyid(-2)) < $aenergy Then Return False
	if DllStructGetData(getskillbar(), "Recharge" & $askillslot) <> 0 Then return False
	; check for blind
	$meffects = geteffect()
	If NOT IsArray($meffects) Then Dim $meffects[1] = [0]
	For $i = 1 To $meffects[0]
		if DllStructGetData($meffects[$i], "SkillID") == 479 AND $askillslot <> 5 AND $askillslot <> 6 Then Return False
	Next
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

Func UpdateTarget()
	If $isFighting = true Then
		$target = 0
		For $i = 1 to 12
			For $j = 1 To $enemiesInRange[0]
				$agent = $enemiesInRange[$j]
				$agentPlayerNumber = DllStructGetData($agent, "PlayerNumber")
				Switch $i
					Case 1
						If $agentPlayerNumber = 8114 OR $agentPlayerNumber = 8115 Then ;peacekeeper
							$target = $agent
							ExitLoop
						EndIf
					Case 2
						If $agentPlayerNumber >= 8203 AND $agentPlayerNumber <= 8210 Then ;monk
							$target = $agent
							ExitLoop
						EndIf
					Case 3
						If $agentPlayerNumber >= 8195 AND $agentPlayerNumber <= 8202 Then ;ele
							$target = $agent
							ExitLoop
						EndIf
					Case 4
						If $agentPlayerNumber >= 8232 AND $agentPlayerNumber <=  8237 Then ;rit
							$target = $agent
							ExitLoop
						EndIf
					Case 5
						If $agentPlayerNumber >= 8181 AND $agentPlayerNumber <= 8186 Then ;mes
							$target = $agent
							ExitLoop
						EndIf
					Case 6
						If $agentPlayerNumber >= 8187 AND $agentPlayerNumber <= 8194 Then ;necro
							$target = $agent
							ExitLoop
						EndIf
					Case 7
						If $agentPlayerNumber >= 8176 AND $agentPlayerNumber <= 8180 Then ;sin
							$target = $agent
							ExitLoop
						EndIf
					Case 8
						If $agentPlayerNumber >= 8219 AND $agentPlayerNumber <= 8226 Then ;ranger
							$target = $agent
							ExitLoop
						EndIf
					Case 9
						If $agentPlayerNumber >= 8228 AND $agentPlayerNumber <= 8231 Then ;dervish
							$target = $agent
							ExitLoop
						EndIf
					Case 10
						If $agentPlayerNumber >= 8211 AND $agentPlayerNumber <= 8218 Then ;warr
							$target = $agent
							ExitLoop
						EndIf
					Case 11
						If $agentPlayerNumber >= 8238 AND $agentPlayerNumber <= 8241 Then ;para
							$target = $agent
							ExitLoop
						EndIf
					Case Else
						$target = $agent
					EndSwitch
			Next
		If $target <> 0 Then ExitLoop
		Next
	EndIf
EndFunc

Func fight($arange)
	Out("Fighting")
	Local $nx, $ny, $rnd, $rndrange
	$ndeadlock = TimerInit()
	Do
		If getisdead(-2) Then ExitLoop
		If TimerDiff($ndeadlock) > 120000 Then
			ExitLoop
			resign()
			Sleep(500+getping())
			returntooutpost()
			$failruns = $failruns + 1
			waitmaploading($homMapId)
			main()
		EndIf
		UpdateEnemiesInRange($arange)
		UpdateTarget()
		castengine()
	Until $enemiesInRange[0] = 0
	Sleep(Random(500, 1000, 1))
	If getisdead(-2) Then
		Return False
	EndIf
	Return True
EndFunc

Func castengine($askill = False, $atarget = 0)
	If NOT $askill Then
		Local $ldeadlock = TimerInit()
		If cast() Then
			Do
				Sleep(50)
			Until TimerDiff($ldeadlock) > getping() + 150
			Return True
		Else
			sleep(300)
		EndIf
	EndIf
	Return False
EndFunc

Func cast()
	If DllStructGetData(GetAgentByID(-2), "HP") < 0.7 Then
		If CanUseSkill(6, 2) Then
			useskill(6, -2)
			Return True
		EndIf
	EndIf
	If getisknocked(-2) Then
		Return False
	EndIf
	If gethascondition(-2) Then
		If CanUseSkill(5, 3) Then
			useskill(5, $target)
			Return True
		EndIf
	EndIf
	; Wait for Miku's hex when she's in range
	If CanUseSkill(1, 2) Then
		$miku = GetAgentById(3) ;Miku
		If GetAgentExists(3) And getDistance($miku, -2) <= 1100 Then
			For $i = 1 To $enemiesInRange[0]
				If gethashex($enemiesInRange[$i]) Then
					useskill(1, $enemiesInRange[$i])
					Return True
				EndIf
			Next
		Else
			useskill(1, $target)
			Return True
		EndIf
	EndIf
	If CanUseSkill(3, 1) Then
		useskill(3, $target)
		Return True
	EndIf
	If CanUseSkill(4, 1) Then
		useskill(4, $target)
		Return True
	EndIf
	If CanUseSkill(2, 2) Then
		useskill(2, $target)
		Return True
	EndIf
	Return False
EndFunc

Func waitforenemies($adist, $iideadlock, $param = False)
	Local $ltarget, $ldistance
	Local $ssdeadlock = TimerInit()
	out("Waiting For The Enemies")
	Do
		$ltarget = getnearestenemytoagent(-2)
		If NOT IsDllStruct($ltarget) Then ContinueLoop
		$ldistance = getdistance($ltarget, -2)
		If $ldistance < $adist Then
			changeweaponset(3)
			$isFighting = True
			fight(1300)
			$isFighting = False
			changeweaponset(4)
		EndIf

		If getisdead(-2) Then
			out("DEAD WaitForEnemies")
			out("------------")
			return false
		EndIf
		sleep(300)
	Until TimerDiff($ssdeadlock) > $iideadlock
	Return true
EndFunc

Func FindWarSupplies()
	Local $litem
	Local $QuantityWS
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

Func TradeItemsToPartner()
	; find tradepartner and trade

	out("Found " & $CharNameTraderpartner)
	TradePlayer($tradeAgent)
	Do
		sleep(100)
	Until getdistance(-2, $tradeAgent) < 350
	sleep(2000)
	; check bag for the right items and offer them
	Local $counter = 0

	;~ $itemsInBag = GetBagItemIDByModelID(35121)
	;~ MsgBox(0, "", $itemsInBag)

	;~ For $i = 1 To $itemsInBag
	;~ 	MsgBox(0, "", $itemsInBag)
	;~ Next
	For $i = 1 To 4
		For $j = 1 To DllStructGetData(getbag($i), "Slots")
			If $counter = 7 Then ExitLoop
			$litem = getitembyslot($i, $j)
			;~ MsgBox(0, "", DllStructGetData($litem, "Id"))
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
	SubmitOffer(GetGoldCharacter())
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

Func CheckForWarSuppliesAndEctosAndGold()
	For $i = 1 To 4
		For $j = 1 To DllStructGetData(getbag($i), "Slots")
			$litem = getitembyslot($i, $j)
			If GetGoldCharacter() > 0 Then
				Return true
			EndIf
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
	If $lgold > 70000 Then
		If getmapid() <> 642 Then
			travelto(642)
		EndIf
   		BuyEctos()
	EndIf
EndFunc	

Func BuyEctos()
	Local $EctoID = 930
	Out("Normally Buying ectos, but now depositing money")
	DepositGold()
	Sleep(2000)
	;~ $MerchantEcto = GetAgentByName("Roland [Rare Material Trader]")
	;~ ChangeTarget($MerchantEcto)
	;~ Sleep(1000)
	;~ GoToNPC($MerchantEcto)
	;~ TraderRequest($EctoID)
	;~ Sleep(500 + 3 * GetPing())
	;~ For $I = 1 To 8
	;~ 	TraderRequest($EctoID)
	;~ 	Sleep(500 + 3 * GetPing())
	;~ 	TraderBuy()
	;~ 	$totalectos += 1
	;~ Next
EndFunc

Func StopRunTime()
	Global $isRunning = false
	Global $Sec2 = 0 ;Variable for Seconds
	Global $Min2 = 0 ;Variable for Minutes
	Global $Hour2 = 0 ;Variable for Hours
EndFunc

Func _purgehook()
	togglerendering()
	Sleep(Random(2000, 2500))
	togglerendering()
EndFunc

Func togglerendering()
	If $rendering Then
		disablerendering()
		$rendering = False
		Sleep(Random(1000, 3000))
		_reducememory()
		AdlibRegister("_ReduceMemory", 20000)
	Else
		AdlibUnRegister("_ReduceMemory")
		enablerendering()
		$rendering = True
	EndIf
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






