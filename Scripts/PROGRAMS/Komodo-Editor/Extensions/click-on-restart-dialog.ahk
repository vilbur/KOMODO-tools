#NoTrayIcon
#SingleInstance force

/*script will:
 *  	1) wait for dialog "restart later OR restart now" in Komodo
 *  	2) then click on "restart now" button
*/

setTitleMatchMode, 1
WinWaitActive, Komodo, , 2
if not ErrorLevel
	send, !r


;MsgBox,262144,, Test,2

ExitApp