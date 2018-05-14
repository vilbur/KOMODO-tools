#NoTrayIcon
#SingleInstance force

/* Wait for dialo "restart later OR restart now"
*/

setTitleMatchMode, 1
WinWaitActive, Komodo, , 2
if not ErrorLevel
	send, !r


;MsgBox,262144,, Test,2

ExitApp