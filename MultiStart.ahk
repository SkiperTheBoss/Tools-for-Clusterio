#SingleInstance force
#Persistent
#NoEnv

run node "C:\Users\Jonathan\Desktop\Clusterio\factorioClusterio\master.js", %A_WorkingDir%\factorioClusterio

Loop, %A_WorkingDir%\factorioClusterio\instances\*, 2, 0
{
	run node "%A_WorkingDir%\factorioClusterio\client.js" start %A_LoopFileName%, %A_WorkingDir%\factorioClusterio
}
ExitApp