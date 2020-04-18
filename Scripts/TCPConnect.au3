#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.0
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here
#include <GWA2.au3>
#include <GuiEdit.au3>
#include <MsgBoxConstants.au3>
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#Region ### START Koda GUI section ### Form=
Opt("GUIOnEventMode", 1)
$Form = GUICreate("Keiran Runner", 389, 595, -1, -1)
$LogBox = GUICtrlCreateEdit("", 40, 416, 305, 169)
GUICtrlSetData(-1, "")
$ButtonStart = GUICtrlCreateButton("Start", 64, 368, 251, 25)
$Label1 = GUICtrlCreateLabel("Succes Runs:", 32, 40, 76, 17)
$Label2 = GUICtrlCreateLabel("Fail Runs:", 32, 72, 51, 17)
$Label3 = GUICtrlCreateLabel("War Supplies:", 32, 104, 70, 17)
$Label4 = GUICtrlCreateLabel("Total Ecto's:", 32, 136, 63, 17)
$Label5 = GUICtrlCreateLabel("Total Time:", 32, 192, 70, 17)
$Label6 = GUICtrlCreateLabel("Last:", 32, 256, 27, 17)
$Label7 = GUICtrlCreateLabel("Average:", 32, 288, 47, 17)
$Label8 = GUICtrlCreateLabel("Best:", 32, 320, 28, 17)
$LabelSuccesRuns = GUICtrlCreateLabel("-", 200, 40, 100, 17)
$LabelFailRuns = GUICtrlCreateLabel("-", 200, 72, 100, 17)
$LabelWarSupplies = GUICtrlCreateLabel("-", 200, 104, 100, 17)
$LabelTotalEctos = GUICtrlCreateLabel("-", 200, 136, 100, 17)
$LabelTotalTime = GUICtrlCreateLabel("00:00:00", 112, 192, 100, 17)
$LabelLast = GUICtrlCreateLabel("00:00", 112, 256, 100, 17)
$LabelAverage = GUICtrlCreateLabel("00:00", 112, 288, 100, 17)
$LabelBest = GUICtrlCreateLabel("00:00", 112, 320, 100, 17)
$Label17 = GUICtrlCreateLabel("Run Time:", 32, 224, 53, 17)
$LabelRunTime = GUICtrlCreateLabel("00:00:00", 112, 224, 100, 17)
$CheckboxGraphics = GUICtrlCreateCheckbox("Disable Graphics", 32, 16, 97, 17)
$CheckboxTrade = GUICtrlCreateCheckbox("Trade", 192, 16, 97, 17)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

GUICtrlSetOnEvent($ButtonStart, "EventHandler")
GUICtrlSetOnEvent($CheckboxGraphics, "EventHandler")
GUICtrlSetOnEvent($CheckboxTrade, "EventHandler")
GUISetOnEvent($gui_event_close, "EventHandler")

Global $CharName = "Math Winning Games"
Global $fLog = FileOpen("Keiran - Runner " & $CharName & ".log", 1) ;Log file
Global $boolrun = False
Global $CharNameTraderpartner = "Math Winning Games"
Global $gwpid = -1
Global $characterName = $CmdLine[1]

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

Global $serverSocket;

StartTcp()

AdlibRegister("ListenToServer")


While 1
    Sleep(100)
WEnd

;~ While 1
;~ 	If $boolrun Then
;~ 		Main()
;~ 	EndIf
;~ 	If Not $boolrun Then
;~ 		AdlibUnRegister("TimerUpdater")
;~ 	EndIf
;~ 	sleep(100)
;~ WEnd

Func ListenToServer()
	$receivedData = TCPRecv($serverSocket, 10025)
	If $receivedData = '' Then Return
	If $receivedData = 'Close' Then 
		Exit
	EndIf
	Out($receivedData)
EndFunc

Func EventHandler()
	Switch (@GUI_CtrlId)
		Case $ButtonStart
			GUICtrlSetData($ButtonStart, "Initializing...")
			GUICtrlSetState($ButtonStart, $gui_disable)
			If initialize($CharName, True, True, True) = False Then
				MsgBox(0, "Error", "Can't find a Guild Wars client with that character name.")
				Exit
			EndIf
			$boolrun = True
			GUICtrlSetData($ButtonStart, "Bot Started")
		Case $CheckboxGraphics
		Case $CheckboxTrade
			If $TradeAfterRun = False Then
				$TradeAfterRun = True
			Else
				$TradeAfterRun = False
			EndIf
		Case $gui_event_close
			;~ TCPCloseSocket($iSocket)
			Exit
	EndSwitch
EndFunc

Func main()
	$npc = GetAgentByID(27)
	Out(getDistance($npc, -2))
	;~ Out(DllStructGetData($npc, "id"))
	If GetAgentExists(DllStructGetData($npc, "id"))  And getDistance($npc, -2) <= 2000 Then
		Out("gelukt")
	Else
		Out("Niet gelukt")
	EndIf
	Sleep(1000)
EndFunc

Func StartTcp()
    TCPStartup() ; Start the TCP service.

    ; Register OnAutoItExit to be called when the script is closed.
    OnAutoItExitRegister("OnAutoItExit")

    ; Assign Local variables the loopback IP Address and the Port.
    Local $sIPAddress = "127.0.0.1" ; This IP Address only works for testing on your own computer.
    Local $iPort = 11000 ; Port used for the connection.

    ; Assign a Local variable the socket and connect to a Listening socket with the IP Address and Port specified.
    $serverSocket = TCPConnect($sIPAddress, $iPort)

    ; If an error occurred display the error code and return False.
    If @error Then
        ; The server is probably offline/port is not opened on the server.
        Local $iError = @error
        MsgBox(BitOR($MB_SYSTEMMODAL, $MB_ICONHAND), "", "Could not connect, Error code: " & $iError)
        Return False
    Else
        Out("Connected to server")
		Sleep(1000)
		Out($characterName)
		TCPSend($serverSocket, $characterName)
		Out("Sent to server")
    EndIf

    ; Close the socket.
EndFunc   ;==>StartTcp

Func OnAutoItExit()
    TCPShutdown() ; Close the TCP service.
EndFunc   ;==>OnAutoItExit

Func Out($aString)
	FileWriteLine($fLog, @HOUR & ":" & @MIN & " - " & $aString)
	ConsoleWrite(@HOUR & ":" & @MIN & " - " & $aString & @CRLF)
	GUICtrlSetData($LogBox, GUICtrlRead($LogBox) & @HOUR & ":" & @MIN & " - " & $aString & @CRLF)
	_GUICtrlEdit_Scroll($LogBox, 4)
EndFunc   ;==>Out
