Dim SH, FSO, path2scansoft, scandevice, oargs
Set SH  = WScript.CreateObject("WScript.Shell")
Set FSO = CreateObject("Scripting.FileSystemObject") 

dbg    = true   ' debug: true or false
prog   = "c:\arbene\soft\scan"
path2scansoft = prog &"\NAPS2\naps2.console.exe"

if Wscript.Arguments.count > 0 Then

	Set oArgs = Wscript.Arguments
	scandevice = oArgs(0)

Else
	scandevice = "HP7740FLB"	' Naps2profil
End if

main

sub main ()

    dim tempDir, outFn, tab, lf, msg, i, ok

    tab    = chr(9)
    lf     = chr(10)
	tempDir= prog &"\temp0"
    outFn  = "scannedpages.pdf"

    if FSO.FolderExists(tempDir) then
     	FSO.DeleteFolder tempDir
    end if
	
	FSO.CreateFolder(tempDir)

	for i = 1 to 500
		ScanPage i, tempDir
		ok= MsgBox("Noch eine Seite scannen?",vbYesNo,"Scanning..")
		if ok = vbNo then exit for
	next
	ConvertToPdf tempDir, outFn

	If not dbg then 
		FSO.DeleteFolder tempDir '  clean up afterwards
	End if
end sub

sub ScanPage(pNum,pDir)

    dim fn, cmd

    fn = "page"& mid("" & (1000+pNum),2,3) &".jpg"
    cmd = path2scansoft
    cmd = cmd &" -o """& pdir &"\"& fn &""" -p "& scandevice &""""
	SH.Run cmd,4,true ' normal window type, wait
	
end sub

sub ConvertToPdf(pDir,pOutFn)

    dim cmd
	cmd = prog &"\Jpg2pdf\Jpg2pdf.exe -c ""A4"" "& pDir & "\page*.jpg "& prog &"\out\"& pOutFn
	SH.Run cmd,1,true ' normal window type, wait

end sub

